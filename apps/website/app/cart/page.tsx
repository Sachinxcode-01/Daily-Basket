// Google Stitch Screen ID: 2b83e1a79bb34387892c25c20f412941
// Title: Your Shopping Cart - Daily Basket
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ArrowLeft, ShoppingBag, Plus, Minus, Tag, MapPin, ChevronRight, ShieldCheck, Zap } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function CartPage() {
  const router = useRouter();
  const [couponCode, setCouponCode] = useState('');
  const [appliedCoupon, setAppliedCoupon] = useState<{ code: string; discount: number } | null>({
    code: 'DAILY100',
    discount: 50,
  });

  const [cartItems, setCartItems] = useState([
    { id: 'p1', name: 'Fresh Organic Farm Tomatoes', unit: '500g', price: 24, mrp: 40, quantity: 2, image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80' },
    { id: 'p2', name: 'Amul Taaza Toned Fresh Milk', unit: '1 Litre', price: 54, mrp: 56, quantity: 1, image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80' },
  ]);

  const updateQty = (id: string, delta: number) => {
    setCartItems((prev) =>
      prev
        .map((item) => {
          if (item.id === id) {
            const newQty = Math.max(0, item.quantity + delta);
            return newQty === 0 ? null : { ...item, quantity: newQty };
          }
          return item;
        })
        .filter(Boolean) as typeof prev,
    );
  };

  const itemSubtotal = cartItems.reduce((acc, item) => acc + item.price * item.quantity, 0);
  const mrpTotal = cartItems.reduce((acc, item) => acc + item.mrp * item.quantity, 0);
  const discountSavings = Math.max(0, mrpTotal - itemSubtotal);
  const deliveryFee = itemSubtotal >= 199 || cartItems.length === 0 ? 0 : 25;
  const platformFee = cartItems.length > 0 ? 5 : 0;
  const couponDiscount = appliedCoupon ? appliedCoupon.discount : 0;

  const grandTotal = Math.max(0, itemSubtotal + deliveryFee + platformFee - couponDiscount);

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

      {cartItems.length === 0 ? (
        <div className="py-20 text-center space-y-4">
          <ShoppingBag className="w-16 h-16 text-slate-600 mx-auto" />
          <h2 className="text-2xl font-bold text-white">Your Cart is Empty</h2>
          <p className="text-slate-400 text-sm">Add fresh groceries delivered to your door in 10 minutes.</p>
          <Link
            href="/"
            className="inline-block px-6 py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl shadow-lg transition"
          >
            Start Shopping
          </Link>
        </div>
      ) : (
        <div className="space-y-6">
          {/* 10-Min Delivery Promise Bar */}
          <div className="bg-emerald-500/10 border border-emerald-500/30 p-4 rounded-2xl flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-emerald-500/20 flex items-center justify-center text-emerald-400">
                <Zap className="w-6 h-6" />
              </div>
              <div>
                <h4 className="text-sm font-bold text-white">⚡ Delivery in 10 Minutes</h4>
                <p className="text-xs text-slate-400">Hub Store #01 Koramangala</p>
              </div>
            </div>
            <span className="text-xs font-bold text-emerald-400 bg-emerald-500/20 px-2.5 py-1 rounded-full">⚡ Express</span>
          </div>

          {/* Cart Item List */}
          <div className="space-y-3">
            {cartItems.map((item) => (
              <div
                key={item.id}
                className="bg-slate-800/80 border border-slate-700/60 p-4 rounded-2xl flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <img src={item.image} alt={item.name} className="w-16 h-16 object-cover rounded-xl bg-slate-900" />
                  <div>
                    <h3 className="text-sm font-bold text-white">{item.name}</h3>
                    <p className="text-xs text-slate-400">{item.unit}</p>
                    <div className="mt-1 flex items-center gap-2">
                      <span className="text-sm font-extrabold text-emerald-400">{formatCurrency(item.price)}</span>
                      <span className="text-xs text-slate-500 line-through">{formatCurrency(item.mrp)}</span>
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 bg-slate-900 border border-slate-700 rounded-xl px-3 py-1.5">
                  <button onClick={() => updateQty(item.id, -1)} className="text-slate-400 hover:text-white">
                    <Minus className="w-4 h-4" />
                  </button>
                  <span className="text-sm font-bold text-white">{item.quantity}</span>
                  <button onClick={() => updateQty(item.id, 1)} className="text-slate-400 hover:text-white">
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>

          {/* Coupon Code Section */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-4 rounded-2xl flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Tag className="w-5 h-5 text-lime-400" />
              <div>
                <p className="text-sm font-bold text-white">Promo Coupon</p>
                <p className="text-xs text-lime-400 font-semibold">{appliedCoupon ? `Applied: ${appliedCoupon.code} (Saved ₹${appliedCoupon.discount})` : 'Apply coupon code'}</p>
              </div>
            </div>
            <button
              onClick={() => {
                if (appliedCoupon) setAppliedCoupon(null);
                else setAppliedCoupon({ code: 'DAILY100', discount: 50 });
              }}
              className="text-xs font-bold text-emerald-400 hover:underline"
            >
              {appliedCoupon ? 'Remove' : 'Apply DAILY100'}
            </button>
          </div>

          {/* Bill Breakdown Summary */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl space-y-3">
            <h3 className="text-sm font-bold text-white mb-2">Bill Breakdown</h3>
            <div className="flex justify-between text-xs text-slate-300">
              <span>Item Total (MRP)</span>
              <span>{formatCurrency(mrpTotal)}</span>
            </div>
            <div className="flex justify-between text-xs text-emerald-400 font-semibold">
              <span>Product Discount Savings</span>
              <span>-{formatCurrency(discountSavings)}</span>
            </div>
            <div className="flex justify-between text-xs text-slate-300">
              <span>Delivery Fee</span>
              <span>{deliveryFee === 0 ? <span className="text-emerald-400 font-bold">FREE</span> : formatCurrency(deliveryFee)}</span>
            </div>
            <div className="flex justify-between text-xs text-slate-300">
              <span>Handling & Platform Fee</span>
              <span>{formatCurrency(platformFee)}</span>
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
        </div>
      )}

      {/* Checkout Sticky Bottom Bar */}
      {cartItems.length > 0 && (
        <div className="fixed bottom-0 left-0 right-0 z-50 bg-slate-900/95 backdrop-blur-lg border-t border-slate-800 p-4">
          <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
            <div>
              <p className="text-xs text-slate-400 font-medium">Grand Total</p>
              <p className="text-xl font-black text-emerald-400">{formatCurrency(grandTotal)}</p>
            </div>
            <button
              onClick={() => router.push('/checkout')}
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
