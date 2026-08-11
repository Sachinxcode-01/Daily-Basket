import { Test, TestingModule } from '@nestjs/testing';
import { InventoryService } from './inventory.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';

describe('InventoryService Concurrency & Unit Tests', () => {
  let service: InventoryService;

  const mockPrismaService = {
    inventory: {
      findMany: jest.fn(),
      upsert: jest.fn(),
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

  const mockEventsGateway = {
    broadcastInventoryUpdate: jest.fn(),
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
});
