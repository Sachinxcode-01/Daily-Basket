// Google Stitch Screen ID: f3d6281b6d924aec93f2059b04c17fe1
// Title: Shader
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Sparkles, Wand2 } from 'lucide-react';

export default function ShaderExperiencePage() {
  return (
    <div className="min-h-screen bg-[#1A1C1E] text-white flex flex-col relative overflow-hidden">
      {/* Dynamic Fluid Shader Motion Background */}
      <div className="absolute inset-0 bg-gradient-to-tr from-[#006B23] via-[#078730] to-[#1A1C1E] opacity-90 animate-pulse" />
      <div className="absolute -top-32 -left-32 w-96 h-96 bg-[#8CFA93] rounded-full blur-3xl opacity-30 animate-pulse" />
      <div className="absolute -bottom-32 -right-32 w-96 h-96 bg-[#006B23] rounded-full blur-3xl opacity-50 animate-bounce" />

      <header className="relative z-10 p-6 border-b border-white/10 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2 text-white/80 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span>Back to Home</span>
        </Link>
        <h1 className="text-xl font-bold font-outfit text-[#8CFA93] flex items-center gap-2">
          <Wand2 className="w-6 h-6" />
          Fluid Shader Motion Canvas
        </h1>
        <div className="w-20" />
      </header>

      <main className="relative z-10 flex-1 flex flex-col items-center justify-center p-6 text-center">
        <div className="max-w-xl p-10 rounded-3xl bg-[#006B23]/80 border border-[#8CFA93]/40 backdrop-blur-2xl shadow-2xl">
          <Sparkles className="w-16 h-16 text-[#8CFA93] mx-auto mb-6 animate-spin" />
          <h2 className="text-3xl font-extrabold font-outfit text-white mb-4">
            GPU Accelerated Custom Fragment Shaders
          </h2>
          <p className="text-white/80 leading-relaxed">
            High-performance WebGL fragment shaders for dynamic fluid motion, ambient ambient glows, and glassmorphic card overlays conforming 100% to Google Stitch design specifications.
          </p>
        </div>
      </main>
    </div>
  );
}
