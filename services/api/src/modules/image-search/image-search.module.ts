import { Module } from '@nestjs/common';
import { ImageSearchController } from './image-search.controller';
import { ImageSearchAdminController } from './image-search-admin.controller';
import { ImageSearchService } from './image-search.service';
import { ImageProcessingService } from './services/image-processing.service';
import { OcrService } from './services/ocr.service';
import { VisionService } from './services/vision.service';
import { ProductMatchingService } from './services/product-matching.service';
import { RecipeService } from './services/recipe.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisModule } from '../redis/redis.module';

@Module({
  imports: [RedisModule],
  controllers: [ImageSearchController, ImageSearchAdminController],
  providers: [
    ImageSearchService,
    ImageProcessingService,
    OcrService,
    VisionService,
    ProductMatchingService,
    RecipeService,
    PrismaService,
  ],
  exports: [
    ImageSearchService,
    ImageProcessingService,
    OcrService,
    VisionService,
    ProductMatchingService,
    RecipeService,
  ],
})
export class ImageSearchModule {}
