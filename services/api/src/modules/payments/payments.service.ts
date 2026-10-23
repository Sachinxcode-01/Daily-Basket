import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { createHmac, timingSafeEqual } from 'crypto';

@Injectable()
export class PaymentsService {
  constructor(private prisma: PrismaService) {}

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

  // ==========================================
  // YOUPI PG V2 — Sovereign UPI Gateway Methods
  // ==========================================

  private get youpiApiUrl(): string {
    return (process.env.YOUPI_API_URL || 'http://localhost:6100').replace(/\/+$/, '');
  }

  private get youpiPortalUrl(): string {
    return (process.env.YOUPI_PORTAL_URL || 'http://localhost:7000').replace(/\/+$/, '');
  }

  private get youpiWebhookSecret(): string {
    return process.env.YOUPI_WEBHOOK_SECRET || 'youpi_dev_webhook_secret_daily_basket';
  }

  async initiateYoupiOrder(
    orderId: string,
    amount: number,
    customer?: { phoneNumber?: string; fullName?: string },
  ) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
    });

    if (!order) {
      throw new BadRequestException(`Order ${orderId} not found`);
    }

    let paymentId = `youpi_pay_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
    let checkoutUrl = `${this.youpiPortalUrl}/checkout?paymentId=${paymentId}`;

    // Call YouPI Core Payment API if reachable
    try {
      const res = await fetch(`${this.youpiApiUrl}/api/v1/payments`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          orderId,
          amount: amount.toFixed(2),
          currency: 'INR',
          customer: customer?.phoneNumber ? { phoneNumber: customer.phoneNumber, fullName: customer.fullName } : undefined,
          returnUrl: `${process.env.STOREFRONT_URL || 'http://localhost:3005'}/order-success?orderId=${orderId}`,
        }),
      });

      if (res.ok) {
        const data = await res.json();
        paymentId = data.paymentId || paymentId;
        checkoutUrl = data.checkoutUrl || checkoutUrl;
      }
    } catch (err: any) {
      // Fallback for local preview if YouPI service container is starting up
      console.warn(`[YouPI] Notice: YouPI API not responding on ${this.youpiApiUrl}, generated local session: ${paymentId}`);
    }

    await this.prisma.payment.create({
      data: {
        orderId,
        razorpayOrderId: paymentId,
        amount,
        method: 'UPI',
        status: 'PENDING',
      },
    });

    return {
      success: true,
      gateway: 'YOUPI_PG_V2',
      paymentId,
      checkoutUrl,
      amount,
      currency: 'INR',
      vpa: process.env.MERCHANT_VPA || 'dailybasket@upi',
    };
  }

  async getYoupiPaymentStatus(paymentId: string) {
    try {
      const res = await fetch(`${this.youpiApiUrl}/api/v1/payments/${paymentId}`);
      if (res.ok) {
        return await res.json();
      }
    } catch {}

    const payment = await this.prisma.payment.findFirst({
      where: { razorpayOrderId: paymentId },
    });

    return {
      paymentId,
      orderId: payment?.orderId,
      status: payment?.status || 'PENDING',
      amount: payment?.amount,
    };
  }

  async handleYoupiWebhook(rawPayload: Buffer | string, signatureHeader?: string) {
    const payloadString = Buffer.isBuffer(rawPayload)
      ? rawPayload.toString('utf8')
      : typeof rawPayload === 'string'
      ? rawPayload
      : JSON.stringify(rawPayload);

    if (!signatureHeader || !signatureHeader.startsWith('sha256=')) {
      throw new BadRequestException('Missing or invalid YouPI webhook signature header');
    }

    const expectedSignature =
      'sha256=' +
      createHmac('sha256', this.youpiWebhookSecret)
        .update(payloadString)
        .digest('hex');

    const expectedBuffer = Buffer.from(expectedSignature, 'utf8');
    const signatureBuffer = Buffer.from(signatureHeader, 'utf8');

    const isValid =
      expectedBuffer.length === signatureBuffer.length &&
      timingSafeEqual(expectedBuffer, signatureBuffer);

    if (!isValid) {
      throw new BadRequestException('YouPI Webhook signature verification failed');
    }

    let payload: any = {};
    try {
      payload = JSON.parse(payloadString);
    } catch {
      throw new BadRequestException('Malformed JSON webhook body');
    }

    if (payload.event === 'SUCCESS' && payload.orderId) {
      const { orderId, utr, paymentId } = payload;

      const payment = await this.prisma.payment.findFirst({
        where: { orderId },
      });

      if (payment) {
        await this.prisma.payment.update({
          where: { id: payment.id },
          data: {
            status: 'SUCCESS',
            transactionRef: utr || paymentId,
          },
        });

        await this.prisma.order.update({
          where: { id: orderId },
          data: {
            paymentStatus: 'SUCCESS',
            status: 'CONFIRMED',
          },
        });
      }
    }

    return { received: true, event: payload.event };
  }
}
