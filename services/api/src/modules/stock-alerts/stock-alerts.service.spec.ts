import { Test, TestingModule } from '@nestjs/testing';
import { StockAlertsService } from './stock-alerts.service';
import { PrismaService } from '../../database/prisma.service';

describe('StockAlertsService', () => {
  let service: StockAlertsService;
  let prisma: PrismaService;

  const mockPrismaService = {
    stockAlert: {
      findMany: jest.fn(),
      upsert: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StockAlertsService,
        {
          provide: PrismaService,
          useValue: mockPrismaService,
        },
      ],
    }).compile();

    service = module.get<StockAlertsService>(StockAlertsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getStockAlerts', () => {
    it('should return mapped alerts from database when available', async () => {
      mockPrismaService.stockAlert.findMany.mockResolvedValueOnce([
        {
          id: 'alert-1',
          userId: 'user-1',
          isEnabled: true,
          status: 'OUT_OF_STOCK',
          variant: {
            price: 199,
            mrp: 249,
            product: {
              name: 'Organic Milk 1L',
              images: ['https://example.com/milk.jpg'],
            },
          },
        },
      ]);

      const result = await service.getStockAlerts('user-1');
      expect(result.status).toBe('success');
      expect(result.data).toHaveLength(1);
      expect(result.data[0].name).toBe('Organic Milk 1L');
      expect(result.data[0].notifyEnabled).toBe(true);
    });

    it('should fall back to default mock stock alerts if database is empty or throws', async () => {
      mockPrismaService.stockAlert.findMany.mockRejectedValueOnce(new Error('DB unreachable'));

      const result = await service.getStockAlerts('user-1');
      expect(result.status).toBe('success');
      expect(result.data.length).toBeGreaterThan(0);
      expect(result.data[0].id).toBe('bs1');
    });
  });

  describe('createStockAlert', () => {
    it('should upsert an alert in the database', async () => {
      mockPrismaService.stockAlert.upsert.mockResolvedValueOnce({
        id: 'alert-123',
        userId: 'user-1',
        variantId: 'var-1',
        isEnabled: true,
        status: 'OUT_OF_STOCK',
      });

      const result = await service.createStockAlert('user-1', 'var-1');
      expect(result.status).toBe('success');
      expect(result.data.id).toBe('alert-123');
      expect(mockPrismaService.stockAlert.upsert).toHaveBeenCalledWith({
        where: {
          userId_variantId: { userId: 'user-1', variantId: 'var-1' },
        },
        update: { isEnabled: true },
        create: {
          userId: 'user-1',
          variantId: 'var-1',
          isEnabled: true,
          status: 'OUT_OF_STOCK',
        },
      });
    });

    it('should return mock alert data if DB fails', async () => {
      mockPrismaService.stockAlert.upsert.mockRejectedValueOnce(new Error('Prisma error'));

      const result = await service.createStockAlert('user-1', 'var-mock');
      expect(result.status).toBe('success');
      expect(result.data.userId).toBe('user-1');
      expect(result.data.variantId).toBe('var-mock');
      expect(result.data.isEnabled).toBe(true);
    });
  });

  describe('toggleStockAlert', () => {
    it('should update isEnabled status in the database', async () => {
      mockPrismaService.stockAlert.update.mockResolvedValueOnce({
        id: 'alert-123',
        isEnabled: false,
      });

      const result = await service.toggleStockAlert('alert-123', false);
      expect(result.status).toBe('success');
      expect(result.data.isEnabled).toBe(false);
    });
  });

  describe('deleteStockAlert', () => {
    it('should remove the alert from the database', async () => {
      mockPrismaService.stockAlert.delete.mockResolvedValueOnce({});

      const result = await service.deleteStockAlert('alert-123');
      expect(result.status).toBe('success');
      expect(result.message).toBe('Alert removed');
    });
  });
});
