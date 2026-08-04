import { Controller, Get, Post, Body, Request } from '@nestjs/common';
import { QuickBuyService } from './quick-buy.service';

@Controller('quick-buy')
export class QuickBuyController {
  constructor(private readonly quickBuyService: QuickBuyService) {}

  @Get()
  async getEssentials(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.quickBuyService.getEssentials(userId);
  }

  @Post('cart')
  async syncCart(
    @Request() req: any,
    @Body() body: { items: Array<{ id: string; qty: number }> },
  ) {
    const userId = req.user?.id || 'demo_user_id';
    return this.quickBuyService.syncCart(userId, body.items || []);
  }

  @Post('bulk-add')
  async bulkAdd(
    @Request() req: any,
    @Body() body: { items: Array<{ id: string; qty: number }> },
  ) {
    const userId = req.user?.id || 'demo_user_id';
    return this.quickBuyService.bulkAdd(userId, body.items || []);
  }
}
