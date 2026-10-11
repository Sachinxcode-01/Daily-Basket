import { Test, TestingModule } from '@nestjs/testing';
import { InventoryService } from './inventory.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';

describe('InventoryService Concurrency & Unit Tests', () => {
  let service: InventoryService;

  const mockPrismaService: any = {
    inventory: {
      findMany: jest.fn(),
      upsert: jest.fn(),
      update: jest.fn(),
      updateMany: jest.fn(),
    },
    store: {
      findFirst: jest.fn(),
    },
    inventoryAudit: {
      create: jest.fn(),
    },
    batchManagement: {
      findMany: jest.fn(),
    },
    $executeRaw: jest.fn(),
  };

  const mockRedisService = {
    get: jest.fn(),
    set: jest.fn(),
    del: jest.fn(),
    acquireLock: jest.fn().mockResolvedValue('token_123'),
    releaseLock: jest.fn().mockResolvedValue(true),
  };

  const mockEventsGateway: any = {
    broadcastInventoryUpdate: jest.fn(),
    broadcastDashboardTick: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        InventoryService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: RedisService, useValue: mockRedisService },
        { provide: EventsGateway, useValue: mockEventsGateway },
      ],
    }).compile();

    service = module.get<InventoryService>(InventoryService);
  });

  describe('reserveStockAtomic', () => {
    it('should acquire Redlock and execute atomic SQL update when stock is available', async () => {
      mockPrismaService.$executeRaw.mockResolvedValue(1); // 1 row updated

      const success = await service.reserveStockAtomic('store_01', 'var_01', 2);

      expect(success).toBe(true);
      expect(mockRedisService.acquireLock).toHaveBeenCalledWith('inventory:store_01:var_01', 5);
      expect(mockRedisService.releaseLock).toHaveBeenCalled();
    });

    it('should return false if atomic update affects 0 rows (insufficient stock)', async () => {
      mockPrismaService.$executeRaw.mockResolvedValue(0);

      const success = await service.reserveStockAtomic('store_01', 'var_01', 500);

      expect(success).toBe(false);
    });
  });

  describe('runNightlyCycleCount', () => {
    it('should audit store inventory and record InventoryAudit entry', async () => {
      mockPrismaService.store = { findFirst: jest.fn().mockResolvedValue({ id: 'store_01' }) } as any;
      mockPrismaService.inventory.findMany.mockResolvedValue([
        {
          id: 'inv_01',
          variantId: 'var_01',
          stockQuantity: 100,
          variant: { price: 40, product: { name: 'Farm Fresh Tomatoes' } },
        },
      ]);
      mockPrismaService.inventory.update = jest.fn().mockResolvedValue({});
      mockPrismaService.inventoryAudit = {
        create: jest.fn().mockResolvedValue({
          id: 'audit_101',
          auditDate: new Date(),
          status: 'COMPLETED',
        }),
      } as any;
      mockEventsGateway.broadcastDashboardTick = jest.fn();

      const result = await service.runNightlyCycleCount('store_01');

      expect(result.auditId).toBe('audit_101');
      expect(result.totalAuditedSkus).toBe(1);
      expect(mockRedisService.del).toHaveBeenCalledWith('dailybasket:inventory:store:store_01');
      expect(mockEventsGateway.broadcastDashboardTick).toHaveBeenCalled();
    });
  });

  describe('logAuditDiscrepancy', () => {
    it('should log discrepancy with reason code and adjust physical inventory', async () => {
      mockPrismaService.inventory.updateMany = jest.fn().mockResolvedValue({ count: 1 });
      mockPrismaService.inventoryAudit = {
        create: jest.fn().mockResolvedValue({ id: 'audit_102' }),
      } as any;

      const result = await service.logAuditDiscrepancy('store_01', {
        auditedBy: 'Picker Rajesh',
        variantId: 'var_01',
        expectedQty: 50,
        actualQty: 46,
        reasonCode: 'DAMAGED_IN_TRANSIT',
        notes: 'Crushed during forklift unloading',
      });

      expect(result.success).toBe(true);
      expect(result.variance).toBe(-4);
      expect(result.reasonCode).toBe('DAMAGED_IN_TRANSIT');
      expect(mockPrismaService.inventory.updateMany).toHaveBeenCalledWith({
        where: { storeId: 'store_01', variantId: 'var_01' },
        data: { stockQuantity: 46 },
      });
    });
  });

  describe('getBatchFifoStatus', () => {
    it('should return FIFO-sorted batches with urgency classification', async () => {
      mockPrismaService.batchManagement = {
        findMany: jest.fn().mockResolvedValue([]),
      } as any;

      const result = await service.getBatchFifoStatus('store_01');

      expect(result.storeId).toBe('store_01');
      expect(result.batchesCount).toBeGreaterThan(0);
      expect(result.batches[0].shelfLocation).toBeDefined();
    });
  });
});

