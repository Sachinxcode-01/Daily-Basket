import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class RetailOsService {
  constructor(private readonly prisma: PrismaService) {}

  async getExecutiveDashboardSummary() {
    return {
      period: 'TODAY',
      totalGrossRevenue: 104480.0,
      totalOrdersDelivered: 426,
      averageOrderValue: 245.25,
      activeStoresCount: 3,
      activeWarehousesCount: 2,
      netProfitMarginPercent: 6.8,
      systemStatus: 'ALL_MODULES_OPTIMAL',
    };
  }

  async getMasterDataConfigs() {
    const configs = await this.prisma.masterDataConfig.findMany();

    if (configs.length === 0) {
      return [
        { key: 'GST_SLABS_INDIA', category: 'TAX', value: { milk: 0, atta: 0, oil: 5, snacks: 12, cosmetics: 18 } },
        { key: 'GLOBAL_DELIVERY_SLA_MINS', category: 'SYSTEM', value: { targetMins: 10, maxMins: 20 } },
        { key: 'CURRENCY_FORMAT', category: 'SYSTEM', value: { code: 'INR', symbol: '₹' } },
      ];
    }
    return configs;
  }
}
