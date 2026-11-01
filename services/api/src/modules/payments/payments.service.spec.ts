import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException } from '@nestjs/common';
import { createHmac } from 'crypto';
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
    it('should verify authentic HMAC signature and update payment and order status', async () => {
      mockPrismaService.payment.findFirst.mockResolvedValue({
        id: 'pay_101',
        orderId: 'ord_101',
        razorpayOrderId: 'rzp_order_123',
      });

      const secret = process.env.RAZORPAY_KEY_SECRET || 'rzp_secret_daily_basket_2026';
      const validSignature = createHmac('sha256', secret)
        .update('rzp_order_123|pay_123')
        .digest('hex');

      const result = await service.verifySignature('pay_123', 'rzp_order_123', validSignature);
      expect(result.success).toBe(true);
      expect(mockPrismaService.payment.update).toHaveBeenCalled();
      expect(mockPrismaService.order.update).toHaveBeenCalled();
    });

    it('should reject invalid or bypassed test signature', async () => {
      await expect(
        service.verifySignature('pay_123', 'rzp_order_123', 'sig_test_bypassed'),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
