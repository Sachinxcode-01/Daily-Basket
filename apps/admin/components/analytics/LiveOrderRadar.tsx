'use client';

import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Bike,
  Package,
  Clock,
  CheckCircle2,
  AlertTriangle,
  Play,
  Pause,
  ExternalLink,
  ShoppingBag,
  Zap,
  MapPin,
  Flame,
} from 'lucide-react';
import Button from '../ui/Button';
import Badge from '../ui/Badge';

export interface LiveOrder {
  id: string;
  orderNumber: string;
  customerName: string;
  itemsCount: number;
  itemsPreview: string;
  totalAmount: number;
  stage: 'PLACED' | 'PICKING' | 'PACKED' | 'DISPATCHED' | 'DELIVERED';
  elapsedSeconds: number; // SLA timer out of 600s (10 mins)
  riderName?: string;
  hub: string;
}

const initialOrders: LiveOrder[] = [
  {
    id: 'ord-101',
    orderNumber: '#DB-8921',
    customerName: 'Aarav Mehta',
    itemsCount: 5,
    itemsPreview: 'Alphonso Mangoes 1kg, Nandini Milk 1L, Fresh Mint',
    totalAmount: 480,
    stage: 'DISPATCHED',
    elapsedSeconds: 430, // 7m 10s
    riderName: 'Ravi Kumar (EV-04)',
    hub: 'Koramangala Hub #01',
  },
  {
    id: 'ord-102',
    orderNumber: '#DB-8922',
    customerName: 'Pooja Sharma',
    itemsCount: 3,
    itemsPreview: 'Organic Spinach 250g, Country Eggs (6pk), Butter',
    totalAmount: 265,
    stage: 'PACKED',
    elapsedSeconds: 270, // 4m 30s
    riderName: 'Assigned (Suresh K.)',
    hub: 'Indiranagar Hub #04',
  },
  {
    id: 'ord-103',
    orderNumber: '#DB-8923',
    customerName: 'Vikram Joshi',
    itemsCount: 8,
    itemsPreview: 'Aashirvaad Atta 5kg, Fortune Oil 1L, Tomatoes 1kg',
    totalAmount: 890,
    stage: 'PICKING',
    elapsedSeconds: 150, // 2m 30s
    hub: 'Koramangala Hub #01',
  },
  {
    id: 'ord-104',
    orderNumber: '#DB-8924',
    customerName: 'Ananya Reddy',
    itemsCount: 2,
    itemsPreview: 'Sourdough Bread, Fresh Strawberry 200g',
    totalAmount: 320,
    stage: 'PLACED',
    elapsedSeconds: 45, // 45s
    hub: 'HSR Sector 2 Hub',
  },
  {
    id: 'ord-105',
    orderNumber: '#DB-8920',
    customerName: 'Karan Verma',
    itemsCount: 4,
    itemsPreview: 'Cold Brew 250ml, Greek Yogurt, Bananas 500g',
    totalAmount: 340,
    stage: 'DELIVERED',
    elapsedSeconds: 560, // 9m 20s
    riderName: 'Mahesh B. (Delivered in 9m 20s)',
    hub: 'Koramangala Hub #01',
  },
];

export default function LiveOrderRadar({
  onSelectOrder,
}: {
  onSelectOrder?: (order: LiveOrder) => void;
}) {
  const [orders, setOrders] = useState<LiveOrder[]>(initialOrders);
  const [isLiveStreaming, setIsLiveStreaming] = useState(true);
  const [activeFilter, setActiveFilter] = useState<'ALL' | 'ACTIVE' | 'DISPATCHED'>('ALL');

  // Live timer tick for SLA countup
  useEffect(() => {
    if (!isLiveStreaming) return;
    const interval = setInterval(() => {
      setOrders((prev) =>
        prev.map((ord) => {
          if (ord.stage === 'DELIVERED') return ord;
          const nextSeconds = ord.elapsedSeconds + 1;
          // Progress stages based on SLA
          let nextStage: LiveOrder['stage'] = ord.stage;
          if (nextSeconds > 480 && ord.stage === 'DISPATCHED') {
            nextStage = 'DELIVERED';
          } else if (nextSeconds > 300 && ord.stage === 'PACKED') {
            nextStage = 'DISPATCHED';
          } else if (nextSeconds > 120 && ord.stage === 'PLACED') {
            nextStage = 'PICKING';
          } else if (nextSeconds > 220 && ord.stage === 'PICKING') {
            nextStage = 'PACKED';
          }
          return { ...ord, elapsedSeconds: nextSeconds, stage: nextStage };
        })
      );
    }, 1000);

    return () => clearInterval(interval);
  }, [isLiveStreaming]);

  // Simulate injecting a new order
  const handleSimulateNewOrder = () => {
    const randomNames = ['Deepak Nair', 'Sneha Patel', 'Rahul Roy', 'Divya Menon'];
    const randomItems = [
      'Fresh Tender Coconut (2x), Alphonso Mangoes',
      'Brown Eggs (12pk), Whole Wheat Bread, Butter',
      'Shimla Apples 1kg, Pure Honey 250g, Green Tea',
      'Organic Potatoes 2kg, Onions 1kg, Ginger 100g',
    ];
    const newId = `#DB-${Math.floor(8925 + Math.random() * 900)}`;
    const newOrder: LiveOrder = {
      id: `ord-${Date.now()}`,
      orderNumber: newId,
      customerName: randomNames[Math.floor(Math.random() * randomNames.length)],
      itemsCount: Math.floor(Math.random() * 6) + 2,
      itemsPreview: randomItems[Math.floor(Math.random() * randomItems.length)],
      totalAmount: Math.floor(Math.random() * 500) + 180,
      stage: 'PLACED',
      elapsedSeconds: 0,
      hub: 'Koramangala Hub #01',
    };

    setOrders((prev) => [newOrder, ...prev.slice(0, 7)]);
  };

  const filteredOrders = orders.filter((o) => {
    if (activeFilter === 'ACTIVE') return o.stage !== 'DELIVERED';
    if (activeFilter === 'DISPATCHED') return o.stage === 'DISPATCHED';
    return true;
  });

  const getStageBadge = (stage: LiveOrder['stage']) => {
    switch (stage) {
      case 'PLACED':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-50 text-amber-800 border border-amber-200">
            <span className="w-1.5 h-1.5 rounded-full bg-amber-500 animate-ping" />
            Placed
          </span>
        );
      case 'PICKING':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-blue-50 text-blue-800 border border-blue-200">
            <Package className="w-3 h-3 text-blue-600 animate-pulse" />
            Picking
          </span>
        );
      case 'PACKED':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-purple-50 text-purple-800 border border-purple-200">
            <CheckCircle2 className="w-3 h-3 text-purple-600" />
            Packed
          </span>
        );
      case 'DISPATCHED':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-[#2d9d43]/15 text-[#078730] border border-[#2d9d43]/30">
            <Bike className="w-3 h-3 text-[#2d9d43] animate-bounce" />
            In Transit
          </span>
        );
      case 'DELIVERED':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-zinc-100 text-zinc-700 border border-zinc-200">
            <CheckCircle2 className="w-3 h-3 text-emerald-600" />
            Delivered
          </span>
        );
    }
  };

  return (
    <div className="glass-card rounded-2xl p-6 shadow-sm border border-zinc-200/80 flex flex-col">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-5">
        <div>
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-emerald-50 text-[#078730] flex items-center justify-center font-bold">
              <Flame className="w-4 h-4 text-[#2d9d43]" />
            </div>
            <h3 className="text-lg font-bold text-zinc-950 font-headline tracking-tight">
              10-Minute Dispatch Pipeline
            </h3>
            <span className="text-[10px] font-bold bg-emerald-500/10 text-emerald-800 border border-emerald-500/20 px-2.5 py-0.5 rounded-full font-mono flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              SLA: &lt;600s
            </span>
          </div>
          <p className="text-xs text-zinc-500 font-body mt-0.5">
            Real-time fulfillment stages from dark store shelf to customer doorstep.
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          {/* Filter Pills */}
          <div className="flex items-center bg-zinc-100 p-1 rounded-xl text-xs font-semibold text-zinc-600">
            {(['ALL', 'ACTIVE', 'DISPATCHED'] as const).map((filter) => (
              <button
                key={filter}
                onClick={() => setActiveFilter(filter)}
                className={`px-3 py-1 rounded-lg transition-all ${
                  activeFilter === filter
                    ? 'bg-white text-zinc-950 shadow-sm font-bold'
                    : 'hover:text-zinc-900'
                }`}
              >
                {filter}
              </button>
            ))}
          </div>

          {/* Trigger Simulated Order */}
          <Button
            variant="brand"
            size="sm"
            onClick={handleSimulateNewOrder}
            leftIcon={<Zap className="w-3.5 h-3.5" />}
          >
            Simulate Order
          </Button>

          {/* Live Pause/Play toggle */}
          <button
            onClick={() => setIsLiveStreaming(!isLiveStreaming)}
            className="p-2 rounded-xl bg-zinc-100 text-zinc-600 hover:text-zinc-950 hover:bg-zinc-200/80 transition"
            title={isLiveStreaming ? 'Pause Realtime Stream' : 'Resume Realtime Stream'}
          >
            {isLiveStreaming ? <Pause className="w-4 h-4" /> : <Play className="w-4 h-4" />}
          </button>
        </div>
      </div>

      {/* SLA Pipeline Flow Indicator Strip */}
      <div className="bg-zinc-50/80 rounded-xl p-3 mb-5 border border-zinc-200/60 grid grid-cols-2 sm:grid-cols-4 gap-2 text-center text-xs">
        <div className="p-2 bg-white rounded-lg border border-zinc-200/50 shadow-2xs">
          <span className="text-[10px] text-zinc-400 uppercase font-mono block">Stage 1</span>
          <span className="font-bold text-zinc-800">🛒 Order Sync (0-2m)</span>
        </div>
        <div className="p-2 bg-white rounded-lg border border-zinc-200/50 shadow-2xs">
          <span className="text-[10px] text-zinc-400 uppercase font-mono block">Stage 2</span>
          <span className="font-bold text-zinc-800">📦 Picker Batch (2-4m)</span>
        </div>
        <div className="p-2 bg-white rounded-lg border border-zinc-200/50 shadow-2xs">
          <span className="text-[10px] text-zinc-400 uppercase font-mono block">Stage 3</span>
          <span className="font-bold text-zinc-800">🏷️ QA & Pack (4-6m)</span>
        </div>
        <div className="p-2 bg-white rounded-lg border border-zinc-200/50 shadow-2xs">
          <span className="text-[10px] text-zinc-400 uppercase font-mono block">Stage 4</span>
          <span className="font-bold text-[#078730]">🛵 EV Dispatch (6-10m)</span>
        </div>
      </div>

      {/* Orders Stream List with AnimatePresence */}
      <div className="space-y-3 flex-1 overflow-hidden">
        <AnimatePresence initial={false}>
          {filteredOrders.map((order) => {
            const minutes = Math.floor(order.elapsedSeconds / 60);
            const seconds = order.elapsedSeconds % 60;
            const progressPercent = Math.min(100, Math.round((order.elapsedSeconds / 600) * 100));
            const isNearSlaLimit = order.elapsedSeconds > 540 && order.stage !== 'DELIVERED';

            return (
              <motion.div
                key={order.id}
                layout
                initial={{ opacity: 0, y: -20, scale: 0.98 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, scale: 0.95, transition: { duration: 0.2 } }}
                transition={{ duration: 0.35, ease: [0.16, 1, 0.3, 1] }}
                onClick={() => onSelectOrder?.(order)}
                className="p-4 rounded-xl bg-white border border-zinc-200/80 hover:border-[#2d9d43]/50 hover:shadow-md transition-all cursor-pointer group flex flex-col md:flex-row md:items-center justify-between gap-4"
              >
                {/* Left Block: ID & Details */}
                <div className="flex items-start gap-3 flex-1 min-w-0">
                  <div className="w-10 h-10 rounded-xl bg-zinc-100 group-hover:bg-[#2d9d43]/10 text-zinc-700 group-hover:text-[#2d9d43] flex items-center justify-center shrink-0 transition-colors">
                    <ShoppingBag className="w-5 h-5" />
                  </div>
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2 mb-0.5">
                      <span className="font-bold text-sm text-zinc-950 font-headline group-hover:text-[#2d9d43] transition-colors">
                        {order.orderNumber}
                      </span>
                      <span className="text-xs text-zinc-500 font-medium truncate">
                        • {order.customerName}
                      </span>
                      {getStageBadge(order.stage)}
                    </div>
                    <p className="text-xs text-zinc-500 truncate font-body">
                      {order.itemsPreview}
                    </p>
                    <div className="flex items-center gap-3 mt-1.5 text-[11px] text-zinc-400">
                      <span className="flex items-center gap-1">
                        <MapPin className="w-3 h-3 text-zinc-400" />
                        {order.hub}
                      </span>
                      {order.riderName && (
                        <span className="flex items-center gap-1 text-zinc-600 font-medium">
                          <Bike className="w-3 h-3 text-[#2d9d43]" />
                          {order.riderName}
                        </span>
                      )}
                    </div>
                  </div>
                </div>

                {/* Right Block: Amount & SLA Progress */}
                <div className="flex items-center justify-between md:justify-end gap-6 shrink-0 pt-2 md:pt-0 border-t md:border-t-0 border-zinc-100">
                  <div className="text-right">
                    <span className="text-xs text-zinc-400 block font-body">Total</span>
                    <span className="font-bold text-sm text-zinc-950 font-headline">
                      ₹{order.totalAmount}
                    </span>
                  </div>

                  {/* SLA Elapsed Counter & Progress Bar */}
                  <div className="w-32 text-right">
                    <div className="flex items-center justify-between text-[11px] font-mono font-bold mb-1">
                      <span className="text-zinc-400">SLA:</span>
                      <span
                        className={`tabular-nums ${
                          isNearSlaLimit ? 'text-rose-600 animate-pulse' : 'text-zinc-700'
                        }`}
                      >
                        {minutes}m {seconds.toString().padStart(2, '0')}s
                      </span>
                    </div>
                    {/* Visual Progress Bar */}
                    <div className="w-full h-1.5 bg-zinc-100 rounded-full overflow-hidden">
                      <motion.div
                        className={`h-full rounded-full ${
                          order.stage === 'DELIVERED'
                            ? 'bg-zinc-400'
                            : isNearSlaLimit
                            ? 'bg-rose-500'
                            : 'bg-[#2d9d43]'
                        }`}
                        animate={{ width: `${progressPercent}%` }}
                        transition={{ duration: 0.5 }}
                      />
                    </div>
                  </div>
                </div>
              </motion.div>
            );
          })}
        </AnimatePresence>
      </div>
    </div>
  );
}
