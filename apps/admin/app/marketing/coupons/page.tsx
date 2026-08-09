'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Search,
  Ticket,
  CheckCircle2,
  TrendingUp,
  PiggyBank,
  Plus,
  BarChart2,
  LayoutGrid,
  Smartphone,
  Grid,
  ShoppingBag,
  Store,
  Tag,
} from 'lucide-react';

// Google Stitch Specs: Coupon Management Dashboard
// ID: ee9fc342aa164f7daa279a40d7a95b32

export default function CouponDashboardPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const couponsData = {
    totalCoupons: 48,
    activeCoupons: 32,
    redemptionsToday: '1,240',
    totalSavings: '₹1.85L',
    coupons: [
      {
        id: 'c-1',
        code: 'WELCOME50',
        title: '50% OFF up to ₹100',
        minOrder: 'Min. order ₹199',
        status: 'ACTIVE',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        redemptions: 1420,
        expires: 'Expires 31 Dec',
      },
      {
        id: 'c-2',
        code: 'FRESH20',
        title: '₹20 Flat OFF on Fresh Produce',
        minOrder: 'Min. order ₹149',
        status: 'ACTIVE',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        redemptions: 850,
        expires: 'Expires 15 Nov',
      },
      {
        id: 'c-3',
        code: 'FESTIVE100',
        title: '₹100 Mega Savings',
        minOrder: 'Min. order ₹500',
        status: 'SCHEDULED',
        statusBg: 'bg-amber-100 text-[#c2410c]',
        redemptions: 0,
        expires: 'Starts 1 Nov',
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Header Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Coupon Management</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">Google Stitch Screen ID: ee9fc342aa164f7daa279a40d7a95b32</p>
          </div>
        </div>

        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('web')}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Web Dashboard</span>
          </button>
          <button
            onClick={() => setViewMode('mobile')}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Mobile Stitch View</span>
          </button>
        </div>
      </div>

      {/* Main Content */}
      {viewMode === 'mobile' ? (
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Marketing &amp; Offers</span>
              <BarChart2 className="w-5 h-5 text-[#1e2923] cursor-pointer" />
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              <h2 className="text-xl font-black text-[#1e2923]">Coupon Management</h2>

              {/* Metrics Strip */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#006837]">
                    <span className="font-bold text-[11px] text-[#64748b]">Total Coupons</span>
                    <Ticket className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{couponsData.totalCoupons}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#15803d]">
                    <span className="font-bold text-[11px] text-[#64748b]">Active</span>
                    <CheckCircle2 className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{couponsData.activeCoupons}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#0284c7]">
                    <span className="font-bold text-[11px] text-[#64748b]">Redemptions Today</span>
                    <TrendingUp className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{couponsData.redemptionsToday}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#c2410c]">
                    <span className="font-bold text-[11px] text-[#64748b]">Total Savings</span>
                    <PiggyBank className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{couponsData.totalSavings}</p>
                </div>
              </div>

              {/* Search Bar */}
              <div className="bg-[#f1f5f9] px-3.5 py-2.5 rounded-2xl border border-[#e2e8f0] flex items-center gap-2 text-xs">
                <Search className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  placeholder="Search code, campaign, offer..."
                  className="bg-transparent border-none outline-none w-full text-[#1e2923]"
                />
              </div>

              {/* Filter Chips */}
              <div className="flex gap-2 text-xs overflow-x-auto no-scrollbar">
                {['All', 'Active', 'Scheduled', 'Expired', 'Draft'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedFilter(f)}
                    className={`px-4 py-1.5 rounded-full font-bold transition shrink-0 ${
                      selectedFilter === f
                        ? 'bg-[#006837] text-white shadow-sm'
                        : 'bg-white text-[#64748b] border border-[#e2e8f0]'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>

              {/* Active Coupons List */}
              <div className="space-y-3">
                <h4 className="font-black text-sm text-[#1e2923]">Active Coupons</h4>

                {couponsData.coupons.map((cpn) => (
                  <div
                    key={cpn.id}
                    onClick={() => setActiveModal(`Details for ${cpn.code}`)}
                    className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3 cursor-pointer hover:border-[#006837]"
                  >
                    <div className="flex justify-between items-center">
                      <span className="px-3 py-1 bg-[#f1f5f9] border border-[#cbd5e1] rounded-xl text-sm font-black font-mono text-[#1e2923]">
                        {cpn.code}
                      </span>
                      <span className={`px-2.5 py-0.5 text-[10px] font-bold rounded-md ${cpn.statusBg}`}>
                        {cpn.status}
                      </span>
                    </div>

                    <div>
                      <h5 className="font-bold text-sm text-[#1e2923]">{cpn.title}</h5>
                      <p className="text-xs text-[#64748b] mt-0.5">{cpn.minOrder}</p>
                    </div>

                    <div className="pt-2 border-t border-[#f1f5f9] flex justify-between items-center text-xs">
                      <span className="font-bold text-[#1e2923]">🔄 {cpn.redemptions} redemptions</span>
                      <span className="text-[#64748b] text-[11px]">{cpn.expires}</span>
                    </div>
                  </div>
                ))}
              </div>

              <button
                onClick={() => setActiveModal('Create New Coupon')}
                className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
              >
                <Plus className="w-6 h-6" />
              </button>
            </div>

            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#006837] text-white rounded-2xl"><Tag className="w-4 h-4" /> Offers</div>
              <div className="flex flex-col items-center gap-0.5"><Store className="w-4 h-4" /> Suppliers</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web View */
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#64748b] font-bold uppercase">Total Coupons</span>
              <p className="text-3xl font-black text-[#1e2923]">{couponsData.totalCoupons}</p>
            </div>
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#15803d] font-bold uppercase">Active</span>
              <p className="text-3xl font-black text-[#15803d]">{couponsData.activeCoupons}</p>
            </div>
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#0284c7] font-bold uppercase">Redemptions Today</span>
              <p className="text-3xl font-black text-[#1e2923]">{couponsData.redemptionsToday}</p>
            </div>
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#c2410c] font-bold uppercase">Total Savings Given</span>
              <p className="text-3xl font-black text-[#c2410c]">{couponsData.totalSavings}</p>
            </div>
          </div>

          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
            <h3 className="font-black text-lg text-[#1e2923]">Active Coupons</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {couponsData.coupons.map((cpn) => (
                <div key={cpn.id} className="p-5 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] space-y-2">
                  <div className="flex justify-between items-center">
                    <span className="font-black font-mono text-lg text-[#006837]">{cpn.code}</span>
                    <span className={`px-3 py-1 text-xs font-bold rounded-full ${cpn.statusBg}`}>{cpn.status}</span>
                  </div>
                  <p className="font-bold text-sm text-[#1e2923]">{cpn.title}</p>
                  <p className="text-xs text-[#64748b]">{cpn.minOrder} • {cpn.redemptions} redemptions</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal}</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for Marketing module.</p>
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
