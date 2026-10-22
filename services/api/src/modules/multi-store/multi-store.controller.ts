import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam, ApiQuery } from '@nestjs/swagger';
import { MultiStoreService, CreateStoreDto, ResolveOptimalStoreInput } from './multi-store.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@ApiTags('Multi-Store Dispatch & Hubs')
@Controller(['multi-store', 'api/multi-store', 'api/v1/multi-store'])
export class MultiStoreController {
  constructor(private readonly multiStoreService: MultiStoreService) {}

  @Get()
  @ApiOperation({ summary: 'List all operational dark stores across service cities' })
  @ApiQuery({ name: 'city', required: false })
  async listStores(@Query('city') city?: string) {
    return this.multiStoreService.listStores(city);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.BUSINESS_OWNER, Role.SUPER_ADMIN)
  @ApiOperation({ summary: 'Register a new dark store hub or franchise facility' })
  async createStore(@Body() dto: CreateStoreDto) {
    return this.multiStoreService.createStore(dto);
  }

  @Post('dispatch/resolve')
  @ApiOperation({ summary: 'Resolve optimal dark store via Haversine distance, stock check, and queue load balancing' })
  async resolveOptimalStore(@Body() body: ResolveOptimalStoreInput) {
    return this.multiStoreService.resolveOptimalStore(body);
  }

  @Get('dispatch/overview')
  @ApiOperation({ summary: 'Get live dark store network dispatch telemetry and active queue loads' })
  async getNetworkDispatchOverview() {
    return this.multiStoreService.getNetworkDispatchOverview();
  }

  @Get('dispatch/zones')
  @ApiOperation({ summary: 'Get serviceable geofence coverage zones and centroids for live maps' })
  async getServiceableZones() {
    return this.multiStoreService.getServiceableZones();
  }

  @Get(':id/analytics')
  @ApiOperation({ summary: 'Get store fulfillment SLAs and revenue performance analytics' })
  @ApiParam({ name: 'id', description: 'Store UUID' })
  async getStoreAnalytics(@Param('id') id: string) {
    return this.multiStoreService.getStoreAnalytics(id);
  }
}
