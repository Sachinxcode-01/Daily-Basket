import { Test, TestingModule } from '@nestjs/testing';
import { StoreOperationsService } from './store-operations.service';
import { PrismaService } from '../../database/prisma.service';

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
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StoreOperationsService,
        { provide: PrismaService, useValue: mockPrismaService },
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
});
