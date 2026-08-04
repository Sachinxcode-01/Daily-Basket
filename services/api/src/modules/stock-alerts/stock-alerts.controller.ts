import { Controller, Get, Post, Delete, Body, Param, Request } from '@nestjs/common';
import { StockAlertsService } from './stock-alerts.service';

@Controller('stock-alerts')
export class StockAlertsController {
  constructor(private readonly stockAlertsService: StockAlertsService) {}

  @Get()
  async getStockAlerts(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.stockAlertsService.getStockAlerts(userId);
  }

  @Post()
  async createStockAlert(
    @Request() req: any,
    @Body() body: { variantId: string },
  ) {
    const userId = req.user?.id || 'demo_user_id';
    return this.stockAlertsService.createStockAlert(userId, body.variantId);
  }

  @Post(':id/toggle')
  async toggleStockAlert(
    @Param('id') id: string,
    @Body() body: { isEnabled: boolean },
  ) {
    return this.stockAlertsService.toggleStockAlert(id, body.isEnabled);
  }

  @Delete(':id')
  async deleteStockAlert(@Param('id') id: string) {
    return this.stockAlertsService.deleteStockAlert(id);
  }
}
