// Google Stitch Screen ID: 7e277a60bf7649c08084b509267db422
// Title: Brand Reveal & Loading Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React from 'react';
import { ShoppingBasket, Zap } from 'lucide-react';

export default function BrandRevealPage() {
  return (
    <div className="min-h-screen bg-[#006B23] text-white flex flex-col items-center justify-center relative overflow-hidden">
      {/* Background Radial Glow */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-[#078730] via-[#006B23] to-[#1A1C1E] opacity-90" />

      <div className="relative z-10 flex flex-col items-center text-center animate-fade-in">
        <div className="w-28 h-28 bg-white rounded-full flex items-center justify-center shadow-[0_0_50px_rgba(140,250,147,0.6)] mb-6 animate-pulse">
          <ShoppingBasket className="w-14 h-14 text-[#006B23]" />
        </div>

        <h1 className="text-4xl md:text-5xl font-black font-outfit tracking-wider text-white mb-3">
          DAILY BASKET
        </h1>

        <div className="inline-flex items-center gap-2 bg-[#8CFA93] text-[#006B23] font-bold font-outfit text-sm px-4 py-1.5 rounded-full mb-10 shadow-lg">
          <Zap className="w-4 h-4 fill-current" />
          <span>10-MINUTE EXPRESS DELIVERY</span>
        </div>

        <div className="w-10 h-10 border-4 border-[#8CFA93] border-t-transparent rounded-full animate-spin" />
      </div>
    </div>
  );
}
