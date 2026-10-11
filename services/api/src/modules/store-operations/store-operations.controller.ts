import { Controller, Get, Post, Put, Body, UseGuards } from '@nestjs/common';
import { StoreOperationsService, UpdateStoreSettingsDto } from './store-operations.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller(['store-operations', 'api/store-operations'])
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

  @Get('control-room')
  async getControlRoom() {
    return this.storeOpsService.getStoreLiveControlRoom();
  }

  @Put('rain-mode')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async toggleRainMode(@Body() body: { isRainMode: boolean; storeId?: string }) {
    return this.storeOpsService.toggleRainMode(body.storeId || 'default', body.isRainMode);
  }

  @Put('promise-buffer')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async adjustPromiseBuffer(@Body() body: { bufferMins: number; storeId?: string }) {
    return this.storeOpsService.adjustPromiseBuffer(body.storeId || 'default', body.bufferMins);
  }

  @Put('soft-close')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async toggleSoftClose(@Body() body: { isSoftClosed: boolean; reason?: string; storeId?: string }) {
    return this.storeOpsService.toggleSoftClose(body.storeId || 'default', body.isSoftClosed, body.reason);
  }

  @Get('business-automation')
  async getBusinessAutomation() {
    return this.storeOpsService.runBusinessAutomation();
  }

  @Get('smart-inventory')
  async getSmartInventory() {
    return this.storeOpsService.getSmartInventoryAnalysis();
  }

  @Get('customer-loyalty')
  async getCustomerLoyalty() {
    return this.storeOpsService.getCustomerLoyaltyMetrics();
  }

  @Get('ai-automation')
  async getAiAutomation() {
    return this.storeOpsService.getAiBusinessAutomation();
  }

  @Get('system-health')
  async getSystemHealth() {
    return this.storeOpsService.getSystemHealthTelemetry();
  }

  @Post('maintenance')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async runMaintenance() {
    return this.storeOpsService.runDatabaseMaintenance();
  }

  @Post('simulation-30-day')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.BUSINESS_OWNER)
  async runSimulation() {
    return this.storeOpsService.run30DayBusinessSimulation();
  }
}

