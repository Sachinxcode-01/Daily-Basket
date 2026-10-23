/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
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
  Sparkles,
  ShieldCheck,
} from 'lucide-react';
import AnimatedKpiCard from '../../components/analytics/AnimatedKpiCard';
import AnalyticsChart from '../../components/analytics/AnalyticsChart';

export default function ExecutiveAnalyticsDashboard() {
  const [timeframe, setTimeframe] = useState<'today' | 'week' | 'month'>('today');
  const [selectedHub, setSelectedHub] = useState<string>('all');
  const [isAiLoading, setIsAiLoading] = useState(false);
  const [aiReport, setAiReport] = useState<string | null>(null);

  const handleGenerateAiInsights = () => {
    setIsAiLoading(true);
    setTimeout(() => {
      setIsAiLoading(false);
      setAiReport(
        'Executive AI Brief: Evening order velocity is trending +18% above forecast. Reallocate 6 electric fleet riders from Whitefield to Koramangala Hub to maintain 9.2m average SLA. Produce spoilage is at a record low of 0.4%.'
      );
    }, 800);
  };

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-12">
      {/* ─── Top Executive Banner ─────────────────────────────────────────── */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="glass-card rounded-2xl p-6 md:p-8 shadow-sm border border-zinc-200/80 flex flex-col md:flex-row md:items-center justify-between gap-6"
      >
        <div className="flex items-center gap-4">
          <div className="relative w-14 h-14 rounded-2xl overflow-hidden border-2 border-[#2d9d43] shrink-0 shadow-md">
            <img
              src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=256&q=80"
              alt="Executive Profile"
              className="w-full h-full object-cover"
            />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-2xl md:text-3xl font-extrabold text-zinc-950 font-headline tracking-tight">
                Executive Control Deck
              </h1>
              <span className="text-xl">🚀</span>
            </div>
            <div className="flex items-center gap-2 mt-1">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-[#078730] border border-emerald-200/80 text-xs font-bold">
                <span className="w-2 h-2 rounded-full bg-[#2d9d43] animate-pulse" />
                Store Network Operational
              </span>
              <span className="text-xs text-zinc-500 font-medium">
                Dark Store Network • 4 Active Micro-Hubs
              </span>
            </div>
          </div>
        </div>

        {/* Action Controls & Filter Buttons */}
        <div className="flex flex-wrap items-center gap-3">
          <div className="bg-zinc-100 p-1 rounded-xl border border-zinc-200/60 flex items-center gap-1">
            {(['today', 'week', 'month'] as const).map((t) => (
              <button
                key={t}
                onClick={() => setTimeframe(t)}
                className={`relative px-3.5 py-1.5 rounded-lg text-xs font-bold capitalize transition-all ${
                  timeframe === t
                    ? 'text-zinc-950'
                    : 'text-zinc-500 hover:text-zinc-900'
                }`}
              >
                {timeframe === t && (
                  <motion.div
                    layoutId="execTimeframe"
                    className="absolute inset-0 bg-white rounded-lg shadow-sm border border-zinc-200"
                    transition={{ type: 'spring', stiffness: 350, damping: 30 }}
                  />
                )}
                <span className="relative z-10">{t}</span>
              </button>
            ))}
          </div>

          <button
            onClick={handleGenerateAiInsights}
            disabled={isAiLoading}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold transition-all shadow-md active:scale-95 disabled:opacity-50"
          >
            <Bot className={`w-4 h-4 text-white ${isAiLoading ? 'animate-spin' : ''}`} />
            <span>{isAiLoading ? 'Analyzing Fleet...' : 'AI Copilot Brief'}</span>
          </button>
        </div>
      </motion.div>

      {/* AI Report Drawer Banner */}
      <AnimatePresence>
        {aiReport && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="overflow-hidden"
          >
            <div className="p-4 rounded-xl bg-gradient-to-r from-emerald-950 via-zinc-900 to-emerald-950 text-white flex items-start justify-between gap-4 border border-emerald-800/50 shadow-md">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#2d9d43] flex items-center justify-center shrink-0 mt-0.5">
                  <Sparkles className="w-4 h-4 text-white" />
                </div>
                <div>
                  <h4 className="text-xs font-bold font-mono uppercase tracking-wider text-[#8cfa93]">
                    Autonomous Operations Recommendation
                  </h4>
                  <p className="text-xs text-zinc-300 mt-1 leading-relaxed">{aiReport}</p>
                </div>
              </div>
              <button
                onClick={() => setAiReport(null)}
                className="text-xs text-zinc-400 hover:text-white px-2 py-1 rounded bg-white/10 shrink-0"
              >
                Dismiss
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* ─── Executive KPI Cards Grid ─────────────────────────────────────────── */}
      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <AnimatedKpiCard
          title="Daily Gross Merchandise (GMV)"
          value={timeframe === 'today' ? 48250 : timeframe === 'week' ? 342000 : 1420000}
          prefix="₹"
          changePercent={14.2}
          changeLabel="+14.2% vs baseline"
          icon={DollarSign}
          accentColor="#2d9d43"
          sparklineData={[32, 36, 38, 41, 45, 48]}
        />

        <AnimatedKpiCard
          title="Dispatched Baskets"
          value={timeframe === 'today' ? 2450 : timeframe === 'week' ? 16800 : 64000}
          changePercent={8.5}
          changeLabel="Avg 9.4 min SLA"
          icon={ShoppingBag}
          accentColor="#078730"
          sparklineData={[2100, 2200, 2310, 2390, 2450]}
        />

        <AnimatedKpiCard
          title="Gross Operating Margin"
          value={24.8}
          suffix="%"
          decimals={1}
          changePercent={2.3}
          changeLabel="₹11,960 Net Today"
          icon={Landmark}
          accentColor="#0369a1"
          sparklineData={[22.1, 22.8, 23.4, 24.2, 24.8]}
        />

        <AnimatedKpiCard
          title="Fulfillment SLA Score"
          value={98.8}
          suffix="%"
          decimals={1}
          changePercent={0.4}
          changeLabel="12 SLA exceptions only"
          icon={Clock}
          accentColor="#70dd7a"
          sparklineData={[97.5, 98.1, 98.4, 98.6, 98.8]}
        />
      </section>

      {/* Detailed Interactive Chart Section */}
      <AnalyticsChart />

      {/* ─── Operational Hubs & Low Stock Alerts ─────────────────────────────── */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Hub Dispatch Status (Span 7) */}
        <div className="lg:col-span-7 bg-white rounded-2xl p-6 shadow-sm border border-zinc-200/80 space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-base font-bold text-zinc-950 font-headline">
                Micro-Warehouse Real-Time Load
              </h3>
              <p className="text-xs text-zinc-500 font-body">
                SLA compliance and order queuing across Bengaluru
              </p>
            </div>
            <span className="text-xs text-[#078730] font-bold bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200">
              4 Active Hubs
            </span>
          </div>

          <div className="space-y-3">
            {[
              {
                name: 'Koramangala Mega Dark Store #01',
                status: 'Optimal',
                time: '9.2 min SLA',
                load: '88%',
                riders: '44 EVs',
              },
              {
                name: 'Indiranagar Urban Hub #04',
                status: 'High Demand',
                time: '9.6 min SLA',
                load: '94%',
                riders: '32 EVs',
              },
              {
                name: 'HSR Layout Sector 2 Hub',
                status: 'Surge',
                time: '9.8 min SLA',
                load: '96%',
                riders: '28 EVs',
              },
              {
                name: 'Whitefield Tech Hub #08',
                status: 'Optimal',
                time: '8.9 min SLA',
                load: '72%',
                riders: '24 EVs',
              },
            ].map((hub, i) => (
              <div
                key={i}
                className="p-3.5 bg-zinc-50 hover:bg-zinc-100/80 rounded-xl border border-zinc-200/60 flex items-center justify-between text-xs transition-colors"
              >
                <div>
                  <h4 className="font-bold text-zinc-900">{hub.name}</h4>
                  <div className="flex items-center gap-3 text-zinc-500 text-[11px] mt-0.5">
                    <span>{hub.time}</span>
                    <span>•</span>
                    <span className="text-emerald-700 font-semibold">{hub.riders}</span>
                  </div>
                </div>
                <div className="text-right">
                  <span
                    className={`font-bold ${
                      hub.status === 'Optimal'
                        ? 'text-emerald-600'
                        : hub.status === 'High Demand'
                        ? 'text-amber-600'
                        : 'text-rose-600'
                    }`}
                  >
                    {hub.status}
                  </span>
                  <p className="text-[10px] text-zinc-400 font-mono">{hub.load} load</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Low Stock Fresh Produce Alerts (Span 5) */}
        <div className="lg:col-span-5 bg-white rounded-2xl p-6 shadow-sm border border-zinc-200/80 space-y-4">
          <div className="flex items-center gap-2 text-rose-600">
            <AlertTriangle className="w-5 h-5" />
            <h3 className="text-base font-bold text-zinc-950 font-headline">
              Critical Low Stock SKUs
            </h3>
          </div>
          <p className="text-xs text-zinc-500 font-body">
            Algorithmic safety-stock trigger active for fastest selling items.
          </p>

          <div className="space-y-3">
            {[
              { name: 'Amul Toned Milk 1L', stock: '4 left', hub: 'Indiranagar' },
              { name: 'Organic Hass Avocados 2x', stock: '2 left', hub: 'HSR Layout' },
              { name: 'Fresh Paneer 200g', stock: '5 left', hub: 'Koramangala' },
              { name: 'Aashirvaad Shudh Chakki Atta 5kg', stock: '3 left', hub: 'Whitefield' },
            ].map((item, i) => (
              <div
                key={i}
                className="p-3 bg-rose-50/50 rounded-xl border border-rose-100 flex items-center justify-between text-xs"
              >
                <div>
                  <h4 className="font-bold text-zinc-900">{item.name}</h4>
                  <p className="text-zinc-500 text-[11px]">{item.hub} Hub</p>
                </div>
                <span className="font-bold text-rose-700 bg-rose-100 px-2.5 py-1 rounded-full text-[11px]">
                  {item.stock}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
