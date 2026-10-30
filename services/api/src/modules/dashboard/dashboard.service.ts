import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class DashboardService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  async getOverview() {
    const cacheKey = 'dashboard:overview';
    const cached = await this.redis.get<any>(cacheKey);
    if (cached) return cached;

    const [orderCount, revenue, lowStockProducts] = await Promise.all([
      this.prisma.orders.count(),
      this.prisma.orders.aggregate({ _sum: { total: true }, where: { status: 'DELIVERED' } }),
      this.prisma.productVariant.count({
        where: { inventories: { some: { stockQuantity: { lt: 10 } } } },
      }),
    ]);

    const result = {
      totalOrders: orderCount,
      revenue: revenue._sum.total ?? 0,
      lowStockCount: lowStockProducts,
    };

    await this.redis.set(cacheKey, result, 60);
    return result;
  }

  async getRecentOrders(limit = 20) {
    const orders = await this.prisma.orders.findMany({
      take: Math.min(limit, 50),
      orderBy: { createdAt: 'desc' },
      include: { items: true, user: { select: { id: true, name: true } } },
    });

    return { orders: orders.map((o) => ({
      id: o.id,
      status: o.status,
      total: o.total,
      createdAt: o.createdAt,
      itemsCount: o.items.length,
      customerName: o.user?.name ?? 'Unknown',
    })) };
  }
}
