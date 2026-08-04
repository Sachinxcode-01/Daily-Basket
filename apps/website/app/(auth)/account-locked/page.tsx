'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Lock, Timer, Info, LifeBuoy, HelpCircle } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';

export default function AccountLockedPage() {
  const router = useRouter();

  const [secondsRemaining, setSecondsRemaining] = useState(1799); // 29m 59s

  useEffect(() => {
    const interval = setInterval(() => {
      setSecondsRemaining((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  const formatTime = (totalSec: number) => {
    const mins = Math.floor(totalSec / 60);
    const secs = totalSec % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="relative min-h-screen flex flex-col justify-center items-center p-4 sm:p-6 bg-slate-50 font-sans">
      <OrganicShaderBackground />

      <main className="relative z-10 w-full max-w-[480px] bg-white rounded-2xl shadow-xl shadow-slate-200/50 overflow-hidden flex flex-col border border-slate-100 animate-[fadeInUp_0.6s_ease-out]">
        
        {/* Top Header Area */}
        <div className="bg-red-50/90 border-b border-red-100 p-6 sm:p-8 flex flex-col items-center justify-center relative overflow-hidden text-center">
          {/* Decorative Glow */}
          <div className="absolute -top-10 -right-10 w-32 h-32 bg-red-200/30 rounded-full blur-2xl pointer-events-none" />
          <div className="absolute -bottom-10 -left-10 w-40 h-40 bg-red-200/20 rounded-full blur-2xl pointer-events-none" />

          {/* Pulsing Lock Icon Badge */}
          <div className="relative z-10 w-20 h-20 bg-red-600 text-white rounded-full flex items-center justify-center mb-4 shadow-lg shadow-red-600/30 animate-pulse">
            <Lock className="w-10 h-10 stroke-[2.2]" />
          </div>

          <h1 className="text-2xl sm:text-3xl font-extrabold text-red-900 font-outfit tracking-tight relative z-10">
            Account Temporarily Locked
          </h1>
        </div>

        {/* Content Area */}
        <div className="p-6 sm:p-8 flex flex-col gap-6 text-center bg-white">
          <p className="text-slate-600 text-sm sm:text-base font-inter leading-relaxed">
            Due to multiple unsuccessful login attempts, your account is locked for 30 minutes for security.
          </p>

          {/* Countdown Timer */}
          <div className="flex justify-center items-center gap-2.5 bg-slate-100 py-3.5 px-4 rounded-xl">
            <Timer className="w-5 h-5 text-slate-500" />
            <span className="font-outfit font-bold text-xl text-slate-900">
              {formatTime(secondsRemaining)}
            </span>
            <span className="text-slate-500 text-xs font-semibold uppercase tracking-wider font-inter">
              remaining
            </span>
          </div>

          {/* Warning Info Box */}
          <div className="bg-slate-50 border border-slate-200/80 rounded-xl p-4 text-left flex gap-3 items-start">
            <Info className="w-5 h-5 text-slate-500 flex-shrink-0 mt-0.5" />
            <p className="text-xs text-slate-600 font-inter leading-relaxed">
              If you did not attempt to log in, your account may be at risk. Please contact our support team immediately to secure your account.
            </p>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col gap-3 w-full pt-1">
            <Link
              href="/support"
              className="w-full h-12 bg-[#006b23] hover:bg-[#00531a] active:scale-[0.98] text-white rounded-xl font-bold text-sm font-outfit flex items-center justify-center gap-2 shadow-sm transition-all duration-200"
            >
              <LifeBuoy className="w-4 h-4" />
              <span>Contact Support</span>
            </Link>

            <Link
              href="/support"
              className="w-full h-12 bg-[#dce5dd] hover:bg-[#c0c9c1] active:scale-[0.98] text-[#00531a] rounded-xl font-bold text-sm font-outfit flex items-center justify-center gap-2 transition-all duration-200"
            >
              <HelpCircle className="w-4 h-4" />
              <span>Go to Help Center</span>
            </Link>
          </div>
        </div>
      </main>

      {/* Footer Branding */}
      <footer className="relative z-10 mt-6 text-center">
        <p className="text-slate-400 font-bold font-outfit text-sm tracking-tight">
          Daily Basket
        </p>
      </footer>
    </div>
  );
}
