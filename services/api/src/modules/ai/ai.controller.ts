import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { AiService } from './ai.service';

@ApiTags('AI & Smart Recommendations')
@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('assistant')
  @ApiOperation({ summary: 'AI natural language grocery search assistant' })
  async shoppingAssistant(@Body() body: { query: string }) {
    return this.aiService.processAiShoppingQuery(body.query);
  }

  @Get('substitutions/:productId')
  @ApiOperation({ summary: 'Get AI smart product substitution recommendations' })
  async getSubstitutions(@Param('productId') productId: string) {
    return this.aiService.getSmartSubstitutions(productId);
  }

  @Get('forecast/:storeId')
  @ApiOperation({ summary: 'Get AI inventory demand forecasting' })
  async getForecast(@Param('storeId') storeId: string) {
    return this.aiService.getDemandForecast(storeId);
  }
}
