'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, ShoppingBasket, Sparkles } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';

export default function EmptyBasketPage() {
  return (
    <div className="relative min-h-screen flex flex-col justify-between bg-slate-50 font-sans">
      <OrganicShaderBackground />

      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="relative z-10 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl font-extrabold text-slate-900 font-outfit">
              Your Shopping Basket
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="relative z-10 flex-1 flex flex-col items-center justify-center px-4 sm:px-8 py-10 max-w-md mx-auto w-full text-center">
        
        <div className="w-full bg-white border border-slate-100 rounded-[28px] p-8 sm:p-10 shadow-xl shadow-slate-200/50 space-y-6">
          
          {/* Empty Basket Illustration Badge */}
          <div className="w-24 h-24 rounded-full bg-emerald-50 text-[#006b23] flex items-center justify-center mx-auto shadow-inner border border-emerald-100">
            <ShoppingBasket className="w-12 h-12 stroke-[1.8]" />
          </div>

          <div className="space-y-2">
            <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit">
              Your Basket is Empty
            </h2>
            <p className="text-slate-600 text-sm font-inter leading-relaxed">
              Looks like you haven't added any fresh groceries to your basket yet.
            </p>
          </div>

          <Link
            href="/"
            className="w-full py-4 bg-[#006b23] hover:bg-[#00531a] active:scale-[0.98] text-white rounded-full font-bold text-base font-outfit shadow-md shadow-[#006b23]/20 flex items-center justify-center gap-2 transition duration-200"
          >
            <Sparkles className="w-5 h-5" />
            <span>Start Shopping</span>
          </Link>

        </div>

      </main>

      <div className="h-6" />
    </div>
  );
}
