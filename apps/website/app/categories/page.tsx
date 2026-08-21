'use client';

import React from 'react';
import Link from 'next/link';
import Image from 'next/image';

/**
 * Browse Categories Page — Daily Basket
 * Stitch Screen ID: d4a9073676484431a88cd27d2cc1e87a
 */
export default function BrowseCategoriesPage() {
  const featured = [
    {
      title: 'Fresh Fruits',
      subtitle: 'Farm to table everyday',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=700&auto=format&fit=crop&q=80',
    },
    {
      title: 'Organic Vegetables',
      subtitle: 'Locally sourced produce',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=700&auto=format&fit=crop&q=80',
    },
  ];

  const categories = [
    {
      title: 'Dairy & Eggs',
      items: '120+ items',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&auto=format&fit=crop&q=80',
    },
    {
      title: 'Bakery',
      items: '85+ items',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80',
    },
    {
      title: 'Snacks',
      items: '300+ items',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=600&auto=format&fit=crop&q=80',
    },
    {
      title: 'Personal Care',
      items: '150+ items',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&auto=format&fit=crop&q=80',
    },
    {
      title: 'Beverages',
      items: '210+ items',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
    },
    {
      title: 'Home Essentials',
      items: '95+ items',
      href: '/categories/fruits-vegetables',
      image:
        'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=600&auto=format&fit=crop&q=80',
    },
  ];

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

        {/* Featured Categories */}
        <section className="mb-10">
          <h2 className="font-['Outfit'] text-[18px] font-semibold text-[#1a1c1e] mb-4">
            Featured Categories
          </h2>
          <div className="flex overflow-x-auto gap-4 pb-4 snap-x hide-scrollbar">
            {featured.map((item, idx) => (
              <Link
                key={idx}
                href={item.href}
                className="min-w-[280px] w-72 flex-shrink-0 snap-start bg-white rounded-2xl overflow-hidden shadow-sm relative group hover:shadow-md transition-shadow"
              >
                <div className="h-44 w-full relative">
                  <img
                    src={item.image}
                    alt={item.title}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/75 via-black/20 to-transparent" />
                </div>
                <div className="absolute bottom-0 left-0 p-4 w-full text-white">
                  <h3 className="font-['Outfit'] text-lg font-bold mb-0.5">{item.title}</h3>
                  <p className="text-xs text-white/80">{item.subtitle}</p>
                </div>
              </Link>
            ))}
          </div>
        </section>

        {/* All Categories Grid */}
        <section className="mb-8">
          <h2 className="font-['Outfit'] text-[18px] font-semibold text-[#1a1c1e] mb-4">
            All Categories
          </h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {categories.map((cat, idx) => (
              <Link
                key={idx}
                href={cat.href}
                className="bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-all p-3 flex flex-col items-center border border-[#e2e2e5]"
              >
                <div className="w-full aspect-square rounded-lg mb-3 overflow-hidden bg-[#f3f3f6]">
                  <img
                    src={cat.image}
                    alt={cat.title}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform"
                  />
                </div>
                <h3 className="font-['Outfit'] text-sm font-semibold text-[#1a1c1e] text-center w-full truncate">
                  {cat.title}
                </h3>
                <p className="text-[11px] text-[#6e7a6c] mt-0.5">{cat.items}</p>
              </Link>
            ))}
          </div>
        </section>
      </main>
    </div>
  );
}
