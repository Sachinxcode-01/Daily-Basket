import { Test, TestingModule } from '@nestjs/testing';
import { DeliveryService } from './delivery.service';
import { PrismaService } from '../../database/prisma.service';

describe('DeliveryService Offline Sync', () => {
  let service: DeliveryService;

  const mockPrismaService = {
    order: {
      findUnique: jest.fn(),
      update: jest.fn().mockImplementation(({ where, data }) =>
        Promise.resolve({ id: where.id, orderNumber: 'DB-892104', status: data.status }),
      ),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DeliveryService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<DeliveryService>(DeliveryService);
  });

  it('should process batch offline queued actions idempotently', async () => {
    const offlineActions = [
      {
        id: 'act_101',
        type: 'STATUS_UPDATE',
        orderId: 'DB-892104',
        payload: { step: 'PICKED_UP' },
        timestamp: new Date().toISOString(),
      },
      {
        id: 'act_102',
        type: 'STATUS_UPDATE',
        orderId: 'DB-892104',
        payload: { step: 'DELIVERED' },
        timestamp: new Date().toISOString(),
      },
    ];

    const result = await service.syncOfflineQueue(offlineActions);

    expect(result.success).toBe(true);
    expect(result.syncedCount).toBe(2);
    expect(result.processedActionIds).toEqual(['act_101', 'act_102']);
  });
});
