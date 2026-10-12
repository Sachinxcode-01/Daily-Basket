'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  Truck,
  Search,
  ArrowRight,
  PackageCheck,
  Clock,
  MapPin,
  Bike,
  ShieldCheck,
  ChevronRight,
  HelpCircle,
  Sparkles,
} from 'lucide-react';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';
import { formatCurrency } from '@daily-basket/shared-utils';

interface ActiveOrderPreview {
  id: string;
  itemsSummary: string;
  itemsCount: number;
  total: number;
  status: 'OUT_FOR_DELIVERY' | 'PACKING' | 'DELIVERED';
  statusLabel: string;
  statusColor: string;
  eta: string;
  riderName?: string;
  placedTime: string;
}

export default function TrackingHubPage() {
  const router = useRouter();
  const [orderQuery, setOrderQuery] = useState('');
  const [errorMsg, setErrorMsg] = useState('');

  const sampleOrders: ActiveOrderPreview[] = [
    {
      id: 'ORD-9824',
      itemsSummary: 'Amul Taaza Milk (1L), Fresho Tomatoes (1kg), Farm Fresh Eggs (6pcs)',
      itemsCount: 3,
      total: 245,
      status: 'OUT_FOR_DELIVERY',
      statusLabel: 'Out for Delivery (Live)',
      statusColor: 'bg-emerald-500 text-white animate-pulse',
      eta: 'Arriving in 5 mins',
      riderName: 'Ramesh Kumar (Speed Delivery Partner)',
      placedTime: '12 mins ago',
    },
    {
      id: 'ORD-8921',
      itemsSummary: 'English Oven Brown Bread (400g), Epigamia Greek Yogurt (100g)',
      itemsCount: 2,
      total: 135,
      status: 'DELIVERED',
      statusLabel: 'Delivered',
      statusColor: 'bg-slate-100 text-slate-700',
      eta: 'Delivered safely at doorstep',
      riderName: 'Suresh Patel',
      placedTime: 'Yesterday, 8:45 AM',
    },
    {
      id: 'ORD-7612',
      itemsSummary: 'Aashirvaad Select Sharbati Atta (5kg), Tata Salt (1kg)',
      itemsCount: 2,
      total: 410,
      status: 'DELIVERED',
      statusLabel: 'Delivered',
      statusColor: 'bg-slate-100 text-slate-700',
      eta: 'Delivered safely at doorstep',
      riderName: 'Vikram Singh',
      placedTime: '3 days ago',
    },
  ];

  const handleTrackSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = orderQuery.trim().toUpperCase();
    if (!trimmed) {
      setErrorMsg('Please enter a valid Order ID (e.g. ORD-9824)');
      return;
    }
    setErrorMsg('');
    router.push(`/tracking/${trimmed}`);
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-inter">
      <HeaderNavBar />

      <main className="flex-1 max-w-4xl w-full mx-auto px-4 sm:px-6 py-8 sm:py-12">
        {/* Page Header */}
        <div className="text-center max-w-2xl mx-auto mb-10">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-50 text-[#006b23] text-xs font-bold font-outfit uppercase tracking-wider mb-4 border border-emerald-200/60">
            <Truck className="w-3.5 h-3.5" />
            <span>10-Minute Rapid Dispatch Hub</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-slate-900 font-outfit tracking-tight">
            Live Order Tracking
          </h1>
          <p className="text-sm text-slate-600 mt-2 font-inter">
            Monitor real-time GPS telemetry, rider movement, and grocery dispatch milestones live.
          </p>
        </div>

        {/* Order ID Search Form Card */}
        <div className="bg-white rounded-3xl p-6 sm:p-8 border border-slate-200/80 shadow-md mb-10">
          <form onSubmit={handleTrackSubmit} className="space-y-4">
            <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 font-outfit">
              Lookup Any Order By ID
            </label>
            <div className="flex flex-col sm:flex-row items-stretch gap-3">
              <div className="relative flex-1">
                <Search className="w-5 h-5 text-slate-400 absolute left-4 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={orderQuery}
                  onChange={(e) => {
                    setOrderQuery(e.target.value);
                    if (errorMsg) setErrorMsg('');
                  }}
                  placeholder="Enter Order ID (e.g. ORD-9824)"
                  className="w-full h-12 pl-12 pr-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-semibold text-slate-900 placeholder-slate-400 focus:outline-none focus:border-[#006b23] focus:ring-2 focus:ring-[#006b23]/10 uppercase font-outfit"
                />
              </div>
              <button
                type="submit"
                className="h-12 px-6 bg-[#006b23] hover:bg-[#00531a] active:scale-98 text-white font-bold text-sm rounded-2xl shadow-md transition-all flex items-center justify-center gap-2 font-outfit"
              >
                <span>Track Live</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>
            {errorMsg && <p className="text-xs text-red-600 font-semibold">{errorMsg}</p>}

            <div className="flex flex-wrap items-center gap-2 pt-2 text-xs text-slate-500">
              <span>Quick Demo Test:</span>
              <button
                type="button"
                onClick={() => router.push('/tracking/ORD-9824')}
                className="font-bold text-[#006b23] hover:underline bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200/50"
              >
                Track Live Order #ORD-9824 →
              </button>
            </div>
          </form>
        </div>

        {/* Recent & Active Orders Section */}
        <div className="space-y-4 mb-12">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-bold text-slate-900 font-outfit flex items-center gap-2">
              <PackageCheck className="w-5 h-5 text-[#006b23]" />
              Recent Orders & Live Deliveries
            </h2>
            <span className="text-xs text-slate-400 font-medium">3 Orders Found</span>
          </div>

          <div className="space-y-4">
            {sampleOrders.map((order) => (
              <div
                key={order.id}
                className="bg-white rounded-2xl p-5 sm:p-6 border border-slate-200/80 shadow-xs hover:border-emerald-300 transition-all flex flex-col md:flex-row md:items-center justify-between gap-4 group"
              >
                <div className="space-y-2 flex-1">
                  <div className="flex flex-wrap items-center gap-2.5">
                    <span className="font-extrabold text-sm text-slate-900 font-outfit">
                      {order.id}
                    </span>
                    <span
                      className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full ${order.statusColor}`}
                    >
                      {order.statusLabel}
                    </span>
                    <span className="text-xs text-slate-400 flex items-center gap-1">
                      <Clock className="w-3 h-3" />
                      {order.placedTime}
                    </span>
                  </div>

                  <p className="text-xs text-slate-600 line-clamp-1">
                    {order.itemsSummary}
                  </p>

                  <div className="flex flex-wrap items-center gap-4 text-xs text-slate-500 pt-1">
                    <span className="flex items-center gap-1 font-semibold text-slate-800">
                      Total: {formatCurrency(order.total)}
                    </span>
                    {order.riderName && (
                      <span className="flex items-center gap-1 text-slate-600">
                        <Bike className="w-3.5 h-3.5 text-[#006b23]" />
                        {order.riderName}
                      </span>
                    )}
                    <span className="text-[#006b23] font-bold flex items-center gap-1">
                      <MapPin className="w-3.5 h-3.5" />
                      {order.eta}
                    </span>
                  </div>
                </div>

                <div className="shrink-0 flex items-center gap-3 pt-3 md:pt-0 border-t md:border-t-0 border-slate-100">
                  <Link
                    href={`/tracking/${order.id}`}
                    className="w-full md:w-auto h-10 px-5 bg-slate-900 hover:bg-[#006b23] text-white rounded-xl text-xs font-bold font-outfit flex items-center justify-center gap-2 transition-all shadow-xs group-hover:bg-[#006b23]"
                  >
                    <span>Track Live GPS</span>
                    <ChevronRight className="w-4 h-4" />
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Customer Help Strip */}
        <div className="bg-white rounded-2xl border border-slate-200/80 p-5 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center shrink-0">
              <HelpCircle className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-slate-900 font-outfit">
                Need immediate help with your delivery?
              </h3>
              <p className="text-xs text-slate-500">
                Contact our 24/7 delivery support team or chat with our live representative.
              </p>
            </div>
          </div>
          <Link
            href="/support"
            className="text-xs font-bold text-[#006b23] hover:underline px-4 py-2 rounded-xl bg-emerald-50 border border-emerald-200/60 shrink-0 font-outfit"
          >
            Contact Support Desk →
          </Link>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-slate-200/80 py-8 px-4 text-center text-xs text-slate-500">
        <p>© 2026 Daily Basket Quick-Commerce Suite. 10-Minute Live Telemetry Dispatch.</p>
      </footer>
    </div>
  );
}
