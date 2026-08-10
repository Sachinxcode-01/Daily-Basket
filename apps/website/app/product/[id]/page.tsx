// Google Stitch Screen ID: 6f96551c525b4b45b8a82ef5f64fbcbc
// Title: Premium Product Details - Daily Basket
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft, Star, ShoppingBag, Heart, Share2, ShieldCheck, Zap, Truck, Clock, Sparkles, Check } from 'lucide-react';
import HeaderNavBar from '../../../components/navigation/HeaderNavBar';

export default function ProductDetailsPage({ params }: { params: { id: string } }) {
  const [selectedQuantity, setSelectedQuantity] = useState(1);
  const [isAdded, setIsAdded] = useState(false);
  const [isFavorite, setIsFavorite] = useState(false);

  const product = {
    id: params.id || 'prod_milk_a2_01',
    name: 'Amul Taaza T-Special Toned Fresh Milk',
    brand: 'Amul Dairy',
    weight: '500 ml Pouch',
    price: 30,
    mrp: 32,
    rating: 4.8,
    reviewsCount: 8420,
    description: 'Pasteurised Toned Milk with minimum 3.0% Fat and 8.5% SNF. Sourced daily from local organic dairy farms with 10-minute cold chain guarantee.',
    nutritionalInfo: [
      { label: 'Energy', value: '58 kcal' },
      { label: 'Total Fat', value: '3.1 g' },
      { label: 'Protein', value: '3.2 g' },
      { label: 'Carbohydrate', value: '4.7 g' },
      { label: 'Calcium', value: '120 mg' },
    ],
    images: [
      'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800&q=80',
      'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=800&q=80',
    ],
  };

  const handleAdd = () => {
    setIsAdded(true);
    setTimeout(() => setIsAdded(false), 2000);
  };

  return (
    <div className="min-h-screen bg-[#F9F9FC] text-[#1A1C1E] flex flex-col">
      <HeaderNavBar />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 py-8">
        <Link href="/" className="inline-flex items-center gap-2 text-sm text-[#006B23] font-medium hover:underline mb-6">
          <ArrowLeft className="w-4 h-4" />
          <span>Back to Home Catalog</span>
        </Link>

        <div className="bg-white rounded-3xl p-6 md:p-10 border border-gray-100 shadow-xl grid grid-cols-1 md:grid-cols-2 gap-10">
          {/* Left Column: Image Gallery */}
          <div className="flex flex-col items-center">
            <div className="w-full h-[380px] md:h-[450px] relative rounded-2xl overflow-hidden bg-gray-50 border border-gray-100">
              <Image
                src={product.images[0]}
                alt={product.name}
                fill
                className="object-contain p-6"
                priority
              />
              <span className="absolute top-4 left-4 bg-[#006B23] text-white text-xs font-bold px-3 py-1 rounded-full shadow">
                ⚡ 10-MIN EXPRESS
              </span>
              <button
                onClick={() => setIsFavorite(!isFavorite)}
                className="absolute top-4 right-4 p-3 rounded-full bg-white shadow-md border border-gray-100 hover:bg-rose-50 transition"
              >
                <Heart className={`w-5 h-5 ${isFavorite ? 'fill-rose-500 text-rose-500' : 'text-gray-400'}`} />
              </button>
            </div>
          </div>

          {/* Right Column: Product Info & Actions */}
          <div className="flex flex-col justify-between">
            <div>
              <div className="text-xs font-bold text-[#006B23] tracking-wider uppercase mb-1">
                {product.brand}
              </div>
              <h1 className="text-2xl md:text-3xl font-extrabold font-outfit text-gray-900 mb-3">
                {product.name}
              </h1>
              <div className="flex items-center gap-4 mb-4 text-sm text-gray-600">
                <span className="bg-emerald-50 text-[#006B23] font-semibold px-2.5 py-1 rounded-lg border border-emerald-100">
                  {product.weight}
                </span>
                <div className="flex items-center gap-1 text-amber-500 font-bold">
                  <Star className="w-4 h-4 fill-current" />
                  <span>{product.rating}</span>
                  <span className="text-gray-400 font-normal">({product.reviewsCount} reviews)</span>
                </div>
              </div>

              {/* Price Row */}
              <div className="flex items-baseline gap-3 mb-6">
                <span className="text-3xl font-black font-outfit text-gray-900">
                  ₹{product.price}
                </span>
                <span className="text-lg text-gray-400 line-through">
                  ₹{product.mrp}
                </span>
                <span className="bg-emerald-100 text-[#006B23] text-xs font-bold px-2.5 py-1 rounded-full">
                  Save ₹{product.mrp - product.price}
                </span>
              </div>

              <p className="text-sm text-gray-600 leading-relaxed mb-6">
                {product.description}
              </p>

              {/* Nutritional Information Card */}
              <div className="bg-emerald-50/50 rounded-2xl p-4 border border-emerald-100 mb-8">
                <h3 className="text-xs font-bold text-[#006B23] uppercase tracking-wider mb-3 flex items-center gap-1.5">
                  <Sparkles className="w-3.5 h-3.5" />
                  Nutritional Highlights (Per 100ml)
                </h3>
                <div className="grid grid-cols-3 gap-2">
                  {product.nutritionalInfo.map((info, idx) => (
                    <div key={idx} className="bg-white p-2.5 rounded-xl border border-emerald-100/60 text-center">
                      <div className="text-[11px] text-gray-500">{info.label}</div>
                      <div className="text-sm font-bold text-gray-900">{info.value}</div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Action Bar */}
            <div className="flex items-center gap-4 pt-4 border-t border-gray-100">
              <button
                onClick={handleAdd}
                className={`flex-1 py-4 rounded-2xl font-bold font-outfit text-base transition-all duration-300 flex items-center justify-center gap-2 shadow-lg ${
                  isAdded
                    ? 'bg-emerald-700 text-white'
                    : 'bg-[#006B23] hover:bg-[#078730] text-white'
                }`}
              >
                {isAdded ? (
                  <>
                    <Check className="w-5 h-5" />
                    <span>Added to Daily Basket!</span>
                  </>
                ) : (
                  <>
                    <ShoppingBag className="w-5 h-5" />
                    <span>Add to Basket — ₹{product.price}</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
