import { Test, TestingModule } from '@nestjs/testing';
import { AiService } from './ai.service';
import { PrismaService } from '../../database/prisma.service';
import { ProviderManager } from './managers/provider.manager';
import { PromptManager } from './managers/prompt.manager';
import { AiToolsRegistry } from './tools/ai-tools.registry';
import { AiSecurityService } from './security/ai-security.service';
import { RecommendationService, RecommendationType } from './services/recommendation.service';
import { ImageAnalysisService } from './services/image-analysis.service';
import { ConversationService } from './services/conversation.service';

describe('AiService', () => {
  let service: AiService;

  const mockPrismaService = {
    aiConversationSession: {
      findUnique: jest.fn(),
      create: jest.fn().mockResolvedValue({ id: 'sess_1', messages: [] }),
      count: jest.fn().mockResolvedValue(5),
    },
    aiChatMessage: {
      create: jest.fn().mockResolvedValue({ id: 'msg_1' }),
    },
    aiAuditLog: {
      create: jest.fn().mockResolvedValue({ id: 'audit_1' }),
    },
    aiAnalyticsMetric: {
      create: jest.fn().mockResolvedValue({ id: 'metric_1' }),
      aggregate: jest.fn().mockResolvedValue({
        _count: { id: 10 },
        _avg: { latencyMs: 250, feedbackRating: 4.8 },
        _sum: { promptTokens: 500, completionTokens: 500, costUsd: 0.05 },
      }),
    },
    productAiInsight: {
      findUnique: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockResolvedValue({
        productId: 'p1',
        benefits: ['Fresh Organic Produce'],
        healthyChoice: true,
        healthScore: 9.5,
      }),
    },
    product: {
      findUnique: jest.fn().mockResolvedValue({ id: 'p1', isOrganic: true }),
    },
  };

  const mockProviderManager = {
    generateResponse: jest.fn().mockResolvedValue({
      content: 'Hello! How can I assist you today?',
      providerUsed: 'GEMINI',
      tokensUsed: 25,
      latencyMs: 120,
    }),
    generateStream: jest.fn(),
    getHealthStatus: jest.fn().mockResolvedValue({ GEMINI: true }),
  };

  const mockPromptManager = {
    getTemplate: jest.fn().mockResolvedValue('System prompt {{languageName}}'),
    renderPrompt: jest.fn().mockReturnValue('System prompt English'),
  };

  const mockToolsRegistry = {
    getToolDefinitions: jest.fn().mockReturnValue([]),
    executeTool: jest.fn(),
  };

  const mockSecurityService = {
    sanitizeInput: jest.fn((str) => str),
    detectPromptInjection: jest.fn().mockReturnValue(false),
    maskPii: jest.fn((str) => str),
  };

  const mockRecommendationService = {
    getRecommendations: jest.fn().mockResolvedValue({
      type: RecommendationType.SIMILAR_PRODUCTS,
      products: [{ id: 'p1', name: 'Fresh Tomatoes', price: 30 }],
    }),
  };

  const mockImageAnalysisService = {
    analyzeProductImage: jest.fn().mockResolvedValue({
      productDetected: 'Tomatoes',
      confidenceScore: 96.0,
      matchedProducts: [{ id: 'p1', name: 'Organic Tomatoes' }],
    }),
  };

  const mockConversationService = {
    getOrCreateSession: jest.fn().mockResolvedValue({ id: 'sess_1', messages: [] }),
    addMessage: jest.fn().mockResolvedValue({ id: 'msg_1' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AiService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: ProviderManager, useValue: mockProviderManager },
        { provide: PromptManager, useValue: mockPromptManager },
        { provide: AiToolsRegistry, useValue: mockToolsRegistry },
        { provide: AiSecurityService, useValue: mockSecurityService },
        { provide: RecommendationService, useValue: mockRecommendationService },
        { provide: ImageAnalysisService, useValue: mockImageAnalysisService },
        { provide: ConversationService, useValue: mockConversationService },
      ],
    }).compile();

    service = module.get<AiService>(AiService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should process chat message and return masked AI response', async () => {
    const res = await service.processChat(
      'user_123',
      'Track my express order #DB-9824',
    );
    expect(res).toBeDefined();
    expect(res.providerUsed).toBe('GEMINI');
    expect(res.content).toContain('Hello!');
  });

  it('should get product AI insights', async () => {
    const insight = await service.getProductAiInsight('p1');
    expect(insight).toBeDefined();
    expect(insight.healthScore).toBe(9.5);
  });

  it('should get smart recommendations', async () => {
    const recs = await service.getSmartRecommendations(RecommendationType.SIMILAR_PRODUCTS, 'p1');
    expect(recs).toBeDefined();
    expect(recs.products.length).toBeGreaterThan(0);
  });
});
