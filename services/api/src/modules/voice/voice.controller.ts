import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Query,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBody } from '@nestjs/swagger';
import { VoiceService, ProcessVoicePayload } from './voice.service';
import { SpeechSynthesisService, TtsOptions } from './services/speech-synthesis.service';

@ApiTags('Voice')
@Controller('voice')
export class VoiceController {
  constructor(
    private readonly voiceService: VoiceService,
    private readonly ttsService: SpeechSynthesisService,
  ) {}

  @Post('process')
  @ApiOperation({ summary: 'Process Spoken Voice Command (Audio Base64 or Text Hint)' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        userId: { type: 'string' },
        audioBase64: { type: 'string' },
        transcriptionHint: { type: 'string', example: 'Open Cart' },
        currentRoute: { type: 'string', example: '/home' },
        locale: { type: 'string', example: 'en_IN' },
      },
    },
  })
  async processVoiceCommand(@Body() body: ProcessVoicePayload) {
    return this.voiceService.processVoiceCommand(body);
  }

  @Post('synthesize')
  @ApiOperation({ summary: 'Synthesize Spoken Text to Audio via Google Cloud TTS' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        text: { type: 'string', example: 'Your 10-minute grocery order has been confirmed.' },
        languageCode: { type: 'string', example: 'en_IN' },
        gender: { type: 'string', example: 'FEMALE' },
        speechRate: { type: 'number', example: 1.0 },
      },
    },
  })
  async synthesizeSpeech(
    @Body('text') text: string,
    @Body('languageCode') languageCode?: string,
    @Body('gender') gender?: 'FEMALE' | 'MALE',
    @Body('speechRate') speechRate?: number,
  ) {
    return this.ttsService.synthesizeSpeech(text || 'Welcome to Daily Basket', {
      languageCode,
      gender,
      speechRate,
    });
  }

  @Get('settings')
  @ApiOperation({ summary: 'Get User Voice AI Preferences & Settings' })
  @ApiQuery({ name: 'userId', required: false })
  async getSettings(@Query('userId') userId?: string) {
    return this.voiceService.getUserVoiceSettings(userId || 'user_demo_01');
  }

  @Put('settings')
  @ApiOperation({ summary: 'Update User Voice AI Preferences & Settings' })
  async updateSettings(
    @Body()
    body: {
      userId?: string;
      voiceEnabled?: boolean;
      preferredLanguage?: string;
      preferredVoiceGender?: 'FEMALE' | 'MALE';
      speechSpeed?: number;
      autoSpeak?: boolean;
      privacyMode?: boolean;
    },
  ) {
    return this.voiceService.updateVoiceSettings(body.userId || 'user_demo_01', body);
  }

  @Get('history')
  @ApiOperation({ summary: 'Get Recent Voice Command History' })
  @ApiQuery({ name: 'userId', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getHistory(
    @Query('userId') userId?: string,
    @Query('limit') limit?: number,
  ) {
    return this.voiceService.getVoiceHistory(userId || 'user_demo_01', limit ? Number(limit) : 20);
  }

  @Delete('history')
  @ApiOperation({ summary: 'Clear User Voice Command History' })
  @ApiQuery({ name: 'userId', required: false })
  async clearHistory(@Query('userId') userId?: string) {
    return this.voiceService.clearVoiceHistory(userId || 'user_demo_01');
  }
}
