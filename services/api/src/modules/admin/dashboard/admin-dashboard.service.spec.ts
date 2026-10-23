import { Test, TestingModule } from '@nestjs/testing';
import { AdminDashboardService } from './admin-dashboard.service';
import { AdminDashboardController } from './admin-dashboard.controller';
import { PrismaService } from '../../../database/prisma.service';

describe('AdminDashboard Enterprise Unit Tests', () => {
  let service: AdminDashboardService;
  let controller: AdminDashboardController;

  const mockDate = new Date();
  const mockOrder = {
    id: 'ord_db_1',
    orderNumber: 'DB-9821',
    totalAmount: 450,
    status: 'DELIVERED',
    paymentStatus: 'SUCCESS',
    createdAt: new Date(mockDate.getTime() - 15 * 60000), // 15 mins ago
    updatedAt: mockDate,
    user: { fullName: 'Sarah Jenkins' },
    items: [
      { productName: 'Fresh Organic Avocados', quantity: 2 },
      { productName: 'Farm Whole Milk', quantity: 1 },
    ],
  };

  const mockInventory = {
    id: 'inv_1',
    stockQuantity: 4,
    variant: {
      sku: 'SKU-MILK-1L',
      unitName: '1 L',
      product: {
        name: 'Farm Whole Milk',
        images: ['https://example.com/milk.jpg'],
      },
    },
  };

  const mockPrismaService = {
    order: {
      findMany: jest.fn(),
      count: jest.fn(),
    },
    product: {
      count: jest.fn(),
    },
    inventory: {
      findMany: jest.fn(),
      count: jest.fn(),
    },
    user: {
      count: jest.fn(),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AdminDashboardController],
      providers: [
        AdminDashboardService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<AdminDashboardService>(AdminDashboardService);
    controller = module.get<AdminDashboardController>(AdminDashboardController);
  });

  describe('getSummary', () => {
    it('should compute real database-derived summary metrics', async () => {
      mockPrismaService.order.findMany
        .mockResolvedValueOnce([mockOrder]) // todayOrders
        .mockResolvedValueOnce([{ totalAmount: 400, status: 'DELIVERED' }]); // yesterdayOrders

      mockPrismaService.product.count.mockResolvedValue(120);
      mockPrismaService.inventory.count
        .mockResolvedValueOnce(3) // lowStock
        .mockResolvedValueOnce(1); // outOfStock

      mockPrismaService.user.count
        .mockResolvedValueOnce(18) // newCustomersToday
        .mockResolvedValueOnce(25); // fleetTotal

      const summary = await service.getSummary();

      expect(summary.todayRevenue).toBe(450);
      expect(summary.yesterdayRevenue).toBe(400);
      expect(summary.revenueChangePercent).toBe(12.5);
      expect(summary.completedOrders).toBe(1);
      expect(summary.totalActiveProducts).toBe(120);
      expect(summary.lowStockCount).toBe(3);
      expect(summary.outOfStockCount).toBe(1);
      expect(summary.newCustomersToday).toBe(18);
      expect(summary.fleetTotal).toBe(25);
      expect(summary.fleetActive).toBe(22);
      expect(summary.darkStoreStatus).toBe('ONLINE_OPTIMAL');
    });

    it('should return resilient zeroed defaults if database query fails', async () => {
      mockPrismaService.order.findMany.mockRejectedValue(new Error('DB offline'));

      const summary = await service.getSummary();
      expect(summary.todayRevenue).toBe(0);
      expect(summary.darkStoreStatus).toBe('ONLINE_STANDBY');
    });
  });

  describe('getSalesTrend', () => {
    it('should return 7-day sales trend with dates and day names', async () => {
      mockPrismaService.order.findMany.mockResolvedValue([{ totalAmount: 500 }]);

      const trend = await service.getSalesTrend(7);
      expect(trend).toHaveLength(7);
      expect(trend[0]).toHaveProperty('dayName');
      expect(trend[0]).toHaveProperty('revenue');
      expect(trend[0]).toHaveProperty('ordersCount');
    });
  });

  describe('getRecentOrders', () => {
    it('should return sanitized recent orders with customer initials and items count', async () => {
      mockPrismaService.order.findMany.mockResolvedValue([mockOrder]);

      const recent = await service.getRecentOrders(5);
      expect(recent).toHaveLength(1);
      expect(recent[0].customerName).toBe('Sarah Jenkins');
      expect(recent[0].customerInitials).toBe('SJ');
      expect(recent[0].itemsCount).toBe(3);
      expect(recent[0].orderNumber).toBe('DB-9821');
    });
  });

  describe('getInventoryAlerts', () => {
    it('should return inventory alerts with severity rating and suggested reorder quantities', async () => {
      mockPrismaService.inventory.findMany.mockResolvedValue([mockInventory]);

      const alerts = await service.getInventoryAlerts(5);
      expect(alerts).toHaveLength(1);
      expect(alerts[0].productName).toBe('Farm Whole Milk');
      expect(alerts[0].severity).toBe('URGENT'); // <= 5
      expect(alerts[0].reorderSuggested).toBe(true);
      expect(alerts[0].suggestedReorderQuantity).toBe(50);
    });
  });

  describe('Controller delegation', () => {
    it('should delegate controller endpoints correctly', async () => {
      jest.spyOn(service, 'getSummary').mockResolvedValue({} as any);
      jest.spyOn(service, 'getSalesTrend').mockResolvedValue([] as any);
      jest.spyOn(service, 'getRecentOrders').mockResolvedValue([] as any);
      jest.spyOn(service, 'getInventoryAlerts').mockResolvedValue([] as any);

      await controller.getSummary('store_1');
      expect(service.getSummary).toHaveBeenCalledWith('store_1');

      await controller.getSalesTrend('7');
      expect(service.getSalesTrend).toHaveBeenCalledWith(7);

      await controller.getRecentOrders('10');
      expect(service.getRecentOrders).toHaveBeenCalledWith(10);

      await controller.getInventoryAlerts('10');
      expect(service.getInventoryAlerts).toHaveBeenCalledWith(10);
    });
  });
});
