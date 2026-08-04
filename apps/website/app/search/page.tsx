'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { Search, Filter, SlidersHorizontal, Plus, Check, ArrowLeft, ShoppingBasket } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

interface SearchItem {
  id: string;
  name: string;
  weight: string;
  price: number;
  mrp: number;
  tag?: string;
  image: string;
}

const searchResults: SearchItem[] = [
  {
    id: 's1',
    name: 'Organic Farm Fresh Tomatoes',
    weight: '500g',
    price: 24,
    mrp: 40,
    tag: '40% OFF',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
  },
  {
    id: 's2',
    name: 'Fresh Cherry Tomatoes Pack',
    weight: '250g',
    price: 45,
    mrp: 60,
    tag: 'Organic',
    image: 'https://images.unsplash.com/photo-1546470427-227c7369a649?w=400&q=80',
  },
  {
    id: 's3',
    name: 'Tomato Puree Tetra Pack',
    weight: '200g',
    price: 30,
    mrp: 35,
    image: 'https://images.unsplash.com/photo-1590779033100-9f60a05a013d?w=400&q=80',
  },
  {
    id: 's4',
    name: 'Italian Sun-Dried Tomatoes',
    weight: '150g',
    price: 120,
    mrp: 150,
    tag: 'Imported',
    image: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&q=80',
  },
];

export default function SearchPage() {
  const [query, setQuery] = useState('Tomatoes');
  const [activeFilter, setActiveFilter] = useState('All');
  const [cart, setCart] = useState<Record<string, number>>({});

  const filters = ['All', 'Organic', 'On Sale', 'Under ₹50'];

  const toggleAdd = (id: string) => {
    setCart((prev) => ({
      ...prev,
      [id]: (prev[id] || 0) + 1,
    }));
  };

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Sticky Search Header ───────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-3">
        <div className="max-w-7xl mx-auto flex items-center gap-3">
          <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
            <ArrowLeft className="w-6 h-6" />
          </Link>

          <div className="relative flex-1">
            <Search className="w-5 h-5 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search groceries..."
              className="w-full h-11 bg-slate-100 border-none rounded-xl pl-11 pr-10 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:ring-2 focus:ring-[#006b23] transition"
            />
          </div>

          <button className="p-2.5 bg-slate-100 text-slate-700 rounded-xl hover:bg-slate-200 transition">
            <SlidersHorizontal className="w-5 h-5" />
          </button>
        </div>

        {/* Filter Chips Bar */}
        <div className="max-w-7xl mx-auto flex items-center gap-2 mt-3 overflow-x-auto scrollbar-none pb-1">
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                activeFilter === f
                  ? 'bg-[#006b23] text-white shadow-md shadow-[#006b23]/20'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              {f}
            </button>
          ))}
        </div>
      </header>

      {/* ─── Search Results Grid ────────────────────────────────────────── */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6">
        <div className="flex items-center justify-between mb-4">
          <p className="text-sm font-medium text-slate-500 font-inter">
            Showing <span className="font-bold text-slate-900">{searchResults.length} results</span> for &ldquo;{query}&rdquo;
          </p>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
          {searchResults.map((item) => {
            const count = cart[item.id] || 0;
            return (
              <div
                key={item.id}
                className="bg-white rounded-2xl p-3 shadow-sm border border-slate-100 flex flex-col justify-between relative group hover:shadow-md transition-shadow"
              >
                {item.tag && (
                  <span className="absolute top-3 left-3 z-10 bg-[#006b23] text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider">
                    {item.tag}
                  </span>
                )}

                <div className="w-full aspect-square bg-slate-50 rounded-xl mb-3 overflow-hidden flex items-center justify-center p-2">
                  <img
                    src={item.image}
                    alt={item.name}
                    className="w-full h-full object-cover rounded-lg group-hover:scale-105 transition-transform duration-300"
                  />
                </div>

                <div className="flex-1 flex flex-col justify-between">
                  <div>
                    <span className="text-xs text-slate-400 font-medium">{item.weight}</span>
                    <h3 className="font-outfit font-semibold text-sm text-slate-900 leading-snug line-clamp-2 mt-0.5">
                      {item.name}
                    </h3>
                  </div>

                  <div className="mt-3 pt-2 border-t border-slate-100 flex items-center justify-between">
                    <div>
                      <span className="font-outfit font-extrabold text-base text-slate-900">
                        {formatCurrency(item.price)}
                      </span>
                      {item.mrp > item.price && (
                        <span className="text-xs text-slate-400 line-through ml-1.5">
                          {formatCurrency(item.mrp)}
                        </span>
                      )}
                    </div>

                    <button
                      onClick={() => toggleAdd(item.id)}
                      className={`w-9 h-9 rounded-full flex items-center justify-center font-bold transition-all ${
                        count > 0
                          ? 'bg-[#006b23] text-white shadow-md shadow-[#006b23]/30'
                          : 'bg-slate-100 text-[#006b23] hover:bg-[#006b23] hover:text-white'
                      }`}
                    >
                      {count > 0 ? count : <Plus className="w-4 h-4" />}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </main>
    </div>
  );
}
