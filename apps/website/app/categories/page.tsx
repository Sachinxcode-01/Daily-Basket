'use client';

import React from 'react';
import Link from 'next/link';
import { useQuery } from '@tanstack/react-query';
import { apiClient } from '@daily-basket/api-client';

/**
 * Browse Categories Page — Daily Basket
 * Stitch Screen ID: d4a9073676484431a88cd27d2cc1e87a
 * Wired to live GET /api/v1/categories.
 */
export default function BrowseCategoriesPage() {
  const {
    data: categories,
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['categories'],
    queryFn: () => apiClient.getCategories(),
  });

  const all = Array.isArray(categories) ? categories : [];
  const featured = all.slice(0, 2);

  const fallbackImage =
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=700&auto=format&fit=crop&q=80';

  return (
    <div className="min-h-screen bg-[#f9f9fc] font-['Inter'] text-[#1a1c1e] pb-24">
      {/* Top Header */}
      <header className="sticky top-0 w-full z-50 bg-[#f9f9fc]/80 backdrop-blur-xl shadow-sm border-b border-[#e2e2e5] flex justify-between items-center px-4 h-16 max-w-7xl mx-auto">
        <Link href="/select-location" className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-[#078730]/10 text-[#006b23]">
          <span className="material-symbols-outlined">location_on</span>
        </Link>
        <h1 className="font-['Outfit'] text-[22px] font-bold text-[#006b23]">
          Daily Basket
        </h1>
        <Link href="/search" className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-[#078730]/10 text-[#006b23]">
          <span className="material-symbols-outlined">search</span>
        </Link>
      </header>

      {/* Main Content */}
      <main className="pt-4 px-4 max-w-7xl mx-auto">
        {/* Search Bar */}
        <div className="mb-8">
          <Link href="/search" className="flex items-center w-full bg-[#f3f3f6] rounded-xl py-3 px-4 text-[#6e7a6c] hover:bg-white border border-transparent hover:border-[#e2e2e5] transition-all">
            <span className="material-symbols-outlined mr-3 text-[#6e7a6c]">search</span>
            <span className="text-sm">Search groceries...</span>
          </Link>
        </div>

        {/* Loading */}
        {isLoading && (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="bg-white rounded-xl p-3 border border-[#e2e2e5] animate-pulse">
                <div className="w-full aspect-square rounded-lg mb-3 bg-[#eeeef0]" />
                <div className="h-3 bg-[#eeeef0] rounded w-3/4 mx-auto" />
              </div>
            ))}
          </div>
        )}

        {/* Error */}
        {isError && (
          <div className="text-center py-16 space-y-3">
            <div className="text-4xl">⚠️</div>
            <p className="font-semibold text-[#1a1c1e]">Couldn&rsquo;t load categories</p>
            <button
              onClick={() => refetch()}
              className="mt-1 bg-[#006b23] text-white text-xs font-bold px-5 py-2.5 rounded-full hover:bg-[#078730]"
            >
              Retry
            </button>
          </div>
        )}

        {/* Empty */}
        {!isLoading && !isError && all.length === 0 && (
          <div className="text-center py-16 space-y-2">
            <div className="text-4xl">🗂️</div>
            <p className="font-semibold text-[#1a1c1e]">No categories available yet</p>
          </div>
        )}

        {!isLoading && !isError && all.length > 0 && (
          <>
            {/* Featured Categories */}
            {featured.length > 0 && (
              <section className="mb-10">
                <h2 className="font-['Outfit'] text-[18px] font-semibold text-[#1a1c1e] mb-4">
                  Featured Categories
                </h2>
                <div className="flex overflow-x-auto gap-4 pb-4 snap-x hide-scrollbar">
                  {featured.map((item) => (
                    <Link
                      key={item.id}
                      href={`/categories/${item.id}`}
                      className="min-w-[280px] w-72 flex-shrink-0 snap-start bg-white rounded-2xl overflow-hidden shadow-sm relative group hover:shadow-md transition-shadow"
                    >
                      <div className="h-44 w-full relative">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img
                          src={item.imageUrl || fallbackImage}
                          alt={item.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/75 via-black/20 to-transparent" />
                      </div>
                      <div className="absolute bottom-0 left-0 p-4 w-full text-white">
                        <h3 className="font-['Outfit'] text-lg font-bold mb-0.5">{item.name}</h3>
                        <p className="text-xs text-white/80">Shop fresh essentials</p>
                      </div>
                    </Link>
                  ))}
                </div>
              </section>
            )}

            {/* All Categories Grid */}
            <section className="mb-8">
              <h2 className="font-['Outfit'] text-[18px] font-semibold text-[#1a1c1e] mb-4">
                All Categories
              </h2>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {all.map((cat) => (
                  <Link
                    key={cat.id}
                    href={`/categories/${cat.id}`}
                    className="bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-all p-3 flex flex-col items-center border border-[#e2e2e5] group"
                  >
                    <div className="w-full aspect-square rounded-lg mb-3 overflow-hidden bg-[#f3f3f6]">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img
                        src={cat.imageUrl || fallbackImage}
                        alt={cat.name}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform"
                      />
                    </div>
                    <h3 className="font-['Outfit'] text-sm font-semibold text-[#1a1c1e] text-center w-full truncate">
                      {cat.name}
                    </h3>
                    <p className="text-[11px] text-[#6e7a6c] mt-0.5">Shop now →</p>
                  </Link>
                ))}
              </div>
            </section>
          </>
        )}
      </main>
    </div>
  );
}
