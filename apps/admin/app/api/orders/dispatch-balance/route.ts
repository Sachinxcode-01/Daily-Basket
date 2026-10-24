import { NextRequest, NextResponse } from 'next/server';
import { STORE_ORDERS, OrderItem } from '../store';

interface HubCapacity {
  code: string;
  name: string;
  maxActiveCapacity: number;
  currentActiveQueue: number;
  loadPercentage: number;
  availableEvRiders: number;
  status: 'OPTIMAL' | 'HIGH_DEMAND' | 'SURGE_CRITICAL';
}

const HUB_PROFILES: Record<string, { name: string; capacity: number; riders: number }> = {
  'BLR-KRM-01': { name: 'Koramangala Mega Dark Store #01', capacity: 50, riders: 14 },
  'BLR-IND-04': { name: 'Indiranagar Urban Hub #04', capacity: 40, riders: 10 },
  'BLR-HSR-02': { name: 'HSR Layout Sector 2 Hub', capacity: 35, riders: 8 },
  'BLR-WTF-08': { name: 'Whitefield Tech Hub #08', capacity: 45, riders: 12 },
};

export async function GET() {
  // Calculate real-time hub statistics
  const hubStats: Record<string, HubCapacity> = {};

  Object.entries(HUB_PROFILES).forEach(([code, profile]) => {
    const activeCount = STORE_ORDERS.filter(
      (o) => o.hubCode === code && o.statusStep < 4
    ).length;
    const loadPct = Math.round((activeCount / profile.capacity) * 100);

    let status: HubCapacity['status'] = 'OPTIMAL';
    if (loadPct > 80) status = 'SURGE_CRITICAL';
    else if (loadPct > 55) status = 'HIGH_DEMAND';

    hubStats[code] = {
      code,
      name: profile.name,
      maxActiveCapacity: profile.capacity,
      currentActiveQueue: activeCount,
      loadPercentage: loadPct,
      availableEvRiders: profile.riders,
      status,
    };
  });

  return NextResponse.json({
    success: true,
    timestamp: new Date().toISOString(),
    hubs: Object.values(hubStats),
  });
}

export async function POST(req: NextRequest) {
  try {
    const rebalancedOrders: {
      orderId: string;
      previousHub: string;
      newHub: string;
      reason: string;
      etaImprovementMinutes: number;
    }[] = [];

    // Find orders in NEW or CONFIRMED state in surge hubs
    const surgeOrders = STORE_ORDERS.filter(
      (o) => o.statusStep <= 1 && o.hubCode === 'BLR-KRM-01' && o.address.toLowerCase().includes('hsr')
    );

    // Rebalance HSR-bound orders from Koramangala Hub to HSR Hub to guarantee <10m SLA
    surgeOrders.forEach((ord) => {
      const prevHub = ord.hubName;
      ord.hubCode = 'BLR-HSR-02';
      ord.hubName = 'HSR Layout Sector 2 Hub';
      ord.slaMinutesRemaining = Math.min(10, ord.slaMinutesRemaining + 2);

      rebalancedOrders.push({
        orderId: ord.id,
        previousHub: prevHub,
        newHub: 'HSR Layout Sector 2 Hub',
        reason: 'Surge mitigation: Proximity optimization routed delivery directly from Sector 2 Hub.',
        etaImprovementMinutes: 3.5,
      });
    });

    return NextResponse.json({
      success: true,
      message: `Dispatched load balancing: ${rebalancedOrders.length} order(s) intelligently redistributed.`,
      rebalancedCount: rebalancedOrders.length,
      actions: rebalancedOrders,
      updatedOrders: STORE_ORDERS,
    });
  } catch (error: any) {
    return NextResponse.json({ success: false, message: error.message }, { status: 500 });
  }
}
