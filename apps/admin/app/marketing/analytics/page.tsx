'use client';

import React from 'react';
import { ArrowLeft, TrendingUp, DollarSign } from 'lucide-react';

// Google Stitch Specs: Coupon Analytics - Daily Basket Admin
// ID: ad9213e4fcb64313875f1b6cbf1bf92d

export default function CouponAnalyticsPage() {
  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-black text-[#006837]">Coupon Analytics &amp; ROI</h1>
          <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: ad9213e4fcb64313875f1b6cbf1bf92d</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
          <div className="flex justify-between items-center text-[#64748b]">
            <span className="text-xs font-bold uppercase">Influenced Revenue</span>
            <DollarSign className="w-4 h-4" />
          </div>
          <p className="text-3xl font-black text-[#1e2923]">₹14.2L</p>
        </div>

        <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
          <div className="flex justify-between items-center text-[#15803d]">
            <span className="text-xs font-bold uppercase">Campaign ROI</span>
            <TrendingUp className="w-4 h-4" />
          </div>
          <p className="text-3xl font-black text-[#15803d]">8.4x</p>
        </div>
      </div>
    </div>
  );
}
