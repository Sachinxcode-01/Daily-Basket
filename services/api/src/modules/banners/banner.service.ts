import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class BannerService {
  constructor(private readonly prisma: PrismaService, private readonly redis: RedisService) {}

  async getActiveBanners() {
    const cacheKey = 'banners:active';
    const cached = await this.redis.get<any>(cacheKey);
    if (cached) return cached;

    const banners = await this.prisma.banner.findMany({
      where: { isActive: true },
      orderBy: { position: 'asc' },
    });
    await this.redis.set(cacheKey, banners, 300);
    return banners;
  }
}
