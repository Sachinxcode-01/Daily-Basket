import { Controller, Get, Post, Put, Patch, Delete, Body, Param } from '@nestjs/common';
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
    return this.marketingService.getBanners(false);
  }

  @Get('banners/admin')
  @ApiOperation({ summary: 'Admin get all banners including inactive' })
  async getAdminBanners() {
    return this.marketingService.getBanners(true);
  }

  @Post('banners')
  @ApiOperation({ summary: 'Admin create new promotional banner' })
  async createBanner(@Body() body: any) {
    return this.marketingService.createBanner(body);
  }

  @Put('banners/:id')
  @ApiOperation({ summary: 'Admin update existing banner' })
  async updateBanner(@Param('id') id: string, @Body() body: any) {
    return this.marketingService.updateBanner(id, body);
  }

  @Patch('banners/:id/toggle')
  @ApiOperation({ summary: 'Admin toggle banner active status' })
  async toggleBannerStatus(@Param('id') id: string, @Body() body: { isActive: boolean }) {
    return this.marketingService.toggleBannerStatus(id, body.isActive);
  }

  @Delete('banners/:id')
  @ApiOperation({ summary: 'Admin delete banner' })
  async deleteBanner(@Param('id') id: string) {
    return this.marketingService.deleteBanner(id);
  }

  @Post('banners/reorder')
  @ApiOperation({ summary: 'Admin reorder banner positions' })
  async reorderBanners(@Body() body: { orderedIds: string[] }) {
    return this.marketingService.reorderBanners(body.orderedIds);
  }

  @Post('push-broadcast')
  @ApiOperation({ summary: 'Trigger segmented FCM push notification broadcast' })
  async triggerPushBroadcast(@Body() body: { title: string; body: string; segment?: string }) {
    return this.marketingService.triggerPushBroadcast(body.title, body.body, body.segment);
  }

  @Get('flash-sales')
  @ApiOperation({ summary: 'Get active flash sale campaign & discounted inventory items' })
  async getFlashSales() {
    return this.marketingService.getFlashSales();
  }

  @Post('delivery-fee')
  @ApiOperation({ summary: 'Calculate dynamic delivery fee & free delivery threshold status' })
  async calculateDeliveryFee(@Body() body: { cartTotal: number }) {
    return this.marketingService.calculateDeliveryFee(body.cartTotal ?? 0);
  }

  @Get('plus-membership')
  @ApiOperation({ summary: 'Get Daily Basket Plus membership plans & VIP benefits' })
  async getPlusMembership() {
    return this.marketingService.getPlusMembershipPlans();
  }

  @Get('subscriptions')
  @ApiOperation({ summary: 'Get recurring order subscriptions (Milk, Bread, Eggs, Curd)' })
  async getSubscriptions() {
    return this.marketingService.getSubscriptions();
  }

  @Post('subscriptions/action')
  @ApiOperation({ summary: 'Pause, Resume, or Skip recurring order subscription' })
  async updateSubscription(@Body() body: { subscriptionId: string; action: 'PAUSE' | 'RESUME' | 'SKIP_NEXT' }) {
    return this.marketingService.updateSubscription(body.subscriptionId, body.action);
  }

  @Get('automated-triggers')
  @ApiOperation({ summary: 'Get marketing automation triggers (Abandoned cart, Price drops, Back in stock)' })
  async getAutomatedTriggers() {
    return this.marketingService.getAutomatedTriggers();
  }

  @Get('ab-testing')
  @ApiOperation({ summary: 'Get active A/B testing experiment variants and conversion uplifts' })
  async getAbTesting() {
    return this.marketingService.getAbTestExperiments();
  }

  @Get('growth-analytics')
  @ApiOperation({ summary: 'Get executive growth KPIs, CLV, Retention, and AOV metrics' })
  async getGrowthAnalytics() {
    return this.marketingService.getGrowthAnalytics();
  }
}

