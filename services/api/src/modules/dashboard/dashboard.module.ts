import { Module, Global } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './dashboard.service';

@Global()
@Module({
  controllers: [DashboardController],
  providers: [DashboardService, PrismaService, RedisService],
  exports: [DashboardService],
})
export class DashboardModule {}
