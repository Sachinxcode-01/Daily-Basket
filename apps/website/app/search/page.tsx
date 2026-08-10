// Google Stitch Screen ID: f7c78b705cb6471dae1b49027ca746b3
// Title: Premium Product Catalog & Search
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';

import Link from 'next/link';
import { Search, Camera, SlidersHorizontal, Plus, Check, ArrowLeft, Sparkles, Upload, X } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

interface SearchItem {
  id: string;
  name: string;
  weight: string;
  price: number;
  mrp: number;
  tag?: string;
  image: string;
  matchScore?: number;
}

const searchResults: SearchItem[] = [
  {
    id: 's1',
    name: 'Organic Farm Fresh Tomatoes',
    weight: '500g',
    price: 24,
    mrp: 40,
    tag: '40% OFF',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
    matchScore: 98,
  },
  {
    id: 's2',
    name: 'Fresh Cherry Tomatoes Pack',
    weight: '250g',
    price: 45,
    mrp: 60,
    tag: 'Organic',
    image: 'https://images.unsplash.com/photo-1546470427-227c7369a649?w=400&q=80',
    matchScore: 92,
  },
  {
    id: 's3',
    name: 'Aashirvaad Shuddh Chakki Atta',
    weight: '5 kg',
    price: 265,
    mrp: 299,
    tag: 'Best Seller',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    matchScore: 96,
  },
  {
    id: 's4',
    name: 'Amul Taaza Toned Fresh Milk',
    weight: '1 L',
    price: 54,
    mrp: 56,
    tag: 'Fresh',
    image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
    matchScore: 99,
  },
];

export default function SearchPage() {
  const [query, setQuery] = useState('Tomatoes');
  const [activeFilter, setActiveFilter] = useState('All');
  const [cart, setCart] = useState<Record<string, number>>({});
  const [isCameraModalOpen, setIsCameraModalOpen] = useState(false);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [visionMode, setVisionMode] = useState(false);

  const filters = ['All', 'Organic', 'On Sale', 'Under ₹50'];

  const toggleAdd = (id: string) => {
    setCart((prev) => ({
      ...prev,
      [id]: (prev[id] || 0) + 1,
    }));
  };

  const handleSimulateCameraSearch = () => {
    setIsAnalyzing(true);
    setTimeout(() => {
      setIsAnalyzing(false);
      setIsCameraModalOpen(false);
      setVisionMode(true);
      setQuery('AI Vision Captured Item');
    }, 1400);
  };

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
              onChange={(e) => {
                setQuery(e.target.value);
                setVisionMode(false);
              }}
              placeholder="Search for groceries, brand or scan camera..."
              className="w-full h-11 bg-slate-900 border border-slate-700 rounded-xl pl-11 pr-12 text-sm font-medium text-white placeholder:text-slate-400 focus:outline-none focus:border-teal-500 transition"
            />
            {/* Camera Action Button inside search bar */}
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
        {visionMode && (
          <div className="mb-6 p-4 rounded-2xl bg-teal-950/60 border border-teal-500/40 flex items-center gap-3">
            <Sparkles className="w-5 h-5 text-teal-400 shrink-0" />
            <div>
              <h3 className="text-sm font-bold font-outfit text-white">
                Results from AI Vision Camera Search
              </h3>
              <p className="text-xs text-teal-300 font-inter">
                Ranked by AI confidence match percentage & instant inventory availability.
              </p>
            </div>
          </div>
        )}

        <div className="flex items-center justify-between mb-4">
          <p className="text-sm font-medium text-slate-400 font-inter">
            Showing <span className="font-bold text-white">{searchResults.length} results</span> for &ldquo;{query}&rdquo;
          </p>
        </div>

        {/* Search Results Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
          {searchResults.map((item) => {
            const count = cart[item.id] || 0;
            return (
              <div
                key={item.id}
                className="bg-slate-800 border border-slate-700/70 hover:border-teal-500/50 rounded-2xl p-4 flex flex-col justify-between transition-all duration-300 hover:shadow-xl hover:shadow-teal-500/5"
              >
                <div>
                  <div className="relative aspect-square rounded-xl overflow-hidden mb-3 bg-slate-900">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img
                      src={item.image}
                      alt={item.name}
                      className="w-full h-full object-cover group-hover:scale-105 transition"
                    />
                    {item.matchScore && visionMode && (
                      <span className="absolute top-2 left-2 bg-teal-500 text-slate-950 text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
                        {item.matchScore}% MATCH
                      </span>
                    )}
                    {item.tag && !visionMode && (
                      <span className="absolute top-2 left-2 bg-emerald-500 text-white text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
                        {item.tag}
                      </span>
                    )}
                  </div>

                  <h3 className="font-bold text-sm text-white font-outfit line-clamp-2 mb-1">
                    {item.name}
                  </h3>
                  <p className="text-xs text-slate-400 font-inter mb-3">{item.weight}</p>
                </div>

                <div>
                  <div className="flex items-baseline gap-1.5 mb-3">
                    <span className="text-base font-extrabold text-teal-400 font-outfit">
                      {formatCurrency(item.price)}
                    </span>
                    <span className="text-xs text-slate-500 line-through font-inter">
                      {formatCurrency(item.mrp)}
                    </span>
                  </div>

                  <button
                    onClick={() => toggleAdd(item.id)}
                    className={`w-full h-9 rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 transition ${
                      count > 0
                        ? 'bg-teal-600 text-white'
                        : 'bg-teal-500 text-slate-950 hover:bg-teal-400'
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
      </main>

      {/* Camera Search Modal */}
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
              Point your camera at any grocery package, food label, bottle, or barcode to instantly search Daily Basket catalog.
            </p>

            {isAnalyzing ? (
              <div className="py-8 flex flex-col items-center gap-3">
                <div className="w-8 h-8 border-3 border-teal-500 border-t-transparent rounded-full animate-spin" />
                <p className="text-xs font-bold text-teal-400 animate-pulse">
                  Analyzing packaging & recognizing product...
                </p>
              </div>
            ) : (
              <div className="space-y-3">
                <button
                  onClick={handleSimulateCameraSearch}
                  className="w-full py-3 bg-teal-500 hover:bg-teal-400 text-slate-950 font-extrabold text-sm rounded-xl transition flex items-center justify-center gap-2"
                >
                  <Camera className="w-4 h-4" /> Open Camera / Scan Item
                </button>
                <button
                  onClick={handleSimulateCameraSearch}
                  className="w-full py-3 bg-slate-700 hover:bg-slate-600 text-white font-bold text-sm rounded-xl transition flex items-center justify-center gap-2"
                >
                  <Upload className="w-4 h-4" /> Upload Image from Device
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
