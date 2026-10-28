'use client';

import React, { useState, useMemo } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  ArrowLeft,
  ShoppingBag,
  Plus,
  Minus,
  Tag,
  ChevronRight,
  Zap,
  Loader2,
  Sparkles,
  Check,
  AlertTriangle,
  RefreshCw,
  Clock,
  Trash2,
  FileText,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../../store/useCart';
import {
  getCartRecommendations,
  getProductSubstitutes,
  normalizeImagePath,
  WebsiteProduct,
} from '../../lib/catalog';

const POPULAR_COUPONS = [
  { code: 'SAVE50', desc: '₹50 OFF on orders above ₹249', minOrder: 249 },
  { code: 'FIRSTORDER', desc: '₹100 OFF for first time grocery buyers', minOrder: 299 },
  { code: 'FREESHIP', desc: 'FREE 10-Min Delivery on all baskets', minOrder: 99 },
];

export default function CartPage() {
  const router = useRouter();
  const {
    activeItems,
    summary,
    isLoading,
    isError,
    refetch,
    addItem,
    updateItem,
    clear,
    userId,
  } = useCart();

  const [couponCode, setCouponCode] = useState('');
  const [appliedCoupon, setAppliedCoupon] = useState<{ code: string; discount: number } | null>(null);
  const [couponError, setCouponError] = useState<string | null>(null);
  const [couponLoading, setCouponLoading] = useState(false);
  const [deliveryNotes, setDeliveryNotes] = useState('');
  const [swappingItemId, setSwappingItemId] = useState<string | null>(null);

  const itemTotal = summary?.itemTotal ?? 0;
  const couponDiscount = appliedCoupon?.discount ?? 0;
  const grandTotal = Math.max(0, (summary?.grandTotal ?? 0) - couponDiscount);

  // Apply Coupon with backend validation
  const handleApplyCoupon = async (codeToApply?: string) => {
    const code = (codeToApply || couponCode).trim().toUpperCase();
    if (!code) return;
    setCouponLoading(true);
    setCouponError(null);
    try {
      const res = await apiClient.applyCoupon(code, itemTotal, userId);
      if (res?.valid) {
        setAppliedCoupon({ code: res.code, discount: res.discountAmount });
        setCouponCode(res.code);
        setCouponError(null);
      } else {
        setCouponError('Coupon could not be applied to this cart value.');
      }
    } catch (err: any) {
      setAppliedCoupon(null);
      setCouponError(err?.message || 'Invalid coupon or minimum order value not met.');
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

  // 1-Click Substitution Swap
  const handleSwapWithSubstitute = (
    currentItemId: string,
    substitute: { variantId: string; name: string; unitName: string; price: number },
  ) => {
    setSwappingItemId(currentItemId);
    // Remove current unavailable item
    updateItem.mutate(
      { itemId: currentItemId, quantity: 0 },
      {
        onSuccess: () => {
          // Add recommended substitute
          addItem.mutate(
            {
              variantId: substitute.variantId,
              productName: substitute.name,
              unitName: substitute.unitName,
              price: substitute.price,
              quantity: 1,
            },
            {
              onSuccess: () => {
                setSwappingItemId(null);
              },
            },
          );
        },
      },
    );
  };

  // Cross-sell items
  const cartItemIds = useMemo(() => activeItems.map((i) => i.variantId || i.id), [activeItems]);
  const cartRecommendations = useMemo(() => getCartRecommendations(cartItemIds, 6), [cartItemIds]);

  return (
    <div className="min-h-screen bg-[#f9f9fc] text-[#191c1e] py-6 px-4 sm:px-6 lg:px-8 pb-36">
      <div className="max-w-4xl mx-auto space-y-6">
        {/* Navigation & Header */}
        <div className="flex items-center justify-between border-b border-[#e2e2e5] pb-4">
          <Link
            href="/"
            className="flex items-center gap-1.5 text-xs font-bold text-[#2d9d43] hover:text-[#078730] transition p-1.5 rounded-lg hover:bg-emerald-50"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Continue Shopping</span>
          </Link>
          <h1 className="text-xl sm:text-2xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
            Shopping Cart ({activeItems.length})
          </h1>
          <div className="w-20" />
        </div>

        {/* Loading State */}
        {isLoading && (
          <div className="py-24 flex flex-col items-center gap-3 text-slate-500">
            <Loader2 className="w-8 h-8 animate-spin text-[#2d9d43]" />
            <p className="text-sm font-medium">Checking live Kirana inventory & cart prices…</p>
          </div>
        )}

        {/* Error State */}
        {!isLoading && isError && (
          <div className="py-16 text-center space-y-4 bg-white border border-[#e2e2e5] rounded-3xl p-8 shadow-xs">
            <AlertTriangle className="w-12 h-12 text-amber-500 mx-auto" />
            <h3 className="text-base font-bold text-[#191c1e]">Unable to load your cart</h3>
            <p className="text-xs text-[#64748b]">Please check your network connection and retry.</p>
            <button
              onClick={() => refetch()}
              className="px-6 py-2.5 bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold rounded-xl shadow-xs transition"
            >
              Retry
            </button>
          </div>
        )}

        {/* Empty State */}
        {!isLoading && !isError && activeItems.length === 0 && (
          <div className="py-20 text-center space-y-4 bg-white border border-[#e2e2e5] rounded-3xl p-8 shadow-xs max-w-md mx-auto">
            <div className="w-16 h-16 rounded-full bg-emerald-50 border border-emerald-100 flex items-center justify-center mx-auto text-[#2d9d43]">
              <ShoppingBag className="w-8 h-8 text-[#2d9d43]" />
            </div>
            <div>
              <h2 className="text-xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                Your Basket is Empty
              </h2>
              <p className="text-xs text-[#64748b] mt-1">
                Stock up on dairy, fresh vegetables, snacks, and daily Kirana essentials delivered in 10 minutes.
              </p>
            </div>
            <Link
              href="/"
              className="inline-block px-6 py-2.5 bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold rounded-xl shadow-xs transition"
            >
              Start Shopping
            </Link>
          </div>
        )}

        {/* Cart Contents */}
        {!isLoading && !isError && activeItems.length > 0 && summary && (
          <div className="space-y-6">
            {/* Express 10-Min Delivery Banner */}
            <div className="bg-emerald-50 border border-emerald-200 p-4 rounded-2xl flex items-center justify-between shadow-xs">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-[#2d9d43] flex items-center justify-center text-white shadow-xs">
                  <Zap className="w-5 h-5 fill-white" />
                </div>
                <div>
                  <h4 className="text-xs sm:text-sm font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                    ⚡ Guaranteed Delivery in 10 Minutes
                  </h4>
                  <p className="text-[11px] text-[#3f4a3d]">Daily Basket Kirana Store • Express Superfast Delivery</p>
                </div>
              </div>
              <span className="text-[11px] font-extrabold text-[#15803d] bg-white border border-emerald-300 px-3 py-1 rounded-full shadow-xs">
                Express Active
              </span>
            </div>

            {/* Cart Items List */}
            <div className="space-y-3">
              {activeItems.map((item) => {
                // Find direct substitutes for this item in case user wants alternatives
                const substitutes = getProductSubstitutes(item.variantId || item.id);
                const topSubstitute = substitutes[0];

                return (
                  <div
                    key={item.id}
                    className="bg-white border border-[#e2e2e5] p-4 rounded-2xl shadow-xs space-y-3"
                  >
                    <div className="flex items-center justify-between gap-3">
                      <div className="flex items-center gap-3">
                        <div className="w-14 h-14 rounded-xl bg-[#f9f9fc] border border-[#eceef0] flex items-center justify-center text-2xl shrink-0">
                          🛒
                        </div>
                        <div>
                          <h3 className="text-xs sm:text-sm font-bold text-[#191c1e] line-clamp-1">{item.productName}</h3>
                          <p className="text-[11px] font-medium text-[#64748b]">{item.unitName}</p>
                          <div className="mt-1 flex items-baseline gap-2">
                            <span className="text-sm font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                              {formatCurrency(item.price * item.quantity)}
                            </span>
                            {item.quantity > 1 && (
                              <span className="text-[10px] text-[#64748b]">
                                ({formatCurrency(item.price)} each)
                              </span>
                            )}
                          </div>
                        </div>
                      </div>

                      <div className="flex items-center gap-2 bg-[#f3f3f6] border border-[#e2e2e5] rounded-xl px-2 py-1">
                        <button
                          onClick={() => changeQty(item.id, item.quantity, -1)}
                          disabled={updateItem.isPending}
                          className="w-7 h-7 flex items-center justify-center rounded-lg hover:bg-slate-200 text-[#191c1e] transition disabled:opacity-40"
                          aria-label="Decrease quantity"
                        >
                          <Minus className="w-3.5 h-3.5" />
                        </button>
                        <span className="text-xs font-extrabold text-[#191c1e] w-6 text-center">{item.quantity}</span>
                        <button
                          onClick={() => changeQty(item.id, item.quantity, 1)}
                          disabled={updateItem.isPending}
                          className="w-7 h-7 flex items-center justify-center rounded-lg hover:bg-slate-200 text-[#191c1e] transition disabled:opacity-40"
                          aria-label="Increase quantity"
                        >
                          <Plus className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </div>

                    {/* Substitution Hint */}
                    {topSubstitute && (
                      <div className="pt-2 border-t border-[#f1f1f3] flex items-center justify-between text-[11px]">
                        <span className="text-[#64748b] flex items-center gap-1">
                          <RefreshCw className="w-3 h-3 text-[#2d9d43]" />
                          <span>Alternative: <strong className="text-[#191c1e]">{topSubstitute.name}</strong> ({formatCurrency(topSubstitute.price)})</span>
                        </span>
                        <button
                          onClick={() =>
                            handleSwapWithSubstitute(item.id, {
                              variantId: topSubstitute.variantId,
                              name: topSubstitute.name,
                              unitName: topSubstitute.unitName,
                              price: topSubstitute.price,
                            })
                          }
                          disabled={swappingItemId === item.id}
                          className="text-[11px] font-bold text-[#2d9d43] hover:text-[#078730] hover:underline"
                        >
                          {swappingItemId === item.id ? 'Swapping…' : 'Swap with Alternative'}
                        </button>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>

            {/* Delivery Instructions / Notes */}
            <div className="bg-white border border-[#e2e2e5] p-4 rounded-2xl shadow-xs space-y-2">
              <div className="flex items-center gap-2">
                <FileText className="w-4 h-4 text-[#2d9d43]" />
                <h3 className="text-xs font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  Delivery Instructions for Rider
                </h3>
              </div>
              <input
                type="text"
                value={deliveryNotes}
                onChange={(e) => setDeliveryNotes(e.target.value)}
                placeholder="e.g. Leave bag at door, ring bell twice, call on arrival..."
                className="w-full bg-[#f9f9fc] border border-[#e2e2e5] rounded-xl px-3 py-2 text-xs text-[#191c1e] placeholder-[#94a3b8] focus:outline-none focus:border-[#2d9d43] transition"
              />
            </div>

            {/* Before You Checkout / Cross-Sell Addons */}
            {cartRecommendations.length > 0 && (
              <div className="bg-white border border-[#e2e2e5] p-4 sm:p-5 rounded-2xl space-y-3 shadow-xs">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Sparkles className="w-4 h-4 text-amber-500" />
                    <div>
                      <h3 className="text-xs sm:text-sm font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                        Complete Your Basket
                      </h3>
                      <p className="text-[11px] text-[#64748b]">Popular grocery additions frequently bought together</p>
                    </div>
                  </div>
                  <span className="text-[10px] font-extrabold text-[#15803d] bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-full">
                    Quick Add
                  </span>
                </div>

                <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-none pt-1">
                  {cartRecommendations.map((prod) => (
                    <div
                      key={prod.id}
                      className="min-w-[140px] max-w-[140px] bg-[#f9f9fc] border border-[#e2e2e5] rounded-xl p-2.5 flex flex-col justify-between hover:border-[#2d9d43] transition group shrink-0"
                    >
                      <Link href={`/product/${prod.id}`} className="block">
                        <div className="w-full h-20 bg-white rounded-lg overflow-hidden flex items-center justify-center mb-1.5 p-1 border border-[#eceef0]">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img
                            src={normalizeImagePath(prod.image)}
                            alt={prod.name}
                            className="max-h-full max-w-full object-contain group-hover:scale-105 transition duration-300"
                          />
                        </div>
                        <h4 className="text-[11px] font-bold text-[#191c1e] line-clamp-2 leading-tight">
                          {prod.name}
                        </h4>
                        <p className="text-[10px] text-[#64748b] mt-0.5">{prod.unitName}</p>
                      </Link>

                      <div className="mt-2 pt-2 border-t border-[#eceef0] flex items-center justify-between">
                        <span className="text-xs font-extrabold text-[#191c1e]">{formatCurrency(prod.price)}</span>
                        <button
                          onClick={() => {
                            addItem.mutate({
                              variantId: prod.variantId || `var_${prod.id}`,
                              productName: prod.name,
                              unitName: prod.unitName,
                              price: prod.price,
                              quantity: 1,
                            });
                          }}
                          disabled={addItem.isPending}
                          className="w-6 h-6 bg-[#2d9d43] hover:bg-[#078730] active:scale-95 text-white rounded-lg flex items-center justify-center font-bold text-xs shadow-xs transition"
                          title="Add to basket"
                        >
                          <Plus className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Coupons Section */}
            <div className="bg-white border border-[#e2e2e5] p-4 rounded-2xl space-y-3 shadow-xs">
              <div className="flex items-center gap-2">
                <Tag className="w-4 h-4 text-[#2d9d43]" />
                <h3 className="text-xs sm:text-sm font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  Store Coupons & Offers
                </h3>
              </div>

              {/* Coupon Chips */}
              <div className="flex flex-wrap gap-2">
                {POPULAR_COUPONS.map((cp) => (
                  <button
                    key={cp.code}
                    onClick={() => handleApplyCoupon(cp.code)}
                    disabled={couponLoading || appliedCoupon?.code === cp.code}
                    className={`text-[11px] font-bold px-2.5 py-1.5 rounded-lg border transition text-left flex items-center gap-1.5 ${
                      appliedCoupon?.code === cp.code
                        ? 'bg-emerald-50 border-emerald-300 text-[#15803d]'
                        : 'bg-[#f9f9fc] border-[#e2e2e5] text-slate-700 hover:border-[#2d9d43]'
                    }`}
                  >
                    <span>🏷️ {cp.code}</span>
                    <span className="text-[10px] text-[#64748b] hidden sm:inline">({cp.desc})</span>
                  </button>
                ))}
              </div>

              {appliedCoupon ? (
                <div className="flex items-center justify-between p-2.5 bg-emerald-50 border border-emerald-200 rounded-xl">
                  <p className="text-xs text-[#15803d] font-bold flex items-center gap-1">
                    <Check className="w-3.5 h-3.5" />
                    <span>Applied: {appliedCoupon.code} (Saved {formatCurrency(appliedCoupon.discount)})</span>
                  </p>
                  <button onClick={removeCoupon} className="text-xs font-bold text-rose-600 hover:underline">
                    Remove
                  </button>
                </div>
              ) : (
                <div className="flex gap-2">
                  <input
                    type="text"
                    value={couponCode}
                    onChange={(e) => setCouponCode(e.target.value.toUpperCase())}
                    placeholder="Enter coupon code (e.g. SAVE50)"
                    className="flex-1 bg-[#f9f9fc] border border-[#e2e2e5] rounded-xl px-3 py-2 text-xs text-[#191c1e] placeholder-[#94a3b8] focus:outline-none focus:border-[#2d9d43]"
                  />
                  <button
                    onClick={() => handleApplyCoupon()}
                    disabled={couponLoading || !couponCode.trim()}
                    className="px-4 py-2 bg-[#2d9d43] hover:bg-[#078730] disabled:opacity-50 text-white text-xs font-bold rounded-xl transition flex items-center gap-1 shadow-xs"
                  >
                    {couponLoading ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : null} Apply
                  </button>
                </div>
              )}
              {couponError && <p className="text-xs font-medium text-rose-600">{couponError}</p>}
            </div>

            {/* Bill Breakdown Summary */}
            <div className="bg-white border border-[#e2e2e5] p-4 sm:p-5 rounded-2xl space-y-2.5 shadow-xs">
              <h3 className="text-xs sm:text-sm font-extrabold text-[#191c1e] mb-2" style={{ fontFamily: 'Outfit' }}>
                Bill Summary
              </h3>
              <div className="flex justify-between text-xs text-[#64748b]">
                <span>Item Total (MRP)</span>
                <span>{formatCurrency(summary.mrpTotal)}</span>
              </div>
              {summary.productDiscounts > 0 && (
                <div className="flex justify-between text-xs text-[#15803d] font-semibold">
                  <span>Product Discount Savings</span>
                  <span>-{formatCurrency(summary.productDiscounts)}</span>
                </div>
              )}
              <div className="flex justify-between text-xs text-[#64748b]">
                <span>Express Delivery Fee</span>
                <span>
                  {summary.deliveryFee === 0 ? (
                    <strong className="text-[#15803d]">FREE</strong>
                  ) : (
                    formatCurrency(summary.deliveryFee)
                  )}
                </span>
              </div>
              <div className="flex justify-between text-xs text-[#64748b]">
                <span>Handling & Store Packing Fee</span>
                <span>{formatCurrency(summary.platformFee + summary.packagingCharges)}</span>
              </div>
              <div className="flex justify-between text-xs text-[#64748b]">
                <span>GST Tax (5%)</span>
                <span>{formatCurrency(summary.taxGst)}</span>
              </div>
              {appliedCoupon && (
                <div className="flex justify-between text-xs text-[#15803d] font-bold">
                  <span>Coupon Discount ({appliedCoupon.code})</span>
                  <span>-{formatCurrency(appliedCoupon.discount)}</span>
                </div>
              )}
              <div className="border-t border-[#eceef0] pt-2.5 flex justify-between items-baseline">
                <div>
                  <span className="text-sm font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                    To Pay
                  </span>
                  <span className="text-[10px] text-[#64748b] block">Inclusive of all taxes</span>
                </div>
                <span className="text-xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  {formatCurrency(grandTotal)}
                </span>
              </div>
            </div>

            <div className="flex justify-between items-center px-1">
              <button
                onClick={() => {
                  if (confirm('Are you sure you want to clear all items in your cart?')) {
                    clear.mutate();
                  }
                }}
                disabled={clear.isPending}
                className="text-xs font-semibold text-rose-600 hover:text-rose-700 flex items-center gap-1 transition"
              >
                <Trash2 className="w-3.5 h-3.5" />
                <span>Clear cart</span>
              </button>
              <div className="flex items-center gap-1.5 text-[11px] text-[#64748b]">
                <Clock className="w-3.5 h-3.5 text-[#2d9d43]" />
                <span>100% Quality & Freshness Guarantee</span>
              </div>
            </div>
          </div>
        )}

        {/* Sticky Checkout Footer Bar */}
        {!isLoading && !isError && activeItems.length > 0 && (
          <div className="fixed bottom-0 left-0 right-0 z-40 bg-white/95 backdrop-blur-xl border-t border-[#e2e2e5] p-3 sm:p-4 shadow-xl">
            <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
              <div>
                <p className="text-[11px] font-medium text-[#64748b]">Total Payable</p>
                <p className="text-xl sm:text-2xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  {formatCurrency(grandTotal)}
                </p>
              </div>
              <button
                onClick={() => {
                  const queryParams = new URLSearchParams();
                  if (appliedCoupon) queryParams.set('coupon', appliedCoupon.code);
                  if (deliveryNotes.trim()) queryParams.set('notes', encodeURIComponent(deliveryNotes.trim()));
                  router.push(`/checkout?${queryParams.toString()}`);
                }}
                className="flex-1 max-w-xs py-3 bg-[#2d9d43] hover:bg-[#078730] text-white text-xs sm:text-sm font-bold rounded-xl shadow-md flex items-center justify-center gap-2 transition active:scale-95"
              >
                <span>Proceed to Checkout</span>
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
