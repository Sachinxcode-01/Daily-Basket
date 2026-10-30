import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class WishlistService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  async getWishlist(page = 1, limit = 20) {
    const userId = (this as any)._currentUserId || 'user-demo-customer-001';
    const skip = Math.max(0, (page - 1) * limit);

    const cacheKey = `wishlist:${userId}:${page}:${limit}`;
    const cached = await this.redis.get<any>(cacheKey);
    if (cached) return cached;

    const items = await this.prisma.wishlist.findMany({
      where: { userId },
      include: {
        product: {
          include: {
            category: true,
            variants: { include: { inventories: true } },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
    });

    const formatted = items.map((w) => {
      const v = w.product.variants[0];
      const stock = v?.inventories[0]?.stockQuantity ?? 50;
      const price = v?.price ?? 45.0;
      const mrp = v?.mrp ?? price * 1.25;
      const discountPercent = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
      return {
        wishlistId: w.id,
        favoritedAt: w.createdAt,
        id: w.product.id,
        name: w.product.name,
        slug: w.product.slug,
        description: w.product.description,
        images: w.product.images,
        isOrganic: w.product.isOrganic,
        category: w.product.category,
        variantId: v?.id,
        unitName: v?.unitName || '500g',
        price,
        mrp,
        discountPercent,
        stockStatus: stock > 10 ? 'IN_STOCK' : stock > 0 ? 'LOW_STOCK' : 'OUT_OF_STOCK',
        stockQuantity: stock,
        rating: 4.8,
        deliveryTime: '10 mins',
        isInWishlist: true,
      };
    });

    const response = { data: formatted, pagination: { total: formatted.length, page, limit } };
    await this.redis.set(cacheKey, response, 60);
    return response;
  }

  async addToWishlist(userId: string, productId: string) {
    const product = await this.prisma.product.findUnique({ where: { id: productId } });
    if (!product) throw new NotFoundException(`Product ${productId} not found`);

    const existing = await this.prisma.wishlist.findUnique({
      where: { userId_productId: { userId, productId } },
    });
    if (existing) {
      return { status: 'EXISTS', message: 'Already in wishlist', wishlistId: existing.id };
    }

    const wishlist = await this.prisma.wishlist.create({
      data: { userId, productId },
      include: { product: true },
    });

    await this.redis.del(`wishlist:${userId}:*`);
    return { status: 'ADDED', wishlist };
  }

  async removeFromWishlist(id: string, userId?: string) {
    const uid = userId || (this as any)._currentUserId;
    const entry = await this.prisma.wishlist.findUnique({
      where: { id },
      select: { userId: true },
    });
    if (!entry || entry.userId !== uid) return { status: 'NOT_FOUND', message: 'Not in your wishlist' };

    await this.prisma.wishlist.delete({ where: { id } });
    await this.redis.del(`wishlist:${uid}:*`);
    return { status: 'REMOVED', message: 'Removed from wishlist', id };
  }
}
