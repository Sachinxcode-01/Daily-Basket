import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { EventsGateway } from '../events/events.gateway';

export interface AddToCartDto {
  variantId: string;
  productName: string;
  unitName: string;
  price: number;
  quantity?: number;
}

@Injectable()
export class CartService {
  private readonly logger = new Logger(CartService.name);

  constructor(
    private prisma: PrismaService,
    private eventsGateway: EventsGateway,
  ) {}

  async getCart(userId: string) {
    let cart = await this.prisma.cart.findUnique({
      where: { userId },
      include: {
        items: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });

    if (!cart) {
      cart = await this.prisma.cart.create({
        data: { userId },
        include: { items: true },
      });
    }

    const activeItems = cart.items.filter((i) => !i.isSavedForLater);
    const savedItems = cart.items.filter((i) => i.isSavedForLater);

    // Backend single source of truth calculations
    let itemTotal = 0;
    let mrpTotal = 0;
    let quantityTotal = 0;

    for (const item of activeItems) {
      itemTotal += item.price * item.quantity;
      mrpTotal += (item.price * 1.15) * item.quantity; // Estimated MRP
      quantityTotal += item.quantity;
    }

    itemTotal = +itemTotal.toFixed(2);
    mrpTotal = +mrpTotal.toFixed(2);
    const productDiscounts = +(mrpTotal - itemTotal).toFixed(2);

    const platformFee = activeItems.length > 0 ? 5 : 0;
    const packagingCharges = activeItems.length > 0 ? 10 : 0;
    const deliveryFee = itemTotal >= 149 || activeItems.length === 0 ? 0 : 25;
    const taxGst = +(itemTotal * 0.05).toFixed(2); // 5% GST

    const grandTotal = activeItems.length > 0
      ? +(itemTotal + platformFee + packagingCharges + deliveryFee + taxGst).toFixed(2)
      : 0;
    const totalSavings = productDiscounts;

    const cartPayload = {
      id: cart.id,
      userId: cart.userId,
      activeItems,
      savedItems,
      summary: {
        itemTotal,
        mrpTotal,
        quantityTotal,
        productDiscounts,
        platformFee,
        packagingCharges,
        deliveryFee,
        taxGst,
        grandTotal,
        totalSavings,
      },
    };

    return cartPayload;
  }

  async addItem(userId: string, dto: AddToCartDto) {
    const quantity = dto.quantity && dto.quantity > 0 ? dto.quantity : 1;

    if (quantity > 10) {
      throw new BadRequestException('Maximum purchase limit per item is 10 units.');
    }

    let cart = await this.prisma.cart.findUnique({
      where: { userId },
    });

    if (!cart) {
      cart = await this.prisma.cart.create({
        data: { userId },
      });
    }

    const existingItem = await this.prisma.cartItem.findFirst({
      where: { cartId: cart.id, variantId: dto.variantId },
    });

    if (existingItem) {
      const newQty = existingItem.quantity + quantity;
      if (newQty > 10) {
        throw new BadRequestException('Maximum purchase limit per item is 10 units.');
      }
      await this.prisma.cartItem.update({
        where: { id: existingItem.id },
        data: { quantity: newQty, isSavedForLater: false },
      });
    } else {
      await this.prisma.cartItem.create({
        data: {
          cartId: cart.id,
          variantId: dto.variantId,
          productName: dto.productName,
          unitName: dto.unitName,
          price: dto.price,
          quantity,
        },
      });
    }

    const updatedCart = await this.getCart(userId);
    this.eventsGateway.server?.to(`user_${userId}`).emit('cart_updated', updatedCart);
    return updatedCart;
  }

  async updateQuantity(userId: string, itemId: string, quantity: number) {
    const item = await this.prisma.cartItem.findUnique({
      where: { id: itemId },
    });

    if (!item) {
      throw new NotFoundException('Cart item not found');
    }

    if (quantity <= 0) {
      await this.prisma.cartItem.delete({ where: { id: itemId } });
    } else {
      if (quantity > 10) {
        throw new BadRequestException('Maximum purchase limit per item is 10 units.');
      }
      await this.prisma.cartItem.update({
        where: { id: itemId },
        data: { quantity },
      });
    }

    const updatedCart = await this.getCart(userId);
    this.eventsGateway.server?.to(`user_${userId}`).emit('cart_updated', updatedCart);
    return updatedCart;
  }

  async removeItem(userId: string, itemId: string) {
    await this.prisma.cartItem.deleteMany({
      where: { id: itemId },
    });

    const updatedCart = await this.getCart(userId);
    this.eventsGateway.server?.to(`user_${userId}`).emit('cart_updated', updatedCart);
    return updatedCart;
  }

  async toggleSaveForLater(userId: string, itemId: string, isSavedForLater: boolean) {
    await this.prisma.cartItem.update({
      where: { id: itemId },
      data: { isSavedForLater },
    });

    const updatedCart = await this.getCart(userId);
    this.eventsGateway.server?.to(`user_${userId}`).emit('cart_updated', updatedCart);
    return updatedCart;
  }

  async mergeGuestCart(userId: string, guestItems: AddToCartDto[]) {
    for (const item of guestItems) {
      await this.addItem(userId, item);
    }
    return this.getCart(userId);
  }

  async clearCart(userId: string) {
    const cart = await this.prisma.cart.findUnique({ where: { userId } });
    if (cart) {
      await this.prisma.cartItem.deleteMany({ where: { cartId: cart.id } });
    }
    const emptyCart = await this.getCart(userId);
    this.eventsGateway.server?.to(`user_${userId}`).emit('cart_updated', emptyCart);
    return emptyCart;
  }
}
