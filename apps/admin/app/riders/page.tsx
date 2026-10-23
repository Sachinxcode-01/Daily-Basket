'use client';

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Bike,
  ShieldCheck,
  Clock,
  Award,
  Star,
  Search,
  MapPin,
  BatteryCharging,
  Zap,
  Phone,
  Navigation,
  CheckCircle2,
  AlertTriangle,
  Flame,
  ArrowRight,
  Filter,
} from 'lucide-react';
import AnimatedKpiCard from '../../components/analytics/AnimatedKpiCard';
import Button from '../../components/ui/Button';
import Badge from '../../components/ui/Badge';

interface Rider {
  id: string;
  name: string;
  vehicle: string;
  rating: number;
  tripsToday: number;
  avgTime: string;
  status: 'ON_TRIP' | 'AVAILABLE' | 'CHARGING' | 'BREAK';
  hub: string;
  battery: number;
  lat: number;
  lng: number;
  currentOrder?: string;
  phone: string;
}

const mockRiders: Rider[] = [
  {
    id: 'RID-401',
    name: 'Ramesh Kumar',
    vehicle: 'Ather 450X #24',
    rating: 4.95,
    tripsToday: 26,
    avgTime: '8.2 mins',
    status: 'ON_TRIP',
    hub: 'Indiranagar Hub #04',
    battery: 78,
    lat: 12.9716,
    lng: 77.6412,
    currentOrder: '#DB-8921',
    phone: '+91 98450 11223',
  },
  {
    id: 'RID-402',
    name: 'Sunil Verma',
    vehicle: 'Ola S1 Pro #18',
    rating: 4.91,
    tripsToday: 22,
    avgTime: '8.8 mins',
    status: 'AVAILABLE',
    hub: 'Koramangala Hub #01',
    battery: 92,
    lat: 12.9352,
    lng: 77.6245,
    phone: '+91 98450 22334',
  },
  {
    id: 'RID-403',
    name: 'Deepak Singh',
    vehicle: 'Ather 450X #09',
    rating: 4.88,
    tripsToday: 19,
    avgTime: '9.4 mins',
    status: 'ON_TRIP',
    hub: 'Koramangala Hub #01',
    battery: 45,
    lat: 12.9279,
    lng: 77.6271,
    currentOrder: '#DB-8923',
    phone: '+91 98450 33445',
  },
  {
    id: 'RID-404',
    name: 'Amit Patel',
    vehicle: 'Chetak EV #31',
    rating: 4.98,
    tripsToday: 28,
    avgTime: '7.9 mins',
    status: 'AVAILABLE',
    hub: 'HSR Layout Hub #02',
    battery: 88,
    lat: 12.9121,
    lng: 77.6446,
    phone: '+91 98450 44556',
  },
  {
    id: 'RID-405',
    name: 'Kiran Gowda',
    vehicle: 'TVS iQube #14',
    rating: 4.89,
    tripsToday: 18,
    avgTime: '8.5 mins',
    status: 'CHARGING',
    hub: 'Whitefield Hub #08',
    battery: 24,
    lat: 12.9698,
    lng: 77.7499,
    phone: '+91 98450 55667',
  },
  {
    id: 'RID-406',
    name: 'Vikas Rao',
    vehicle: 'Ather 450X #11',
    rating: 4.93,
    tripsToday: 24,
    avgTime: '8.1 mins',
    status: 'ON_TRIP',
    hub: 'HSR Layout Hub #02',
    battery: 64,
    lat: 12.9145,
    lng: 77.6389,
    currentOrder: '#DB-8924',
    phone: '+91 98450 66778',
  },
];

export default function RiderPerformancePage() {
  const [filter, setFilter] = useState<'ALL' | 'ON_TRIP' | 'AVAILABLE' | 'CHARGING'>('ALL');
  const [search, setSearch] = useState('');
  const [selectedRider, setSelectedRider] = useState<Rider | null>(null);

  const filteredRiders = mockRiders.filter((r) => {
    const matchesFilter = filter === 'ALL' || r.status === filter;
    const matchesSearch =
      r.name.toLowerCase().includes(search.toLowerCase()) ||
      r.id.toLowerCase().includes(search.toLowerCase()) ||
      r.hub.toLowerCase().includes(search.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  return (
    <div className="space-y-8">
      {/* ─── Header ──────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-2xl md:text-3xl font-extrabold font-headline tracking-tight text-zinc-950">
              Rider Performance & EV Fleet
            </h1>
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold font-mono bg-emerald-50 text-[#078730] border border-emerald-200">
              <span className="w-2 h-2 rounded-full bg-[#2d9d43] animate-ping" />
              GPS RADAR ACTIVE
            </span>
          </div>
          <p className="text-xs md:text-sm text-zinc-500 mt-1 font-body">
            Real-time electric scooter telemetry, doorstep speed, and battery swap networks.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Button
            variant="brand"
            size="sm"
            leftIcon={<Zap className="w-3.5 h-3.5 text-white" />}
          >
            Auto-Dispatch Mode
          </Button>
        </div>
      </div>

      {/* ─── 4 Fleet KPI Cards ────────────────────────────────────────────────── */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <AnimatedKpiCard
          title="Active Fleet On Duty"
          value={48}
          suffix=" riders"
          changePercent={12.5}
          changeLabel="92% Store Grid Coverage"
          icon={Bike}
          accentColor="#2d9d43"
          sparklineData={[40, 42, 44, 46, 47, 48]}
        />
        <AnimatedKpiCard
          title="On-Time 10m SLA"
          value={98.6}
          suffix="%"
          decimals={1}
          changePercent={0.4}
          changeLabel="Target: >98.0%"
          icon={Clock}
          accentColor="#078730"
          sparklineData={[97.8, 98.1, 98.4, 98.6]}
        />
        <AnimatedKpiCard
          title="Avg Doorstep Time"
          value={8.4}
          suffix=" mins"
          decimals={1}
          changePercent={-6.2}
          changeLabel="Shelf to customer handoff"
          icon={Navigation}
          accentColor="#0369a1"
          sparklineData={[9.2, 8.9, 8.6, 8.4]}
        />
        <AnimatedKpiCard
          title="Partner CSAT Rating"
          value={4.92}
          suffix=" / 5.0"
          decimals={2}
          changePercent={1.8}
          changeLabel="Top partner tier"
          icon={Star}
          accentColor="#b45309"
          sparklineData={[4.88, 4.9, 4.91, 4.92]}
        />
      </div>

      {/* ─── Simulated Live GPS Fleet Radar Map Widget ────────────────────────── */}
      <div className="glass-card rounded-2xl p-6 shadow-sm border border-zinc-200/80 space-y-4">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
          <div>
            <div className="flex items-center gap-2">
              <span className="p-1.5 rounded-lg bg-[#2d9d43]/10 text-[#2d9d43]">
                <Navigation className="w-4 h-4" />
              </span>
              <h3 className="text-base font-bold text-zinc-950 font-headline">
                Bengaluru Dark Store Grid & GPS Dispatch Map
              </h3>
            </div>
            <p className="text-xs text-zinc-500 font-body">
              Live tracking of electric delivery fleet across active dark store micro-zones.
            </p>
          </div>

          <div className="flex items-center gap-3 text-xs">
            <span className="flex items-center gap-1.5 text-zinc-600 font-medium">
              <span className="w-2.5 h-2.5 rounded-full bg-[#2d9d43] inline-block animate-pulse" />
              On Delivery Trip (32)
            </span>
            <span className="flex items-center gap-1.5 text-zinc-600 font-medium">
              <span className="w-2.5 h-2.5 rounded-full bg-blue-500 inline-block" />
              Available at Hub (12)
            </span>
            <span className="flex items-center gap-1.5 text-zinc-600 font-medium">
              <span className="w-2.5 h-2.5 rounded-full bg-amber-500 inline-block" />
              Charging (4)
            </span>
          </div>
        </div>

        {/* Visual Simulated Map Canvas */}
        <div className="relative w-full h-[280px] bg-gradient-to-br from-zinc-900 via-zinc-950 to-zinc-900 rounded-xl overflow-hidden border border-zinc-800 flex items-center justify-center p-4">
          {/* Subtle Grid Map Lines */}
          <div
            className="absolute inset-0 opacity-15"
            style={{
              backgroundImage:
                'radial-gradient(circle at 1px 1px, #2d9d43 1px, transparent 0)',
              backgroundSize: '24px 24px',
            }}
          />

          {/* Dark Store Hub Nodes */}
          {[
            { name: 'Koramangala Hub #01', x: '45%', y: '50%' },
            { name: 'Indiranagar Hub #04', x: '60%', y: '30%' },
            { name: 'HSR Layout Hub #02', x: '40%', y: '75%' },
            { name: 'Whitefield Hub #08', x: '80%', y: '40%' },
          ].map((hub, idx) => (
            <div
              key={idx}
              className="absolute flex flex-col items-center"
              style={{ left: hub.x, top: hub.y }}
            >
              <div className="w-6 h-6 rounded-lg bg-[#2d9d43] text-white flex items-center justify-center text-[10px] font-bold shadow-lg ring-4 ring-[#2d9d43]/30">
                DB
              </div>
              <span className="text-[10px] font-mono text-zinc-300 font-bold bg-zinc-950/80 px-1.5 py-0.5 rounded mt-1 border border-zinc-800 whitespace-nowrap">
                {hub.name}
              </span>
            </div>
          ))}

          {/* Simulated Moving Riders */}
          {mockRiders.map((r, i) => {
            const posX = 35 + ((i * 12) % 55);
            const posY = 25 + ((i * 16) % 60);
            return (
              <motion.div
                key={r.id}
                className="absolute cursor-pointer group"
                style={{ left: `${posX}%`, top: `${posY}%` }}
                animate={{
                  x: [0, (i % 2 === 0 ? 10 : -10), 0],
                  y: [0, (i % 2 === 0 ? -12 : 12), 0],
                }}
                transition={{
                  duration: 4 + (i % 3),
                  repeat: Infinity,
                  ease: 'easeInOut',
                }}
                onClick={() => setSelectedRider(r)}
              >
                <div
                  className={`w-5 h-5 rounded-full flex items-center justify-center shadow-md ring-2 ring-white/20 ${
                    r.status === 'ON_TRIP'
                      ? 'bg-emerald-500 text-white'
                      : r.status === 'AVAILABLE'
                      ? 'bg-blue-500 text-white'
                      : 'bg-amber-500 text-white'
                  }`}
                >
                  <Bike className="w-3 h-3" />
                </div>
                {/* Hover Tooltip */}
                <div className="absolute -top-7 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 transition-opacity bg-zinc-900 text-white text-[10px] px-2 py-0.5 rounded shadow pointer-events-none whitespace-nowrap z-20 font-mono">
                  {r.name} ({r.avgTime})
                </div>
              </motion.div>
            );
          })}

          {/* Map Overlay Stats */}
          <div className="absolute bottom-3 left-3 bg-zinc-900/90 backdrop-blur-md px-3 py-1.5 rounded-lg border border-zinc-800 text-[11px] text-zinc-300 font-mono flex items-center gap-3">
            <span>Grid Speed: 26.4 km/h</span>
            <span>•</span>
            <span className="text-emerald-400">Battery Swap Ready (18 packs)</span>
          </div>
        </div>
      </div>

      {/* ─── Fleet Roster Table with Filters ─────────────────────────────────── */}
      <div className="bg-white rounded-2xl shadow-sm border border-zinc-200/80 overflow-hidden">
        <div className="p-5 border-b border-zinc-200/80 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-zinc-50/50">
          <div>
            <h3 className="text-base font-bold text-zinc-950 font-headline">
              Rider Fleet Roster & Dispatch Details
            </h3>
            <p className="text-xs text-zinc-500 font-body">
              Status, vehicle telemetry, and today trip counts.
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-2.5">
            {/* Status Filter Tabs */}
            <div className="flex items-center bg-zinc-100 p-1 rounded-xl text-xs font-semibold text-zinc-600">
              {(['ALL', 'ON_TRIP', 'AVAILABLE', 'CHARGING'] as const).map((st) => (
                <button
                  key={st}
                  onClick={() => setFilter(st)}
                  className={`px-3 py-1 rounded-lg transition-all ${
                    filter === st
                      ? 'bg-white text-zinc-950 shadow-sm font-bold'
                      : 'hover:text-zinc-900'
                  }`}
                >
                  {st.replace('_', ' ')}
                </button>
              ))}
            </div>

            {/* Search Input */}
            <div className="relative w-48 sm:w-56">
              <Search className="w-4 h-4 text-zinc-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Search partner or ID..."
                className="w-full pl-9 pr-3 py-1.5 bg-white border border-zinc-200 rounded-xl text-xs text-zinc-900 placeholder-zinc-400 focus:outline-none focus:border-[#2d9d43]"
              />
            </div>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs border-collapse">
            <thead>
              <tr className="bg-zinc-50/80 text-[11px] text-zinc-500 uppercase font-mono font-semibold tracking-wider border-b border-zinc-200">
                <th className="px-5 py-3">Rider ID</th>
                <th className="px-5 py-3">Partner Name</th>
                <th className="px-5 py-3">EV Model & Battery</th>
                <th className="px-5 py-3">Assigned Hub</th>
                <th className="px-5 py-3">Trips Today</th>
                <th className="px-5 py-3">Avg SLA Speed</th>
                <th className="px-5 py-3">Rating</th>
                <th className="px-5 py-3">Status</th>
                <th className="px-5 py-3 text-right">Inspect</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 bg-white">
              {filteredRiders.map((r) => (
                <tr
                  key={r.id}
                  onClick={() => setSelectedRider(r)}
                  className="hover:bg-zinc-50/80 transition cursor-pointer"
                >
                  <td className="px-5 py-3.5 font-mono font-bold text-[#2d9d43]">
                    {r.id}
                  </td>
                  <td className="px-5 py-3.5">
                    <div className="font-bold text-zinc-900">{r.name}</div>
                    <div className="text-[11px] text-zinc-400 font-mono">{r.phone}</div>
                  </td>
                  <td className="px-5 py-3.5">
                    <div className="text-zinc-800 font-medium">{r.vehicle}</div>
                    <div className="flex items-center gap-1.5 mt-0.5">
                      <div className="w-16 h-1.5 bg-zinc-100 rounded-full overflow-hidden">
                        <div
                          className={`h-full rounded-full ${
                            r.battery > 50 ? 'bg-[#2d9d43]' : 'bg-amber-500'
                          }`}
                          style={{ width: `${r.battery}%` }}
                        />
                      </div>
                      <span className="text-[10px] text-zinc-400 font-mono">
                        {r.battery}%
                      </span>
                    </div>
                  </td>
                  <td className="px-5 py-3.5 text-zinc-600">{r.hub}</td>
                  <td className="px-5 py-3.5 font-bold text-zinc-950 font-mono">
                    {r.tripsToday} trips
                  </td>
                  <td className="px-5 py-3.5 font-bold text-zinc-950 font-mono">
                    {r.avgTime}
                  </td>
                  <td className="px-5 py-3.5 font-bold text-amber-600">
                    <div className="flex items-center gap-1">
                      <Star className="w-3.5 h-3.5 fill-amber-400" />
                      <span>{r.rating}</span>
                    </div>
                  </td>
                  <td className="px-5 py-3.5">
                    <span
                      className={`px-2.5 py-0.5 rounded-full font-bold text-[10px] font-mono ${
                        r.status === 'ON_TRIP'
                          ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                          : r.status === 'AVAILABLE'
                          ? 'bg-blue-50 text-blue-800 border border-blue-200'
                          : 'bg-amber-50 text-amber-800 border border-amber-200'
                      }`}
                    >
                      {r.status.replace('_', ' ')}
                    </span>
                  </td>
                  <td className="px-5 py-3.5 text-right">
                    <button className="text-[#2d9d43] hover:bg-[#2d9d43]/10 p-1.5 rounded-lg transition">
                      <ArrowRight className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* ─── Rider Details Slide Drawer ──────────────────────────────────────── */}
      <AnimatePresence>
        {selectedRider && (
          <div className="fixed inset-0 z-50 overflow-hidden flex justify-end">
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setSelectedRider(null)}
              className="fixed inset-0 bg-black/40 backdrop-blur-xs"
            />
            <motion.div
              initial={{ x: '100%' }}
              animate={{ x: 0 }}
              exit={{ x: '100%' }}
              transition={{ type: 'spring', damping: 28, stiffness: 280 }}
              className="relative w-full max-w-md bg-white shadow-2xl flex flex-col h-full z-10 border-l border-zinc-200 p-6 space-y-6"
            >
              <div className="flex items-center justify-between pb-4 border-b border-zinc-200">
                <div>
                  <h3 className="font-bold text-lg font-headline text-zinc-950">
                    {selectedRider.name}
                  </h3>
                  <span className="text-xs text-zinc-400 font-mono">
                    {selectedRider.id} • {selectedRider.hub}
                  </span>
                </div>
                <button
                  onClick={() => setSelectedRider(null)}
                  className="p-1.5 rounded-lg text-zinc-400 hover:text-zinc-600 hover:bg-zinc-100"
                >
                  ✕
                </button>
              </div>

              <div className="p-4 bg-emerald-50 rounded-xl border border-emerald-200 text-xs space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-zinc-600 font-medium">Daily Milestone Bonus</span>
                  <span className="font-bold text-[#078730]">₹600 UNLOCKED</span>
                </div>
                <div className="text-[11px] text-zinc-500">
                  Completed {selectedRider.tripsToday} / 25 trips required for peak incentive.
                </div>
              </div>

              <div className="space-y-3 text-xs">
                <div className="flex items-center justify-between p-3 bg-zinc-50 rounded-xl">
                  <span className="text-zinc-500">Vehicle Battery</span>
                  <span className="font-bold font-mono text-zinc-900">
                    {selectedRider.battery}% Charged
                  </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-zinc-50 rounded-xl">
                  <span className="text-zinc-500">Partner Rating</span>
                  <span className="font-bold font-mono text-amber-600 flex items-center gap-1">
                    <Star className="w-3.5 h-3.5 fill-amber-400" />
                    {selectedRider.rating}
                  </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-zinc-50 rounded-xl">
                  <span className="text-zinc-500">Avg Speed SLA</span>
                  <span className="font-bold font-mono text-emerald-600">
                    {selectedRider.avgTime}
                  </span>
                </div>
              </div>

              <div className="pt-4 border-t border-zinc-200 flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  className="flex-1"
                  leftIcon={<Phone className="w-3.5 h-3.5" />}
                >
                  Call Rider
                </Button>
                <Button
                  variant="brand"
                  size="sm"
                  className="flex-1"
                  onClick={() => setSelectedRider(null)}
                >
                  Done
                </Button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
