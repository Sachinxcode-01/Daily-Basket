import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Query,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiQuery, ApiBody, ApiConsumes, ApiResponse } from '@nestjs/swagger';
import { VoiceService, ProcessVoicePayload } from './voice.service';
import { SpeechSynthesisService } from './services/speech-synthesis.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';
import { VoiceSearchDto, VoiceSearchResponseDto } from './dto/voice-search.dto';

@ApiTags('Voice')
@Controller('voice')
export class VoiceController {
  constructor(
    private readonly voiceService: VoiceService,
    private readonly ttsService: SpeechSynthesisService,
  ) {}

  @Post('search')
  @HttpCode(HttpStatus.OK)
  @UseGuards(OptionalJwtAuthGuard)
  @UseInterceptors(FileInterceptor('audio'))
  @ApiOperation({
    summary: 'Search Daily Basket Grocery Catalogue via Spoken Natural Audio or Voice Hint',
    description:
      'Transcribes audio via configured SpeechProvider (VoiceStudio / Google), normalizes grocery terms, and searches live catalogue.',
  })
  @ApiConsumes('multipart/form-data', 'application/json')
  @ApiResponse({ status: 200, type: VoiceSearchResponseDto })
  async searchVoice(
    @ResolvedUserId() userId: string,
    @Body() body: VoiceSearchDto,
    @UploadedFile() file?: { buffer: Buffer; mimetype?: string; originalname?: string },
  ) {
    const audioBuffer = file?.buffer;
    const effectiveMime = file?.mimetype || body.mimeType;

    const data = await this.voiceService.searchVoiceProducts(
      userId || 'customer_guest',
      {
        ...body,
        mimeType: effectiveMime,
      },
      audioBuffer,
    );

    return {
      success: true,
      data,
    };
  }

  @Get('provider/status')
  @ApiOperation({ summary: 'Check Active Speech Provider Status, Model, and Capabilities' })
  async getProviderStatus() {
    return this.voiceService.getProviderStatus();
  }

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
  @ApiOperation({ summary: 'Synthesize Spoken Text to Audio via Speech Synthesis' })
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
