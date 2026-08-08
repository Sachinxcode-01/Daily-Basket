import { Test, TestingModule } from '@nestjs/testing';
import { VoiceService } from './voice.service';
import { SpeechRecognitionService } from './services/speech-recognition.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';
import { ConversationMemoryService } from './services/conversation-memory.service';
import { LanguageDetectionService } from './services/language-detection.service';
import { PrismaService } from '../../database/prisma.service';
import { SearchService } from '../search/search.service';
import { AiService } from '../ai/ai.service';

describe('VoiceService', () => {
  let service: VoiceService;

  const mockPrismaService = {
    voiceSession: {
      findFirst: jest.fn().mockResolvedValue({ id: 'vs_1', logs: [] }),
      create: jest.fn().mockResolvedValue({ id: 'vs_1', logs: [] }),
    },
    voiceCommandLog: {
      create: jest.fn().mockResolvedValue({ id: 'log_1' }),
      findMany: jest.fn().mockResolvedValue([{ id: 'log_1', transcription: 'Open Cart' }]),
      count: jest.fn().mockResolvedValue(15),
      groupBy: jest.fn().mockResolvedValue([]),
      deleteMany: jest.fn().mockResolvedValue({ count: 1 }),
    },
    voiceSettings: {
      findUnique: jest.fn().mockResolvedValue({
        userId: 'u1',
        voiceEnabled: true,
        preferredLanguage: 'en_IN',
        preferredVoiceGender: 'FEMALE',
        speechSpeed: 1.0,
        autoSpeak: true,
      }),
      upsert: jest.fn().mockResolvedValue({ userId: 'u1', preferredLanguage: 'hi_IN' }),
      create: jest.fn().mockResolvedValue({ userId: 'u1' }),
    },
    voiceAnalyticsMetric: {
      create: jest.fn().mockResolvedValue({ id: 'vam_1' }),
      aggregate: jest.fn().mockResolvedValue({
        _avg: { sttLatencyMs: 150, aiLatencyMs: 200, ttsLatencyMs: 35 },
      }),
    },
  };

  const mockSttService = {
    transcribeAudio: jest.fn().mockResolvedValue({
      transcription: 'Open Cart',
      detectedLanguage: 'en_IN',
      confidenceScore: 98.0,
      latencyMs: 120,
    }),
  };

  const mockTtsService = {
    synthesizeSpeech: jest.fn().mockResolvedValue({
      audioBase64: 'MOCK_AUDIO_BASE64',
      mimeType: 'audio/mp3',
      text: 'Opening your Daily Basket cart.',
      durationMs: 1400,
    }),
  };

  const mockMemoryService = {
    getOrCreateVoiceSession: jest.fn().mockResolvedValue({ id: 'vs_1' }),
    resolveFollowUpState: jest.fn().mockResolvedValue({}),
  };

  const mockLanguageDetector = {
    detectLanguage: jest.fn().mockReturnValue({ code: 'en_IN', name: 'English' }),
  };

  const mockSearchService = {
    searchProducts: jest.fn().mockResolvedValue({ products: [] }),
  };

  const mockAiService = {
    processChat: jest.fn().mockResolvedValue({ content: 'I can assist you with your order.' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VoiceService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: SpeechRecognitionService, useValue: mockSttService },
        { provide: SpeechSynthesisService, useValue: mockTtsService },
        { provide: ConversationMemoryService, useValue: mockMemoryService },
        { provide: LanguageDetectionService, useValue: mockLanguageDetector },
        { provide: SearchService, useValue: mockSearchService },
        { provide: AiService, useValue: mockAiService },
      ],
    }).compile();

    service = module.get<VoiceService>(VoiceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should process voice navigation command "Open Cart"', async () => {
    const res = await service.processVoiceCommand({
      userId: 'u1',
      transcriptionHint: 'Open Cart',
    });

    expect(res).toBeDefined();
    expect(res.intent).toBe('NAVIGATE');
    expect(res.action).toBe('NAVIGATE_CART');
    expect(res.navTargetRoute).toBe('/cart');
    expect(res.spokenResponseText).toContain('Opening your Daily Basket cart');
  });

  it('should update user voice settings', async () => {
    const updated = await service.updateVoiceSettings('u1', {
      preferredLanguage: 'hi_IN',
      preferredVoiceGender: 'MALE',
    });
    expect(updated).toBeDefined();
  });

  it('should get voice analytics summary', async () => {
    const analytics = await service.getVoiceAnalyticsSummary();
    expect(analytics).toBeDefined();
    expect(analytics.totalVoiceSearches).toBeGreaterThan(0);
  });
});
