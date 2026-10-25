import { Test, TestingModule } from '@nestjs/testing';
import { VoiceController } from './voice.controller';
import { VoiceService } from './voice.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';

describe('VoiceController', () => {
  let controller: VoiceController;

  const mockVoiceService = {
    searchVoiceProducts: jest.fn().mockResolvedValue({
      transcription: 'Find one litre of milk',
      language: 'en_IN',
      searchQuery: 'milk',
      extractedQuantity: 1,
      extractedUnit: '1L',
      results: [
        {
          id: 'prod_1',
          name: 'Amul Taaza Milk 1L',
          price: 54,
          unit: '1L',
        },
      ],
      totalCount: 1,
      meta: {
        requestId: 'voice_123',
        processingTimeMs: 250,
        provider: 'voicestudio',
        providerLatencyMs: 150,
        searchLatencyMs: 30,
        healthStatus: 'HEALTHY',
      },
    }),
    getProviderStatus: jest.fn().mockResolvedValue({
      provider: 'voicestudio',
      isAvailable: true,
      endpoint: 'http://127.0.0.1:8000',
      capabilities: {
        supportsStreaming: true,
        supportedLanguages: ['en', 'hi', 'kn'],
      },
    }),
    processVoiceCommand: jest.fn().mockResolvedValue({
      transcription: 'Open Cart',
      intent: 'NAVIGATE',
      action: 'NAVIGATE_CART',
    }),
  };

  const mockTtsService = {
    synthesizeSpeech: jest.fn().mockResolvedValue({
      audioBase64: 'BASE64',
    }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [VoiceController],
      providers: [
        { provide: VoiceService, useValue: mockVoiceService },
        { provide: SpeechSynthesisService, useValue: mockTtsService },
      ],
    }).compile();

    controller = module.get<VoiceController>(VoiceController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should handle POST /voice/search with queryHint and return catalogue items', async () => {
    const response = await controller.searchVoice('cust_101', {
      queryHint: 'Find one litre of milk',
      languageHint: 'en_IN',
    });

    expect(response).toBeDefined();
    expect(response.success).toBe(true);
    expect(response.data.transcription).toBe('Find one litre of milk');
    expect(response.data.results.length).toBe(1);
    expect(response.data.results[0].name).toBe('Amul Taaza Milk 1L');
    expect(mockVoiceService.searchVoiceProducts).toHaveBeenCalledWith(
      'cust_101',
      expect.objectContaining({ queryHint: 'Find one litre of milk' }),
      undefined,
    );
  });

  it('should handle POST /voice/search with uploaded audio file', async () => {
    const mockFile = {
      buffer: Buffer.alloc(100),
      mimetype: 'audio/wav',
      originalname: 'mic_input.wav',
    };

    const response = await controller.searchVoice(
      'cust_101',
      { languageHint: 'en_IN' },
      mockFile as any,
    );

    expect(response.success).toBe(true);
    expect(mockVoiceService.searchVoiceProducts).toHaveBeenCalledWith(
      'cust_101',
      expect.objectContaining({ mimeType: 'audio/wav' }),
      mockFile.buffer,
    );
  });

  it('should handle GET /voice/provider/status', async () => {
    const status = await controller.getProviderStatus();
    expect(status).toBeDefined();
    expect(status.provider).toBe('voicestudio');
    expect(status.isAvailable).toBe(true);
  });
});
