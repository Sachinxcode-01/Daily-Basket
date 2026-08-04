import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ReferralsService } from './referrals.service';

@ApiTags('Referrals')
@Controller('referrals')
export class ReferralsController {
  constructor(private readonly referralsService: ReferralsService) {}

  @Get()
  @ApiOperation({ summary: 'Get referral system overview' })
  async getOverview(@Query('userId') userId?: string) {
    return this.referralsService.getDashboard(userId);
  }

  @Get('dashboard')
  @ApiOperation({ summary: 'Get detailed referral dashboard metrics' })
  async getDashboard(@Query('userId') userId?: string) {
    return this.referralsService.getDashboard(userId);
  }

  @Get('history')
  @ApiOperation({ summary: 'Get user referral invite history' })
  async getHistory(@Query('userId') userId?: string) {
    return this.referralsService.getHistory(userId);
  }

  @Post('share')
  @ApiOperation({ summary: 'Generate social media referral share link' })
  async shareReferral(
    @Query('userId') userId: string,
    @Body() body: { platform: string },
  ) {
    return this.referralsService.shareReferral(userId, body);
  }

  @Post('redeem')
  @ApiOperation({ summary: 'Redeem friend referral invite code' })
  async redeemReferralCode(
    @Query('userId') userId: string,
    @Body() body: { code: string },
  ) {
    return this.referralsService.redeemReferralCode(userId, body);
  }
}
