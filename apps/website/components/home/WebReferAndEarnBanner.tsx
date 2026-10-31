'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function WebReferAndEarnBanner() {
  const [copied, setCopied] = useState(false);
  const referralCode = 'DAILYBASKET200';

  const handleCopy = () => {
    navigator.clipboard?.writeText(referralCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2500);
  };

  return (
    <section className="bg-gradient-to-r from-emerald-900 via-[#078730] to-teal-900 text-white rounded-3xl p-6 sm:p-8 shadow-level-2 border border-emerald-500/30 relative overflow-hidden flex flex-col md:flex-row items-center justify-between gap-6">
      {/* Background radial accent */}
      <div className="absolute -top-12 -right-12 w-48 h-48 bg-white/10 rounded-full blur-2xl pointer-events-none" />

      <div className="space-y-2 text-center md:text-left z-10">
        <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/20 text-emerald-100 text-[10px] font-extrabold uppercase tracking-widest backdrop-blur-md border border-white/20">
          🎁 REFERRAL REWARDS PROGRAM
        </span>
        <h3 className="text-2xl sm:text-3xl font-extrabold font-outfit text-white">
          Refer Friends & Get <span className="text-amber-300">₹200 Cashback</span>
        </h3>
        <p className="text-xs sm:text-sm text-emerald-100/90 font-inter max-w-xl">
          Share your love for farm-fresh groceries. Your friend gets 30% OFF their first basket, and you receive ₹200 Daily Basket wallet cashback on delivery!
        </p>
      </div>

      <div className="flex flex-col sm:flex-row items-center gap-3 z-10 w-full md:w-auto">
        <div className="flex items-center justify-between bg-black/30 backdrop-blur-md px-4 py-2.5 rounded-2xl border border-white/25 w-full sm:w-auto gap-3">
          <div className="flex flex-col text-left">
            <span className="text-[9px] uppercase tracking-wider text-emerald-200/80 font-bold">Your Referral Code</span>
            <span className="font-mono text-sm font-extrabold tracking-widest text-amber-300">
              {referralCode}
            </span>
          </div>
          <button
            onClick={handleCopy}
            className="bg-white/20 hover:bg-white/30 text-white text-xs font-bold px-3 py-1.5 rounded-xl border border-white/30 active:scale-95 transition-all"
          >
            {copied ? '✓ Copied' : 'Copy'}
          </button>
        </div>

        <Link
          href="/referral"
          className="bg-white text-[#078730] hover:bg-emerald-50 font-extrabold text-xs sm:text-sm px-6 py-3 rounded-full transition-all shadow-lg active:scale-95 whitespace-nowrap text-center w-full sm:w-auto"
        >
          Invite Friends →
        </Link>
      </div>
    </section>
  );
}
