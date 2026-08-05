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

  @Post('check-location')
  @ApiOperation({ summary: 'Verify 10-minute delivery serviceability for GPS coordinates' })
  async checkLocation(@Body() body: { lat?: number; lng?: number; address?: string }) {
    return this.deliveryService.checkLocation(body.lat, body.lng, body.address);
  }

  @Post('reschedule')
  @ApiOperation({ summary: 'Reschedule delivery time slot' })
  async rescheduleDelivery(@Body() body: { orderId: string; newTimeSlot: string; date: string }) {
    return this.deliveryService.rescheduleDelivery(body.orderId, body.newTimeSlot, body.date);
  }

  @Post('rate')
  @ApiOperation({ summary: 'Submit delivery partner rating and feedback' })
  async rateDelivery(@Body() body: { orderId: string; rating: number; feedback?: string; tipAmount?: number }) {
    return this.deliveryService.rateDelivery(body.orderId, body.rating, body.feedback, body.tipAmount);
  }
}


