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
}
