import { Test, TestingModule } from '@nestjs/testing';
import { StoreOperationsService } from './store-operations.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';

describe('StoreOperationsService', () => {
  let service: StoreOperationsService;

  const mockPrismaService = {
    store: {
      findFirst: jest.fn().mockResolvedValue({
        id: 'store_01',
        name: 'Daily Basket Main Kirana',
        isOpen: true,
        address: 'Indiranagar 100ft Rd',
      }),
    },
    storeSettings: {
      findUnique: jest.fn().mockResolvedValue({
        isOpen: true,
        businessHours: { open: '07:00', close: '22:00' },
        deliveryRadiusKm: 5.0,
        minOrderValue: 149.0,
      }),
      upsert: jest.fn().mockResolvedValue({
        isOpen: false,
        storeId: 'store_01',
      }),
    },
    order: {
      count: jest.fn().mockResolvedValue(8),
    },
  };

  const mockRedisService = {
    get: jest.fn().mockResolvedValue(null),
    set: jest.fn().mockResolvedValue('OK'),
  };

  const mockEventsGateway = {
    server: {
      emit: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StoreOperationsService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: RedisService, useValue: mockRedisService },
        { provide: EventsGateway, useValue: mockEventsGateway },
      ],
    }).compile();

    service = module.get<StoreOperationsService>(StoreOperationsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should return store status & business hours', async () => {
    const status = await service.getStoreStatus('store_01');
    expect(status).toBeDefined();
    expect(status.isOpen).toBe(true);
    expect(status.deliveryRadiusKm).toBe(5.0);
  });

  it('should toggle store open/close status', async () => {
    const result = await service.toggleStoreStatus('store_01', false);
    expect(result).toBeDefined();
    expect(result.isOpen).toBe(false);
  });

  it('should toggle rain mode and persist to Redis', async () => {
    const result = await service.toggleRainMode('store_01', true);
    expect(result.isRainMode).toBe(true);
    expect(mockRedisService.set).toHaveBeenCalledWith('dailybasket:store:store_01:rain_mode', 'true', 86400);
  });

  it('should adjust promise buffer in Redis', async () => {
    const result = await service.adjustPromiseBuffer('store_01', 5);
    expect(result.bufferMins).toBe(5);
    expect(mockRedisService.set).toHaveBeenCalledWith('dailybasket:store:store_01:promise_buffer', '5', 86400);
  });

  it('should toggle soft-close and persist to Redis', async () => {
    const result = await service.toggleSoftClose('store_01', true, 'Overloaded queue');
    expect(result.isSoftClosed).toBe(true);
    expect(mockRedisService.set).toHaveBeenCalledWith('dailybasket:store:store_01:soft_closed', 'true', 86400);
  });
});
