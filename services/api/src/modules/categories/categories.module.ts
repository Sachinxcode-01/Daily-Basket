import { Module } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { CategoriesController } from './categories.controller';
import { PrismaService } from '../../database/prisma.service';
import { RedisModule } from '../redis/redis.module';

@Module({
  imports: [RedisModule],
  controllers: [CategoriesController],
  providers: [CategoriesService, PrismaService],
  exports: [CategoriesService],
})
export class CategoriesModule {}
