import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { DeliveryPartnerService } from './delivery-partner.service';

@ApiTags('Delivery Partner Fleet')
@Controller('delivery-partner')
export class DeliveryPartnerController {
  constructor(private readonly partnerService: DeliveryPartnerService) {}

  @Get('dashboard/:driverId')
  @ApiOperation({ summary: 'Get rider dashboard metrics, active order, and wallet earnings' })
  async getDashboard(@Param('driverId') driverId: string) {
    return this.partnerService.getRiderDashboard(driverId);
  }

  @Post('duty')
  @ApiOperation({ summary: 'Toggle online/offline duty status' })
  async toggleDuty(@Body() body: { driverId: string; isOnline: boolean }) {
    return this.partnerService.toggleDutyStatus(body.driverId, body.isOnline);
  }

  @Post('complete-order')
  @ApiOperation({ summary: 'Verify OTP and mark order delivered' })
  async completeOrder(@Body() body: { orderId: string; otp: string }) {
    return this.partnerService.completeOrder(body.orderId, body.otp);
  }

  @Get('route-optimization/:driverId')
  @ApiOperation({ summary: 'Get optimized batch delivery route navigation' })
  async getRouteOptimization(@Param('driverId') driverId: string) {
    return this.partnerService.getRouteOptimization(driverId);
  }

  @Post('fuel-tracking')
  @ApiOperation({ summary: 'Log rider distance and fuel consumption' })
  async logFuelTracking(@Body() body: { driverId: string; distanceKm: number; fuelLiters?: number }) {
    return this.partnerService.logFuelTracking(body.driverId, body.distanceKm, body.fuelLiters);
  }

  @Get('weekly-performance/:driverId')
  @ApiOperation({ summary: 'Get weekly performance, earnings, tips, and rider ratings' })
  async getWeeklyPerformance(@Param('driverId') driverId: string) {
    return this.partnerService.getWeeklyPerformance(driverId);
  }

  @Get('incentives/:driverId')
  @ApiOperation({ summary: 'Get active milestone bonus incentives' })
  async getIncentives(@Param('driverId') driverId: string) {
    return this.partnerService.getIncentives(driverId);
  }

  @Post('leave-request')
  @ApiOperation({ summary: 'Submit leave request or log attendance' })
  async submitLeaveRequest(@Body() body: { driverId: string; startDate: string; endDate: string; reason: string }) {
    return this.partnerService.submitLeaveRequest(body.driverId, body.startDate, body.endDate, body.reason);
  }
}

