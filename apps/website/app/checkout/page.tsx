// Google Stitch Screen ID: 6b2f3bdb3dca4c43954638dd8af95506
// Title: Secure Enterprise Checkout Flow - Checkout Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useMemo, useState, Suspense } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ArrowLeft, MapPin, CreditCard, ShieldCheck, CheckCircle2, Zap, Clock, Loader2 } from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../../store/useCart';

type PaymentChoice = 'UPI' | 'CARD' | 'COD';

// Map the UI payment choice to the backend PaymentMethod enum.
const PAYMENT_ENUM: Record<PaymentChoice, string> = {
  UPI: 'UPI',
  CARD: 'CARD',
  COD: 'CASH_ON_DELIVERY',
};

function CheckoutInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const couponCode = searchParams.get('coupon') || undefined;

  const { activeItems, userId, clear } = useCart();
  const [selectedPayment, setSelectedPayment] = useState<PaymentChoice>('UPI');
  const [isPlacing, setIsPlacing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Items in the shape the pricing + order endpoints expect.
  const orderItems = useMemo(
    () =>
      activeItems.map((i) => ({
        id: i.variantId,
        variantId: i.variantId,
        productName: i.productName,
        unitName: i.unitName,
        price: i.price,
        quantity: i.quantity,
      })),
    [activeItems],
  );

  // Server-authoritative pricing (recomputed whenever items / coupon / payment change).
  const { data: pricing, isLoading: pricingLoading } = useQuery({
    queryKey: ['order-pricing', orderItems, couponCode, selectedPayment],
    queryFn: () =>
      apiClient.calculateOrderPricing({
        items: orderItems,
        couponCode,
        paymentMethod: PAYMENT_ENUM[selectedPayment],
      }),
    enabled: orderItems.length > 0,
  });

  // Default delivery address.
  const { data: addresses } = useQuery({
    queryKey: ['addresses', userId],
    queryFn: () => apiClient.getAddresses(userId),
  });
  const address = Array.isArray(addresses) ? (addresses.find((a: any) => a.isDefault) ?? addresses[0]) : undefined;

  const payable = pricing?.finalPayable ?? pricing?.grandTotal ?? 0;

  const handlePlaceOrder = async () => {
    if (orderItems.length === 0) {
      router.push('/cart');
      return;
    }
    if (!address?.id) {
      setError('Please add a delivery address before placing the order.');
      return;
    }
    setIsPlacing(true);
    setError(null);
    try {
      // 1. Create the order (server recomputes totals + generates delivery OTP).
      const order = await apiClient.createOrder({
        userId,
        addressId: address.id,
        paymentMethod: PAYMENT_ENUM[selectedPayment],
        items: orderItems,
        couponCode,
      });

      // 2. Online payment: initiate Razorpay + verify server-side. COD skips the gateway.
      if (selectedPayment !== 'COD') {
        const init = await apiClient.initiatePayment(order.id, order.totalAmount);
        // Demo/test mode: the backend accepts a `sig_test` signature (no live Razorpay keys).
        // In production this handler runs inside the Razorpay checkout success callback with
        // the real razorpay_payment_id + razorpay_signature.
        await apiClient.verifyPayment({
          paymentId: `pay_test_${Date.now()}`,
          razorpayOrderId: init.razorpayOrderId,
          razorpaySignature: 'sig_test_demo',
        });
      }

      // 3. Clear the cart and go to the confirmation screen.
      await clear.mutateAsync().catch(() => {});
      router.push(`/order-success?orderId=${order.id}`);
    } catch (err: any) {
      setError(err?.message || 'Could not place your order. Please try again.');
    } finally {
      setIsPlacing(false);
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

      {orderItems.length === 0 ? (
        <div className="py-24 text-center space-y-4">
          <p className="text-white font-bold text-lg">Your cart is empty</p>
          <Link href="/" className="inline-block px-6 py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl">
            Start Shopping
          </Link>
        </div>
      ) : (
        <div className="space-y-6">
          {/* Delivery Address */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2 text-emerald-400 font-bold text-sm">
                <MapPin className="w-4 h-4" />
                <span>Delivery Address</span>
              </div>
              <Link href="/add-address" className="text-xs font-bold text-emerald-400 hover:underline">Change</Link>
            </div>
            {address ? (
              <>
                <p className="text-white font-bold text-sm">{address.label} — {address.city}</p>
                <p className="text-slate-400 text-xs mt-1">
                  {address.houseNo}, {address.street}, {address.city} - {address.pincode}
                </p>
              </>
            ) : (
              <p className="text-slate-400 text-xs">No saved address. Please add one to continue.</p>
            )}
          </div>

          {/* Delivery Slot */}
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
              onClick={() => setSelectedPayment('CARD')}
              className={`p-4 rounded-xl border cursor-pointer flex items-center justify-between transition ${
                selectedPayment === 'CARD' ? 'bg-emerald-500/10 border-emerald-500' : 'bg-slate-900/60 border-slate-700'
              }`}
            >
              <div className="flex items-center gap-3">
                <CreditCard className="w-5 h-5 text-sky-400" />
                <div>
                  <p className="text-sm font-bold text-white">Credit / Debit Card (Razorpay)</p>
                  <p className="text-xs text-slate-400">Visa, Mastercard, RuPay</p>
                </div>
              </div>
              {selectedPayment === 'CARD' && <CheckCircle2 className="w-5 h-5 text-emerald-400" />}
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

          {/* Bill Summary (server-authoritative) */}
          {pricing && (
            <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl space-y-2">
              <h3 className="text-sm font-bold text-white mb-2">Bill Summary</h3>
              <div className="flex justify-between text-xs text-slate-300"><span>Subtotal</span><span>{formatCurrency(pricing.subtotal)}</span></div>
              {pricing.couponDiscount > 0 && (
                <div className="flex justify-between text-xs text-lime-400 font-semibold"><span>Coupon ({pricing.appliedCoupon})</span><span>-{formatCurrency(pricing.couponDiscount)}</span></div>
              )}
              <div className="flex justify-between text-xs text-slate-300"><span>Delivery Fee</span><span>{pricing.deliveryFee === 0 ? <span className="text-emerald-400 font-bold">FREE</span> : formatCurrency(pricing.deliveryFee)}</span></div>
              <div className="flex justify-between text-xs text-slate-300"><span>Platform + Packaging</span><span>{formatCurrency(pricing.platformFee + pricing.packagingFee)}</span></div>
              <div className="flex justify-between text-xs text-slate-300"><span>GST</span><span>{formatCurrency(pricing.totalGst)}</span></div>
              <div className="border-t border-slate-700/60 pt-2 flex justify-between items-center">
                <span className="text-sm font-extrabold text-white">Total Payable</span>
                <span className="text-lg font-black text-emerald-400">{formatCurrency(payable)}</span>
              </div>
            </div>
          )}

          {error && <p className="text-sm text-rose-400 bg-rose-500/10 border border-rose-500/30 rounded-xl p-3">{error}</p>}
        </div>
      )}

      {/* Pay CTA Bar */}
      {orderItems.length > 0 && (
        <div className="fixed bottom-0 left-0 right-0 z-50 bg-slate-900/95 backdrop-blur-lg border-t border-slate-800 p-4">
          <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
            <div>
              <p className="text-xs text-slate-400">Total Payable</p>
              <p className="text-xl font-black text-emerald-400">{pricingLoading ? '…' : formatCurrency(payable)}</p>
            </div>
            <button
              onClick={handlePlaceOrder}
              disabled={isPlacing || pricingLoading || !address}
              className="flex-1 max-w-xs py-3.5 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white font-bold rounded-xl shadow-lg shadow-emerald-900/40 flex items-center justify-center gap-2 transition"
            >
              {isPlacing ? <Loader2 className="w-5 h-5 animate-spin" /> : <span>{selectedPayment === 'COD' ? 'Place 10-Min Order' : `Pay ${formatCurrency(payable)}`}</span>}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

export default function CheckoutPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-slate-900" />}>
      <CheckoutInner />
    </Suspense>
  );
}
