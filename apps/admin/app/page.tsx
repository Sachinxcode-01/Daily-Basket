'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  TrendingUp,
  Package,
  ShoppingCart,
  Clock,
  CheckCircle2,
  AlertTriangle,
  ArrowUpRight,
  Bike,
  DollarSign,
  Users,
  Zap,
  RefreshCw,
  ExternalLink,
  ChevronRight,
  SlidersHorizontal,
} from 'lucide-react';
import Button from '../components/ui/Button';
import Badge from '../components/ui/Badge';

export default function AdminOverviewPage() {
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => setIsRefreshing(false), 800);
  };

  const queueOrders = [
    {
      id: 'ORD-9824',
      name: 'Aarav Sharma',
      items: '3 items (Avocados, Milk, Eggs)',
      amount: '₹240',
      status: 'PACKING',
      timer: '2m 14s',
      badgeVariant: 'warning' as const,
      hub: 'Koramangala Hub #01',
    },
    {
      id: 'ORD-9825',
      name: 'Neha Gupta',
      items: '5 items (Fresh Spinach, Tomatoes)',
      amount: '₹410',
      status: 'DISPATCHED',
      timer: '5m 02s',
      badgeVariant: 'brand' as const,
      hub: 'Indiranagar Hub #02',
    },
    {
      id: 'ORD-9826',
      name: 'Rahul Verma',
      items: '1 item (Organic Fruit Box)',
      amount: '₹299',
      status: 'CONFIRMED',
      timer: '0m 45s',
      badgeVariant: 'default' as const,
      hub: 'HSR Layout Hub #03',
    },
    {
      id: 'ORD-9827',
      name: 'Siddharth R.',
      items: '4 items (Snacks, Sparkling Water)',
      amount: '₹180',
      status: 'DELIVERED',
      timer: '8m 40s',
      badgeVariant: 'success' as const,
      hub: 'Koramangala Hub #01',
    },
  ];

  return (
    <div className="space-y-8 animate-in fade-in duration-200">
      {/* Page Title & Fast Action Bar */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <h1 className="text-2xl md:text-3xl font-extrabold tracking-tight text-zinc-950">
              Operations Command Center
            </h1>
            <Badge variant="mono" pulse>
              LIVE 10-MIN SLA
            </Badge>
          </div>
          <p className="text-xs md:text-sm text-zinc-500">
            Real-time dark store order queue, dispatch automation, and fleet health metrics.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="secondary"
            size="sm"
            onClick={handleRefresh}
            isLoading={isRefreshing}
            leftIcon={<RefreshCw className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin' : ''}`} />}
          >
            Refresh Feeds
          </Button>

          <Link href="/products/daily-pricing">
            <Button
              variant="brand"
              size="sm"
              leftIcon={<Zap className="w-3.5 h-3.5" />}
            >
              Update Mandi Rates
            </Button>
          </Link>
        </div>
      </div>

      {/* KPI Stats Cards (Vercel Style Clean Grid) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2 group hover:border-zinc-300 transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Today&apos;s Revenue
            </span>
            <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center font-bold">
              <DollarSign className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            ₹1,84,920
          </div>
          <div className="flex items-center gap-1.5 text-xs text-emerald-700 font-semibold">
            <ArrowUpRight className="w-3.5 h-3.5" /> +14.2% from yesterday
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2 group hover:border-zinc-300 transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Active Orders
            </span>
            <div className="w-8 h-8 rounded-lg bg-zinc-100 text-zinc-800 flex items-center justify-center font-bold">
              <ShoppingCart className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            142
          </div>
          <div className="text-xs text-zinc-500">
            38 packing • 104 out for delivery
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2 group hover:border-zinc-300 transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Avg Delivery Time
            </span>
            <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center font-bold">
              <Clock className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            9.4 mins
          </div>
          <div className="flex items-center gap-1.5 text-xs text-emerald-700 font-semibold">
            <CheckCircle2 className="w-3.5 h-3.5" /> SLA Target: &lt; 10.0 mins
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2 group hover:border-zinc-300 transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Active Fleet
            </span>
            <div className="w-8 h-8 rounded-lg bg-zinc-100 text-zinc-800 flex items-center justify-center font-bold">
              <Bike className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            48 / 52
          </div>
          <div className="text-xs text-zinc-500">
            92.3% rider fleet utilization
          </div>
        </div>
      </div>

      {/* Main Content Dashboard Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Live Order Queue Feed (Span 8) */}
        <div className="lg:col-span-8 bg-white rounded-2xl p-6 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-5">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-base font-bold text-zinc-950">Live Dispatch Queue</h2>
              <p className="text-xs text-zinc-500">Auto-refreshing WebSocket stream from rider telemetry.</p>
            </div>
            <Link href="/orders">
              <Button variant="ghost" size="xs" rightIcon={<ChevronRight className="w-3.5 h-3.5" />}>
                View All Orders
              </Button>
            </Link>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-zinc-200/80 text-zinc-500 font-mono uppercase text-[11px]">
                  <th className="pb-3 font-semibold">Order ID</th>
                  <th className="pb-3 font-semibold">Customer</th>
                  <th className="pb-3 font-semibold">Basket Items</th>
                  <th className="pb-3 font-semibold">Amount</th>
                  <th className="pb-3 font-semibold">Status</th>
                  <th className="pb-3 font-semibold text-right">Elapsed</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-zinc-100">
                {queueOrders.map((row) => (
                  <tr key={row.id} className="hover:bg-zinc-50/80 transition-colors">
                    <td className="py-3.5 font-bold font-mono text-[#006b23]">
                      {row.id}
                    </td>
                    <td className="py-3.5 font-semibold text-zinc-900">
                      <div>{row.name}</div>
                      <div className="text-[10px] text-zinc-400 font-normal">{row.hub}</div>
                    </td>
                    <td className="py-3.5 text-zinc-600">
                      {row.items}
                    </td>
                    <td className="py-3.5 font-bold font-mono text-zinc-900">
                      {row.amount}
                    </td>
                    <td className="py-3.5">
                      <Badge variant={row.badgeVariant}>
                        {row.status}
                      </Badge>
                    </td>
                    <td className="py-3.5 font-mono font-bold text-zinc-900 text-right">
                      {row.timer}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Low Stock Alerts & Fast Quick Links (Span 4) */}
        <div className="lg:col-span-4 space-y-6">
          <div className="bg-white rounded-2xl p-6 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-rose-600">
                <AlertTriangle className="w-4 h-4" />
                <h3 className="text-sm font-bold text-zinc-950">Low Stock SKU Alerts</h3>
              </div>
              <Badge variant="danger">4 Critical</Badge>
            </div>

            <div className="space-y-2.5">
              {[
                { name: 'Amul Toned Milk 1L', stock: '4 units left', darkStore: 'Indiranagar Hub' },
                { name: 'Brown Sandwich Bread 400g', stock: '2 units left', darkStore: 'Koramangala Hub' },
                { name: 'Organic Hass Avocados 2x', stock: '6 units left', darkStore: 'HSR Layout Hub' },
              ].map((alert, i) => (
                <div
                  key={i}
                  className="p-3 bg-rose-50/60 rounded-xl border border-rose-200/60 flex items-center justify-between text-xs"
                >
                  <div>
                    <h4 className="font-semibold text-zinc-900">{alert.name}</h4>
                    <p className="text-[11px] text-zinc-500">{alert.darkStore}</p>
                  </div>
                  <span className="font-bold font-mono text-rose-600">{alert.stock}</span>
                </div>
              ))}
            </div>

            <Link href="/inventory" className="block pt-1">
              <Button variant="secondary" size="sm" className="w-full">
                Manage Replenishment
              </Button>
            </Link>
          </div>

          {/* Quick Hub Health Card */}
          <div className="bg-white rounded-2xl p-6 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-3">
            <h3 className="text-sm font-bold text-zinc-950">Dark Store Hardware Nodes</h3>
            <div className="space-y-2 text-xs">
              <div className="flex items-center justify-between p-2 rounded-lg bg-zinc-50">
                <span className="text-zinc-600">IoT Chiller Sensors</span>
                <span className="font-mono text-emerald-600 font-semibold">3.8°C (Optimal)</span>
              </div>
              <div className="flex items-center justify-between p-2 rounded-lg bg-zinc-50">
                <span className="text-zinc-600">Barcode Scanners</span>
                <span className="font-mono text-emerald-600 font-semibold">12/12 Online</span>
              </div>
              <div className="flex items-center justify-between p-2 rounded-lg bg-zinc-50">
                <span className="text-zinc-600">Dispatch Gate Telemetry</span>
                <span className="font-mono text-emerald-600 font-semibold">Connected</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
