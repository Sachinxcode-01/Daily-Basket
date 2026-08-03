'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Zap, Phone, MessageSquare, MapPin, CheckCircle2, Navigation, Clock, ShieldCheck } from 'lucide-react';

export default function OrderTrackingPage({ params }: { params: { id: string } }) {
  const [currentStep, setCurrentStep] = useState(2); // 0: Confirmed, 1: Packing, 2: Out for Delivery, 3: Delivered

  const steps = [
    { label: 'Order Confirmed', time: '10:02 PM', done: true },
    { label: 'Packing at Hub Store #01', time: '10:04 PM', done: true },
    { label: 'Out for Delivery', time: '10:06 PM', active: true },
    { label: 'Arriving at Doorstep', time: '10:12 PM', done: false },
  ];

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-20 max-w-4xl mx-auto">
      {/* Top Header */}
      <div className="flex items-center justify-between py-3 border-b border-slate-800 mb-4">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Store</span>
        </Link>
        <h1 className="text-base font-extrabold text-white">Live Delivery Tracking</h1>
        <span className="text-xs text-emerald-400 font-bold bg-emerald-500/10 border border-emerald-500/30 px-2.5 py-1 rounded-full">
          Order #{params.id || 'DB-892104'}
        </span>
      </div>

      <div className="space-y-6">
        {/* Live ETA Card */}
        <div className="bg-gradient-to-r from-emerald-900/60 to-teal-900/40 border border-emerald-500/40 p-6 rounded-3xl shadow-xl flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wider mb-1">
              <Zap className="w-4 h-4 fill-emerald-400" />
              <span>Instant Delivery</span>
            </div>
            <h2 className="text-3xl font-black text-white">Arriving in 6 Mins</h2>
            <p className="text-xs text-emerald-200 mt-1">Delivery partner is on the way with your order</p>
          </div>
          <div className="w-16 h-16 rounded-2xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400">
            <Clock className="w-8 h-8 animate-pulse" />
          </div>
        </div>

        {/* Simulated GPS Route Map Box */}
        <div className="relative h-48 bg-slate-800 border border-slate-700/60 rounded-3xl overflow-hidden shadow-inner flex items-center justify-center">
          <div className="absolute inset-0 opacity-30 bg-[radial-gradient(#10b981_1px,transparent_1px)] [background-size:16px_16px]" />
          <div className="relative z-10 flex items-center gap-8">
            <div className="flex flex-col items-center">
              <div className="w-10 h-10 rounded-full bg-slate-700 border border-slate-600 flex items-center justify-center text-slate-300 font-bold text-xs">
                HUB
              </div>
              <span className="text-[10px] text-slate-400 font-semibold mt-1">Store #01</span>
            </div>

            <div className="w-28 h-1 bg-gradient-to-r from-slate-700 via-emerald-500 to-emerald-400 rounded-full relative">
              <div className="absolute -top-3.5 left-1/2 -translate-x-1/2 w-8 h-8 rounded-full bg-emerald-500 border-2 border-white shadow-lg flex items-center justify-center text-white">
                <Navigation className="w-4 h-4" />
              </div>
            </div>

            <div className="flex flex-col items-center">
              <div className="w-10 h-10 rounded-full bg-emerald-600 border border-emerald-400 flex items-center justify-center text-white font-bold text-xs shadow-lg">
                YOU
              </div>
              <span className="text-[10px] text-emerald-400 font-semibold mt-1">Home</span>
            </div>
          </div>
        </div>

        {/* Delivery Partner Contact Card */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="relative">
              <img
                src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80"
                alt="Driver Ramesh"
                className="w-12 h-12 object-cover rounded-full border-2 border-emerald-500"
              />
              <span className="absolute bottom-0 right-0 w-3.5 h-3.5 bg-emerald-500 border-2 border-slate-900 rounded-full" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-white">Ramesh Kumar</h3>
              <p className="text-xs text-slate-400">KA 01 EB 4821 • ⭐ 4.9 Rating</p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <a
              href="tel:+919876500112"
              className="p-3 bg-emerald-600/20 hover:bg-emerald-600 border border-emerald-500/50 text-emerald-400 hover:text-white rounded-xl transition"
            >
              <Phone className="w-4 h-4" />
            </a>
            <button className="p-3 bg-slate-700/50 hover:bg-slate-700 border border-slate-600 text-slate-200 rounded-xl transition">
              <MessageSquare className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Step Status Timeline */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl space-y-4">
          <h3 className="text-sm font-bold text-white mb-2">Order Step Timeline</h3>
          <div className="space-y-4">
            {steps.map((st, idx) => (
              <div key={st.label} className="flex items-center gap-3">
                <div
                  className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${
                    st.done
                      ? 'bg-emerald-500 text-white'
                      : st.active
                      ? 'bg-amber-500 text-white animate-pulse'
                      : 'bg-slate-700 text-slate-400'
                  }`}
                >
                  {st.done ? '✓' : idx + 1}
                </div>
                <div className="flex-1 flex items-center justify-between">
                  <span className={`text-xs font-bold ${st.active ? 'text-emerald-400' : st.done ? 'text-white' : 'text-slate-500'}`}>
                    {st.label}
                  </span>
                  <span className="text-[10px] text-slate-500">{st.time}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
