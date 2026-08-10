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

  async getFlashSales() {
    return {
      active: true,
      title: '⚡ Midnight Kirana Flash Sale',
      endsAt: new Date(Date.now() + 14400000).toISOString(), // 4 hours from now
      discountFlatPercent: 25,
      items: [
        { productId: 'prod_avocado', title: 'Organic Hass Avocado', flashPrice: 90, normalPrice: 120, stockRemaining: 14 },
        { productId: 'mlk1', title: 'Full Cream Milk 1L', flashPrice: 48, normalPrice: 64, stockRemaining: 8 },
      ],
    };
  }

  async calculateDeliveryFee(cartTotal: number) {
    const freeDeliveryThreshold = 199;
    const baseFee = 25;
    const isFree = cartTotal >= freeDeliveryThreshold;
    const fee = isFree ? 0 : baseFee;
    const remainingForFree = Math.max(0, freeDeliveryThreshold - cartTotal);

    return {
      cartTotal,
      freeDeliveryThreshold,
      isFree,
      deliveryFee: fee,
      remainingForFreeDelivery: remainingForFree,
    };
  }

  /**
   * Phase 4 — Daily Basket Plus Membership Suite
   */
  async getPlusMembershipPlans() {
    return {
      activeMember: true,
      memberTier: 'ANNUAL_VIP',
      expiresAt: '2027-08-10',
      totalSavingsToDate: 2480.0,
      plans: [
        { id: 'plan_monthly', name: 'Monthly Pass', price: 99, durationDays: 30, freeDeliveryMinOrder: 99, vipDiscountPercent: 5 },
        { id: 'plan_quarterly', name: 'Quarterly Savings', price: 249, durationDays: 90, freeDeliveryMinOrder: 99, vipDiscountPercent: 8, popular: true },
        { id: 'plan_annual', name: 'Annual VIP Choice', price: 799, durationDays: 365, freeDeliveryMinOrder: 49, vipDiscountPercent: 10, bestValue: true },
      ],
      benefits: [
        'Free Unlimited 10-Minute Delivery on orders above ₹99',
        'Extra 10% VIP Discount on all Organic Harvest items',
        'Priority Dark Store Packing & Rider Dispatch SLA',
        'Dedicated 24/7 AI VIP Support Concierge',
      ],
    };
  }

  /**
   * Phase 4 — Recurring Daily Subscriptions (Milk, Bread, Eggs, Curd)
   */
  async getSubscriptions(userId = 'usr_default') {
    return {
      userId,
      activeSubscriptions: [
        { id: 'sub_01', item: 'Amul Taaza T-Special Milk 1L', quantity: 2, frequency: 'DAILY', deliveryTime: '07:00 AM', status: 'ACTIVE', nextDelivery: '2026-08-11' },
        { id: 'sub_02', item: 'Modern Whole Wheat Bread 400g', quantity: 1, frequency: 'EVERY_3_DAYS', deliveryTime: '07:00 AM', status: 'ACTIVE', nextDelivery: '2026-08-12' },
        { id: 'sub_03', item: 'Farm Fresh Organic Eggs 12s', quantity: 1, frequency: 'WEEKLY', deliveryTime: '08:00 AM', status: 'PAUSED', nextDelivery: '2026-08-15' },
      ],
    };
  }

  async updateSubscription(subId: string, action: 'PAUSE' | 'RESUME' | 'SKIP_NEXT') {
    return {
      success: true,
      subscriptionId: subId,
      actionApplied: action,
      message: `Subscription ${subId} updated with status ${action}.`,
      updatedAt: new Date().toISOString(),
    };
  }

  /**
   * Phase 4 — Marketing Automation Triggers
   */
  async getAutomatedTriggers() {
    return {
      abandonedCartTrigger: { enabled: true, delayMinutes: 15, recoveryCoupon: 'CART10', estimatedRecoveryRate: '24.2%' },
      priceDropAlerts: { enabled: true, totalAlertsSentToday: 420, avgOpenRate: '38.5%' },
      backInStockNotifications: { enabled: true, pendingRequests: 18, autoRestockNotify: true },
      birthdayRewards: { enabled: true, rewardValue: 100, autoDispatchDaysBefore: 0 },
    };
  }

  /**
   * Phase 4 — A/B Testing Framework
   */
  async getAbTestExperiments() {
    return {
      activeExperiments: [
        { experimentId: 'exp_homepage_layout', variant: 'BENTO_GRID_V2', conversionUplift: '+12.4%' },
        { experimentId: 'exp_checkout_cta', variant: '1-TAP_UPI_BUY', conversionUplift: '+18.6%' },
        { experimentId: 'exp_recommendation_algorithm', variant: 'HYBRID_VECTOR_RECS', conversionUplift: '+21.0%' },
      ],
    };
  }

  /**
   * Phase 4 — Business Growth Analytics & CLV
   */
  async getGrowthAnalytics() {
    return {
      growthSummary: {
        customerLifetimeValueAvg: 4890.0,
        monthlyRetentionRate: '84.2%',
        repeatOrderRate: '78.5%',
        averageBasketValue: 389.5,
        customerAcquisitionCost: 112.0,
        netRevenueRetention: '124.8%',
      },
      topCategoriesByGrowth: [
        { category: 'Fresh Dairy & Milk', growthMoM: '+28.4%', revenueShare: '34.2%' },
        { category: 'Organic Vegetables', growthMoM: '+22.1%', revenueShare: '28.0%' },
        { category: 'Quick Snacks & Beverages', growthMoM: '+18.5%', revenueShare: '18.4%' },
      ],
    };
  }
}

