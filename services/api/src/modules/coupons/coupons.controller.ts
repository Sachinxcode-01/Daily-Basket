import { Controller, Get, Post, Put, Delete, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CouponsService, CouponDto } from './coupons.service';

@ApiTags('Coupons')
@Controller('coupons')
export class CouponsController {
  constructor(private readonly couponsService: CouponsService) {}

  @Get()
  @ApiOperation({ summary: 'Get list of active promotional coupons' })
  async getAvailableCoupons() {
    return this.couponsService.getAvailableCoupons();
  }

  @Get('history')
  @ApiOperation({ summary: 'Get user coupon redemption history' })
  async getHistory(@Query('userId') userId?: string) {
    return this.couponsService.getHistory(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get coupon details by ID or code' })
  async getCouponById(@Param('id') id: string) {
    return this.couponsService.getCouponById(id);
  }

  @Post('apply')
  @ApiOperation({ summary: 'Validate and calculate coupon discount for cart' })
  async applyCoupon(@Body() body: { code: string; cartSubtotal: number; userId?: string }) {
    return this.couponsService.validateCoupon(body.code, body.cartSubtotal, body.userId);
  }

  @Delete('remove')
  @ApiOperation({ summary: 'Remove applied coupon from cart session' })
  async removeCoupon(@Body() body: { code: string }) {
    return this.couponsService.removeCoupon(body.code);
  }

  // ─── ADMIN ENDPOINTS ────────────────────────────────────────────────────────
  @Post('admin')
  @ApiOperation({ summary: 'Create a new promotional coupon (Admin)' })
  async createCoupon(@Body() body: CouponDto) {
    return this.couponsService.createCoupon(body);
  }

  @Put('admin/:id')
  @ApiOperation({ summary: 'Update an existing coupon (Admin)' })
  async updateCoupon(@Param('id') id: string, @Body() body: Partial<CouponDto>) {
    return this.couponsService.updateCoupon(id, body);
  }

  @Delete('admin/:id')
  @ApiOperation({ summary: 'Delete a coupon by ID (Admin)' })
  async deleteCoupon(@Param('id') id: string) {
    return this.couponsService.deleteCoupon(id);
  }
}
