import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class ImpactService {
  constructor(private readonly prisma: PrismaService) {}

  async getDashboard(userId: string) {
    let impact = await this.prisma.userImpact.findUnique({
      where: { userId },
    });

    if (!impact) {
      impact = await this.prisma.userImpact.create({
        data: {
          userId,
          impactPoints: 1240,
          plasticSavedKg: 4.2,
          co2ReducedKg: 12.5,
          paperBagsSaved: 18,
          ecoDeliveries: 34,
          greenOrders: 28,
          monthlyProgress: 84.0,
          yearlyProgress: 65.0,
          treesEquivalent: 3.5,
          level: 'Earth Champion',
        },
      });
    }

    return {
      status: 'success',
      data: {
        impact,
        percentile: 'top 5%',
        userTier: 'Earth Champion',
      },
    };
  }

  async getHistory(_userId: string) {
    return {
      status: 'success',
      data: [
        { month: 'May 2026', plasticSavedKg: 1.1, co2ReducedKg: 3.2, points: 320 },
        { month: 'Jun 2026', plasticSavedKg: 1.4, co2ReducedKg: 4.1, points: 410 },
        { month: 'Jul 2026', plasticSavedKg: 1.7, co2ReducedKg: 5.2, points: 510 },
      ],
    };
  }

  async getBadges(userId: string) {
    const badges = await this.prisma.userBadge.findMany({
      where: { userId },
    });

    if (badges.length === 0) {
      return {
        status: 'success',
        data: [
          { title: 'Zero Waste', tier: 'Tier 2', iconName: 'nature_people' },
          { title: 'EV Champion', tier: 'Tier 3', iconName: 'bolt' },
          { title: 'Tree Saver', tier: 'Tier 1', iconName: 'park' },
        ],
      };
    }

    return { status: 'success', data: badges };
  }

  async getRewards(_userId: string) {
    return {
      status: 'success',
      data: [
        { id: 'rew_1', title: '₹50 Green Cashback', pointsRequired: 500, isUnlocked: true },
        { id: 'rew_2', title: 'Free Eco Cotton Tote Bag', pointsRequired: 1000, isUnlocked: true },
        { id: 'rew_3', title: 'Plant 1 Tree in Your Name', pointsRequired: 2000, isUnlocked: false },
      ],
    };
  }

  async recalculate(userId: string) {
    const updated = await this.prisma.userImpact.upsert({
      where: { userId },
      update: {
        impactPoints: { increment: 50 },
        plasticSavedKg: { increment: 0.3 },
        co2ReducedKg: { increment: 0.8 },
      },
      create: {
        userId,
        impactPoints: 1290,
        plasticSavedKg: 4.5,
        co2ReducedKg: 13.3,
        paperBagsSaved: 19,
        ecoDeliveries: 35,
        greenOrders: 29,
        monthlyProgress: 88.0,
        yearlyProgress: 68.0,
        treesEquivalent: 3.8,
        level: 'Earth Champion',
      },
    });

    return { status: 'success', data: updated };
  }
}
