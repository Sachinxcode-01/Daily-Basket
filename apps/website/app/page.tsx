'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { formatCurrency } from '@daily-basket/shared-utils';
import HeaderNavBar from '../components/navigation/HeaderNavBar';

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
    unitName: '500g Pack',
    price: 24,
    mrp: 40,
    tag: '40% OFF',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&q=80',
  },
  {
    id: 'p2',
    name: 'Amul Taaza Toned Milk',
    unitName: '1 Litre Pouch',
    price: 54,
    mrp: 56,
    image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500&q=80',
  },
  {
    id: 'p3',
    name: 'Brown Sandwich Bread',
    unitName: '400g Loaf',
    price: 45,
    mrp: 50,
    tag: '10% OFF',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&q=80',
  },
  {
    id: 'p4',
    name: 'Fresh Alphonso Mangoes',
    unitName: '1 kg Box',
    price: 299,
    mrp: 450,
    tag: '33% OFF',
    image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=500&q=80',
  },
];

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
  return (
    <div className="bg-surface-container-lowest border border-outline-variant/20 rounded-2xl p-4 flex flex-col justify-between hover:shadow-level-2 transition-all duration-300 group relative">
      {/* Tag pill */}
      {product.tag && (
        <span className="absolute top-3 left-3 z-10 bg-primary text-on-primary font-label-md text-label-md px-2.5 py-1 rounded-full text-[11px] font-bold shadow-sm">
          {product.tag}
        </span>
      )}

      <div>
        {/* Product Image */}
        <div className="relative w-full aspect-square bg-surface-container-low rounded-xl overflow-hidden mb-3">
          <img
            src={product.image}
            alt={product.name}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
          />
        </div>

        {/* Product Details */}
        <p className="font-body-sm text-xs text-on-surface-variant font-medium">{product.unitName}</p>
        <h3 className="font-title-md text-base font-bold text-on-surface leading-tight mt-1 line-clamp-2" style={{ fontFamily: 'Outfit' }}>
          {product.name}
        </h3>
      </div>

      {/* Pricing & Cart Action */}
      <div className="mt-4 pt-3 border-t border-outline-variant/10 flex items-center justify-between">
        <div>
          <span className="font-title-md text-lg text-primary font-bold" style={{ fontFamily: 'Outfit' }}>
            {formatCurrency(product.price)}
          </span>
          {product.mrp > product.price && (
            <span className="font-body-sm text-xs text-on-surface-variant line-through ml-2">
              {formatCurrency(product.mrp)}
            </span>
          )}
        </div>

        {qty === 0 ? (
          <button
            onClick={onAdd}
            aria-label={`Add ${product.name} to cart`}
            className="px-4 py-2 bg-primary text-on-primary rounded-full font-label-md text-sm font-semibold hover:bg-surface-tint active:scale-95 transition-all shadow-level-1 flex items-center gap-1.5"
          >
            <span className="text-base font-bold">+</span> Add
          </button>
        ) : (
          <div className="flex items-center gap-2 bg-primary/10 border border-primary/20 rounded-full px-2 py-1">
            <button
              onClick={onRemove}
              className="w-6 h-6 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs hover:bg-surface-tint transition-colors"
            >
              −
            </button>
            <span className="font-label-md text-sm font-bold text-primary min-w-[16px] text-center">
              {qty}
            </span>
            <button
              onClick={onAdd}
              className="w-6 h-6 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs hover:bg-surface-tint transition-colors"
            >
              +
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

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
    <div className="min-h-screen bg-background text-on-background font-body-lg antialiased pb-20">

      {/* ─── Sticky Unified Desktop Header ────────────────────────────────── */}
      <HeaderNavBar cartCount={totalCartCount} />

      {/* ─── Main Hero Canvas ────────────────────────────────────────────── */}
      <main className="max-w-[1280px] mx-auto px-margin-mobile md:px-margin-desktop space-y-12 pt-6">

        {/* Hero Section */}
        <section className="bg-primary text-on-primary rounded-3xl p-6 sm:p-10 md:p-12 shadow-level-2 relative overflow-hidden flex flex-col md:flex-row items-center justify-between gap-8">
          <div className="space-y-4 max-w-xl text-center md:text-left z-10">
            <span className="inline-block px-4 py-1.5 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider text-white">
              🌾 Farm Fresh Vegetables & Kirana
            </span>
            <h1 className="text-3xl sm:text-5xl md:text-6xl font-extrabold font-outfit leading-tight">
              Delivered in <span className="text-secondary-container">10 Mins</span>
            </h1>
            <p className="text-white/90 text-sm sm:text-base font-inter max-w-lg">
              Directly harvested from local organic farms to your kitchen counter. Crisp, fresh, and guaranteed fast.
            </p>
            <div className="pt-2 flex flex-wrap items-center justify-center md:justify-start gap-4">
              <button className="bg-surface-container-lowest text-primary font-label-md text-sm font-semibold px-8 py-3.5 rounded-full hover:bg-surface-container-low transition-all shadow-level-1 active:scale-95">
                Shop Fresh Produce
              </button>
              <Link href="/freshness" className="bg-white/10 hover:bg-white/20 text-white font-label-md text-sm font-medium px-6 py-3.5 rounded-full transition-all border border-white/20">
                Explore Farm Origins →
              </Link>
            </div>
          </div>

          <div className="w-full md:w-1/2 h-64 sm:h-80 md:h-96 relative flex items-center justify-center">
            <img
              src="/illustrations/web_hero_banner_3d.png"
              alt="Daily Basket 3D Hero Illustration"
              className="w-full h-full object-contain drop-shadow-2xl hover:scale-105 transition-transform duration-500"
            />
          </div>
        </section>

        {/* Categories Section */}
        <section className="space-y-6">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface">
                Explore Categories
              </h2>
              <p className="text-xs sm:text-sm text-on-surface-variant">Selected top picks delivered in 10 mins</p>
            </div>
            <button className="font-label-md text-sm text-primary font-bold hover:underline flex items-center gap-1">
              See All Categories →
            </button>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-4">
            {categories.map((cat) => (
              <button
                key={cat.id}
                className="bg-surface-container-lowest rounded-2xl p-5 shadow-level-1 border border-outline-variant/15
                           flex flex-col items-center gap-2 hover:shadow-level-2 hover:-translate-y-1 active:scale-95
                           transition-all duration-300 group"
              >
                <span className="text-4xl group-hover:scale-110 transition-transform">{cat.emoji}</span>
                <span className="font-title-md text-sm font-bold text-on-surface text-center mt-1" style={{ fontFamily: 'Outfit' }}>
                  {cat.name}
                </span>
                <span className="font-label-md text-xs text-on-surface-variant">{cat.count}</span>
              </button>
            ))}
          </div>
        </section>

        {/* Flash Deals Section */}
        <section className="space-y-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="text-2xl">⚡</span>
              <div>
                <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface">
                  Flash Deals
                </h2>
                <p className="text-xs sm:text-sm text-on-surface-variant">Unbeatable prices on daily essentials</p>
              </div>
            </div>
            <button className="font-label-md text-sm text-primary font-bold hover:underline flex items-center gap-1">
              View All Deals →
            </button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
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

        {/* Value Proposition Grid */}
        <section className="bg-surface-container-low rounded-3xl p-8 md:p-12 border border-outline-variant/20">
          <div className="text-center max-w-xl mx-auto mb-10">
            <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface mb-2">
              Why Urban Households Choose Daily Basket
            </h2>
            <p className="text-sm text-on-surface-variant">The quick-commerce standard built for speed and fresh quality.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-surface-container-lowest p-6 rounded-2xl shadow-level-1 border border-outline-variant/10 text-center flex flex-col items-center">
              <div className="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary font-bold text-2xl mb-4">
                ⚡
              </div>
              <h3 className="font-title-md text-lg font-bold mb-2" style={{ fontFamily: 'Outfit' }}>10-Minute Delivery</h3>
              <p className="font-body-sm text-xs text-on-surface-variant leading-relaxed">
                Hyper-local dark stores optimized to dispatch your basket within 120 seconds of tapping pay.
              </p>
            </div>

            <div className="bg-surface-container-lowest p-6 rounded-2xl shadow-level-1 border border-outline-variant/10 text-center flex flex-col items-center">
              <div className="w-14 h-14 rounded-2xl bg-secondary-container flex items-center justify-center text-primary font-bold text-2xl mb-4">
                🌿
              </div>
              <h3 className="font-title-md text-lg font-bold mb-2" style={{ fontFamily: 'Outfit' }}>100% Farm Organic</h3>
              <p className="font-body-sm text-xs text-on-surface-variant leading-relaxed">
                Direct partnerships with verified local farms. Harvest timestamps printed on every produce pack.
              </p>
            </div>

            <div className="bg-surface-container-lowest p-6 rounded-2xl shadow-level-1 border border-outline-variant/10 text-center flex flex-col items-center">
              <div className="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary font-bold text-2xl mb-4">
                🛡️
              </div>
              <h3 className="font-title-md text-lg font-bold mb-2" style={{ fontFamily: 'Outfit' }}>Zero Hassle Refunds</h3>
              <p className="font-body-sm text-xs text-on-surface-variant leading-relaxed">
                Not satisfied with produce quality? Get an instant 1-tap refund credited straight to your DB Wallet.
              </p>
            </div>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-surface-container-low w-full border-t border-outline-variant/20 mt-16 py-10 px-margin-mobile md:px-margin-desktop">
        <div className="max-w-[1280px] mx-auto flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="flex items-center gap-2">
            <img src="/images/daily_basket_logo.png" alt="Daily Basket Logo" className="w-6 h-6 object-contain" />
            <span className="font-title-md text-lg font-bold text-on-surface" style={{ fontFamily: 'Outfit' }}>Daily Basket</span>
          </div>
          <p className="font-body-sm text-xs text-on-surface-variant">
            © 2026 Daily Basket Inc. All rights reserved. 10-Minute Grocery Delivery.
          </p>
        </div>
      </footer>

      {/* ─── Mobile Glass Bottom Bar (Hidden on desktop) ─────────────────── */}
      <nav className="bottom-nav md:hidden" aria-label="Main navigation">
        {[
          { id: 'home',   label: 'Home',    icon: '🏠' },
          { id: 'search', label: 'Search',  icon: '🔍' },
          { id: 'orders', label: 'Orders',  icon: '📦' },
          { id: 'profile',label: 'Profile', icon: '👤' },
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`bottom-nav-item ${activeTab === tab.id ? 'active' : ''}`}
          >
            <span className="text-lg">{tab.icon}</span>
            <span className="font-label-md text-[10px]">{tab.label}</span>
          </button>
        ))}
      </nav>
    </div>
  );
}
