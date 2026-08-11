import { Test, TestingModule } from '@nestjs/testing';
import { OrdersService } from './orders.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';
import { QueueProcessor } from '../queue/queue.processor';
import { OrderPricingService } from './order-pricing.service';

describe('OrdersService Unit Tests', () => {
  let service: OrdersService;

  const mockPrismaService = {
    order: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
  };

  const mockRedisService = {
    acquireLock: jest.fn().mockResolvedValue('token_123'),
    releaseLock: jest.fn().mockResolvedValue(true),
    getQueueMetrics: jest.fn().mockResolvedValue({ pendingOrders: 0, redisConnected: true }),
  };

  const mockEventsGateway = {
    broadcastOrderCreated: jest.fn(),
    broadcastOrderPacking: jest.fn(),
    broadcastOrderUpdated: jest.fn(),
  };

  const mockQueueProcessor = {
    enqueueJob: jest.fn().mockResolvedValue('job_123'),
  };

  const mockOrderPricingService = {
    calculatePricing: jest.fn().mockReturnValue({
      subtotal: 250,
      deliveryFee: 25,
      couponDiscount: 0,
      itemDiscounts: 0,
      finalPayable: 275,
      selectedPaymentMethod: 'UPI',
    }),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OrdersService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: RedisService, useValue: mockRedisService },
        { provide: EventsGateway, useValue: mockEventsGateway },
        { provide: QueueProcessor, useValue: mockQueueProcessor },
        { provide: OrderPricingService, useValue: mockOrderPricingService },
      ],
    }).compile();

    service = module.get<OrdersService>(OrdersService);
  });

  describe('createOrder', () => {
    it('should create order, enqueue jobs, and broadcast realtime events', async () => {
      const mockOrderObj = {
        id: 'ord_101',
        orderNumber: 'DB-100001',
        totalAmount: 275,
        items: [],
      };
      mockPrismaService.order.create.mockResolvedValue(mockOrderObj);

      const result = await service.createOrder('user_101', {
        addressId: 'addr_101',
        paymentMethod: 'UPI',
        items: [{ variantId: 'var_01', productName: 'Milk', price: 54, quantity: 2 }],
      });

      expect(result).toBeDefined();
      expect(mockPrismaService.order.create).toHaveBeenCalled();
      expect(mockEventsGateway.broadcastOrderCreated).toHaveBeenCalled();
    });
  });

  describe('getOrderTracking', () => {
    it('should return tracking details and ETA', async () => {
      const mockOrderObj = {
        id: 'ord_101',
        status: 'CONFIRMED',
        estimatedArrivalMins: 10,
        items: [],
      };
      mockPrismaService.order.findUnique.mockResolvedValue(mockOrderObj);

      const tracking = await service.getOrderTracking('ord_101');
      expect(tracking.estimatedEtaMins).toBe(10);
      expect(tracking.stepStatus).toBe('CONFIRMED');
    });
  });
});
