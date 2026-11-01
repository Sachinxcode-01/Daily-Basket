import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { createHmac, timingSafeEqual } from 'crypto';

@Injectable()
export class PaymentsService {
  constructor(private prisma: PrismaService) { }

  async initiateRazorpayOrder(orderId: string, amount: number) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
    });

    if (!order) {
      throw new BadRequestException(`Order ${orderId} not found`);
    }

    const razorpayOrderId = `rzp_order_${Date.now()}_${Math.floor(Math.random() * 1000)}`;

    await this.prisma.payment.create({
      data: {
        orderId,
        razorpayOrderId,
        amount,
        method: order.paymentMethod,
        status: 'PENDING',
      },
    });

    return {
      success: true,
      razorpayOrderId,
      amount: amount * 100, // Amount in paise
      currency: 'INR',
      keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_daily_basket_2026',
    };
  }

  async verifySignature(paymentId: string, razorpayOrderId: string, razorpaySignature: string) {
    const secret = process.env.RAZORPAY_KEY_SECRET || 'rzp_secret_daily_basket_2026';
    const body = `${razorpayOrderId}|${paymentId}`;
    const expectedSignature = createHmac('sha256', secret).update(body).digest('hex');

    // Strict HMAC SHA-256 validation with constant-time equality check
    let isValid = false;
    try {
      const expectedBuffer = Buffer.from(expectedSignature, 'utf8');
      const signatureBuffer = Buffer.from(razorpaySignature || '', 'utf8');
      if (expectedBuffer.length === signatureBuffer.length) {
        isValid = timingSafeEqual(expectedBuffer, signatureBuffer);
      }
    } catch {
      isValid = false;
    }

    if (!isValid) {
      throw new BadRequestException('Razorpay payment signature verification failed.');
    }

    const payment = await this.prisma.payment.findFirst({
      where: { razorpayOrderId },
    });

    if (payment) {
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: { status: 'SUCCESS', transactionRef: paymentId },
      });

      await this.prisma.order.update({
        where: { id: payment.orderId },
        data: { paymentStatus: 'SUCCESS', status: 'CONFIRMED' },
      });
    }

    return {
      success: true,
      message: 'Razorpay Payment Signature Verified Successfully',
    };
  }
}
