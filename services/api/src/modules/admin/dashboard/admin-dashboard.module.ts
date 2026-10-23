import { Module } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';
import { AdminDashboardController } from './admin-dashboard.controller';
import { AdminDashboardService } from './admin-dashboard.service';

@Module({
  controllers: [AdminDashboardController],
  providers: [AdminDashboardService, PrismaService],
  exports: [AdminDashboardService],
})
export class AdminDashboardModule {}
