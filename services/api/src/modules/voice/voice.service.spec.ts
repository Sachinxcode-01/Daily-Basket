import { Test, TestingModule } from '@nestjs/testing';
import { VoiceService } from './voice.service';
import { SpeechRecognitionService } from './services/speech-recognition.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';
import { ConversationMemoryService } from './services/conversation-memory.service';
import { LanguageDetectionService } from './services/language-detection.service';
import { TranscriptionNormalizerService } from './services/transcription-normalizer.service';
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
      transcription: 'Find one litre of milk',
      detectedLanguage: 'en_IN',
      confidenceScore: 98.0,
      latencyMs: 120,
      provider: 'voicestudio',
    }),
    healthCheck: jest.fn().mockResolvedValue({
      isAvailable: true,
      provider: 'voicestudio',
      endpoint: 'http://127.0.0.1:8000',
    }),
    getCapabilities: jest.fn().mockReturnValue({
      supportsStreaming: true,
      supportedLanguages: ['en', 'hi', 'kn'],
      modelName: 'whisper-tiny',
    }),
    getProviderName: jest.fn().mockReturnValue('voicestudio'),
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

  const mockCatalogueProducts = [
    {
      id: 'prod_milk_1',
      name: 'Amul Taaza Toned Fresh Milk',
      brand: 'Amul',
      price: 27,
      mrp: 30,
      unit: '500ml',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150',
      isAvailable: true,
      isOrganic: false,
    },
    {
      id: 'prod_milk_2',
      name: 'Amul Gold Full Cream Fresh Milk 1L',
      brand: 'Amul',
      price: 66,
      mrp: 70,
      unit: '1L',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b',
      isAvailable: true,
      isOrganic: false,
    },
  ];

  const mockSearchService = {
    searchProducts: jest.fn().mockResolvedValue({
      products: mockCatalogueProducts,
      totalCount: 2,
    }),
  };

  const mockAiService = {
    processChat: jest.fn().mockResolvedValue({ content: 'I can assist you with your order.' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VoiceService,
        TranscriptionNormalizerService,
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

  it('should execute searchVoiceProducts with real catalogue search integration', async () => {
    const res = await service.searchVoiceProducts('user_123', {
      queryHint: 'Find one litre of milk',
      languageHint: 'en_IN',
    });

    expect(res).toBeDefined();
    expect(res.transcription).toBe('Find one litre of milk');
    expect(res.searchQuery).toBe('milk');
    expect(res.extractedQuantity).toBe(1);
    expect(res.extractedUnit).toBe('1L');
    expect(res.results.length).toBe(2);
    expect(res.results[0].id).toBe('prod_milk_1');
    expect(res.results[0].price).toBe(27);
    expect(res.meta.provider).toBe('voicestudio');
    expect(res.meta.healthStatus).toBe('HEALTHY');
    expect(mockSearchService.searchProducts).toHaveBeenCalledWith('milk', 'user_123');
  });

  it('should check provider status via getProviderStatus', async () => {
    const status = await service.getProviderStatus();
    expect(status).toBeDefined();
    expect(status.provider).toBe('voicestudio');
    expect(status.isAvailable).toBe(true);
    expect(status.capabilities).toBeDefined();
  });

  it('should process voice navigation command "Open Cart"', async () => {
    mockSttService.transcribeAudio.mockResolvedValueOnce({
      transcription: 'Open Cart',
      detectedLanguage: 'en_IN',
      confidenceScore: 98.0,
      latencyMs: 120,
      provider: 'voicestudio',
    });

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
    expect(analytics.totalVoiceSearches).toBeGreaterThanOrEqual(0);
  });
});
