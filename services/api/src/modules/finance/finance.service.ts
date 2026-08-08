import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class FinanceService {
  constructor(private prisma: PrismaService) {}

  async getRevenueOverview() {
    return {
      period: 'THIS_MONTH',
      grossRevenue: 482900,
      netProfit: 86900,
      taxCollectedGst: 43461,
      totalOrdersCount: 2410,
      averageOrderValue: 200.37,
      refundTotal: 4820,
      discountTotal: 24100,
    };
  }

  async getGstReport() {
    return {
      financialYear: '2026-2027',
      gstin: '29AABCD1234E1Z5',
      taxableAmount: 439439,
      cgstAmount: 21730.5,
      sgstAmount: 21730.5,
      igstAmount: 0.0,
      totalGstLiability: 43461,
    };
  }

  async getVendorPayouts() {
    return {
      pendingPayoutsCount: 3,
      totalPendingAmount: 124500,
      payouts: [
        { vendorId: 'v_01', vendorName: 'Fresh Farms Organics', amountDue: 45000, dueDate: '2026-08-10', status: 'PENDING' },
        { vendorId: 'v_02', vendorName: 'Amul Dairy Co-op', amountDue: 62000, dueDate: '2026-08-08', status: 'PROCESSING' },
      ],
    };
  }

  async getRiderPayouts() {
    return {
      period: 'WEEKLY_SETTLEMENT',
      totalRiderPayouts: 38400,
      activeRidersCount: 42,
      averagePayoutPerRider: 914.28,
    };
  }

  async processDailyClosing() {
    return {
      success: true,
      closingDate: new Date().toISOString().split('T')[0],
      totalTransactions: 142,
      grossSales: 28480,
      cashOnDeliveryCollected: 4200,
      digitalPaymentsSettled: 24280,
      closingStatus: 'BALANCED_AND_LOCKED',
    };
  }

  async getProfitAndLossStatement() {
    return {
      period: 'JULY_2026',
      totalRevenue: 482900.0,
      costOfGoodsSold: 312000.0,
      grossProfit: 170900.0,
      operatingExpenses: {
        rentAndUtilities: 35000.0,
        staffSalaries: 42000.0,
        deliveryPartnerPayouts: 38400.0,
        marketingAndDiscounts: 24100.0,
      },
      totalExpenses: 139500.0,
      netOperatingProfit: 31400.0,
      profitMarginPercent: 6.5,
    };
  }
}
