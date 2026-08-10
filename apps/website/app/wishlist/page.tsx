// Google Stitch Screen ID: 538a08fbfe7b48218ebe496fdd5635e9
// Title: My Wishlist - Daily Basket Elite Website Elite
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';

import Link from 'next/link';

interface FavoriteProduct {
  id: string;
  name: string;
  brand: string;
  weight: string;
  price: number;
  mrp: number;
  discountPercent: number;
  category: string;
  categoryId: string;
  stockStatus: 'IN_STOCK' | 'LOW_STOCK' | 'OUT_OF_STOCK';
  imageUrl: string;
}

const INITIAL_FAVORITES: FavoriteProduct[] = [
  {
    id: 'prod-001',
    name: 'Organic Farm Fresh Tomatoes',
    brand: 'Organic India',
    weight: '500g',
    mrp: 55,
    price: 45,
    discountPercent: 18,
    category: 'Fresh Vegetables',
    categoryId: 'cat-veg',
    stockStatus: 'IN_STOCK',
    imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
  },
  {
    id: 'prod-003',
    name: 'Amul Taaza Toned Fresh Milk',
    brand: 'Amul',
    weight: '1 L',
    mrp: 75,
    price: 68,
    discountPercent: 9,
    category: 'Dairy & Eggs',
    categoryId: 'cat-dairy',
    stockStatus: 'IN_STOCK',
    imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
  },
  {
    id: 'prod-005',
    name: 'Aashirvaad Shuddh Chakki Atta',
    brand: 'Aashirvaad',
    weight: '5 kg',
    mrp: 310,
    price: 265,
    discountPercent: 15,
    category: 'Atta, Rice & Dal',
    categoryId: 'cat-staples',
    stockStatus: 'IN_STOCK',
    imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
  },
  {
    id: 'prod-007',
    name: 'Cold-Pressed Almond Oil',
    brand: 'Banyan Botanicals',
    weight: '500 ml',
    mrp: 699,
    price: 599,
    discountPercent: 14,
    category: 'Oils & Ghee',
    categoryId: 'cat-oils',
    stockStatus: 'LOW_STOCK',
    imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
  },
];

export default function WishlistPage() {
  const [favorites, setFavorites] = useState<FavoriteProduct[]>(INITIAL_FAVORITES);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('ALL');
  const [sortBy, setSortBy] = useState('RECENTLY_ADDED');

  const removeFavorite = (id: string) => {
    setFavorites((prev) => prev.filter((item) => item.id !== id));
  };

  const clearAllFavorites = () => {
    if (confirm('Are you sure you want to clear all items from your wishlist?')) {
      setFavorites([]);
    }
  };

  const filteredFavorites = favorites
    .filter((item) => {
      const matchesCategory = selectedCategory === 'ALL' || item.categoryId === selectedCategory;
      const matchesSearch =
        item.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        item.brand.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    })
    .sort((a, b) => {
      if (sortBy === 'PRICE_LOW_HIGH') return a.price - b.price;
      if (sortBy === 'PRICE_HIGH_LOW') return b.price - a.price;
      if (sortBy === 'ALPHABETICAL') return a.name.localeCompare(b.name);
      return 0;
    });

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between border-b border-slate-800 pb-6 mb-8 gap-4">
          <div>
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <span>My Favorites</span>
              <span className="text-red-500 text-2xl">❤️</span>
            </h1>
            <p className="text-slate-400 text-sm mt-1">
              {favorites.length} saved product{favorites.length !== 1 ? 's' : ''} in your wishlist
            </p>
          </div>
          {favorites.length > 0 && (
            <button
              onClick={clearAllFavorites}
              className="self-start md:self-auto px-4 py-2 bg-red-500/10 text-red-400 hover:bg-red-500/20 border border-red-500/30 rounded-xl text-sm font-semibold transition"
            >
              Clear All Wishlist
            </button>
          )}
        </div>

        {/* Search & Filter Bar */}
        <div className="flex flex-col md:flex-row gap-4 mb-8">
          <div className="flex-1 relative">
            <input
              type="text"
              placeholder="Search within favorites..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-slate-800 border border-slate-700 rounded-xl py-3 px-4 pl-10 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-teal-500 transition"
            />
            <svg
              className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>

          <div className="flex items-center gap-3">
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="bg-slate-800 border border-slate-700 rounded-xl py-3 px-4 text-sm text-white focus:outline-none focus:border-teal-500"
            >
              <option value="ALL">All Categories</option>
              <option value="cat-veg">Fresh Vegetables</option>
              <option value="cat-dairy">Dairy & Eggs</option>
              <option value="cat-staples">Atta, Rice & Dal</option>
              <option value="cat-oils">Oils & Ghee</option>
            </select>

            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="bg-slate-800 border border-slate-700 rounded-xl py-3 px-4 text-sm text-white focus:outline-none focus:border-teal-500"
            >
              <option value="RECENTLY_ADDED">Recently Added</option>
              <option value="PRICE_LOW_HIGH">Price: Low → High</option>
              <option value="PRICE_HIGH_LOW">Price: High → Low</option>
              <option value="ALPHABETICAL">Alphabetical</option>
            </select>
          </div>
        </div>

        {/* Product Grid */}
        {filteredFavorites.length === 0 ? (
          <div className="text-center py-20 bg-slate-800/40 rounded-3xl border border-slate-800">
            <div className="w-20 h-20 bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-4 text-slate-500 text-3xl">
              ❤️
            </div>
            <h3 className="text-xl font-bold text-white mb-2">No Wishlist Items Found</h3>
            <p className="text-slate-400 text-sm mb-6">
              {favorites.length === 0
                ? 'Your wishlist is currently empty. Explore our fresh items and save your favorites!'
                : 'No favorite products match your active search filter.'}
            </p>
            <Link
              href="/"
              className="inline-block px-6 py-3 bg-teal-600 hover:bg-teal-500 text-white font-bold rounded-xl transition"
            >
              Browse Products
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {filteredFavorites.map((product) => (
              <div
                key={product.id}
                className="bg-slate-800 border border-slate-700/60 rounded-2xl overflow-hidden flex flex-col justify-between hover:border-teal-500/50 transition duration-300"
              >
                <div className="relative">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={product.imageUrl}
                    alt={product.name}
                    className="w-full h-48 object-cover"
                  />
                  {product.discountPercent > 0 && (
                    <span className="absolute top-3 left-3 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-md">
                      {product.discountPercent}% OFF
                    </span>
                  )}
                  <button
                    onClick={() => removeFavorite(product.id)}
                    className="absolute top-3 right-3 p-2 bg-slate-900/80 hover:bg-red-500/20 text-red-500 rounded-full backdrop-blur-sm transition"
                    title="Remove from favorites"
                  >
                    ❤️
                  </button>
                </div>

                <div className="p-4 flex-1 flex flex-col justify-between">
                  <div>
                    <span className="text-xs font-semibold text-teal-400">{product.brand}</span>
                    <h4 className="text-sm font-bold text-white mt-1 line-clamp-2">{product.name}</h4>
                    <p className="text-xs text-slate-400 mt-1">{product.weight}</p>
                  </div>

                  <div className="mt-4 pt-3 border-t border-slate-700/50">
                    <div className="flex items-baseline justify-between mb-3">
                      <div>
                        <span className="text-lg font-bold text-teal-400">₹{product.price}</span>
                        {product.mrp > product.price && (
                          <span className="text-xs text-slate-500 line-through ml-2">₹{product.mrp}</span>
                        )}
                      </div>
                      <span
                        className={`text-[10px] font-bold px-2 py-0.5 rounded ${
                          product.stockStatus === 'IN_STOCK'
                            ? 'bg-emerald-500/20 text-emerald-400'
                            : 'bg-amber-500/20 text-amber-400'
                        }`}
                      >
                        {product.stockStatus === 'IN_STOCK' ? 'IN STOCK' : 'LOW STOCK'}
                      </span>
                    </div>

                    <button
                      onClick={() => alert(`Added "${product.name}" to cart!`)}
                      className="w-full py-2.5 bg-teal-600 hover:bg-teal-500 text-white text-xs font-bold rounded-xl transition flex items-center justify-center gap-2"
                    >
                      🛒 Add to Cart
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
