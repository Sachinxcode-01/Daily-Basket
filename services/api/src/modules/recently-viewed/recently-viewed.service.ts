import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class RecentlyViewedService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  async get(limit = 12) {
    const userId = (this as any)._currentUserId || 'user-demo-customer-001';
    const items = await this.prisma.recentlyViewed.findMany({
      where: { userId },
      include: {
        product: {
          include: {
            category: true,
            variants: { include: { inventories: true } },
          },
        },
      },
      orderBy: { viewedAt: 'desc' },
      take: Math.min(limit, 50),
    });

    const formatted = items.map((rv) => {
      const v = rv.product.variants[0];
      const stock = v?.inventories[0]?.stockQuantity ?? 50;
      return {
        viewedAt: rv.viewedAt,
        id: rv.product.id,
        name: rv.product.name,
        slug: rv.product.slug,
        images: rv.product.images,
        brand: rv.product.brand,
        variantId: v?.id,
        price: v?.price ?? 45.0,
        mrp: v?.mrp ?? 50.0,
        stockStatus: stock > 10 ? 'IN_STOCK' : stock > 0 ? 'LOW_STOCK' : 'OUT_OF_STOCK',
        stockQuantity: stock,
        categoryName: rv.product.category?.name,
      };
    });

    return { data: formatted };
  }

  async track(userId: string, productId: string) {
    await this.prisma.recentlyViewed.upsert({
      where: { userId_productId: { userId, productId } },
      create: { userId, productId },
      update: {},
    });
    await this.redis.del(`recently-viewed:${userId}:*`);
    return { success: true };
  }

  async remove(id: string) {
    await this.prisma.recentlyViewed.delete({ where: { id } });
    return { status: 'REMOVED', id };
  }
}
