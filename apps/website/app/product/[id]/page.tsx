/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState, useMemo } from 'react';
import Link from 'next/link';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';

export default function ProductDetailsPage({ params }: { params: { id?: string } }) {
  const productId = params.id ?? '';

  const [selectedVariantId, setSelectedVariantId] = useState<string | null>(null);
  const [quantity, setQuantity] = useState(1);
  const [activeThumb, setActiveThumb] = useState(0);
  const [isFavorited, setIsFavorited] = useState(false);
  const [detailsOpen, setDetailsOpen] = useState(true);

  const { data: product, isLoading, isError, refetch } = useQuery({
    queryKey: ['product', productId],
    queryFn: () => apiClient.getProductDetails(productId),
    enabled: Boolean(productId),
  });

  const p: any = product;
  const images: string[] = useMemo(
    () => (Array.isArray(p?.images) && p.images.length > 0 ? p.images : ['https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80']),
    [p],
  );
  const variants: any[] = Array.isArray(p?.variants) ? p.variants : [];
  const selectedVariant = useMemo(
    () => variants.find((v) => v.id === selectedVariantId) ?? variants.find((v) => v.isAvailable) ?? variants[0] ?? null,
    [variants, selectedVariantId],
  );
  const price = selectedVariant?.price ?? 0;
  const mrp = selectedVariant?.mrp ?? price;
  const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
  const reviewCount = Array.isArray(p?.reviews) ? p.reviews.length : 0;

  if (isLoading) {
    return (
      <div className="bg-[#f9f9fc] min-h-screen pt-20 max-w-7xl mx-auto md:grid md:grid-cols-2 md:gap-8 md:p-12 md:pt-24 animate-pulse">
        <div className="w-full aspect-square bg-[#eeeef0] md:rounded-2xl" />
        <div className="p-4 md:p-0 space-y-4">
          <div className="h-4 bg-[#eeeef0] rounded w-1/3" />
          <div className="h-8 bg-[#eeeef0] rounded w-2/3" />
          <div className="h-6 bg-[#eeeef0] rounded w-1/4" />
          <div className="h-24 bg-[#eeeef0] rounded" />
        </div>
      </div>
    );
  }

  if (isError || !product) {
    return (
      <div className="bg-[#f9f9fc] min-h-screen flex flex-col items-center justify-center gap-4 text-center px-4">
        <div className="text-5xl">🛒</div>
        <h1 className="text-xl font-bold text-[#1a1c1e]">Product not found</h1>
        <p className="text-sm text-[#3f4a3d]">This product may be unavailable or the link is invalid.</p>
        <div className="flex gap-3">
          <button onClick={() => refetch()} className="bg-[#006b23] text-white text-sm font-bold px-5 py-2.5 rounded-xl hover:bg-[#078730]">
            Retry
          </button>
          <Link href="/" className="bg-[#eeeef0] text-[#1a1c1e] text-sm font-bold px-5 py-2.5 rounded-xl hover:bg-[#e2e2e5]">
            Back to Home
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-[#f9f9fc] text-[#1a1c1e] font-sans antialiased pb-24 md:pb-0 min-h-screen">
      {/* TopAppBar */}
      <header className="fixed top-0 w-full z-50 bg-[#f9f9fc]/80 backdrop-blur-xl shadow-sm flex items-center justify-between px-4 h-16">
        <Link href="/" className="text-[#006b23] p-2 -ml-2 rounded-full hover:opacity-80 transition-opacity">
          <span className="material-symbols-outlined">arrow_back</span>
        </Link>
        <div className="font-headline text-xl font-bold text-[#006b23]">Daily Basket</div>
        <Link href="/search" className="text-[#006b23] p-2 -mr-2 rounded-full hover:opacity-80 transition-opacity">
          <span className="material-symbols-outlined">search</span>
        </Link>
      </header>

      {/* Main Container */}
      <main className="pt-16 max-w-7xl mx-auto md:grid md:grid-cols-2 md:gap-8 md:p-12 md:pt-24">
        {/* Image Gallery Section */}
        <section className="relative md:sticky md:top-24 h-fit">
          <div className="relative w-full aspect-square md:rounded-2xl overflow-hidden bg-[#f3f3f6]">
            <img
              src={images[activeThumb] ?? images[0]}
              alt={p.name}
              className="w-full h-full object-cover"
            />

            <div className="absolute top-4 right-4 flex flex-col gap-3">
              <button
                onClick={() => setIsFavorited(!isFavorited)}
                className="w-10 h-10 rounded-full bg-white/80 backdrop-blur-md flex items-center justify-center text-[#1a1c1e] hover:bg-white transition-colors shadow-sm"
              >
                <span className={`material-symbols-outlined ${isFavorited ? 'fill text-rose-600' : ''}`}>
                  favorite
                </span>
              </button>
              <button className="w-10 h-10 rounded-full bg-white/80 backdrop-blur-md flex items-center justify-center text-[#1a1c1e] hover:bg-white transition-colors shadow-sm">
                <span className="material-symbols-outlined">share</span>
              </button>
            </div>

            {p.isOrganic && (
              <div className="absolute top-4 left-4 bg-[#078730] text-[#f7fff2] px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1 shadow-sm">
                <span className="material-symbols-outlined text-[16px]">eco</span>
                Certified Organic
              </div>
            )}
          </div>

          {/* Thumbnails */}
          {images.length > 1 && (
            <div className="flex gap-4 p-4 md:p-0 md:mt-4 overflow-x-auto">
              {images.map((img, index) => (
                <div
                  key={index}
                  onClick={() => setActiveThumb(index)}
                  className={`w-20 h-20 rounded-xl overflow-hidden border-2 cursor-pointer flex-shrink-0 transition-all ${
                    activeThumb === index ? 'border-[#006b23]' : 'border-transparent opacity-70 hover:opacity-100'
                  }`}
                >
                  <img src={img} alt={`Thumbnail ${index + 1}`} className="w-full h-full object-cover" />
                </div>
              ))}
            </div>
          )}
        </section>

        {/* Product Details Section */}
        <section className="px-4 md:px-0 flex flex-col gap-6">
          {/* Header Info */}
          <div>
            {p.brand && <p className="text-[#006b23] text-sm font-semibold mb-1">{p.brand}</p>}
            <h1 className="font-headline text-3xl md:text-4xl font-bold text-[#1a1c1e] mb-2">
              {p.name}
            </h1>
            {reviewCount > 0 && (
              <div className="flex items-center gap-2 mb-4">
                <span className="material-symbols-outlined fill text-[18px] text-[#F59E0B]">star</span>
                <span className="text-[#3f4a3d] text-sm">({reviewCount} Reviews)</span>
              </div>
            )}

            <div className="flex items-end gap-3 mb-2">
              <span className="font-headline text-3xl font-bold text-[#1a1c1e]">
                {formatCurrency(price * quantity)}
              </span>
              {mrp > price && (
                <>
                  <span className="text-[#3f4a3d] line-through text-lg mb-1">
                    {formatCurrency(mrp * quantity)}
                  </span>
                  <span className="bg-[#ffdad6] text-[#93000a] px-2 py-0.5 rounded-md text-xs font-bold mb-1.5">
                    -{discount}%
                  </span>
                </>
              )}
            </div>
            <p className="text-[#3f4a3d] text-sm">
              Delivery in <span className="font-semibold text-[#006b23]">10 mins</span>
            </p>
          </div>

          {/* Variant Selection */}
          {variants.length > 0 && (
            <div className="border-t border-[#e2e2e5] pt-6">
              <h3 className="font-headline text-lg font-semibold mb-3 text-[#1a1c1e]">Select Pack</h3>
              <div className="flex gap-3 flex-wrap">
                {variants.map((v) => {
                  const isSelected = selectedVariant?.id === v.id;
                  return (
                    <button
                      key={v.id}
                      disabled={!v.isAvailable}
                      onClick={() => setSelectedVariantId(v.id)}
                      className={`py-3 px-4 rounded-xl border-2 font-semibold flex flex-col items-center justify-center transition-all min-w-[96px] ${
                        isSelected
                          ? 'border-[#006b23] bg-[#006b23]/5 text-[#006b23]'
                          : 'border-[#e2e2e5] text-[#3f4a3d] hover:bg-[#eeeef0]'
                      } ${!v.isAvailable ? 'opacity-40 cursor-not-allowed' : ''}`}
                    >
                      <span className="text-lg">{v.unitName}</span>
                      <span className="text-xs opacity-80">{formatCurrency(v.price)}</span>
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          {/* Accordion Details */}
          <div className="mt-4 flex flex-col gap-4">
            <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white">
              <button
                onClick={() => setDetailsOpen(!detailsOpen)}
                className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f3f3f6] transition-colors"
              >
                <span className="font-headline font-semibold text-[#1a1c1e]">Product Details</span>
                <span className={`material-symbols-outlined transition-transform duration-300 ${detailsOpen ? 'rotate-180' : ''}`}>
                  expand_more
                </span>
              </button>
              {detailsOpen && (
                <div className="p-4 pt-0 text-sm text-[#3f4a3d] leading-relaxed border-t border-[#e2e2e5]">
                  {p.description || 'No description available for this product.'}
                </div>
              )}
            </div>
          </div>
        </section>
      </main>

      {/* Bottom Action Bar */}
      <div className="fixed bottom-0 left-0 w-full bg-white border-t border-[#e2e2e5] p-4 z-40 md:relative md:border-none md:p-0 md:mt-8 md:bg-transparent">
        <div className="max-w-7xl mx-auto flex gap-4 md:justify-end">
          <div className="flex items-center justify-between bg-[#eeeef0] rounded-xl px-2 h-14 md:w-32 border border-[#e2e2e5]">
            <button
              onClick={() => setQuantity(Math.max(1, quantity - 1))}
              className="w-10 h-10 flex items-center justify-center text-[#1a1c1e] hover:bg-[#e2e2e5] rounded-lg transition-colors"
            >
              <span className="material-symbols-outlined">remove</span>
            </button>
            <span className="font-headline font-semibold text-lg w-8 text-center">{quantity}</span>
            <button
              onClick={() => setQuantity(quantity + 1)}
              className="w-10 h-10 flex items-center justify-center text-[#1a1c1e] hover:bg-[#e2e2e5] rounded-lg transition-colors"
            >
              <span className="material-symbols-outlined">add</span>
            </button>
          </div>

          <button
            disabled={!selectedVariant}
            className="flex-1 md:flex-none md:w-64 bg-[#006b23] hover:bg-[#078730] disabled:opacity-50 text-white font-headline font-semibold text-lg rounded-xl h-14 flex items-center justify-center shadow-md active:scale-95 transition-all"
          >
            Add to Cart - {formatCurrency(price * quantity)}
          </button>
        </div>
      </div>
    </div>
  );
}
