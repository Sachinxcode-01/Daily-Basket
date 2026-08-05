import { Module, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD, APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';

import configuration from './config/configuration';
import { envValidationSchema } from './config/env.validation';

import { PrismaService } from './database/prisma.service';
import { RequestContextMiddleware } from './common/middleware/request-context.middleware';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';

import { AuthModule } from './modules/auth/auth.module';
import { ProductsModule } from './modules/products/products.module';
import { OrdersModule } from './modules/orders/orders.module';
import { CategoriesModule } from './modules/categories/categories.module';
import { InventoryModule } from './modules/inventory/inventory.module';
import { HealthModule } from './modules/health/health.module';
import { RedisModule } from './modules/redis/redis.module';
import { UploadsModule } from './modules/uploads/uploads.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { SearchModule } from './modules/search/search.module';
import { CouponsModule } from './modules/coupons/coupons.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { DeliveryModule } from './modules/delivery/delivery.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { DeliveryPartnerModule } from './modules/delivery-partner/delivery-partner.module';
import { LoyaltyModule } from './modules/loyalty/loyalty.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { AiModule } from './modules/ai/ai.module';
import { EmailModule } from './modules/email/email.module';
import { UsersModule } from './modules/users/users.module';
import { ReferralsModule } from './modules/referrals/referrals.module';
import { ImpactModule } from './modules/impact/impact.module';
import { SupportModule } from './modules/support/support.module';
import { QuickBuyModule } from './modules/quick-buy/quick-buy.module';
import { StockAlertsModule } from './modules/stock-alerts/stock-alerts.module';
import { FinanceModule } from './modules/finance/finance.module';
import { MarketingModule } from './modules/marketing/marketing.module';
import { EventsModule } from './modules/events/events.module';
import { QueueModule } from './modules/queue/queue.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validationSchema: envValidationSchema,
    }),
    ThrottlerModule.forRoot([{ ttl: 60000, limit: 100 }]),
    HealthModule,
    RedisModule,
    UploadsModule,
    NotificationsModule,
    EventsModule,
    QueueModule,
    AuthModule,
    UsersModule,
    ReferralsModule,
    ProductsModule,
    OrdersModule,
    CategoriesModule,
    InventoryModule,
    SearchModule,
    CouponsModule,
    PaymentsModule,
    DeliveryModule,
    AnalyticsModule,
    DeliveryPartnerModule,
    LoyaltyModule,
    ReviewsModule,
    AiModule,
    EmailModule,
    ImpactModule,
    SupportModule,
    QuickBuyModule,
    StockAlertsModule,
    FinanceModule,
    MarketingModule,
  ],

  providers: [
    PrismaService,
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_INTERCEPTOR, useClass: TransformInterceptor },
    { provide: APP_INTERCEPTOR, useClass: LoggingInterceptor },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(RequestContextMiddleware).forRoutes('*');
  }
}
