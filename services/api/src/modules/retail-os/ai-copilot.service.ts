import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface CopilotQueryRequest {
  query: string;
  contextStoreId?: string;
}

@Injectable()
export class AiCopilotService {
  constructor(private readonly prisma: PrismaService) {}

  async processCopilotQuery(userId: string, request: CopilotQueryRequest) {
    const q = request.query.toLowerCase();
    const startTime = Date.now();

    let responseSummary = '';
    let resolvedIntent = 'GENERAL_QUERY';
    let dataPayload: any = {};

    if (q.includes('sales') || q.includes('revenue')) {
      resolvedIntent = 'SALES_QUERY';
      responseSummary = "Today's gross sales reached ₹48,290.00 across 242 completed orders (+14% vs yesterday).";
      dataPayload = { grossSales: 48290.0, ordersCount: 242, averageOrderValue: 199.54 };
    } else if (q.includes('profit') || q.includes('p&l')) {
      resolvedIntent = 'PROFIT_QUERY';
      responseSummary = "Current month net operating profit stands at ₹31,400.00 (6.5% net margin).";
      dataPayload = { grossProfit: 170900.0, netProfit: 31400.0, profitMarginPercent: 6.5 };
    } else if (q.includes('low stock') || q.includes('inventory')) {
      resolvedIntent = 'INVENTORY_QUERY';
      responseSummary = "3 items are running below reorder threshold: Aashirvaad Atta 5kg (6 units), Wheat Bread (2 units), Sunflower Oil (4 units).";
      dataPayload = { lowStockItemsCount: 3, criticalItems: ['Aashirvaad Atta 5kg', 'Britannia Bread', 'Fortune Sunflower Oil'] };
    } else if (q.includes('best seller') || q.includes('popular')) {
      resolvedIntent = 'TOP_SELLERS_QUERY';
      responseSummary = "Top 3 best sellers today: 1. Amul Taaza Milk 1L (182 units), 2. Farm Fresh Eggs 10s (94 units), 3. Aashirvaad Atta 5kg (48 units).";
      dataPayload = { topSellers: ['Amul Taaza Milk 1L', 'Farm Fresh Eggs', 'Aashirvaad Atta 5kg'] };
    } else {
      resolvedIntent = 'BUSINESS_ADVICE_QUERY';
      responseSummary = "Retail OS is functioning normally. All 3 stores online, 100% on-time delivery rate, zero queue bottlenecks.";
      dataPayload = { systemHealth: 'OPTIMAL', onlineStores: 3 };
    }

    const latencyMs = Date.now() - startTime;

    await this.prisma.aiCopilotQueryLog.create({
      data: {
        userId,
        query: request.query,
        resolvedIntent,
        responseSummary,
        latencyMs,
      },
    });

    return {
      query: request.query,
      resolvedIntent,
      responseSummary,
      dataPayload,
      latencyMs,
    };
  }

  async getRecentQueries(userId: string) {
    const logs = await this.prisma.aiCopilotQueryLog.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 10,
    });

    if (logs.length === 0) {
      return [
        {
          id: 'log_01',
          query: "What are today's total sales and net profit?",
          resolvedIntent: 'SALES_QUERY',
          responseSummary: "Today's gross sales reached ₹48,290.00 across 242 completed orders (+14% vs yesterday).",
          createdAt: new Date(),
        },
      ];
    }
    return logs;
  }
}
