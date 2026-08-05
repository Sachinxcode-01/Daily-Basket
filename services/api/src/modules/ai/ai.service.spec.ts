import { Test, TestingModule } from '@nestjs/testing';
import { AiService } from './ai.service';
import { PrismaService } from '../../database/prisma.service';
import { ProviderManager } from './managers/provider.manager';
import { AiToolsRegistry } from './tools/ai-tools.registry';
import { AiSecurityService } from './security/ai-security.service';

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

  const mockToolsRegistry = {
    getToolDefinitions: jest.fn().mockReturnValue([]),
    executeTool: jest.fn(),
  };

  const mockSecurityService = {
    sanitizeInput: jest.fn((str) => str),
    detectPromptInjection: jest.fn().mockReturnValue(false),
    maskPii: jest.fn((str) => str),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AiService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: ProviderManager, useValue: mockProviderManager },
        { provide: AiToolsRegistry, useValue: mockToolsRegistry },
        { provide: AiSecurityService, useValue: mockSecurityService },
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

  it('should get admin AI metrics', async () => {
    const metrics = await service.getAdminMetrics();
    expect(metrics).toBeDefined();
    expect(metrics.totalRequests).toBe(10);
    expect(metrics.avgCsatScore).toBe(4.8);
  });
});
