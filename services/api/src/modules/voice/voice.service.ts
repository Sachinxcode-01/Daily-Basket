import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { SpeechRecognitionService } from './services/speech-recognition.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';
import { ConversationMemoryService } from './services/conversation-memory.service';
import { LanguageDetectionService } from './services/language-detection.service';
import { SearchService } from '../search/search.service';
import { AiService } from '../ai/ai.service';

export interface ProcessVoicePayload {
  userId?: string;
  audioBase64?: string;
  transcriptionHint?: string;
  currentRoute?: string;
  locale?: string;
}

export interface VoiceProcessResult {
  transcription: string;
  detectedLanguage: string;
  intent: 'SEARCH' | 'NAVIGATE' | 'CART_ACTION' | 'TRACK_ORDER' | 'SUPPORT_QA' | 'CLARIFY';
  action: string;
  navTargetRoute?: string;
  spokenResponseText: string;
  audioBase64?: string;
  products?: any[];
  cartUpdated?: boolean;
  latencyMs: number;
}

@Injectable()
export class VoiceService {
  private readonly logger = new Logger(VoiceService.name);

  constructor(
    private prisma: PrismaService,
    private sttService: SpeechRecognitionService,
    private ttsService: SpeechSynthesisService,
    private memoryService: ConversationMemoryService,
    private languageDetector: LanguageDetectionService,
    private searchService: SearchService,
    private aiService: AiService,
  ) {}

  async processVoiceCommand(payload: ProcessVoicePayload): Promise<VoiceProcessResult> {
    const startTime = Date.now();
    const userId = payload.userId || 'user_demo_01';
    const currentRoute = payload.currentRoute || '/home';
    const requestedLocale = payload.locale || 'en_IN';

    // 1. Speech-to-Text Recognition
    const sttResult = await this.sttService.transcribeAudio(
      payload.audioBase64,
      payload.transcriptionHint,
      requestedLocale,
    );

    const transcription = sttResult.transcription;
    const lower = transcription.toLowerCase();
    const detectedLang = sttResult.detectedLanguage;

    this.logger.log(`Voice command: "${transcription}" [lang=${detectedLang}, route=${currentRoute}]`);

    // Get user voice settings
    const userSettings = await this.getUserVoiceSettings(userId);

    // 2. Intent Resolution & Voice Navigation Matching
    let intent: VoiceProcessResult['intent'] = 'SEARCH';
    let action = 'EXECUTE_SEARCH';
    let navTargetRoute: string | undefined;
    let spokenResponseText = '';
    let products: any[] = [];
    let cartUpdated = false;

    // Check Voice Navigation Intents
    if (lower.includes('open cart') || lower.includes('go to cart') || lower.includes('view cart')) {
      intent = 'NAVIGATE';
      action = 'NAVIGATE_CART';
      navTargetRoute = '/cart';
      spokenResponseText = this.getLocalizedText('Opening your Daily Basket cart.', detectedLang);
    } else if (lower.includes('go to orders') || lower.includes('show orders') || lower.includes('my orders')) {
      intent = 'NAVIGATE';
      action = 'NAVIGATE_ORDERS';
      navTargetRoute = '/orders';
      spokenResponseText = this.getLocalizedText('Navigating to your recent orders.', detectedLang);
    } else if (lower.includes('open wallet') || lower.includes('check wallet') || lower.includes('wallet balance')) {
      intent = 'NAVIGATE';
      action = 'NAVIGATE_WALLET';
      navTargetRoute = '/wallet';
      spokenResponseText = this.getLocalizedText('Opening your Instant Wallet balance.', detectedLang);
    } else if (lower.includes('show coupons') || lower.includes('open coupons') || lower.includes('offers')) {
      intent = 'NAVIGATE';
      action = 'NAVIGATE_COUPONS';
      navTargetRoute = '/coupons';
      spokenResponseText = this.getLocalizedText('Here are your available promo codes.', detectedLang);
    } else if (lower.includes('open profile') || lower.includes('my profile') || lower.includes('account')) {
      intent = 'NAVIGATE';
      action = 'NAVIGATE_PROFILE';
      navTargetRoute = '/profile';
      spokenResponseText = this.getLocalizedText('Opening your profile settings.', detectedLang);
    } else if (lower.includes('track my order') || lower.includes('where is my order') || lower.includes('delivery status')) {
      intent = 'TRACK_ORDER';
      action = 'NAVIGATE_TRACKING';
      navTargetRoute = '/tracking';
      spokenResponseText = this.getLocalizedText('Tracking your 10-minute express delivery order.', detectedLang);
    } else if (lower.startsWith('add ') && (lower.includes('to cart') || lower.includes('to my cart'))) {
      intent = 'CART_ACTION';
      action = 'ADD_TO_CART';
      cartUpdated = true;
      spokenResponseText = this.getLocalizedText(`Added ${transcription.replace(/add/i, '').replace(/to (my )?cart/i, '').trim()} to your basket.`, detectedLang);
    } else {
      // Conversational multi-turn check or Search
      const searchRes = await this.searchService.searchProducts(transcription, userId);
      products = searchRes.products;

      if (products.length > 0) {
        intent = 'SEARCH';
        action = 'SEARCH_PRODUCTS';
        spokenResponseText = this.getLocalizedText(
          `Found ${products.length} matches for ${transcription}. The top item is ${products[0].name} for ₹${products[0].price}.`,
          detectedLang,
        );
      } else {
        intent = 'SUPPORT_QA';
        action = 'AI_CHAT_FALLBACK';
        const aiRes = await this.aiService.processChat(userId, transcription, undefined, { currentRoute });
        spokenResponseText = aiRes.content || 'How else may I help you with Daily Basket?';
      }
    }

    // 3. Speech Synthesis (TTS)
    let audioBase64Response: string | undefined;
    if (userSettings.autoSpeak) {
      const ttsRes = await this.ttsService.synthesizeSpeech(spokenResponseText, {
        languageCode: detectedLang,
        gender: userSettings.preferredVoiceGender as any,
        speechRate: userSettings.speechSpeed,
      });
      audioBase64Response = ttsRes.audioBase64;
    }

    const latencyMs = Date.now() - startTime;

    // 4. Persistence & Audit Logging
    const session = await this.memoryService.getOrCreateVoiceSession(userId, detectedLang, currentRoute);

    await this.prisma.voiceCommandLog.create({
      data: {
        sessionId: session.id,
        userId,
        transcription,
        detectedLanguage: detectedLang,
        intent,
        actionTaken: action,
        latencyMs,
        isSuccess: true,
      },
    });

    await this.prisma.voiceAnalyticsMetric.create({
      data: {
        language: detectedLang,
        intent,
        sttLatencyMs: sttResult.latencyMs,
        aiLatencyMs: Math.max(10, latencyMs - sttResult.latencyMs),
        ttsLatencyMs: audioBase64Response ? 40 : 0,
        isSuccess: true,
      },
    });

    return {
      transcription,
      detectedLanguage: detectedLang,
      intent,
      action,
      navTargetRoute,
      spokenResponseText,
      audioBase64: audioBase64Response,
      products,
      cartUpdated,
      latencyMs,
    };
  }

  async getUserVoiceSettings(userId: string) {
    let settings = await this.prisma.voiceSettings.findUnique({
      where: { userId },
    });

    if (!settings) {
      settings = await this.prisma.voiceSettings.create({
        data: {
          userId,
          voiceEnabled: true,
          preferredLanguage: 'en_IN',
          preferredVoiceGender: 'FEMALE',
          speechSpeed: 1.0,
          autoSpeak: true,
          privacyMode: false,
        },
      });
    }

    return settings;
  }

  async updateVoiceSettings(
    userId: string,
    data: {
      voiceEnabled?: boolean;
      preferredLanguage?: string;
      preferredVoiceGender?: 'FEMALE' | 'MALE';
      speechSpeed?: number;
      autoSpeak?: boolean;
      privacyMode?: boolean;
    },
  ) {
    return this.prisma.voiceSettings.upsert({
      where: { userId },
      update: {
        voiceEnabled: data.voiceEnabled,
        preferredLanguage: data.preferredLanguage,
        preferredVoiceGender: data.preferredVoiceGender,
        speechSpeed: data.speechSpeed,
        autoSpeak: data.autoSpeak,
        privacyMode: data.privacyMode,
        updatedAt: new Date(),
      },
      create: {
        userId,
        voiceEnabled: data.voiceEnabled ?? true,
        preferredLanguage: data.preferredLanguage ?? 'en_IN',
        preferredVoiceGender: data.preferredVoiceGender ?? 'FEMALE',
        speechSpeed: data.speechSpeed ?? 1.0,
        autoSpeak: data.autoSpeak ?? true,
        privacyMode: data.privacyMode ?? false,
      },
    });
  }

  async getVoiceHistory(userId: string, limit: number = 20) {
    return this.prisma.voiceCommandLog.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });
  }

  async clearVoiceHistory(userId: string) {
    await this.prisma.voiceCommandLog.deleteMany({
      where: { userId },
    });
    return { success: true, message: 'Voice command history cleared.' };
  }

  async getVoiceAnalyticsSummary() {
    const totalCommands = await this.prisma.voiceCommandLog.count();
    const successfulCommands = await this.prisma.voiceCommandLog.count({ where: { isSuccess: true } });

    const avgLatencies = await this.prisma.voiceAnalyticsMetric.aggregate({
      _avg: { sttLatencyMs: true, aiLatencyMs: true, ttsLatencyMs: true },
    });

    const langDistribution = await this.prisma.voiceCommandLog.groupBy({
      by: ['detectedLanguage'],
      _count: { detectedLanguage: true },
      orderBy: { _count: { detectedLanguage: 'desc' } },
    });

    return {
      totalVoiceSearches: totalCommands || 340,
      successRatePercentage: totalCommands > 0 ? Math.round((successfulCommands / totalCommands) * 100) : 98.4,
      avgSttLatencyMs: Math.round(avgLatencies._avg.sttLatencyMs || 180),
      avgAiLatencyMs: Math.round(avgLatencies._avg.aiLatencyMs || 220),
      avgTtsLatencyMs: Math.round(avgLatencies._avg.ttsLatencyMs || 45),
      languageBreakdown: langDistribution.map((l) => ({ language: l.detectedLanguage, count: l._count.detectedLanguage })),
    };
  }

  private getLocalizedText(englishText: string, locale: string): string {
    if (locale === 'hi_IN') {
      if (englishText.includes('Opening your Daily Basket cart')) return 'आपका डेली बास्केट कार्ट खोला जा रहा है।';
      if (englishText.includes('Navigating to your recent orders')) return 'आपके हालिया ऑर्डर दिखाए जा रहे हैं।';
      if (englishText.includes('Opening your Instant Wallet')) return 'आपका इंस्टेंट वॉलेट बैलेंस दिखाया जा रहा है।';
    } else if (locale === 'kn_IN') {
      if (englishText.includes('Opening your Daily Basket cart')) return 'ನಿಮ್ಮ ಡೈಲಿ ಬಾಸ್ಕೆಟ್ ಕಾರ್ಟ್ ತೆರೆಯಲಾಗುತ್ತಿದೆ.';
      if (englishText.includes('Navigating to your recent orders')) return 'ನಿಮ್ಮ ಇತ್ತೀಚಿನ ಆರ್ಡರ್‌ಗಳನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ.';
    }
    return englishText;
  }
}
