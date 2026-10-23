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
    it('should verify authentic webhook HMAC and update order to CONFIRMED and payment to SUCCESS', async () => {
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
      const payloadString = JSON.stringify(webhookPayload);
      const webhookSecret = process.env.YOUPI_WEBHOOK_SECRET || 'yp_whsec_daily_basket_2026';
      const validSignature =
        'sha256=' +
        createHmac('sha256', webhookSecret).update(payloadString).digest('hex');

      const result = await service.handleYoupiWebhook(payloadString, validSignature);

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

    it('should reject webhook with missing or invalid signature', async () => {
      await expect(
        service.handleYoupiWebhook(JSON.stringify({ event: 'SUCCESS' }), 'sha256=invalid_hash'),
      ).rejects.toThrow(BadRequestException);

      await expect(
        service.handleYoupiWebhook(JSON.stringify({ event: 'SUCCESS' }), undefined),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
