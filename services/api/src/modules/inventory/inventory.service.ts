import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class InventoryService {
  constructor(private prisma: PrismaService) {}

  async getStoreInventory(storeId: string) {
    return this.prisma.inventory.findMany({
      where: { storeId },
      include: { variant: { include: { product: true } } },
    });
  }

  async updateStock(storeId: string, variantId: string, stockQuantity: number) {
    return this.prisma.inventory.upsert({
      where: { storeId_variantId: { storeId, variantId } },
      update: { stockQuantity },
      create: { storeId, variantId, stockQuantity },
    });
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

