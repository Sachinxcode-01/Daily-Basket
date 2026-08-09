'use client';

import React from 'react';
import { ArrowLeft } from 'lucide-react';

// Google Stitch Specs: Campaign & Offers - Daily Basket Admin
// ID: 2dda772b4d834ef69b76b0da69bbc596

export default function CampaignsPage() {
  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-black text-[#006837]">Campaigns &amp; Banners</h1>
          <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: 2dda772b4d834ef69b76b0da69bbc596</p>
        </div>
      </div>

      <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
        <h3 className="font-black text-lg text-[#1e2923]">Diwali Mega Sale Banner</h3>
        <p className="text-xs text-[#64748b]">Active • 1 Nov - 10 Nov</p>
      </div>
    </div>
  );
}
