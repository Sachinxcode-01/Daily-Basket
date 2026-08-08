import { Controller, Get, Put, Body, Param, UseGuards } from '@nestjs/common';
import { StoreOperationsService, UpdateStoreSettingsDto } from './store-operations.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/store-operations')
export class StoreOperationsController {
  constructor(private readonly storeOpsService: StoreOperationsService) {}

  @Get('status')
  async getStatus() {
    return this.storeOpsService.getStoreStatus();
  }

  @Put('toggle-status')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async toggleStatus(@Body() body: { isOpen: boolean; storeId?: string }) {
    return this.storeOpsService.toggleStoreStatus(body.storeId || 'default', body.isOpen);
  }

  @Put('settings')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async updateSettings(@Body() dto: UpdateStoreSettingsDto) {
    return this.storeOpsService.updateStoreSettings('default', dto);
  }
}
