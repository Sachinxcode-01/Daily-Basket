import { Test, TestingModule } from '@nestjs/testing';
import { MultiStoreService } from './multi-store.service';
import { PrismaService } from '../../database/prisma.service';

describe('MultiStoreService', () => {
  let service: MultiStoreService;

  const mockPrismaService = {
    store: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'store_01', name: 'Indiranagar Main', code: 'DB_01', city: 'Bengaluru' },
        { id: 'store_02', name: 'Koramangala Express', code: 'DB_02', city: 'Bengaluru' },
      ]),
      create: jest.fn().mockResolvedValue({ id: 'store_03', name: 'HSR Layout' }),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MultiStoreService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<MultiStoreService>(MultiStoreService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should list stores across cities', async () => {
    const stores = await service.listStores('Bengaluru');
    expect(stores).toBeDefined();
    expect(stores.length).toBeGreaterThan(0);
  });

  it('should get store analytics', async () => {
    const analytics = await service.getStoreAnalytics('store_01');
    expect(analytics).toBeDefined();
    expect(analytics.totalRevenue).toBeGreaterThan(0);
  });
});
