'use client';

import React, { useState } from 'react';
import { ArrowLeft, Sparkles, CheckCircle2 } from 'lucide-react';

// Google Stitch Specs: Create Coupon - Daily Basket Admin
// ID: 0a470157a8f2468f81962043fc512599

export default function CreateCouponPage() {
  const [code, setCode] = useState('SUMMER50');
  const [discountType, setDiscountType] = useState('Percentage');
  const [discountValue, setDiscountValue] = useState('20');
  const [minOrder, setMinOrder] = useState('299');
  const [maxDiscount, setMaxDiscount] = useState('100');
  const [isSuccess, setIsSuccess] = useState(false);

  const handlePublish = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSuccess(true);
    setTimeout(() => setIsSuccess(false), 3000);
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6 font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-black text-[#006837]">Create New Coupon</h1>
          <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: 0a470157a8f2468f81962043fc512599</p>
        </div>
      </div>

      <form onSubmit={handlePublish} className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-5">
        {isSuccess && (
          <div className="p-4 bg-emerald-100 border border-[#a7f3d0] rounded-2xl flex items-center gap-3 text-[#15803d]">
            <CheckCircle2 className="w-5 h-5 shrink-0" />
            <span className="text-xs font-bold">Coupon published successfully to Daily Basket Storefront!</span>
          </div>
        )}

        {/* Coupon Code */}
        <div className="space-y-1.5">
          <label className="text-xs font-bold text-[#1e2923]">Coupon Code</label>
          <div className="flex gap-2">
            <input
              type="text"
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              className="flex-1 px-4 py-2.5 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl font-mono font-black text-sm text-[#1e2923] uppercase outline-none focus:border-[#006837]"
            />
            <button
              type="button"
              onClick={() => setCode(`GEN${Math.floor(1000 + Math.random() * 9000)}`)}
              className="px-4 py-2.5 bg-[#f1f5f9] border border-[#e2e8f0] rounded-2xl text-xs font-bold text-[#1e2923] flex items-center gap-1 hover:bg-[#e2e8f0]"
            >
              <Sparkles className="w-3.5 h-3.5 text-[#006837]" /> Auto Code
            </button>
          </div>
        </div>

        {/* Discount Type */}
        <div className="space-y-1.5">
          <label className="text-xs font-bold text-[#1e2923]">Discount Type</label>
          <div className="grid grid-cols-3 gap-2">
            {['Percentage', 'Fixed ₹', 'Free Delivery'].map((type) => (
              <button
                key={type}
                type="button"
                onClick={() => setDiscountType(type)}
                className={`py-2.5 rounded-2xl text-xs font-bold transition border ${
                  discountType === type
                    ? 'bg-[#006837] text-white border-[#006837] shadow-sm'
                    : 'bg-[#f8fafc] text-[#64748b] border-[#cbd5e1] hover:bg-white'
                }`}
              >
                {type}
              </button>
            ))}
          </div>
        </div>

        {/* Value & Limits */}
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-[#1e2923]">Discount Value</label>
            <input
              type="number"
              value={discountValue}
              onChange={(e) => setDiscountValue(e.target.value)}
              className="w-full px-4 py-2.5 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-xs text-[#1e2923] outline-none"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-bold text-[#1e2923]">Min. Order (₹)</label>
            <input
              type="number"
              value={minOrder}
              onChange={(e) => setMinOrder(e.target.value)}
              className="w-full px-4 py-2.5 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-xs text-[#1e2923] outline-none"
            />
          </div>
        </div>

        <div className="space-y-1.5">
          <label className="text-xs font-bold text-[#1e2923]">Max Discount Limit (₹)</label>
          <input
            type="number"
            value={maxDiscount}
            onChange={(e) => setMaxDiscount(e.target.value)}
            className="w-full px-4 py-2.5 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-xs text-[#1e2923] outline-none"
          />
        </div>

        <button
          type="submit"
          className="w-full py-3 bg-[#006837] text-white text-xs font-bold rounded-2xl shadow-md hover:bg-[#00522b] transition"
        >
          Publish Coupon
        </button>
      </form>
    </div>
  );
}
