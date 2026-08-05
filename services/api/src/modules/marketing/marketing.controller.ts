import { Controller, Get, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { MarketingService } from './marketing.service';

@ApiTags('Marketing & Campaigns')
@Controller('marketing')
export class MarketingController {
  constructor(private readonly marketingService: MarketingService) {}

  @Get('campaigns')
  @ApiOperation({ summary: 'Get active and scheduled promotional campaigns' })
  async getCampaigns() {
    return this.marketingService.getCampaigns();
  }

  @Post('campaigns/create')
  @ApiOperation({ summary: 'Create new marketing campaign' })
  async createCampaign(@Body() body: { title: string; channel: string; targetSegment?: string }) {
    return this.marketingService.createCampaign(body);
  }

  @Get('banners')
  @ApiOperation({ summary: 'Get homepage marketing promotional banners' })
  async getBanners() {
    return this.marketingService.getBanners();
  }

  @Post('push-broadcast')
  @ApiOperation({ summary: 'Trigger segmented FCM push notification broadcast' })
  async triggerPushBroadcast(@Body() body: { title: string; body: string; segment?: string }) {
    return this.marketingService.triggerPushBroadcast(body.title, body.body, body.segment);
  }
}
