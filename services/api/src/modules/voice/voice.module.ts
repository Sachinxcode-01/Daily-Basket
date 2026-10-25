import { Module, Provider } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { VoiceController } from './voice.controller';
import { VoiceAdminController } from './voice-admin.controller';
import { VoiceService } from './voice.service';
import { SpeechRecognitionService } from './services/speech-recognition.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';
import { ConversationMemoryService } from './services/conversation-memory.service';
import { LanguageDetectionService } from './services/language-detection.service';
import { AudioValidationService } from './services/audio-validation.service';
import { TranscriptionNormalizerService } from './services/transcription-normalizer.service';
import { PrismaService } from '../../database/prisma.service';
import { SearchModule } from '../search/search.module';
import { AiModule } from '../ai/ai.module';
import { VoiceStudioProvider } from './providers/voicestudio.provider';
import { GoogleCloudSpeechProvider } from './providers/google-speech.provider';
import { SPEECH_PROVIDER_TOKEN, SpeechProvider } from './interfaces/speech-provider.interface';

const speechProviderFactory: Provider = {
  provide: SPEECH_PROVIDER_TOKEN,
  useFactory: (
    configService: ConfigService,
    voiceStudio: VoiceStudioProvider,
    googleSpeech: GoogleCloudSpeechProvider,
  ): SpeechProvider => {
    const providerName = (
      configService.get<string>('VOICE_PROVIDER') ||
      process.env.VOICE_PROVIDER ||
      'voicestudio'
    ).toLowerCase();

    if (providerName === 'google' || providerName === 'google-cloud') {
      return googleSpeech;
    }

    // Default: VoiceStudio
    return voiceStudio;
  },
  inject: [ConfigService, VoiceStudioProvider, GoogleCloudSpeechProvider],
};

@Module({
  imports: [SearchModule, AiModule],
  controllers: [VoiceController, VoiceAdminController],
  providers: [
    VoiceStudioProvider,
    GoogleCloudSpeechProvider,
    speechProviderFactory,
    AudioValidationService,
    TranscriptionNormalizerService,
    SpeechRecognitionService,
    SpeechSynthesisService,
    ConversationMemoryService,
    LanguageDetectionService,
    VoiceService,
    PrismaService,
  ],
  exports: [
    VoiceService,
    SpeechRecognitionService,
    SpeechSynthesisService,
    ConversationMemoryService,
    LanguageDetectionService,
    AudioValidationService,
    TranscriptionNormalizerService,
    SPEECH_PROVIDER_TOKEN,
  ],
})
export class VoiceModule {}
