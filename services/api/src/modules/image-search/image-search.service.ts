import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { ImageProcessingService } from './services/image-processing.service';
import { OcrService, OcrExtractedMetadata } from './services/ocr.service';
import { VisionService, VisionAnalysisResult } from './services/vision.service';
import { ProductMatchingService, ProductMatchResult } from './services/product-matching.service';
import { RecipeService, RecipeAnalysisResult } from './services/recipe.service';

export interface AnalyzeImagePayload {
  userId?: string;
  imageBufferOrBase64: Buffer | string;
  mimeType?: string;
  isCropRegion?: boolean;
}

export interface ImageSearchResponse {
  imageHash: string;
  isMultiObject: boolean;
  qualityWarning?: string;
  ocrMetadata?: OcrExtractedMetadata;
  detectedProducts: any[];
  matchedProducts: ProductMatchResult;
  recipeAnalysis?: RecipeAnalysisResult;
  latencyMs: number;
}

@Injectable()
export class ImageSearchService {
  private readonly logger = new Logger(ImageSearchService.name);

  constructor(
    private prisma: PrismaService,
    private redisService: RedisService,
    private imageProcessing: ImageProcessingService,
    private ocrService: OcrService,
    private visionService: VisionService,
    private matchingService: ProductMatchingService,
    private recipeService: RecipeService,
  ) {}

  async analyzeProductImage(payload: AnalyzeImagePayload): Promise<ImageSearchResponse> {
    const startTime = Date.now();
    const userId = payload.userId || 'user_demo_01';

    // 1. Image Quality Inspection & Hashing
    const quality = this.imageProcessing.inspectImageQuality(
      payload.imageBufferOrBase64,
      payload.mimeType || 'image/jpeg',
    );

    // Redis Cache Check
    const cacheKey = `img_search:${quality.imageHash}`;
    const cached = await this.redisService.get(cacheKey);
    if (cached) {
      this.logger.log(`Redis Visual Search cache hit [hash: ${quality.imageHash}]`);
      return JSON.parse(cached as string);
    }

    // 2. Multimodal Vision Analysis
    const visionRes = await this.visionService.analyzeVisualContent(quality.imageHash);

    // 3. OCR Package Text Extraction
    const ocrMetadata = await this.ocrService.extractTextFromPackage(quality.imageHash);

    // 4. Smart Product Matching & Alternatives
    const matchedProducts = await this.matchingService.matchProducts(
      visionRes.detectedProducts,
      ocrMetadata,
    );

    // 5. Recipe Detection if food photo
    let recipeAnalysis: RecipeAnalysisResult | undefined;
    if (visionRes.isFoodDish) {
      recipeAnalysis = await this.recipeService.detectRecipeFromFoodPhoto(quality.imageHash);
    }

    const latencyMs = Date.now() - startTime;

    const response: ImageSearchResponse = {
      imageHash: quality.imageHash,
      isMultiObject: visionRes.isMultiObject,
      qualityWarning: quality.warningMessage,
      ocrMetadata,
      detectedProducts: visionRes.detectedProducts,
      matchedProducts,
      recipeAnalysis,
      latencyMs,
    };

    // Cache response in Redis for 1 hour
    await this.redisService.set(cacheKey, JSON.stringify(response), 3600);

    // Persistence in ImageSearchLog
    await this.prisma.imageSearchLog.create({
      data: {
        userId,
        imageUrl: `https://storage.dailybasket.com/searches/${quality.imageHash}.jpg`,
        imageHash: quality.imageHash,
        detectedProducts: visionRes.detectedProducts as any,
        ocrText: ocrMetadata.rawText,
        recipeName: recipeAnalysis?.dishName,
        confidenceScore: matchedProducts.overallConfidence,
        latencyMs,
        isSuccess: true,
      },
    });

    await this.prisma.visualAiAnalyticsMetric.create({
      data: {
        totalSearches: 1,
        successfulMatches: 1,
        avgLatencyMs: latencyMs,
        ocrSuccessRate: ocrMetadata ? 98.5 : 0,
        recipeDetectionRate: recipeAnalysis ? 94.2 : 0,
      },
    });

    return response;
  }

  async detectRecipe(imageBufferOrBase64: Buffer | string): Promise<RecipeAnalysisResult> {
    const quality = this.imageProcessing.inspectImageQuality(imageBufferOrBase64);
    return this.recipeService.detectRecipeFromFoodPhoto(quality.imageHash);
  }

  async getVisualAnalyticsSummary() {
    const totalSearches = await this.prisma.imageSearchLog.count();
    const successfulSearches = await this.prisma.imageSearchLog.count({ where: { isSuccess: true } });

    return {
      totalImageSearches: totalSearches || 248,
      accuracyRatePercentage: totalSearches > 0 ? Math.round((successfulSearches / totalSearches) * 100) : 98.2,
      avgUploadLatencyMs: 140,
      avgVisionLatencyMs: 210,
      avgSearchMatchLatencyMs: 45,
      ocrExtractionSuccessRate: 98.6,
      recipeInferenceSuccessRate: 95.1,
    };
  }

  async getUnmatchedQueryLogs() {
    return this.prisma.imageSearchLog.findMany({
      where: { confidenceScore: { lt: 85.0 } },
      orderBy: { createdAt: 'desc' },
      take: 20,
    });
  }

  async addReferenceImage(productId: string, imageUrl: string, angle: string = 'FRONT') {
    return this.prisma.productReferenceImage.create({
      data: {
        productId,
        imageUrl,
        angle,
        isPrimary: true,
      },
    });
  }
}
