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

  @Get('admin/fraud-dashboard')
  @ApiOperation({ summary: 'Get security fraud monitoring and risk alerts' })
  async getFraudDashboard() {
    return this.analyticsService.getFraudDashboard();
  }

  @Get('admin/heat-maps')
  @ApiOperation({ summary: 'Get dark store delivery order density heat map' })
  async getDeliveryHeatMaps() {
    return this.analyticsService.getDeliveryHeatMaps();
  }

  @Get('admin/coupon-analytics')
  @ApiOperation({ summary: 'Get promo coupon performance and redemption metrics' })
  async getCouponAnalytics() {
    return this.analyticsService.getCouponAnalytics();
  }

  @Get('admin/export-report')
  @ApiOperation({ summary: 'Export store performance data report in CSV' })
  async exportReport() {
    return this.analyticsService.exportReport();
  }
}

