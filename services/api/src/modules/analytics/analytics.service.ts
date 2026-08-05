import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class AnalyticsService {
  constructor(private prisma: PrismaService) {}

  async getStoreAnalytics(storeId: string = 'store_main_01') {
    const totalOrders = await this.prisma.order.count();
    const completedOrders = await this.prisma.order.count({ where: { status: 'DELIVERED' } });
    const pendingOrders = await this.prisma.order.count({ where: { status: { in: ['CREATED', 'CONFIRMED', 'PACKING'] } } });

    const topSellingProducts = [
      { id: 'p1', name: 'Fresh Organic Farm Tomatoes', category: 'Vegetables', unitsSold: 420, revenue: 10080 },
      { id: 'p2', name: 'Amul Taaza Toned Milk', category: 'Dairy', unitsSold: 350, revenue: 18900 },
      { id: 'p3', name: 'Brown Sandwich Bread', category: 'Bakery', unitsSold: 210, revenue: 9450 },
    ];

    const hourlyOrderDistribution = [
      { hour: '08:00 AM', orders: 12 },
      { hour: '10:00 AM', orders: 45 },
      { hour: '12:00 PM', orders: 38 },
      { hour: '04:00 PM', orders: 52 },
      { hour: '08:00 PM', orders: 64 },
    ];

    return {
      todayRevenue: 38450,
      todayOrdersCount: totalOrders > 0 ? totalOrders : 142,
      completedOrders,
      pendingOrders: pendingOrders > 0 ? pendingOrders : 12,
      lowStockAlertCount: 8,
      avgDispatchTimeMins: 2.4,
      topSellingProducts,
      hourlyOrderDistribution,
    };
  }

  async getFraudDashboard() {
    return {
      riskScore: 'LOW',
      flaggedAccountsCount: 2,
      suspiciousTransactions: [
        { id: 'tx_091', userId: 'usr_882', reason: 'High velocity repeated OTP requests', riskLevel: 'MEDIUM', createdAt: new Date().toISOString() },
      ],
      botAttacksPrevented: 14,
      rateLimitTriggers24h: 38,
    };
  }

  async getDeliveryHeatMaps() {
    return {
      zones: [
        { pincode: '560034', sector: 'Koramangala 4th Block', orderDensity: 94, averageDeliveryMins: 8.2 },
        { pincode: '560095', sector: 'HSR Layout Sector 1', orderDensity: 88, averageDeliveryMins: 9.1 },
        { pincode: '560037', sector: 'Indiranagar 100 Feet Rd', orderDensity: 76, averageDeliveryMins: 8.5 },
      ],
    };
  }

  async getCouponAnalytics() {
    return {
      totalRedemptions: 1420,
      totalDiscountGranted: 142000,
      topPerformingCode: 'DAILYFRESH100',
      conversionRateMultiplier: 1.34,
    };
  }

  async exportReport() {
    return {
      downloadUrl: 'https://dailybasket.local/exports/daily-analytics-2026.csv',
      format: 'CSV',
      generatedAt: new Date().toISOString(),
    };
  }
}

