import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { WarehouseService, CreateWarehouseDto, CreateTransferDto } from './warehouse.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/warehouse')
export class WarehouseController {
  constructor(private readonly warehouseService: WarehouseService) {}

  @Get()
  async listWarehouses(@Query('city') city?: string) {
    return this.warehouseService.listWarehouses(city);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.INVENTORY_MANAGER, Role.BUSINESS_OWNER)
  async createWarehouse(@Body() dto: CreateWarehouseDto) {
    return this.warehouseService.createWarehouse(dto);
  }

  @Get('transfers')
  async listTransfers() {
    return this.warehouseService.listTransfers();
  }

  @Post('transfers')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.INVENTORY_MANAGER, Role.BUSINESS_OWNER)
  async createTransfer(@Body() dto: CreateTransferDto) {
    return this.warehouseService.createTransfer(dto);
  }
}
