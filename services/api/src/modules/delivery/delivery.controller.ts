import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { DeliveryService } from './delivery.service';
import { GeofenceService } from './geofence.service';
import { TimedDispatchService } from './timed-dispatch.service';

@ApiTags('Delivery & GPS Tracking')
@Controller('delivery')
export class DeliveryController {
  constructor(
    private readonly deliveryService: DeliveryService,
    private readonly geofenceService: GeofenceService,
    private readonly timedDispatchService: TimedDispatchService,
  ) {}

  @Post('dispatch/:orderId')
  @ApiOperation({ summary: 'Evaluate timed dispatch (60% packing progress) and dynamic corridor batching' })
  async dispatchOrder(
    @Param('orderId') orderId: string,
    @Body() body: { forceImmediate?: boolean },
  ) {
    return this.timedDispatchService.dispatchOrder(orderId, body?.forceImmediate);
  }

  @Get('dispatch-status/:storeId')
  @ApiOperation({ summary: 'Get live dark store fleet dispatch roster & availability heatmap' })
  async getDispatchStatus(@Param('storeId') storeId: string) {
    return this.timedDispatchService.getFleetDispatchStatus(storeId);
  }

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

  @Post('geofence-check')
  @ApiOperation({ summary: 'Evaluate dark store geofence coverage and delivery serviceability' })
  async evaluateGeofence(
    @Body() body: { lat: number; lng: number; itemTotal?: number },
  ) {
    return this.geofenceService.evaluateGeofence(
      { lat: body.lat, lng: body.lng },
      body.itemTotal || 0,
    );
  }

  @Post('surge-pricing')
  @ApiOperation({ summary: 'Calculate dynamic surge delivery pricing based on location and demand' })
  async calculateSurgePricing(
    @Body() body: { lat: number; lng: number; itemTotal?: number },
  ) {
    const result = this.geofenceService.evaluateGeofence(
      { lat: body.lat, lng: body.lng },
      body.itemTotal || 0,
    );
    return result.surgePricing;
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

  @Post('sync-offline-queue')
  @ApiOperation({ summary: 'Process batch of queued offline delivery actions' })
  async syncOfflineQueue(@Body() body: { actions: Array<{ id: string; type: string; orderId: string; payload: any; timestamp: string }> }) {
    return this.deliveryService.syncOfflineQueue(body.actions || []);
  }
}




