import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  Req,
  Res,
  UseGuards,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';
import { AiService } from './ai.service';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('ai')
@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('chat')
  @ApiOperation({ summary: 'Send message to Enterprise AI Agent' })
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

  @Post('chat/stream')
  @ApiOperation({ summary: 'Stream responses from Enterprise AI Agent via SSE' })
  async chatStream(
    @Body()
    body: {
      userId?: string;
      message: string;
      sessionId?: string;
      context?: Record<string, any>;
    },
    @Res() res: Response,
  ) {
    const userId = body.userId || 'user_demo_01';

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    try {
      const stream = this.aiService.streamChat(
        userId,
        body.message,
        body.sessionId,
        body.context,
      );

      for await (const chunk of stream) {
        res.write(`data: ${JSON.stringify(chunk)}\n\n`);
      }
    } catch (err: any) {
      res.write(
        `data: ${JSON.stringify({ type: 'error', content: err.message })}\n\n`,
      );
    } finally {
      res.end();
    }
  }

  @Get('admin/metrics')
  @ApiOperation({ summary: 'Get AI usage and provider health metrics for Admin' })
  async getAdminMetrics() {
    return this.aiService.getAdminMetrics();
  }

  @Post('shopping-query')
  @ApiOperation({ summary: 'Process smart natural language shopping query' })
  async processQuery(@Body('query') query: string) {
    return this.aiService.processAiShoppingQuery(query);
  }

  @Get('substitutions')
  @ApiOperation({ summary: 'Get smart AI product substitutions' })
  async getSubstitutions(@Query('productId') productId: string) {
    return this.aiService.getSmartSubstitutions(productId);
  }

  @Get('demand-forecast')
  @ApiOperation({ summary: 'Get dark store AI demand forecasting' })
  async getDemandForecast(@Query('storeId') storeId: string) {
    return this.aiService.getDemandForecast(storeId);
  }
}
