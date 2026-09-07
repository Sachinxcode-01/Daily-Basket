// Google Stitch Screen ID: dc03d5c76b814f639becc038ad8805bb
// Title: Daily Basket - Premium Home Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState, useMemo } from 'react';

import Link from 'next/link';
import Image from 'next/image';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import HeaderNavBar from '../components/navigation/HeaderNavBar';
import { useCart } from '../store/useCart';

interface Product {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  unitName: string;
  price: number;
  mrp: number;
  rating?: number;
  reviews?: number;
  category: string;
  tag?: string;
  image: string;
}

// Map the real API product (with variants + category relation) to the card shape used by this view.
function mapApiProduct(p: any): Product {
  const variant =
    (Array.isArray(p?.variants) && (p.variants.find((v: any) => v?.isAvailable) ?? p.variants[0])) || null;
  return {
    id: p?.id,
    variantId: variant?.id ?? '',
    name: p?.name ?? '',
    brand: p?.brand ?? '',
    unitName: variant?.unitName ?? '',
    price: variant?.price ?? 0,
    mrp: variant?.mrp ?? variant?.price ?? 0,
    rating: typeof p?.rating === 'number' && p.rating > 0 ? p.rating : undefined,
    reviews: typeof p?.reviewCount === 'number' && p.reviewCount > 0 ? p.reviewCount : undefined,
    category: p?.category?.name ?? '',
    tag: p?.isOrganic ? 'Organic' : undefined,
    image: (Array.isArray(p?.images) && p.images[0]) || '/images/daily_basket_logo.png',
  };
}

export default function HomePage() {
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [isCartOpen, setIsCartOpen] = useState(false);

  // Live catalog from the backend (single source of truth).
  const {
    data: apiProducts,
    isLoading: productsLoading,
    isError: productsError,
    refetch: refetchProducts,
  } = useQuery({
    queryKey: ['products'],
    queryFn: () => apiClient.getProducts(),
  });

  const catalog: Product[] = useMemo(
    () => (Array.isArray(apiProducts) ? apiProducts.map(mapApiProduct) : []),
    [apiProducts],
  );

  const categoryList = useMemo(() => {
    const names = Array.from(new Set(catalog.map((p) => p.category).filter(Boolean)));
    return ['All', ...names];
  }, [catalog]);

  // Live order banner is shown only when the customer actually has an active order.
  // TODO(Batch 4): populate from the orders/tracking API + Socket.IO instead of a placeholder.
  const activeOrder: { orderNumber: string; etaMins: number; riderName: string; distanceText: string; area: string } | null = null;

  const featuredProduct = catalog[0] ?? null;

  // Backend-backed persistent cart (validated totals).
  const { activeItems, summary, itemCount, addItem, updateItem } = useCart();

  const cartItemForVariant = (variantId: string) => activeItems.find((i) => i.variantId === variantId);
  const qtyForVariant = (variantId: string) => cartItemForVariant(variantId)?.quantity ?? 0;

  const addOne = (p: Product) => {
    if (!p.variantId) return;
    const existing = cartItemForVariant(p.variantId);
    if (existing) {
      updateItem.mutate({ itemId: existing.id, quantity: existing.quantity + 1 });
    } else {
      addItem.mutate({ variantId: p.variantId, productName: p.name, unitName: p.unitName, price: p.price, quantity: 1 });
    }
  };

  const removeOne = (p: Product) => {
    const existing = cartItemForVariant(p.variantId);
    if (existing) updateItem.mutate({ itemId: existing.id, quantity: existing.quantity - 1 });
  };

  const filteredProducts = catalog.filter((p) => {
    const matchesCat = selectedCategory === 'All' || p.category === selectedCategory;
    const matchesSearch = searchQuery === '' || p.name.toLowerCase().includes(searchQuery.toLowerCase()) || p.brand.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCat && matchesSearch;
  });

  const totalCartCount = itemCount;

  return (
    <div className="min-h-screen bg-background text-on-background font-body-lg antialiased pb-24 relative">

      {/* ─── Sticky Header Navbar ─────────────────────────────────────────── */}
      <HeaderNavBar
        cartCount={totalCartCount}
        onSearch={(q) => setSearchQuery(q)}
        onCartClick={() => setIsCartOpen(true)}
      />

      {/* ─── Main Desktop Storefront Canvas (1440px max) ───────────────────── */}
      <main className="max-w-[1440px] mx-auto px-margin-mobile md:px-margin-desktop space-y-12 pt-6">

        {/* ─── Live Order Tracker Alert Strip (only when a live order exists) ─────── */}
        {activeOrder && (
        <section className="bg-gradient-to-r from-emerald-900 to-[#006b23] text-white rounded-2xl p-4 shadow-level-1 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center text-xl animate-pulse">
              🛵
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xs font-extrabold uppercase tracking-wider bg-emerald-400 text-emerald-950 px-2 py-0.5 rounded-full">
                  LIVE ORDER #{activeOrder.orderNumber}
                </span>
                <span className="text-xs text-emerald-200">ETA: {activeOrder.etaMins} Mins</span>
              </div>
              <p className="text-sm font-semibold font-outfit mt-0.5">
                Rider {activeOrder.riderName} is {activeOrder.distanceText} away from your door • {activeOrder.area}
              </p>
            </div>
          </div>
          <Link href="/tracking" className="bg-white text-[#006b23] font-bold text-xs px-5 py-2.5 rounded-full hover:bg-emerald-50 transition-all shadow-md">
            Track Live Map →
          </Link>
        </section>
        )}

        {/* ─── Hero Section ────────────────────────────────────────────────── */}
        <section className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          
          {/* Main Hero Card with full-card background image */}
          <div className="lg:col-span-8 rounded-3xl p-8 sm:p-10 shadow-level-2 relative overflow-hidden min-h-[340px] flex items-center">
            
            {/* Full Card Background Image */}
            <Image
              src="/illustrations/web_hero_banner_3d.png"
              alt="Fresh Produce Background"
              fill
              unoptimized
              className="object-cover object-right z-0 transform hover:scale-105 transition-transform duration-700"
            />

            {/* Dark Green Gradient Overlay for crisp text contrast */}
            <div className="absolute inset-0 bg-gradient-to-r from-[#006b23] via-[#006b23]/90 sm:via-[#006b23]/80 to-[#006b23]/40 sm:to-transparent z-0" />

            {/* Hero Card Content */}
            <div className="space-y-4 max-w-lg text-center sm:text-left z-10 relative">
              <span className="inline-block px-3.5 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider text-white shadow-sm border border-white/20">
                🥬 FARM FRESH PRODUCE & KIRANA
              </span>
              <h1 className="text-3xl sm:text-5xl font-extrabold font-outfit leading-tight text-white drop-shadow-sm">
                Delivered in <span className="text-emerald-300">10 Mins</span>
              </h1>
              <p className="text-white/95 text-xs sm:text-sm font-inter leading-relaxed max-w-md drop-shadow-sm">
                Directly harvested from local organic farms to your doorstep. Unbeatable prices & 100% fresh guarantee.
              </p>
              <div className="pt-2 flex flex-wrap gap-3 justify-center sm:justify-start">
                <button
                  onClick={() => setSelectedCategory('Dairy')}
                  className="bg-white text-[#006b23] font-bold text-xs px-6 py-3 rounded-full hover:bg-emerald-50 transition-all shadow-lg active:scale-95"
                >
                  Shop Fresh Milk & Dairy
                </button>
                <Link
                  href="/freshness"
                  className="bg-black/30 hover:bg-black/40 backdrop-blur-md text-white font-medium text-xs px-5 py-3 rounded-full transition-all border border-white/30 shadow-md"
                >
                  Trace Harvest Origin →
                </Link>
              </div>
            </div>
          </div>

          {/* Quick Buy Essentials + DB Plus Pass Card */}
          <div className="lg:col-span-4 flex flex-col justify-between gap-6">
            
            {/* DB Plus VIP Pass Banner */}
            <div className="bg-gradient-to-br from-amber-500 via-amber-600 to-amber-700 text-white rounded-3xl p-6 shadow-level-2 relative overflow-hidden flex flex-col justify-between">
              <div className="flex justify-between items-start">
                <div>
                  <span className="bg-black/20 text-amber-100 font-extrabold text-[10px] uppercase px-2.5 py-1 rounded-full tracking-wider">
                    DAILY BASKET PLUS VIP
                  </span>
                  <h3 className="text-2xl font-bold font-outfit mt-2">Unlimited Free Delivery</h3>
                </div>
                <span className="text-3xl">👑</span>
              </div>
              <p className="text-amber-100 text-xs font-inter mt-2">
                Save up to ₹450 every month. Get priority picking, zero surge fees, & exclusive 15% cashback.
              </p>
              <Link href="/loyalty" className="mt-4 bg-white text-amber-900 text-xs font-bold px-4 py-2.5 rounded-full text-center hover:bg-amber-50 transition-colors shadow-md">
                Try 30 Days Free →
              </Link>
            </div>

            {/* Quick Buy Card */}
            <div className="bg-surface-container-low rounded-3xl p-6 border border-outline-variant/20 flex flex-col justify-between">
              <div className="flex justify-between items-center mb-3">
                <h4 className="font-bold text-sm font-outfit text-on-surface flex items-center gap-1.5">
                  <span>⚡</span> 1-Tap Quick Buy Essentials
                </h4>
                <Link href="/cart" className="text-xs text-primary font-bold hover:underline">Reorder All</Link>
              </div>
              {featuredProduct ? (
              <div className="flex items-center gap-3 bg-surface-container-lowest p-3 rounded-2xl border border-outline-variant/10 shadow-sm">
                <Image src={featuredProduct.image} alt={featuredProduct.name} width={48} height={48} unoptimized className="w-12 h-12 rounded-xl object-cover" />
                <div className="flex-1 min-w-0">
                  <div className="text-xs font-bold truncate">{featuredProduct.name}</div>
                  <div className="text-[10px] text-on-surface-variant">{featuredProduct.brand} • {featuredProduct.unitName}</div>
                  <div className="text-xs font-bold text-primary mt-0.5">{formatCurrency(featuredProduct.price)}</div>
                </div>
                <button
                  onClick={() => addOne(featuredProduct)}
                  className="bg-primary text-white text-xs font-bold px-3 py-1.5 rounded-full hover:bg-surface-tint active:scale-95 transition-all"
                >
                  + Add
                </button>
              </div>
              ) : (
                <div className="flex items-center justify-center bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/10 text-[11px] text-on-surface-variant">
                  Loading essentials…
                </div>
              )}
            </div>

          </div>
        </section>

        {/* ─── My Impact & Sustainability Section ────────────────────────────── */}
        <section className="bg-emerald-950 text-white rounded-3xl p-6 sm:p-8 shadow-level-2 border border-emerald-800">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6 mb-6">
            <div>
              <span className="text-xs font-extrabold uppercase tracking-wider text-emerald-400 bg-emerald-900/60 px-3 py-1 rounded-full">
                🌱 MY SUSTAINABILITY IMPACT
              </span>
              <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-white mt-2">
                Your Eco-Friendly Shopping Impact
              </h2>
            </div>
            <Link href="/about" className="text-xs text-emerald-300 font-bold hover:underline flex items-center gap-1">
              Learn about our 100% Organic Supply Chain →
            </Link>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">🚴</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">14.2 kg</div>
              <div className="text-xs text-emerald-200 font-medium">CO2 Emissions Saved</div>
            </div>
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">🛍️</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">3.8 kg</div>
              <div className="text-xs text-emerald-200 font-medium">Plastic Waste Reduced</div>
            </div>
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">👩‍🌾</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">18 Farms</div>
              <div className="text-xs text-emerald-200 font-medium">Local Farmers Supported</div>
            </div>
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">🎖️</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">Tier 3 Eco</div>
              <div className="text-xs text-emerald-200 font-medium">Sustainability Badge</div>
            </div>
          </div>
        </section>

        {/* ─── Kirana & Essentials Storefront Catalog ─────────────────────── */}
        <section className="space-y-6">
          
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface">
                Kirana & Daily Essentials Catalog
              </h2>
              <p className="text-xs sm:text-sm text-on-surface-variant">
                Showing {filteredProducts.length} items from leading Indian Kirana brands
              </p>
            </div>

            {/* Category Filter Pills */}
            <div className="flex items-center gap-2 overflow-x-auto scrollbar-none pb-2 max-w-full">
              {categoryList.map((cat) => {
                const isSelected = selectedCategory === cat;
                return (
                  <button
                    key={cat}
                    onClick={() => setSelectedCategory(cat)}
                    className={`text-xs font-bold px-4 py-2 rounded-full whitespace-nowrap transition-all duration-200 ${
                      isSelected
                        ? 'bg-primary text-white shadow-sm scale-105'
                        : 'bg-surface-container-lowest text-on-surface-variant hover:bg-surface-container-low border border-outline-variant/20'
                    }`}
                  >
                    {cat}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Loading skeleton */}
          {productsLoading && (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4 sm:gap-5">
              {Array.from({ length: 12 }).map((_, i) => (
                <div key={i} className="bg-surface-container-lowest border border-outline-variant/20 rounded-2xl p-3.5 animate-pulse">
                  <div className="w-full aspect-square bg-surface-container-low rounded-xl mb-3" />
                  <div className="h-2.5 bg-surface-container-low rounded w-1/2 mb-2" />
                  <div className="h-3 bg-surface-container-low rounded w-3/4 mb-2" />
                  <div className="h-4 bg-surface-container-low rounded w-1/3 mt-3" />
                </div>
              ))}
            </div>
          )}

          {/* Error state */}
          {productsError && (
            <div className="text-center py-16 space-y-3">
              <div className="text-4xl">⚠️</div>
              <p className="font-bold text-on-surface">Couldn&rsquo;t load the catalog</p>
              <p className="text-xs text-on-surface-variant">Please check your connection and try again.</p>
              <button
                onClick={() => refetchProducts()}
                className="mt-2 bg-primary text-white text-xs font-bold px-5 py-2.5 rounded-full hover:bg-surface-tint active:scale-95 transition-all"
              >
                Retry
              </button>
            </div>
          )}

          {/* Empty state */}
          {!productsLoading && !productsError && filteredProducts.length === 0 && (
            <div className="text-center py-16 space-y-2">
              <div className="text-4xl">🧺</div>
              <p className="font-bold text-on-surface">No products found</p>
              <p className="text-xs text-on-surface-variant">Try a different category or search term.</p>
            </div>
          )}

          {/* Product Grid (Responsive: 2-col mobile, 3-col tablet, 4-col laptop, 5-col desktop, 6-col wide) */}
          {!productsLoading && !productsError && filteredProducts.length > 0 && (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4 sm:gap-5">
            {filteredProducts.map((p) => {
              const qty = qtyForVariant(p.variantId);
              return (
                <div
                  key={p.id}
                  className="bg-surface-container-lowest border border-outline-variant/20 rounded-2xl p-3.5 flex flex-col justify-between hover:shadow-level-2 transition-all duration-300 group relative"
                >
                  {/* Tag badge */}
                  {p.tag && (
                    <span className="absolute top-3 left-3 z-10 bg-primary text-on-primary text-[10px] font-bold px-2 py-0.5 rounded-full shadow-sm">
                      {p.tag}
                    </span>
                  )}

                  <div>
                    {/* Image */}
                    <div className="relative w-full aspect-square bg-surface-container-low rounded-xl overflow-hidden mb-3">
                      <Image
                        src={p.image}
                        alt={p.name}
                        fill
                        unoptimized
                        className="object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                    </div>

                    {/* Details */}
                    <div className="text-[10px] font-bold text-primary uppercase tracking-wider">{p.brand}</div>
                    <h3 className="font-title-md text-xs sm:text-sm font-bold text-on-surface leading-tight mt-0.5 line-clamp-2" style={{ fontFamily: 'Outfit' }}>
                      {p.name}
                    </h3>
                    <div className="text-[10px] text-on-surface-variant mt-1">{p.unitName}</div>

                    {/* Rating (only when available) */}
                    {typeof p.rating === 'number' && (
                      <div className="flex items-center gap-1 mt-1.5">
                        <span className="text-amber-500 text-xs">★</span>
                        <span className="text-xs font-bold text-on-surface">{p.rating}</span>
                        {typeof p.reviews === 'number' && (
                          <span className="text-[10px] text-on-surface-variant">({(p.reviews / 1000).toFixed(1)}k)</span>
                        )}
                      </div>
                    )}
                  </div>

                  {/* Price & Add */}
                  <div className="mt-3 pt-2.5 border-t border-outline-variant/10 flex items-center justify-between">
                    <div>
                      <div className="font-title-md text-sm sm:text-base text-primary font-bold" style={{ fontFamily: 'Outfit' }}>
                        {formatCurrency(p.price)}
                      </div>
                      {p.mrp > p.price && (
                        <div className="text-[10px] text-on-surface-variant line-through">
                          {formatCurrency(p.mrp)}
                        </div>
                      )}
                    </div>

                    {qty === 0 ? (
                      <button
                        onClick={() => addOne(p)}
                        className="px-3 py-1.5 bg-primary text-white text-xs font-bold rounded-full hover:bg-surface-tint active:scale-95 transition-all shadow-sm"
                      >
                        + Add
                      </button>
                    ) : (
                      <div className="flex items-center gap-1.5 bg-primary/10 border border-primary/20 rounded-full px-1.5 py-0.5">
                        <button
                          onClick={() => removeOne(p)}
                          className="w-5 h-5 rounded-full bg-primary text-white font-bold flex items-center justify-center text-xs hover:bg-surface-tint"
                        >
                          −
                        </button>
                        <span className="text-xs font-bold text-primary min-w-[14px] text-center">
                          {qty}
                        </span>
                        <button
                          onClick={() => addOne(p)}
                          className="w-5 h-5 rounded-full bg-primary text-white font-bold flex items-center justify-center text-xs hover:bg-surface-tint"
                        >
                          +
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
          )}
        </section>

        {/* ─── Fresh Produce Traceability Banner ─────────────────────────── */}
        <section className="bg-surface-container-low border border-outline-variant/20 rounded-3xl p-8 flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="space-y-2">
            <span className="text-xs font-bold text-primary uppercase tracking-widest bg-primary/10 px-3 py-1 rounded-full">
              🔍 100% Traceable Harvest
            </span>
            <h3 className="text-2xl font-bold font-outfit text-on-surface">
              Know the exact farm and harvest time of your produce
            </h3>
            <p className="text-xs text-on-surface-variant max-w-xl">
              Every organic vegetable bag comes with a QR code showing farm soil reports, harvest time, and pesticide-free certificates.
            </p>
          </div>
          <Link
            href="/freshness"
            className="bg-primary text-white text-xs font-bold px-6 py-3 rounded-full hover:bg-surface-tint transition-all shadow-level-1 whitespace-nowrap"
          >
            Open Fresh Produce Explorer →
          </Link>
        </section>

      </main>

      {/* ─── Slide-over Interactive Cart Drawer ───────────────────────────── */}
      {isCartOpen && (
        <div className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm flex justify-end animate-fadeIn">
          <div className="w-full max-w-md bg-white h-full shadow-2xl flex flex-col justify-between overflow-hidden">
            
            {/* Header */}
            <div className="p-5 border-b border-slate-100 bg-slate-50 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-xl">🛒</span>
                <h3 className="font-bold text-lg font-outfit">Your Basket ({totalCartCount})</h3>
              </div>
              <button onClick={() => setIsCartOpen(false)} className="w-8 h-8 rounded-full bg-slate-200 text-slate-700 flex items-center justify-center font-bold hover:bg-slate-300">
                ✕
              </button>
            </div>

            {/* Items List (backend cart) */}
            <div className="p-5 overflow-y-auto flex-1 space-y-4">
              {activeItems.length === 0 ? (
                <div className="text-center py-12 text-slate-400 space-y-3">
                  <span className="text-4xl">🧺</span>
                  <p className="font-bold text-slate-600">Your basket is empty</p>
                  <button onClick={() => setIsCartOpen(false)} className="text-xs bg-[#006b23] text-white px-4 py-2 rounded-full font-bold">
                    Start Adding Items
                  </button>
                </div>
              ) : (
                activeItems.map((item) => (
                  <div key={item.id} className="flex items-center gap-3 p-3 bg-slate-50 rounded-2xl border border-slate-100">
                    <div className="w-14 h-14 rounded-xl bg-slate-100 flex items-center justify-center text-2xl">🛒</div>
                    <div className="flex-1 min-w-0">
                      <div className="text-xs font-bold truncate">{item.productName}</div>
                      <div className="text-[10px] text-slate-500">{item.unitName}</div>
                      <div className="text-xs font-bold text-[#006b23] mt-0.5">{formatCurrency(item.price * item.quantity)}</div>
                    </div>
                    <div className="flex items-center gap-2 bg-white border border-slate-200 rounded-full px-2 py-1">
                      <button onClick={() => updateItem.mutate({ itemId: item.id, quantity: item.quantity - 1 })} className="w-5 h-5 rounded-full bg-slate-100 text-slate-700 font-bold flex items-center justify-center text-xs hover:bg-slate-200">
                        −
                      </button>
                      <span className="text-xs font-bold text-[#006b23] min-w-[14px] text-center">{item.quantity}</span>
                      <button onClick={() => updateItem.mutate({ itemId: item.id, quantity: item.quantity + 1 })} className="w-5 h-5 rounded-full bg-[#006b23] text-white font-bold flex items-center justify-center text-xs">
                        +
                      </button>
                    </div>
                  </div>
                ))
              )}
            </div>

            {/* Total Footer (backend-validated) */}
            {activeItems.length > 0 && summary && (
              <div className="p-5 border-t border-slate-200 bg-slate-50 space-y-4">
                <div className="space-y-1 text-xs text-slate-600">
                  <div className="flex justify-between">
                    <span>Items Subtotal</span>
                    <span>{formatCurrency(summary.itemTotal)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Delivery Charge (10 Mins)</span>
                    <span>{summary.deliveryFee === 0 ? <span className="text-emerald-600 font-bold">FREE</span> : formatCurrency(summary.deliveryFee)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Handling & GST</span>
                    <span>{formatCurrency(summary.platformFee + summary.packagingCharges + summary.taxGst)}</span>
                  </div>
                  <div className="flex justify-between font-bold text-sm text-slate-900 pt-2 border-t border-slate-200">
                    <span>To Pay</span>
                    <span className="text-[#006b23]">{formatCurrency(summary.grandTotal)}</span>
                  </div>
                </div>

                <Link
                  href="/cart"
                  className="w-full bg-[#006b23] text-white font-bold text-sm py-3.5 rounded-full text-center block shadow-lg hover:bg-emerald-800 transition-colors"
                >
                  View Cart & Checkout ({formatCurrency(summary.grandTotal)}) →
                </Link>
                <p className="text-[10px] text-center text-slate-400">Apply coupons at checkout</p>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="bg-surface-container-low w-full border-t border-outline-variant/20 mt-16 py-10 px-margin-mobile md:px-margin-desktop">
        <div className="max-w-[1440px] mx-auto flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="flex items-center gap-2">
            <Image src="/images/daily_basket_logo.png" alt="Daily Basket Logo" width={24} height={24} className="object-contain" />
            <span className="font-title-md text-lg font-bold text-on-surface" style={{ fontFamily: 'Outfit' }}>Daily Basket</span>
          </div>
          <p className="font-body-sm text-xs text-on-surface-variant">
            © 2026 Daily Basket Inc. All rights reserved. 10-Minute Grocery Delivery Suite.
          </p>
        </div>
      </footer>
    </div>
  );
}
