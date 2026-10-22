import { Test, TestingModule } from '@nestjs/testing';
import { OrdersService } from './orders.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';
import { QueueProcessor } from '../queue/queue.processor';
import { OrderPricingService } from './order-pricing.service';
import { InventoryService } from '../inventory/inventory.service';
import { MultiStoreService } from '../multi-store/multi-store.service';

describe('OrdersService Unit Tests', () => {
  let service: OrdersService;

  const mockMultiStoreService = {
    resolveOptimalStore: jest.fn().mockResolvedValue({
      selectedStore: {
        id: 'store_101',
        name: 'Dark Store',
        code: 'STR_BLR_01',
        address: '100ft Road, Indiranagar',
        city: 'Bengaluru',
        pincode: '560038',
        latitude: 12.9716,
        longitude: 77.5946,
      },
      distanceKm: 1.5,
      estimatedArrivalMins: 9,
      isFullyStocked: true,
      activeOrdersCount: 2,
      congestionLevel: 'LOW',
      routingReason: 'Optimal route',
    }),
  };

  const mockInventoryService = {
    reserveBatchAtomic: jest.fn().mockResolvedValue({ success: true }),
    releaseBatchAtomic: jest.fn().mockResolvedValue(undefined),
    commitBatchAtomic: jest.fn().mockResolvedValue(undefined),
  };

  const mockPrismaService = {
    order: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    user: {
      findUnique: jest.fn().mockResolvedValue({ id: 'user_101', fullName: 'Test User' }),
      findFirst: jest.fn().mockResolvedValue({ id: 'user_101', fullName: 'Test User' }),
      create: jest.fn().mockResolvedValue({ id: 'user_101', fullName: 'Test User' }),
    },
    store: {
      findFirst: jest.fn().mockResolvedValue({ id: 'store_101', name: 'Dark Store' }),
      create: jest.fn().mockResolvedValue({ id: 'store_101', name: 'Dark Store' }),
    },
    address: {
      findUnique: jest.fn().mockResolvedValue({ id: 'addr_101', street: '100ft Road' }),
      findFirst: jest.fn().mockResolvedValue({ id: 'addr_101', street: '100ft Road' }),
      create: jest.fn().mockResolvedValue({ id: 'addr_101', street: '100ft Road' }),
    },
    productVariant: {
      findFirst: jest.fn().mockResolvedValue({ id: 'var_01', price: 54 }),
    },
    category: {
      findFirst: jest.fn().mockResolvedValue({ id: 'cat_01', name: 'Vegetables' }),
      create: jest.fn().mockResolvedValue({ id: 'cat_01', name: 'Vegetables' }),
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
    calculatePricing: jest.fn().mockResolvedValue({
      subtotal: 250,
      deliveryFee: 25,
      surgeFee: 0,
      rainFee: 0,
      couponDiscount: 0,
      itemDiscounts: 0,
      finalPayable: 275,
      selectedPaymentMethod: 'UPI',
      estimatedArrivalMins: 10,
      promiseBadge: '10–12 MINS ⚡',
      isSurgeApplied: false,
      isRainMode: false,
      surgeReason: null,
      storeLoadRatio: 0.25,
      isSoftClosed: false,
      softCloseMessage: null,
      minOrderValue: 149,
      isBelowMinOrder: false,
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
        { provide: InventoryService, useValue: mockInventoryService },
        { provide: MultiStoreService, useValue: mockMultiStoreService },
      ],
    }).compile();

    service = module.get<OrdersService>(OrdersService);
  });

  describe('createOrder', () => {
    it('should create order, reserve inventory atomically, enqueue jobs, and broadcast realtime events', async () => {
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
      expect(mockInventoryService.reserveBatchAtomic).toHaveBeenCalled();
      expect(mockPrismaService.order.create).toHaveBeenCalled();
      expect(mockEventsGateway.broadcastOrderCreated).toHaveBeenCalled();
    });

    it('should reject order creation if store is soft-closed', async () => {
      mockOrderPricingService.calculatePricing.mockResolvedValueOnce({
        subtotal: 250,
        deliveryFee: 25,
        finalPayable: 275,
        isSoftClosed: true,
        softCloseMessage: 'Store temporarily soft-closed due to high demand.',
        isBelowMinOrder: false,
      });

      await expect(
        service.createOrder('user_101', {
          addressId: 'addr_101',
          paymentMethod: 'UPI',
          items: [{ variantId: 'var_01', productName: 'Milk', price: 54, quantity: 2 }],
        }),
      ).rejects.toThrow('Store temporarily soft-closed due to high demand.');
    });

    it('should reject order creation if subtotal is below minimum order value', async () => {
      mockOrderPricingService.calculatePricing.mockResolvedValueOnce({
        subtotal: 50,
        deliveryFee: 25,
        finalPayable: 75,
        isSoftClosed: false,
        isBelowMinOrder: true,
        minOrderValue: 149,
      });

      await expect(
        service.createOrder('user_101', {
          addressId: 'addr_101',
          paymentMethod: 'UPI',
          items: [{ variantId: 'var_01', productName: 'Milk', price: 50, quantity: 1 }],
        }),
      ).rejects.toThrow('Minimum order value for 10-minute delivery is ₹149');
    });
  });

  describe('cancelOrder', () => {
    it('should cancel confirmed order and release reserved stock', async () => {
      const mockOrder = {
        id: 'ord_101',
        userId: 'user_101',
        orderNumber: 'DB-100001',
        storeId: 'store_101',
        status: 'CONFIRMED',
        paymentStatus: 'SUCCESS',
        items: [{ variantId: 'var_01', quantity: 2 }],
      };
      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.order.update.mockResolvedValue({ ...mockOrder, status: 'CANCELLED', paymentStatus: 'REFUNDED' });

      const result = await service.cancelOrder('ord_101', 'user_101', 'Changed mind');
      expect(result.success).toBe(true);
      expect(mockInventoryService.releaseBatchAtomic).toHaveBeenCalledWith('store_101', [{ variantId: 'var_01', quantity: 2 }]);
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
