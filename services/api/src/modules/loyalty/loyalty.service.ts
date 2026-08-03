import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class LoyaltyService {
  constructor(private prisma: PrismaService) {}

  async getUserLoyalty(userId: string = 'user_demo_1') {
    return {
      userId,
      pointsBalance: 480,
      tier: 'GOLD',
      referralCode: 'DAILY-ANANYA-2026',
      totalReferrals: 4,
      totalEarnedCashback: 400,
      tierBenefits: [
        'Free Delivery on orders above ₹99',
        '2x Points on Fresh Vegetables',
        'Priority 8-Min Express Delivery',
      ],
      referralHistory: [
        { friendName: 'Rahul Verma', status: 'COMPLETED', reward: '₹100 Cashback' },
        { friendName: 'Sneha Patel', status: 'COMPLETED', reward: '₹100 Cashback' },
      ],
    };
  }

  async redeemPoints(userId: string, points: number) {
    const discountValue = Math.floor(points / 10); // 10 points = ₹1
    return {
      success: true,
      pointsRedeemed: points,
      discountValue,
      message: `Successfully redeemed ${points} points for ₹${discountValue} discount coupon!`,
    };
  }
}
