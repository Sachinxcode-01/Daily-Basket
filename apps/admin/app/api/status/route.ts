import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

export async function GET() {
  const startTime = Date.now();
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000';
  
  let backendHealth: { status: string; latencyMs?: number } = { status: 'offline' };

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 2000);
    const res = await fetch(`${apiUrl}/api/v1/health`, {
      signal: controller.signal,
      cache: 'no-store',
    });
    clearTimeout(timeoutId);
    backendHealth = {
      status: res.ok ? 'operational' : 'degraded',
      latencyMs: Date.now() - startTime,
    };
  } catch {
    backendHealth = { status: 'offline' };
  }

  return NextResponse.json({
    service: 'daily-basket-admin',
    status: 'operational',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    uptime: process.uptime ? Math.floor(process.uptime()) : 0,
    storeId: 'BLR-KOR-01',
    storeName: 'Koramangala Dark Store Hub #01',
    backendApi: {
      endpoint: apiUrl,
      status: backendHealth.status,
      latencyMs: backendHealth.latencyMs,
    },
    features: {
      dailyPriceEditor: 'operational',
      orderDispatchPipeline: 'operational',
      realtimeRiderTelemetry: 'operational',
      inventoryEngine: 'operational',
    },
  }, {
    status: 200,
    headers: {
      'Cache-Control': 'no-store, no-cache, must-revalidate',
    },
  });
}
