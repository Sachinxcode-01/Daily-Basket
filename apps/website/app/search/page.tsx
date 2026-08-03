'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Search as SearchIcon, X, TrendingUp, History, ShoppingBag } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function SearchPage() {
  const [query, setQuery] = useState('');

  const trendingTags = ['Tomatoes', 'Amul Milk', 'Brown Bread', 'Alphonso Mangoes', 'Butter', 'Eggs'];
  const recentSearches = ['Fresh Organic Milk', 'Atta 5kg', 'Cold Pressed Oil'];

  const sampleResults = [
    { id: 'p1', name: 'Fresh Organic Farm Tomatoes', unit: '500g', price: 24, mrp: 40, image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80' },
    { id: 'p2', name: 'Amul Taaza Toned Fresh Milk', unit: '1 Litre', price: 54, mrp: 56, image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80' },
  ].filter((p) => p.name.toLowerCase().includes(query.toLowerCase()));

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 max-w-4xl mx-auto">
      {/* Search Header */}
      <div className="flex items-center gap-3 py-3 mb-4">
        <Link href="/" className="text-slate-400 hover:text-white">
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="relative flex-1">
          <SearchIcon className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            autoFocus
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search 1,000+ daily grocery items..."
            className="w-full bg-slate-800 border border-slate-700 focus:border-emerald-500 rounded-xl py-2.5 pl-10 pr-10 text-sm text-white placeholder-slate-400 outline-none transition"
          />
          {query && (
            <button onClick={() => setQuery('')} className="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-white">
              <X className="w-4 h-4" />
            </button>
          )}
        </div>
      </div>

      {!query ? (
        <div className="space-y-6">
          {/* Trending Searches */}
          <div>
            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-emerald-400" />
              <span>Trending Searches</span>
            </h3>
            <div className="flex flex-wrap gap-2">
              {trendingTags.map((tag) => (
                <button
                  key={tag}
                  onClick={() => setQuery(tag)}
                  className="px-3.5 py-1.5 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 text-xs font-semibold rounded-full transition"
                >
                  {tag}
                </button>
              ))}
            </div>
          </div>

          {/* Recent Searches */}
          <div>
            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 flex items-center gap-2">
              <History className="w-4 h-4 text-slate-400" />
              <span>Recent Searches</span>
            </h3>
            <div className="space-y-2">
              {recentSearches.map((item) => (
                <div
                  key={item}
                  onClick={() => setQuery(item)}
                  className="flex items-center justify-between p-3 bg-slate-800/50 hover:bg-slate-800 rounded-xl cursor-pointer transition text-sm text-slate-300"
                >
                  <span>{item}</span>
                  <ArrowLeft className="w-4 h-4 text-slate-500 rotate-180" />
                </div>
              ))}
            </div>
          </div>
        </div>
      ) : (
        <div className="space-y-3">
          {sampleResults.length === 0 ? (
            <div className="py-16 text-center">
              <ShoppingBag className="w-12 h-12 text-slate-600 mx-auto mb-3" />
              <h3 className="text-lg font-bold text-white mb-1">No Products Found</h3>
              <p className="text-slate-400 text-xs">Try searching for "milk", "tomatoes", or "bread".</p>
            </div>
          ) : (
            sampleResults.map((prod) => (
              <div
                key={prod.id}
                className="p-3 bg-slate-800/80 border border-slate-700/60 rounded-xl flex items-center justify-between hover:border-emerald-500/40 transition"
              >
                <div className="flex items-center gap-3">
                  <img src={prod.image} alt={prod.name} className="w-14 h-14 object-cover rounded-lg bg-slate-900" />
                  <div>
                    <h4 className="text-sm font-bold text-white">{prod.name}</h4>
                    <span className="text-xs text-slate-400">{prod.unit}</span>
                  </div>
                </div>
                <div className="text-right">
                  <span className="text-sm font-extrabold text-emerald-400">{formatCurrency(prod.price)}</span>
                  <button className="block mt-1 px-3 py-1 bg-emerald-600 text-white font-bold text-xs rounded-md shadow">
                    + ADD
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
}
