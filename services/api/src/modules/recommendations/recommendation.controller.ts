import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { RecommendationService } from './recommendation.service';

@ApiTags('Recommendations')
@Controller('recommendations')
export class RecommendationController {
  constructor(private readonly recommendationService: RecommendationService) {}

  @Get('similar')
  @ApiOperation({ summary: 'Similar products within same category' })
  async similar(
    @Query('productId') productId: string,
    @Query('limit') limit?: number,
  ) {
    return this.recommendationService.getSimilarProducts(productId, Number(limit) || 6);
  }

  @Get('frequently-bought-together')
  @ApiOperation({ summary: 'Frequently bought together products' })
  async frequentlyBoughtTogether(
    @Query('productId') productId: string,
    @Query('limit') limit?: number,
  ) {
    return this.recommendationService.getFrequentlyBoughtTogether(productId, Number(limit) || 4);
  }
}
