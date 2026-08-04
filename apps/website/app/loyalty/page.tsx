'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Crown, Zap, ShieldCheck, Gift, Check, Sparkles } from 'lucide-react';

export default function LoyaltyPage() {
  const [selectedPlan, setSelectedPlan] = useState<'monthly' | 'annual'>('annual');

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl font-extrabold text-slate-900 font-outfit">
              Daily Basket Plus
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-8">
        
        {/* Golden VIP Hero Card */}
        <div className="bg-gradient-to-r from-amber-500 via-amber-600 to-amber-700 text-white rounded-3xl p-6 sm:p-10 shadow-xl relative overflow-hidden space-y-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Crown className="w-8 h-8 text-amber-200" />
              <span className="font-outfit font-extrabold text-xl tracking-tight">
                Daily Basket VIP
              </span>
            </div>
            <span className="px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider">
              Plus Membership
            </span>
          </div>

          <div className="space-y-2 max-w-lg">
            <h2 className="text-3xl sm:text-4xl font-extrabold font-outfit leading-tight">
              Zero Delivery Fee on All Orders
            </h2>
            <p className="text-amber-100 text-sm sm:text-base font-inter">
              Enjoy unlimited free 10-minute deliveries, VIP customer support, and exclusive 5% wallet cashback.
            </p>
          </div>
        </div>

        {/* Benefits Breakdown */}
        <div className="space-y-4">
          <h3 className="text-lg font-bold text-slate-900 font-outfit">
            Plus Membership Perks
          </h3>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            {[
              {
                icon: Zap,
                title: 'Free 10-Min Delivery',
                desc: 'Zero delivery fee on all orders above ₹99',
              },
              {
                icon: Gift,
                title: '5% Extra Cashback',
                desc: 'Earn cashback on every order automatically',
              },
              {
                icon: ShieldCheck,
                title: 'VIP Support',
                desc: 'Priority live chat resolution with zero wait time',
              },
            ].map((perk) => (
              <div
                key={perk.title}
                className="bg-white rounded-2xl p-5 border border-slate-100 shadow-sm flex flex-col gap-3"
              >
                <div className="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center">
                  <perk.icon className="w-6 h-6" />
                </div>
                <div>
                  <h4 className="font-outfit font-bold text-base text-slate-900">
                    {perk.title}
                  </h4>
                  <p className="text-xs text-slate-500 font-inter mt-1 leading-relaxed">
                    {perk.desc}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Subscription Plan Selector */}
        <div className="bg-white rounded-3xl p-6 sm:p-8 border border-slate-100 shadow-sm space-y-6">
          <h3 className="text-lg font-bold text-slate-900 font-outfit">
            Choose Your Plan
          </h3>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {/* Annual Plan */}
            <div
              onClick={() => setSelectedPlan('annual')}
              className={`p-5 rounded-2xl border-2 cursor-pointer transition relative flex flex-col justify-between ${
                selectedPlan === 'annual'
                  ? 'border-[#006b23] bg-emerald-50/50'
                  : 'border-slate-200 bg-white hover:border-slate-300'
              }`}
            >
              <span className="absolute -top-3 right-4 bg-[#006b23] text-white text-[10px] font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wider">
                Best Value (Save 60%)
              </span>

              <div>
                <h4 className="font-outfit font-bold text-lg text-slate-900">Annual Pass</h4>
                <p className="text-xs text-slate-500 font-inter mt-0.5">Billed ₹499 every 12 months</p>
              </div>

              <div className="mt-4 pt-3 border-t border-slate-200/60 flex items-baseline justify-between">
                <span className="text-2xl font-extrabold font-outfit text-slate-900">₹499/yr</span>
                <span className="text-xs font-bold text-[#006b23]">~₹41 / month</span>
              </div>
            </div>

            {/* Monthly Plan */}
            <div
              onClick={() => setSelectedPlan('monthly')}
              className={`p-5 rounded-2xl border-2 cursor-pointer transition flex flex-col justify-between ${
                selectedPlan === 'monthly'
                  ? 'border-[#006b23] bg-emerald-50/50'
                  : 'border-slate-200 bg-white hover:border-slate-300'
              }`}
            >
              <div>
                <h4 className="font-outfit font-bold text-lg text-slate-900">Monthly Pass</h4>
                <p className="text-xs text-slate-500 font-inter mt-0.5">Billed ₹99 every month</p>
              </div>

              <div className="mt-4 pt-3 border-t border-slate-200/60 flex items-baseline justify-between">
                <span className="text-2xl font-extrabold font-outfit text-slate-900">₹99/mo</span>
                <span className="text-xs text-slate-500 font-medium">Flexible</span>
              </div>
            </div>
          </div>

          <button className="w-full py-4 bg-[#006b23] hover:bg-[#00531a] active:scale-[0.98] text-white rounded-full font-bold text-base font-outfit shadow-md shadow-[#006b23]/20 transition flex items-center justify-center gap-2">
            <Sparkles className="w-5 h-5" />
            <span>Join Daily Basket Plus Now</span>
          </button>
        </div>

      </main>
    </div>
  );
}
