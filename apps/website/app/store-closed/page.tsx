'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';

/**
 * Store Closed / Unavailable Page
 * Google Stitch Screen ID: aa293ee6932a4eb1b5e289a822dd08be
 * Source of Truth: Daily Basket Quick-Commerce Suite
 */
export default function StoreClosedPage() {
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => {
      setIsRefreshing(false);
    }, 800);
  };

  return (
    <div className="bg-[#f9f9fc] text-[#1a1c1e] font-sans antialiased min-h-screen flex flex-col items-center justify-center pt-16">
      {/* TopAppBar */}
      <header className="fixed top-0 w-full z-50 bg-[#f9f9fc]/80 backdrop-blur-xl shadow-sm flex justify-between items-center px-4 sm:px-6 h-16 max-w-7xl">
        <button
          aria-label="Menu"
          className="text-[#006b23] hover:bg-[#f3f3f6] transition-colors active:scale-95 duration-200 p-2 rounded-full flex items-center justify-center"
        >
          <span className="material-symbols-outlined text-2xl">menu</span>
        </button>
        <Link href="/">
          <h1 className="font-['Outfit'] text-[24px] font-bold text-[#006b23] tracking-tight">
            Daily Basket
          </h1>
        </Link>
        <button
          aria-label="Cart"
          className="text-[#006b23] hover:bg-[#f3f3f6] transition-colors active:scale-95 duration-200 p-2 rounded-full flex items-center justify-center relative"
        >
          <span className="material-symbols-outlined text-2xl">shopping_cart</span>
          {/* Badge */}
          <span className="absolute top-1 right-1 w-2.5 h-2.5 bg-[#ba1a1a] rounded-full border-2 border-[#f9f9fc]"></span>
        </button>
      </header>

      {/* Main Content Canvas */}
      <main className="flex-grow flex flex-col items-center justify-center w-full max-w-[480px] px-4 py-8 mx-auto text-center">
        {/* Illustration */}
        <div className="mb-6 w-full max-w-[280px] aspect-square rounded-2xl overflow-hidden shadow-[0px_4px_12px_rgba(0,0,0,0.08)] bg-white relative">
          <Image
            src="/images/store_closed_basket_3d.png"
            alt="Closed basket illustration"
            width={280}
            height={280}
            className="w-full h-full object-cover"
            priority
          />
          <div className="absolute inset-0 bg-black/5 flex items-center justify-center backdrop-blur-[2px]">
            <span className="bg-[#f9f9fc]/90 text-[#1a1c1e] font-['Outfit'] font-semibold px-4 py-1.5 rounded-full text-sm shadow-sm backdrop-blur-md">
              Closed
            </span>
          </div>
        </div>

        {/* Typography */}
        <h2 className="font-['Outfit'] text-[32px] font-semibold text-[#1a1c1e] mb-2 leading-tight">
          We&apos;re currently resting
        </h2>
        <p className="font-['Inter'] text-[16px] text-[#3f4a3d] mb-6 px-4 leading-relaxed">
          Our local kirana store is currently closed. We&apos;ll be back online to deliver fresh groceries soon.
        </p>

        {/* Status Card (Material 3 Softness) */}
        <div className="w-full bg-white rounded-xl p-6 shadow-[0px_2px_8px_rgba(0,0,0,0.04)] mb-6 border border-[#becab9]/30 flex flex-col items-center">
          <div className="flex items-center gap-2 text-[#1a1c1e] mb-1">
            <span className="material-symbols-outlined text-[#006b23] text-xl">schedule</span>
            <span className="font-['Outfit'] font-semibold text-[18px]">Opens at 7:00 AM</span>
          </div>
          <p className="font-['Inter'] text-[14px] text-[#3f4a3d]">Tomorrow morning</p>
        </div>

        {/* Action Buttons */}
        <div className="w-full flex flex-col gap-3">
          <button
            onClick={handleRefresh}
            disabled={isRefreshing}
            className="w-full bg-[#006b23] hover:bg-[#006e25] text-white font-['Inter'] font-semibold text-[16px] py-3.5 px-6 rounded-xl shadow-sm transition-all active:scale-[0.98] flex items-center justify-center gap-2"
          >
            <span className={`material-symbols-outlined text-[20px] ${isRefreshing ? 'animate-spin' : ''}`}>
              refresh
            </span>
            {isRefreshing ? 'Checking Store...' : 'Refresh Status'}
          </button>
          <button
            className="w-full bg-transparent border-2 border-[#becab9] text-[#3f4a3d] hover:bg-[#f3f3f6] hover:text-[#1a1c1e] hover:border-[#6e7a6c] font-['Inter'] font-semibold text-[16px] py-3 px-6 rounded-xl transition-all active:scale-[0.98] flex items-center justify-center gap-2"
          >
            <span className="material-symbols-outlined text-[20px]">location_on</span>
            Change Location
          </button>
        </div>
      </main>
    </div>
  );
}
