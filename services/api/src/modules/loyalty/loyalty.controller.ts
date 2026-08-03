import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { LoyaltyService } from './loyalty.service';

@ApiTags('Loyalty & Referrals')
@Controller('loyalty')
export class LoyaltyController {
  constructor(private readonly loyaltyService: LoyaltyService) {}

  @Get(':userId')
  @ApiOperation({ summary: 'Get user loyalty points, tier status, and referral rewards' })
  async getLoyalty(@Param('userId') userId: string) {
    return this.loyaltyService.getUserLoyalty(userId);
  }

  @Post('redeem')
  @ApiOperation({ summary: 'Redeem loyalty points for checkout discount' })
  async redeemPoints(@Body() body: { userId: string; points: number }) {
    return this.loyaltyService.redeemPoints(body.userId, body.points);
  }
}
