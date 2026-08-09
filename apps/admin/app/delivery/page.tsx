'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Search,
  Truck,
  Bike,
  ClipboardList,
  Compass,
  Sparkles,
  GitBranch,
  MessageSquare,
  MapPin,
  Star,
  CheckCircle2,
  Edit,
  Clock,
  TrendingUp,
  Wallet,
  Grid,
  ShoppingBag,
  Package,
  Tag,
  BarChart3,
  Smartphone,
  LayoutGrid,
  Zap,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen 1: Delivery Management Dashboard (ID: e3716d1d69d5417aaa1ddfbb89b6a272)
// Screen 2: Delivery Partner Profile (ID: 752cc842c34a4783937ee46992667864)

export default function DeliveryManagementPage() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'rider'>('dashboard');
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [isAutoDispatchApplied, setIsAutoDispatchApplied] = useState(false);
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const dashboardData = {
    activeDeliveries: 42,
    availableRiders: 18,
    availableRidersDelta: '+2',
    waitingAssignment: 12,
    activeZones: 3,
    autoDispatchRecommendation: {
      title: 'Route Optimization',
      subtitle: 'Batching 4 orders for Rider John D. to save 12 mins.',
    },
    activeFleet: [
      {
        id: 'DB-RIDER-101',
        name: 'Michael T.',
        vehicle: 'E-Scooter',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        status: 'Online',
        statusColor: 'bg-emerald-500',
        rating: 4.9,
        doneToday: 14,
        earnedToday: '₹845.00',
        isAvailable: true,
      },
      {
        id: 'DB-RIDER-402',
        name: 'Sarah K.',
        vehicle: 'Busy (On Route)',
        avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
        status: 'Busy',
        statusColor: 'bg-orange-500',
        rating: 4.8,
        doneToday: 11,
        earnedToday: '₹620.00',
        isAvailable: false,
      },
    ],
  };

  const riderData = {
    id: 'DB-RIDER-402',
    name: 'Vikram Singh',
    status: 'Online',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    vehicleType: 'E-Scooter',
    vehicleReg: 'DL 4S AB 1234',
    todayEarnings: '₹840',
    todayTrend: '+12%',
    rating: '4.8',
    onTimeRate: '96%',
    lastUpdated: '1m ago',
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Stitch Header Title & Navigation Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">
              {activeTab === 'dashboard' ? 'Delivery Management' : 'Rider Profile'}
            </h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: {activeTab === 'dashboard' ? 'e3716d1d69d5417aaa1ddfbb89b6a272' : '752cc842c34a4783937ee46992667864'}
            </p>
          </div>
        </div>

        {/* Controls Row: Tab Switcher & View Mode Toggle */}
        <div className="flex flex-wrap items-center gap-3">
          <div className="flex items-center bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
            <button
              onClick={() => setActiveTab('dashboard')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                activeTab === 'dashboard' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
              }`}
            >
              Delivery Dashboard
            </button>
            <button
              onClick={() => setActiveTab('rider')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                activeTab === 'rider' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
              }`}
            >
              Rider Profile
            </button>
          </div>

          <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
            <button
              onClick={() => setViewMode('web')}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
              }`}
            >
              <LayoutGrid className="w-3.5 h-3.5" />
              <span>Web Dashboard</span>
            </button>
            <button
              onClick={() => setViewMode('mobile')}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
              }`}
            >
              <Smartphone className="w-3.5 h-3.5" />
              <span>Mobile Stitch View</span>
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      {viewMode === 'mobile' ? (
        /* Mobile Device Frame View simulating exact phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">
                {activeTab === 'dashboard' ? 'Delivery Management' : 'Rider Profile'}
              </span>
              <Search className="w-5 h-5 text-[#1e2923] cursor-pointer" />
            </div>

            {/* Scrollable Mobile Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              {activeTab === 'dashboard' ? (
                /* Delivery Dashboard Screen */
                <>
                  {/* Top Metrics Strip */}
                  <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-[#0284c7]">
                        <Truck className="w-4 h-4" />
                        <span className="w-2 h-2 rounded-full bg-[#0284c7]" />
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{dashboardData.activeDeliveries}</p>
                      <p className="text-[11px] text-[#64748b]">Active Deliveries</p>
                    </div>

                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-[#006837]">
                        <Bike className="w-4 h-4" />
                        <span className="text-[10px] font-bold text-[#15803d]">{dashboardData.availableRidersDelta}</span>
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{dashboardData.availableRiders}</p>
                      <p className="text-[11px] text-[#64748b]">Available Riders</p>
                    </div>

                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-[#ea580c]">
                        <ClipboardList className="w-4 h-4" />
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{dashboardData.waitingAssignment}</p>
                      <p className="text-[11px] text-[#64748b]">Waiting Assignment</p>
                    </div>
                  </div>

                  {/* Live Fleet Tracking Map Card */}
                  <div className="relative w-full h-48 rounded-3xl overflow-hidden border border-[#e2e8f0] shadow-sm">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img
                      src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800"
                      alt="Fleet Map"
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute bottom-3 left-3 right-3 bg-white/95 backdrop-blur p-3 rounded-2xl border border-[#e2e8f0] flex items-center justify-between shadow-md">
                      <div className="flex items-center gap-2">
                        <div className="p-2 bg-[#006837] text-white rounded-full">
                          <Compass className="w-4 h-4" />
                        </div>
                        <div>
                          <p className="font-bold text-xs text-[#1e2923]">Live Fleet Tracking</p>
                          <p className="text-[10px] text-[#64748b]">{dashboardData.activeZones} zones active</p>
                        </div>
                      </div>
                      <button className="px-3 py-1 border border-[#cbd5e1] text-xs font-bold rounded-xl text-[#1e2923]">
                        Expand
                      </button>
                    </div>
                  </div>

                  {/* Auto-Dispatch AI */}
                  <div className="bg-[#f1f5f9] p-4 rounded-3xl border border-[#e2e8f0] space-y-3">
                    <div className="flex items-center gap-2">
                      <Sparkles className="w-4 h-4 text-[#006837]" />
                      <h4 className="font-black text-sm text-[#1e2923]">Auto-Dispatch AI</h4>
                    </div>

                    <div className="bg-white p-3 rounded-2xl border border-[#e2e8f0] flex items-center justify-between">
                      <div className="flex items-center gap-2.5">
                        <GitBranch className="w-4 h-4 text-[#c2410c]" />
                        <div>
                          <p className="font-bold text-xs text-[#1e2923]">{dashboardData.autoDispatchRecommendation.title}</p>
                          <p className="text-[10px] text-[#64748b]">{dashboardData.autoDispatchRecommendation.subtitle}</p>
                        </div>
                      </div>
                      <button
                        onClick={() => setIsAutoDispatchApplied(!isAutoDispatchApplied)}
                        className="text-xs font-black text-[#006837] ml-2 shrink-0"
                      >
                        {isAutoDispatchApplied ? 'Applied' : 'Apply'}
                      </button>
                    </div>
                  </div>

                  {/* Current Priority Order */}
                  <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                    <h4 className="font-black text-sm text-[#1e2923]">Current Priority Order</h4>

                    <div className="grid grid-cols-4 text-center text-[10px] gap-1">
                      <div className="flex flex-col items-center gap-1">
                        <div className="w-9 h-9 rounded-full bg-[#006837] text-white flex items-center justify-center">
                          <Package className="w-4 h-4" />
                        </div>
                        <span className="font-bold text-[#64748b]">Packed</span>
                      </div>
                      <div className="flex flex-col items-center gap-1">
                        <div className="w-9 h-9 rounded-full bg-[#006837] text-white flex items-center justify-center">
                          <CheckCircle2 className="w-4 h-4" />
                        </div>
                        <span className="font-bold text-[#64748b]">Assigned</span>
                      </div>
                      <div className="flex flex-col items-center gap-1">
                        <div className="w-9 h-9 rounded-full bg-[#006837] text-white flex items-center justify-center ring-4 ring-[#dcfce7]">
                          <Bike className="w-4 h-4" />
                        </div>
                        <span className="font-black text-[#006837]">On Way</span>
                      </div>
                      <div className="flex flex-col items-center gap-1">
                        <div className="w-9 h-9 rounded-full bg-[#f1f5f9] text-[#94a3b8] flex items-center justify-center">
                          <CheckCircle2 className="w-4 h-4" />
                        </div>
                        <span className="font-bold text-[#cbd5e1]">Delivered</span>
                      </div>
                    </div>

                    <div className="flex gap-2">
                      <button
                        onClick={() => setActiveModal('Chat')}
                        className="flex-1 py-2.5 bg-[#f1f5f9] text-[#1e2923] text-xs font-bold rounded-2xl flex items-center justify-center gap-1.5"
                      >
                        <MessageSquare className="w-4 h-4" /> Chat
                      </button>
                      <button
                        onClick={() => setActiveModal('View Route')}
                        className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-2xl flex items-center justify-center gap-1.5"
                      >
                        <MapPin className="w-4 h-4" /> View Route
                      </button>
                    </div>
                  </div>

                  {/* Active Fleet */}
                  <div className="space-y-3">
                    <div className="flex justify-between items-center">
                      <h4 className="font-black text-sm text-[#1e2923]">Active Fleet</h4>
                      <button className="text-xs font-bold text-[#006837]">View All</button>
                    </div>

                    {dashboardData.activeFleet.map((r) => (
                      <div
                        key={r.id}
                        onClick={() => setActiveTab('rider')}
                        className="bg-white p-3.5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2 cursor-pointer hover:border-[#006837] transition"
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-3">
                            <div className="relative">
                              {/* eslint-disable-next-line @next/next/no-img-element */}
                              <img src={r.avatar} alt={r.name} className="w-11 h-11 rounded-2xl object-cover" />
                              <span className={`absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-white ${r.statusColor}`} />
                            </div>
                            <div>
                              <p className="font-bold text-xs text-[#1e2923]">{r.name}</p>
                              <p className="text-[11px] text-[#64748b]">{r.vehicle}</p>
                            </div>
                          </div>
                          <div className="flex items-center gap-1 text-xs font-bold text-[#1e2923]">
                            <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500" />
                            <span>{r.rating}</span>
                          </div>
                        </div>

                        {r.isAvailable && (
                          <div className="pt-2 border-t border-[#f1f5f9] flex justify-between items-center text-xs">
                            <div className="flex gap-4 text-[11px]">
                              <div><span className="text-[#64748b] block text-[10px]">Done</span><span className="font-bold text-[#1e2923]">{r.doneToday}</span></div>
                              <div><span className="text-[#64748b] block text-[10px]">Earned</span><span className="font-bold text-[#1e2923]">{r.earnedToday}</span></div>
                            </div>
                            <span className="px-3 py-1 bg-[#e2e8f0] text-[#15803d] font-bold rounded-xl text-[11px]">
                              ✓ Assign
                            </span>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                </>
              ) : (
                /* Rider Profile Screen */
                <div className="space-y-4">
                  {/* Identity Card */}
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm text-center space-y-3">
                    <div className="relative inline-block mx-auto">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={riderData.avatar} alt={riderData.name} className="w-24 h-24 rounded-3xl object-cover" />
                      <div className="absolute bottom-0 left-1/2 -translate-x-1/2 px-2.5 py-0.5 bg-[#006837] text-white text-[10px] font-bold rounded-full flex items-center gap-1 shadow-sm">
                        <CheckCircle2 className="w-3 h-3" /> Verified
                      </div>
                    </div>

                    <div>
                      <h2 className="text-xl font-black text-[#1e2923]">{riderData.name}</h2>
                      <p className="text-xs text-[#64748b] flex items-center justify-center gap-1.5 mt-1">
                        <span>{riderData.id}</span>
                        <span>•</span>
                        <Zap className="w-3.5 h-3.5 text-[#15803d]" />
                        <span className="font-bold text-[#15803d]">{riderData.status}</span>
                      </p>
                    </div>

                    <div className="bg-[#f1f5f9] p-3 rounded-2xl flex items-center justify-between text-xs">
                      <div className="flex items-center gap-2">
                        <div className="p-2 bg-[#e0f2fe] text-[#0284c7] rounded-full"><Bike className="w-4 h-4" /></div>
                        <div className="text-left">
                          <p className="font-bold text-[#1e2923]">{riderData.vehicleType}</p>
                          <p className="text-[10px] text-[#64748b] font-mono">{riderData.vehicleReg}</p>
                        </div>
                      </div>
                      <button className="font-bold text-[#006837]">Edit</button>
                    </div>
                  </div>

                  {/* Performance Metrics */}
                  <div className="grid grid-cols-2 gap-3">
                    <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-xs">
                        <Wallet className="w-4 h-4 text-[#15803d]" />
                        <span className="text-[#64748b] text-[10px]">Today</span>
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{riderData.todayEarnings}</p>
                      <p className="text-[10px] font-bold text-[#15803d] flex items-center gap-1"><TrendingUp className="w-3 h-3" /> {riderData.todayTrend}</p>
                    </div>

                    <div className="space-y-3">
                      <div className="bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm flex items-center justify-between text-xs">
                        <div className="flex items-center gap-1.5"><Star className="w-4 h-4 text-amber-500 fill-amber-500" /><span className="font-black text-[#1e2923]">{riderData.rating}</span></div>
                        <span className="text-[10px] text-[#64748b]">Rating</span>
                      </div>
                      <div className="bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm flex items-center justify-between text-xs">
                        <div className="flex items-center gap-1.5"><Clock className="w-4 h-4 text-[#006837]" /><span className="font-black text-[#1e2923]">{riderData.onTimeRate}</span></div>
                        <span className="text-[10px] text-[#64748b]">On-Time</span>
                      </div>
                    </div>
                  </div>

                  {/* Live Location Map */}
                  <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                    <div className="flex justify-between items-center">
                      <h4 className="font-black text-sm text-[#1e2923]">Live Location</h4>
                      <span className="px-2.5 py-0.5 bg-[#dce6fe] text-[#1e2923] text-[10px] font-bold rounded-lg">
                        Last updated: {riderData.lastUpdated}
                      </span>
                    </div>

                    <div className="relative w-full h-44 rounded-2xl overflow-hidden border border-[#e2e8f0]">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src="https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800" alt="Rider Map" className="w-full h-full object-cover" />
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dce6fe] text-[#1e2923] rounded-2xl"><Grid className="w-4 h-4 text-[#006837]" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><Tag className="w-4 h-4" /> Products</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="space-y-6">
          {activeTab === 'dashboard' ? (
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              {/* Left Column (Span 7) */}
              <div className="lg:col-span-7 space-y-6">
                {/* Top Metrics Cards */}
                <div className="grid grid-cols-3 gap-4">
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                    <div className="flex justify-between items-center text-[#0284c7]">
                      <Truck className="w-5 h-5" />
                      <span className="w-2.5 h-2.5 rounded-full bg-[#0284c7]" />
                    </div>
                    <p className="text-3xl font-black text-[#1e2923]">{dashboardData.activeDeliveries}</p>
                    <p className="text-xs text-[#64748b]">Active Deliveries</p>
                  </div>

                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                    <div className="flex justify-between items-center text-[#006837]">
                      <Bike className="w-5 h-5" />
                      <span className="text-xs font-bold text-[#15803d]">{dashboardData.availableRidersDelta}</span>
                    </div>
                    <p className="text-3xl font-black text-[#1e2923]">{dashboardData.availableRiders}</p>
                    <p className="text-xs text-[#64748b]">Available Riders</p>
                  </div>

                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                    <div className="flex justify-between items-center text-[#ea580c]">
                      <ClipboardList className="w-5 h-5" />
                    </div>
                    <p className="text-3xl font-black text-[#1e2923]">{dashboardData.waitingAssignment}</p>
                    <p className="text-xs text-[#64748b]">Waiting Assignment</p>
                  </div>
                </div>

                {/* Fleet Map */}
                <div className="relative w-full h-80 rounded-3xl overflow-hidden border border-[#e2e8f0] shadow-sm">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800" alt="Fleet Map" className="w-full h-full object-cover" />
                  <div className="absolute bottom-4 left-4 right-4 bg-white/95 backdrop-blur p-4 rounded-2xl border border-[#e2e8f0] flex items-center justify-between shadow-md">
                    <div className="flex items-center gap-3">
                      <div className="p-2.5 bg-[#006837] text-white rounded-full"><Compass className="w-5 h-5" /></div>
                      <div>
                        <p className="font-bold text-sm text-[#1e2923]">Live Fleet Tracking</p>
                        <p className="text-xs text-[#64748b]">{dashboardData.activeZones} zones active across city</p>
                      </div>
                    </div>
                    <button className="px-4 py-2 border border-[#cbd5e1] text-xs font-bold rounded-xl hover:bg-[#f8fafc]">
                      Full Screen Map
                    </button>
                  </div>
                </div>
              </div>

              {/* Right Column (Span 5) */}
              <div className="lg:col-span-5 space-y-6">
                {/* Auto Dispatch AI */}
                <div className="bg-[#f1f5f9] p-6 rounded-3xl border border-[#e2e8f0] space-y-4">
                  <div className="flex items-center gap-2">
                    <Sparkles className="w-5 h-5 text-[#006837]" />
                    <h3 className="font-black text-base text-[#1e2923]">Auto-Dispatch AI</h3>
                  </div>

                  <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <GitBranch className="w-5 h-5 text-[#c2410c]" />
                      <div>
                        <p className="font-bold text-xs text-[#1e2923]">{dashboardData.autoDispatchRecommendation.title}</p>
                        <p className="text-xs text-[#64748b]">{dashboardData.autoDispatchRecommendation.subtitle}</p>
                      </div>
                    </div>
                    <button
                      onClick={() => setIsAutoDispatchApplied(!isAutoDispatchApplied)}
                      className="px-3 py-1.5 bg-[#006837] text-white text-xs font-bold rounded-xl"
                    >
                      {isAutoDispatchApplied ? 'Applied' : 'Apply'}
                    </button>
                  </div>
                </div>

                {/* Active Fleet List */}
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                  <div className="flex justify-between items-center">
                    <h3 className="font-black text-base text-[#1e2923]">Active Fleet</h3>
                    <button className="text-xs font-bold text-[#006837]">View All</button>
                  </div>

                  <div className="space-y-3">
                    {dashboardData.activeFleet.map((r) => (
                      <div
                        key={r.id}
                        onClick={() => setActiveTab('rider')}
                        className="p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-center justify-between cursor-pointer hover:border-[#006837] transition"
                      >
                        <div className="flex items-center gap-3">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img src={r.avatar} alt={r.name} className="w-12 h-12 rounded-2xl object-cover" />
                          <div>
                            <p className="font-bold text-sm text-[#1e2923]">{r.name}</p>
                            <p className="text-xs text-[#64748b]">{r.vehicle}</p>
                          </div>
                        </div>

                        <div className="text-right">
                          <div className="flex items-center justify-end gap-1 text-xs font-bold text-[#1e2923]">
                            <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500" />
                            <span>{r.rating}</span>
                          </div>
                          <span className="text-xs font-bold text-[#15803d]">{r.status}</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          ) : (
            /* Web Rider Profile */
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              <div className="lg:col-span-5 space-y-6">
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm text-center space-y-4">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={riderData.avatar} alt={riderData.name} className="w-28 h-28 rounded-3xl object-cover mx-auto" />
                  <div>
                    <h2 className="text-2xl font-black text-[#1e2923]">{riderData.name}</h2>
                    <p className="text-xs text-[#64748b] mt-1">{riderData.id} • {riderData.status}</p>
                  </div>
                </div>
              </div>

              <div className="lg:col-span-7 space-y-6">
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                  <h3 className="font-black text-lg text-[#1e2923]">Live Location & Route</h3>
                  <div className="relative w-full h-64 rounded-2xl overflow-hidden border border-[#e2e8f0]">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src="https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800" alt="Rider Map" className="w-full h-full object-cover" />
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Action Modals */}
      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal} Modal</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for active delivery fleet.</p>
            <button
              onClick={() => setActiveModal(null)}
              className="w-full py-3 bg-[#006837] text-white font-bold text-xs rounded-2xl hover:bg-[#00522b]"
            >
              Close Modal
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
