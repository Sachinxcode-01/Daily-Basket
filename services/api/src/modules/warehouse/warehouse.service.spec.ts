import { Test, TestingModule } from '@nestjs/testing';
import { WarehouseService } from './warehouse.service';
import { PrismaService } from '../../database/prisma.service';

describe('WarehouseService', () => {
  let service: WarehouseService;

  const mockPrismaService = {
    warehouse: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'wh_01', name: 'Whitefield Central Hub', code: 'WH_01', capacitySqFt: 35000 },
      ]),
      create: jest.fn().mockResolvedValue({ id: 'wh_02', name: 'Peenya North Hub' }),
    },
    interLocationTransfer: {
      findMany: jest.fn().mockResolvedValue([]),
      count: jest.fn().mockResolvedValue(0),
      create: jest.fn().mockResolvedValue({ id: 'tr_01', transferNumber: 'TR-2026-001', status: 'APPROVED' }),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WarehouseService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<WarehouseService>(WarehouseService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should list dark warehouses', async () => {
    const warehouses = await service.listWarehouses();
    expect(warehouses).toBeDefined();
    expect(warehouses.length).toBeGreaterThan(0);
  });

  it('should create inter-location stock transfer', async () => {
    const tr = await service.createTransfer({
      fromType: 'WAREHOUSE',
      fromId: 'wh_01',
      toType: 'STORE',
      toId: 'store_01',
      items: [{ productId: 'p1', quantity: 50 }],
    });
    expect(tr).toBeDefined();
    expect(tr.transferNumber).toBe('TR-2026-001');
  });
});
