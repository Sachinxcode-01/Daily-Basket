'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Bell, ShoppingBag, Tag, AlertCircle, CheckCheck } from 'lucide-react';

interface Notification {
  id: string;
  title: string;
  message: string;
  time: string;
  category: 'Orders' | 'Offers' | 'System';
  unread: boolean;
}

const initialNotifications: Notification[] = [
  {
    id: 'n1',
    title: 'Order Delivered! 🚚',
    message: 'Your order #ORD-9824 has been delivered fresh to your doorstep.',
    time: '2 mins ago',
    category: 'Orders',
    unread: true,
  },
  {
    id: 'n2',
    title: '50% OFF Flash Sale Live! ⚡',
    message: 'Get 50% OFF on all organic fruits & fresh veggies for the next 2 hours.',
    time: '1 hour ago',
    category: 'Offers',
    unread: true,
  },
  {
    id: 'n3',
    title: 'Wallet Cashback Credited 💰',
    message: '₹50 cashback has been added to your Daily Basket wallet.',
    time: 'Yesterday',
    category: 'System',
    unread: false,
  },
];

export default function NotificationsPage() {
  const [filter, setFilter] = useState('All');
  const [notifications, setNotifications] = useState(initialNotifications);

  const markAllRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, unread: false })));
  };

  const filtered = filter === 'All'
    ? notifications
    : notifications.filter((n) => n.category === filter);

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl font-extrabold text-slate-900 font-outfit">
              Notification Center
            </h1>
          </div>

          <button
            onClick={markAllRead}
            className="text-xs font-bold text-[#006b23] hover:underline flex items-center gap-1 font-inter"
          >
            <CheckCheck className="w-4 h-4" />
            <span>Mark all read</span>
          </button>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-6">
        
        {/* Filter Tabs */}
        <div className="flex items-center gap-2 overflow-x-auto scrollbar-none pb-1">
          {['All', 'Orders', 'Offers', 'System'].map((tab) => (
            <button
              key={tab}
              onClick={() => setFilter(tab)}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition ${
                filter === tab
                  ? 'bg-[#006b23] text-white shadow-md shadow-[#006b23]/20'
                  : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
              }`}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* Notifications List */}
        <div className="space-y-3">
          {filtered.map((item) => (
            <div
              key={item.id}
              className={`p-4 rounded-2xl border transition flex items-start gap-4 ${
                item.unread
                  ? 'bg-white border-emerald-200/80 shadow-sm'
                  : 'bg-slate-50 border-slate-200/60 opacity-80'
              }`}
            >
              <div className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 ${
                item.category === 'Orders'
                  ? 'bg-emerald-100 text-[#006b23]'
                  : item.category === 'Offers'
                  ? 'bg-amber-100 text-amber-600'
                  : 'bg-blue-100 text-blue-600'
              }`}>
                {item.category === 'Orders' ? (
                  <ShoppingBag className="w-5 h-5" />
                ) : item.category === 'Offers' ? (
                  <Tag className="w-5 h-5" />
                ) : (
                  <Bell className="w-5 h-5" />
                )}
              </div>

              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between gap-2">
                  <h3 className="font-outfit font-bold text-sm text-slate-900">
                    {item.title}
                  </h3>
                  <span className="text-xs text-slate-400 font-inter whitespace-nowrap">
                    {item.time}
                  </span>
                </div>
                <p className="text-xs text-slate-600 font-inter leading-relaxed mt-1">
                  {item.message}
                </p>
              </div>
            </div>
          ))}
        </div>

      </main>
    </div>
  );
}
