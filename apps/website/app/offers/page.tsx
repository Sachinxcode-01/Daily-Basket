'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  Tag,
  Copy,
  Check,
  Sparkles,
  ShoppingBag,
  Percent,
  Clock,
  Zap,
  ArrowRight,
  ShieldCheck,
  Gift,
  CreditCard,
} from 'lucide-react';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';

interface CouponItem {
  code: string;
  title: string;
  description: string;
  discount: string;
  minOrder: number;
  maxDiscount?: number;
  validTill: string;
  category: 'all' | 'instant' | 'upi' | 'new-user';
  badge?: string;
  bgColor: string;
}

export default function OffersPage() {
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [copiedCode, setCopiedCode] = useState<string | null>(null);

  const coupons: CouponItem[] = [
    {
      code: 'WELCOME100',
      title: 'First Order Special',
      description: 'Flat ₹100 OFF on your first 10-minute grocery delivery order above ₹299.',
      discount: '₹100 FLAT OFF',
      minOrder: 299,
      validTill: 'Valid on first order',
      category: 'new-user',
      badge: 'NEW USER',
      bgColor: 'from-emerald-600 to-teal-700',
    },
    {
      code: 'FREESHIP',
      title: 'Free 10-Min Delivery',
      description: 'Zero delivery fee on all fresh groceries & dairy items above ₹149.',
      discount: '100% FREE DELIVERY',
      minOrder: 149,
      validTill: 'Valid all week',
      category: 'instant',
      badge: 'TRENDING',
      bgColor: 'from-amber-500 to-orange-600',
    },
    {
      code: 'DAILY50',
      title: 'Fresh Veggies & Fruits Fest',
      description: 'Get ₹50 instant discount on farm fresh vegetables, leafy greens, and seasonal fruits.',
      discount: '₹50 INSTANT OFF',
      minOrder: 199,
      validTill: 'Expires in 3 days',
      category: 'instant',
      badge: 'FARM FRESH',
      bgColor: 'from-green-600 to-emerald-800',
    },
    {
      code: 'UPIEXTRA10',
      title: 'UPI & Instant Wallet Offer',
      description: '10% instant discount when paying via Google Pay, PhonePe, Paytm, or DB Wallet.',
      discount: '10% CASHBACK',
      minOrder: 249,
      maxDiscount: 75,
      validTill: 'Valid till month end',
      category: 'upi',
      badge: 'PAYMENT DEAL',
      bgColor: 'from-blue-600 to-indigo-700',
    },
    {
      code: 'ORGANIC25',
      title: 'Organic Certified Essentials',
      description: 'Save 25% on certified organic cold-pressed oils, A2 ghee, and whole grain flours.',
      discount: '25% OFF',
      minOrder: 399,
      maxDiscount: 150,
      validTill: 'Limited stock coupon',
      category: 'instant',
      badge: 'ORGANIC',
      bgColor: 'from-teal-600 to-emerald-800',
    },
    {
      code: 'NIGHTOWL',
      title: 'Late Night Cravings Bonus',
      description: 'Enjoy ₹40 off on midnight snacks, ice creams, beverages, and quick bites.',
      discount: '₹40 OFF',
      minOrder: 199,
      validTill: 'Valid 10 PM - 2 AM',
      category: 'instant',
      badge: 'MIDNIGHT',
      bgColor: 'from-purple-600 to-indigo-800',
    },
  ];

  const handleCopy = (code: string) => {
    if (typeof navigator !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText(code);
    }
    setCopiedCode(code);
    setTimeout(() => {
      setCopiedCode((curr) => (curr === code ? null : curr));
    }, 3000);
  };

  const filteredCoupons = coupons.filter((c) =>
    selectedCategory === 'all' ? true : c.category === selectedCategory
  );

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-inter">
      <HeaderNavBar />

      <main className="flex-1 max-w-5xl w-full mx-auto px-4 sm:px-6 py-8 sm:py-12">
        {/* Hero Banner */}
        <div className="bg-gradient-to-r from-[#006b23] via-[#00531a] to-emerald-800 text-white rounded-3xl p-6 sm:p-10 shadow-xl relative overflow-hidden mb-10">
          <div className="absolute right-0 top-0 w-96 h-96 bg-white/10 rounded-full blur-3xl pointer-events-none -mr-20 -mt-20" />
          <div className="relative z-10 max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/20 backdrop-blur-md text-xs font-bold font-outfit uppercase tracking-wider mb-4">
              <Gift className="w-3.5 h-3.5" />
              <span>Exclusive Daily Basket Offers</span>
            </div>
            <h1 className="text-3xl sm:text-5xl font-black font-outfit tracking-tight leading-tight">
              Coupons, Deals & Instant Savings
            </h1>
            <p className="text-emerald-100 text-xs sm:text-sm mt-3 leading-relaxed">
              Copy any promo code below and apply it at checkout to get instant discounts on 10-minute grocery delivery!
            </p>
          </div>
        </div>

        {/* Filter Navigation Tabs */}
        <div className="flex items-center gap-2 overflow-x-auto pb-2 mb-8 scrollbar-none">
          {[
            { id: 'all', label: 'All Deals' },
            { id: 'instant', label: 'Instant Discounts' },
            { id: 'new-user', label: 'New User Specials' },
            { id: 'upi', label: 'UPI & Bank Offers' },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setSelectedCategory(tab.id)}
              className={`px-4 py-2.5 rounded-full text-xs font-bold font-outfit whitespace-nowrap transition-all shadow-xs ${
                selectedCategory === tab.id
                  ? 'bg-[#006b23] text-white shadow-emerald-700/20 shadow-md'
                  : 'bg-white text-slate-700 hover:bg-slate-100 border border-slate-200/80'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Coupon Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5 mb-12">
          {filteredCoupons.map((coupon) => {
            const isCopied = copiedCode === coupon.code;
            return (
              <div
                key={coupon.code}
                className="bg-white rounded-3xl border border-slate-200/80 shadow-xs hover:shadow-md transition-all overflow-hidden flex flex-col justify-between"
              >
                {/* Coupon Header Card Strip */}
                <div className={`p-5 bg-gradient-to-r ${coupon.bgColor} text-white flex items-start justify-between gap-4`}>
                  <div>
                    {coupon.badge && (
                      <span className="text-[10px] font-extrabold uppercase tracking-wider bg-black/20 backdrop-blur-md px-2.5 py-0.5 rounded-full inline-block mb-1.5">
                        {coupon.badge}
                      </span>
                    )}
                    <h2 className="text-lg font-black font-outfit">{coupon.discount}</h2>
                    <p className="text-white/90 text-xs font-medium mt-0.5">{coupon.title}</p>
                  </div>
                  <div className="w-10 h-10 rounded-2xl bg-white/20 backdrop-blur-md flex items-center justify-center shrink-0">
                    <Tag className="w-5 h-5 text-white" />
                  </div>
                </div>

                {/* Coupon Details */}
                <div className="p-5 flex-1 flex flex-col justify-between gap-4">
                  <p className="text-xs text-slate-600 leading-relaxed">
                    {coupon.description}
                  </p>

                  <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-[11px] text-slate-400 font-medium">
                    <span>Min order: ₹{coupon.minOrder}</span>
                    <span className="flex items-center gap-1">
                      <Clock className="w-3 h-3 text-slate-400" />
                      {coupon.validTill}
                    </span>
                  </div>

                  {/* Promo Code Box & Action */}
                  <div className="flex items-center justify-between gap-3 p-2.5 bg-slate-50 border border-dashed border-slate-300 rounded-2xl">
                    <div className="flex items-center gap-2 pl-2">
                      <Sparkles className="w-4 h-4 text-emerald-600" />
                      <span className="font-mono font-extrabold text-sm text-slate-900 tracking-wider">
                        {coupon.code}
                      </span>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleCopy(coupon.code)}
                        className={`h-9 px-4 rounded-xl text-xs font-bold font-outfit flex items-center gap-1.5 transition-all ${
                          isCopied
                            ? 'bg-emerald-600 text-white'
                            : 'bg-white hover:bg-slate-100 text-slate-800 border border-slate-200'
                        }`}
                      >
                        {isCopied ? (
                          <>
                            <Check className="w-3.5 h-3.5" />
                            <span>COPIED!</span>
                          </>
                        ) : (
                          <>
                            <Copy className="w-3.5 h-3.5" />
                            <span>COPY CODE</span>
                          </>
                        )}
                      </button>

                      <Link
                        href="/cart"
                        className="h-9 px-3.5 bg-[#006b23] hover:bg-[#00531a] text-white rounded-xl text-xs font-bold font-outfit flex items-center justify-center transition"
                        title="Go to Cart to Apply"
                      >
                        Apply →
                      </Link>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* How to Redeem Banner */}
        <div className="bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 shadow-xs">
          <h2 className="text-base font-bold text-slate-900 font-outfit mb-4 flex items-center gap-2">
            <ShieldCheck className="w-5 h-5 text-[#006b23]" />
            How to Redeem Your Daily Basket Coupons
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 text-xs text-slate-600">
            <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100">
              <span className="w-6 h-6 rounded-full bg-[#006b23] text-white text-[11px] font-black flex items-center justify-center mb-2">
                1
              </span>
              <h3 className="font-bold text-slate-900 mb-1">Add Fresh Items</h3>
              <p className="text-slate-500">Pick veggies, dairy, groceries, and bakery items to meet minimum order value.</p>
            </div>
            <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100">
              <span className="w-6 h-6 rounded-full bg-[#006b23] text-white text-[11px] font-black flex items-center justify-center mb-2">
                2
              </span>
              <h3 className="font-bold text-slate-900 mb-1">Paste Promo Code</h3>
              <p className="text-slate-500">Copy code from above and paste in the coupon field on the checkout screen.</p>
            </div>
            <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100">
              <span className="w-6 h-6 rounded-full bg-[#006b23] text-white text-[11px] font-black flex items-center justify-center mb-2">
                3
              </span>
              <h3 className="font-bold text-slate-900 mb-1">Instant 10-Min Delivery</h3>
              <p className="text-slate-500">Watch the discount apply immediately and enjoy doorstep delivery in 10 minutes!</p>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-slate-200/80 py-8 px-4 text-center text-xs text-slate-500">
        <p>© 2026 Daily Basket Quick-Commerce Suite. Real-Time Deals & Verified Coupons.</p>
      </footer>
    </div>
  );
}
