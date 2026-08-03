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
}
