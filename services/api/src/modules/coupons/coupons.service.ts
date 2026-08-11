import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { EventsGateway } from '../events/events.gateway';

export interface CouponDto {
  id?: string;
  code: string;
  title: string;
  description: string;
  discountType: 'PERCENTAGE' | 'FLAT' | 'FREE_DELIVERY' | 'CASHBACK' | 'FIRST_ORDER' | 'CATEGORY' | 'BRAND' | 'PRODUCT';
  discountValue: number;
  minOrderAmount: number;
  maxDiscount?: number;
  category?: string;
  startDate?: string;
  expiresAt: string;
  isActive?: boolean;
  usageLimitPerUser?: number;
  totalUsageLimit?: number;
  usedCount?: number;
}

@Injectable()
export class CouponsService {
  private readonly logger = new Logger(CouponsService.name);

  constructor(
    private prisma: PrismaService,
    private eventsGateway: EventsGateway,
  ) {}

  async getAvailableCoupons() {
    const coupons = await this.prisma.coupon.findMany({
      where: {
        isActive: true,
        expiresAt: { gte: new Date() },
      },
      orderBy: { createdAt: 'desc' },
    });

    // Seed default promotional coupons if database table is empty
    if (coupons.length === 0) {
      await this.seedDefaultCoupons();
      return this.prisma.coupon.findMany({ where: { isActive: true } });
    }

    return { success: true, data: coupons };
  }

  private async seedDefaultCoupons() {
    const defaults = [
      {
        code: 'WELCOME100',
        title: '₹100 Off First Order',
        description: 'Get flat ₹100 off on your first order above ₹299',
        discountType: 'FIRST_ORDER',
        discountValue: 100,
        minOrderAmount: 299,
        expiresAt: new Date('2026-12-31T23:59:59Z'),
        isActive: true,
        usageLimitPerUser: 1,
        totalUsageLimit: 10000,
      },
      {
        code: 'FRESH20',
        title: '20% Off Fresh Farm Vegetables',
        description: 'Save 20% up to ₹80 on fresh fruits and vegetables',
        discountType: 'PERCENTAGE',
        discountValue: 20,
        minOrderAmount: 199,
        maxDiscount: 80,
        expiresAt: new Date('2026-10-15T23:59:59Z'),
        isActive: true,
        usageLimitPerUser: 5,
        totalUsageLimit: 5000,
      },
      {
        code: 'FREEDEL',
        title: 'Free Delivery',
        description: 'Free 10-minute delivery on all orders above ₹149',
        discountType: 'FREE_DELIVERY',
        discountValue: 25,
        minOrderAmount: 149,
        expiresAt: new Date('2026-11-30T23:59:59Z'),
        isActive: true,
        usageLimitPerUser: 10,
        totalUsageLimit: 20000,
      },
    ];

    for (const item of defaults) {
      await this.prisma.coupon.upsert({
        where: { code: item.code },
        update: {},
        create: item,
      });
    }
  }

  async getCouponById(id: string) {
    const coupon = await this.prisma.coupon.findFirst({
      where: { OR: [{ id }, { code: id.toUpperCase() }] },
    });

    if (!coupon) throw new NotFoundException('Coupon not found');
    return { success: true, data: coupon };
  }

  async validateCoupon(code: string, cartSubtotal: number, userId = 'usr_default') {
    const coupon = await this.prisma.coupon.findUnique({
      where: { code: code.toUpperCase() },
    });

    if (!coupon || !coupon.isActive) {
      throw new BadRequestException('Invalid or inactive coupon code.');
    }

    if (new Date() > coupon.expiresAt) {
      throw new BadRequestException('Coupon code has expired.');
    }

    if (cartSubtotal < coupon.minOrderAmount) {
      throw new BadRequestException(
        `Minimum order amount of ₹${coupon.minOrderAmount} required for coupon ${coupon.code}.`,
      );
    }

    // First order validation check
    if (coupon.discountType === 'FIRST_ORDER') {
      const userOrderCount = await this.prisma.order.count({
        where: { userId, status: { not: 'CANCELLED' } },
      });
      if (userOrderCount > 0) {
        throw new BadRequestException('Coupon WELCOME100 is valid on your first order only.');
      }
    }

    // User redemption count validation
    const userRedemptions = await this.prisma.couponRedemption.count({
      where: { couponId: coupon.id, userId },
    });

    if (userRedemptions >= coupon.usageLimitPerUser) {
      throw new BadRequestException(`Usage limit of ${coupon.usageLimitPerUser} times reached for this coupon.`);
    }

    let discountAmount = 0;
    if (coupon.discountType === 'PERCENTAGE') {
      discountAmount = (cartSubtotal * coupon.discountValue) / 100;
      if (coupon.maxDiscount && discountAmount > coupon.maxDiscount) {
        discountAmount = coupon.maxDiscount;
      }
    } else if (coupon.discountType === 'FREE_DELIVERY') {
      discountAmount = coupon.discountValue || 25;
    } else {
      discountAmount = coupon.discountValue;
    }

    discountAmount = Math.round(discountAmount);

    return {
      success: true,
      valid: true,
      code: coupon.code,
      discountType: coupon.discountType,
      discountAmount,
      message: `Coupon ${coupon.code} applied successfully! Saved ₹${discountAmount}.`,
    };
  }

  async removeCoupon(code: string) {
    return {
      success: true,
      message: `Coupon ${code.toUpperCase()} removed from cart.`,
    };
  }

  async getHistory(userId = 'usr_default') {
    const history = await this.prisma.couponRedemption.findMany({
      where: { userId },
      include: { coupon: true },
      orderBy: { redeemedAt: 'desc' },
    });
    return { success: true, data: history };
  }

  // ─── ADMIN MANAGEMENT WITH INSTANT WEBSOCKET BROADCASTING ─────────────────
  async createCoupon(dto: CouponDto) {
    const code = dto.code.toUpperCase();
    const existing = await this.prisma.coupon.findUnique({ where: { code } });

    if (existing) {
      throw new BadRequestException(`Coupon code ${code} already exists.`);
    }

    const coupon = await this.prisma.coupon.create({
      data: {
        code,
        title: dto.title,
        description: dto.description,
        discountType: dto.discountType,
        discountValue: dto.discountValue,
        minOrderAmount: dto.minOrderAmount || 0,
        maxDiscount: dto.maxDiscount,
        category: dto.category,
        expiresAt: new Date(dto.expiresAt),
        isActive: dto.isActive !== undefined ? dto.isActive : true,
        usageLimitPerUser: dto.usageLimitPerUser || 1,
        totalUsageLimit: dto.totalUsageLimit || 10000,
      },
    });

    // Real-time Socket.IO emission to Customer Apps & Web Checkouts
    this.eventsGateway.broadcastCouponCreated(coupon);

    return { success: true, data: coupon, message: 'Coupon created successfully' };
  }

  async updateCoupon(id: string, dto: Partial<CouponDto>) {
    const existing = await this.prisma.coupon.findFirst({
      where: { OR: [{ id }, { code: id.toUpperCase() }] },
    });

    if (!existing) throw new NotFoundException('Coupon not found');

    const updated = await this.prisma.coupon.update({
      where: { id: existing.id },
      data: {
        title: dto.title,
        description: dto.description,
        discountType: dto.discountType,
        discountValue: dto.discountValue,
        minOrderAmount: dto.minOrderAmount,
        maxDiscount: dto.maxDiscount,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
        isActive: dto.isActive,
      },
    });

    // Real-time Socket.IO emission
    this.eventsGateway.broadcastCouponUpdated(updated);

    return { success: true, data: updated, message: 'Coupon updated successfully' };
  }

  async deleteCoupon(id: string) {
    const existing = await this.prisma.coupon.findFirst({
      where: { OR: [{ id }, { code: id.toUpperCase() }] },
    });

    if (!existing) throw new NotFoundException('Coupon not found');

    await this.prisma.coupon.delete({ where: { id: existing.id } });
    this.eventsGateway.server?.emit('coupon.deleted', { id: existing.id, code: existing.code });

    return { success: true, message: 'Coupon deleted successfully' };
  }
}
