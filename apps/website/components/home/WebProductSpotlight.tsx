'use client';

import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { formatCurrency } from '@daily-basket/shared-utils';
import { useCart } from '../../store/useCart';

export default function WebProductSpotlight() {
  const { addItem, updateItem, activeItems } = useCart();

  const spotlightProduct = {
    id: 'spotlight_amul_ghee',
    variantId: 'var_amul_ghee_1l',
    name: 'Amul Pure Cow Ghee 1L Tin',
    brand: 'Amul Dairy',
    unitName: '1 Litre Tin',
    price: 649,
    mrp: 750,
    discountPercentage: '13% OFF',
    rating: 4.9,
    reviews: 1420,
    image: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400',
    description: '100% pure traditional aroma clarified cow ghee. Prepared from fresh milk cream for rich culinary flavor and Ayurvedic purity.',
    badges: ['👑 #1 BESTSELLER', '🌱 100% PURE COW MILK'],
  };

  const sideTrending = [
    {
      id: 'side_atta',
      variantId: 'var_atta_10kg',
      name: 'Aashirvaad Shudh Chakki Atta 10kg',
      unit: '10 kg Bag',
      price: 435,
      mrp: 495,
      image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    },
    {
      id: 'side_oil',
      variantId: 'var_fortune_oil',
      name: 'Fortune Sunlite Refined Sunflower Oil',
      unit: '1 Litre Pouch',
      price: 138,
      mrp: 175,
      image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    },
    {
      id: 'side_tea',
      variantId: 'var_red_label',
      name: 'Brooke Bond Red Label Natural Care Tea',
      unit: '500g Pack',
      price: 285,
      mrp: 340,
      image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    },
  ];

  const cartQty = (variantId: string) => {
    return activeItems.find((i) => i.variantId === variantId)?.quantity ?? 0;
  };

  const handleAdd = (p: { variantId: string; name: string; unitName?: string; unit?: string; price: number }) => {
    const existing = activeItems.find((i) => i.variantId === p.variantId);
    if (existing) {
      updateItem.mutate({ itemId: existing.id, quantity: existing.quantity + 1 });
    } else {
      addItem.mutate({
        variantId: p.variantId,
        productName: p.name,
        unitName: p.unitName || p.unit || '1 unit',
        price: p.price,
        quantity: 1,
      });
    }
  };

  return (
    <section className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 border border-amber-200 text-amber-800 text-[11px] font-bold uppercase tracking-wider mb-1">
            <span>✨</span>
            <span>EDITOR&apos;S CHOICE & HIGHEST SAVINGS</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface">
            Deal of the Day Spotlight
          </h2>
        </div>
        <Link
          href="/catalog"
          className="text-xs sm:text-sm text-primary hover:text-emerald-700 font-bold flex items-center gap-1 transition-colors"
        >
          <span>Explore Kirana Catalog</span>
          <span>→</span>
        </Link>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Main Bento Hero Spotlight (Col-span 8) */}
        <div className="lg:col-span-8 bg-gradient-to-br from-emerald-950 via-slate-900 to-[#032b1b] rounded-3xl p-6 sm:p-8 text-white border border-emerald-900/40 shadow-level-2 relative overflow-hidden flex flex-col md:flex-row items-center gap-6 justify-between">
          <div className="space-y-3 flex-1 z-10">
            <div className="flex flex-wrap gap-2">
              {spotlightProduct.badges.map((b, i) => (
                <span
                  key={i}
                  className="bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-full"
                >
                  {b}
                </span>
              ))}
            </div>

            <div className="text-xs font-bold text-emerald-400 uppercase tracking-widest">
              {spotlightProduct.brand}
            </div>

            <h3 className="text-2xl sm:text-3xl font-extrabold font-outfit leading-tight text-white">
              {spotlightProduct.name}
            </h3>

            <p className="text-xs text-white/80 font-inter max-w-md leading-relaxed">
              {spotlightProduct.description}
            </p>

            <div className="flex items-center gap-3 pt-1">
              <div className="flex items-center gap-1 bg-amber-500/20 px-2 py-0.5 rounded-full text-xs font-bold text-amber-300 border border-amber-500/30">
                <span>★</span>
                <span>{spotlightProduct.rating}</span>
              </div>
              <span className="text-xs text-white/60">({spotlightProduct.reviews.toLocaleString()} reviews)</span>
              <span className="text-xs font-bold text-emerald-300 bg-emerald-500/10 px-2 py-0.5 rounded-full">
                {spotlightProduct.discountPercentage}
              </span>
            </div>

            <div className="pt-4 flex items-center gap-4">
              <div>
                <div className="text-2xl sm:text-3xl font-extrabold font-outfit text-white">
                  {formatCurrency(spotlightProduct.price)}
                </div>
                <div className="text-xs text-white/50 line-through">
                  MRP {formatCurrency(spotlightProduct.mrp)}
                </div>
              </div>

              <button
                onClick={() => handleAdd(spotlightProduct)}
                className="bg-primary hover:bg-emerald-600 text-white font-bold text-xs sm:text-sm px-6 py-3 rounded-full transition-all active:scale-95 shadow-lg flex items-center gap-2"
              >
                <span>+ Add to Daily Basket</span>
                {cartQty(spotlightProduct.variantId) > 0 && (
                  <span className="bg-white/20 px-2 py-0.5 rounded-full text-xs">
                    {cartQty(spotlightProduct.variantId)}
                  </span>
                )}
              </button>
            </div>
          </div>

          <div className="relative w-48 h-48 sm:w-60 sm:h-60 rounded-2xl overflow-hidden shadow-2xl flex-shrink-0 border-2 border-white/10">
            <Image
              src={spotlightProduct.image}
              alt={spotlightProduct.name}
              fill
              unoptimized
              className="object-cover"
            />
          </div>
        </div>

        {/* Right Trending Essentials Quick Buy Rail (Col-span 4) */}
        <div className="lg:col-span-4 bg-surface-container-low rounded-3xl p-6 border border-outline-variant/20 flex flex-col justify-between space-y-4">
          <div className="flex items-center justify-between border-b border-outline-variant/10 pb-3">
            <h4 className="font-bold text-sm font-outfit text-on-surface flex items-center gap-1.5">
              <span>🔥</span> Trending Daily Essentials
            </h4>
            <span className="text-[10px] font-extrabold uppercase bg-emerald-100 text-emerald-800 px-2 py-0.5 rounded-full">
              High Demand
            </span>
          </div>

          <div className="space-y-3 flex-1 flex flex-col justify-around">
            {sideTrending.map((item) => {
              const qty = cartQty(item.variantId);
              return (
                <div
                  key={item.id}
                  className="flex items-center gap-3 bg-surface-container-lowest p-3 rounded-2xl border border-outline-variant/10 hover:shadow-sm transition-all"
                >
                  <Image
                    src={item.image}
                    alt={item.name}
                    width={44}
                    height={44}
                    unoptimized
                    className="w-11 h-11 rounded-xl object-cover"
                  />
                  <div className="flex-1 min-w-0">
                    <div className="text-xs font-bold truncate text-on-surface">{item.name}</div>
                    <div className="text-[10px] text-on-surface-variant">{item.unit}</div>
                    <div className="text-xs font-bold text-primary mt-0.5">
                      {formatCurrency(item.price)}
                    </div>
                  </div>
                  <button
                    onClick={() => handleAdd(item)}
                    className="bg-primary text-white text-xs font-bold px-3 py-1.5 rounded-full hover:bg-emerald-700 active:scale-95 transition-all"
                  >
                    {qty > 0 ? `+${qty}` : '+ Add'}
                  </button>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}
