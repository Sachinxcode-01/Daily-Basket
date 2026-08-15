/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function RiderPerformanceDashboardPage() {
  const [filter, setFilter] = useState<'All' | 'Active' | 'Idle'>('All');
  const [searchQuery, setSearchQuery] = useState('');

  const riders = [
    {
      id: '1',
      name: 'Alex Mercer',
      initials: 'AM',
      status: 'Active',
      vehicle: 'E-Bike',
      rating: 4.9,
      trips: 42,
      earnings: 124.50,
      avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCgRPF7eR92asoL0yA94GReDyoFH1dGjCgGp05dzRTUHgrwWH_h7W4FaVUzWaedm7bn4_kzLyGJlIMjP3Tg1eOLNW_EFwGGH9Q-0zFkUbQpIf_PQIYmuWqLtKXPBmynP4bM-adgN4iMM_BcLy8o7J_ID1uAi9S2KLHb6WgP4bLCGO2jelVeKnMC_PKCr7aZEe4SMYys0PIp7wSOATl69zd5zQNUVQYPI-DjnSRIkJvCGuoT7lXDjx81',
    },
    {
      id: '2',
      name: 'Sarah Chen',
      initials: 'SC',
      status: 'Idle',
      vehicle: 'Moped',
      rating: 4.8,
      trips: 38,
      earnings: 118.00,
      avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDtNvf-ma6_QsnAi841Idq60sZWf0OYNPz9GZIdJWQFXbRUvZKdL9dRiRFLXEGyZNuL7DUySwK3LmHt-vsM8e1omr4pkntG_tIrzlaHT9YZXp9vK2hwnIBd7L6j3KhjfJsO9h5bSBmtVQZW9rWuhviAPkW7C8NddA2ACrvrh7WE7egzfdxpMK3F4jq0QyBnwQVem68CyQYeOrsLW4Tt2k-pdTC12Wzo3Xz6AVg7BFajpb9tl3snndPX',
    },
    {
      id: '3',
      name: 'David Okafor',
      initials: 'DO',
      status: 'Active',
      vehicle: 'E-Bike',
      rating: 4.9,
      trips: 35,
      earnings: 105.00,
      avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDHn0LsO7Xc4pDU9n-NEtrYq3_sZXIkpBoCqGVJ8PjEECydNs8826b2zHVUn7OYfQMdyJ4WVWORNH7G79gMrmdxSZmOuArsFChWebeBY9u05-0TtdQBSuWmJuWLdeKZmcxv5cAMsdvbtauLvKTREfVVBJu-YeY6zIubaC7y-k6_cm6Ev5YhbCcibOmC9m-Wizu8WXiWl0WuIXl7fq_P4YO1Kolgksa51cKsxvvnOy5zcvq3BsEYD3qx',
    },
    {
      id: '4',
      name: 'Marcus Johnson',
      initials: 'MJ',
      status: 'Offline',
      vehicle: 'Bicycle',
      rating: 4.6,
      trips: 0,
      earnings: 0.00,
      avatar: null,
    },
  ];

  const filteredRiders = riders.filter((r) => {
    if (filter !== 'All' && r.status !== filter) return false;
    if (searchQuery && !r.name.toLowerCase().includes(searchQuery.toLowerCase())) return false;
    return true;
  });

  return (
    <div className="bg-[#f9f9fc] text-[#1a1c1e] font-sans flex min-h-screen">
      {/* SideNavBar */}
      <nav className="h-screen w-64 fixed left-0 top-0 z-50 bg-[#f3f3f6] border-r border-[#becab9]/20 flex flex-col p-4 gap-2">
        <div className="px-4 py-6 flex items-center gap-3 mb-4">
          <div className="w-10 h-10 rounded-lg bg-[#006b23] flex items-center justify-center text-white font-bold text-xl">
            DB
          </div>
          <div>
            <h1 className="font-bold text-[#006b23] text-base">Daily Basket</h1>
            <p className="text-[#3f4a3d] text-xs">Delivery Portal</p>
          </div>
        </div>

        <div className="flex-1 flex flex-col gap-1">
          <Link href="/" className="flex items-center gap-3 px-4 py-3 text-[#58605a] hover:bg-[#dce5dd]/50 rounded-lg transition-all text-sm font-medium">
            <span className="material-symbols-outlined text-[20px]">dashboard</span>
            Active Order
          </Link>
          <Link href="/performance" className="flex items-center gap-3 px-4 py-3 bg-[#078730] text-[#f7fff2] rounded-lg font-semibold transition-all text-sm">
            <span className="material-symbols-outlined text-[20px]">delivery_dining</span>
            Rider Performance
          </Link>
        </div>

        <button className="mt-auto flex items-center justify-center gap-2 bg-[#006b23] text-white px-4 py-3 rounded-lg font-semibold shadow-sm hover:bg-[#006e25] transition-colors">
          <span className="material-symbols-outlined text-[20px]">add</span>
          New Report
        </button>
      </nav>

      {/* Main Content */}
      <main className="flex-1 ml-64 flex flex-col min-h-screen">
        {/* TopNavBar */}
        <header className="w-full sticky top-0 z-40 bg-[#f9f9fc]/80 backdrop-blur-xl border-b border-[#becab9]/30 shadow-sm flex items-center justify-between px-6 py-3 text-sm">
          <div className="flex items-center gap-4">
            <div className="relative w-64">
              <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-[#3f4a3d]/60">search</span>
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search riders, orders..."
                className="w-full bg-[#dce5dd]/30 border-none rounded-full py-2 pl-10 pr-4 focus:ring-2 focus:ring-[#006b23] text-[#1a1c1e] text-xs placeholder:text-[#3f4a3d]/60 outline-none"
              />
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button className="p-2 text-[#3f4a3d] hover:bg-[#dce5dd]/50 rounded-full">
              <span className="material-symbols-outlined">notifications</span>
            </button>
            <button className="p-2 text-[#3f4a3d] hover:bg-[#dce5dd]/50 rounded-full">
              <span className="material-symbols-outlined">help</span>
            </button>
            <button className="p-2 text-[#3f4a3d] hover:bg-[#dce5dd]/50 rounded-full mr-2">
              <span className="material-symbols-outlined">settings</span>
            </button>
            <div className="h-8 w-px bg-[#becab9]/30 mx-2" />
            <div className="w-9 h-9 rounded-full bg-[#006b23] text-white flex items-center justify-center font-bold text-xs">
              RK
            </div>
          </div>
        </header>

        {/* Dashboard Canvas */}
        <div className="p-6 md:p-8 flex flex-col gap-8 flex-1">
          {/* Header */}
          <div className="flex justify-between items-end">
            <div>
              <h2 className="text-[32px] font-semibold text-[#1a1c1e] leading-tight">Rider Performance</h2>
              <p className="text-[#3f4a3d] mt-1 text-sm">Live metrics and fleet status for today.</p>
            </div>
            <div className="flex gap-3">
              <button className="px-4 py-2 border border-[#becab9] rounded-lg text-sm font-semibold text-[#3f4a3d] hover:bg-[#e2e2e5]/50 flex items-center gap-2">
                <span className="material-symbols-outlined text-[18px]">calendar_today</span>
                Today
              </button>
            </div>
          </div>

          {/* KPI Row */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* KPI Card 1 */}
            <div className="bg-white rounded-xl p-6 shadow-sm border border-[#becab9]/20 flex flex-col gap-4 relative overflow-hidden">
              <div className="flex justify-between items-start">
                <div className="p-2 bg-[#078730]/10 text-[#006b23] rounded-lg">
                  <span className="material-symbols-outlined">pedal_bike</span>
                </div>
                <span className="text-xs font-medium text-[#006b23] bg-[#078730]/10 px-2 py-1 rounded-md">+12% vs yesterday</span>
              </div>
              <div>
                <div className="text-[32px] font-semibold text-[#1a1c1e]">42 / 50</div>
                <div className="text-xs text-[#3f4a3d] mt-1 font-medium">Active Riders Online</div>
              </div>
            </div>

            {/* KPI Card 2 */}
            <div className="bg-white rounded-xl p-6 shadow-sm border border-[#becab9]/20 flex flex-col gap-4 relative overflow-hidden">
              <div className="flex justify-between items-start">
                <div className="p-2 bg-[#dce5dd] text-[#58605a] rounded-lg">
                  <span className="material-symbols-outlined">timer</span>
                </div>
                <span className="text-xs font-medium text-[#006b23] bg-[#078730]/10 px-2 py-1 rounded-md">-2m improvement</span>
              </div>
              <div>
                <div className="text-[32px] font-semibold text-[#1a1c1e]">14.5<span className="text-lg text-[#3f4a3d] ml-1">min</span></div>
                <div className="text-xs text-[#3f4a3d] mt-1 font-medium">Avg. Delivery Time</div>
              </div>
            </div>

            {/* KPI Card 3 */}
            <div className="bg-white rounded-xl p-6 shadow-sm border border-[#becab9]/20 flex flex-col gap-4 relative overflow-hidden">
              <div className="flex justify-between items-start">
                <div className="p-2 bg-[#e2e2e5] text-[#3f4a3d] rounded-lg">
                  <span className="material-symbols-outlined">local_mall</span>
                </div>
                <span className="text-xs font-medium text-[#006b23] bg-[#078730]/10 px-2 py-1 rounded-md">+184 today</span>
              </div>
              <div>
                <div className="text-[32px] font-semibold text-[#1a1c1e]">845</div>
                <div className="text-xs text-[#3f4a3d] mt-1 font-medium">Total Deliveries</div>
              </div>
            </div>
          </div>

          {/* Map & Top Performers */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Map View */}
            <div className="lg:col-span-2 bg-white rounded-xl shadow-sm border border-[#becab9]/20 overflow-hidden flex flex-col h-[400px]">
              <div className="px-6 py-4 border-b border-[#becab9]/20 flex justify-between items-center bg-white">
                <h3 className="font-semibold text-base text-[#1a1c1e]">Live Fleet Map</h3>
                <div className="flex items-center gap-4 text-xs font-medium text-[#3f4a3d]">
                  <div className="flex items-center gap-1.5">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#006b23]" /> Active
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#58605a]" /> Idle
                  </div>
                </div>
              </div>
              <div className="flex-1 relative bg-[#eeeef0] flex items-center justify-center">
                <div
                  className="absolute inset-0 bg-cover bg-center opacity-80"
                  style={{
                    backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuCVy8ai8nmFcvqN-MovdZTOMWL9mIWrzqn7NMKN0tMyhFcCWgCjHYJOtpuykg6jl6CtLeVIbS_8b7DSXaE-0hFeyZG4ZNtVAa2beh-xnvHfITnmVzQ-OlihW5WZx95kiamXYgt4TnI5LC9gFI61fSUyfssQIYvhusFv3_GZ6GchmOk7EmcmqJMfw-Xc5R-kr0pvwwFr2U76YFIt1WID9vIp-yglwV8q9XthzO0qJ1GHqj8NUPGn9gYa')",
                  }}
                />
                <div className="absolute top-[35%] left-[45%] w-8 h-8 bg-[#006b23] rounded-full border-2 border-white flex items-center justify-center text-white shadow-md">
                  <span className="material-symbols-outlined text-[16px]">pedal_bike</span>
                </div>
                <div className="absolute top-[50%] left-[25%] w-8 h-8 bg-[#006b23] rounded-full border-2 border-white flex items-center justify-center text-white shadow-md">
                  <span className="material-symbols-outlined text-[16px]">pedal_bike</span>
                </div>
                <div className="absolute top-[65%] left-[60%] w-10 h-10 bg-[#006b23]/20 rounded-full flex items-center justify-center animate-pulse">
                  <div className="w-6 h-6 bg-[#006b23] rounded-full border-2 border-white flex items-center justify-center text-white shadow-md">
                    <span className="text-xs font-bold">3</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Top Performers */}
            <div className="bg-white rounded-xl shadow-sm border border-[#becab9]/20 flex flex-col h-[400px]">
              <div className="px-6 py-4 border-b border-[#becab9]/20">
                <h3 className="font-semibold text-base text-[#1a1c1e]">Top Performers Today</h3>
              </div>
              <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-2">
                {riders.slice(0, 3).map((r) => (
                  <div key={r.id} className="flex items-center gap-4 p-3 rounded-lg hover:bg-[#f3f3f6] transition-colors cursor-pointer">
                    {r.avatar ? (
                      <img src={r.avatar} alt={r.name} className="w-10 h-10 rounded-full object-cover" />
                    ) : (
                      <div className="w-10 h-10 rounded-full bg-[#006b23]/10 text-[#006b23] flex items-center justify-center font-bold text-xs">
                        {r.initials}
                      </div>
                    )}
                    <div className="flex-1">
                      <h4 className="text-sm font-semibold text-[#1a1c1e]">{r.name}</h4>
                      <div className="text-xs text-[#3f4a3d] flex items-center gap-1">
                        <span className="text-[#f59e0b]">★</span> {r.rating} ({r.trips} trips)
                      </div>
                    </div>
                    <div className="text-right text-sm font-semibold text-[#006b23]">
                      ₹{r.earnings}
                    </div>
                  </div>
                ))}
                <button className="mt-auto w-full py-2 text-xs font-semibold text-[#006b23] hover:bg-[#078730]/10 rounded-md transition-colors">
                  View All Rankings
                </button>
              </div>
            </div>
          </div>

          {/* Fleet Directory Table */}
          <div className="bg-white rounded-xl shadow-sm border border-[#becab9]/20 overflow-hidden">
            <div className="px-6 py-5 border-b border-[#becab9]/20 flex justify-between items-center">
              <h3 className="font-semibold text-base text-[#1a1c1e]">Fleet Directory</h3>
              <div className="flex gap-2">
                {(['All', 'Active', 'Idle'] as const).map((tab) => (
                  <button
                    key={tab}
                    onClick={() => setFilter(tab)}
                    className={`px-3 py-1.5 text-xs font-semibold rounded-full transition-colors ${
                      filter === tab ? 'bg-[#078730] text-[#f7fff2]' : 'text-[#3f4a3d] hover:bg-[#e2e2e5]/50'
                    }`}
                  >
                    {tab}
                  </button>
                ))}
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm text-[#1a1c1e]">
                <thead className="bg-[#f3f3f6] text-xs uppercase text-[#3f4a3d] border-b border-[#becab9]/20">
                  <tr>
                    <th className="px-6 py-4 font-semibold">Rider</th>
                    <th className="px-6 py-4 font-semibold">Status</th>
                    <th className="px-6 py-4 font-semibold">Vehicle</th>
                    <th className="px-6 py-4 font-semibold">Rating</th>
                    <th className="px-6 py-4 font-semibold">Earnings Today</th>
                    <th className="px-6 py-4 font-semibold text-right">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-[#becab9]/10">
                  {filteredRiders.map((rider) => (
                    <tr key={rider.id} className="hover:bg-[#f3f3f6]/50 transition-colors">
                      <td className="px-6 py-4 flex items-center gap-3 font-semibold">
                        <div className="w-8 h-8 rounded-full bg-[#006b23]/10 flex items-center justify-center text-[#006b23] font-semibold text-xs">
                          {rider.initials}
                        </div>
                        <span>{rider.name}</span>
                      </td>
                      <td className="px-6 py-4">
                        <span
                          className={`inline-flex items-center gap-1.5 py-1 px-2.5 rounded-full text-xs font-medium ${
                            rider.status === 'Active'
                              ? 'bg-[#078730]/10 text-[#006b23]'
                              : rider.status === 'Idle'
                              ? 'bg-[#dce5dd] text-[#58605a]'
                              : 'bg-[#e2e2e5] text-[#3f4a3d]'
                          }`}
                        >
                          <span
                            className={`w-1.5 h-1.5 rounded-full ${
                              rider.status === 'Active' ? 'bg-[#006b23]' : rider.status === 'Idle' ? 'bg-[#58605a]' : 'bg-[#3f4a3d]'
                            }`}
                          />
                          {rider.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-[#3f4a3d]">{rider.vehicle}</td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-1">
                          <span className="text-[#f59e0b]">★</span>
                          <span className="font-medium">{rider.rating}</span>
                        </div>
                      </td>
                      <td className="px-6 py-4 font-medium">₹{rider.earnings}</td>
                      <td className="px-6 py-4 text-right">
                        <button className="text-[#006b23] hover:underline font-medium text-xs">Manage</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
