import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { InventoryService } from './inventory.service';

@ApiTags('Inventory')
@Controller('inventory')
export class InventoryController {
  constructor(private readonly inventoryService: InventoryService) {}

  @Get(':storeId')
  @ApiOperation({ summary: 'Get store real-time inventory level' })
  async getStoreInventory(@Param('storeId') storeId: string) {
    return this.inventoryService.getStoreInventory(storeId);
  }

  @Post(':storeId/update')
  @ApiOperation({ summary: 'Update stock count for a variant' })
  async updateStock(
    @Param('storeId') storeId: string,
    @Body() body: { variantId: string; stockQuantity: number },
  ) {
    return this.inventoryService.updateStock(storeId, body.variantId, body.stockQuantity);
  }

  @Get('vendors/list')
  @ApiOperation({ summary: 'Get list of active suppliers & vendors' })
  async getVendors() {
    return this.inventoryService.getVendors();
  }

  @Post('purchase-orders/create')
  @ApiOperation({ summary: 'Create automated or manual supplier Purchase Order' })
  async createPurchaseOrder(@Body() body: { vendorId: string; storeId: string; items: any[] }) {
    return this.inventoryService.createPurchaseOrder(body.vendorId, body.storeId, body.items);
  }

  @Post('goods-inward')
  @ApiOperation({ summary: 'Process Goods Inward (GRN) with batch numbers & expiry dates' })
  async processGoodsInward(@Body() body: { poId: string; batchNumber: string; expiryDate: string; itemsReceived: any[] }) {
    return this.inventoryService.processGoodsInward(body.poId, body.batchNumber, body.expiryDate, body.itemsReceived);
  }

  @Post('stock-transfer')
  @ApiOperation({ summary: 'Transfer inventory between dark stores' })
  async transferStock(@Body() body: { sourceStoreId: string; destStoreId: string; variantId: string; quantity: number }) {
    return this.inventoryService.transferStock(body.sourceStoreId, body.destStoreId, body.variantId, body.quantity);
  }

  @Get('expiry-alerts/:storeId')
  @ApiOperation({ summary: 'Get upcoming batch expiry reminders & near-expiry inventory' })
  async getExpiryAlerts(@Param('storeId') storeId: string) {
    return this.inventoryService.getExpiryAlerts(storeId);
  }

  @Post('qr-lookup')
  @ApiOperation({ summary: 'Lookup stock details via barcode or QR payload' })
  async qrLookup(@Body() body: { barcode: string }) {
    return this.inventoryService.qrLookup(body.barcode);
  }

  @Post(':storeId/cycle-count')
  @ApiOperation({ summary: 'Trigger nightly automated cycle count and stock reconciliation' })
  async runNightlyCycleCount(@Param('storeId') storeId: string) {
    return this.inventoryService.runNightlyCycleCount(storeId);
  }

  @Post(':storeId/audit-discrepancy')
  @ApiOperation({ summary: 'Log physical shelf discrepancy with reason code (spoilage, shrinkage, transit damage)' })
  async logAuditDiscrepancy(
    @Param('storeId') storeId: string,
    @Body() body: {
      auditedBy: string;
      variantId: string;
      expectedQty: number;
      actualQty: number;
      reasonCode: 'SPOILAGE' | 'SHRINKAGE' | 'DAMAGED_IN_TRANSIT' | 'MISCOUNT';
      notes?: string;
    },
  ) {
    return this.inventoryService.logAuditDiscrepancy(storeId, body);
  }

  @Get(':storeId/fifo-batches')
  @ApiOperation({ summary: 'Get FIFO-sorted batches with shelf locations & automated markdown actions' })
  async getBatchFifoStatus(@Param('storeId') storeId: string) {
    return this.inventoryService.getBatchFifoStatus(storeId);
  }
}


