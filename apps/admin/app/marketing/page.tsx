'use client';

import React from 'react';
import { Megaphone, Plus, Tag, TrendingUp, Sparkles, Calendar, ArrowUpRight } from 'lucide-react';

export default function MarketingCampaignsPage() {
  const campaigns = [
    { id: 'CMP-501', title: '50% OFF Organic Fruit Flash Sale', code: 'FLASH50', discount: '50% OFF (Max ₹100)', conversion: '24.8%', totalRedeemed: '4,820', status: 'ACTIVE' },
    { id: 'CMP-502', title: 'Free Delivery Weekend', code: 'FREESHIP', discount: 'Free Delivery (Min ₹199)', conversion: '31.2%', totalRedeemed: '12,450', status: 'ACTIVE' },
    { id: 'CMP-503', title: 'Daily Basket Plus Referral Boost', code: 'REFPLUS', discount: '₹100 Wallet Credit', conversion: '18.5%', totalRedeemed: '2,140', status: 'SCHEDULED' },
  ];

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Marketing & Campaigns</h1>
          <p className="text-sm text-[#3f4a3d]">Manage promotional discount codes, push notifications, and hyper-local banner carousels.</p>
        </div>

        <div className="flex items-center gap-3">
          <button className="inline-flex items-center gap-2 px-4 py-2 bg-[#006b23] text-white rounded-xl text-xs font-bold hover:bg-[#078730] transition active:scale-95 shadow-sm">
            <Plus className="w-4 h-4" />
            <span>Create Campaign</span>
          </button>
        </div>
      </div>

      {/* Campaign Performance Table */}
      <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-bold text-[#1a1c1e]">Active Promo Codes & Campaigns</h2>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-[#e2e2e5] text-[#3f4a3d] uppercase font-bold tracking-wider">
                <th className="pb-3">Campaign ID</th>
                <th className="pb-3">Title</th>
                <th className="pb-3">Promo Code</th>
                <th className="pb-3">Discount Spec</th>
                <th className="pb-3">Redemptions</th>
                <th className="pb-3">Conversion Rate</th>
                <th className="pb-3">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e2e2e5]">
              {campaigns.map((c) => (
                <tr key={c.id} className="hover:bg-[#f3f3f6] transition">
                  <td className="py-3.5 font-mono font-bold text-[#006b23]">{c.id}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{c.title}</td>
                  <td className="py-3.5 font-mono font-bold text-[#1a1c1e] bg-[#f3f3f6] px-2 py-1 rounded-md inline-block my-2">
                    {c.code}
                  </td>
                  <td className="py-3.5 text-[#3f4a3d]">{c.discount}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{c.totalRedeemed} times</td>
                  <td className="py-3.5 font-bold text-emerald-700">{c.conversion}</td>
                  <td className="py-3.5">
                    <span className="px-2.5 py-1 bg-[#dce5dd] text-[#006b23] rounded-full font-bold text-[10px]">
                      {c.status}
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
