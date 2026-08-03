'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { CheckCircle2, Zap, Clock, ChevronRight, FileText } from 'lucide-react';

export default function OrderSuccessPage() {
  const [countdownSeconds, setCountdownSeconds] = useState(600); // 10 minutes

  useEffect(() => {
    const timer = setInterval(() => {
      setCountdownSeconds((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const mins = Math.floor(countdownSeconds / 60);
  const secs = countdownSeconds % 60;

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 flex flex-col justify-center items-center text-center max-w-md mx-auto">
      {/* Animated Success Badge */}
      <div className="w-20 h-20 rounded-full bg-emerald-500/20 border-2 border-emerald-500 flex items-center justify-center text-emerald-400 mb-6 animate-bounce">
        <CheckCircle2 className="w-12 h-12" />
      </div>

      <h1 className="text-3xl font-black text-white mb-2">Order Confirmed!</h1>
      <p className="text-slate-400 text-sm mb-6">
        Order ID: <span className="text-emerald-400 font-bold">DB-892104</span>
      </p>

      {/* Countdown Timer Box */}
      <div className="w-full bg-gradient-to-r from-emerald-900/50 to-teal-900/40 border border-emerald-500/40 p-6 rounded-3xl mb-6 shadow-xl">
        <div className="flex items-center justify-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wider mb-2">
          <Zap className="w-4 h-4 fill-emerald-400" />
          <span>Estimated Arrival</span>
        </div>
        <div className="text-4xl font-black text-white tracking-widest font-mono mb-2">
          {String(mins).padStart(2, '0')}:{String(secs).padStart(2, '0')}
        </div>
        <p className="text-xs text-emerald-200">Delivery partner assigned & packing at Hub Store #01</p>
      </div>

      {/* Action CTAs */}
      <div className="w-full space-y-3">
        <Link
          href="/"
          className="w-full py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl shadow-lg flex items-center justify-center gap-2 transition"
        >
          <span>Track Order Live</span>
          <ChevronRight className="w-4 h-4" />
        </Link>
        <Link
          href="/"
          className="w-full py-3 border border-slate-700 hover:bg-slate-800 text-slate-300 font-medium rounded-xl flex items-center justify-center gap-2 transition text-sm"
        >
          <FileText className="w-4 h-4 text-slate-400" />
          <span>Download Invoice</span>
        </Link>
      </div>
    </div>
  );
}
