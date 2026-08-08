import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { MultiStoreService, CreateStoreDto } from './multi-store.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/multi-store')
export class MultiStoreController {
  constructor(private readonly multiStoreService: MultiStoreService) {}

  @Get()
  async listStores(@Query('city') city?: string) {
    return this.multiStoreService.listStores(city);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.BUSINESS_OWNER, Role.SUPER_ADMIN)
  async createStore(@Body() dto: CreateStoreDto) {
    return this.multiStoreService.createStore(dto);
  }

  @Get(':id/analytics')
  async getStoreAnalytics(@Param('id') id: string) {
    return this.multiStoreService.getStoreAnalytics(id);
  }
}
