import { Test, TestingModule } from '@nestjs/testing';
import { PurchaseManagementService } from './purchase-management.service';
import { PrismaService } from '../../database/prisma.service';

describe('PurchaseManagementService', () => {
  let service: PurchaseManagementService;

  const mockPrismaService = {
    supplier: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'sup_01', name: 'Amul Dairy', code: 'AMUL_01', rating: 4.9 },
      ]),
      create: jest.fn().mockResolvedValue({ id: 'sup_02', name: 'ITC FMCG' }),
    },
    purchaseOrder: {
      findMany: jest.fn().mockResolvedValue([]),
      count: jest.fn().mockResolvedValue(0),
      findUnique: jest.fn().mockResolvedValue({
        id: 'po_01',
        items: [{ productId: 'p1', quantity: 10, unitCost: 40 }],
      }),
      create: jest.fn().mockResolvedValue({ id: 'po_01', poNumber: 'PO-2026-001', status: 'APPROVED' }),
      update: jest.fn().mockResolvedValue({ id: 'po_01', status: 'RECEIVED' }),
    },
    goodsReceiptNote: {
      count: jest.fn().mockResolvedValue(0),
      create: jest.fn().mockResolvedValue({ id: 'grn_01', grnNumber: 'GRN-2026-001' }),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PurchaseManagementService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<PurchaseManagementService>(PurchaseManagementService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should list suppliers', async () => {
    const suppliers = await service.listSuppliers();
    expect(suppliers).toBeDefined();
    expect(suppliers.length).toBeGreaterThan(0);
  });

  it('should create purchase order', async () => {
    const po = await service.createPurchaseOrder({
      supplierId: 'sup_01',
      items: [{ productId: 'p1', name: 'Milk 1L', quantity: 10, unitCost: 40 }],
      expectedDeliveryAt: new Date(),
    });
    expect(po).toBeDefined();
    expect(po.poNumber).toBe('PO-2026-001');
  });
});
