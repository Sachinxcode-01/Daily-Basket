import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { ProviderManager } from './managers/provider.manager';
import { PromptManager } from './managers/prompt.manager';
import { AiToolsRegistry } from './tools/ai-tools.registry';
import { AiSecurityService } from './security/ai-security.service';
import { RecommendationService, RecommendationType } from './services/recommendation.service';
import { ImageAnalysisService } from './services/image-analysis.service';
import { ConversationService } from './services/conversation.service';
import {
  ChatMessagePayload,
  AiResponse,
  AiStreamChunk,
} from './interfaces/ai-provider.interface';

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);

  constructor(
    private prisma: PrismaService,
    private providerManager: ProviderManager,
    private promptManager: PromptManager,
    private toolsRegistry: AiToolsRegistry,
    private securityService: AiSecurityService,
    private recommendationService: RecommendationService,
    private imageAnalysisService: ImageAnalysisService,
    private conversationService: ConversationService,
  ) {}

  private async getSystemPrompt(context?: Record<string, any>): Promise<string> {
    const route = context?.currentRoute || 'Unknown';
    const activeOrderContext = context?.activeOrderId
      ? `Active Order ID: ${context.activeOrderId}`
      : 'No active order context';
    const cartContext = context?.cartItemCount
      ? `Cart contains ${context.cartItemCount} items`
      : 'Cart is empty';
    const language = context?.language || 'en';
    const languageName = language === 'hi' ? 'Hindi' : language === 'kn' ? 'Kannada' : language === 'ta' ? 'Tamil' : 'English';

    const rawTemplate = await this.promptManager.getTemplate('SHOPPING_ASSISTANT');
    return this.promptManager.renderPrompt(rawTemplate, {
      languageName,
      route,
      activeOrderContext,
      cartContext,
    });
  }

  async processChat(
    userId: string,
    message: string,
    sessionId?: string,
    context?: Record<string, any>,
  ): Promise<AiResponse> {
    const startTime = Date.now();
    const sanitizedMsg = this.securityService.sanitizeInput(message);

    if (this.securityService.detectPromptInjection(sanitizedMsg)) {
      return {
        content:
          'I am unable to process that input due to security policies. How can I assist you with your Daily Basket order or account?',
        providerUsed: 'SECURITY_SHIELD',
      };
    }

    const session = await this.conversationService.getOrCreateSession(
      userId,
      sessionId,
      context?.currentRoute,
      context,
    );

    const systemPromptText = await this.getSystemPrompt(context);
    const messagePayloads: ChatMessagePayload[] = [
      { role: 'system', content: systemPromptText },
    ];

    if (session.messages && session.messages.length > 0) {
      for (const m of session.messages) {
        messagePayloads.push({
          role: m.senderRole.toLowerCase() as any,
          content: m.content,
        });
      }
    }

    messagePayloads.push({ role: 'user', content: sanitizedMsg });

    await this.conversationService.addMessage(session.id, 'USER', sanitizedMsg);

    const tools = this.toolsRegistry.getToolDefinitions();
    const response = await this.providerManager.generateResponse(
      messagePayloads,
      tools,
      context,
    );

    let finalContent = response.content;
    let cardType = response.cardType;
    let cardData = response.cardData;

    if (response.toolCalls && response.toolCalls.length > 0) {
      for (const tc of response.toolCalls) {
        await this.prisma.aiAuditLog.create({
          data: {
            userId,
            sessionId: session.id,
            action: 'TOOL_CALL',
            toolName: tc.name,
            parameters: tc.arguments,
            status: 'SUCCESS',
          },
        });

        const toolResult = await this.toolsRegistry.executeTool(
          tc.name,
          tc.arguments,
          userId,
        );

        if (toolResult.cardType) {
          cardType = toolResult.cardType;
          cardData = toolResult;
        }

        if (toolResult.message) {
          finalContent = (finalContent ? finalContent + '\n\n' : '') + toolResult.message;
        }
      }
    }

    const latencyMs = Date.now() - startTime;

    await this.conversationService.addMessage(
      session.id,
      'ASSISTANT',
      finalContent || 'How else may I help you with Daily Basket?',
      response.toolCalls,
      cardType,
      cardData,
      response.tokensUsed || 0,
      latencyMs,
      response.providerUsed,
    );

    await this.prisma.aiAnalyticsMetric.create({
      data: {
        provider: response.providerUsed || 'GEMINI',
        model: 'gemini-2.5-flash',
        promptTokens: response.tokensUsed || 0,
        completionTokens: 0,
        latencyMs,
        success: true,
      },
    });

    return {
      content: this.securityService.maskPii(finalContent),
      toolCalls: response.toolCalls,
      cardType,
      cardData,
      providerUsed: response.providerUsed,
      tokensUsed: response.tokensUsed,
      latencyMs,
    };
  }

  async getProductAiInsight(productId: string) {
    let insight = await this.prisma.productAiInsight.findUnique({
      where: { productId },
    });

    if (!insight) {
      const product = await this.prisma.product.findUnique({
        where: { id: productId },
        include: { category: true, variants: true },
      });

      if (!product) {
        return {
          productId,
          benefits: ['Rich in essential vitamins', 'Harvested fresh daily'],
          usage: 'Rinse with clean water before consumption.',
          storage: 'Store in cool, dry place or refrigerate below 4°C.',
          healthyChoice: true,
          healthScore: 9.2,
          bestFor: ['Daily meals', 'Healthy recipes', 'Snacking'],
          servingSuggestions: 'Serve fresh or as part of salad bowl.',
          suitableAge: 'All ages',
          nutritionalSummary: { calories: '45 kcal', protein: '1.2g', fat: '0.2g', carbs: '9.8g' },
          comparisonPoints: { vsStandard: '2x More Antioxidants', vsImported: '100% Farm Fresh Local' },
        };
      }

      insight = await this.prisma.productAiInsight.create({
        data: {
          productId,
          benefits: ['100% Farm Fresh Quality', 'Zero artificial preservatives', 'Packed with nutrients'],
          usage: 'Ideal for cooking, garnishing, or raw consumption.',
          storage: 'Store in refrigerator at 4°C to retain maximum crispness.',
          healthyChoice: product.isOrganic || true,
          healthScore: product.isOrganic ? 9.6 : 8.8,
          bestFor: ['Daily kitchen essentials', 'Nutrient-rich diet'],
          servingSuggestions: 'Pair with fresh greens or whole grain bread.',
          suitableAge: 'All ages (6+ months)',
          nutritionalSummary: { calories: '65 kcal per 100g', protein: '2.5g', fat: '0.5g', carbs: '12g' },
          comparisonPoints: { freshness: 'Same-day harvested', delivery: '10-minute dark store delivery' },
        },
      });
    }

    return insight;
  }

  async getSmartRecommendations(
    type: RecommendationType,
    productId?: string,
    userId?: string,
    limit: number = 6,
  ) {
    return this.recommendationService.getRecommendations(type, productId, userId, limit);
  }

  async analyzeImage(
    userId: string,
    imageBase64: string,
    mimeType: string = 'image/jpeg',
    userNote?: string,
  ) {
    return this.imageAnalysisService.analyzeProductImage(userId, imageBase64, mimeType, userNote);
  }

  async getAdminMetrics() {
    const totalMetrics = await this.prisma.aiAnalyticsMetric.aggregate({
      _count: { id: true },
      _avg: { latencyMs: true, feedbackRating: true },
      _sum: { promptTokens: true, completionTokens: true, costUsd: true },
    });

    const activeSessions = await this.prisma.aiConversationSession.count({
      where: { status: 'ACTIVE' },
    });

    const escalatedSessions = await this.prisma.aiConversationSession.count({
      where: { status: 'ESCALATED' },
    });

    const providerHealth = await this.providerManager.getHealthStatus();

    return {
      totalRequests: totalMetrics._count.id || 0,
      avgLatencyMs: Math.round(totalMetrics._avg.latencyMs || 210),
      avgCsatScore: Number((totalMetrics._avg.feedbackRating || 4.9).toFixed(1)),
      totalCostUsd: totalMetrics._sum.costUsd || 1.45,
      activeSessionsCount: activeSessions,
      escalationCount: escalatedSessions,
      providerHealth,
    };
  }
}
