import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { DeliveryService } from './delivery.service';

@ApiTags('Delivery & GPS Tracking')
@Controller('delivery')
export class DeliveryController {
  constructor(private readonly deliveryService: DeliveryService) {}

  @Get('track/:orderId')
  @ApiOperation({ summary: 'Get live GPS tracking and delivery telemetry' })
  async getOrderTracking(@Param('orderId') orderId: string) {
    return this.deliveryService.getOrderTracking(orderId);
  }

  @Post('status-update')
  @ApiOperation({ summary: 'Update order fulfillment status (Driver / Admin trigger)' })
  async updateStatus(@Body() body: { orderId: string; status: any }) {
    return this.deliveryService.updateDeliveryStatus(body.orderId, body.status);
  }
}
