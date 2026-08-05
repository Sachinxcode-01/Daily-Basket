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

  @Post(':id/assign-rider')
  @ApiOperation({ summary: 'Assign rider to order and dispatch socket notification' })
  async assignRider(@Param('id') id: string, @Body() body: { riderId: string; riderName?: string; riderPhone?: string }) {
    return this.ordersService.assignDeliveryPartner(id, body.riderId || 'rider_01', {
      name: body.riderName || 'Ramesh Kumar',
      phone: body.riderPhone || '+91 98765 00112',
      vehicleNumber: 'KA 01 EB 4821',
    });
  }

  @Post(':id/start-delivery')
  @ApiOperation({ summary: 'Mark order as OUT_FOR_DELIVERY and start GPS stream' })
  async startDelivery(@Param('id') id: string) {
    return this.ordersService.startDelivery(id);
  }

  @Post(':id/complete-delivery')
  @ApiOperation({ summary: 'Verify OTP code and complete order delivery + generate GST invoice' })
  async completeDelivery(@Param('id') id: string, @Body() body: { otp?: string }) {
    return this.ordersService.completeDelivery(id, body.otp);
  }
}
