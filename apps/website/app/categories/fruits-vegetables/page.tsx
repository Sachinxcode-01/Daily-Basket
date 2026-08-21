'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

/**
 * Fresh Fruits & Vegetables Product Listing Page
 * Stitch Screen ID: f8d0070376a249618783bc48ce8cf9a8
 */
export default function FreshFruitsVegetablesPage() {
  const router = useRouter();
  const [selectedFilter, setSelectedFilter] = useState('Seasonal');
  const [cartCount, setCartCount] = useState(0);

  const filters = ['Sort', 'Seasonal', 'Organic', 'Price'];

  const products = [
    {
      id: 'prod_gala_apple',
      name: 'Royal Gala Apple',
      subtitle: 'Daily Basket Select',
      unit: '500g',
      price: 140,
      mrp: 160,
      badge: '10% OFF',
      badgeClass: 'bg-[#ba1a1a] text-white',
      inStock: true,
      category: 'Seasonal',
      image:
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600&auto=format&fit=crop&q=80',
    },
    {
      id: 'prod_banana_cavendish',
      name: 'Premium Cavendish Banana',
      subtitle: 'Organic',
      unit: '1 kg',
      price: 65,
      mrp: 75,
      badge: 'Out of Stock',
      inStock: false,
      category: 'Organic',
      image:
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=600&auto=format&fit=crop&q=80',
    },
    {
      id: 'prod_baby_spinach',
      name: 'Organic Baby Spinach',
      subtitle: 'Local Farm',
      unit: '200g',
      price: 45,
      mrp: 55,
      badge: 'Daily Basket Select',
      badgeClass: 'bg-[#078730] text-white',
      inStock: true,
      category: 'Organic',
      image:
        'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=600&auto=format&fit=crop&q=80',
    },
    {
      id: 'prod_dutch_carrots',
      name: 'Dutch Carrots with Tops',
      subtitle: 'Daily Basket Select',
      unit: '1 Bunch',
      price: 55,
      mrp: 65,
      badge: 'New',
      badgeClass: 'bg-[#dce5dd] text-[#404943]',
      inStock: true,
      category: 'Seasonal',
      image:
        'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600&auto=format&fit=crop&q=80',
    },
  ];

  return (
    <div className="min-h-screen bg-[#f9f9fc] font-['Inter'] text-[#1a1c1e] pb-24">
      {/* Top Header */}
      <header className="sticky top-0 w-full z-50 bg-[#f9f9fc]/80 backdrop-blur-xl shadow-sm border-b border-[#e2e2e5] flex justify-between items-center px-4 h-16 max-w-7xl mx-auto">
        <button
          onClick={() => router.back()}
          className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-[#e8e8ea] transition-colors"
        >
          <span className="material-symbols-outlined text-[#006b23]">arrow_back</span>
        </button>
        <h1 className="font-['Outfit'] text-lg font-semibold text-[#006b23] truncate px-2 text-center flex-1">
          Fresh Fruits &amp; Vegetables
        </h1>
        <Link href="/cart" className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-[#e8e8ea] text-[#006b23] relative">
          <span className="material-symbols-outlined">shopping_basket</span>
          {cartCount > 0 && (
            <span className="absolute top-2 right-2 w-2 h-2 bg-[#ba1a1a] rounded-full" />
          )}
        </Link>
      </header>

      {/* Sub Header & Filter Chips */}
      <div className="sticky top-16 bg-[#f9f9fc]/95 backdrop-blur-md z-40 border-b border-[#eeeef0] py-2.5 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 flex flex-col gap-2">
          <span className="text-xs text-[#3f4a3d] font-medium">48 products</span>
          <div className="flex gap-2 overflow-x-auto hide-scrollbar pb-1">
            {filters.map((f) => {
              const isSelected = selectedFilter === f;
              return (
                <button
                  key={f}
                  onClick={() => setSelectedFilter(f)}
                  className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                    isSelected
                      ? 'bg-[#078730]/15 border border-[#078730] text-[#078730]'
                      : 'bg-white border border-[#becab9] text-[#3f4a3d] hover:bg-[#f3f3f6]'
                  }`}
                >
                  {f === 'Sort' && <span className="material-symbols-outlined text-sm mr-1 align-middle">swap_vert</span>}
                  {f}
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Product Grid */}
      <main className="max-w-7xl mx-auto px-4 py-6">
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {products.map((p) => (
            <div
              key={p.id}
              className="bg-white rounded-2xl p-3 shadow-sm border border-[#e2e2e5] flex flex-col relative group hover:-translate-y-0.5 transition-transform"
            >
              {p.badge && p.inStock && (
                <span className={`absolute top-2 left-2 text-[10px] font-bold px-2 py-0.5 rounded-full z-10 ${p.badgeClass}`}>
                  {p.badge}
                </span>
              )}

              {!p.inStock && (
                <div className="absolute inset-0 bg-white/70 backdrop-blur-[2px] z-20 rounded-2xl flex items-center justify-center pointer-events-none">
                  <span className="bg-[#e8e8ea] text-[#1a1c1e] px-3 py-1 rounded-full text-xs font-semibold shadow-sm border border-[#becab9]/40">
                    Out of Stock
                  </span>
                </div>
              )}

              <div className="relative w-full aspect-square mb-2.5 rounded-xl overflow-hidden bg-[#eeeef0]">
                <img src={p.image} alt={p.name} className="w-full h-full object-cover" />
              </div>

              <div className="flex-1 flex flex-col">
                <span className="text-[10px] text-[#3f4a3d] font-semibold tracking-wider uppercase mb-0.5">
                  {p.subtitle}
                </span>
                <h3 className="font-['Outfit'] text-sm font-semibold text-[#1a1c1e] line-clamp-2 mb-1">
                  {p.name}
                </h3>
                <span className="text-xs text-[#6e7a6c] mb-auto">{p.unit}</span>

                <div className="flex items-center justify-between mt-3">
                  <div>
                    <span className="font-['Outfit'] text-base font-bold text-[#006b23]">
                      ₹{p.price}
                    </span>
                    {p.mrp && (
                      <span className="text-[10px] text-[#3f4a3d] line-through ml-1.5">
                        ₹{p.mrp}
                      </span>
                    )}
                  </div>

                  <button
                    onClick={() => p.inStock && setCartCount((c) => c + 1)}
                    disabled={!p.inStock}
                    className={`w-8 h-8 rounded-full flex items-center justify-center shadow-md active:scale-90 transition-all ${
                      p.inStock
                        ? 'bg-[#006b23] hover:bg-[#078730] text-white'
                        : 'bg-[#e8e8ea] text-[#3f4a3d]/50 cursor-not-allowed'
                    }`}
                  >
                    <span className="material-symbols-outlined text-lg">add</span>
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
