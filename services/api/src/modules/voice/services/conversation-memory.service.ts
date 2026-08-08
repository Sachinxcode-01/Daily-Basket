import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

export interface VoiceTurnState {
  pendingIntent?: string;
  categoryContext?: string;
  brandContext?: string;
  variantContext?: string;
  cartDraftId?: string;
}

@Injectable()
export class ConversationMemoryService {
  private readonly logger = new Logger(ConversationMemoryService.name);

  constructor(private prisma: PrismaService) {}

  async getOrCreateVoiceSession(userId: string, locale: string = 'en_IN', currentRoute: string = '/home') {
    let session = await this.prisma.voiceSession.findFirst({
      where: { userId, status: 'ACTIVE' },
      orderBy: { updatedAt: 'desc' },
      include: { logs: { take: 10, orderBy: { createdAt: 'desc' } } },
    });

    if (!session) {
      session = await this.prisma.voiceSession.create({
        data: {
          userId,
          locale,
          currentRoute,
          status: 'ACTIVE',
        },
        include: { logs: true },
      });
    }

    return session;
  }

  async resolveFollowUpState(sessionId: string, newSpokenText: string): Promise<VoiceTurnState> {
    const session = await this.prisma.voiceSession.findUnique({
      where: { id: sessionId },
      include: { logs: { take: 3, orderBy: { createdAt: 'desc' } } },
    });

    if (!session || !session.logs || session.logs.length === 0) {
      return {};
    }

    const lastLog = session.logs[0];
    const lower = newSpokenText.toLowerCase();

    // Check multi-turn brand & quantity follow-up flows
    if (lastLog.intent === 'SEARCH' || lastLog.intent === 'CLARIFY_BRAND') {
      if (lower.includes('fortune') || lower.includes('amul') || lower.includes('aashirvaad') || lower.includes('tata')) {
        return {
          pendingIntent: 'CLARIFY_VARIANT',
          categoryContext: lastLog.actionTaken || 'Grocery',
          brandContext: newSpokenText.trim(),
        };
      }
    }

    if (lastLog.intent === 'CLARIFY_VARIANT') {
      if (lower.includes('1l') || lower.includes('5l') || lower.includes('500g') || lower.includes('1kg') || lower.includes('5kg')) {
        return {
          pendingIntent: 'ADD_TO_CART_EXECUTE',
          variantContext: newSpokenText.trim(),
        };
      }
    }

    return {};
  }
}
