import { Controller, Get, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CouponsService } from './coupons.service';

@ApiTags('Coupons')
@Controller('coupons')
export class CouponsController {
  constructor(private readonly couponsService: CouponsService) {}

  @Get()
  @ApiOperation({ summary: 'Get list of active promotional coupons' })
  async getAvailableCoupons() {
    return this.couponsService.getAvailableCoupons();
  }

  @Post('apply')
  @ApiOperation({ summary: 'Validate and calculate coupon discount for cart' })
  async applyCoupon(@Body() body: { code: string; cartSubtotal: number }) {
    return this.couponsService.validateCoupon(body.code, body.cartSubtotal);
  }
}
