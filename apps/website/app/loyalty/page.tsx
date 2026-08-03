'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Gift, Share2, Copy, CheckCircle2, Award, Zap, ChevronRight } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function LoyaltyPage() {
  const [copied, setCopied] = useState(false);
  const referralCode = 'DAILY-ANANYA-2026';

  const copyCode = () => {
    navigator.clipboard.writeText(referralCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-20 max-w-4xl mx-auto">
      {/* Top Header */}
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Store</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white">Daily Basket Rewards & Referrals</h1>
        <div className="w-6" />
      </div>

      <div className="space-y-6">
        {/* Loyalty Tier Header Card */}
        <div className="bg-gradient-to-r from-amber-600 via-amber-700 to-amber-900 border border-amber-500/40 p-6 rounded-3xl shadow-xl flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 text-amber-200 font-bold text-xs uppercase tracking-wider mb-1">
              <Award className="w-4 h-4" />
              <span>GOLD TIER MEMBER</span>
            </div>
            <h2 className="text-3xl font-black text-white">480 Points</h2>
            <p className="text-xs text-amber-100/90 mt-1">₹48 Discount Available • 20 pts to Platinum Tier</p>
          </div>
          <div className="w-16 h-16 rounded-2xl bg-amber-500/20 border border-amber-400/40 flex items-center justify-center text-amber-300">
            <Gift className="w-8 h-8" />
          </div>
        </div>

        {/* Refer & Earn Section */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-6 rounded-3xl space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-base font-bold text-white">Invite Friends, Get ₹100 Cashback</h3>
              <p className="text-xs text-slate-400 mt-0.5">Give ₹100 on first 10-min order, get ₹100 when they order.</p>
            </div>
            <span className="text-2xl font-black text-emerald-400">₹100</span>
          </div>

          <div className="p-3 bg-slate-900 border border-slate-700 rounded-2xl flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-400">Your Referral Code:</span>
              <span className="text-sm font-mono font-extrabold text-emerald-400">{referralCode}</span>
            </div>
            <button
              onClick={copyCode}
              className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl flex items-center gap-1.5 transition"
            >
              {copied ? <CheckCircle2 className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
              <span>{copied ? 'Copied' : 'Copy'}</span>
            </button>
          </div>
        </div>

        {/* Tier Perks Breakdown */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-6 rounded-3xl space-y-3">
          <h3 className="text-sm font-bold text-white mb-2">Gold Tier Member Benefits</h3>
          <div className="space-y-2 text-xs text-slate-300">
            <div className="flex items-center gap-2">
              <Zap className="w-4 h-4 text-emerald-400" />
              <span>Free 10-Minute Express Delivery on orders above ₹99</span>
            </div>
            <div className="flex items-center gap-2">
              <Gift className="w-4 h-4 text-amber-400" />
              <span>2x Rewards Points on Fresh Hydroponic Produce</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
