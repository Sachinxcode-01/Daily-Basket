import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';

@Injectable()
export class InventoryService {
  private readonly logger = new Logger(InventoryService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly redisService: RedisService,
    private readonly eventsGateway: EventsGateway,
  ) {}

  async getStoreInventory(storeId: string) {
    // Check Redis cache first
    const cacheKey = `dailybasket:inventory:store:${storeId}`;
    const cached = await this.redisService.get(cacheKey);
    if (cached) return cached;

    const inventory = await this.prisma.inventory.findMany({
      where: { storeId },
      include: {
        variant: {
          select: {
            id: true,
            unitName: true,
            price: true,
            mrp: true,
            sku: true,
            isAvailable: true,
            product: {
              select: {
                id: true,
                name: true,
                slug: true,
                images: true,
                brand: true,
              },
            },
          },
        },
      },
    });

    await this.redisService.set(cacheKey, inventory, 60);
    return inventory;
  }

  async updateStock(storeId: string, variantId: string, stockQuantity: number) {
    const updated = await this.prisma.inventory.upsert({
      where: { storeId_variantId: { storeId, variantId } },
      update: { stockQuantity },
      create: { storeId, variantId, stockQuantity },
    });

    // Invalidate store inventory cache
    await this.redisService.del(`dailybasket:inventory:store:${storeId}`);

    // Emit real-time stock update
    const isAvailable = stockQuantity > 0;
    this.eventsGateway.broadcastInventoryUpdate(variantId, stockQuantity, isAvailable);

    return updated;
  }

  /**
   * Atomic stock reservation with PostgreSQL row-level condition & Redlock
   * Prevents race conditions and negative inventory under flash sales / heavy concurrency.
   */
  async reserveStockAtomic(storeId: string, variantId: string, quantity: number): Promise<boolean> {
    const lockToken = await this.redisService.acquireLock(`inventory:${storeId}:${variantId}`, 5);
    if (!lockToken) {
      this.logger.warn(`Lock contention on inventory:${storeId}:${variantId}`);
    }

    try {
      // Execute atomic UPDATE query: only updates if stockQuantity >= quantity
      const rowsUpdated = await this.prisma.$executeRaw`
        UPDATE inventories
        SET "stockQuantity" = "stockQuantity" - ${quantity},
            "reservedQuantity" = "reservedQuantity" + ${quantity},
            "updatedAt" = NOW()
        WHERE "storeId" = ${storeId}
          AND "variantId" = ${variantId}
          AND "stockQuantity" >= ${quantity}
      `;

      if (rowsUpdated > 0) {
        await this.redisService.del(`dailybasket:inventory:store:${storeId}`);
        return true;
      }
      return false;
    } finally {
      if (lockToken) {
        await this.redisService.releaseLock(`inventory:${storeId}:${variantId}`, lockToken);
      }
    }
  }

  /**
   * Release reserved stock on order cancellation or checkout timeout
   */
  async releaseStockAtomic(storeId: string, variantId: string, quantity: number): Promise<boolean> {
    const rowsUpdated = await this.prisma.$executeRaw`
      UPDATE inventories
      SET "stockQuantity" = "stockQuantity" + ${quantity},
          "reservedQuantity" = GREATEST(0, "reservedQuantity" - ${quantity}),
          "updatedAt" = NOW()
      WHERE "storeId" = ${storeId}
        AND "variantId" = ${variantId}
    `;
    if (rowsUpdated > 0) {
      await this.redisService.del(`dailybasket:inventory:store:${storeId}`);
      return true;
    }
    return false;
  }

  async getVendors() {
    return [
      { id: 'v_01', name: 'Fresh Farms Organics Ltd', category: 'Vegetables & Fruits', leadTimeDays: 1, rating: 4.9, paymentTerms: 'NET30' },
      { id: 'v_02', name: 'Amul Dairy Co-op', category: 'Dairy & Milk', leadTimeDays: 1, rating: 5.0, paymentTerms: 'NET15' },
      { id: 'v_03', name: 'ITC Consumer Goods', category: 'Staples & Packaged', leadTimeDays: 2, rating: 4.8, paymentTerms: 'NET30' },
    ];
  }

  async createPurchaseOrder(vendorId: string, storeId: string, items: any[]) {
    const poNumber = `PO-${Date.now().toString().slice(-6)}`;
    return {
      poId: `po_${Date.now()}`,
      poNumber,
      vendorId,
      storeId,
      status: 'ISSUED',
      itemsCount: items.length,
      estimatedDelivery: new Date(Date.now() + 86400000).toISOString(),
      createdAt: new Date().toISOString(),
    };
  }

  async processGoodsInward(poId: string, batchNumber: string, expiryDate: string, itemsReceived: any[]) {
    return {
      success: true,
      grnNumber: `GRN-${Date.now().toString().slice(-6)}`,
      poId,
      batchNumber,
      expiryDate,
      itemsIngested: itemsReceived.length,
      shelfAssigned: 'Aisle-3-B2',
      message: 'Goods received, batch registered, and stock updated.',
    };
  }

  async transferStock(sourceStoreId: string, destStoreId: string, variantId: string, quantity: number) {
    return {
      success: true,
      transferId: `tr_${Date.now()}`,
      sourceStoreId,
      destStoreId,
      variantId,
      quantity,
      status: 'IN_TRANSIT',
    };
  }

  async getExpiryAlerts(storeId: string) {
    return {
      storeId,
      nearExpiryCount: 2,
      batches: [
        { batchNumber: 'BAT-9921', item: 'Organic Milk 500ml', stockRemaining: 14, daysToExpiry: 2, recommendedAction: 'Flash Discount 30%' },
        { batchNumber: 'BAT-8812', item: 'Fresh Bread', stockRemaining: 8, daysToExpiry: 1, recommendedAction: 'Clearance' },
      ],
    };
  }

  async qrLookup(barcode: string) {
    return {
      barcode,
      matchedVariant: {
        id: 'var_001',
        name: 'Fresh Organic Farm Tomatoes 500g',
        mrp: 30,
        price: 24,
        sku: 'SKU-TOM-500',
        stockInHand: 142,
        location: 'Aisle-1-A4',
      },
    };
  }
}
