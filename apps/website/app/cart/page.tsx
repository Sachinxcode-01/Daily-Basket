// Google Stitch Screen ID: 2b83e1a79bb34387892c25c20f412941
// Title: Your Shopping Cart - Daily Basket
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ArrowLeft, ShoppingBag, Plus, Minus, Tag, ChevronRight, Zap, Loader2 } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../../store/useCart';

export default function CartPage() {
  const router = useRouter();
  const { activeItems, summary, isLoading, isError, refetch, updateItem, clear, userId } = useCart();

  const [couponCode, setCouponCode] = useState('');
  const [appliedCoupon, setAppliedCoupon] = useState<{ code: string; discount: number } | null>(null);
  const [couponError, setCouponError] = useState<string | null>(null);
  const [couponLoading, setCouponLoading] = useState(false);

  const itemTotal = summary?.itemTotal ?? 0;
  const couponDiscount = appliedCoupon?.discount ?? 0;
  const grandTotal = Math.max(0, (summary?.grandTotal ?? 0) - couponDiscount);

  const applyCoupon = async () => {
    const code = couponCode.trim().toUpperCase();
    if (!code) return;
    setCouponLoading(true);
    setCouponError(null);
    try {
      const res = await apiClient.applyCoupon(code, itemTotal, userId);
      if (res?.valid) {
        setAppliedCoupon({ code: res.code, discount: res.discountAmount });
        setCouponError(null);
      } else {
        setCouponError('Coupon could not be applied.');
      }
    } catch (err: any) {
      setAppliedCoupon(null);
      setCouponError(err?.message || 'Invalid coupon code.');
    } finally {
      setCouponLoading(false);
    }
  };

  const removeCoupon = () => {
    setAppliedCoupon(null);
    setCouponCode('');
    setCouponError(null);
  };

  const changeQty = (itemId: string, current: number, delta: number) => {
    updateItem.mutate({ itemId, quantity: Math.max(0, current + delta) });
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-28 max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-4">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Continue Shopping</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white">Your Shopping Cart</h1>
        <div className="w-6" />
      </div>

      {/* Loading */}
      {isLoading && (
        <div className="py-24 flex flex-col items-center gap-3 text-slate-400">
          <Loader2 className="w-8 h-8 animate-spin text-emerald-400" />
          <p className="text-sm">Loading your cart…</p>
        </div>
      )}

      {/* Error */}
      {!isLoading && isError && (
        <div className="py-20 text-center space-y-4">
          <p className="text-white font-bold">Couldn&rsquo;t load your cart</p>
          <button onClick={() => refetch()} className="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white text-sm font-bold rounded-xl">
            Retry
          </button>
        </div>
      )}

      {/* Empty */}
      {!isLoading && !isError && activeItems.length === 0 && (
        <div className="py-20 text-center space-y-4">
          <ShoppingBag className="w-16 h-16 text-slate-600 mx-auto" />
          <h2 className="text-2xl font-bold text-white">Your Cart is Empty</h2>
          <p className="text-slate-400 text-sm">Add fresh groceries delivered to your door in 10 minutes.</p>
          <Link href="/" className="inline-block px-6 py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl shadow-lg transition">
            Start Shopping
          </Link>
        </div>
      )}

      {!isLoading && !isError && activeItems.length > 0 && summary && (
        <div className="space-y-6">
          {/* 10-Min Delivery Promise Bar */}
          <div className="bg-emerald-500/10 border border-emerald-500/30 p-4 rounded-2xl flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-emerald-500/20 flex items-center justify-center text-emerald-400">
                <Zap className="w-6 h-6" />
              </div>
              <div>
                <h4 className="text-sm font-bold text-white">⚡ Delivery in 10 Minutes</h4>
                <p className="text-xs text-slate-400">Daily Basket — Koramangala</p>
              </div>
            </div>
            <span className="text-xs font-bold text-emerald-400 bg-emerald-500/20 px-2.5 py-1 rounded-full">⚡ Express</span>
          </div>

          {/* Cart Item List */}
          <div className="space-y-3">
            {activeItems.map((item) => (
              <div
                key={item.id}
                className="bg-slate-800/80 border border-slate-700/60 p-4 rounded-2xl flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <div className="w-16 h-16 rounded-xl bg-slate-900 flex items-center justify-center text-2xl">🛒</div>
                  <div>
                    <h3 className="text-sm font-bold text-white">{item.productName}</h3>
                    <p className="text-xs text-slate-400">{item.unitName}</p>
                    <div className="mt-1 flex items-center gap-2">
                      <span className="text-sm font-extrabold text-emerald-400">{formatCurrency(item.price)}</span>
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 bg-slate-900 border border-slate-700 rounded-xl px-3 py-1.5">
                  <button onClick={() => changeQty(item.id, item.quantity, -1)} disabled={updateItem.isPending} className="text-slate-400 hover:text-white disabled:opacity-40">
                    <Minus className="w-4 h-4" />
                  </button>
                  <span className="text-sm font-bold text-white min-w-[16px] text-center">{item.quantity}</span>
                  <button onClick={() => changeQty(item.id, item.quantity, 1)} disabled={updateItem.isPending} className="text-slate-400 hover:text-white disabled:opacity-40">
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>

          {/* Coupon Code Section */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-4 rounded-2xl space-y-3">
            <div className="flex items-center gap-2">
              <Tag className="w-5 h-5 text-lime-400" />
              <p className="text-sm font-bold text-white">Promo Coupon</p>
            </div>
            {appliedCoupon ? (
              <div className="flex items-center justify-between">
                <p className="text-xs text-lime-400 font-semibold">
                  Applied: {appliedCoupon.code} (Saved {formatCurrency(appliedCoupon.discount)})
                </p>
                <button onClick={removeCoupon} className="text-xs font-bold text-rose-400 hover:underline">
                  Remove
                </button>
              </div>
            ) : (
              <div className="flex gap-2">
                <input
                  type="text"
                  value={couponCode}
                  onChange={(e) => setCouponCode(e.target.value.toUpperCase())}
                  placeholder="Enter coupon (e.g. FRESH20)"
                  className="flex-1 bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500"
                />
                <button
                  onClick={applyCoupon}
                  disabled={couponLoading || !couponCode.trim()}
                  className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white text-xs font-bold rounded-xl flex items-center gap-1"
                >
                  {couponLoading ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : null} Apply
                </button>
              </div>
            )}
            {couponError && <p className="text-xs text-rose-400">{couponError}</p>}
          </div>

          {/* Bill Breakdown Summary (backend-validated) */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl space-y-3">
            <h3 className="text-sm font-bold text-white mb-2">Bill Breakdown</h3>
            <div className="flex justify-between text-xs text-slate-300">
              <span>Item Total (MRP)</span>
              <span>{formatCurrency(summary.mrpTotal)}</span>
            </div>
            {summary.productDiscounts > 0 && (
              <div className="flex justify-between text-xs text-emerald-400 font-semibold">
                <span>Product Discount Savings</span>
                <span>-{formatCurrency(summary.productDiscounts)}</span>
              </div>
            )}
            <div className="flex justify-between text-xs text-slate-300">
              <span>Delivery Fee</span>
              <span>{summary.deliveryFee === 0 ? <span className="text-emerald-400 font-bold">FREE</span> : formatCurrency(summary.deliveryFee)}</span>
            </div>
            <div className="flex justify-between text-xs text-slate-300">
              <span>Handling & Platform Fee</span>
              <span>{formatCurrency(summary.platformFee + summary.packagingCharges)}</span>
            </div>
            <div className="flex justify-between text-xs text-slate-300">
              <span>GST (5%)</span>
              <span>{formatCurrency(summary.taxGst)}</span>
            </div>
            {appliedCoupon && (
              <div className="flex justify-between text-xs text-lime-400 font-semibold">
                <span>Coupon Discount ({appliedCoupon.code})</span>
                <span>-{formatCurrency(appliedCoupon.discount)}</span>
              </div>
            )}
            <div className="border-t border-slate-700/60 pt-3 flex justify-between items-center">
              <span className="text-base font-extrabold text-white">To Pay</span>
              <span className="text-xl font-black text-emerald-400">{formatCurrency(grandTotal)}</span>
            </div>
          </div>

          <button onClick={() => clear.mutate()} disabled={clear.isPending} className="text-xs text-slate-500 hover:text-rose-400 transition">
            Clear cart
          </button>
        </div>
      )}

      {/* Checkout Sticky Bottom Bar */}
      {!isLoading && !isError && activeItems.length > 0 && (
        <div className="fixed bottom-0 left-0 right-0 z-50 bg-slate-900/95 backdrop-blur-lg border-t border-slate-800 p-4">
          <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
            <div>
              <p className="text-xs text-slate-400 font-medium">Grand Total</p>
              <p className="text-xl font-black text-emerald-400">{formatCurrency(grandTotal)}</p>
            </div>
            <button
              onClick={() => router.push(appliedCoupon ? `/checkout?coupon=${appliedCoupon.code}` : '/checkout')}
              className="flex-1 max-w-xs py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl shadow-lg shadow-emerald-900/40 flex items-center justify-center gap-2 transition"
            >
              <span>Proceed to Checkout</span>
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
