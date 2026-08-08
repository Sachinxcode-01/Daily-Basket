import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class RecommendationEngine {
  private readonly logger = new Logger(RecommendationEngine.name);

  constructor(
    private prisma: PrismaService,
    private redisService: RedisService,
  ) {}

  async generatePersonalizedSection(
    sectionKey: string,
    userId: string = 'user_demo_01',
    limit: number = 6,
  ) {
    const startTime = Date.now();
    const cacheKey = `recs:engine:${sectionKey}:${userId}:${limit}`;
    const cached = await this.redisService.get(cacheKey);
    if (cached) {
      return JSON.parse(cached as string);
    }

    const products = await this.prisma.product.findMany({
      take: limit,
      include: { variants: true, category: true, aiInsight: true },
      orderBy: { createdAt: 'desc' },
    });

    const formatted = products.map((p) => ({
      id: p.id,
      name: p.name,
      brand: p.brand || 'Daily Basket',
      category: p.category?.name || 'Grocery',
      price: p.variants[0]?.price || 56,
      mrp: p.variants[0]?.mrp || 65,
      unit: p.variants[0]?.unitName || '1 unit',
      imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      isOrganic: p.isOrganic,
      healthScore: p.aiInsight?.healthScore || 8.5,
      recommendationReason: `Picked for you based on ${sectionKey.replace(/_/g, ' ').toLowerCase()}`,
    }));

    const result = {
      sectionKey,
      products: formatted,
      latencyMs: Date.now() - startTime,
    };

    await this.redisService.set(cacheKey, JSON.stringify(result), 1800); // 30 min TTL
    return result;
  }
}
