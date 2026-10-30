import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { DashboardService } from './dashboard.service';

@ApiTags('Dashboard')
@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get('overview')
  @ApiOperation({ summary: 'Dashboard overview stats' })
  async overview() {
    return this.dashboardService.getOverview();
  }

  @Get('recent-orders')
  @ApiOperation({ summary: 'Recent orders for dashboard' })
  async recentOrders(@Query('limit') limit?: number) {
    return this.dashboardService.getRecentOrders(Number(limit) || 20);
  }
}
