import React from 'react';

export default function Loading() {
  return (
    <div className="min-h-screen bg-white m-0 overflow-hidden flex items-center justify-center relative font-sans">
      {/* Soft Gradient Background Overlay */}
      <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-emerald-50/40 opacity-80 pointer-events-none" />
      
      <main className="relative z-10 flex flex-col items-center justify-center px-4 md:px-12 text-center w-full max-w-md mx-auto">
        {/* Logo Badge Container */}
        <div className="animate-[fadeInUp_0.8s_ease-out] w-32 h-32 md:w-40 md:h-40 mb-8 rounded-2xl overflow-hidden shadow-sm bg-white border border-slate-100 flex items-center justify-center p-4">
          <div className="flex flex-col items-center justify-center">
            <div className="w-16 h-16 rounded-full bg-[#006b23] flex items-center justify-center text-white mb-2 shadow-md shadow-[#006b23]/20">
              <svg className="w-9 h-9 stroke-[2.2]" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="m5 11 4-7" />
                <path d="m19 11-4-7" />
                <path d="M2 11h20" />
                <path d="m3.5 11 1.6 7.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6l1.6-7.4" />
                <path d="M9 11v9" />
                <path d="M15 11v9" />
              </svg>
            </div>
            <span className="text-xs font-bold text-[#006b23] font-outfit">Daily Basket</span>
          </div>
        </div>

        {/* Circular Spinner */}
        <div className="animate-[fadeInUp_0.8s_ease-out_0.2s_both] mb-8">
          <div className="w-12 h-12 border-4 border-[#dce5dd] border-b-[#006b23] rounded-full animate-spin" />
        </div>

        {/* Brand Text & Tagline */}
        <div className="animate-[fadeInUp_0.8s_ease-out_0.4s_both] flex flex-col items-center gap-2">
          <h1 className="text-3xl md:text-4xl font-extrabold text-[#006b23] font-outfit tracking-tight">
            Daily Basket
          </h1>
          <p className="text-base text-slate-600 font-inter font-medium">
            Freshness is coming your way...
          </p>
        </div>
      </main>
    </div>
  );
}
