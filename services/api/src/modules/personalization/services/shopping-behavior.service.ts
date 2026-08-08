import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

export interface CustomerBehaviorProfile {
  userId: string;
  topCategories: string[];
  topBrands: string[];
  budgetTier: 'BUDGET' | 'BALANCED' | 'PREMIUM';
  dietaryPreference: string;
  averageOrderIntervalDays: number;
  timeOfDayPreference: 'MORNING' | 'AFTERNOON' | 'EVENING';
}

@Injectable()
export class ShoppingBehaviorService {
  private readonly logger = new Logger(ShoppingBehaviorService.name);

  constructor(private prisma: PrismaService) {}

  async getBehaviorProfile(userId: string): Promise<CustomerBehaviorProfile> {
    const userProfile = await this.prisma.userPreferenceProfile.findUnique({
      where: { userId },
    });

    const ordersCount = await this.prisma.order.count({ where: { userId } });

    return {
      userId,
      topCategories: userProfile?.favoriteCategories || ['Dairy', 'Atta & Flours', 'Fresh Vegetables'],
      topBrands: userProfile?.favoriteBrands || ['Amul', 'Aashirvaad', 'Fortune'],
      budgetTier: (userProfile?.budgetTier as any) || 'BALANCED',
      dietaryPreference: userProfile?.dietaryPreferences[0] || 'Organic & Healthy',
      averageOrderIntervalDays: ordersCount > 5 ? 4 : 7,
      timeOfDayPreference: new Date().getHours() < 12 ? 'MORNING' : 'EVENING',
    };
  }
}
