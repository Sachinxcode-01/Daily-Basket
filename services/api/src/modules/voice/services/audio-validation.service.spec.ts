import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { BadRequestException } from '@nestjs/common';
import { AudioValidationService } from './audio-validation.service';

describe('AudioValidationService', () => {
  let service: AudioValidationService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AudioValidationService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string) => {
              if (key === 'VOICE_MAX_AUDIO_BYTES') return '1048576'; // 1MB for test
              if (key === 'VOICE_MAX_AUDIO_DURATION_SECONDS') return '30';
              return null;
            }),
          },
        },
      ],
    }).compile();

    service = module.get<AudioValidationService>(AudioValidationService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should reject empty audio buffer (0 bytes)', () => {
    expect(() => service.validateAudio(Buffer.alloc(0))).toThrow(BadRequestException);
    expect(() => service.validateAudio(null)).toThrow(BadRequestException);
  });

  it('should reject audio recording that is too short (< 64 bytes)', () => {
    const smallBuffer = Buffer.alloc(32);
    expect(() => service.validateAudio(smallBuffer)).toThrow(BadRequestException);
  });

  it('should reject audio exceeding maximum permitted size', () => {
    const oversized = Buffer.alloc(2 * 1024 * 1024); // 2MB > 1MB limit
    expect(() => service.validateAudio(oversized)).toThrow(BadRequestException);
  });

  it('should accept valid WAV audio buffer with RIFF/WAVE header', () => {
    const wavHeader = Buffer.alloc(128);
    // 'RIFF'
    wavHeader.write('RIFF', 0);
    // 'WAVE'
    wavHeader.write('WAVE', 8);

    const validated = service.validateAudio(wavHeader, 'audio/wav');
    expect(validated).toBeDefined();
    expect(validated.detectedFormat).toBe('WAV');
    expect(validated.mimeType).toBe('audio/wav');
  });

  it('should accept valid OGG audio buffer with OggS header', () => {
    const oggBuffer = Buffer.alloc(128);
    // 'OggS'
    oggBuffer.write('OggS', 0);

    const validated = service.validateAudio(oggBuffer, 'audio/ogg');
    expect(validated.detectedFormat).toBe('OGG');
    expect(validated.mimeType).toBe('audio/ogg');
  });

  it('should accept valid WebM audio buffer with EBML header', () => {
    const webmBuffer = Buffer.alloc(128);
    webmBuffer[0] = 0x1a;
    webmBuffer[1] = 0x45;
    webmBuffer[2] = 0xdf;
    webmBuffer[3] = 0xa3;

    const validated = service.validateAudio(webmBuffer, 'audio/webm');
    expect(validated.detectedFormat).toBe('WEBM');
    expect(validated.mimeType).toBe('audio/webm');
  });

  it('should reject unsupported MIME type', () => {
    const buf = Buffer.alloc(128);
    expect(() => service.validateAudio(buf, 'video/mp4')).toThrow(BadRequestException);
    expect(() => service.validateAudio(buf, 'application/pdf')).toThrow(BadRequestException);
  });
});
