/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useRef, useState } from 'react';
import Link from 'next/link';
import { ChevronLeft, ChevronRight, Plus, Check, Star, Leaf } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { WebsiteProduct } from '../lib/catalog';
import { useCart } from '../store/useCart';

interface ProductRecommendationsCarouselProps {
  title: string;
  subtitle?: string;
  badge?: string;
  products: WebsiteProduct[];
  onClear?: () => void;
  clearLabel?: string;
}

export function ProductRecommendationsCarousel({
  title,
  subtitle,
  badge,
  products,
  onClear,
  clearLabel,
}: ProductRecommendationsCarouselProps) {
  const scrollRef = useRef<HTMLDivElement>(null);
  const { addItem } = useCart();
  const [addedIds, setAddedIds] = useState<Set<string>>(new Set());

  if (!products || products.length === 0) return null;

  const scroll = (direction: 'left' | 'right') => {
    if (scrollRef.current) {
      const offset = direction === 'left' ? -320 : 320;
      scrollRef.current.scrollBy({ left: offset, behavior: 'smooth' });
    }
  };

  const handleAdd = (e: React.MouseEvent, p: WebsiteProduct) => {
    e.preventDefault();
    e.stopPropagation();

    addItem.mutate({
      variantId: p.variantId || `var_${p.id}`,
      productName: p.name,
      unitName: p.unitName,
      price: p.price,
      quantity: 1,
    });

    setAddedIds((prev) => new Set(prev).add(p.id));
    setTimeout(() => {
      setAddedIds((prev) => {
        const next = new Set(prev);
        next.delete(p.id);
        return next;
      });
    }, 1800);
  };

  return (
    <div className="py-2">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <div>
          <div className="flex items-center gap-2">
            <h3 className="text-lg font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
              {title}
            </h3>
            {badge && (
              <span className="text-[10px] font-extrabold uppercase px-2 py-0.5 rounded-full bg-emerald-100 text-[#15803d]">
                {badge}
              </span>
            )}
          </div>
          {subtitle && <p className="text-xs text-[#64748b] mt-0.5">{subtitle}</p>}
        </div>

        <div className="flex items-center gap-2">
          {onClear && (
            <button
              onClick={onClear}
              className="text-xs font-semibold text-[#64748b] hover:text-[#191c1e] px-2 py-1 transition"
            >
              {clearLabel || 'Clear'}
            </button>
          )}

          <div className="hidden sm:flex items-center gap-1.5">
            <button
              onClick={() => scroll('left')}
              className="w-8 h-8 rounded-full border border-[#e2e2e5] hover:border-slate-400 bg-white flex items-center justify-center text-[#191c1e] transition shadow-xs active:scale-95"
              aria-label="Previous"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <button
              onClick={() => scroll('right')}
              className="w-8 h-8 rounded-full border border-[#e2e2e5] hover:border-slate-400 bg-white flex items-center justify-center text-[#191c1e] transition shadow-xs active:scale-95"
              aria-label="Next"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Product Card Row */}
      <div
        ref={scrollRef}
        className="flex items-stretch gap-3 overflow-x-auto scrollbar-none py-2 -mx-1 px-1"
      >
        {products.map((p) => {
          const isAdded = addedIds.has(p.id);

          return (
            <Link
              key={p.id}
              href={`/product/${p.id}`}
              className="group flex-shrink-0 w-44 sm:w-48 bg-white border border-[#e2e2e5] hover:border-[#2d9d43] rounded-2xl p-3 flex flex-col justify-between shadow-xs hover:shadow-md transition-all duration-200"
            >
              {/* Image & Badges */}
              <div className="relative w-full aspect-square bg-[#f9f9fc] rounded-xl overflow-hidden mb-2.5 flex items-center justify-center p-2">
                <img
                  src={p.image}
                  alt={p.name}
                  className="w-full h-full object-contain group-hover:scale-105 transition-transform duration-300"
                  loading="lazy"
                />

                {/* Discount Badge */}
                {p.discount > 0 && (
                  <span className="absolute top-2 left-2 bg-[#ba1a1a] text-white text-[10px] font-extrabold px-1.5 py-0.5 rounded shadow-xs">
                    {p.discount}% OFF
                  </span>
                )}

                {/* Organic Pill */}
                {p.isOrganic && (
                  <span className="absolute bottom-2 left-2 bg-emerald-600/90 text-white text-[9px] font-bold px-1.5 py-0.5 rounded-full flex items-center gap-0.5 backdrop-blur-xs">
                    <Leaf className="w-2.5 h-2.5" /> Organic
                  </span>
                )}
              </div>

              {/* Title & Brand */}
              <div>
                <span className="text-[10px] uppercase font-bold text-[#64748b] block truncate">
                  {p.brand}
                </span>
                <h4
                  className="text-xs font-bold text-[#191c1e] group-hover:text-[#2d9d43] line-clamp-2 transition mt-0.5"
                  title={p.name}
                >
                  {p.name}
                </h4>
                <p className="text-[11px] text-[#64748b] mt-0.5">{p.unitName}</p>

                {/* Rating */}
                {p.rating && (
                  <div className="flex items-center gap-1 mt-1 text-[11px] text-[#64748b]">
                    <span className="flex items-center gap-0.5 font-bold text-[#191c1e] bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200/60">
                      {p.rating} <Star className="w-3 h-3 fill-amber-400 text-amber-400" />
                    </span>
                    <span className="text-[10px]">({p.reviews || 120})</span>
                  </div>
                )}
              </div>

              {/* Price & Add Button */}
              <div className="flex items-center justify-between pt-3 mt-2 border-t border-[#eceef0]">
                <div>
                  <span className="text-sm font-extrabold text-[#191c1e]">
                    {formatCurrency(p.price)}
                  </span>
                  {p.mrp > p.price && (
                    <span className="text-[10px] text-[#64748b] line-through ml-1 block">
                      {formatCurrency(p.mrp)}
                    </span>
                  )}
                </div>

                <button
                  onClick={(e) => handleAdd(e, p)}
                  className={`w-8 h-8 rounded-full flex items-center justify-center font-bold transition shadow-xs active:scale-95 ${
                    isAdded
                      ? 'bg-[#15803d] text-white'
                      : 'bg-[#2d9d43] hover:bg-[#078730] text-white'
                  }`}
                  title="Add to cart"
                  aria-label={`Add ${p.name} to cart`}
                >
                  {isAdded ? <Check className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
                </button>
              </div>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
