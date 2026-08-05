import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class MarketingService {
  constructor(private prisma: PrismaService) {}

  async getCampaigns() {
    return [
      { id: 'cmp_01', title: 'Weekend Organic Harvest Sale', channel: 'PUSH_AND_SMS', status: 'ACTIVE', sentCount: 14200, openRate: 0.28, conversionRate: 0.12 },
      { id: 'cmp_02', title: 'Monsoon Dairy Festival', channel: 'IN_APP_BANNER', status: 'SCHEDULED', startDate: '2026-08-08', targetSegment: 'VIP_CUSTOMERS' },
    ];
  }

  async createCampaign(campaignData: any) {
    return {
      success: true,
      campaignId: `cmp_${Date.now()}`,
      title: campaignData.title,
      channel: campaignData.channel,
      status: 'SCHEDULED',
      createdAt: new Date().toISOString(),
    };
  }

  async getBanners() {
    return [
      { id: 'b_01', imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80', title: 'Fresh Vegetables 20% Off', targetRoute: '/categories/vegetables' },
      { id: 'b_02', imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800&q=80', title: 'Daily Milk Delivery Special', targetRoute: '/categories/dairy' },
    ];
  }

  async triggerPushBroadcast(title: string, body: string, segment?: string) {
    return {
      success: true,
      jobId: `fcm_job_${Date.now()}`,
      recipientsEstimated: segment === 'VIP' ? 1200 : 18500,
      title,
      body,
      dispatchedAt: new Date().toISOString(),
    };
  }
}
