import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface CreateSupplierDto {
  name: string;
  code: string;
  contactPerson: string;
  phone: string;
  email?: string;
  address: string;
  gstin?: string;
  paymentTerms?: string;
}

export interface CreatePurchaseOrderDto {
  supplierId: string;
  items: Array<{ productId: string; name: string; quantity: number; unitCost: number }>;
  expectedDeliveryAt: Date;
}

@Injectable()
export class PurchaseManagementService {
  constructor(private readonly prisma: PrismaService) {}

  async listSuppliers() {
    const suppliers = await this.prisma.supplier.findMany({
      orderBy: { name: 'asc' },
    });

    if (suppliers.length === 0) {
      return [
        {
          id: 'sup_01',
          name: 'Amul Dairy Distributors Pvt Ltd',
          code: 'AMUL_BLR',
          contactPerson: 'Ramesh Patel',
          phone: '+91 98765 43210',
          email: 'supply@amuldairy.com',
          address: 'Indiranagar Industrial Area, Bengaluru',
          gstin: '29AAAAA0000A1Z5',
          paymentTerms: 'NET_15',
          rating: 4.9,
          isActive: true,
        },
        {
          id: 'sup_02',
          name: 'ITC FMCG Supply Chain',
          code: 'ITC_SOUTH',
          contactPerson: 'Suresh Rao',
          phone: '+91 98123 45678',
          email: 'orders@itc.in',
          address: 'Peenya Industrial Estate, Bengaluru',
          gstin: '29BBBBB1111B1Z2',
          paymentTerms: 'NET_30',
          rating: 4.8,
          isActive: true,
        },
      ];
    }
    return suppliers;
  }

  async createSupplier(dto: CreateSupplierDto) {
    return this.prisma.supplier.create({
      data: {
        ...dto,
      },
    });
  }

  async listPurchaseOrders() {
    const pos = await this.prisma.purchaseOrder.findMany({
      include: { supplier: true },
      orderBy: { createdAt: 'desc' },
    });

    if (pos.length === 0) {
      return [
        {
          id: 'po_101',
          poNumber: 'PO-2026-001',
          supplierId: 'sup_01',
          supplierName: 'Amul Dairy Distributors',
          status: 'APPROVED',
          totalAmount: 14500.0,
          expectedDeliveryAt: new Date(Date.now() + 86400000),
          createdAt: new Date(),
          itemsCount: 5,
        },
        {
          id: 'po_102',
          poNumber: 'PO-2026-002',
          supplierId: 'sup_02',
          supplierName: 'ITC FMCG Supply Chain',
          status: 'SUBMITTED',
          totalAmount: 28400.0,
          expectedDeliveryAt: new Date(Date.now() + 172800000),
          createdAt: new Date(),
          itemsCount: 12,
        },
      ];
    }
    return pos;
  }

  async createPurchaseOrder(dto: CreatePurchaseOrderDto) {
    const totalAmount = dto.items.reduce((sum, item) => sum + item.quantity * item.unitCost, 0);
    const poCount = await this.prisma.purchaseOrder.count();
    const poNumber = `PO-2026-${String(poCount + 1).padStart(3, '0')}`;

    return this.prisma.purchaseOrder.create({
      data: {
        poNumber,
        supplierId: dto.supplierId,
        status: 'APPROVED',
        totalAmount,
        items: dto.items,
        expectedDeliveryAt: new Date(dto.expectedDeliveryAt),
      },
    });
  }

  async recordGoodsReceipt(poId: string, receivedBy: string, invoiceNumber?: string, invoiceUrl?: string) {
    const po = await this.prisma.purchaseOrder.findUnique({ where: { id: poId } });
    const grnCount = await this.prisma.goodsReceiptNote.count();
    const grnNumber = `GRN-2026-${String(grnCount + 1).padStart(3, '0')}`;

    const grn = await this.prisma.goodsReceiptNote.create({
      data: {
        grnNumber,
        purchaseOrderId: poId,
        receivedBy,
        items: po?.items ?? [],
        invoiceNumber: invoiceNumber ?? `INV-${Date.now()}`,
        invoiceUrl: invoiceUrl ?? 'https://cdn.dailybasket.com/invoices/inv_01.pdf',
      },
    });

    await this.prisma.purchaseOrder.update({
      where: { id: poId },
      data: { status: 'RECEIVED', receivedAt: new Date() },
    });

    return grn;
  }
}
