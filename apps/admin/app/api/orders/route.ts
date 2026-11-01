import { NextRequest, NextResponse } from 'next/server';
import { STORE_ORDERS, OrderItem } from './store';

const BACKEND_URL = (process.env.API_BASE_URL || process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000').replace(/\/$/, '');

const STATUS_STEP_MAP: Record<string, number> = {
  CREATED: 0,
  PENDING: 0,
  CONFIRMED: 1,
  PACKING: 2,
  READY_FOR_PICKUP: 2,
  OUT_FOR_DELIVERY: 3,
  DELIVERED: 4,
  COMPLETED: 4,
  CANCELLED: -1,
};

const STEP_TO_STATUS = ['NEW', 'CONFIRMED', 'PACKING', 'OUT_FOR_DELIVERY', 'DELIVERED'];

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const hubFilter = searchParams.get('hub');
  const statusFilter = searchParams.get('status');

  // Try backend first
  try {
    const res = await fetch(`${BACKEND_URL}/api/v1/orders/admin/all`, {
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store',
    });

    if (res.ok) {
      const data = await res.json();
      const rawList = Array.isArray(data) ? data : data.data || [];
      if (Array.isArray(rawList) && rawList.length > 0) {
        const mappedOrders: OrderItem[] = rawList.map((ord: any) => {
          const rawAddress = ord.address;
          const streetAddress = rawAddress?.street
            ? `${rawAddress.houseNo || ''} ${rawAddress.street}, ${rawAddress.city || ''}`.trim()
            : typeof rawAddress?.streetAddress === 'string'
            ? rawAddress.streetAddress
            : 'Indiranagar, Bengaluru';
          const phone = rawAddress?.phoneNumber || ord.customer?.phoneNumber || ord.user?.phoneNumber || '+91 98765 43210';
          const orderNum = ord.orderNumber || ord.id || `DB-${Date.now().toString().slice(-4)}`;
          const id = orderNum.startsWith('#') ? orderNum : `#${orderNum}`;
          const step = STATUS_STEP_MAP[ord.status] ?? 0;
          const statusLabel = ord.status || STEP_TO_STATUS[Math.max(0, step)];

          return {
            id,
            customer: ord.customer?.fullName || ord.user?.fullName || rawAddress?.name || 'Customer App User',
            address: streetAddress,
            phone,
            amount: `₹${ord.totalAmount || 0}`,
            isPriority: true,
            statusStep: step,
            statusLabel,
            time: ord.createdAt
              ? new Date(ord.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
              : 'Just now',
            paymentMethod: `Paid via ${ord.paymentMethod || 'UPI'}`,
            items: Array.isArray(ord.items) && ord.items.length > 0
              ? ord.items.map((i: any) => `${i.productName || i.name || 'Item'} x${i.quantity || 1}`)
              : ['Farm Fresh Produce x1'],
            hubCode: ord.store?.code || 'BLR-KRM-01',
            hubName: ord.store?.name || 'Koramangala Mega Dark Store #01',
            riderName: ord.deliveryPartner?.fullName,
            slaMinutesRemaining: ord.estimatedArrivalMins || 8,
          };
        });

        let filtered = mappedOrders;
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
    }
  } catch {
    // Backend offline / starting up, fallback to in-memory store below
  }

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
    const { orderId, statusStep, hubCode, hubName, riderName, status } = body;
    const cleanId = orderId ? String(orderId).replace(/^#/, '') : '';

    // Forward status step advance to backend
    if (typeof statusStep === 'number' || status) {
      const targetStatus = status || STEP_TO_STATUS[statusStep];
      try {
        await fetch(`${BACKEND_URL}/api/v1/orders/${cleanId}/advance-step`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ status: targetStatus }),
        });
      } catch {}
    }

    // Also update in-memory STORE_ORDERS
    const idx = STORE_ORDERS.findIndex((o) => o.id === orderId || o.id === `#${cleanId}` || o.id === cleanId);
    if (idx !== -1) {
      if (typeof statusStep === 'number') {
        STORE_ORDERS[idx].statusStep = statusStep;
        STORE_ORDERS[idx].statusLabel = STEP_TO_STATUS[statusStep] || 'PROCESSING';
      }
      if (hubCode && hubName) {
        STORE_ORDERS[idx].hubCode = hubCode;
        STORE_ORDERS[idx].hubName = hubName;
      }
      if (riderName) {
        STORE_ORDERS[idx].riderName = riderName;
      }
    }

    return NextResponse.json({
      success: true,
      message: `Order ${orderId} updated successfully`,
      order: idx !== -1 ? STORE_ORDERS[idx] : { id: orderId, statusStep },
    });
  } catch (error: any) {
    return NextResponse.json({ success: false, message: error.message }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const orderId = searchParams.get('id');
    if (!orderId) {
      return NextResponse.json({ success: false, message: 'Missing order id' }, { status: 400 });
    }
    const cleanId = orderId.replace(/^#/, '');

    // Forward cancellation to backend
    try {
      await fetch(`${BACKEND_URL}/api/v1/orders/${cleanId}/cancel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reason: 'Admin cancelled order' }),
      });
    } catch {}

    const idx = STORE_ORDERS.findIndex((o) => o.id === orderId || o.id === `#${cleanId}` || o.id === cleanId);
    if (idx !== -1) {
      STORE_ORDERS.splice(idx, 1);
    }

    return NextResponse.json({
      success: true,
      message: `Order ${orderId} cancelled/removed successfully`,
    });
  } catch (err: any) {
    return NextResponse.json({ success: false, message: err.message }, { status: 500 });
  }
}
