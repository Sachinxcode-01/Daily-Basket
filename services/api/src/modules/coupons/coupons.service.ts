import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class CouponsService {
  constructor(private prisma: PrismaService) {}

  async validateCoupon(code: string, cartSubtotal: number) {
    const coupon = await this.prisma.coupon.findUnique({
      where: { code: code.toUpperCase() },
    });

    if (!coupon || !coupon.isActive) {
      throw new BadRequestException('Invalid or expired coupon code.');
    }

    if (new Date() > coupon.expiresAt) {
      throw new BadRequestException('Coupon code has expired.');
    }

    if (cartSubtotal < coupon.minOrderAmount) {
      throw new BadRequestException(
        `Minimum order amount of ₹${coupon.minOrderAmount} required for coupon ${coupon.code}.`,
      );
    }

    let discountAmount = 0;
    if (coupon.discountType === 'PERCENTAGE') {
      discountAmount = (cartSubtotal * coupon.discountValue) / 100;
      if (coupon.maxDiscount && discountAmount > coupon.maxDiscount) {
        discountAmount = coupon.maxDiscount;
      }
    } else {
      discountAmount = coupon.discountValue;
    }

    return {
      valid: true,
      code: coupon.code,
      discountAmount: Math.round(discountAmount),
      message: `Coupon ${coupon.code} applied! Saved ₹${Math.round(discountAmount)}.`,
    };
  }

  async getAvailableCoupons() {
    return this.prisma.coupon.findMany({
      where: { isActive: true },
    });
  }
}
