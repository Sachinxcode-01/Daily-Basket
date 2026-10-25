import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { ServiceUnavailableException } from '@nestjs/common';
import { VoiceStudioProvider } from './voicestudio.provider';

describe('VoiceStudioProvider', () => {
  let provider: VoiceStudioProvider;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VoiceStudioProvider,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string) => {
              if (key === 'VOICESTUDIO_BASE_URL') return 'http://127.0.0.1:8000';
              if (key === 'VOICE_REQUEST_TIMEOUT_MS') return '500';
              if (key === 'VOICESTUDIO_MODEL') return 'whisper-tiny';
              return null;
            }),
          },
        },
      ],
    }).compile();

    provider = module.get<VoiceStudioProvider>(VoiceStudioProvider);
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('should be defined and report provider name', () => {
    expect(provider).toBeDefined();
    expect(provider.name).toBe('voicestudio');
  });

  it('should report provider capabilities', () => {
    const caps = provider.getCapabilities();
    expect(caps).toBeDefined();
    expect(caps.supportsStreaming).toBe(true);
    expect(caps.supportedLanguages).toContain('en');
    expect(caps.supportedLanguages).toContain('hi');
    expect(caps.supportedLanguages).toContain('kn');
  });

  it('should report isAvailable: false when VoiceStudio server is unreachable', async () => {
    jest.spyOn(global, 'fetch').mockRejectedValue(new Error('ECONNREFUSED 127.0.0.1:8000'));

    const health = await provider.healthCheck();
    expect(health.isAvailable).toBe(false);
    expect(health.error).toContain('ECONNREFUSED');
  });

  it('should report isAvailable: true when VoiceStudio server is healthy', async () => {
    jest.spyOn(global, 'fetch').mockResolvedValue({
      ok: true,
      status: 200,
      json: async () => ({ status: 'healthy', model: 'whisper-tiny' }),
    } as any);

    const health = await provider.healthCheck();
    expect(health.isAvailable).toBe(true);
    expect(health.modelLoaded).toBe('whisper-tiny');
  });

  it('should transcribe audio when VoiceStudio responds with 200 OK', async () => {
    jest.spyOn(global, 'fetch').mockResolvedValue({
      ok: true,
      status: 200,
      json: async () => ({ text: 'Find one litre of milk', language: 'en', confidence: 96.5 }),
    } as any);

    const fakeAudio = Buffer.alloc(100);
    const result = await provider.transcribe(fakeAudio, { languageCode: 'en_IN' });

    expect(result.text).toBe('Find one litre of milk');
    expect(result.detectedLanguage).toBe('en');
    expect(result.confidence).toBe(96.5);
    expect(result.provider).toBe('voicestudio');
  });

  it('should throw ServiceUnavailableException when VoiceStudio returns 500 error', async () => {
    jest.spyOn(global, 'fetch').mockResolvedValue({
      ok: false,
      status: 500,
      statusText: 'Internal Server Error',
      text: async () => 'CUDA Out of Memory',
    } as any);

    const fakeAudio = Buffer.alloc(100);
    await expect(provider.transcribe(fakeAudio)).rejects.toThrow(ServiceUnavailableException);
  });
});
