'use client';

import React from 'react';
import { Bike, ShieldCheck, Clock, Award, Star, Search, MapPin } from 'lucide-react';

export default function RiderPerformancePage() {
  const riders = [
    { id: 'RID-401', name: 'Ramesh Kumar', vehicle: 'EV Scooter #24', rating: '4.95', tripsToday: 24, avgTime: '8.2 mins', status: 'ON_TRIP', hub: 'Indiranagar Hub' },
    { id: 'RID-402', name: 'Sunil Verma', vehicle: 'EV Scooter #18', rating: '4.91', tripsToday: 21, avgTime: '8.8 mins', status: 'AVAILABLE', hub: 'Indiranagar Hub' },
    { id: 'RID-403', name: 'Deepak Singh', vehicle: 'EV Scooter #09', rating: '4.88', tripsToday: 19, avgTime: '9.4 mins', status: 'ON_TRIP', hub: 'Koramangala Hub' },
    { id: 'RID-404', name: 'Amit Patel', vehicle: 'EV Scooter #31', rating: '4.98', tripsToday: 26, avgTime: '7.9 mins', status: 'AVAILABLE', hub: 'HSR Layout Hub' },
  ];

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Rider Performance & Fleet</h1>
          <p className="text-sm text-[#3f4a3d]">Monitor active rider delivery speeds, safety compliance, and doorstep SLA metrics.</p>
        </div>
      </div>

      {/* Rider Fleet KPIs */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Active Fleet On Duty</span>
          <div className="text-3xl font-black text-[#1a1c1e]">48 riders</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            92% dark store coverage
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">On-Time Delivery SLA</span>
          <div className="text-3xl font-black text-[#006b23]">98.6%</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            Target: &gt; 98.0%
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Avg Doorstep Time</span>
          <div className="text-3xl font-black text-[#1a1c1e]">8.4 mins</div>
          <div className="flex items-center gap-1 text-xs text-[#3f4a3d]">
            From dark store exit to handoff
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Rider Satisfaction Rating</span>
          <div className="text-3xl font-black text-[#1a1c1e]">4.92 / 5.0</div>
          <div className="flex items-center gap-1 text-xs text-amber-600 font-bold">
            <Star className="w-3.5 h-3.5 fill-amber-400" /> Top Partner Score
          </div>
        </div>
      </div>

      {/* Fleet Roster Table */}
      <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-bold text-[#1a1c1e]">Rider Fleet Roster</h2>
          <div className="relative w-64">
            <Search className="w-4 h-4 text-[#3f4a3d] absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search rider ID or name..."
              className="w-full pl-9 pr-4 py-1.5 bg-[#f3f3f6] border border-transparent rounded-xl text-xs focus:outline-none focus:border-[#006b23] focus:bg-white transition"
            />
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-[#e2e2e5] text-[#3f4a3d] uppercase font-bold tracking-wider">
                <th className="pb-3">Rider ID</th>
                <th className="pb-3">Partner Name</th>
                <th className="pb-3">Vehicle Assigned</th>
                <th className="pb-3">Assigned Hub</th>
                <th className="pb-3">Trips Today</th>
                <th className="pb-3">Avg Trip Speed</th>
                <th className="pb-3">Rating</th>
                <th className="pb-3">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e2e2e5]">
              {riders.map((r) => (
                <tr key={r.id} className="hover:bg-[#f3f3f6] transition">
                  <td className="py-3.5 font-mono font-bold text-[#006b23]">{r.id}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{r.name}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{r.vehicle}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{r.hub}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{r.tripsToday} trips</td>
                  <td className="py-3.5 font-mono font-bold text-[#1a1c1e]">{r.avgTime}</td>
                  <td className="py-3.5 font-bold text-amber-600 flex items-center gap-1">
                    <Star className="w-3.5 h-3.5 fill-amber-400" /> {r.rating}
                  </td>
                  <td className="py-3.5">
                    <span
                      className={`px-2.5 py-1 rounded-full font-bold text-[10px] ${
                        r.status === 'ON_TRIP' ? 'bg-[#dce5dd] text-[#006b23]' : 'bg-[#f3f3f6] text-[#3f4a3d]'
                      }`}
                    >
                      {r.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
