import { NextRequest, NextResponse } from 'next/server';

export interface OrderItem {
  id: string;
  customer: string;
  address: string;
  phone: string;
  amount: string;
  isPriority: boolean;
  statusStep: number; // 0: New, 1: Accept, 2: Pack, 3: Assign, 4: Done
  statusLabel: string;
  time: string;
  paymentMethod: string;
  items: string[];
  hubCode: string;
  hubName: string;
  riderName?: string;
  slaMinutesRemaining: number;
}

export let STORE_ORDERS: OrderItem[] = [
  {
    id: '#DB-9842',
    customer: 'Rahul Sharma',
    address: '12, Green Park Avenue, Block C, HSR',
    phone: '+91 98765 43210',
    amount: '₹1,240',
    isPriority: true,
    statusStep: 1,
    statusLabel: 'CONFIRMED',
    time: '5m ago',
    paymentMethod: 'Paid via UPI',
    items: ['Organic Avocados x4', 'Aashirvaad Atta 5kg', 'Amul Butter 500g'],
    hubCode: 'BLR-KRM-01',
    hubName: 'Koramangala Mega Dark Store #01',
    slaMinutesRemaining: 7,
  },
  {
    id: '#DB-9840',
    customer: 'Priya Desai',
    address: 'Sector 4, HSR Layout, Bengaluru',
    phone: '+91 98765 12345',
    amount: '₹450',
    isPriority: false,
    statusStep: 2,
    statusLabel: 'PACKING',
    time: '12m ago',
    paymentMethod: 'Paid via Card',
    items: ['Fresh Paneer 200g', 'Free-range Eggs 6pk'],
    hubCode: 'BLR-HSR-02',
    hubName: 'HSR Layout Sector 2 Hub',
    slaMinutesRemaining: 5,
  },
  {
    id: '#DB-9838',
    customer: 'Ananya R.',
    address: '102, Sun City Apts, Sarjapur Road',
    phone: '+91 91234 56789',
    amount: '₹890',
    isPriority: true,
    statusStep: 0,
    statusLabel: 'NEW',
    time: '1m ago',
    paymentMethod: 'Paid via Wallet',
    items: ['Greek Yogurt 400g', 'Cold Pressed Juice 1L', 'Blueberries 125g'],
    hubCode: 'BLR-KRM-01',
    hubName: 'Koramangala Mega Dark Store #01',
    slaMinutesRemaining: 10,
  },
  {
    id: '#DB-9835',
    customer: 'Vikram Malhotra',
    address: '45, Koramangala 5th Block, Bengaluru',
    phone: '+91 99887 76655',
    amount: '₹1,560',
    isPriority: false,
    statusStep: 3,
    statusLabel: 'OUT_FOR_DELIVERY',
    time: '18m ago',
    paymentMethod: 'Paid via UPI',
    items: ['Basmati Rice 5kg', 'Sunflower Oil 2L', 'Toor Dal 1kg'],
    hubCode: 'BLR-KRM-01',
    hubName: 'Koramangala Mega Dark Store #01',
    riderName: 'Kiran Patel (EV #402)',
    slaMinutesRemaining: 3,
  },
  {
    id: '#DB-9831',
    customer: 'Divya Nair',
    address: '88, 100ft Road, Indiranagar',
    phone: '+91 97711 22334',
    amount: '₹620',
    isPriority: true,
    statusStep: 1,
    statusLabel: 'CONFIRMED',
    time: '4m ago',
    paymentMethod: 'Paid via UPI',
    items: ['Organic Spinach 250g', 'Fresh Coriander 100g', 'Country Tomatoes 1kg'],
    hubCode: 'BLR-IND-04',
    hubName: 'Indiranagar Urban Hub #04',
    slaMinutesRemaining: 8,
  },
];

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
