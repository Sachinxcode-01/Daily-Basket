import { Test, TestingModule } from '@nestjs/testing';
import { PersonalizationService } from './personalization.service';
import { RecommendationEngine } from './recommendation.engine';
import { ShoppingBehaviorService } from './services/shopping-behavior.service';
import { SmartBasketService } from './services/smart-basket.service';
import { CustomerInsightsService } from './services/customer-insights.service';
import { RecipeRecommendationService } from './services/recipe-recommendation.service';
import { PrismaService } from '../../database/prisma.service';

describe('PersonalizationService', () => {
  let service: PersonalizationService;

  const mockPrismaService = {
    product: {
      findMany: jest.fn().mockResolvedValue([
        {
          id: 'p1',
          name: 'Amul Milk 1L',
          brand: 'Amul',
          images: ['url1'],
          variants: [{ price: 56, unitName: '1L' }],
        },
      ]),
    },
    groceryList: {
      findMany: jest.fn().mockResolvedValue([]),
      create: jest.fn().mockResolvedValue({ id: 'gl_1', name: 'Weekly Essentials' }),
    },
    personalizedOffer: {
      findMany: jest.fn().mockResolvedValue([]),
      create: jest.fn().mockResolvedValue({ id: 'po_1', code: 'MYAMUL15' }),
    },
  };

  const mockRecEngine = {
    generatePersonalizedSection: jest.fn().mockResolvedValue({
      sectionKey: 'RECOMMENDED_FOR_YOU',
      products: [{ id: 'p1', name: 'Amul Milk 1L' }],
      latencyMs: 35,
    }),
  };

  const mockBehaviorService = {
    getBehaviorProfile: jest.fn().mockResolvedValue({
      userId: 'u1',
      topCategories: ['Dairy'],
      topBrands: ['Amul'],
    }),
  };

  const mockSmartBasketService = {
    generateSmartWeeklyBasket: jest.fn().mockResolvedValue({
      items: [{ productId: 'p1', name: 'Amul Milk 1L', price: 56 }],
      totalBasketAmount: 56,
    }),
    optimizeBasket: jest.fn().mockResolvedValue({
      currentSubtotal: 450,
      deliveryFee: 30,
      optimizedDeliveryFee: 0,
      bundleSavingsAmount: 45,
    }),
  };

  const mockInsightsService = {
    getCustomerInsights: jest.fn().mockResolvedValue({
      userId: 'u1',
      monthlySpending: 3450,
      totalMoneySaved: 620,
    }),
  };

  const mockRecipeService = {
    getPersonalizedRecipes: jest.fn().mockResolvedValue([]),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PersonalizationService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: RecommendationEngine, useValue: mockRecEngine },
        { provide: ShoppingBehaviorService, useValue: mockBehaviorService },
        { provide: SmartBasketService, useValue: mockSmartBasketService },
        { provide: CustomerInsightsService, useValue: mockInsightsService },
        { provide: RecipeRecommendationService, useValue: mockRecipeService },
      ],
    }).compile();

    service = module.get<PersonalizationService>(PersonalizationService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should generate personalized home feed', async () => {
    const feed = await service.getPersonalizedHomeFeed('u1');
    expect(feed).toBeDefined();
    expect(feed.greeting).toBeDefined();
    expect(feed.sections.recommendedForYou.length).toBeGreaterThan(0);
  });

  it('should get smart reorder list', async () => {
    const list = await service.getSmartReorderList('u1');
    expect(list).toBeDefined();
    expect(list.length).toBeGreaterThan(0);
  });

  it('should get customer insights', async () => {
    const insights = await service.getCustomerInsights('u1');
    expect(insights).toBeDefined();
    expect(insights.monthlySpending).toBeGreaterThan(0);
  });
});
