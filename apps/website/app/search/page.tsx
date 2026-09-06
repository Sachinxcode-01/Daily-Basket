// Google Stitch Screen ID: f7c78b705cb6471dae1b49027ca746b3
// Title: Premium Product Catalog & Search
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState, useEffect, useMemo } from 'react';

import Link from 'next/link';
import { Search, Camera, SlidersHorizontal, Plus, Check, ArrowLeft, X } from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';

interface SearchItem {
  id: string;
  name: string;
  weight: string;
  price: number;
  mrp: number;
  isOrganic: boolean;
  image: string;
}

function mapItem(p: any): SearchItem {
  const variant =
    (Array.isArray(p?.variants) && (p.variants.find((v: any) => v?.isAvailable) ?? p.variants[0])) || null;
  return {
    id: p?.id,
    name: p?.name ?? '',
    weight: variant?.unitName ?? '',
    price: variant?.price ?? 0,
    mrp: variant?.mrp ?? variant?.price ?? 0,
    isOrganic: Boolean(p?.isOrganic),
    image: (Array.isArray(p?.images) && p.images[0]) || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80',
  };
}

export default function SearchPage() {
  const [query, setQuery] = useState('');
  const [debouncedQuery, setDebouncedQuery] = useState('');
  const [activeFilter, setActiveFilter] = useState('All');
  const [cart, setCart] = useState<Record<string, number>>({});
  const [isCameraModalOpen, setIsCameraModalOpen] = useState(false);

  const filters = ['All', 'Organic', 'On Sale', 'Under ₹50'];

  // Debounce the query so we don't hit the API on every keystroke.
  useEffect(() => {
    const t = setTimeout(() => setDebouncedQuery(query.trim()), 350);
    return () => clearTimeout(t);
  }, [query]);

  const {
    data: apiProducts,
    isLoading,
    isFetching,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['search', debouncedQuery],
    queryFn: () => apiClient.getProducts(undefined, debouncedQuery || undefined),
  });

  const results = useMemo(() => {
    const mapped = Array.isArray(apiProducts) ? apiProducts.map(mapItem) : [];
    switch (activeFilter) {
      case 'Organic':
        return mapped.filter((p) => p.isOrganic);
      case 'On Sale':
        return mapped.filter((p) => p.mrp > p.price);
      case 'Under ₹50':
        return mapped.filter((p) => p.price < 50);
      default:
        return mapped;
    }
  }, [apiProducts, activeFilter]);

  const toggleAdd = (id: string) => {
    setCart((prev) => ({ ...prev, [id]: (prev[id] || 0) + 1 }));
  };

  const loading = isLoading || isFetching;

  return (
    <div className="min-h-screen bg-slate-900 font-sans pb-24 text-white">
      {/* Sticky Search Header */}
      <header className="sticky top-0 z-40 bg-slate-800/90 backdrop-blur-md border-b border-slate-700/80 px-4 sm:px-8 py-3">
        <div className="max-w-7xl mx-auto flex items-center gap-3">
          <Link href="/" className="p-2 text-teal-400 hover:bg-slate-700 rounded-full transition">
            <ArrowLeft className="w-6 h-6" />
          </Link>

          <div className="relative flex-1">
            <Search className="w-5 h-5 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search for groceries, brand or scan camera..."
              className="w-full h-11 bg-slate-900 border border-slate-700 rounded-xl pl-11 pr-12 text-sm font-medium text-white placeholder:text-slate-400 focus:outline-none focus:border-teal-500 transition"
            />
            <button
              onClick={() => setIsCameraModalOpen(true)}
              title="Search by Camera"
              className="absolute right-2 top-1/2 -translate-y-1/2 p-2 bg-teal-500 text-slate-950 rounded-lg hover:bg-teal-400 transition flex items-center justify-center"
            >
              <Camera className="w-4 h-4" />
            </button>
          </div>

          <button className="p-2.5 bg-slate-700 text-slate-200 rounded-xl hover:bg-slate-600 transition">
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
                  ? 'bg-teal-500 text-slate-950 font-bold shadow-md shadow-teal-500/20'
                  : 'bg-slate-700 text-slate-300 hover:bg-slate-600'
              }`}
            >
              {f}
            </button>
          ))}
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6">
        <div className="flex items-center justify-between mb-4">
          <p className="text-sm font-medium text-slate-400 font-inter">
            {debouncedQuery
              ? <>Showing <span className="font-bold text-white">{results.length} results</span> for &ldquo;{debouncedQuery}&rdquo;</>
              : <>Showing <span className="font-bold text-white">{results.length}</span> products</>}
          </p>
        </div>

        {/* Loading */}
        {loading && (
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="bg-slate-800 border border-slate-700/70 rounded-2xl p-4 animate-pulse">
                <div className="aspect-square rounded-xl mb-3 bg-slate-700/50" />
                <div className="h-3 bg-slate-700/50 rounded w-3/4 mb-2" />
                <div className="h-3 bg-slate-700/50 rounded w-1/2 mb-3" />
                <div className="h-9 bg-slate-700/50 rounded-xl" />
              </div>
            ))}
          </div>
        )}

        {/* Error */}
        {!loading && isError && (
          <div className="text-center py-16 space-y-3">
            <div className="text-4xl">⚠️</div>
            <p className="font-bold text-white">Search failed</p>
            <button
              onClick={() => refetch()}
              className="mt-1 bg-teal-500 text-slate-950 text-xs font-bold px-5 py-2.5 rounded-xl hover:bg-teal-400"
            >
              Retry
            </button>
          </div>
        )}

        {/* Empty */}
        {!loading && !isError && results.length === 0 && (
          <div className="text-center py-16 space-y-2">
            <div className="text-4xl">🔍</div>
            <p className="font-bold text-white">No products found</p>
            <p className="text-xs text-slate-400">
              {debouncedQuery ? 'Try a different search term or filter.' : 'Start typing to search the catalog.'}
            </p>
          </div>
        )}

        {/* Results Grid */}
        {!loading && !isError && results.length > 0 && (
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
            {results.map((item) => {
              const count = cart[item.id] || 0;
              const discount = item.mrp > item.price ? Math.round(((item.mrp - item.price) / item.mrp) * 100) : 0;
              return (
                <div
                  key={item.id}
                  className="bg-slate-800 border border-slate-700/70 hover:border-teal-500/50 rounded-2xl p-4 flex flex-col justify-between transition-all duration-300 hover:shadow-xl hover:shadow-teal-500/5"
                >
                  <div>
                    <Link href={`/product/${item.id}`} className="relative block aspect-square rounded-xl overflow-hidden mb-3 bg-slate-900">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={item.image} alt={item.name} className="w-full h-full object-cover" />
                      {item.isOrganic && (
                        <span className="absolute top-2 left-2 bg-emerald-500 text-white text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
                          Organic
                        </span>
                      )}
                      {!item.isOrganic && discount > 0 && (
                        <span className="absolute top-2 left-2 bg-red-500 text-white text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
                          {discount}% OFF
                        </span>
                      )}
                    </Link>

                    <Link href={`/product/${item.id}`}>
                      <h3 className="font-bold text-sm text-white font-outfit line-clamp-2 mb-1 hover:text-teal-400 transition">
                        {item.name}
                      </h3>
                    </Link>
                    <p className="text-xs text-slate-400 font-inter mb-3">{item.weight}</p>
                  </div>

                  <div>
                    <div className="flex items-baseline gap-1.5 mb-3">
                      <span className="text-base font-extrabold text-teal-400 font-outfit">
                        {formatCurrency(item.price)}
                      </span>
                      {item.mrp > item.price && (
                        <span className="text-xs text-slate-500 line-through font-inter">
                          {formatCurrency(item.mrp)}
                        </span>
                      )}
                    </div>

                    <button
                      onClick={() => toggleAdd(item.id)}
                      className={`w-full h-9 rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 transition ${
                        count > 0 ? 'bg-teal-600 text-white' : 'bg-teal-500 text-slate-950 hover:bg-teal-400'
                      }`}
                    >
                      {count > 0 ? (
                        <>
                          <Check className="w-4 h-4" /> Added ({count})
                        </>
                      ) : (
                        <>
                          <Plus className="w-4 h-4" /> ADD
                        </>
                      )}
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </main>

      {/* Camera Search Modal (visual search is a planned feature) */}
      {isCameraModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-md flex items-center justify-center p-4">
          <div className="bg-slate-800 border border-slate-700 rounded-3xl max-w-md w-full p-6 text-center relative overflow-hidden shadow-2xl">
            <button
              onClick={() => setIsCameraModalOpen(false)}
              className="absolute top-4 right-4 text-slate-400 hover:text-white p-2 rounded-full"
            >
              <X className="w-5 h-5" />
            </button>

            <div className="w-16 h-16 bg-teal-500/20 text-teal-400 rounded-full flex items-center justify-center mx-auto mb-4 border border-teal-500/30">
              <Camera className="w-8 h-8" />
            </div>

            <h3 className="text-xl font-bold font-outfit text-white mb-2">
              AI Visual Search by Camera
            </h3>
            <p className="text-xs text-slate-300 font-inter mb-6">
              Point your camera at any grocery package to search the Daily Basket catalog. This feature is coming soon.
            </p>

            <button
              onClick={() => setIsCameraModalOpen(false)}
              className="w-full py-3 bg-slate-700 hover:bg-slate-600 text-white font-bold text-sm rounded-xl transition"
            >
              Close
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
