'use client';

import React, { useState } from 'react';
import Link from 'next/link';

interface OfferCard {
  id: string;
  code: string;
  badge: string;
  discount: string;
  title: string;
  minOrder: string;
  expiresIn: string;
  bgGradient: string;
  accentColor: string;
  icon: string;
}

const OFFERS: OfferCard[] = [
  {
    id: 'fresh40',
    code: 'FRESH40',
    badge: 'SUPER SAVER',
    discount: 'FLAT 40% OFF',
    title: 'On Fresh Fruits & Organic Vegetables',
    minOrder: 'Min. Order ₹299',
    expiresIn: 'Ends in 4 hours',
    bgGradient: 'from-emerald-900 via-[#078730] to-[#2D9D43]',
    accentColor: '#4ADE80',
    icon: '🥑',
  },
  {
    id: 'bogo_dairy',
    code: 'BOGOCHEESE',
    badge: 'BUY 1 GET 1',
    discount: 'BOGO FREE',
    title: 'Farm Fresh Paneer & Gourmet Cheese',
    minOrder: 'Min. 2 units in basket',
    expiresIn: 'Valid today only',
    bgGradient: 'from-amber-900 via-amber-700 to-amber-600',
    accentColor: '#FDE047',
    icon: '🧀',
  },
  {
    id: 'super50',
    code: 'KIRANA50',
    badge: 'FESTIVAL SPECIAL',
    discount: 'UP TO ₹150 CASHBACK',
    title: 'Daily Essentials, Pulses & Atta Staples',
    minOrder: 'Min. Order ₹499',
    expiresIn: 'Limited slots',
    bgGradient: 'from-teal-950 via-teal-800 to-emerald-700',
    accentColor: '#2DD4BF',
    icon: '🌾',
  },
  {
    id: 'free_del',
    code: 'FIRSTFREE',
    badge: 'NEW CUSTOMER',
    discount: '100% FREE DELIVERY',
    title: 'Zero Delivery Fee on your 1st 3 Orders',
    minOrder: 'No minimum order',
    expiresIn: 'Auto-applied',
    bgGradient: 'from-indigo-950 via-slate-900 to-slate-800',
    accentColor: '#93C5FD',
    icon: '⚡',
  },
];

export default function WebOffersCarousel() {
  const [copiedCode, setCopiedCode] = useState<string | null>(null);

  const handleCopy = (code: string) => {
    navigator.clipboard?.writeText(code);
    setCopiedCode(code);
    setTimeout(() => setCopiedCode(null), 2500);
  };

  return (
    <section className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 border border-emerald-200 text-emerald-800 text-[11px] font-bold uppercase tracking-wider mb-1">
            <span>🏷️</span>
            <span>EXCLUSIVE BANK & STORE PROMOS</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface">
            Best Offers & Coupons
          </h2>
        </div>
        <Link
          href="/coupons"
          className="text-xs sm:text-sm text-primary hover:text-emerald-700 font-bold flex items-center gap-1 transition-colors"
        >
          <span>View All 12 Coupons</span>
          <span>→</span>
        </Link>
      </div>

      {/* Horizontal Carousel */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {OFFERS.map((offer) => {
          const isCopied = copiedCode === offer.code;
          return (
            <div
              key={offer.id}
              className={`bg-gradient-to-br ${offer.bgGradient} text-white rounded-3xl p-5 shadow-level-1 relative overflow-hidden flex flex-col justify-between border border-white/10 group hover:-translate-y-1 transition-all duration-300 hover:shadow-level-2 min-h-[190px]`}
            >
              {/* Background ambient badge */}
              <span className="absolute -right-3 -bottom-3 text-7xl opacity-15 select-none pointer-events-none group-hover:scale-110 transition-transform">
                {offer.icon}
              </span>

              {/* Header */}
              <div>
                <div className="flex items-center justify-between gap-2">
                  <span
                    className="text-[10px] font-extrabold uppercase tracking-wider px-2.5 py-0.5 rounded-full backdrop-blur-md bg-white/20 border border-white/20"
                    style={{ color: offer.accentColor }}
                  >
                    {offer.badge}
                  </span>
                  <span className="text-[10px] text-white/70 font-medium">{offer.expiresIn}</span>
                </div>

                <div className="text-xl font-extrabold font-outfit mt-3 leading-tight tracking-tight">
                  {offer.discount}
                </div>
                <p className="text-xs text-white/85 font-inter mt-1 line-clamp-2 leading-relaxed">
                  {offer.title}
                </p>
              </div>

              {/* Bottom Strip: Perforated Code Pill + Copy */}
              <div className="pt-4 border-t border-white/15 flex items-center justify-between gap-2">
                <div className="flex flex-col">
                  <span className="text-[9px] text-white/60 uppercase font-semibold">Coupon Code</span>
                  <span className="font-mono text-xs font-bold tracking-wider text-white">
                    {offer.code}
                  </span>
                </div>

                <button
                  onClick={() => handleCopy(offer.code)}
                  className={`text-xs font-bold px-3.5 py-1.5 rounded-full transition-all duration-200 active:scale-95 shadow-sm ${
                    isCopied
                      ? 'bg-white text-emerald-900 font-extrabold'
                      : 'bg-white/20 hover:bg-white/30 text-white border border-white/25 backdrop-blur-md'
                  }`}
                >
                  {isCopied ? '✓ Copied' : 'Apply'}
                </button>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}
