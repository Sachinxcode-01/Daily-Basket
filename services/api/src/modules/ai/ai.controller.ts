import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  Res,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import { AiService } from './ai.service';
import { RecommendationType } from './services/recommendation.service';
import { ApiTags, ApiOperation, ApiQuery, ApiBody, ApiConsumes } from '@nestjs/swagger';

@ApiTags('ai')
@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('chat')
  @ApiOperation({ summary: 'Send message to Sarah J. AI Assistant' })
  async chat(
    @Body()
    body: {
      userId?: string;
      message: string;
      sessionId?: string;
      context?: Record<string, any>;
    },
  ) {
    const userId = body.userId || 'user_demo_01';
    return this.aiService.processChat(
      userId,
      body.message,
      body.sessionId,
      body.context,
    );
  }

  @Get('product-insight')
  @ApiOperation({ summary: 'Get AI product insights (benefits, usage, storage, health score)' })
  @ApiQuery({ name: 'productId', required: true })
  async getProductInsight(@Query('productId') productId: string) {
    return this.aiService.getProductAiInsight(productId);
  }

  @Get('recommendations')
  @ApiOperation({ summary: 'Get Smart Product Recommendations (12 channels)' })
  @ApiQuery({ name: 'type', enum: RecommendationType, required: false })
  @ApiQuery({ name: 'productId', required: false })
  @ApiQuery({ name: 'userId', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getRecommendations(
    @Query('type') type?: RecommendationType,
    @Query('productId') productId?: string,
    @Query('userId') userId?: string,
    @Query('limit') limit?: number,
  ) {
    return this.aiService.getSmartRecommendations(
      type || RecommendationType.RECOMMENDED_FOR_YOU,
      productId,
      userId,
      limit ? Number(limit) : 6,
    );
  }

  @Post('analyze-image')
  @ApiOperation({ summary: 'AI Image Analysis using Gemini Vision model' })
  @UseInterceptors(FileInterceptor('image'))
  @ApiConsumes('multipart/form-data', 'application/json')
  async analyzeImage(
    @UploadedFile() file?: any,
    @Body('imageBase64') imageBase64?: string,
    @Body('userId') userId?: string,
    @Body('mimeType') mimeType?: string,
    @Body('userNote') userNote?: string,
  ) {
    const base64Str = imageBase64 || (file ? file.buffer.toString('base64') : '');
    return this.aiService.analyzeImage(
      userId || 'user_demo_01',
      base64Str,
      mimeType || file?.mimetype || 'image/jpeg',
      userNote,
    );
  }

  @Get('admin/metrics')
  @ApiOperation({ summary: 'Get AI usage and provider health metrics for Admin' })
  async getAdminMetrics() {
    return this.aiService.getAdminMetrics();
  }
}
