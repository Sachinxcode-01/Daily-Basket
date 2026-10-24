import { NextRequest, NextResponse } from 'next/server';
import { STORE_ORDERS, OrderItem } from './store';

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const hubFilter = searchParams.get('hub');
  const statusFilter = searchParams.get('status');

  let filtered = [...STORE_ORDERS];
  if (hubFilter && hubFilter !== 'ALL') {
    filtered = filtered.filter((o) => o.hubCode === hubFilter);
  }
  if (statusFilter && statusFilter !== 'ALL') {
    filtered = filtered.filter((o) => o.statusLabel === statusFilter);
  }

  return NextResponse.json({
    success: true,
    count: filtered.length,
    orders: filtered,
  });
}

export async function PATCH(req: NextRequest) {
  try {
    const body = await req.json();
    const { orderId, statusStep, hubCode, hubName, riderName } = body;

    const idx = STORE_ORDERS.findIndex((o) => o.id === orderId);
    if (idx === -1) {
      return NextResponse.json({ success: false, message: 'Order not found' }, { status: 404 });
    }

    const stepLabels = ['NEW', 'CONFIRMED', 'PACKING', 'OUT_FOR_DELIVERY', 'DELIVERED'];
    if (typeof statusStep === 'number') {
      STORE_ORDERS[idx].statusStep = statusStep;
      STORE_ORDERS[idx].statusLabel = stepLabels[statusStep] || 'PROCESSING';
    }
    if (hubCode && hubName) {
      STORE_ORDERS[idx].hubCode = hubCode;
      STORE_ORDERS[idx].hubName = hubName;
    }
    if (riderName) {
      STORE_ORDERS[idx].riderName = riderName;
    }

    return NextResponse.json({
      success: true,
      message: `Order ${orderId} updated successfully`,
      order: STORE_ORDERS[idx],
    });
  } catch (error: any) {
    return NextResponse.json({ success: false, message: error.message }, { status: 500 });
  }
}
