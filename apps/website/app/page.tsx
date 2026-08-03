'use client';

import React, { useState } from 'react';
import { formatCurrency } from '@daily-basket/shared-utils';

// ─── Google Stitch Design System Tokens ─────────────────────────────────────
// Primary: #006b23 | Surface: #f9f9fc | on-Surface: #1a1c1e
// Outfit (headlines) + Inter (body) | Rounded-lg cards | Glassmorphism header

interface Product {
  id: string;
  name: string;
  unitName: string;
  price: number;
  mrp: number;
  tag?: string;
  image: string;
}

interface Category {
  id: string;
  name: string;
  emoji: string;
  count: string;
  color: string;
}

const categories: Category[] = [
  { id: 'c1', name: 'Fresh Produce', emoji: '🥬', count: '45 items', color: 'bg-secondary-container' },
  { id: 'c2', name: 'Dairy & Eggs',  emoji: '🥛', count: '28 items', color: 'bg-secondary-container' },
  { id: 'c3', name: 'Beverages',     emoji: '🧃', count: '32 items', color: 'bg-secondary-container' },
  { id: 'c4', name: 'Snacks',        emoji: '🥨', count: '50 items', color: 'bg-secondary-container' },
  { id: 'c5', name: 'Bakery',        emoji: '🍞', count: '20 items', color: 'bg-secondary-container' },
  { id: 'c6', name: 'Staples',       emoji: '🌾', count: '60 items', color: 'bg-secondary-container' },
];

const flashDeals: Product[] = [
  {
    id: 'p1',
    name: 'Organic Farm Tomatoes',
    unitName: '500g',
    price: 24,
    mrp: 40,
    tag: '40% OFF',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
  },
  {
    id: 'p2',
    name: 'Amul Taaza Toned Milk',
    unitName: '1 Litre',
    price: 54,
    mrp: 56,
    image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80',
  },
  {
    id: 'p3',
    name: 'Brown Sandwich Bread',
    unitName: '400g',
    price: 45,
    mrp: 50,
    tag: '10% OFF',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
  },
  {
    id: 'p4',
    name: 'Alphonso Mangoes',
    unitName: '1 kg',
    price: 299,
    mrp: 450,
    tag: '33% OFF',
    image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
  },
];

// ─── Product Card Component ──────────────────────────────────────────────────
function ProductCard({
  product,
  qty,
  onAdd,
  onRemove,
}: {
  product: Product;
  qty: number;
  onAdd: () => void;
  onRemove: () => void;
}) {
  const discount = Math.round(((product.mrp - product.price) / product.mrp) * 100);

  return (
    <div className="product-card flex-shrink-0 w-44 flex flex-col relative">
      {/* Tag pill */}
      {product.tag && (
        <span className="absolute top-2 left-2 z-10 bg-primary text-on-primary font-label-md text-label-md px-2 py-0.5 rounded-full text-[10px]">
          {product.tag}
        </span>
      )}

      {/* Product image */}
      <div className="relative w-full aspect-square bg-surface-container-low rounded-t-lg overflow-hidden">
        <img
          src={product.image}
          alt={product.name}
          className="w-full h-full object-cover"
        />
      </div>

      {/* Info */}
      <div className="p-sm flex-1 flex flex-col gap-xs">
        <p className="font-body-sm text-body-sm text-on-surface-variant">{product.unitName}</p>
        <h3 className="font-body-lg text-body-lg font-medium text-on-surface leading-snug line-clamp-2" style={{ fontFamily: 'Outfit' }}>
          {product.name}
        </h3>

        <div className="flex items-baseline gap-xs mt-auto">
          <span className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>
            {formatCurrency(product.price)}
          </span>
          {product.mrp > product.price && (
            <span className="font-body-sm text-body-sm text-on-surface-variant line-through text-xs">
              {formatCurrency(product.mrp)}
            </span>
          )}
        </div>
      </div>

      {/* Add / Qty toggle */}
      <div className="px-sm pb-sm">
        {qty === 0 ? (
          <button
            onClick={onAdd}
            aria-label={`Add ${product.name} to cart`}
            className="w-full h-9 bg-primary text-on-primary rounded-full font-label-md text-label-md
                       hover:bg-surface-tint active:scale-95 transition-all duration-200 shadow-level-1
                       flex items-center justify-center gap-1"
          >
            <span className="text-lg leading-none">+</span> Add
          </button>
        ) : (
          <div className="qty-toggle justify-between w-full">
            <button
              onClick={onRemove}
              aria-label="Remove one"
              className="w-7 h-7 rounded-full bg-surface-container-lowest text-primary font-bold
                         flex items-center justify-center hover:bg-outline-variant/30 transition-colors"
            >
              −
            </button>
            <span className="font-label-md text-label-md text-on-surface min-w-[20px] text-center">
              {qty}
            </span>
            <button
              onClick={onAdd}
              aria-label="Add one"
              className="w-7 h-7 rounded-full bg-primary text-on-primary font-bold
                         flex items-center justify-center hover:bg-surface-tint transition-colors"
            >
              +
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

// ─── Home Page ───────────────────────────────────────────────────────────────
export default function HomePage() {
  const [cartItems, setCartItems] = useState<Record<string, number>>({});
  const [searchQuery, setSearchQuery] = useState('');
  const [activeTab, setActiveTab] = useState('home');

  const updateQty = (id: string, delta: number) => {
    setCartItems((prev) => {
      const current = prev[id] || 0;
      const updated = Math.max(0, current + delta);
      if (updated === 0) {
        const { [id]: _, ...rest } = prev;
        return rest;
      }
      return { ...prev, [id]: updated };
    });
  };

  const totalCartCount = Object.values(cartItems).reduce((a, b) => a + b, 0);

  return (
    <div className="min-h-screen bg-background text-on-background pb-24 max-w-mobile mx-auto relative">

      {/* ─── Sticky Glass Header ─────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 glass-header shadow-level-1 px-margin-mobile py-sm border-b border-outline-variant/20">

        {/* Top bar: location + avatar */}
        <div className="flex items-center justify-between mb-sm">
          <div className="flex items-center gap-sm">
            {/* 10 min badge */}
            <div className="flex items-center gap-1 px-sm py-xs rounded-full bg-primary/10 border border-primary/20">
              <svg className="w-3.5 h-3.5 text-primary" viewBox="0 0 24 24" fill="currentColor">
                <path d="M11 1v2H9C5.13 3 2 6.13 2 10s3.13 7 7 7h1v2H9C3.48 19 0 14.97 0 10S3.48 1 9 1h2zm2 0h2c5.52 0 9 4.03 9 9s-3.48 9-9 9h-2v-2h2c3.87 0 7-3.13 7-7s-3.13-7-7-7h-2V1zm-1 4v6l4 2-1 2-5-2.5V5h2z"/>
              </svg>
              <span className="font-label-md text-label-md text-primary font-bold">10 MINS</span>
            </div>

            {/* Location */}
            <button className="flex flex-col cursor-pointer text-left">
              <span className="font-label-md text-label-md text-on-surface-variant">Delivery to 📍</span>
              <span className="font-body-sm text-body-sm font-semibold text-on-surface truncate max-w-[160px]" style={{ fontFamily: 'Outfit' }}>
                Koramangala 4th Block, Bengaluru
              </span>
            </button>
          </div>

          {/* Brand Logo Avatar */}
          <div className="w-9 h-9 rounded-full bg-surface-container-lowest border border-outline-variant/30 flex items-center justify-center overflow-hidden p-1 shadow-level-1">
            <img src="/images/daily_basket_logo.png" alt="Daily Basket Logo" className="w-full h-full object-contain" />
          </div>
        </div>

        {/* Search bar */}
        <div className="relative">
          <svg className="w-4 h-4 text-on-surface-variant absolute left-md top-1/2 -translate-y-1/2" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}>
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
          </svg>
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder='Search "milk", "tomatoes", "bread"...'
            className="input-field pl-10 pr-10"
          />
          <button className="absolute right-md top-1/2 -translate-y-1/2 text-primary">
            <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3zm6.25 8.85a.75.75 0 0 0-1.5 0 4.75 4.75 0 0 1-9.5 0 .75.75 0 0 0-1.5 0 6.25 6.25 0 0 0 5.5 6.21V18h-2a.75.75 0 0 0 0 1.5h5.5a.75.75 0 0 0 0-1.5h-2v-1.94A6.25 6.25 0 0 0 18.25 9.85z"/>
            </svg>
          </button>
        </div>

        {/* Flash deal banner strip */}
        <div className="mt-sm -mx-margin-mobile px-margin-mobile bg-primary/5 py-xs flex items-center gap-sm overflow-x-auto scrollbar-none">
          <span className="font-label-md text-label-md text-primary whitespace-nowrap">⚡ Flash Deal</span>
          <span className="font-body-sm text-body-sm text-on-surface-variant whitespace-nowrap">40% OFF on Farm Tomatoes</span>
        </div>
      </header>

      {/* ─── Hero Banner ─────────────────────────────────────────────────── */}
      <section className="mx-margin-mobile mt-md rounded-xl overflow-hidden relative bg-primary shadow-level-2">
        <div className="absolute top-0 left-0 w-full h-full opacity-10 blob-primary" />
        <div className="relative z-10 p-md">
          <p className="font-label-md text-label-md text-on-primary/70 uppercase tracking-wider mb-xs">
            Farm Fresh Vegetables
          </p>
          <h1 className="font-headline-lg-mobile text-headline-lg-mobile text-on-primary mb-sm" style={{ fontFamily: 'Outfit' }}>
            Delivered in 10 Mins
          </h1>
          <p className="font-body-sm text-body-sm text-on-primary/80 mb-md">
            Directly from local farms to your doorstep.
          </p>
          <button className="bg-surface-container-lowest text-primary font-label-md text-label-md px-lg py-sm rounded-full hover:bg-surface-container-low transition-colors shadow-level-1 active:scale-95">
            Shop Now
          </button>
        </div>
        <div className="absolute right-0 bottom-0 w-48 h-40 rounded-tl-3xl overflow-hidden">
          <img
            src="/illustrations/web_hero_banner_3d.png"
            alt="3D Fresh vegetables hero illustration"
            className="w-full h-full object-contain drop-shadow-lg"
          />
        </div>
      </section>

      {/* ─── Categories ──────────────────────────────────────────────────── */}
      <section className="mt-lg">
        <div className="flex items-center justify-between px-margin-mobile mb-sm">
          <h2 className="font-headline-lg-mobile text-headline-lg-mobile text-on-surface" style={{ fontFamily: 'Outfit' }}>
            Explore Categories
          </h2>
          <button className="font-label-md text-label-md text-primary flex items-center gap-xs hover:opacity-80">
            See All
            <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.5}>
              <path d="m9 18 6-6-6-6"/>
            </svg>
          </button>
        </div>

        <div className="flex gap-sm px-margin-mobile overflow-x-auto scrollbar-none pb-sm">
          {categories.map((cat) => (
            <button
              key={cat.id}
              className="flex-shrink-0 flex flex-col items-center gap-xs bg-surface-container-lowest
                         rounded-lg p-sm shadow-level-1 w-20 hover:shadow-level-2 active:scale-95
                         transition-all duration-200 border border-outline-variant/10"
            >
              <span className="text-3xl">{cat.emoji}</span>
              <span className="font-label-md text-label-md text-on-surface text-center leading-tight">
                {cat.name}
              </span>
              <span className="font-label-md text-[10px] text-on-surface-variant">{cat.count}</span>
            </button>
          ))}
        </div>
      </section>

      {/* ─── Flash Deals ─────────────────────────────────────────────────── */}
      <section className="mt-lg">
        <div className="flex items-center justify-between px-margin-mobile mb-sm">
          <div className="flex items-center gap-xs">
            <span className="text-lg">⚡</span>
            <h2 className="font-headline-lg-mobile text-headline-lg-mobile text-on-surface" style={{ fontFamily: 'Outfit' }}>
              Flash Deals
            </h2>
          </div>
          <button className="font-label-md text-label-md text-primary flex items-center gap-xs hover:opacity-80">
            See All
            <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.5}>
              <path d="m9 18 6-6-6-6"/>
            </svg>
          </button>
        </div>

        <div className="flex gap-md px-margin-mobile overflow-x-auto scrollbar-none pb-sm">
          {flashDeals.map((product) => (
            <ProductCard
              key={product.id}
              product={product}
              qty={cartItems[product.id] || 0}
              onAdd={() => updateQty(product.id, 1)}
              onRemove={() => updateQty(product.id, -1)}
            />
          ))}
        </div>
      </section>

      {/* ─── Feature Highlights Strip ────────────────────────────────────── */}
      <section className="mt-lg mx-margin-mobile rounded-xl bg-secondary-container/30 p-md">
        <div className="grid grid-cols-3 gap-md text-center">
          {[
            { icon: '🌿', label: 'Farm Fresh' },
            { icon: '⚡', label: '10 Min Delivery' },
            { icon: '🔒', label: 'Secure Pay' },
          ].map((feat) => (
            <div key={feat.label} className="flex flex-col items-center gap-xs">
              <span className="text-2xl">{feat.icon}</span>
              <span className="font-label-md text-label-md text-on-surface-variant">{feat.label}</span>
            </div>
          ))}
        </div>
      </section>

      {/* ─── Bottom Navigation Bar (Glassmorphism) ──────────────────────── */}
      <nav className="bottom-nav" aria-label="Main navigation">
        {[
          { id: 'home',   label: 'Home',       icon: '🏠' },
          { id: 'search', label: 'Search',      icon: '🔍' },
          { id: 'orders', label: 'Orders',      icon: '📦' },
          { id: 'profile',label: 'Profile',     icon: '👤' },
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`bottom-nav-item ${activeTab === tab.id ? 'active' : ''}`}
            aria-label={tab.label}
            aria-current={activeTab === tab.id ? 'page' : undefined}
          >
            {activeTab === tab.id ? (
              <span className="bottom-nav-pill flex items-center justify-center">
                <span className="text-lg">{tab.icon}</span>
              </span>
            ) : (
              <span className="text-lg">{tab.icon}</span>
            )}
            <span className="font-label-md text-label-md text-[10px]">{tab.label}</span>
          </button>
        ))}

        {/* Cart FAB */}
        {totalCartCount > 0 && (
          <div className="fixed bottom-20 right-4 z-50">
            <button className="bg-primary text-on-primary w-14 h-14 rounded-full shadow-level-3
                               flex items-center justify-center flex-col hover:bg-surface-tint
                               active:scale-95 transition-all duration-200">
              <span className="text-xl">🛒</span>
              <span className="font-label-md text-label-md text-[10px] font-bold">{totalCartCount}</span>
            </button>
          </div>
        )}
      </nav>
    </div>
  );
}
