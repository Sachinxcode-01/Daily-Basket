// Google Stitch Screen ID: 6b2f3bdb3dca4c43954638dd8af95506
// Title: Secure Enterprise Checkout Flow - Checkout Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ArrowLeft, MapPin, CreditCard, ShieldCheck, CheckCircle2, Zap, Clock, Loader2 } from 'lucide-react';
import { apiClient } from '@daily-basket/api-client';

export default function CheckoutPage() {
  const router = useRouter();
  const [selectedPayment, setSelectedPayment] = useState<'UPI' | 'RAZORPAY' | 'COD'>('UPI');
  const [isLoading, setIsLoading] = useState(false);

  const handlePlaceOrder = async () => {
    setIsLoading(true);
    try {
      // Step 1: Create Order on backend
      const order = await apiClient.createOrder({
        addressId: 'addr_default_01',
        paymentMethod: selectedPayment,
        items: [
          {
            id: 'item_1',
            productId: 'prod_1',
            variantId: 'var_1',
            productName: 'Organic Farm Tomatoes',
            unitName: '500g',
            price: 24,
            mrp: 40,
            quantity: 2,
          },
        ],
      });

      // Step 2: Route to Order Success Screen
      setTimeout(() => {
        router.push(`/order-success?orderId=${order.id || 'DB-892104'}`);
      }, 1000);
    } catch (err) {
      // Fallback demo order routing
      router.push('/order-success?orderId=DB-892104');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-28 max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <Link href="/cart" className="flex items-center gap-2 text-slate-300 hover:text-white">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Cart</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white">Checkout</h1>
        <div className="w-6" />
      </div>

      <div className="space-y-6">
        {/* Delivery Address Picker */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2 text-emerald-400 font-bold text-sm">
              <MapPin className="w-4 h-4" />
              <span>Delivery Address</span>
            </div>
            <button className="text-xs font-bold text-emerald-400 hover:underline">Change</button>
          </div>
          <p className="text-white font-bold text-sm">Home — Koramangala 4th Block</p>
          <p className="text-slate-400 text-xs mt-1">#42, 100 Feet Road, 4th Block, Koramangala, Bengaluru - 560034</p>
        </div>

        {/* Delivery Slot Choice */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
          <div className="flex items-center gap-2 text-amber-400 font-bold text-sm mb-3">
            <Clock className="w-4 h-4" />
            <span>Delivery Time Slot</span>
          </div>
          <div className="p-3 bg-emerald-500/10 border border-emerald-500/30 rounded-xl flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <Zap className="w-4 h-4 text-emerald-400" />
              <div>
                <p className="text-xs font-bold text-white">⚡ Instant 10-Minute Delivery</p>
                <p className="text-[10px] text-slate-400">Guaranteed arrival in ~8 to 10 mins</p>
              </div>
            </div>
            <span className="text-xs font-bold text-emerald-400">Selected</span>
          </div>
        </div>

        {/* Payment Methods */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl space-y-3">
          <h3 className="text-sm font-bold text-white mb-2">Select Payment Method</h3>

          <div
            onClick={() => setSelectedPayment('UPI')}
            className={`p-4 rounded-xl border cursor-pointer flex items-center justify-between transition ${
              selectedPayment === 'UPI' ? 'bg-emerald-500/10 border-emerald-500' : 'bg-slate-900/60 border-slate-700'
            }`}
          >
            <div className="flex items-center gap-3">
              <ShieldCheck className="w-5 h-5 text-emerald-400" />
              <div>
                <p className="text-sm font-bold text-white">UPI (Google Pay, PhonePe, Paytm)</p>
                <p className="text-xs text-slate-400">Fast 1-tap instant payment</p>
              </div>
            </div>
            {selectedPayment === 'UPI' && <CheckCircle2 className="w-5 h-5 text-emerald-400" />}
          </div>

          <div
            onClick={() => setSelectedPayment('RAZORPAY')}
            className={`p-4 rounded-xl border cursor-pointer flex items-center justify-between transition ${
              selectedPayment === 'RAZORPAY' ? 'bg-emerald-500/10 border-emerald-500' : 'bg-slate-900/60 border-slate-700'
            }`}
          >
            <div className="flex items-center gap-3">
              <CreditCard className="w-5 h-5 text-sky-400" />
              <div>
                <p className="text-sm font-bold text-white">Credit / Debit Card (Razorpay)</p>
                <p className="text-xs text-slate-400">Visa, Mastercard, RuPay</p>
              </div>
            </div>
            {selectedPayment === 'RAZORPAY' && <CheckCircle2 className="w-5 h-5 text-emerald-400" />}
          </div>

          <div
            onClick={() => setSelectedPayment('COD')}
            className={`p-4 rounded-xl border cursor-pointer flex items-center justify-between transition ${
              selectedPayment === 'COD' ? 'bg-emerald-500/10 border-emerald-500' : 'bg-slate-900/60 border-slate-700'
            }`}
          >
            <div className="flex items-center gap-3">
              <Zap className="w-5 h-5 text-amber-400" />
              <div>
                <p className="text-sm font-bold text-white">Cash on Delivery (COD)</p>
                <p className="text-xs text-slate-400">Pay cash upon 10-min arrival</p>
              </div>
            </div>
            {selectedPayment === 'COD' && <CheckCircle2 className="w-5 h-5 text-emerald-400" />}
          </div>
        </div>
      </div>

      {/* Pay CTA Bar */}
      <div className="fixed bottom-0 left-0 right-0 z-50 bg-slate-900/95 backdrop-blur-lg border-t border-slate-800 p-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
          <div>
            <p className="text-xs text-slate-400">Total Payable</p>
            <p className="text-xl font-black text-emerald-400">₹53</p>
          </div>
          <button
            onClick={handlePlaceOrder}
            disabled={isLoading}
            className="flex-1 max-w-xs py-3.5 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white font-bold rounded-xl shadow-lg shadow-emerald-900/40 flex items-center justify-center gap-2 transition"
          >
            {isLoading ? (
              <Loader2 className="w-5 h-5 animate-spin" />
            ) : (
              <span>Place 10-Min Order</span>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
