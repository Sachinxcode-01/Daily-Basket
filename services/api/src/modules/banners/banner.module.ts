import { Module } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { BannerController } from './banner.controller';
import { BannerService } from './banner.service';

@Module({
  controllers: [BannerController],
  providers: [BannerService, PrismaService, RedisService],
  exports: [BannerService],
})
export class BannerModule {}
