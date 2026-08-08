import { Test, TestingModule } from '@nestjs/testing';
import { ImageSearchService } from './image-search.service';
import { ImageProcessingService } from './services/image-processing.service';
import { OcrService } from './services/ocr.service';
import { VisionService } from './services/vision.service';
import { ProductMatchingService } from './services/product-matching.service';
import { RecipeService } from './services/recipe.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

describe('ImageSearchService', () => {
  let service: ImageSearchService;

  const mockPrismaService = {
    imageSearchLog: {
      create: jest.fn().mockResolvedValue({ id: 'log_1' }),
      count: jest.fn().mockResolvedValue(10),
      findMany: jest.fn().mockResolvedValue([]),
    },
    visualAiAnalyticsMetric: {
      create: jest.fn().mockResolvedValue({ id: 'vam_1' }),
    },
    productReferenceImage: {
      create: jest.fn().mockResolvedValue({ id: 'pri_1', productId: 'p1' }),
    },
  };

  const mockRedisService = {
    get: jest.fn().mockResolvedValue(null),
    set: jest.fn().mockResolvedValue('OK'),
  };

  const mockImageProcessing = {
    inspectImageQuality: jest.fn().mockReturnValue({
      isValid: true,
      imageHash: 'hash_abc123',
      isBlurry: false,
      isLowLight: false,
      mimeType: 'image/jpeg',
    }),
  };

  const mockOcrService = {
    extractTextFromPackage: jest.fn().mockResolvedValue({
      rawText: 'Amul Taaza Milk 1L',
      brand: 'Amul',
      mrp: 56,
      weight: '1L',
      confidenceScore: 98.0,
    }),
  };

  const mockVisionService = {
    analyzeVisualContent: jest.fn().mockResolvedValue({
      isMultiObject: false,
      detectedProducts: [
        {
          id: 'd1',
          detectedName: 'Amul Milk 1L',
          brand: 'Amul',
          category: 'Dairy',
          confidenceScore: 98.0,
          boundingBox: { xMin: 0, yMin: 0, xMax: 1, yMax: 1 },
        },
      ],
      isFoodDish: false,
      primaryCategory: 'Dairy',
      latencyMs: 120,
    }),
  };

  const mockMatchingService = {
    matchProducts: jest.fn().mockResolvedValue({
      exactMatch: { id: 'p1', name: 'Amul Taaza Milk 1L', price: 56 },
      similarProducts: [],
      healthyAlternatives: [],
      budgetAlternatives: [],
      organicAlternatives: [],
      matchType: 'EXACT',
      overallConfidence: 98.0,
    }),
  };

  const mockRecipeService = {
    detectRecipeFromFoodPhoto: jest.fn().mockResolvedValue({
      dishName: 'Paneer Butter Masala',
      cuisine: 'Indian',
      ingredients: [],
    }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ImageSearchService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: RedisService, useValue: mockRedisService },
        { provide: ImageProcessingService, useValue: mockImageProcessing },
        { provide: OcrService, useValue: mockOcrService },
        { provide: VisionService, useValue: mockVisionService },
        { provide: ProductMatchingService, useValue: mockMatchingService },
        { provide: RecipeService, useValue: mockRecipeService },
      ],
    }).compile();

    service = module.get<ImageSearchService>(ImageSearchService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should analyze product image successfully', async () => {
    const res = await service.analyzeProductImage({
      userId: 'u1',
      imageBufferOrBase64: 'BASE64_MOCK_PAYLOAD',
    });

    expect(res).toBeDefined();
    expect(res.imageHash).toBe('hash_abc123');
    expect(res.matchedProducts.matchType).toBe('EXACT');
    expect(res.ocrMetadata?.brand).toBe('Amul');
  });

  it('should get visual analytics summary', async () => {
    const analytics = await service.getVisualAnalyticsSummary();
    expect(analytics).toBeDefined();
    expect(analytics.totalImageSearches).toBeGreaterThan(0);
  });
});
