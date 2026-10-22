import { Module } from '@nestjs/common';
import { OrdersController } from './orders.controller';
import { OrdersService } from './orders.service';
import { OrderPricingService } from './order-pricing.service';
import { SubstitutionsService } from './substitutions.service';
import { RedisModule } from '../redis/redis.module';
import { EventsModule } from '../events/events.module';
import { QueueModule } from '../queue/queue.module';
import { CouponsModule } from '../coupons/coupons.module';
import { InventoryModule } from '../inventory/inventory.module';
import { MultiStoreModule } from '../multi-store/multi-store.module';

@Module({
  imports: [
    RedisModule,
    EventsModule,
    QueueModule,
    CouponsModule,
    InventoryModule,
    MultiStoreModule,
  ],
  controllers: [OrdersController],
  providers: [OrdersService, OrderPricingService, SubstitutionsService],
  exports: [OrdersService, OrderPricingService, SubstitutionsService],
})
export class OrdersModule {}
