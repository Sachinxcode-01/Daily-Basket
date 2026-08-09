/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState } from 'react';
import {
  TrendingUp,
  ShoppingBag,
  Landmark,
  Clock,
  AlertTriangle,
  ArrowUpRight,
  Minus,
  Bot,
  Store,
  DollarSign,
  Package,
  Layers,
  ChevronRight,
  Filter,
  RefreshCw,
  Zap,
} from 'lucide-react';

export default function ExecutiveAnalyticsDashboard() {
  const [timeframe, setTimeframe] = useState<'today' | 'week' | 'month'>('today');
  const [selectedHub, setSelectedHub] = useState<string>('all');

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-12">
      {/* ─── Top Executive Banner (Google Stitch Spec) ─────────────────────────── */}
      <div className="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-surface-variant flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div className="flex items-center gap-4">
          <div className="relative w-14 h-14 rounded-full overflow-hidden border-2 border-primary-container shrink-0 shadow-md">
            <img
              src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=256&q=80"
              alt="Executive Profile"
              className="w-full h-full object-cover"
            />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-2xl md:text-3xl font-extrabold text-on-surface tracking-tight">
                Good Morning, Sachin <span className="inline-block animate-bounce">👋</span>
              </h1>
            </div>
            <div className="flex items-center gap-2 mt-1">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary-container/20 text-primary text-xs font-bold">
                <span className="w-2 h-2 rounded-full bg-status-success animate-pulse" />
                Store Open & Operational
              </span>
              <span className="text-xs text-on-surface-subtle">
                Dark Store Network • 12 Active Hubs
              </span>
            </div>
          </div>
        </div>

        {/* Action Controls & Filter Buttons */}
        <div className="flex flex-wrap items-center gap-3">
          <div className="bg-surface-container-low p-1 rounded-2xl border border-surface-variant flex items-center gap-1">
            {(['today', 'week', 'month'] as const).map((t) => (
              <button
                key={t}
                onClick={() => setTimeframe(t)}
                className={`px-3.5 py-1.5 rounded-xl text-xs font-bold capitalize transition-all ${
                  timeframe === t
                    ? 'bg-primary text-on-primary shadow-sm'
                    : 'text-on-surface-variant hover:text-on-surface'
                }`}
              >
                {t}
              </button>
            ))}
          </div>

          <button className="flex items-center gap-2 px-4 py-2 rounded-2xl bg-surface-container-high hover:bg-surface-container-highest text-on-surface-variant text-xs font-bold transition-all active:scale-95">
            <Bot className="w-4 h-4 text-primary" />
            <span>AI Copilot Insights</span>
          </button>
        </div>
      </div>

      {/* ─── Executive KPI Cards Grid (Exact Stitch Specifications) ───────────────── */}
      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        {/* Today's Revenue */}
        <div className="glass-card rounded-3xl p-5 flex flex-col justify-between min-h-[140px] relative overflow-hidden bg-gradient-to-br from-primary-container/15 via-white to-transparent border border-primary-container/20">
          <div className="flex justify-between items-start mb-2 z-10">
            <span className="text-xs font-bold text-on-surface-subtle uppercase tracking-wider">
              Today&apos;s Revenue
            </span>
            <div className="bg-primary/10 p-2 rounded-full text-primary">
              <DollarSign className="w-4 h-4" />
            </div>
          </div>
          <div className="z-10">
            <h2 className="text-3xl font-black text-on-surface">$12,450</h2>
            <div className="flex items-center gap-1 mt-1.5">
              <ArrowUpRight className="w-4 h-4 text-status-success" />
              <span className="text-xs font-bold text-status-success">+14% vs yesterday</span>
            </div>
          </div>
          {/* Sparkline Decorative Overlay */}
          <svg
            className="absolute bottom-0 left-0 w-full h-14 opacity-25 text-primary pointer-events-none"
            preserveAspectRatio="none"
            viewBox="0 0 100 30"
          >
            <path
              d="M0 30 L10 20 L20 25 L30 10 L40 15 L50 5 L60 12 L70 8 L80 18 L90 5 L100 15 L100 30 Z"
              fill="currentColor"
            />
            <polyline
              fill="none"
              points="0,30 10,20 20,25 30,10 40,15 50,5 60,12 70,8 80,18 90,5 100,15"
              stroke="currentColor"
              strokeWidth="2"
            />
          </svg>
        </div>

        {/* Today's Orders */}
        <div className="glass-card rounded-3xl p-5 flex flex-col justify-between min-h-[140px] border border-surface-variant">
          <div className="flex justify-between items-start mb-2">
            <span className="text-xs font-bold text-on-surface-subtle uppercase tracking-wider">
              Today&apos;s Orders
            </span>
            <div className="bg-secondary/10 p-2 rounded-full text-secondary">
              <ShoppingBag className="w-4 h-4" />
            </div>
          </div>
          <div>
            <h2 className="text-3xl font-black text-on-surface">342</h2>
            <div className="flex items-center gap-1 mt-1.5">
              <ArrowUpRight className="w-4 h-4 text-status-success" />
              <span className="text-xs font-bold text-status-success">+5% vs yesterday</span>
            </div>
          </div>
        </div>

        {/* Gross Profit */}
        <div className="glass-card rounded-3xl p-5 flex flex-col justify-between min-h-[140px] border border-surface-variant">
          <div className="flex justify-between items-start mb-2">
            <span className="text-xs font-bold text-on-surface-subtle uppercase tracking-wider">
              Gross Profit
            </span>
            <div className="bg-status-info/10 p-2 rounded-full text-status-info">
              <Landmark className="w-4 h-4" />
            </div>
          </div>
          <div>
            <h2 className="text-3xl font-black text-on-surface">$4,120</h2>
            <div className="flex items-center gap-1 mt-1.5">
              <Minus className="w-4 h-4 text-status-warning" />
              <span className="text-xs font-bold text-status-warning">Stable performance</span>
            </div>
          </div>
        </div>

        {/* Pending Orders (Attention Required) */}
        <div className="glass-card rounded-3xl p-5 flex flex-col justify-between min-h-[140px] bg-error-container/20 border border-error-container">
          <div className="flex justify-between items-start mb-2">
            <span className="text-xs font-bold text-on-surface-subtle uppercase tracking-wider">
              Pending Orders
            </span>
            <div className="bg-status-error/10 p-2 rounded-full text-status-error">
              <Clock className="w-4 h-4" />
            </div>
          </div>
          <div>
            <h2 className="text-3xl font-black text-on-surface">18</h2>
            <div className="flex items-center gap-1 mt-1.5">
              <AlertTriangle className="w-4 h-4 text-status-error" />
              <span className="text-xs font-bold text-status-error">Needs immediate attention</span>
            </div>
          </div>
        </div>
      </section>

      {/* ─── Detailed Executive Analytics Grid ─────────────────────────────────── */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* Hourly Revenue & Order Velocity (Span 8) */}
        <div className="lg:col-span-8 bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-surface-variant space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h2 className="text-lg font-bold text-on-surface">Hourly Order & Revenue Velocity</h2>
              <p className="text-xs text-on-surface-variant mt-0.5">
                Real-time 10-minute dispatch throughput across Bangalore hubs
              </p>
            </div>
            <div className="flex items-center gap-2">
              <span className="inline-flex items-center gap-1.5 text-xs text-status-success font-bold bg-status-success/10 px-3 py-1 rounded-full">
                <Zap className="w-3.5 h-3.5" /> Peak Hour (9.4m SLA)
              </span>
            </div>
          </div>

          {/* Simulated Hourly Chart Bars */}
          <div className="h-64 flex items-end justify-between gap-2 pt-8 pb-2 border-b border-surface-variant">
            {[
              { time: '6 AM', val: 40, rev: '$850' },
              { time: '7 AM', val: 65, rev: '$1,420' },
              { time: '8 AM', val: 95, rev: '$2,890' },
              { time: '9 AM', val: 100, rev: '$3,450' },
              { time: '10 AM', val: 80, rev: '$2,100' },
              { time: '11 AM', val: 55, rev: '$1,740' },
              { time: '12 PM', val: 70, rev: '$2,200' },
            ].map((h, i) => (
              <div key={i} className="flex-1 flex flex-col items-center gap-2 h-full justify-end group">
                <div className="text-[10px] font-bold text-on-surface-variant opacity-0 group-hover:opacity-100 transition-opacity">
                  {h.rev}
                </div>
                <div
                  style={{ height: `${h.val}%` }}
                  className="w-full bg-gradient-to-t from-primary-container to-primary rounded-t-xl group-hover:brightness-110 transition-all cursor-pointer relative"
                />
                <span className="text-[11px] font-bold text-on-surface-subtle">{h.time}</span>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-3 gap-4 pt-2">
            <div className="bg-surface-container-low p-4 rounded-2xl">
              <span className="text-xs text-on-surface-subtle font-semibold">Average Order Value</span>
              <p className="text-xl font-bold text-on-surface mt-1">$36.40</p>
            </div>
            <div className="bg-surface-container-low p-4 rounded-2xl">
              <span className="text-xs text-on-surface-subtle font-semibold">Fulfillment SLA Rate</span>
              <p className="text-xl font-bold text-status-success mt-1">98.4%</p>
            </div>
            <div className="bg-surface-container-low p-4 rounded-2xl">
              <span className="text-xs text-on-surface-subtle font-semibold">Active Riders</span>
              <p className="text-xl font-bold text-on-surface mt-1">48 On Duty</p>
            </div>
          </div>
        </div>

        {/* Operational Hubs & Low Stock Alerts (Span 4) */}
        <div className="lg:col-span-4 space-y-6">
          {/* Dark Store Network Status */}
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-surface-variant space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="text-base font-bold text-on-surface">Hub Dispatch Status</h3>
              <span className="text-xs text-primary font-bold">12 Active</span>
            </div>

            <div className="space-y-3">
              {[
                { name: 'Indiranagar Hub', status: 'Optimal', time: '8.2 min SLA', load: '88%' },
                { name: 'Koramangala Hub', status: 'High Traffic', time: '9.5 min SLA', load: '94%' },
                { name: 'HSR Layout Hub', status: 'Optimal', time: '7.9 min SLA', load: '72%' },
                { name: 'Whitefield Hub', status: 'Optimal', time: '8.8 min SLA', load: '65%' },
              ].map((hub, i) => (
                <div key={i} className="p-3.5 bg-surface-container-low rounded-2xl flex items-center justify-between text-xs">
                  <div>
                    <h4 className="font-bold text-on-surface">{hub.name}</h4>
                    <p className="text-on-surface-variant">{hub.time}</p>
                  </div>
                  <div className="text-right">
                    <span className="font-bold text-status-success">{hub.status}</span>
                    <p className="text-[10px] text-on-surface-subtle">{hub.load} load</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Low Stock Alerts Card */}
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-error-container/60 space-y-4">
            <div className="flex items-center gap-2 text-status-error">
              <AlertTriangle className="w-5 h-5" />
              <h3 className="text-base font-bold text-on-surface">Critical Low Stock SKUs</h3>
            </div>

            <div className="space-y-3">
              {[
                { name: 'Amul Toned Milk 1L', stock: '4 left', hub: 'Indiranagar' },
                { name: 'Organic Hass Avocados 2x', stock: '2 left', hub: 'HSR Layout' },
                { name: 'Fresh Paneer 200g', stock: '5 left', hub: 'Koramangala' },
              ].map((item, i) => (
                <div
                  key={i}
                  className="p-3 bg-error-container/30 rounded-2xl border border-error-container flex items-center justify-between text-xs"
                >
                  <div>
                    <h4 className="font-bold text-on-surface">{item.name}</h4>
                    <p className="text-on-surface-variant">{item.hub} Hub</p>
                  </div>
                  <span className="font-extrabold text-status-error bg-error-container px-2.5 py-1 rounded-full">
                    {item.stock}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
