'use client';

import React from 'react';
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
} from 'lucide-react';

export default function AdminOverviewPage() {
  return (
    <div className="space-y-8">
      {/* Page Title Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Admin Overview</h1>
          <p className="text-sm text-[#3f4a3d]">Real-time dark store operations, dispatch metrics, and revenue analytics.</p>
        </div>
        <div className="flex items-center gap-2">
          <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[#dce5dd] text-[#006b23] text-xs font-bold">
            <span className="w-2 h-2 rounded-full bg-[#006b23] animate-pulse" /> Live Store Feeds
          </span>
        </div>
      </div>

      {/* KPI Stats Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Today&apos;s Revenue</span>
            <div className="w-9 h-9 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
              <DollarSign className="w-5 h-5" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#1a1c1e]">₹1,84,920</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            <ArrowUpRight className="w-3.5 h-3.5" /> +14.2% from yesterday
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Active Orders</span>
            <div className="w-9 h-9 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
              <ShoppingCart className="w-5 h-5" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#1a1c1e]">142</div>
          <div className="flex items-center gap-1 text-xs text-[#3f4a3d]">
            38 packing • 104 out for delivery
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Avg Delivery Time</span>
            <div className="w-9 h-9 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
              <Clock className="w-5 h-5" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#1a1c1e]">9.4 mins</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            <CheckCircle2 className="w-3.5 h-3.5" /> SLA Target: &lt; 10 mins
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Active Fleet</span>
            <div className="w-9 h-9 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
              <Bike className="w-5 h-5" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#1a1c1e]">48 / 52</div>
          <div className="flex items-center gap-1 text-xs text-[#3f4a3d]">
            92.3% rider utilization
          </div>
        </div>
      </div>

      {/* Main Content Dashboard Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* Live Order Queue Feed (Span 8) */}
        <div className="lg:col-span-8 bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] space-y-6">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-bold text-[#1a1c1e]">Live Dispatch Queue</h2>
            <span className="text-xs text-[#3f4a3d]">Auto-refreshing (2s)</span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-[#e2e2e5] text-[#3f4a3d] uppercase font-bold tracking-wider">
                  <th className="pb-3">Order ID</th>
                  <th className="pb-3">Customer</th>
                  <th className="pb-3">Items</th>
                  <th className="pb-3">Amount</th>
                  <th className="pb-3">Status</th>
                  <th className="pb-3">SLA Timer</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#e2e2e5]">
                {[
                  { id: 'ORD-9824', name: 'Aarav Sharma', items: '3 items (Avocados, Milk)', amount: '₹240', status: 'PACKING', timer: '2m 14s' },
                  { id: 'ORD-9825', name: 'Neha Gupta', items: '5 items (Vegetables)', amount: '₹410', status: 'DISPATCHED', timer: '5m 02s' },
                  { id: 'ORD-9826', name: 'Rahul Verma', items: '1 item (Fruit Box)', amount: '₹299', status: 'CONFIRMED', timer: '0m 45s' },
                  { id: 'ORD-9827', name: 'Siddharth R.', items: '4 items (Snacks)', amount: '₹180', status: 'DELIVERED', timer: '8m 40s' },
                ].map((row) => (
                  <tr key={row.id} className="hover:bg-[#f3f3f6] transition">
                    <td className="py-3 font-bold text-[#006b23]">{row.id}</td>
                    <td className="py-3 font-semibold text-[#1a1c1e]">{row.name}</td>
                    <td className="py-3 text-[#3f4a3d]">{row.items}</td>
                    <td className="py-3 font-bold text-[#1a1c1e]">{row.amount}</td>
                    <td className="py-3">
                      <span className={`px-2.5 py-1 rounded-full font-bold text-[10px] ${
                        row.status === 'DELIVERED' ? 'bg-[#dce5dd] text-[#006b23]' : 'bg-[#ffdad6] text-[#ba1a1a]'
                      }`}>
                        {row.status}
                      </span>
                    </td>
                    <td className="py-3 font-mono font-bold text-[#1a1c1e]">{row.timer}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Low Stock Alerts & Dark Store Health (Span 4) */}
        <div className="lg:col-span-4 space-y-6">
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
            <div className="flex items-center gap-2 text-[#ba1a1a]">
              <AlertTriangle className="w-5 h-5" />
              <h3 className="text-base font-bold text-[#1a1c1e]">Low Stock SKU Alerts</h3>
            </div>

            <div className="space-y-3">
              {[
                { name: 'Amul Toned Milk 1L', stock: '4 units left', darkStore: 'Indiranagar Hub' },
                { name: 'Brown Sandwich Bread 400g', stock: '2 units left', darkStore: 'Koramangala Hub' },
                { name: 'Organic Hass Avocados 2x', stock: '6 units left', darkStore: 'HSR Layout Hub' },
              ].map((alert, i) => (
                <div key={i} className="p-3 bg-[#ffdad6]/40 rounded-2xl border border-[#ffdad6] flex items-center justify-between text-xs">
                  <div>
                    <h4 className="font-bold text-[#1a1c1e]">{alert.name}</h4>
                    <p className="text-[#3f4a3d]">{alert.darkStore}</p>
                  </div>
                  <span className="font-bold text-[#ba1a1a]">{alert.stock}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
