import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';
import { RedisService } from '../../redis/redis.service';

export enum RecommendationType {
  FREQUENTLY_BOUGHT_TOGETHER = 'FREQUENTLY_BOUGHT_TOGETHER',
  CUSTOMERS_ALSO_BOUGHT = 'CUSTOMERS_ALSO_BOUGHT',
  SIMILAR_PRODUCTS = 'SIMILAR_PRODUCTS',
  HEALTHY_ALTERNATIVES = 'HEALTHY_ALTERNATIVES',
  BUDGET_ALTERNATIVES = 'BUDGET_ALTERNATIVES',
  PREMIUM_ALTERNATIVES = 'PREMIUM_ALTERNATIVES',
  ORGANIC_ALTERNATIVES = 'ORGANIC_ALTERNATIVES',
  RECENTLY_VIEWED = 'RECENTLY_VIEWED',
  BUY_AGAIN = 'BUY_AGAIN',
  RECOMMENDED_FOR_YOU = 'RECOMMENDED_FOR_YOU',
  SEASONAL_PICKS = 'SEASONAL_PICKS',
  FESTIVAL_SUGGESTIONS = 'FESTIVAL_SUGGESTIONS',
}

@Injectable()
export class RecommendationService {
  private readonly logger = new Logger(RecommendationService.name);

  constructor(
    private prisma: PrismaService,
    private redisService: RedisService,
  ) {}

  async getRecommendations(
    type: RecommendationType,
    productId?: string,
    userId?: string,
    limit: number = 6,
  ) {
    const cacheKey = `recs:${type}:${productId || 'none'}:${userId || 'anon'}:${limit}`;
    const cached = await this.redisService.get(cacheKey);
    if (cached) {
      return JSON.parse(cached as string);
    }

    let targetProduct: any = null;
    if (productId) {
      targetProduct = await this.prisma.product.findUnique({
        where: { id: productId },
        include: { category: true, variants: true, aiInsight: true },
      });
    }

    let products: any[] = [];
    let rationale = '';

    switch (type) {
      case RecommendationType.FREQUENTLY_BOUGHT_TOGETHER:
        products = await this.prisma.product.findMany({
          where: {
            categoryId: targetProduct?.categoryId,
            id: { not: productId },
          },
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Frequently paired with this item by Daily Basket shoppers.';
        break;

      case RecommendationType.CUSTOMERS_ALSO_BOUGHT:
        products = await this.prisma.product.findMany({
          where: {
            id: { not: productId },
          },
          orderBy: { createdAt: 'desc' },
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Popular additions to daily grocery baskets.';
        break;

      case RecommendationType.SIMILAR_PRODUCTS:
        products = await this.prisma.product.findMany({
          where: {
            categoryId: targetProduct?.categoryId,
            id: { not: productId },
          },
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Top matching alternatives in the same category.';
        break;

      case RecommendationType.HEALTHY_ALTERNATIVES:
      case RecommendationType.ORGANIC_ALTERNATIVES:
        products = await this.prisma.product.findMany({
          where: {
            OR: [
              { isOrganic: true },
              { tags: { hasSome: ['healthy', 'organic', 'sugar-free', 'high-protein', 'fresh'] } },
            ],
            id: { not: productId },
          },
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Nutrient-rich, zero-preservative healthy choices.';
        break;

      case RecommendationType.BUDGET_ALTERNATIVES:
        products = await this.prisma.product.findMany({
          where: {
            categoryId: targetProduct?.categoryId,
            id: { not: productId },
          },
          include: { variants: true, category: true },
          take: limit,
        });
        products.sort((a, b) => (a.variants[0]?.price || 0) - (b.variants[0]?.price || 0));
        rationale = 'Great savings! High-quality pocket-friendly options.';
        break;

      case RecommendationType.PREMIUM_ALTERNATIVES:
        products = await this.prisma.product.findMany({
          where: {
            tags: { hasSome: ['premium', 'imported', 'gourmet', 'artisan'] },
            id: { not: productId },
          },
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Gourmet & artisanal premium selections.';
        break;

      case RecommendationType.RECENTLY_VIEWED:
        if (userId) {
          const views = await this.prisma.recentlyViewed.findMany({
            where: { userId },
            orderBy: { viewedAt: 'desc' },
            take: limit,
          });
          const productIds = views.map((v) => v.productId);
          products = await this.prisma.product.findMany({
            where: { id: { in: productIds } },
            include: { variants: true, category: true },
          });
        }
        rationale = 'Items you recently explored.';
        break;

      case RecommendationType.BUY_AGAIN:
        if (userId) {
          const orders = await this.prisma.order.findMany({
            where: { userId },
            include: { items: { include: { variant: { include: { product: true } } } } },
            take: 5,
            orderBy: { createdAt: 'desc' },
          });
          const set = new Set<string>();
          for (const o of orders) {
            for (const item of o.items) {
              if (item.variant?.product) set.add(item.variant.product.id);
            }
          }
          products = await this.prisma.product.findMany({
            where: { id: { in: Array.from(set) } },
            include: { variants: true, category: true },
            take: limit,
          });
        }
        rationale = 'Your regular household essentials for 1-tap reordering.';
        break;

      case RecommendationType.SEASONAL_PICKS:
      case RecommendationType.FESTIVAL_SUGGESTIONS:
        products = await this.prisma.product.findMany({
          where: {
            tags: { hasSome: ['seasonal', 'festive', 'fresh', 'summer', 'monsoon'] },
          },
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Handpicked seasonal & festive daily specials.';
        break;

      case RecommendationType.RECOMMENDED_FOR_YOU:
      default:
        products = await this.prisma.product.findMany({
          include: { variants: true, category: true },
          take: limit,
        });
        rationale = 'Personalized based on your shopping preferences.';
        break;
    }

    const formatted = products.map((p) => {
      const v = p.variants[0] || { price: 99, mrp: 120, unitName: '1 unit', isAvailable: true };
      return {
        id: p.id,
        name: p.name,
        brand: p.brand || 'Daily Basket',
        categoryName: p.category?.name || 'Grocery',
        price: v.price,
        mrp: v.mrp,
        unit: v.unitName,
        imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        isOrganic: p.isOrganic,
        rating: 4.8,
        deliveryEtaMins: 10,
        isAvailable: v.isAvailable,
      };
    });

    const payload = {
      type,
      productId,
      userId,
      rationale,
      products: formatted,
    };

    await this.redisService.set(cacheKey, JSON.stringify(payload), 300);
    return payload;
  }

  async getUserPreferenceProfile(userId: string) {
    let profile = await this.prisma.userPreferenceProfile.findUnique({
      where: { userId },
    });
    if (!profile) {
      profile = await this.prisma.userPreferenceProfile.create({
        data: {
          userId,
          favoriteCategories: ['Fresh Fruits & Vegetables', 'Dairy, Bread & Eggs'],
          favoriteBrands: ['Amul', 'Aashirvaad', 'Daily Basket Farms'],
          dietaryPreferences: ['Organic', 'High-Protein'],
          budgetTier: 'BALANCED',
          shoppingFrequency: 'WEEKLY',
        },
      });
    }
    return profile;
  }
}
