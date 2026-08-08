import { Module } from '@nestjs/common';
import { VoiceController } from './voice.controller';
import { VoiceAdminController } from './voice-admin.controller';
import { VoiceService } from './voice.service';
import { SpeechRecognitionService } from './services/speech-recognition.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';
import { ConversationMemoryService } from './services/conversation-memory.service';
import { LanguageDetectionService } from './services/language-detection.service';
import { PrismaService } from '../../database/prisma.service';
import { SearchModule } from '../search/search.module';
import { AiModule } from '../ai/ai.module';

@Module({
  imports: [SearchModule, AiModule],
  controllers: [VoiceController, VoiceAdminController],
  providers: [
    VoiceService,
    SpeechRecognitionService,
    SpeechSynthesisService,
    ConversationMemoryService,
    LanguageDetectionService,
    PrismaService,
  ],
  exports: [
    VoiceService,
    SpeechRecognitionService,
    SpeechSynthesisService,
    ConversationMemoryService,
    LanguageDetectionService,
  ],
})
export class VoiceModule {}
