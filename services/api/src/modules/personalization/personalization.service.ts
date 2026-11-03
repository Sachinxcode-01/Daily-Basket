import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RecommendationEngine } from './recommendation.engine';
import { ShoppingBehaviorService } from './services/shopping-behavior.service';
import { SmartBasketService } from './services/smart-basket.service';
import { CustomerInsightsService } from './services/customer-insights.service';
import { RecipeRecommendationService } from './services/recipe-recommendation.service';

@Injectable()
export class PersonalizationService {
  private readonly logger = new Logger(PersonalizationService.name);

  constructor(
    private prisma: PrismaService,
    private recEngine: RecommendationEngine,
    private behaviorService: ShoppingBehaviorService,
    private smartBasketService: SmartBasketService,
    private insightsService: CustomerInsightsService,
    private recipeService: RecipeRecommendationService,
  ) {}

  async getPersonalizedHomeFeed(userId: string = 'user_demo_01') {
    const hour = new Date().getHours();
    const greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';

    const behavior = await this.behaviorService.getBehaviorProfile(userId);
    const weeklyBasket = await this.smartBasketService.generateSmartWeeklyBasket(userId);

    const [recommended, trending, healthy, deals] = await Promise.all([
      this.recEngine.generatePersonalizedSection('RECOMMENDED_FOR_YOU', userId, 6),
      this.recEngine.generatePersonalizedSection('TRENDING_NEAR_YOU', userId, 6),
      this.recEngine.generatePersonalizedSection('HEALTHY_CHOICES', userId, 6),
      this.recEngine.generatePersonalizedSection('TODAYS_DEALS', userId, 6),
    ]);

    return {
      greeting: `${greeting}, ${userId.split('_')[0]}!`,
      behaviorSummary: behavior,
      weeklyBasket: weeklyBasket.items,
      sections: {
        recommendedForYou: recommended.products,
        trendingNearYou: trending.products,
        healthyChoices: healthy.products,
        todaysDeals: deals.products,
      },
    };
  }

  async getSmartReorderList(userId: string = 'user_demo_01') {
    const dbProducts = await this.prisma.product.findMany({
      take: 4,
      include: { variants: true },
    });

    return dbProducts.map((p) => ({
      productId: p.id,
      name: p.name,
      brand: p.brand || 'Daily Basket',
      price: p.variants[0]?.price || 56,
      unit: p.variants[0]?.unitName || '1 unit',
      imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      daysLeftEstimate: Math.floor(Math.random() * 3) + 1,
      status: 'RUNNING_LOW',
    }));
  }

  async getCustomerInsights(userId: string = 'user_demo_01') {
    return this.insightsService.getCustomerInsights(userId);
  }

  async getGroceryLists(userId: string = 'user_demo_01') {
    return this.prisma.groceryList.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async createGroceryList(userId: string = 'user_demo_01', name: string, items: any[]) {
    return this.prisma.groceryList.create({
      data: {
        userId,
        name,
        type: 'CUSTOM',
        items: items as any,
        isRecurring: true,
        reminderFrequency: 'WEEKLY',
      },
    });
  }

  async getPersonalizedOffers(userId: string = 'user_demo_01') {
    let offers = await this.prisma.personalizedOffer.findMany({
      where: { userId, isRedeemed: false },
    });

    if (offers.length === 0) {
      const createdOffer = await this.prisma.personalizedOffer.create({
        data: {
          userId,
          code: `MYAMUL${Math.floor(Math.random() * 1000)}`,
          title: '15% Off Your Favorite Amul Dairy Basket',
          discountPercent: 15.0,
          maxDiscount: 150.0,
          targetReason: 'FAVORITE_BRAND',
          expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        },
      });
      offers = [createdOffer];
    }

    return offers;
  }

  async getRecommendationsByRecentlyViewed(
    recentlyViewedIds: string[] = [],
    category?: string,
    limit: number = 6,
  ) {
    try {
      let categoryFilter: any = {};
      if (recentlyViewedIds.length > 0) {
        const viewedProducts = await this.prisma.product.findMany({
          where: { id: { in: recentlyViewedIds } },
          select: { categoryId: true },
        });
        const categoryIds = viewedProducts.map((p) => p.categoryId).filter(Boolean);
        if (categoryIds.length > 0) {
          categoryFilter = { categoryId: { in: categoryIds } };
        }
      }

      const products = await this.prisma.product.findMany({
        where: {
          ...categoryFilter,
          ...(recentlyViewedIds.length > 0 ? { id: { notIn: recentlyViewedIds } } : {}),
        },
        take: limit,
        include: { variants: true, category: true, aiInsight: true },
        orderBy: { createdAt: 'desc' },
      });

      if (products.length > 0) {
        return {
          success: true,
          reason: recentlyViewedIds.length > 0
            ? 'Based on products you recently explored'
            : 'Popular daily recommendations for you',
          items: products.map((p) => ({
            id: p.id,
            name: p.name,
            brand: p.brand || 'Daily Basket',
            category: p.category?.name || 'Grocery',
            price: `₹${p.variants[0]?.price || 56}`,
            mrp: `₹${p.variants[0]?.mrp || 65}`,
            unit: p.variants[0]?.unitName || '1 unit',
            imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
            rating: 4.8,
            badgeType: 'AI Pick',
          })),
        };
      }
    } catch {
      // Fallback
    }

    return {
      success: true,
      reason: recentlyViewedIds.length > 0
        ? 'Curated pairings based on your active browsing'
        : 'Smart AI picks for fresh daily groceries',
      items: [
        {
          id: 'rec_avocado',
          name: 'Organic Hass Avocados (2 pcs)',
          brand: 'Daily Basket Organics',
          category: 'Fruits & Vegetables',
          price: '₹180',
          mrp: '₹220',
          unit: '400g',
          imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300',
          rating: 4.9,
          badgeType: 'Fresh Harvest',
        },
        {
          id: 'rec_milk',
          name: 'A2 Farm Fresh Cow Milk 1L',
          brand: 'Daily Basket Dairy',
          category: 'Dairy & Breakfast',
          price: '₹75',
          mrp: '₹85',
          unit: '1 Litre',
          imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300',
          rating: 4.8,
          badgeType: 'Daily Staple',
        },
        {
          id: 'rec_bread',
          name: 'Artisan Whole Wheat Sourdough',
          brand: 'Daily Basket Bakery',
          category: 'Bakery & Snacks',
          price: '₹65',
          mrp: '₹80',
          unit: '400g Loaf',
          imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
          rating: 4.7,
          badgeType: 'Baked Fresh',
        },
      ],
    };
  }

  async getPersonalizationAnalyticsSummary() {
    return {
      recommendationCtrPercentage: 14.8,
      recommendationConversionRate: 8.4,
      repeatPurchaseRate: 68.2,
      averageBasketSize: 620,
      customerLifetimeValueAvg: 14500,
      churnRiskLowCount: 1420,
      churnRiskHighCount: 38,
    };
  }
}
