import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class RecommendationService {
  constructor(private readonly prisma: PrismaService, private readonly redis: RedisService) {}

  async getSimilarProducts(productId: string, limit = 6) {
    const cacheKey = `similar:${productId}:${limit}`;
    const cached = await this.redis.get<any>(cacheKey);
    if (cached) return cached;

    const product = await this.prisma.product.findUnique({
      where: { id: productId },
      select: { categoryId: true, brand: true, tags: true },
    });
    if (!product) return { data: [], similarProductIds: [] };

    // Same category
    let candidates: any[] = [];
    candidates = await this.prisma.product.findMany({
      where: { categoryId: product.categoryId },
      include: {
        variants: { include: { inventories: true } },
        category: true,
      },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });

    const similar = candidates
      .filter((p) => p.id !== productId)
      .map((p) => ({
        id: p.id,
        name: p.name,
        slug: p.slug,
        images: p.images,
        brand: p.brand,
        tags: p.tags,
        variantId: p.variants[0]?.id,
        price: p.variants[0]?.price ?? 45.0,
        mrp: p.variants[0]?.mrp ?? 50.0,
        stockStatus:
          (p.variants[0]?.inventories[0]?.stockQuantity ?? 0) > 10 ? 'IN_STOCK' :
          (p.variants[0]?.inventories[0]?.stockQuantity ?? 0) > 0 ? 'LOW_STOCK' : 'OUT_OF_STOCK',
        stockQuantity: p.variants[0]?.inventories[0]?.stockQuantity ?? 0,
        categoryName: p.category?.name,
        isSameBrand: !!product.brand && p.brand === product.brand,
      }))
      .slice(0, limit);

    await this.redis.set(cacheKey, similar, 300);
    return { data: similar };
  }

  async getFrequentlyBoughtTogether(productId: string, limit = 4) {
    const cacheKey = `fbt:${productId}:${limit}`;
    const cached = await this.redis.get<any>(cacheKey);
    if (cached) return cached;

    // Same category — what other customers commonly buy alongside this one
    const product = await this.prisma.product.findUnique({
      where: { id: productId },
      select: { categoryId: true, name: true },
    });
    if (!product) return { data: [] };

    const products = await this.prisma.product.findMany({
      where: { categoryId: product.categoryId },
      include: {
        variants: { include: { inventories: true } },
        category: true,
      },
      orderBy: { createdAt: 'desc' },
      take: 80,
    });

    const seenIds = new Set([productId]);
    const topProducts = products
      .filter((p) => !seenIds.has(p.id))
      .map((p) => ({
        id: p.id,
        name: p.name,
        slug: p.slug,
        images: p.images,
        brand: p.brand,
        tags: p.tags,
        variantId: p.variants[0]?.id,
        price: p.variants[0]?.price ?? 45.0,
        mrp: p.variants[0]?.mrp ?? 50.0,
        stockStatus:
          (p.variants[0]?.inventories[0]?.stockQuantity ?? 0) > 10 ? 'IN_STOCK' :
          (p.variants[0]?.inventories[0]?.stockQuantity ?? 0) > 0 ? 'LOW_STOCK' : 'OUT_OF_STOCK',
        stockQuantity: p.variants[0]?.inventories[0]?.stockQuantity ?? 0,
        inCategory: true,
      }))
      .slice(0, limit);

    const result = { data: topProducts };
    await this.redis.set(cacheKey, result, 300);
    return result;
  }
}
