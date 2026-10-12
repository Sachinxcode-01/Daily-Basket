import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({
    success: true,
    data: {
      todayRevenue: 184920,
      revenueChangePercent: 14.2,
      activeOrders: 142,
      packingOrders: 38,
      outForDelivery: 104,
      avgDeliveryTimeMinutes: 9.4,
      slaTargetMinutes: 10.0,
      slaComplianceRate: 98.4,
      fleetActive: 48,
      fleetTotal: 52,
      fleetUtilizationPercent: 92.3,
      darkStoreStatus: 'ONLINE_OPTIMAL',
      activeAlertsCount: 2,
      lowStockSkus: 4,
      lastSyncTimestamp: new Date().toISOString(),
    },
  });
}
