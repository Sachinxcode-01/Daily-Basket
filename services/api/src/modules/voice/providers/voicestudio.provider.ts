import { Injectable, Logger, ServiceUnavailableException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  SpeechProvider,
  TranscribeOptions,
  SpeechTranscriptionResult,
  ProviderHealthCheckResult,
  SpeechProviderCapabilities,
} from '../interfaces/speech-provider.interface';

@Injectable()
export class VoiceStudioProvider implements SpeechProvider {
  readonly name = 'voicestudio';
  private readonly logger = new Logger(VoiceStudioProvider.name);

  private readonly baseUrl: string;
  private readonly apiKey?: string;
  private readonly timeoutMs: number;
  private readonly defaultModel: string;
  private readonly maxAudioBytes: number;
  private readonly maxAudioDurationSeconds: number;

  constructor(private configService: ConfigService) {
    this.baseUrl = (
      this.configService.get<string>('VOICESTUDIO_BASE_URL') ||
      process.env.VOICESTUDIO_BASE_URL ||
      'http://127.0.0.1:8000'
    ).replace(/\/+$/, '');

    this.apiKey =
      this.configService.get<string>('VOICESTUDIO_API_KEY') ||
      process.env.VOICESTUDIO_API_KEY;

    this.timeoutMs =
      parseInt(
        this.configService.get<string>('VOICE_REQUEST_TIMEOUT_MS') ||
        process.env.VOICE_REQUEST_TIMEOUT_MS ||
        '',
        10,
      ) || 10000;

    this.defaultModel =
      this.configService.get<string>('VOICESTUDIO_MODEL') ||
      process.env.VOICESTUDIO_MODEL ||
      'whisper-tiny';

    this.maxAudioBytes =
      parseInt(
        this.configService.get<string>('VOICE_MAX_AUDIO_BYTES') ||
        process.env.VOICE_MAX_AUDIO_BYTES ||
        '',
        10,
      ) || 10 * 1024 * 1024;

    this.maxAudioDurationSeconds =
      parseInt(
        this.configService.get<string>('VOICE_MAX_AUDIO_DURATION_SECONDS') ||
        process.env.VOICE_MAX_AUDIO_DURATION_SECONDS ||
        '',
        10,
      ) || 30;
  }

  getCapabilities(): SpeechProviderCapabilities {
    return {
      supportsStreaming: true, // VoiceStudio supports WebSocket-based streaming dictation
      supportedMimeTypes: [
        'audio/wav',
        'audio/x-wav',
        'audio/webm',
        'audio/ogg',
        'audio/mpeg',
        'audio/mp3',
        'audio/m4a',
        'audio/flac',
      ],
      supportedLanguages: ['en', 'hi', 'kn', 'ta', 'te', 'mr', 'bn', 'gu', 'ur'],
      maxAudioBytes: this.maxAudioBytes,
      maxAudioDurationSeconds: this.maxAudioDurationSeconds,
      modelName: this.defaultModel,
    };
  }

  async healthCheck(): Promise<ProviderHealthCheckResult> {
    const startTime = Date.now();
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), Math.min(3000, this.timeoutMs));

    try {
      // VoiceStudio exposes /health or /v1/models
      const headers: Record<string, string> = { Accept: 'application/json' };
      if (this.apiKey) {
        headers['Authorization'] = `Bearer ${this.apiKey}`;
      }

      const res = await fetch(`${this.baseUrl}/health`, {
        method: 'GET',
        headers,
        signal: controller.signal,
      }).catch(async () => {
        // Fallback probe to /v1/models if /health is not implemented
        return fetch(`${this.baseUrl}/v1/models`, {
          method: 'GET',
          headers,
          signal: controller.signal,
        });
      });

      clearTimeout(timeout);
      const latencyMs = Date.now() - startTime;

      if (res.ok) {
        return {
          isAvailable: true,
          provider: this.name,
          endpoint: this.baseUrl,
          latencyMs,
          modelLoaded: this.defaultModel,
        };
      }

      return {
        isAvailable: false,
        provider: this.name,
        endpoint: this.baseUrl,
        latencyMs,
        error: `VoiceStudio endpoint returned HTTP ${res.status}: ${res.statusText}`,
      };
    } catch (err: any) {
      clearTimeout(timeout);
      const isTimeout = err?.name === 'AbortError';
      const errorMsg = isTimeout
        ? `Connection timed out after ${this.timeoutMs}ms reaching VoiceStudio at ${this.baseUrl}`
        : `VoiceStudio connection error at ${this.baseUrl}: ${err?.message || err}`;

      this.logger.debug(`VoiceStudio health check: ${errorMsg}`);
      return {
        isAvailable: false,
        provider: this.name,
        endpoint: this.baseUrl,
        error: errorMsg,
      };
    }
  }

  async transcribe(
    audio: Buffer,
    options?: TranscribeOptions,
  ): Promise<SpeechTranscriptionResult> {
    const startTime = Date.now();

    if (!audio || audio.length === 0) {
      throw new Error('Audio payload is empty');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), this.timeoutMs);

    try {
      // Build standard multipart/form-data for VoiceStudio OpenAI-compatible ASR endpoint
      const formData = new FormData();
      const blob = new Blob([new Uint8Array(audio)], { type: 'audio/wav' });
      formData.append('file', blob, 'audio.wav');
      formData.append('model', options?.model || this.defaultModel);

      if (options?.languageCode) {
        // Format ISO code e.g. "en_IN" -> "en"
        const cleanLang = options.languageCode.split('_')[0].toLowerCase();
        formData.append('language', cleanLang);
      }

      if (options?.prompt) {
        formData.append('prompt', options.prompt);
      }

      const headers: Record<string, string> = {};
      if (this.apiKey) {
        headers['Authorization'] = `Bearer ${this.apiKey}`;
      }

      const response = await fetch(`${this.baseUrl}/v1/audio/transcriptions`, {
        method: 'POST',
        headers,
        body: formData,
        signal: controller.signal,
      });

      clearTimeout(timeout);
      const latencyMs = Date.now() - startTime;

      if (!response.ok) {
        const errText = await response.text().catch(() => '');
        this.logger.error(
          `VoiceStudio transcription failed with HTTP ${response.status}: ${errText}`,
        );
        throw new ServiceUnavailableException(
          `Speech recognition provider returned HTTP ${response.status}: ${errText || response.statusText}`,
        );
      }

      const json = (await response.json()) as any;
      const transcriptionText = (json.text || json.transcription || '').trim();

      if (!transcriptionText) {
        this.logger.warn('VoiceStudio returned 200 OK but empty transcription text.');
      }

      return {
        text: transcriptionText,
        confidence: typeof json.confidence === 'number' ? json.confidence : 95.0,
        detectedLanguage: json.language || options?.languageCode || 'en',
        latencyMs,
        provider: this.name,
        rawResponse: json,
      };
    } catch (err: any) {
      clearTimeout(timeout);
      const isTimeout = err?.name === 'AbortError';
      const message = isTimeout
        ? `VoiceStudio transcription request timed out after ${this.timeoutMs}ms`
        : err?.message || 'VoiceStudio connection error';

      this.logger.error(`VoiceStudio transcription error: ${message}`);
      throw new ServiceUnavailableException(
        `VoiceStudio provider unavailable or unresponsive: ${message}. Ensure VoiceStudio service is running at ${this.baseUrl}.`,
      );
    }
  }
}
