'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, ChevronRight } from 'lucide-react';

interface CategoryCard {
  id: string;
  name: string;
  itemCount: string;
  bgColor: string;
  image: string;
}

const mainCategories: CategoryCard[] = [
  {
    id: 'cat-1',
    name: 'Fruits & Vegetables',
    itemCount: '120+ items',
    bgColor: 'bg-emerald-50 border-emerald-100',
    image: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80',
  },
  {
    id: 'cat-2',
    name: 'Dairy, Bread & Eggs',
    itemCount: '85+ items',
    bgColor: 'bg-amber-50 border-amber-100',
    image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
  },
  {
    id: 'cat-3',
    name: 'Cold Drinks & Juices',
    itemCount: '60+ items',
    bgColor: 'bg-sky-50 border-sky-100',
    image: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400&q=80',
  },
  {
    id: 'cat-4',
    name: 'Snacks & Munchies',
    itemCount: '140+ items',
    bgColor: 'bg-orange-50 border-orange-100',
    image: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&q=80',
  },
  {
    id: 'cat-5',
    name: 'Bakery & Biscuits',
    itemCount: '70+ items',
    bgColor: 'bg-yellow-50 border-yellow-100',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
  },
  {
    id: 'cat-6',
    name: 'Meat, Fish & Poultry',
    itemCount: '45+ items',
    bgColor: 'bg-rose-50 border-rose-100',
    image: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&q=80',
  },
];

export default function CategoriesPage() {
  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl sm:text-2xl font-extrabold text-slate-900 font-outfit">
              Browse Categories
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6">
        
        {/* Banner Promo */}
        <div className="mb-6 rounded-2xl bg-gradient-to-r from-[#006b23] to-emerald-700 p-6 text-white shadow-md relative overflow-hidden">
          <div className="relative z-10 max-w-md">
            <span className="inline-block px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider mb-2">
              Fresh Daily
            </span>
            <h2 className="text-2xl font-extrabold font-outfit mb-1">
              Farm Fresh Guarantee
            </h2>
            <p className="text-white/90 text-sm font-inter">
              Directly sourced from trusted local organic farms every morning.
            </p>
          </div>
        </div>

        {/* Categories Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
          {mainCategories.map((cat) => (
            <Link
              key={cat.id}
              href={`/search?category=${encodeURIComponent(cat.name)}`}
              className={`rounded-2xl p-4 border transition-all duration-200 hover:shadow-md hover:scale-[1.02] flex flex-col justify-between ${cat.bgColor}`}
            >
              <div className="w-full aspect-square rounded-xl overflow-hidden mb-3 bg-white/60 p-2 shadow-inner">
                <img
                  src={cat.image}
                  alt={cat.name}
                  className="w-full h-full object-cover rounded-lg"
                />
              </div>

              <div className="flex items-end justify-between">
                <div>
                  <h3 className="font-outfit font-bold text-base text-slate-900 leading-snug">
                    {cat.name}
                  </h3>
                  <span className="text-xs text-slate-500 font-medium font-inter mt-0.5 block">
                    {cat.itemCount}
                  </span>
                </div>

                <div className="w-8 h-8 rounded-full bg-white text-[#006b23] flex items-center justify-center shadow-sm">
                  <ChevronRight className="w-4 h-4" />
                </div>
              </div>
            </Link>
          ))}
        </div>
      </main>
    </div>
  );
}
