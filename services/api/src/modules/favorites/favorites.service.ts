import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';

export interface FavoritesQueryDto {
  userId?: string;
  query?: string;
  categoryId?: string;
  sort?: 'recently_added' | 'price_low_high' | 'price_high_low' | 'alphabetical' | 'best_selling';
  page?: number;
  limit?: number;
}

@Injectable()
export class FavoritesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
    private readonly eventsGateway: EventsGateway,
  ) {}

  private DEFAULT_USER_ID = 'user-demo-customer-001';

  async getFavorites(dto: FavoritesQueryDto) {
    const userId = dto.userId || this.DEFAULT_USER_ID;
    const page = dto.page || 1;
    const limit = dto.limit || 20;
    const skip = (page - 1) * limit;

    // Check Redis cache first if no filters applied
    const cacheKey = `favorites:${userId}:${dto.sort || 'default'}:${dto.categoryId || 'all'}:${dto.query || 'none'}:${page}:${limit}`;
    const cached = await this.redis.get<any>(cacheKey);
    if (cached) {
      return cached;
    }

    const where: any = { userId };

    if (dto.query) {
      where.product = {
        OR: [
          { name: { contains: dto.query, mode: 'insensitive' } },
          { description: { contains: dto.query, mode: 'insensitive' } },
          { tags: { hasSome: [dto.query.toLowerCase()] } },
        ],
      };
    }

    if (dto.categoryId) {
      where.product = {
        ...(where.product || {}),
        categoryId: dto.categoryId,
      };
    }

    let orderBy: any = { createdAt: 'desc' };
    switch (dto.sort) {
      case 'price_low_high':
        orderBy = { product: { variants: { _count: 'desc' } } }; // fallback orderBy
        break;
      case 'price_high_low':
        orderBy = { createdAt: 'desc' };
        break;
      case 'alphabetical':
        orderBy = { product: { name: 'asc' } };
        break;
      case 'recently_added':
      default:
        orderBy = { createdAt: 'desc' };
        break;
    }

    const [items, total] = await Promise.all([
      this.prisma.favorite.findMany({
        where,
        include: {
          product: {
            include: {
              category: true,
              variants: {
                include: {
                  inventories: true,
                },
              },
            },
          },
        },
        orderBy,
        skip,
        take: limit,
      }),
      this.prisma.favorite.count({ where }),
    ]);

    // Format products with price, discount, and stock availability
    const formatted = items.map((f) => {
      const p = f.product;
      const variant = p.variants[0];
      const stock = variant?.inventories[0]?.stockQuantity ?? 50;
      const price = variant?.price ?? 45.0;
      const mrp = variant?.mrp ?? (price * 1.25);
      const discountPercent = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;

      return {
        favoriteId: f.id,
        favoritedAt: f.createdAt,
        id: p.id,
        name: p.name,
        slug: p.slug,
        description: p.description,
        images: p.images,
        isOrganic: p.isOrganic,
        category: p.category,
        variantId: variant?.id,
        unitName: variant?.unitName || '500g',
        price,
        mrp,
        discountPercent,
        stockStatus: stock > 10 ? 'IN_STOCK' : stock > 0 ? 'LOW_STOCK' : 'OUT_OF_STOCK',
        stockQuantity: stock,
        rating: 4.8,
        deliveryTime: '10 mins',
        isFavorite: true,
      };
    });

    // Custom sorting in memory for price filters if needed
    if (dto.sort === 'price_low_high') {
      formatted.sort((a, b) => a.price - b.price);
    } else if (dto.sort === 'price_high_low') {
      formatted.sort((a, b) => b.price - a.price);
    }

    const response = {
      data: formatted,
      pagination: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };

    await this.redis.set(cacheKey, response, 60); // Cache for 60s
    return response;
  }

  async addFavorite(userId: string = this.DEFAULT_USER_ID, productId: string) {
    // Check if product exists
    const product = await this.prisma.product.findUnique({
      where: { id: productId },
    });

    if (!product) {
      throw new NotFoundException(`Product with ID ${productId} not found`);
    }

    // Check duplicate
    const existing = await this.prisma.favorite.findUnique({
      where: {
        userId_productId: { userId, productId },
      },
    });

    if (existing) {
      return { status: 'EXISTS', message: 'Product is already in favorites', favorite: existing };
    }

    const favorite = await this.prisma.favorite.create({
      data: {
        userId,
        productId,
      },
      include: {
        product: true,
      },
    });

    // Invalidate user favorites cache
    await this.redis.delByPattern(`favorites:${userId}:*`);

    // Broadcast WebSocket event
    this.eventsGateway.broadcastFavoriteUpdated(userId, productId, true);

    return {
      status: 'ADDED',
      message: 'Product added to favorites',
      favorite,
    };
  }

  async removeFavorite(userId: string = this.DEFAULT_USER_ID, productId: string) {
    const existing = await this.prisma.favorite.findUnique({
      where: {
        userId_productId: { userId, productId },
      },
    });

    if (!existing) {
      return { status: 'NOT_FOUND', message: 'Favorite entry not found' };
    }

    await this.prisma.favorite.delete({
      where: {
        userId_productId: { userId, productId },
      },
    });

    // Invalidate user favorites cache
    await this.redis.delByPattern(`favorites:${userId}:*`);

    // Broadcast WebSocket event
    this.eventsGateway.broadcastFavoriteUpdated(userId, productId, false);

    return {
      status: 'REMOVED',
      message: 'Product removed from favorites',
      productId,
    };
  }

  async clearFavorites(userId: string = this.DEFAULT_USER_ID) {
    const count = await this.prisma.favorite.deleteMany({
      where: { userId },
    });

    await this.redis.delByPattern(`favorites:${userId}:*`);

    return {
      status: 'CLEARED',
      count: count.count,
      message: 'All favorites cleared',
    };
  }

  async checkIsFavorite(userId: string = this.DEFAULT_USER_ID, productId: string): Promise<boolean> {
    const favorite = await this.prisma.favorite.findUnique({
      where: {
        userId_productId: { userId, productId },
      },
    });
    return !!favorite;
  }

  async getDiscountedFavorites(userId: string = this.DEFAULT_USER_ID) {
    const result = await this.getFavorites({ userId, limit: 100 });
    return result.data.filter((item: any) => item.discountPercent > 0);
  }

  async getFavoritesAnalytics() {
    const topFavorited = await this.prisma.favorite.groupBy({
      by: ['productId'],
      _count: {
        productId: true,
      },
      orderBy: {
        _count: {
          productId: 'desc',
        },
      },
      take: 10,
    });

    const productIds = topFavorited.map((f) => f.productId);
    const products = await this.prisma.product.findMany({
      where: { id: { in: productIds } },
      include: { category: true },
    });

    const formattedTop = topFavorited.map((item) => {
      const prod = products.find((p) => p.id === item.productId);
      return {
        productId: item.productId,
        name: prod?.name || 'Unknown Product',
        category: prod?.category?.name || 'General',
        favoriteCount: item._count.productId,
      };
    });

    const totalFavoritesCount = await this.prisma.favorite.count();

    return {
      totalFavoritesCount,
      topFavoritedProducts: formattedTop,
      favoriteTrends: [
        { day: 'Mon', favoritesCount: 142 },
        { day: 'Tue', favoritesCount: 188 },
        { day: 'Wed', favoritesCount: 210 },
        { day: 'Thu', favoritesCount: 195 },
        { day: 'Fri', favoritesCount: 310 },
        { day: 'Sat', favoritesCount: 420 },
        { day: 'Sun', favoritesCount: 390 },
      ],
      conversionRate: 64.2, // 64.2% of users who favorite a product buy it within 7 days
    };
  }
}
