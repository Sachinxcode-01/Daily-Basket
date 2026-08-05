'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Search, Filter, ShoppingBag, Heart, Star, Sparkles } from 'lucide-react';

interface Product {
  id: string;
  name: string;
  subtitle: string;
  price: number;
  mrp: number;
  imageUrl: string;
  sub: string;
  rating: number;
}

const mockProducts: Record<string, Product[]> = {
  'fresh-fruits-vegetables': [
    { id: 'p1', name: 'Organic Farm Tomatoes', subtitle: '500g (Farm Fresh)', price: 32, mrp: 45, imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80', sub: 'Fresh Vegetables', rating: 4.8 },
    { id: 'p2', name: 'Fresh Royal Gala Apples', subtitle: '4 pcs (approx. 600g)', price: 149, mrp: 199, imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&q=80', sub: 'Fresh Fruits', rating: 4.9 },
    { id: 'p3', name: 'Organic Hass Avocados', subtitle: '2 pcs (Imported)', price: 180, mrp: 240, imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&q=80', sub: 'Exotics & Premium', rating: 4.7 },
  ],
  grocery: [
    { id: 'p4', name: 'Fortune Basmati Rice', subtitle: '5 kg Pack', price: 499, mrp: 650, imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80', sub: 'Rice', rating: 4.9 },
    { id: 'p5', name: 'Aashirvaad Shuddh Chakki Atta', subtitle: '10 kg Pack', price: 420, mrp: 510, imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80', sub: 'Atta', rating: 4.8 },
  ],
};

const categoryNames: Record<string, { name: string; banner: string; subs: string[] }> = {
  'fresh-fruits-vegetables': {
    name: 'Fresh Fruits & Vegetables',
    banner: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=1200&q=80',
    subs: ['All', 'Fresh Vegetables', 'Fresh Fruits', 'Exotics & Premium', 'Organic Produce'],
  },
  grocery: {
    name: 'Grocery',
    banner: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=1200&q=80',
    subs: ['All', 'Rice', 'Atta', 'Flour', 'Dal', 'Pulses', 'Sugar', 'Dry Fruits'],
  },
};

export default function CategoryDetailPage({ params }: { params: { id: string } }) {
  const slug = params.id || 'fresh-fruits-vegetables';
  const category = categoryNames[slug] || categoryNames['fresh-fruits-vegetables'];
  const products = mockProducts[slug] || mockProducts['fresh-fruits-vegetables'];

  const [activeSub, setActiveSub] = useState('All');
  const [search, setSearch] = useState('');
  const [cartCount, setCartCount] = useState(0);

  const filteredProducts = products.filter((p) => {
    const matchesSub = activeSub === 'All' || p.sub === activeSub;
    const matchesSearch = p.name.toLowerCase().includes(search.toLowerCase());
    return matchesSub && matchesSearch;
  });

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
              {category.name}
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
          <img src={category.banner} alt={category.name} className="w-full h-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/60 to-transparent" />
          <div className="absolute bottom-6 left-6 right-6">
            <span className="inline-flex items-center gap-1 px-3 py-1 bg-teal-500 text-slate-950 text-xs font-bold rounded-full mb-2 uppercase">
              <Sparkles className="w-3.5 h-3.5" /> Express 10-Min Delivery
            </span>
            <h2 className="text-2xl md:text-4xl font-extrabold font-outfit text-white">
              {category.name}
            </h2>
          </div>
        </div>

        {/* Subcategories & Search */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
          {/* Subcategory Tabs */}
          <div className="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-none">
            {category.subs.map((sub) => (
              <button
                key={sub}
                onClick={() => setActiveSub(sub)}
                className={`px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition ${
                  activeSub === sub
                    ? 'bg-teal-500 text-slate-950'
                    : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
                }`}
              >
                {sub}
              </button>
            ))}
          </div>

          {/* Search Input */}
          <div className="relative w-full md:w-64">
            <Search className="w-4 h-4 absolute left-3 top-3 text-slate-400" />
            <input
              type="text"
              placeholder={`Search in ${category.name}...`}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full bg-slate-800 border border-slate-700 rounded-xl pl-9 pr-4 py-2 text-xs text-white placeholder-slate-400 focus:outline-none focus:border-teal-500"
            />
          </div>
        </div>

        {/* Product Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {filteredProducts.map((p) => (
            <div
              key={p.id}
              className="bg-slate-800 border border-slate-700/60 rounded-2xl overflow-hidden flex flex-col justify-between hover:border-teal-500/50 transition duration-300"
            >
              <div className="relative">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src={p.imageUrl} alt={p.name} className="w-full h-48 object-cover" />
                <span className="absolute top-3 left-3 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-md">
                  {Math.round(((p.mrp - p.price) / p.mrp) * 100)}% OFF
                </span>
                <button className="absolute top-3 right-3 p-2 bg-slate-900/80 text-rose-400 rounded-full hover:bg-rose-500 hover:text-white transition">
                  <Heart className="w-4 h-4" />
                </button>
              </div>

              <div className="p-4">
                <div className="flex items-center gap-1 text-amber-400 text-xs font-bold mb-1">
                  <Star className="w-3.5 h-3.5 fill-amber-400" />
                  <span>{p.rating}</span>
                </div>
                <h3 className="text-sm font-bold font-outfit text-white line-clamp-1">{p.name}</h3>
                <p className="text-xs text-slate-400 font-inter mt-0.5">{p.subtitle}</p>

                <div className="mt-4 flex items-center justify-between">
                  <div>
                    <span className="text-lg font-bold font-outfit text-teal-400">₹{p.price}</span>
                    <span className="text-xs text-slate-500 line-through ml-1.5">₹{p.mrp}</span>
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
      </main>
    </div>
  );
}
