'use client';

import React, { useState } from 'react';
import {
  MapPin,
  Search,
  Mic,
  Zap,
  ShoppingBag,
  Plus,
  Minus,
  Sparkles,
  Flame,
  ChevronRight,
  Home,
  Grid,
  Tag,
  User,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function HomePage() {
  const [cartItems, setCartItems] = useState<Record<string, number>>({});
  const [searchQuery, setSearchQuery] = useState('');

  const categories = [
    { id: 'c1', name: 'Fresh Produce', icon: '🥬', count: '45 Items' },
    { id: 'c2', name: 'Dairy & Eggs', icon: '🥛', count: '28 Items' },
    { id: 'c3', name: 'Beverages', icon: '🧃', count: '32 Items' },
    { id: 'c4', name: 'Snacks & Chips', icon: '🥨', count: '50 Items' },
    { id: 'c5', name: 'Bakery & Bread', icon: '🍞', count: '20 Items' },
  ];

  const flashDeals = [
    {
      id: 'p1',
      name: 'Organic Farm Tomatoes',
      unitName: '500g',
      price: 24,
      mrp: 40,
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
      image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    },
    {
      id: 'p4',
      name: 'Alphonso Mangoes',
      unitName: '1 kg',
      price: 299,
      mrp: 450,
      image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
    },
  ];

  const updateQuantity = (id: string, delta: number) => {
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
    <div className="min-h-screen bg-slate-900 text-slate-100 pb-24">
      {/* Sticky Header */}
      <header className="sticky top-0 z-40 bg-slate-900/90 backdrop-blur-md border-b border-slate-800 px-4 py-3">
        <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 font-bold text-xs">
              <Zap className="w-3.5 h-3.5 fill-emerald-400" />
              <span>10 MINS</span>
            </div>
            <div className="cursor-pointer">
              <div className="flex items-center gap-1 text-slate-400 text-xs font-medium">
                <span>Delivery to</span>
                <MapPin className="w-3 h-3 text-emerald-400" />
              </div>
              <p className="text-white text-xs font-bold truncate max-w-[180px] sm:max-w-xs">
                Koramangala 4th Block, Bengaluru
              </p>
            </div>
          </div>

          <div className="w-9 h-9 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center text-slate-300 font-bold text-xs">
            DB
          </div>
        </div>

        {/* Search Bar */}
        <div className="max-w-4xl mx-auto mt-3 relative">
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder='Search "milk", "tomatoes", "bread"...'
            className="w-full bg-slate-800/90 border border-slate-700/60 focus:border-emerald-500 rounded-xl py-2.5 pl-10 pr-10 text-sm text-white placeholder-slate-400 outline-none transition"
          />
          <Mic className="w-4 h-4 text-emerald-400 absolute right-3.5 top-1/2 -translate-y-1/2 cursor-pointer hover:opacity-80" />
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 mt-4 space-y-6">
        {/* Banner Carousel */}
        <div className="relative rounded-2xl overflow-hidden bg-gradient-to-r from-emerald-700 to-teal-900 p-6 border border-emerald-500/30 shadow-xl">
          <div className="relative z-10 max-w-xs">
            <span className="bg-lime-400 text-slate-950 font-black text-[10px] uppercase px-2 py-0.5 rounded-full inline-block mb-2">
              Flash Deal 40% OFF
            </span>
            <h2 className="text-xl sm:text-2xl font-black text-white leading-tight mb-2">
              Farm Fresh Vegetables Delivered in 10 Mins
            </h2>
            <p className="text-emerald-100 text-xs mb-4">Directly from local farms to your doorstep.</p>
            <button className="px-4 py-2 bg-white text-emerald-950 font-bold rounded-xl text-xs shadow-md hover:bg-slate-100 transition">
              Shop Now
            </button>
          </div>
          <img
            src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&q=80"
            alt="Fresh Produce"
            className="absolute right-0 top-0 bottom-0 w-1/2 object-cover opacity-60 mix-blend-overlay"
          />
        </div>

        {/* Categories Grid */}
        <section>
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-base font-bold text-white flex items-center gap-2">
              <Sparkles className="w-4 h-4 text-emerald-400" />
              <span>Explore Categories</span>
            </h3>
            <span className="text-xs text-emerald-400 font-semibold cursor-pointer flex items-center">
              View All <ChevronRight className="w-3 h-3" />
            </span>
          </div>

          <div className="grid grid-cols-5 gap-2.5">
            {categories.map((cat) => (
              <div
                key={cat.id}
                className="bg-slate-800/60 border border-slate-700/40 hover:border-emerald-500/50 rounded-xl p-3 flex flex-col items-center text-center cursor-pointer transition"
              >
                <span className="text-2xl mb-1">{cat.icon}</span>
                <span className="text-xs font-bold text-slate-200 truncate w-full">{cat.name}</span>
                <span className="text-[10px] text-slate-400">{cat.count}</span>
              </div>
            ))}
          </div>
        </section>

        {/* ⚡ Flash Deals Horizontal Carousel */}
        <section>
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-base font-bold text-white flex items-center gap-2">
              <Flame className="w-4 h-4 text-amber-400" />
              <span>⚡ 10-Min Flash Deals</span>
            </h3>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            {flashDeals.map((prod) => {
              const qty = cartItems[prod.id] || 0;
              return (
                <div
                  key={prod.id}
                  className="bg-slate-800/80 border border-slate-700/50 rounded-2xl p-3 flex flex-col justify-between hover:border-emerald-500/40 transition shadow-md"
                >
                  <div>
                    <div className="relative w-full h-28 rounded-xl overflow-hidden bg-slate-900 mb-2">
                      <img src={prod.image} alt={prod.name} className="w-full h-full object-cover" />
                      <span className="absolute top-1.5 left-1.5 bg-emerald-500 text-white font-extrabold text-[10px] px-1.5 py-0.5 rounded-md">
                        {Math.round(((prod.mrp - prod.price) / prod.mrp) * 100)}% OFF
                      </span>
                    </div>

                    <span className="text-[11px] text-slate-400 font-medium">{prod.unitName}</span>
                    <h4 className="text-xs font-bold text-slate-100 line-clamp-2 mt-0.5 mb-2">{prod.name}</h4>
                  </div>

                  <div className="flex items-center justify-between mt-1">
                    <div>
                      <span className="text-sm font-extrabold text-emerald-400">{formatCurrency(prod.price)}</span>
                      <span className="text-[10px] text-slate-500 line-through ml-1">{formatCurrency(prod.mrp)}</span>
                    </div>

                    {qty === 0 ? (
                      <button
                        onClick={() => updateQuantity(prod.id, 1)}
                        className="px-3 py-1.5 bg-emerald-600/20 hover:bg-emerald-600 border border-emerald-500/50 text-emerald-400 hover:text-white font-bold text-xs rounded-lg transition"
                      >
                        + ADD
                      </button>
                    ) : (
                      <div className="flex items-center gap-2 bg-emerald-600 text-white rounded-lg px-2 py-1">
                        <button onClick={() => updateQuantity(prod.id, -1)} className="hover:opacity-80">
                          <Minus className="w-3 h-3" />
                        </button>
                        <span className="text-xs font-bold">{qty}</span>
                        <button onClick={() => updateQuantity(prod.id, 1)} className="hover:opacity-80">
                          <Plus className="w-3 h-3" />
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </section>
      </main>

      {/* Floating Cart Bar (Appears when items are in cart) */}
      {totalCartCount > 0 && (
        <div className="fixed bottom-16 left-4 right-4 max-w-md mx-auto z-40">
          <div className="bg-emerald-600 text-white p-3.5 rounded-2xl shadow-xl shadow-emerald-900/50 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-full bg-emerald-500 flex items-center justify-center font-black text-xs">
                {totalCartCount}
              </div>
              <div>
                <p className="text-xs font-semibold text-emerald-100">{totalCartCount} Items Added</p>
                <p className="text-sm font-extrabold">Instant Delivery in 10 Mins</p>
              </div>
            </div>

            <button className="flex items-center gap-1.5 bg-white text-emerald-950 font-bold px-4 py-2 rounded-xl text-xs shadow">
              <span>View Cart</span>
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      {/* Sticky Bottom Navigation Bar */}
      <nav className="fixed bottom-0 left-0 right-0 z-50 bg-slate-900/95 backdrop-blur-lg border-t border-slate-800 py-2">
        <div className="max-w-md mx-auto flex items-center justify-around">
          <button className="flex flex-col items-center text-emerald-400">
            <Home className="w-5 h-5" />
            <span className="text-[10px] font-bold mt-1">Home</span>
          </button>
          <button className="flex flex-col items-center text-slate-400 hover:text-slate-200">
            <Grid className="w-5 h-5" />
            <span className="text-[10px] font-bold mt-1">Categories</span>
          </button>
          <button className="flex flex-col items-center text-slate-400 hover:text-slate-200">
            <Tag className="w-5 h-5" />
            <span className="text-[10px] font-bold mt-1">Offers</span>
          </button>
          <button className="flex flex-col items-center text-slate-400 hover:text-slate-200">
            <User className="w-5 h-5" />
            <span className="text-[10px] font-bold mt-1">Profile</span>
          </button>
        </div>
      </nav>
    </div>
  );
}
