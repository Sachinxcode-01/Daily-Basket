import { Controller, Get, Param } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { AnalyticsService } from './analytics.service';

@ApiTags('Analytics & Admin')
@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get(':storeId')
  @ApiOperation({ summary: 'Get store real-time sales KPIs and fulfillment metrics' })
  async getStoreAnalytics(@Param('storeId') storeId: string) {
    return this.analyticsService.getStoreAnalytics(storeId);
  }
}
