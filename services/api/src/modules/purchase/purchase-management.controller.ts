import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { PurchaseManagementService, CreateSupplierDto, CreatePurchaseOrderDto } from './purchase-management.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/purchase-management')
export class PurchaseManagementController {
  constructor(private readonly purchaseService: PurchaseManagementService) {}

  @Get('suppliers')
  async listSuppliers() {
    return this.purchaseService.listSuppliers();
  }

  @Post('suppliers')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.INVENTORY_MANAGER, Role.BUSINESS_OWNER)
  async createSupplier(@Body() dto: CreateSupplierDto) {
    return this.purchaseService.createSupplier(dto);
  }

  @Get('orders')
  async listPurchaseOrders() {
    return this.purchaseService.listPurchaseOrders();
  }

  @Post('orders')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.INVENTORY_MANAGER, Role.BUSINESS_OWNER)
  async createPurchaseOrder(@Body() dto: CreatePurchaseOrderDto) {
    return this.purchaseService.createPurchaseOrder(dto);
  }

  @Post('orders/:id/grn')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.INVENTORY_MANAGER, Role.BUSINESS_OWNER)
  async recordGoodsReceipt(@Param('id') poId: string, @Body() body: { receivedBy: string; invoiceNumber?: string; invoiceUrl?: string }) {
    return this.purchaseService.recordGoodsReceipt(poId, body.receivedBy || 'STORE_OWNER', body.invoiceNumber, body.invoiceUrl);
  }
}
