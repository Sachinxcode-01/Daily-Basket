'use client';

import React, { useState } from 'react';
import Link from 'next/link';

interface WatchedItem {
  id: string;
  name: string;
  unit: string;
  price: string;
  imageUrl: string;
  isAlertEnabled: boolean;
}

const initialItems: WatchedItem[] = [
  {
    id: 'sa_1',
    name: 'Organic Hass Avocados',
    unit: 'Pack of 4',
    price: '₹180',
    imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&q=80',
    isAlertEnabled: true,
  },
  {
    id: 'sa_2',
    name: 'A2 Cow Milk (1L)',
    unit: '1 Litre Bottle',
    price: '₹85',
    imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80',
    isAlertEnabled: true,
  },
  {
    id: 'sa_3',
    name: 'Alfonso Mangoes',
    unit: '1 kg Box',
    price: '₹450',
    imageUrl: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
    isAlertEnabled: false,
  },
];

export default function StockAlertsPage() {
  const [globalEnabled, setGlobalEnabled] = useState(true);
  const [items, setItems] = useState<WatchedItem[]>(initialItems);

  const toggleItem = (id: string) => {
    setItems((prev) =>
      prev.map((item) => (item.id === id ? { ...item, isAlertEnabled: !item.isAlertEnabled } : item))
    );
  };

  const toggleGlobal = () => {
    const nextState = !globalEnabled;
    setGlobalEnabled(nextState);
    setItems((prev) => prev.map((item) => ({ ...item, isAlertEnabled: nextState })));
  };

  return (
    <main className="min-h-screen bg-surface text-on-surface py-8 px-4 max-w-3xl mx-auto w-full flex flex-col gap-6">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-on-surface-variant">
        <Link href="/" className="hover:text-primary">Home</Link>
        <span>/</span>
        <span className="text-on-surface font-medium">Stock Alerts</span>
      </div>

      <div>
        <h1 className="font-headline text-2xl md:text-3xl font-bold text-on-surface mb-2">
          Back to Stock Alerts
        </h1>
        <p className="font-body text-sm text-on-surface-variant">
          Manage your notifications for items that are currently out of stock. We will notify you instantly when they arrive.
        </p>
      </div>

      {/* Global Toggle Card */}
      <section className="bg-surface-container-lowest rounded-2xl shadow-sm p-4 md:p-6 border border-surface-variant/40 flex items-center justify-between">
        <div>
          <h2 className="font-headline text-base md:text-lg font-semibold text-on-surface">Enable All Alerts</h2>
          <p className="font-body text-xs md:text-sm text-on-surface-variant mt-1">
            Receive push & email notifications for all watched items.
          </p>
        </div>
        <button
          onClick={toggleGlobal}
          className={`w-12 h-6 rounded-full transition-colors relative flex items-center px-0.5 ${
            globalEnabled ? 'bg-primary' : 'bg-surface-variant'
          }`}
        >
          <div
            className={`w-5 h-5 rounded-full bg-white shadow-md transform transition-transform ${
              globalEnabled ? 'translate-x-6' : 'translate-x-0'
            }`}
          />
        </button>
      </section>

      {/* Currently Watching */}
      <section className="flex flex-col gap-4">
        <h2 className="font-headline text-lg font-semibold text-on-surface px-1">Currently Watching</h2>
        <div className="flex flex-col gap-3">
          {items.map((item) => (
            <div
              key={item.id}
              className="bg-surface-container-lowest rounded-2xl shadow-sm p-4 flex gap-4 items-center border border-surface-variant/40 hover:shadow-md transition-shadow"
            >
              <div className="w-20 h-20 rounded-xl bg-surface-container flex-shrink-0 overflow-hidden relative">
                <img src={item.imageUrl} alt={item.name} className="w-full h-full object-cover" />
                <span className="absolute bottom-1 left-1 bg-surface-container-lowest/90 text-error font-label text-[9px] font-bold px-1.5 py-0.5 rounded-full">
                  Out of Stock
                </span>
              </div>
              <div className="flex-grow min-w-0">
                <h3 className="font-headline text-base font-semibold text-on-surface truncate">{item.name}</h3>
                <p className="font-body text-xs text-on-surface-variant mb-1">{item.unit}</p>
                <p className="font-body text-sm text-primary font-bold">{item.price}</p>
              </div>
              <button
                onClick={() => toggleItem(item.id)}
                className={`w-12 h-6 rounded-full transition-colors relative flex items-center px-0.5 ${
                  item.isAlertEnabled ? 'bg-primary' : 'bg-surface-variant'
                }`}
              >
                <div
                  className={`w-5 h-5 rounded-full bg-white shadow-md transform transition-transform ${
                    item.isAlertEnabled ? 'translate-x-6' : 'translate-x-0'
                  }`}
                />
              </button>
            </div>
          ))}
        </div>
      </section>
    </main>
  );
}
