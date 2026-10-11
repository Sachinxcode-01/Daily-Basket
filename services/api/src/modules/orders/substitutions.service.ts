import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { InventoryService } from '../inventory/inventory.service';
import { EventsGateway } from '../events/events.gateway';
import { OrderStatus } from '@prisma/client';

export interface SubstituteCandidate {
  id: string;
  productId: string;
  productName: string;
  unitName: string;
  price: number;
  mrp: number;
  priceDiff: number;
  imageUrl?: string;
  availableStock: number;
}

@Injectable()
export class SubstitutionsService {
  private readonly logger = new Logger(SubstitutionsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly inventoryService: InventoryService,
    private readonly eventsGateway: EventsGateway,
  ) {}

  /**
   * Search available 1:1 substitute candidates in the same store and category.
   * Filters by available inventory > 0 and price proximity (within +/- 35%).
   */
  async getAvailableSubstitutes(
    storeId: string,
    variantId: string,
    limit = 5,
  ): Promise<SubstituteCandidate[]> {
    const sourceVariant = await this.prisma.productVariant.findUnique({
      where: { id: variantId },
      include: {
        product: {
          include: { category: true },
        },
      },
    });

    if (!sourceVariant) {
      return [];
    }

    const categoryId = sourceVariant.product.categoryId;
    const basePrice = sourceVariant.price;

    // Fetch candidate variants in the same category & store
    const candidates = await this.prisma.productVariant.findMany({
      where: {
        id: { not: variantId },
        isAvailable: true,
        product: {
          storeId,
          categoryId,
        },
      },
      include: {
        product: true,
        inventories: {
          where: { storeId },
        },
      },
      take: 20,
    });

    const results: SubstituteCandidate[] = [];

    for (const cand of candidates) {
      const inv = cand.inventories[0];
      const availableStock = inv ? Math.max(0, inv.stockQuantity - inv.reservedQuantity) : 0;
      if (availableStock <= 0) continue;

      const priceDiff = +(cand.price - basePrice).toFixed(2);
      const pricePercentDiff = Math.abs(priceDiff) / (basePrice || 1);

      // Within 35% price range
      if (pricePercentDiff <= 0.35) {
        results.push({
          id: cand.id,
          productId: cand.product.id,
          productName: cand.product.name,
          unitName: cand.unitName,
          price: cand.price,
          mrp: cand.mrp,
          priceDiff,
          imageUrl: cand.product.images?.[0],
          availableStock,
        });
      }
    }

    // Sort by smallest price difference, then stock quantity descending
    results.sort((a, b) => {
      const diffA = Math.abs(a.priceDiff);
      const diffB = Math.abs(b.priceDiff);
      if (diffA !== diffB) return diffA - diffB;
      return b.availableStock - a.availableStock;
    });

    return results.slice(0, limit);
  }

  /**
   * Mark an item missing or damaged on physical shelf during dark store picking.
   * - Releases reserved inventory immediately for this order item.
   * - Zeros/reduces phantom inventory on the shelf to prevent subsequent orders.
   * - Detects sensitive categories (baby food, medications, allergens) where auto-substitution is barred.
   * - Queries smart substitutes and broadcasts real-time alert to customer and admin.
   */
  async markItemMissing(
    orderId: string,
    orderItemId: string,
    reason = 'Item missing or damaged during picking',
  ) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: {
          include: {
            variant: {
              include: {
                product: {
                  include: { category: true },
                },
              },
            },
          },
        },
      },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    const orderItem = order.items.find((item) => item.id === orderItemId);
    if (!orderItem) {
      throw new NotFoundException(`Order item ${orderItemId} not found in order ${orderId}`);
    }

    // State validation
    if (order.status === OrderStatus.DELIVERED || order.status === OrderStatus.CANCELLED) {
      throw new BadRequestException(`Cannot report missing item for order in ${order.status} state.`);
    }

    // 1. Release reserved inventory for this missing item
    await this.inventoryService.releaseStockAtomic(order.storeId, orderItem.variantId, orderItem.quantity);

    // 2. Zero / reduce physical shelf stock to prevent subsequent phantom sales (Blinkit Invariant)
    try {
      await this.prisma.inventory.updateMany({
        where: {
          storeId: order.storeId,
          variantId: orderItem.variantId,
        },
        data: {
          stockQuantity: 0,
        },
      });
      this.eventsGateway.broadcastInventoryUpdate(orderItem.variantId, 0, false);
    } catch (err) {
      this.logger.warn(`Could not zero inventory for variant ${orderItem.variantId}: ${err.message}`);
    }

    // 3. Sensitive Category Guardrail
    const categoryName = orderItem.variant?.product?.category?.name || '';
    const categorySlug = orderItem.variant?.product?.category?.slug || '';
    const isSensitiveCategory = /baby|infant|formula|pharma|medicine|drug|allergen|medical|health/i.test(
      `${categoryName} ${categorySlug}`,
    );

    // 4. Query substitute candidates
    const substitutes = isSensitiveCategory
      ? []
      : await this.getAvailableSubstitutes(order.storeId, orderItem.variantId, 4);

    // 5. Broadcast real-time substitution alert
    this.eventsGateway.broadcastItemMissing(orderId, order.userId, orderItem, substitutes);

    return {
      success: true,
      orderId,
      orderItemId,
      missingItem: {
        id: orderItem.id,
        productName: orderItem.productName,
        variantId: orderItem.variantId,
        quantity: orderItem.quantity,
        totalPrice: orderItem.totalPrice,
      },
      reason,
      isSensitiveCategory,
      substitutes,
    };
  }

  /**
   * Accept a suggested substitute item.
   * - Atomically reserves substitute variant stock.
   * - Updates order line item.
   * - If substitute is cheaper, credits delta directly to customer wallet.
   * - If substitute is more expensive, difference is waived via Blinkit price protection.
   * - Broadcasts substitute acceptance event.
   */
  async acceptSubstitute(
    orderId: string,
    orderItemId: string,
    substituteVariantId: string,
    userId: string,
  ) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: { items: true },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    if (order.userId !== userId) {
      throw new BadRequestException('You do not have permission to modify this order.');
    }

    if (order.status === OrderStatus.DELIVERED || order.status === OrderStatus.CANCELLED) {
      throw new BadRequestException(`Cannot substitute item for order in ${order.status} state.`);
    }

    const orderItem = order.items.find((item) => item.id === orderItemId);
    if (!orderItem) {
      throw new NotFoundException(`Order item ${orderItemId} not found in order ${orderId}`);
    }

    // Fetch substitute variant & verify availability
    const substituteVariant = await this.prisma.productVariant.findUnique({
      where: { id: substituteVariantId },
      include: {
        product: true,
        inventories: { where: { storeId: order.storeId } },
      },
    });

    if (!substituteVariant) {
      throw new NotFoundException(`Substitute variant ${substituteVariantId} not found`);
    }

    const inv = substituteVariant.inventories[0];
    const availableStock = inv ? Math.max(0, inv.stockQuantity - inv.reservedQuantity) : 0;
    if (availableStock < orderItem.quantity) {
      throw new BadRequestException(
        `Substitute product is out of stock (only ${availableStock} available, needed ${orderItem.quantity}).`,
      );
    }

    // Atomically reserve substitute stock
    const reserved = await this.inventoryService.reserveStockAtomic(
      order.storeId,
      substituteVariant.id,
      orderItem.quantity,
    );
    if (!reserved) {
      throw new BadRequestException('Could not reserve stock for the selected substitute. Please pick another.');
    }

    const oldItemTotal = orderItem.totalPrice;
    const substituteUnitPrice = substituteVariant.price;
    const substituteTotal = +(substituteUnitPrice * orderItem.quantity).toFixed(2);
    const delta = +(substituteTotal - oldItemTotal).toFixed(2);

    let refundCredited = 0;

    // Line-level price reconciliation:
    // If substitute is cheaper, credit difference to wallet
    if (delta < 0) {
      refundCredited = Math.abs(delta);
      const wallet = await this.prisma.wallet.upsert({
        where: { userId: order.userId },
        update: { balance: { increment: refundCredited } },
        create: { userId: order.userId, balance: refundCredited },
      });

      const tx = await this.prisma.walletTransaction.create({
        data: {
          walletId: wallet.id,
          amount: refundCredited,
          type: 'CREDIT',
          description: `Refund: Price difference for substitute item on Order #${order.orderNumber}`,
        },
      });

      this.eventsGateway.broadcastWalletUpdated(order.userId, wallet.balance, tx);
    }

    // Quick-commerce Price Protection: If substitute is more expensive, customer is charged old price
    const finalItemTotal = delta < 0 ? substituteTotal : oldItemTotal;

    // Update order item in database
    const updatedItem = await this.prisma.orderItem.update({
      where: { id: orderItemId },
      data: {
        variantId: substituteVariant.id,
        productName: substituteVariant.product.name,
        unitName: substituteVariant.unitName,
        price: substituteUnitPrice,
        totalPrice: finalItemTotal,
      },
    });

    // Update order totals if cheaper
    let updatedOrder = order;
    if (delta < 0) {
      updatedOrder = await this.prisma.order.update({
        where: { id: orderId },
        data: {
          subtotal: Math.max(0, +(order.subtotal + delta).toFixed(2)),
          totalAmount: Math.max(0, +(order.totalAmount + delta).toFixed(2)),
        },
        include: { items: true, address: true },
      });
    }

    // Emit real-time substitute accepted broadcast
    this.eventsGateway.broadcastSubstituteAccepted(orderId, order.userId, updatedItem, delta);

    return {
      success: true,
      message:
        refundCredited > 0
          ? `Substitute accepted! ₹${refundCredited} credited back to your wallet.`
          : 'Substitute accepted with Price Protection (no extra charges)!',
      refundCredited,
      priceProtectionAbsorbed: delta > 0 ? delta : 0,
      updatedItem,
      order: updatedOrder,
    };
  }

  /**
   * Decline substitute or remove item when out-of-stock.
   * - Issues 100% line-level refund to customer wallet.
   * - Removes line item from order.
   * - If no items remain, safely cancels order and refunds any delivery/service fees.
   * - Broadcasts item removed & refund issued event.
   */
  async removeItemAndRefund(
    orderId: string,
    orderItemId: string,
    userId: string,
    reason = 'Substitute declined by customer',
  ) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: { items: true },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    if (order.userId !== userId) {
      throw new BadRequestException('You do not have permission to modify this order.');
    }

    if (order.status === OrderStatus.DELIVERED || order.status === OrderStatus.CANCELLED) {
      throw new BadRequestException(`Cannot remove item from order in ${order.status} state.`);
    }

    const orderItem = order.items.find((item) => item.id === orderItemId);
    if (!orderItem) {
      throw new NotFoundException(`Order item ${orderItemId} not found in order ${orderId}`);
    }

    // Release any lingering reservation
    await this.inventoryService.releaseStockAtomic(order.storeId, orderItem.variantId, orderItem.quantity);

    // Full line-level refund
    const refundAmount = orderItem.totalPrice;
    const wallet = await this.prisma.wallet.upsert({
      where: { userId: order.userId },
      update: { balance: { increment: refundAmount } },
      create: { userId: order.userId, balance: refundAmount },
    });

    const tx = await this.prisma.walletTransaction.create({
      data: {
        walletId: wallet.id,
        amount: refundAmount,
        type: 'CREDIT',
        description: `Full refund for out-of-stock item "${orderItem.productName}" on Order #${order.orderNumber}`,
      },
    });

    this.eventsGateway.broadcastWalletUpdated(order.userId, wallet.balance, tx);

    // Delete item from order
    await this.prisma.orderItem.delete({
      where: { id: orderItemId },
    });

    const remainingItems = order.items.filter((item) => item.id !== orderItemId);

    let updatedOrder;
    if (remainingItems.length === 0) {
      // Entire basket emptied -> Cancel order and refund remaining delivery fee if any
      const remainingFee = order.deliveryFee;
      if (remainingFee > 0) {
        await this.prisma.wallet.update({
          where: { id: wallet.id },
          data: { balance: { increment: remainingFee } },
        });
        await this.prisma.walletTransaction.create({
          data: {
            walletId: wallet.id,
            amount: remainingFee,
            type: 'CREDIT',
            description: `Delivery fee refund for empty order #${order.orderNumber}`,
          },
        });
      }

      updatedOrder = await this.prisma.order.update({
        where: { id: orderId },
        data: {
          status: OrderStatus.CANCELLED,
          subtotal: 0,
          totalAmount: 0,
        },
        include: { items: true, address: true },
      });

      this.eventsGateway.broadcastOrderCancelled(orderId, order.userId, 'All items were out of stock');
    } else {
      updatedOrder = await this.prisma.order.update({
        where: { id: orderId },
        data: {
          subtotal: Math.max(0, +(order.subtotal - refundAmount).toFixed(2)),
          totalAmount: Math.max(0, +(order.totalAmount - refundAmount).toFixed(2)),
        },
        include: { items: true, address: true },
      });
    }

    this.eventsGateway.broadcastItemRemovedAndRefunded(orderId, order.userId, orderItemId, refundAmount);

    return {
      success: true,
      message: `Item removed and full refund of ₹${refundAmount} credited to your wallet.`,
      refundedAmount: refundAmount,
      reason,
      order: updatedOrder,
    };
  }
}
