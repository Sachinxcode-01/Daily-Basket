import { Module } from '@nestjs/common';
import { OrdersController } from './orders.controller';
import { OrdersService } from './orders.service';
import { OrderPricingService } from './order-pricing.service';
import { RedisModule } from '../redis/redis.module';
import { EventsModule } from '../events/events.module';
import { QueueModule } from '../queue/queue.module';
import { CouponsModule } from '../coupons/coupons.module';

@Module({
  imports: [RedisModule, EventsModule, QueueModule, CouponsModule],
  controllers: [OrdersController],
  providers: [OrdersService, OrderPricingService],
  exports: [OrdersService, OrderPricingService],
})
export class OrdersModule {}
