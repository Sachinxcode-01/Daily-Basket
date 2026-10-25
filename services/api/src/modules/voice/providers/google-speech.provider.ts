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
export class GoogleCloudSpeechProvider implements SpeechProvider {
  readonly name = 'google';
  private readonly logger = new Logger(GoogleCloudSpeechProvider.name);

  private readonly apiKey?: string;
  private readonly timeoutMs: number;

  constructor(private configService: ConfigService) {
    this.apiKey =
      this.configService.get<string>('GOOGLE_CLOUD_API_KEY') ||
      this.configService.get<string>('google.cloudApiKey') ||
      process.env.GOOGLE_CLOUD_API_KEY;

    this.timeoutMs =
      parseInt(
        this.configService.get<string>('VOICE_REQUEST_TIMEOUT_MS') ||
        process.env.VOICE_REQUEST_TIMEOUT_MS ||
        '',
        10,
      ) || 10000;
  }

  getCapabilities(): SpeechProviderCapabilities {
    return {
      supportsStreaming: true,
      supportedMimeTypes: ['audio/wav', 'audio/webm', 'audio/ogg', 'audio/mpeg', 'audio/mp4'],
      supportedLanguages: ['en-IN', 'hi-IN', 'kn-IN', 'ta-IN', 'te-IN', 'mr-IN', 'bn-IN'],
      maxAudioBytes: 10 * 1024 * 1024,
      maxAudioDurationSeconds: 60,
      modelName: 'google-speech-v1',
    };
  }

  async healthCheck(): Promise<ProviderHealthCheckResult> {
    if (!this.apiKey) {
      return {
        isAvailable: false,
        provider: this.name,
        error: 'GOOGLE_CLOUD_API_KEY is not configured in environment variables.',
      };
    }

    return {
      isAvailable: true,
      provider: this.name,
      endpoint: 'https://speech.googleapis.com/v1/speech:recognize',
      modelLoaded: 'google-speech-v1',
    };
  }

  async transcribe(
    audio: Buffer,
    options?: TranscribeOptions,
  ): Promise<SpeechTranscriptionResult> {
    const startTime = Date.now();

    if (!this.apiKey) {
      throw new ServiceUnavailableException(
        'Google Cloud Speech provider is not configured (missing GOOGLE_CLOUD_API_KEY).',
      );
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), this.timeoutMs);

    const base64Audio = audio.toString('base64');
    const languageCode = (options?.languageCode || 'en_IN').replace('_', '-');

    try {
      const response = await fetch(
        `https://speech.googleapis.com/v1/speech:recognize?key=${this.apiKey}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            config: {
              languageCode,
              enableAutomaticPunctuation: true,
            },
            audio: {
              content: base64Audio,
            },
          }),
          signal: controller.signal,
        },
      );

      clearTimeout(timeout);
      const latencyMs = Date.now() - startTime;

      if (!response.ok) {
        const errJson = (await response.json().catch(() => null)) as any;
        const msg = errJson?.error?.message || response.statusText;
        throw new ServiceUnavailableException(`Google Speech STT error HTTP ${response.status}: ${msg}`);
      }

      const data = (await response.json()) as any;
      const alt = data.results?.[0]?.alternatives?.[0];

      if (!alt || !alt.transcript) {
        return {
          text: '',
          confidence: 0,
          detectedLanguage: languageCode,
          latencyMs,
          provider: this.name,
          rawResponse: data,
        };
      }

      return {
        text: alt.transcript.trim(),
        confidence: Math.round((alt.confidence || 0.95) * 100),
        detectedLanguage: languageCode,
        latencyMs,
        provider: this.name,
        rawResponse: data,
      };
    } catch (err: any) {
      clearTimeout(timeout);
      if (err instanceof ServiceUnavailableException) throw err;
      throw new ServiceUnavailableException(
        `Google Speech transcription failed: ${err?.message || err}`,
      );
    }
  }
}
