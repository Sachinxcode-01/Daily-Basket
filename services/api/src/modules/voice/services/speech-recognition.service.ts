import { Injectable, Logger, Inject, BadRequestException, ServiceUnavailableException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  SpeechProvider,
  SPEECH_PROVIDER_TOKEN,
  SpeechTranscriptionResult,
  ProviderHealthCheckResult,
  SpeechProviderCapabilities,
} from '../interfaces/speech-provider.interface';
import { LanguageDetectionService } from './language-detection.service';
import { AudioValidationService, ValidatedAudio } from './audio-validation.service';

export interface SttResult {
  transcription: string;
  detectedLanguage: string;
  confidenceScore: number;
  latencyMs: number;
  provider: string;
}

@Injectable()
export class SpeechRecognitionService {
  private readonly logger = new Logger(SpeechRecognitionService.name);

  constructor(
    @Inject(SPEECH_PROVIDER_TOKEN) private speechProvider: SpeechProvider,
    private languageDetector: LanguageDetectionService,
    private audioValidator: AudioValidationService,
    private configService: ConfigService,
  ) {}

  getProviderName(): string {
    return this.speechProvider.name;
  }

  getCapabilities(): SpeechProviderCapabilities {
    return this.speechProvider.getCapabilities();
  }

  async healthCheck(): Promise<ProviderHealthCheckResult> {
    return this.speechProvider.healthCheck();
  }

  /**
   * Transcribes audio buffer using the configured SpeechProvider.
   * If client provides rawTextHint (e.g. from mobile platform on-device STT), validates and uses it.
   * Never fabricates fake transcriptions.
   */
  async transcribeAudio(
    audioBufferOrBase64?: Buffer | string,
    rawTextHint?: string,
    requestedLocale: string = 'en_IN',
    mimeType?: string,
  ): Promise<SttResult> {
    const startTime = Date.now();

    // 1. Direct text hint provided by client (e.g., native on-device speech-to-text)
    if (rawTextHint && rawTextHint.trim().length > 0) {
      const trimmed = rawTextHint.trim();
      const detected = this.languageDetector.detectLanguage(trimmed, requestedLocale);
      return {
        transcription: trimmed,
        detectedLanguage: detected.code,
        confidenceScore: 98.0,
        latencyMs: Date.now() - startTime,
        provider: 'client-stt',
      };
    }

    // 2. Audio input verification
    let buffer: Buffer;
    if (Buffer.isBuffer(audioBufferOrBase64)) {
      buffer = audioBufferOrBase64;
    } else if (typeof audioBufferOrBase64 === 'string' && audioBufferOrBase64.trim().length > 0) {
      try {
        buffer = Buffer.from(audioBufferOrBase64, 'base64');
      } catch (e: any) {
        throw new BadRequestException('Malformed base64 audio payload.');
      }
    } else {
      throw new BadRequestException(
        'No audio or transcription hint provided. Please provide an audio recording or text hint.',
      );
    }

    // 3. Audio format and integrity validation
    const validated: ValidatedAudio = this.audioValidator.validateAudio(buffer, mimeType);
    this.logger.log(
      `Transcribing audio via ${this.speechProvider.name}: ${validated.sizeBytes} bytes, format=${validated.detectedFormat}, mime=${validated.mimeType}`,
    );

    // 4. Delegate to the authoritative SpeechProvider (VoiceStudio, Google, etc.)
    const providerResult: SpeechTranscriptionResult = await this.speechProvider.transcribe(
      validated.buffer,
      {
        languageCode: requestedLocale,
      },
    );

    if (!providerResult.text || providerResult.text.trim() === '') {
      throw new BadRequestException('No speech detected in the audio recording. Please speak clearly and try again.');
    }

    const detected = this.languageDetector.detectLanguage(providerResult.text, requestedLocale);

    return {
      transcription: providerResult.text.trim(),
      detectedLanguage: providerResult.detectedLanguage || detected.code,
      confidenceScore: providerResult.confidence,
      latencyMs: Date.now() - startTime,
      provider: providerResult.provider || this.speechProvider.name,
    };
  }
}
