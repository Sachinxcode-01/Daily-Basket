'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ArrowLeft, Fingerprint, Smile, Loader2 } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';

export default function EnableBiometricsPage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  const handleEnableNow = async () => {
    setIsLoading(true);
    await new Promise((res) => setTimeout(res, 800));
    setIsLoading(false);
    router.push('/success');
  };

  const handleMaybeLater = () => {
    router.push('/');
  };

  return (
    <div className="relative min-h-screen flex flex-col justify-between bg-slate-50 font-sans">
      <OrganicShaderBackground />

      {/* ─── Top Bar Header ────────────────────────────────────────────── */}
      <header className="relative z-10 bg-white/90 backdrop-blur-md border-b border-slate-200/70 py-4 px-6 flex items-center justify-between max-w-7xl mx-auto w-full">
        <button
          onClick={() => router.back()}
          className="text-[#006b23] hover:bg-slate-100 p-2 rounded-full transition flex items-center justify-center"
          aria-label="Go Back"
        >
          <ArrowLeft className="w-6 h-6 stroke-[2.2]" />
        </button>

        <h1 className="text-2xl font-extrabold text-[#006b23] font-outfit tracking-tight">
          Daily Basket
        </h1>

        <div className="w-10" /> {/* Spacer */}
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="relative z-10 flex-1 flex flex-col items-center justify-center px-4 sm:px-8 py-10 max-w-md mx-auto w-full text-center">
        
        {/* Biometric Illustration Area */}
        <div className="relative w-48 h-48 mb-8 flex items-center justify-center">
          {/* Pulsing Background Rings */}
          <div className="absolute inset-0 rounded-full border border-emerald-300/40 animate-pulse" />
          <div className="absolute inset-4 rounded-full border border-emerald-400/30 animate-ping opacity-75" />

          {/* Central Glassmorphism Card */}
          <div className="relative z-10 w-32 h-32 bg-white/70 backdrop-blur-md rounded-full shadow-lg border border-white/60 flex items-center justify-center text-[#006b23]">
            <Fingerprint className="w-16 h-16 stroke-[1.8]" />
          </div>

          {/* Decorative Floating Face ID Icon */}
          <div className="absolute top-0 right-4 w-12 h-12 bg-[#dce5dd] text-[#006b23] rounded-full flex items-center justify-center shadow-md animate-bounce">
            <Smile className="w-6 h-6 stroke-[2]" />
          </div>
        </div>

        {/* Text Content */}
        <div className="mb-8 space-y-3">
          <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit">
            Enable Biometric Login
          </h2>
          <p className="text-slate-600 text-base font-inter max-w-[300px] mx-auto leading-relaxed">
            Use Face ID or Touch ID for faster, more secure access to your Daily Basket.
          </p>
        </div>

        {/* Call to Actions */}
        <div className="w-full flex flex-col gap-3.5">
          <button
            onClick={handleEnableNow}
            disabled={isLoading}
            className="w-full h-12 bg-[#006b23] hover:bg-[#00531a] active:scale-[0.98] text-white rounded-full font-bold text-base font-outfit flex items-center justify-center shadow-md shadow-[#006b23]/20 transition-all duration-200 disabled:opacity-60"
          >
            {isLoading ? (
              <Loader2 className="w-5 h-5 animate-spin" />
            ) : (
              <span>Enable Now</span>
            )}
          </button>

          <button
            onClick={handleMaybeLater}
            className="w-full h-12 bg-[#dce5dd] hover:bg-[#c0c9c1] active:scale-[0.98] text-[#006b23] rounded-full font-bold text-base font-outfit flex items-center justify-center transition-all duration-200"
          >
            Maybe Later
          </button>
        </div>

      </main>

      <div className="h-4" />
    </div>
  );
}
