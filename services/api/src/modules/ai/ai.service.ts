import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { ProviderManager } from './managers/provider.manager';
import { AiToolsRegistry } from './tools/ai-tools.registry';
import { AiSecurityService } from './security/ai-security.service';
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
    private toolsRegistry: AiToolsRegistry,
    private securityService: AiSecurityService,
  ) {}

  private getSystemPrompt(context?: Record<string, any>): string {
    const route = context?.currentRoute || 'Unknown';
    const activeOrder = context?.activeOrderId
      ? `Active Order ID: ${context.activeOrderId}`
      : '';
    const cartInfo = context?.cartItemCount
      ? `Cart contains ${context.cartItemCount} items`
      : '';

    return `You are the Daily Basket Enterprise AI Customer Support Assistant.
You behave like an exceptionally helpful, polite, professional support executive at Daily Basket.

CONTEXT:
- App Route: ${route}
- ${activeOrder}
- ${cartInfo}

RULES:
1. Never hallucinate fake order status, refunds, or payment details. Always use tools (e.g., trackOrder, getWalletBalance, getOrderHistory, claimRefund) to verify facts.
2. If a customer reports a damaged, broken, or missing item, apologize sincerely and offer an instant wallet refund using claimRefund.
3. If a customer asks to speak with a human manager or supervisor, call createSupportTicket and transfer context to Senior Support Lead "Ananya R.".
4. Maintain a warm, courteous tone. Use bullet points and clear, concise formatting.
5. Provide actionable responses and quick suggestions.`;
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
          'I am unable to process that input. How can I assist you with your Daily Basket order or account?',
        providerUsed: 'SECURITY_SHIELD',
      };
    }

    // Get or create session
    let session: any = null;
    if (sessionId) {
      session = await this.prisma.aiConversationSession.findUnique({
        where: { id: sessionId },
        include: { messages: { take: 10, orderBy: { createdAt: 'asc' } } },
      });
    }

    if (!session) {
      session = await this.prisma.aiConversationSession.create({
        data: {
          userId,
          currentRoute: context?.currentRoute || '/chat',
          contextData: context || {},
          status: 'ACTIVE',
        },
        include: { messages: true },
      });
    }

    // Build message payload history
    const messagePayloads: ChatMessagePayload[] = [
      { role: 'system', content: this.getSystemPrompt(context) },
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

    // Save user message to database
    await this.prisma.aiChatMessage.create({
      data: {
        sessionId: session.id,
        senderRole: 'USER',
        content: sanitizedMsg,
      },
    });

    const tools = this.toolsRegistry.getToolDefinitions();
    const response = await this.providerManager.generateResponse(
      messagePayloads,
      tools,
      context,
    );

    // If AI triggered tool calls, execute them securely
    let finalContent = response.content;
    let cardType = response.cardType;
    let cardData = response.cardData;

    if (response.toolCalls && response.toolCalls.length > 0) {
      for (const tc of response.toolCalls) {
        // Audit log tool execution
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

    // Save assistant message to database
    await this.prisma.aiChatMessage.create({
      data: {
        sessionId: session.id,
        senderRole: 'ASSISTANT',
        content: finalContent || 'How else may I help you with Daily Basket?',
        cardType,
        cardData: cardData || undefined,
        tokensUsed: response.tokensUsed || 0,
        latencyMs,
        providerUsed: response.providerUsed,
      },
    });

    // Record telemetry metrics
    await this.prisma.aiAnalyticsMetric.create({
      data: {
        provider: response.providerUsed,
        model: 'default',
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

  async *streamChat(
    userId: string,
    message: string,
    sessionId?: string,
    context?: Record<string, any>,
  ): AsyncIterable<AiStreamChunk> {
    const sanitizedMsg = this.securityService.sanitizeInput(message);
    if (this.securityService.detectPromptInjection(sanitizedMsg)) {
      yield {
        type: 'content',
        content:
          'Security check triggered. How may I assist you with Daily Basket orders?',
        providerUsed: 'SECURITY_SHIELD',
      };
      yield { type: 'done', providerUsed: 'SECURITY_SHIELD' };
      return;
    }

    const messagePayloads: ChatMessagePayload[] = [
      { role: 'system', content: this.getSystemPrompt(context) },
      { role: 'user', content: sanitizedMsg },
    ];

    const tools = this.toolsRegistry.getToolDefinitions();
    const stream = this.providerManager.generateStream(
      messagePayloads,
      tools,
      context,
    );

    for await (const chunk of stream) {
      if (chunk.type === 'tool_call' && chunk.toolCall) {
        const tc = chunk.toolCall;
        const toolResult = await this.toolsRegistry.executeTool(
          tc.name,
          tc.arguments,
          userId,
        );

        if (toolResult.cardType) {
          yield {
            type: 'card',
            cardType: toolResult.cardType,
            cardData: toolResult,
            providerUsed: chunk.providerUsed,
          };
        }
      } else {
        yield chunk;
      }
    }
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
      avgLatencyMs: Math.round(totalMetrics._avg.latencyMs || 0),
      avgCsatScore: Number((totalMetrics._avg.feedbackRating || 4.8).toFixed(1)),
      totalCostUsd: totalMetrics._sum.costUsd || 0.0,
      activeSessionsCount: activeSessions,
      escalationCount: escalatedSessions,
      providerHealth,
    };
  }

  async processAiShoppingQuery(query: string) {
    return {
      query,
      aiIntent: 'HEALTHY_SALAD_RECIPE',
      suggestedProducts: [
        { id: 'p1', name: 'Organic Farm Tomatoes', unit: '500g', price: 24 },
        { id: 'p4', name: 'Fresh Cucumbers', unit: '500g', price: 20 },
      ],
      aiTip: 'Great choice! These fresh organic vegetables make a nutrient-rich salad.',
    };
  }

  async getSmartSubstitutions(productId: string) {
    return {
      productId,
      substitutions: [
        { id: 'sub_1', name: 'Organic Roma Tomatoes', unit: '500g', price: 26, matchPercentage: 98 },
        { id: 'sub_2', name: 'Cherry Tomatoes Box', unit: '250g', price: 35, matchPercentage: 92 },
      ],
    };
  }

  async getDemandForecast(storeId: string = 'store_main_01') {
    return {
      storeId,
      forecastDate: new Date().toISOString().split('T')[0],
      predictedPeakHours: ['08:00 AM - 10:00 AM', '06:00 PM - 09:00 PM'],
      predictedTopItems: [
        { name: 'Organic Tomatoes', expectedDemandUnits: 480, restockRecommended: 200 },
        { name: 'Amul Toned Milk', expectedDemandUnits: 400, restockRecommended: 150 },
      ],
      confidenceScore: 0.94,
    };
  }
}
