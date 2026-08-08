import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

@Injectable()
export class ConversationService {
  private readonly logger = new Logger(ConversationService.name);

  constructor(private prisma: PrismaService) {}

  async getOrCreateSession(
    userId: string,
    sessionId?: string,
    currentRoute: string = '/chat',
    contextData?: Record<string, any>,
  ) {
    if (sessionId) {
      const existing = await this.prisma.aiConversationSession.findUnique({
        where: { id: sessionId },
        include: {
          messages: {
            take: 20,
            orderBy: { createdAt: 'asc' },
          },
        },
      });
      if (existing) {
        return existing;
      }
    }

    return this.prisma.aiConversationSession.create({
      data: {
        userId,
        currentRoute,
        contextData: contextData || {},
        status: 'ACTIVE',
      },
      include: {
        messages: true,
      },
    });
  }

  async addMessage(
    sessionId: string,
    senderRole: 'USER' | 'ASSISTANT' | 'SYSTEM' | 'TOOL',
    content: string,
    toolCalls?: any,
    cardType?: string,
    cardData?: any,
    tokensUsed?: number,
    latencyMs?: number,
    providerUsed?: string,
  ) {
    return this.prisma.aiChatMessage.create({
      data: {
        sessionId,
        senderRole,
        content,
        toolCalls: toolCalls || undefined,
        cardType,
        cardData: cardData || undefined,
        tokensUsed,
        latencyMs,
        providerUsed,
      },
    });
  }

  async getSessionHistory(sessionId: string) {
    return this.prisma.aiChatMessage.findMany({
      where: { sessionId },
      orderBy: { createdAt: 'asc' },
    });
  }

  async escalateSession(sessionId: string, reason: string) {
    return this.prisma.aiConversationSession.update({
      where: { id: sessionId },
      data: {
        status: 'ESCALATED',
        updatedAt: new Date(),
      },
    });
  }
}
