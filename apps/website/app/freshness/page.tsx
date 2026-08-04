'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Leaf, ShieldCheck, Sun, Plus, Award } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

interface FreshProduce {
  id: string;
  name: string;
  origin: string;
  freshnessScore: number;
  harvestedDate: string;
  price: number;
  mrp: number;
  image: string;
}

const produceItems: FreshProduce[] = [
  {
    id: 'f1',
    name: 'Organic Hydroponic Spinach',
    origin: 'Koramangala Organic Farm #4',
    freshnessScore: 99,
    harvestedDate: 'Today, 5:30 AM',
    price: 35,
    mrp: 50,
    image: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80',
  },
  {
    id: 'f2',
    name: 'Crisp Farm-Fresh Broccoli',
    origin: 'Ooty Hills Co-op Farm',
    freshnessScore: 98,
    harvestedDate: 'Today, 4:00 AM',
    price: 65,
    mrp: 90,
    image: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&q=80',
  },
  {
    id: 'f3',
    name: 'Sweet Crunchy Carrots',
    origin: 'Mysuru Local Greenhouses',
    freshnessScore: 97,
    harvestedDate: 'Yesterday Evening',
    price: 28,
    mrp: 40,
    image: 'https://images.unsplash.com/photo-1598170845058-12ef4a45753b?w=400&q=80',
  },
  {
    id: 'f4',
    name: 'Organic Red Bell Peppers',
    origin: 'Polyhouse Farm #12',
    freshnessScore: 99,
    harvestedDate: 'Today, 6:00 AM',
    price: 75,
    mrp: 110,
    image: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400&q=80',
  },
];

export default function FreshnessPage() {
  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl font-extrabold text-slate-900 font-outfit">
              Fresh Produce Explorer
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6 space-y-8">
        
        {/* Origin Hero Banner */}
        <div className="bg-[#006b23] text-white rounded-3xl p-6 sm:p-10 shadow-lg relative overflow-hidden flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-2 max-w-lg">
            <span className="inline-block px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider">
              100% Traceable & Organic
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold font-outfit leading-tight">
              Directly Harvested Every Morning
            </h2>
            <p className="text-white/90 text-sm font-inter">
              Every item has a verified harvest timestamp and farm location origin tag.
            </p>
          </div>

          <div className="w-20 h-20 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center flex-shrink-0">
            <Leaf className="w-10 h-10 text-white" />
          </div>
        </div>

        {/* Produce Grid */}
        <div className="space-y-4">
          <h3 className="text-lg font-bold text-slate-900 font-outfit">
            Today's Fresh Harvest
          </h3>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {produceItems.map((item) => (
              <div
                key={item.id}
                className="bg-white rounded-2xl p-4 border border-slate-100 shadow-sm flex flex-col justify-between hover:shadow-md transition group"
              >
                <div>
                  <div className="relative w-full aspect-square bg-slate-50 rounded-xl overflow-hidden mb-3 p-2">
                    <img
                      src={item.image}
                      alt={item.name}
                      className="w-full h-full object-cover rounded-lg group-hover:scale-105 transition duration-300"
                    />
                    <span className="absolute top-3 right-3 bg-emerald-600 text-white text-[10px] font-extrabold px-2.5 py-1 rounded-full shadow-md flex items-center gap-1">
                      <Award className="w-3 h-3" />
                      {item.freshnessScore}% Fresh
                    </span>
                  </div>

                  <span className="text-[11px] font-semibold text-[#006b23] uppercase tracking-wider block">
                    📍 {item.origin}
                  </span>
                  <h4 className="font-outfit font-bold text-base text-slate-900 mt-1">
                    {item.name}
                  </h4>
                  <p className="text-xs text-slate-400 font-inter mt-1">
                    Harvested: {item.harvestedDate}
                  </p>
                </div>

                <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between">
                  <div>
                    <span className="font-outfit font-extrabold text-base text-slate-900">
                      {formatCurrency(item.price)}
                    </span>
                    {item.mrp > item.price && (
                      <span className="text-xs text-slate-400 line-through ml-1.5">
                        {formatCurrency(item.mrp)}
                      </span>
                    )}
                  </div>

                  <button className="w-9 h-9 rounded-full bg-slate-100 text-[#006b23] hover:bg-[#006b23] hover:text-white flex items-center justify-center font-bold transition">
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>

      </main>
    </div>
  );
}
