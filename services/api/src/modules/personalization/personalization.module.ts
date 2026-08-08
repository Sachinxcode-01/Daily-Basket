import { Module } from '@nestjs/common';
import { PersonalizationController } from './personalization.controller';
import { PersonalizationAdminController } from './personalization-admin.controller';
import { PersonalizationService } from './personalization.service';
import { RecommendationEngine } from './recommendation.engine';
import { ShoppingBehaviorService } from './services/shopping-behavior.service';
import { SmartBasketService } from './services/smart-basket.service';
import { CustomerInsightsService } from './services/customer-insights.service';
import { RecipeRecommendationService } from './services/recipe-recommendation.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisModule } from '../redis/redis.module';

@Module({
  imports: [RedisModule],
  controllers: [PersonalizationController, PersonalizationAdminController],
  providers: [
    PersonalizationService,
    RecommendationEngine,
    ShoppingBehaviorService,
    SmartBasketService,
    CustomerInsightsService,
    RecipeRecommendationService,
    PrismaService,
  ],
  exports: [
    PersonalizationService,
    RecommendationEngine,
    ShoppingBehaviorService,
    SmartBasketService,
    CustomerInsightsService,
    RecipeRecommendationService,
  ],
})
export class PersonalizationModule {}
