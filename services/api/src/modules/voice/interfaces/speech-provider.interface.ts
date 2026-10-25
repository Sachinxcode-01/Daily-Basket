export interface TranscribeOptions {
  languageCode?: string;
  model?: string;
  prompt?: string;
  temperature?: number;
}

export interface SpeechTranscriptionResult {
  text: string;
  confidence: number;
  detectedLanguage: string;
  latencyMs: number;
  provider: string;
  rawResponse?: any;
}

export interface ProviderHealthCheckResult {
  isAvailable: boolean;
  provider: string;
  endpoint?: string;
  latencyMs?: number;
  error?: string;
  modelLoaded?: string;
  details?: Record<string, any>;
}

export interface SpeechProviderCapabilities {
  supportsStreaming: boolean;
  supportedMimeTypes: string[];
  supportedLanguages: string[];
  maxAudioBytes: number;
  maxAudioDurationSeconds: number;
  modelName: string;
}

export const SPEECH_PROVIDER_TOKEN = 'SPEECH_PROVIDER';

export interface SpeechProvider {
  readonly name: string;
  transcribe(audio: Buffer, options?: TranscribeOptions): Promise<SpeechTranscriptionResult>;
  healthCheck(): Promise<ProviderHealthCheckResult>;
  getCapabilities(): SpeechProviderCapabilities;
}
