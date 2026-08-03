'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Search, Sparkles } from 'lucide-react';

export default function CategoriesPage() {
  const categories = [
    { id: 'cat_veg', name: 'Fresh Vegetables & Fruits', icon: '🥬', items: '45 Items', bg: 'from-emerald-900/40 to-teal-900/20' },
    { id: 'cat_dairy', name: 'Dairy, Bread & Eggs', icon: '🥛', items: '28 Items', bg: 'from-amber-900/40 to-orange-900/20' },
    { id: 'cat_bev', name: 'Cold Drinks & Juices', icon: '🧃', items: '32 Items', bg: 'from-sky-900/40 to-blue-900/20' },
    { id: 'cat_snack', name: 'Munchies & Snacks', icon: '🥨', items: '50 Items', bg: 'from-purple-900/40 to-pink-900/20' },
    { id: 'cat_bakery', name: 'Fresh Bakery & Cakes', icon: '🍞', items: '20 Items', bg: 'from-yellow-900/40 to-amber-900/20' },
  ];

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-20 max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between py-4 mb-4 border-b border-slate-800">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Home</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white">All Categories</h1>
        <Link href="/search" className="text-slate-400 hover:text-white">
          <Search className="w-5 h-5" />
        </Link>
      </div>

      {/* Categories Grid */}
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
        {categories.map((cat) => (
          <div
            key={cat.id}
            className={`p-6 rounded-2xl border border-slate-700/50 bg-gradient-to-br ${cat.bg} hover:border-emerald-500/50 flex flex-col items-center text-center cursor-pointer transition shadow-lg`}
          >
            <span className="text-4xl mb-3">{cat.icon}</span>
            <h3 className="font-bold text-white text-sm mb-1">{cat.name}</h3>
            <span className="text-xs text-slate-400 font-semibold">{cat.items}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
