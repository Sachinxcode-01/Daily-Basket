import { Controller, Post, Get, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { OrdersService } from './orders.service';

@ApiTags('Orders')
@Controller('orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  @ApiOperation({ summary: 'Create new 10-minute quick-commerce order' })
  async createOrder(@Body() body: { userId: string; addressId: string; paymentMethod: any; items: any[] }) {
    return this.ordersService.createOrder(body.userId || 'demo_user_01', body);
  }

  @Get(':id/tracking')
  @ApiOperation({ summary: 'Get live GPS tracking and delivery step status' })
  async getOrderTracking(@Param('id') id: string) {
    return this.ordersService.getOrderTracking(id);
  }
}
