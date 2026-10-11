import { Test, TestingModule } from '@nestjs/testing';
import { TimedDispatchService } from './timed-dispatch.service';
import { PrismaService } from '../../database/prisma.service';
import { GeofenceService } from './geofence.service';
import { EventsGateway } from '../events/events.gateway';
import { OrderStatus } from '@prisma/client';

describe('TimedDispatchService Unit Tests', () => {
  let service: TimedDispatchService;

  const mockGeofenceService = {
    calculateHaversineDistance: jest.fn(),
  };

  const mockEventsGateway = {
    broadcastRiderAssigned: jest.fn(),
  };

  const mockPrismaService = {
    order: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      count: jest.fn(),
      update: jest.fn(),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TimedDispatchService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: GeofenceService, useValue: mockGeofenceService },
        { provide: EventsGateway, useValue: mockEventsGateway },
      ],
    }).compile();

    service = module.get<TimedDispatchService>(TimedDispatchService);
  });

  describe('calculateDispatchTiming', () => {
    it('should calculate packing duration and hold dispatch window until 60% elapsed', () => {
      const now = new Date();
      // Fresh order created 0 seconds ago with 5 items
      const result = service.calculateDispatchTiming(now, 5);

      expect(result.packingDurationMins).toBe(2.0); // 1.5 + 5 * 0.1
      expect(result.packingProgressPercent).toBe(0);
      expect(result.isDispatchWindowOpen).toBe(false);
      expect(result.remainingSecsUntilDispatch).toBeGreaterThan(0);
    });

    it('should open dispatch window once 60% of packing time has passed', () => {
      // Order created 80 seconds ago (60% of 120s is 72s)
      const past = new Date(Date.now() - 80 * 1000);
      const result = service.calculateDispatchTiming(past, 5);

      expect(result.isDispatchWindowOpen).toBe(true);
      expect(result.remainingSecsUntilDispatch).toBe(0);
    });
  });

  describe('dispatchOrder', () => {
    it('should hold assignment if packing progress is under 60% and not forced', async () => {
      const mockOrder = {
        id: 'ord_101',
        createdAt: new Date(), // Just placed
        items: [{ id: 'item_1' }, { id: 'item_2' }],
        storeId: 'store_01',
        address: { latitude: 12.937, longitude: 77.621 },
      };
      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);

      const decision = await service.dispatchOrder('ord_101', false);

      expect(decision.status).toBe('DISPATCH_WINDOW_PENDING');
      expect(decision.isBatched).toBe(false);
      expect(mockPrismaService.order.update).not.toHaveBeenCalled();
    });

    it('should dispatch nearest qualified rider within 1.5km when window is open or forced', async () => {
      const mockOrder = {
        id: 'ord_101',
        createdAt: new Date(),
        items: [{ id: 'item_1' }],
        storeId: 'store_01',
        address: { latitude: 12.937, longitude: 77.621 },
      };
      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.order.count.mockResolvedValue(0); // Riders have 0 active orders
      mockGeofenceService.calculateHaversineDistance.mockReturnValue(0.4); // 400m away
      mockPrismaService.order.update.mockResolvedValue({ id: 'ord_101', status: OrderStatus.READY_FOR_PICKUP });

      const decision = await service.dispatchOrder('ord_101', true);

      expect(decision.status).toBe('ASSIGNED');
      expect(decision.isBatched).toBe(false);
      expect(decision.rider).toBeDefined();
      expect(mockPrismaService.order.update).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { id: 'ord_101' },
          data: expect.objectContaining({ status: OrderStatus.READY_FOR_PICKUP }),
        }),
      );
      expect(mockEventsGateway.broadcastRiderAssigned).toHaveBeenCalled();
    });

    it('should dynamically batch second order if rider destination is within 800m corridor', async () => {
      const mockOrder = {
        id: 'ord_new_102',
        orderNumber: 'DB-10002',
        createdAt: new Date(),
        items: [{ id: 'item_1' }],
        storeId: 'store_01',
        address: { street: '4th Block, 100ft Rd', latitude: 12.938, longitude: 77.622 },
      };

      const existingOrder = {
        id: 'ord_existing_101',
        orderNumber: 'DB-10001',
        storeId: 'store_01',
        deliveryPartnerId: 'rider_01',
        status: OrderStatus.READY_FOR_PICKUP,
        address: { street: '5th Block, 100ft Rd', latitude: 12.936, longitude: 77.621 },
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      // First rider has 1 active order, second rider has 0
      mockPrismaService.order.count
        .mockResolvedValueOnce(1)
        .mockResolvedValue(0);

      // Distance to store
      mockGeofenceService.calculateHaversineDistance
        .mockReturnValueOnce(0.3) // Rider 1 to store: 0.3km
        .mockReturnValueOnce(0.5) // Distance between drops: 500m (0.5km)
        .mockReturnValue(0.8);

      mockPrismaService.order.findFirst.mockResolvedValue(existingOrder);
      mockPrismaService.order.update.mockResolvedValue({ id: 'ord_new_102', status: OrderStatus.READY_FOR_PICKUP });

      const decision = await service.dispatchOrder('ord_new_102', true);

      expect(decision.status).toBe('BATCHED');
      expect(decision.isBatched).toBe(true);
      expect(decision.batchDetails).toBeDefined();
      expect(decision.batchDetails?.stops.length).toBe(3); // 1 Pickup, 2 Drops
      expect(decision.batchDetails?.orderIds).toContain('ord_new_102');
      expect(decision.batchDetails?.orderIds).toContain('ord_existing_101');
      expect(mockEventsGateway.broadcastRiderAssigned).toHaveBeenCalledWith(
        'ord_new_102',
        undefined,
        expect.any(String),
        expect.objectContaining({ isBatched: true }),
      );
    });
  });
});
