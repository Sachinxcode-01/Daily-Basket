'use client';

import React, { useState, useMemo } from 'react';
import Link from 'next/link';
import { ArrowLeft, Search, ShoppingBag, Heart, Star, Sparkles } from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';

interface CardProduct {
  id: string;
  name: string;
  subtitle: string;
  price: number;
  mrp: number;
  imageUrl: string;
  rating?: number;
}

function mapProduct(p: any): CardProduct {
  const variant =
    (Array.isArray(p?.variants) && (p.variants.find((v: any) => v?.isAvailable) ?? p.variants[0])) || null;
  return {
    id: p?.id,
    name: p?.name ?? '',
    subtitle: variant?.unitName ?? p?.brand ?? '',
    price: variant?.price ?? 0,
    mrp: variant?.mrp ?? variant?.price ?? 0,
    imageUrl: (Array.isArray(p?.images) && p.images[0]) || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80',
    rating: typeof p?.rating === 'number' && p.rating > 0 ? p.rating : undefined,
  };
}

export default function CategoryDetailPage({ params }: { params: { id: string } }) {
  const categoryId = params.id;

  const [search, setSearch] = useState('');
  const [cartCount, setCartCount] = useState(0);

  const { data: categories } = useQuery({
    queryKey: ['categories'],
    queryFn: () => apiClient.getCategories(),
  });

  const {
    data: apiProducts,
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['products', 'category', categoryId],
    queryFn: () => apiClient.getProducts(categoryId),
  });

  const category = useMemo(
    () => (Array.isArray(categories) ? categories.find((c: any) => c.id === categoryId) : undefined),
    [categories, categoryId],
  );
  const categoryName = category?.name ?? 'Category';
  const banner =
    (category as any)?.bannerImage ||
    category?.imageUrl ||
    'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=1200&q=80';

  const products = useMemo(
    () => (Array.isArray(apiProducts) ? apiProducts.map(mapProduct) : []),
    [apiProducts],
  );

  const filteredProducts = products.filter((p) =>
    p.name.toLowerCase().includes(search.toLowerCase()),
  );

  return (
    <div className="min-h-screen bg-slate-900 font-sans pb-24 text-white">
      {/* Header */}
      <header className="sticky top-0 z-40 bg-slate-800/90 backdrop-blur-md border-b border-slate-700/80 px-4 sm:px-8 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/categories" className="p-2 text-teal-400 hover:bg-slate-700 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl sm:text-2xl font-extrabold text-white font-outfit">
              {categoryName}
            </h1>
          </div>
          <Link href="/cart" className="relative p-2 text-teal-400 hover:bg-slate-700 rounded-full transition">
            <ShoppingBag className="w-6 h-6" />
            {cartCount > 0 && (
              <span className="absolute -top-1 -right-1 bg-teal-500 text-slate-950 font-bold text-xs w-5 h-5 rounded-full flex items-center justify-center">
                {cartCount}
              </span>
            )}
          </Link>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6">
        {/* Category Banner */}
        <div className="relative rounded-2xl overflow-hidden h-48 md:h-64 mb-6 shadow-xl">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={banner} alt={categoryName} className="w-full h-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/60 to-transparent" />
          <div className="absolute bottom-6 left-6 right-6">
            <span className="inline-flex items-center gap-1 px-3 py-1 bg-teal-500 text-slate-950 text-xs font-bold rounded-full mb-2 uppercase">
              <Sparkles className="w-3.5 h-3.5" /> Express 10-Min Delivery
            </span>
            <h2 className="text-2xl md:text-4xl font-extrabold font-outfit text-white">
              {categoryName}
            </h2>
          </div>
        </div>

        {/* Search */}
        <div className="flex flex-col md:flex-row md:items-center justify-end gap-4 mb-6">
          <div className="relative w-full md:w-64">
            <Search className="w-4 h-4 absolute left-3 top-3 text-slate-400" />
            <input
              type="text"
              placeholder={`Search in ${categoryName}...`}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full bg-slate-800 border border-slate-700 rounded-xl pl-9 pr-4 py-2 text-xs text-white placeholder-slate-400 focus:outline-none focus:border-teal-500"
            />
          </div>
        </div>

        {/* Loading */}
        {isLoading && (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="bg-slate-800 border border-slate-700/60 rounded-2xl overflow-hidden animate-pulse">
                <div className="w-full h-48 bg-slate-700/50" />
                <div className="p-4 space-y-2">
                  <div className="h-3 bg-slate-700/50 rounded w-3/4" />
                  <div className="h-3 bg-slate-700/50 rounded w-1/2" />
                  <div className="h-6 bg-slate-700/50 rounded w-1/3 mt-3" />
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Error */}
        {isError && (
          <div className="text-center py-16 space-y-3">
            <div className="text-4xl">⚠️</div>
            <p className="font-bold text-white">Couldn&rsquo;t load products</p>
            <button
              onClick={() => refetch()}
              className="mt-1 bg-teal-500 text-slate-950 text-xs font-bold px-5 py-2.5 rounded-xl hover:bg-teal-400"
            >
              Retry
            </button>
          </div>
        )}

        {/* Empty */}
        {!isLoading && !isError && filteredProducts.length === 0 && (
          <div className="text-center py-16 space-y-2">
            <div className="text-4xl">🧺</div>
            <p className="font-bold text-white">No products in this category</p>
            <p className="text-xs text-slate-400">Try another category or search.</p>
          </div>
        )}

        {/* Product Grid */}
        {!isLoading && !isError && filteredProducts.length > 0 && (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {filteredProducts.map((p) => (
              <div
                key={p.id}
                className="bg-slate-800 border border-slate-700/60 rounded-2xl overflow-hidden flex flex-col justify-between hover:border-teal-500/50 transition duration-300"
              >
                <Link href={`/product/${p.id}`} className="relative block">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={p.imageUrl} alt={p.name} className="w-full h-48 object-cover" />
                  {p.mrp > p.price && (
                    <span className="absolute top-3 left-3 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-md">
                      {Math.round(((p.mrp - p.price) / p.mrp) * 100)}% OFF
                    </span>
                  )}
                  <button
                    onClick={(e) => e.preventDefault()}
                    className="absolute top-3 right-3 p-2 bg-slate-900/80 text-rose-400 rounded-full hover:bg-rose-500 hover:text-white transition"
                  >
                    <Heart className="w-4 h-4" />
                  </button>
                </Link>

                <div className="p-4">
                  {typeof p.rating === 'number' && (
                    <div className="flex items-center gap-1 text-amber-400 text-xs font-bold mb-1">
                      <Star className="w-3.5 h-3.5 fill-amber-400" />
                      <span>{p.rating}</span>
                    </div>
                  )}
                  <Link href={`/product/${p.id}`}>
                    <h3 className="text-sm font-bold font-outfit text-white line-clamp-1 hover:text-teal-400 transition">{p.name}</h3>
                  </Link>
                  <p className="text-xs text-slate-400 font-inter mt-0.5">{p.subtitle}</p>

                  <div className="mt-4 flex items-center justify-between">
                    <div>
                      <span className="text-lg font-bold font-outfit text-teal-400">{formatCurrency(p.price)}</span>
                      {p.mrp > p.price && (
                        <span className="text-xs text-slate-500 line-through ml-1.5">{formatCurrency(p.mrp)}</span>
                      )}
                    </div>
                    <button
                      onClick={() => setCartCount((c) => c + 1)}
                      className="px-3.5 py-1.5 bg-teal-500 hover:bg-teal-400 text-slate-950 font-extrabold text-xs rounded-xl transition"
                    >
                      ADD
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
