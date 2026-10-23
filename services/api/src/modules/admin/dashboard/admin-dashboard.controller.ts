import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { Role } from '@prisma/client';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { Roles } from '../../../common/decorators/roles.decorator';
import { AdminDashboardService } from './admin-dashboard.service';

@ApiTags('Admin Dashboard')
@ApiBearerAuth()
@Controller('admin/dashboard')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(
  Role.ADMIN,
  Role.SUPER_ADMIN,
  Role.STORE_MANAGER,
  Role.INVENTORY_MANAGER,
  Role.FINANCE_MANAGER,
  Role.BUSINESS_OWNER,
)
export class AdminDashboardController {
  constructor(private readonly dashboardService: AdminDashboardService) {}

  @Get('summary')
  @ApiOperation({ summary: 'Get operational KPI summary for today with SLA and revenue changes' })
  @ApiQuery({ name: 'storeId', required: false, description: 'Filter metrics for specific store' })
  async getSummary(@Query('storeId') storeId?: string) {
    return this.dashboardService.getSummary(storeId);
  }

  @Get('sales')
  @ApiOperation({ summary: 'Get past N-days sales and order trend history' })
  @ApiQuery({ name: 'days', required: false, type: Number, description: 'Number of past days (default 7)' })
  async getSalesTrend(@Query('days') days?: string) {
    const numDays = days ? parseInt(days, 10) : 7;
    return this.dashboardService.getSalesTrend(numDays);
  }

  @Get('recent-orders')
  @ApiOperation({ summary: 'Get live real-time recent order dispatch queue' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Max items to return (default 10)' })
  async getRecentOrders(@Query('limit') limit?: string) {
    const numLimit = limit ? parseInt(limit, 10) : 10;
    return this.dashboardService.getRecentOrders(numLimit);
  }

  @Get('inventory-alerts')
  @ApiOperation({ summary: 'Get low-stock and out-of-stock inventory alerts requiring action' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Max items to return (default 10)' })
  async getInventoryAlerts(@Query('limit') limit?: string) {
    const numLimit = limit ? parseInt(limit, 10) : 10;
    return this.dashboardService.getInventoryAlerts(numLimit);
  }
}
