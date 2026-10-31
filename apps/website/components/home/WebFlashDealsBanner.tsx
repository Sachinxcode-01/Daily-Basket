'use client';

import React, { useState, useEffect } from 'react';
import Image from 'next/image';
import { formatCurrency } from '@daily-basket/shared-utils';
import { useCart } from '../../store/useCart';

interface FlashDealItem {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  unit: string;
  price: number;
  mrp: number;
  discount: string;
  claimedPercentage: number;
  image: string;
}

const FLASH_DEALS: FlashDealItem[] = [
  {
    id: 'fd_avocado',
    variantId: 'var_avocado_01',
    name: 'Organic Hass Avocados (2 pcs)',
    brand: 'Fresh Picks',
    unit: '2 pcs',
    price: 139,
    mrp: 220,
    discount: '37% OFF',
    claimedPercentage: 84,
    image: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400',
  },
  {
    id: 'fd_paneer',
    variantId: 'var_paneer_01',
    name: 'Malai Fresh Paneer Cube',
    brand: 'Amul Dairy',
    unit: '200g',
    price: 78,
    mrp: 115,
    discount: '32% OFF',
    claimedPercentage: 92,
    image: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400',
  },
  {
    id: 'fd_strawberries',
    variantId: 'var_strawberries_01',
    name: 'Mahabaleshwar Sweet Strawberries',
    brand: 'Berry Garden',
    unit: '250g Box',
    price: 89,
    mrp: 140,
    discount: '36% OFF',
    claimedPercentage: 68,
    image: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
  },
  {
    id: 'fd_cashews',
    variantId: 'var_cashews_01',
    name: 'Goa Premium Jumbo Cashews W320',
    brand: 'Daily Staples',
    unit: '250g Pack',
    price: 219,
    mrp: 350,
    discount: '37% OFF',
    claimedPercentage: 76,
    image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
  },
];

export default function WebFlashDealsBanner() {
  const { addItem, updateItem, activeItems } = useCart();

  // Countdown timer state (starts at 2 hours, 45 mins, 10 secs)
  const [secondsLeft, setSecondsLeft] = useState(2 * 3600 + 45 * 60 + 10);

  useEffect(() => {
    const timer = setInterval(() => {
      setSecondsLeft((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const hours = String(Math.floor(secondsLeft / 3600)).padStart(2, '0');
  const minutes = String(Math.floor((secondsLeft % 3600) / 60)).padStart(2, '0');
  const seconds = String(secondsLeft % 60).padStart(2, '0');

  const cartQty = (variantId: string) => {
    const item = activeItems.find((i) => i.variantId === variantId);
    return item ? item.quantity : 0;
  };

  const handleAdd = (item: FlashDealItem) => {
    const existing = activeItems.find((i) => i.variantId === item.variantId);
    if (existing) {
      updateItem.mutate({ itemId: existing.id, quantity: existing.quantity + 1 });
    } else {
      addItem.mutate({
        variantId: item.variantId,
        productName: item.name,
        unitName: item.unit,
        price: item.price,
        quantity: 1,
      });
    }
  };

  return (
    <section className="bg-gradient-to-r from-red-950 via-amber-950 to-emerald-950 rounded-3xl p-6 md:p-8 text-white shadow-level-2 border border-red-900/40 relative overflow-hidden space-y-6">
      {/* Background glow effects */}
      <div className="absolute -top-16 -right-16 w-64 h-64 bg-red-600/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute -bottom-16 -left-16 w-64 h-64 bg-amber-600/10 rounded-full blur-3xl pointer-events-none" />

      {/* Banner Top Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 relative z-10">
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-red-500/20 text-red-300 border border-red-500/30 text-[10px] font-extrabold uppercase tracking-widest animate-pulse">
              <span>⚡</span> LIVE FLASH SALE
            </span>
            <span className="text-xs text-amber-200/90 font-medium hidden sm:inline">
              Up to 45% OFF on Top Staples
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold font-outfit text-white tracking-tight">
            Lightning Deals of the Hour
          </h2>
        </div>

        {/* Live Ticking Countdown Timer */}
        <div className="flex items-center gap-2 bg-black/40 backdrop-blur-md px-4 py-2.5 rounded-2xl border border-white/15 self-start sm:self-auto">
          <span className="text-xs text-white/70 font-semibold uppercase tracking-wider">Ends in</span>
          <div className="flex items-center gap-1 font-mono text-sm sm:text-base font-extrabold text-amber-400">
            <span className="bg-white/10 px-2 py-0.5 rounded-lg">{hours}</span>
            <span>:</span>
            <span className="bg-white/10 px-2 py-0.5 rounded-lg">{minutes}</span>
            <span>:</span>
            <span className="bg-white/10 px-2 py-0.5 rounded-lg">{seconds}</span>
          </div>
        </div>
      </div>

      {/* Product Deal Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 relative z-10">
        {FLASH_DEALS.map((deal) => {
          const qty = cartQty(deal.variantId);
          return (
            <div
              key={deal.id}
              className="bg-white/10 hover:bg-white/15 backdrop-blur-md border border-white/15 rounded-2xl p-4 flex flex-col justify-between transition-all duration-300 hover:-translate-y-1 group"
            >
              <div>
                <div className="relative w-full aspect-square rounded-xl overflow-hidden mb-3 bg-black/20">
                  <Image
                    src={deal.image}
                    alt={deal.name}
                    fill
                    unoptimized
                    className="object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                  <span className="absolute top-2 left-2 bg-red-600 text-white text-[10px] font-extrabold px-2 py-0.5 rounded-full shadow-md">
                    {deal.discount}
                  </span>
                </div>

                <div className="text-[10px] uppercase font-bold text-amber-300">{deal.brand}</div>
                <h4 className="text-xs sm:text-sm font-bold text-white font-outfit line-clamp-2 mt-0.5">
                  {deal.name}
                </h4>
                <div className="text-[10px] text-white/70 mt-0.5">{deal.unit}</div>

                {/* Progress Claimed Bar */}
                <div className="mt-3 space-y-1">
                  <div className="flex justify-between text-[10px] text-white/75 font-medium">
                    <span>Claimed</span>
                    <span className="font-bold text-amber-300">{deal.claimedPercentage}%</span>
                  </div>
                  <div className="w-full bg-white/20 h-1.5 rounded-full overflow-hidden">
                    <div
                      className="bg-gradient-to-r from-amber-400 to-red-500 h-full rounded-full transition-all duration-500"
                      style={{ width: `${deal.claimedPercentage}%` }}
                    />
                  </div>
                </div>
              </div>

              {/* Price and Add button */}
              <div className="mt-4 pt-3 border-t border-white/10 flex items-center justify-between">
                <div>
                  <div className="text-base font-extrabold text-amber-300 font-outfit">
                    {formatCurrency(deal.price)}
                  </div>
                  <div className="text-[10px] text-white/60 line-through">
                    {formatCurrency(deal.mrp)}
                  </div>
                </div>

                <button
                  onClick={() => handleAdd(deal)}
                  className="bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold px-3.5 py-1.5 rounded-full shadow-md active:scale-95 transition-all flex items-center gap-1"
                >
                  <span>+ Add</span>
                  {qty > 0 && <span className="bg-white/30 px-1.5 py-0.2 rounded-full text-[10px]">{qty}</span>}
                </button>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}

