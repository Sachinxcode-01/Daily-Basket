'use client';

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Store,
  Bike,
  BatteryCharging,
  Zap,
  CheckCircle2,
  AlertTriangle,
  Users,
  Clock,
  ShieldCheck,
  TrendingUp,
} from 'lucide-react';

interface DarkStoreHub {
  id: string;
  name: string;
  code: string;
  zone: string;
  status: 'OPTIMAL' | 'HIGH_DEMAND' | 'SURGE';
  ordersToday: number;
  avgSlaMinutes: number;
  activeRiders: number;
  totalFleet: number;
  fleetBatteryAvg: number;
  pickersActive: number;
  stockHealthPercent: number;
}

const darkStoreHubs: DarkStoreHub[] = [
  {
    id: 'hub-1',
    name: 'Koramangala Mega Dark Store #01',
    code: 'BLR-KRM-01',
    zone: 'South Bengaluru Central',
    status: 'OPTIMAL',
    ordersToday: 1840,
    avgSlaMinutes: 9.2,
    activeRiders: 44,
    totalFleet: 48,
    fleetBatteryAvg: 88,
    pickersActive: 16,
    stockHealthPercent: 99.4,
  },
  {
    id: 'hub-2',
    name: 'Indiranagar Urban Hub #04',
    code: 'BLR-IND-04',
    zone: 'East Bengaluru Inner',
    status: 'HIGH_DEMAND',
    ordersToday: 1420,
    avgSlaMinutes: 9.6,
    activeRiders: 32,
    totalFleet: 35,
    fleetBatteryAvg: 82,
    pickersActive: 12,
    stockHealthPercent: 97.8,
  },
  {
    id: 'hub-3',
    name: 'HSR Layout Sector 2 Hub',
    code: 'BLR-HSR-02',
    zone: 'South-East Corridor',
    status: 'SURGE',
    ordersToday: 1190,
    avgSlaMinutes: 9.8,
    activeRiders: 28,
    totalFleet: 30,
    fleetBatteryAvg: 79,
    pickersActive: 10,
    stockHealthPercent: 96.5,
  },
  {
    id: 'hub-4',
    name: 'Whitefield Tech Hub #08',
    code: 'BLR-WTF-08',
    zone: 'East Tech Corridor',
    status: 'OPTIMAL',
    ordersToday: 980,
    avgSlaMinutes: 8.9,
    activeRiders: 24,
    totalFleet: 26,
    fleetBatteryAvg: 91,
    pickersActive: 8,
    stockHealthPercent: 99.1,
  },
];

export default function DarkStoreMapTelemetry() {
  const [selectedHubId, setSelectedHubId] = useState<string>('hub-1');

  const selectedHub =
    darkStoreHubs.find((h) => h.id === selectedHubId) || darkStoreHubs[0];

  return (
    <div className="glass-card rounded-2xl p-6 shadow-sm border border-zinc-200/80 flex flex-col">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 mb-5">
        <div>
          <div className="flex items-center gap-2">
            <span className="p-1.5 rounded-lg bg-[#2d9d43]/10 text-[#2d9d43]">
              <Store className="w-4 h-4" />
            </span>
            <h3 className="text-lg font-bold text-zinc-950 font-headline tracking-tight">
              Dark Store Hub Telemetry
            </h3>
            <span className="text-[10px] font-bold uppercase tracking-wider bg-zinc-100 text-zinc-700 px-2 py-0.5 rounded-md font-mono">
              4 Micro-Warehouses
            </span>
          </div>
          <p className="text-xs text-zinc-500 font-body mt-0.5">
            Active picker speed, EV fleet allocation, and automated batching health.
          </p>
        </div>
      </div>

      {/* Hub Tabs with Fluid Transition */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 mb-5">
        {darkStoreHubs.map((hub) => {
          const isSelected = hub.id === selectedHubId;
          return (
            <button
              key={hub.id}
              onClick={() => setSelectedHubId(hub.id)}
              className={`p-3 rounded-xl text-left border transition-all relative overflow-hidden ${
                isSelected
                  ? 'bg-white border-[#2d9d43] shadow-md ring-1 ring-[#2d9d43]/30'
                  : 'bg-zinc-50/70 border-zinc-200/70 hover:bg-zinc-100/80'
              }`}
            >
              {isSelected && (
                <motion.div
                  layoutId="activeHubIndicator"
                  className="absolute top-0 left-0 right-0 h-1 bg-[#2d9d43]"
                  transition={{ type: 'spring', stiffness: 350, damping: 30 }}
                />
              )}
              <div className="flex items-center justify-between mb-1">
                <span className="text-[10px] font-bold font-mono text-zinc-400">
                  {hub.code}
                </span>
                <span
                  className={`w-2 h-2 rounded-full ${
                    hub.status === 'OPTIMAL'
                      ? 'bg-emerald-500'
                      : hub.status === 'HIGH_DEMAND'
                      ? 'bg-amber-500'
                      : 'bg-rose-500'
                  }`}
                />
              </div>
              <div className="font-bold text-xs text-zinc-900 truncate">
                {hub.name.split(' ')[0]} {hub.name.split(' ')[1]}
              </div>
              <div className="text-[11px] text-zinc-500 font-mono mt-0.5">
                {hub.ordersToday} orders
              </div>
            </button>
          );
        })}
      </div>

      {/* Selected Hub Deep-Dive Telemetry Grid with AnimatePresence */}
      <AnimatePresence mode="wait">
        <motion.div
          key={selectedHub.id}
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -10 }}
          transition={{ duration: 0.25 }}
          className="space-y-4"
        >
          {/* Hub Summary Hero Banner */}
          <div className="p-4 rounded-xl bg-gradient-to-r from-zinc-900 via-zinc-950 to-zinc-900 text-white flex flex-col sm:flex-row sm:items-center justify-between gap-4 shadow-sm">
            <div>
              <div className="flex items-center gap-2">
                <h4 className="font-bold text-base font-headline text-white">
                  {selectedHub.name}
                </h4>
                <span className="text-[10px] font-mono font-bold bg-white/10 text-emerald-400 px-2 py-0.5 rounded-full">
                  {selectedHub.status}
                </span>
              </div>
              <p className="text-xs text-zinc-400 mt-0.5">{selectedHub.zone}</p>
            </div>

            <div className="flex items-center gap-6">
              <div>
                <span className="text-[10px] text-zinc-400 uppercase font-mono block">
                  Today Orders
                </span>
                <span className="text-lg font-bold font-headline text-white">
                  {selectedHub.ordersToday.toLocaleString()}
                </span>
              </div>
              <div className="h-8 w-[1px] bg-zinc-800" />
              <div>
                <span className="text-[10px] text-zinc-400 uppercase font-mono block">
                  Avg 10m SLA
                </span>
                <span className="text-lg font-bold font-headline text-emerald-400">
                  {selectedHub.avgSlaMinutes} min
                </span>
              </div>
            </div>
          </div>

          {/* 4 Telemetry Metrics */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
            {/* Metric 1: EV Fleet Utilization */}
            <div className="p-3.5 rounded-xl bg-zinc-50/90 border border-zinc-200/70">
              <div className="flex items-center justify-between text-zinc-500 text-xs font-semibold mb-1">
                <span>Active EV Fleet</span>
                <Bike className="w-4 h-4 text-[#2d9d43]" />
              </div>
              <div className="text-xl font-extrabold text-zinc-950 font-headline">
                {selectedHub.activeRiders} / {selectedHub.totalFleet}
              </div>
              <div className="w-full bg-zinc-200 h-1.5 rounded-full mt-2 overflow-hidden">
                <motion.div
                  className="bg-[#2d9d43] h-full rounded-full"
                  initial={{ width: 0 }}
                  animate={{
                    width: `${(selectedHub.activeRiders / selectedHub.totalFleet) * 100}%`,
                  }}
                  transition={{ duration: 0.6 }}
                />
              </div>
              <span className="text-[10px] text-zinc-400 mt-1 block">
                {Math.round((selectedHub.activeRiders / selectedHub.totalFleet) * 100)}% on delivery routes
              </span>
            </div>

            {/* Metric 2: Fleet Battery Average */}
            <div className="p-3.5 rounded-xl bg-zinc-50/90 border border-zinc-200/70">
              <div className="flex items-center justify-between text-zinc-500 text-xs font-semibold mb-1">
                <span>Fleet Battery Avg</span>
                <BatteryCharging className="w-4 h-4 text-emerald-600" />
              </div>
              <div className="text-xl font-extrabold text-zinc-950 font-headline">
                {selectedHub.fleetBatteryAvg}%
              </div>
              <div className="w-full bg-zinc-200 h-1.5 rounded-full mt-2 overflow-hidden">
                <motion.div
                  className="bg-emerald-500 h-full rounded-full"
                  initial={{ width: 0 }}
                  animate={{ width: `${selectedHub.fleetBatteryAvg}%` }}
                  transition={{ duration: 0.6 }}
                />
              </div>
              <span className="text-[10px] text-zinc-400 mt-1 block">
                6 Swappable packs on charging dock
              </span>
            </div>

            {/* Metric 3: Active Dark Store Pickers */}
            <div className="p-3.5 rounded-xl bg-zinc-50/90 border border-zinc-200/70">
              <div className="flex items-center justify-between text-zinc-500 text-xs font-semibold mb-1">
                <span>In-Store Pickers</span>
                <Users className="w-4 h-4 text-blue-600" />
              </div>
              <div className="text-xl font-extrabold text-zinc-950 font-headline">
                {selectedHub.pickersActive} Active
              </div>
              <div className="w-full bg-zinc-200 h-1.5 rounded-full mt-2 overflow-hidden">
                <motion.div
                  className="bg-blue-600 h-full rounded-full"
                  initial={{ width: 0 }}
                  animate={{ width: '85%' }}
                  transition={{ duration: 0.6 }}
                />
              </div>
              <span className="text-[10px] text-zinc-400 mt-1 block">
                Avg 74s per order picking time
              </span>
            </div>

            {/* Metric 4: Stock Health Index */}
            <div className="p-3.5 rounded-xl bg-zinc-50/90 border border-zinc-200/70">
              <div className="flex items-center justify-between text-zinc-500 text-xs font-semibold mb-1">
                <span>Stock Health Index</span>
                <ShieldCheck className="w-4 h-4 text-[#2d9d43]" />
              </div>
              <div className="text-xl font-extrabold text-zinc-950 font-headline">
                {selectedHub.stockHealthPercent}%
              </div>
              <div className="w-full bg-zinc-200 h-1.5 rounded-full mt-2 overflow-hidden">
                <motion.div
                  className="bg-[#2d9d43] h-full rounded-full"
                  initial={{ width: 0 }}
                  animate={{ width: `${selectedHub.stockHealthPercent}%` }}
                  transition={{ duration: 0.6 }}
                />
              </div>
              <span className="text-[10px] text-zinc-400 mt-1 block">
                Zero critical out-of-stock SKUs
              </span>
            </div>
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}
