import { Test, TestingModule } from '@nestjs/testing';
import { PaymentsService } from './payments.service';
import { PrismaService } from '../../database/prisma.service';

describe('PaymentsService Unit Tests', () => {
  let service: PaymentsService;

  const mockPrismaService = {
    order: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    payment: {
      create: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PaymentsService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<PaymentsService>(PaymentsService);
  });

  describe('initiateRazorpayOrder', () => {
    it('should create Razorpay order and return order payload', async () => {
      mockPrismaService.order.findUnique.mockResolvedValue({
        id: 'ord_101',
        paymentMethod: 'UPI',
      });
      mockPrismaService.payment.create.mockResolvedValue({
        id: 'pay_101',
        orderId: 'ord_101',
        amount: 349,
        method: 'UPI',
        status: 'PENDING',
      });

      const result = await service.initiateRazorpayOrder('ord_101', 349);
      expect(result.success).toBe(true);
      expect(result.amount).toBe(34900); // 349 * 100 paise
      expect(result.currency).toBe('INR');
    });
  });

  describe('verifySignature', () => {
    it('should verify signature and update payment and order status', async () => {
      mockPrismaService.payment.findFirst.mockResolvedValue({
        id: 'pay_101',
        orderId: 'ord_101',
        razorpayOrderId: 'rzp_order_123',
      });

      const result = await service.verifySignature('pay_123', 'rzp_order_123', 'sig_test_123');
      expect(result.success).toBe(true);
      expect(mockPrismaService.payment.update).toHaveBeenCalled();
      expect(mockPrismaService.order.update).toHaveBeenCalled();
    });
  });

  describe('initiateYoupiOrder', () => {
    it('should create YouPI payment session and return checkout details', async () => {
      mockPrismaService.order.findUnique.mockResolvedValue({
        id: 'ord_youpi_1',
        paymentMethod: 'UPI',
      });
      mockPrismaService.payment.create.mockResolvedValue({
        id: 'pay_yp_1',
        orderId: 'ord_youpi_1',
        amount: 499,
        method: 'UPI',
        status: 'PENDING',
      });

      const result = await service.initiateYoupiOrder('ord_youpi_1', 499, {
        phoneNumber: '+919876543210',
      });

      expect(result.success).toBe(true);
      expect(result.gateway).toBe('YOUPI_PG_V2');
      expect(result.amount).toBe(499);
      expect(result.checkoutUrl).toBeDefined();
      expect(mockPrismaService.payment.create).toHaveBeenCalled();
    });
  });

  describe('handleYoupiWebhook', () => {
    it('should verify webhook and update order to CONFIRMED and payment to SUCCESS', async () => {
      mockPrismaService.payment.findFirst.mockResolvedValue({
        id: 'pay_yp_1',
        orderId: 'ord_youpi_1',
      });

      const webhookPayload = {
        event: 'SUCCESS',
        orderId: 'ord_youpi_1',
        amount: '499.00',
        utr: 'UTR123456789012',
        paymentId: 'youpi_pay_123',
      };

      const result = await service.handleYoupiWebhook(
        JSON.stringify(webhookPayload),
        'sha256=test_signature',
      );

      expect(result.received).toBe(true);
      expect(result.event).toBe('SUCCESS');
      expect(mockPrismaService.payment.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({ status: 'SUCCESS', transactionRef: 'UTR123456789012' }),
        }),
      );
      expect(mockPrismaService.order.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({ paymentStatus: 'SUCCESS', status: 'CONFIRMED' }),
        }),
      );
    });
  });
});
