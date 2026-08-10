'use client';

import React, { useState } from 'react';
import Link from 'next/link';

interface QuickItem {
  id: string;
  name: string;
  unit: string;
  price: string;
  tag?: string;
  image: string;
  hero?: boolean;
}

const quickItems: QuickItem[] = [
  {
    id: 'qb_1',
    name: 'Fresh Whole Milk',
    unit: '1 Gallon',
    price: '₹249',
    tag: 'Express',
    image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=600&q=80',
    hero: true,
  },
  {
    id: 'qb_2',
    name: 'Artisan Sliced Bread',
    unit: '400g',
    price: '₹65',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&q=80',
  },
  {
    id: 'qb_3',
    name: 'Free-Range Brown Eggs',
    unit: '12 ct',
    price: '₹140',
    tag: 'Organic',
    image: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=600&q=80',
  },
  {
    id: 'qb_4',
    name: 'Greek Plain Yogurt',
    unit: '500g',
    price: '₹199',
    tag: 'Bestseller',
    image: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=600&q=80',
  },
];

export default function QuickBuyPage() {
  const [addedIds, setAddedIds] = useState<Record<string, boolean>>({});

  const handleAdd = (id: string) => {
    setAddedIds((prev) => ({ ...prev, [id]: true }));
    setTimeout(() => {
      setAddedIds((prev) => ({ ...prev, [id]: false }));
    }, 1200);
  };

  return (
    <main className="min-h-screen bg-surface text-on-surface py-8 px-4 md:px-12 max-w-5xl mx-auto flex flex-col gap-8">
      {/* Header / Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-on-surface-variant">
        <Link href="/" className="hover:text-primary">Home</Link>
        <span>/</span>
        <span className="text-on-surface font-medium">Quick Buy Essentials</span>
      </div>

      {/* Greeting Banner */}
      <section className="bg-primary-container/10 p-6 rounded-2xl border border-primary/20 flex flex-col gap-1">
        <h1 className="font-headline text-3xl font-bold text-on-surface">Good Morning!</h1>
        <p className="font-body text-on-surface-variant">
          Your daily essentials are ready to restock in 1-click.
        </p>
      </section>

      {/* Buy Again Bento Grid */}
      <section className="flex flex-col gap-4">
        <div className="flex items-center justify-between">
          <h2 className="font-headline text-2xl font-semibold text-on-surface">Buy Again</h2>
          <span className="font-label text-sm text-primary font-semibold uppercase tracking-wider">
            10-min delivery
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {quickItems.map((item) => {
            const isAdded = addedIds[item.id];
            if (item.hero) {
              return (
                <div
                  key={item.id}
                  className="col-span-1 md:col-span-2 flex items-center bg-surface-container-lowest rounded-2xl p-4 shadow-sm border border-surface-variant/40 relative group hover:shadow-md transition-shadow"
                >
                  <div className="w-28 h-28 rounded-xl overflow-hidden bg-surface-container flex-shrink-0 mr-4">
                    <img
                      src={item.image}
                      alt={item.name}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                  </div>
                  <div className="flex flex-col justify-between h-full flex-grow py-1">
                    <div>
                      {item.tag && (
                        <span className="inline-block px-2 py-0.5 bg-secondary-container text-on-secondary-container font-label text-[10px] uppercase font-bold rounded-full mb-1">
                          {item.tag}
                        </span>
                      )}
                      <h3 className="font-body text-lg font-semibold text-on-surface leading-tight">
                        {item.name}
                      </h3>
                      <p className="font-body text-sm text-on-surface-variant mt-0.5">{item.unit}</p>
                    </div>
                    <div className="flex items-center justify-between mt-3">
                      <span className="font-headline text-xl font-bold text-primary">{item.price}</span>
                    </div>
                  </div>
                  <button
                    onClick={() => handleAdd(item.id)}
                    className={`absolute bottom-4 right-4 w-10 h-10 rounded-full flex items-center justify-center shadow-md transition-all ${
                      isAdded
                        ? 'bg-secondary-container text-primary'
                        : 'bg-primary text-on-primary hover:bg-primary-container active:scale-95'
                    }`}
                  >
                    <span className="material-symbols-outlined">{isAdded ? 'check' : 'add'}</span>
                  </button>
                </div>
              );
            }

            return (
              <div
                key={item.id}
                className="col-span-1 flex flex-col bg-surface-container-lowest rounded-2xl p-4 shadow-sm border border-surface-variant/40 relative group hover:shadow-md transition-shadow"
              >
                <div className="w-full aspect-square rounded-xl overflow-hidden bg-surface-container mb-3 relative">
                  {item.tag && (
                    <span className="absolute top-2 left-2 px-2 py-0.5 bg-primary/10 text-primary font-label text-[10px] uppercase font-bold rounded-full z-10 backdrop-blur-sm">
                      {item.tag}
                    </span>
                  )}
                  <img
                    src={item.image}
                    alt={item.name}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                </div>
                <div className="flex flex-col flex-grow">
                  <h3 className="font-body text-sm font-semibold text-on-surface leading-tight mb-1">
                    {item.name}
                  </h3>
                  <p className="font-body text-xs text-on-surface-variant mb-2">{item.unit}</p>
                  <div className="mt-auto flex items-center justify-between">
                    <span className="font-headline text-base font-bold text-primary">{item.price}</span>
                  </div>
                </div>
                <button
                  onClick={() => handleAdd(item.id)}
                  className={`absolute bottom-3 right-3 w-8 h-8 rounded-full flex items-center justify-center transition-all ${
                    isAdded
                      ? 'bg-secondary-container text-primary'
                      : 'bg-secondary-container text-primary hover:bg-primary hover:text-on-primary active:scale-95'
                  }`}
                >
                  <span className="material-symbols-outlined text-[20px]">{isAdded ? 'check' : 'add'}</span>
                </button>
              </div>
            );
          })}
        </div>
      </section>
    </main>
  );
}
