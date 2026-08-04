import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';

export interface CouponDto {
  id?: string;
  code: string;
  title: string;
  description: string;
  discountType: 'PERCENTAGE' | 'FLAT' | 'FREE_DELIVERY' | 'CASHBACK';
  discountValue: number;
  minOrderAmount: number;
  maxDiscount?: number;
  expiresAt: string;
  isActive: boolean;
  usageLimitPerUser?: number;
  totalUsageLimit?: number;
  usedCount?: number;
  category?: string;
}

@Injectable()
export class CouponsService {
  private coupons: Map<string, CouponDto> = new Map();
  private couponHistory: Map<string, any[]> = new Map();

  constructor() {
    // Seed initial production coupons
    const initialCoupons: CouponDto[] = [
      {
        id: 'cpn_WELCOME100',
        code: 'WELCOME100',
        title: '₹100 Off First Order',
        description: 'Get flat ₹100 off on your first order above ₹299',
        discountType: 'FLAT',
        discountValue: 100,
        minOrderAmount: 299,
        expiresAt: '2026-12-31T23:59:59Z',
        isActive: true,
        usageLimitPerUser: 1,
        usedCount: 1420,
        category: 'WELCOME',
      },
      {
        id: 'cpn_FRESH20',
        code: 'FRESH20',
        title: '20% Off Fresh Vegetables',
        description: 'Save 20% up to ₹80 on fresh fruits and vegetables',
        discountType: 'PERCENTAGE',
        discountValue: 20,
        minOrderAmount: 199,
        maxDiscount: 80,
        expiresAt: '2026-10-15T23:59:59Z',
        isActive: true,
        usageLimitPerUser: 5,
        usedCount: 3890,
        category: 'VEGETABLES',
      },
      {
        id: 'cpn_FREEDEL',
        code: 'FREEDEL',
        title: 'Free Delivery',
        description: 'Free 10-minute delivery on all orders above ₹149',
        discountType: 'FREE_DELIVERY',
        discountValue: 35,
        minOrderAmount: 149,
        expiresAt: '2026-11-30T23:59:59Z',
        isActive: true,
        usageLimitPerUser: 10,
        usedCount: 8900,
        category: 'DELIVERY',
      },
      {
        id: 'cpn_DAILY50',
        code: 'DAILY50',
        title: 'Flat ₹50 Super Saver',
        description: 'Flat ₹50 discount on grocery essentials',
        discountType: 'FLAT',
        discountValue: 50,
        minOrderAmount: 399,
        expiresAt: '2026-09-30T23:59:59Z',
        isActive: true,
        usageLimitPerUser: 3,
        usedCount: 2310,
        category: 'GROCERY',
      },
    ];

    initialCoupons.forEach((c) => this.coupons.set(c.code, c));

    // Seed mock coupon history for default user
    this.couponHistory.set('usr_default', [
      {
        code: 'WELCOME100',
        appliedAt: '2026-08-01T14:30:00Z',
        savedAmount: 100,
        orderId: 'ORD-98214',
      },
      {
        code: 'FREEDEL',
        appliedAt: '2026-08-03T10:15:00Z',
        savedAmount: 35,
        orderId: 'ORD-98255',
      },
    ]);
  }

  async getAvailableCoupons() {
    return {
      success: true,
      data: Array.from(this.coupons.values()).filter((c) => c.isActive),
    };
  }

  async getCouponById(id: string) {
    const coupon = Array.from(this.coupons.values()).find((c) => c.id === id || c.code === id);
    if (!coupon) throw new NotFoundException('Coupon not found');
    return { success: true, data: coupon };
  }

  async validateCoupon(code: string, cartSubtotal: number, userId = 'usr_default') {
    const coupon = this.coupons.get(code.toUpperCase());

    if (!coupon || !coupon.isActive) {
      throw new BadRequestException('Invalid or expired coupon code.');
    }

    if (new Date() > new Date(coupon.expiresAt)) {
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
    } else if (coupon.discountType === 'FREE_DELIVERY') {
      discountAmount = coupon.discountValue || 35;
    } else {
      discountAmount = coupon.discountValue;
    }

    discountAmount = Math.round(discountAmount);

    return {
      success: true,
      valid: true,
      code: coupon.code,
      discountAmount,
      message: `Coupon ${coupon.code} applied! Saved ₹${discountAmount}.`,
    };
  }

  async removeCoupon(code: string) {
    return {
      success: true,
      message: `Coupon ${code.toUpperCase()} removed from cart.`,
    };
  }

  async getHistory(userId = 'usr_default') {
    const history = this.couponHistory.get(userId) || [];
    return { success: true, data: history };
  }

  // ─── ADMIN CRUD ─────────────────────────────────────────────────────────────
  async createCoupon(dto: CouponDto) {
    const newCoupon = {
      ...dto,
      id: `cpn_${dto.code.toUpperCase()}`,
      code: dto.code.toUpperCase(),
      usedCount: 0,
      isActive: true,
    };
    this.coupons.set(newCoupon.code, newCoupon);
    return { success: true, data: newCoupon, message: 'Coupon created successfully' };
  }

  async updateCoupon(id: string, dto: Partial<CouponDto>) {
    const existing = Array.from(this.coupons.values()).find((c) => c.id === id || c.code === id);
    if (!existing) throw new NotFoundException('Coupon not found');

    const updated = { ...existing, ...dto };
    this.coupons.set(existing.code, updated);
    return { success: true, data: updated, message: 'Coupon updated successfully' };
  }

  async deleteCoupon(id: string) {
    const existing = Array.from(this.coupons.values()).find((c) => c.id === id || c.code === id);
    if (!existing) throw new NotFoundException('Coupon not found');

    this.coupons.delete(existing.code);
    return { success: true, message: 'Coupon deleted successfully' };
  }
}
