'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Search, Sparkles, ArrowRight } from 'lucide-react';

interface CategoryItem {
  id: string;
  slug: string;
  name: string;
  description: string;
  imageUrl: string;
  subcategoriesCount: number;
  isFeatured?: boolean;
}

const all18Categories: CategoryItem[] = [
  { id: 'cat-1', slug: 'fresh-fruits-vegetables', name: 'Fresh Fruits & Vegetables', description: 'Farm fresh organic vegetables, fresh fruits & leafy greens', imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=500&q=80', subcategoriesCount: 6, isFeatured: true },
  { id: 'cat-2', slug: 'dairy-bread-eggs', name: 'Dairy, Bread & Eggs', description: 'Fresh milk, butter, paneer, curd, fresh bread & eggs', imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&q=80', subcategoriesCount: 7, isFeatured: true },
  { id: 'cat-3', slug: 'snacks-packaged-foods', name: 'Snacks & Packaged Foods', description: 'Chips, namkeen, instant noodles, pasta & popcorn', imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=500&q=80', subcategoriesCount: 7, isFeatured: true },
  { id: 'cat-4', slug: 'grocery', name: 'Grocery', description: 'Basmati rice, premium atta, pulses, dals & dry fruits', imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500&q=80', subcategoriesCount: 7, isFeatured: true },
  { id: 'cat-5', slug: 'cooking-essentials', name: 'Cooking Essentials', description: 'Mustard oil, ghee, masalas, sauces & pickles', imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500&q=80', subcategoriesCount: 9, isFeatured: true },
  { id: 'cat-6', slug: 'pooja-needs', name: 'Pooja Needs', description: 'Agarbatti, dhoop, camphor, cotton wicks & kumkum', imageUrl: 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=500&q=80', subcategoriesCount: 10, isFeatured: false },
  { id: 'cat-7', slug: 'cleaning-essentials', name: 'Cleaning Essentials', description: 'Floor cleaners, dishwash, detergents & garbage bags', imageUrl: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=500&q=80', subcategoriesCount: 9, isFeatured: false },
  { id: 'cat-8', slug: 'household-lifestyle', name: 'Household & Lifestyle', description: 'Containers, aluminium foil, tissues & repellents', imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=500&q=80', subcategoriesCount: 9, isFeatured: false },
  { id: 'cat-9', slug: 'personal-care', name: 'Personal Care', description: 'Soaps, shampoos, toothpastes & skincare lotions', imageUrl: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=500&q=80', subcategoriesCount: 7, isFeatured: false },
  { id: 'cat-10', slug: 'baby-care', name: 'Baby Care', description: 'Diapers, baby wipes, baby food & gentle skincare', imageUrl: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=500&q=80', subcategoriesCount: 6, isFeatured: false },
  { id: 'cat-11', slug: 'pet-care', name: 'Pet Care', description: 'Dog food, cat treats, litter sand & grooming shampoos', imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=500&q=80', subcategoriesCount: 6, isFeatured: false },
  { id: 'cat-12', slug: 'cold-drinks-juices', name: 'Cold Drinks & Juices', description: 'Soft drinks, fruit juices, coconut water & energy drinks', imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500&q=80', subcategoriesCount: 6, isFeatured: true },
  { id: 'cat-13', slug: 'tea-coffee-beverages', name: 'Tea, Coffee & Beverages', description: 'Assam tea, instant coffee, green tea & health mixes', imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&q=80', subcategoriesCount: 6, isFeatured: false },
  { id: 'cat-14', slug: 'biscuits-bakery', name: 'Biscuits & Bakery', description: 'Cookies, cream biscuits, rusks & artisan breads', imageUrl: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=500&q=80', subcategoriesCount: 6, isFeatured: false },
  { id: 'cat-15', slug: 'chocolates-ice-cream', name: 'Chocolates & Ice Cream', description: 'Milk chocolates, dark chocolates & ice cream tubs', imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500&q=80', subcategoriesCount: 5, isFeatured: true },
  { id: 'cat-16', slug: 'organic-healthy-foods', name: 'Organic & Healthy Foods', description: 'Organic staples, cold-pressed oils, millets & quinoa', imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500&q=80', subcategoriesCount: 6, isFeatured: false },
  { id: 'cat-17', slug: 'frozen-foods', name: 'Frozen Foods', description: 'French fries, veg momos, frozen parathas & green peas', imageUrl: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=500&q=80', subcategoriesCount: 5, isFeatured: false },
  { id: 'cat-18', slug: 'meat-fish-eggs', name: 'Meat, Fish & Eggs', description: 'Fresh chicken, mutton, sea fish, prawns & eggs', imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=500&q=80', subcategoriesCount: 6, isFeatured: false },
];

export default function CategoriesPage() {
  const [search, setSearch] = useState('');

  const filtered = all18Categories.filter(
    (c) =>
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.description.toLowerCase().includes(search.toLowerCase()),
  );

  return (
    <div className="min-h-screen bg-slate-900 font-sans pb-24 text-white">
      {/* Header */}
      <header className="sticky top-0 z-40 bg-slate-800/90 backdrop-blur-md border-b border-slate-700/80 px-4 sm:px-8 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-teal-400 hover:bg-slate-700 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl sm:text-2xl font-extrabold text-white font-outfit">
              All Categories ({all18Categories.length})
            </h1>
          </div>
        </div>
      </header>

      {/* Main Container */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6">
        {/* Quick Commerce Banner */}
        <div className="mb-8 rounded-2xl bg-gradient-to-r from-teal-600 to-emerald-600 p-6 text-white shadow-xl relative overflow-hidden flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div>
            <span className="inline-flex items-center gap-1.5 px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider mb-2">
              <Sparkles className="w-3.5 h-3.5" /> 10-Minute Quick Commerce Taxonomy
            </span>
            <h2 className="text-2xl md:text-3xl font-extrabold font-outfit mb-1">
              Every Department Freshly Stocked
            </h2>
            <p className="text-white/90 text-sm font-inter">
              Browse 18 quick-commerce departments with instant subcategory filtering and express delivery.
            </p>
          </div>
        </div>

        {/* Search Bar */}
        <div className="mb-6 relative max-w-md">
          <Search className="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400" />
          <input
            type="text"
            placeholder="Search departments..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full bg-slate-800 border border-slate-700 rounded-xl pl-11 pr-4 py-3 text-sm text-white placeholder-slate-400 focus:outline-none focus:border-teal-500 transition"
          />
        </div>

        {/* Categories Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {filtered.map((cat) => (
            <Link
              key={cat.id}
              href={`/categories/${cat.slug}`}
              className="group bg-slate-800 border border-slate-700/70 hover:border-teal-500/60 rounded-2xl overflow-hidden transition-all duration-300 hover:shadow-xl hover:shadow-teal-500/10 flex flex-col justify-between"
            >
              <div>
                <div className="relative h-44 overflow-hidden">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={cat.imageUrl}
                    alt={cat.name}
                    className="w-full h-full object-cover group-hover:scale-105 transition duration-500"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-slate-900 via-transparent to-transparent opacity-80" />
                  {cat.isFeatured && (
                    <span className="absolute top-3 right-3 bg-pink-500 text-white text-xs font-bold px-2.5 py-1 rounded-md shadow">
                      POPULAR
                    </span>
                  )}
                </div>
                <div className="p-5">
                  <h3 className="text-lg font-bold font-outfit text-white group-hover:text-teal-400 transition">
                    {cat.name}
                  </h3>
                  <p className="text-xs text-slate-400 font-inter mt-1 line-clamp-2">
                    {cat.description}
                  </p>
                </div>
              </div>
              <div className="px-5 pb-5 pt-0 flex items-center justify-between border-t border-slate-700/50 mt-2">
                <span className="text-xs text-teal-400 font-semibold font-inter">
                  {cat.subcategoriesCount} subcategories
                </span>
                <span className="p-2 bg-slate-700/50 group-hover:bg-teal-500 group-hover:text-slate-950 text-slate-300 rounded-full transition">
                  <ArrowRight className="w-4 h-4" />
                </span>
              </div>
            </Link>
          ))}
        </div>
      </main>
    </div>
  );
}
