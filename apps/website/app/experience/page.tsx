'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Sparkles, Layers, Box, Cpu, ArrowRight } from 'lucide-react';

export default function ExperienceHubPage() {
  return (
    <div className="min-h-screen bg-slate-950 text-white selection:bg-emerald-500 selection:text-black p-6 sm:p-12 flex flex-col justify-between">
      {/* Top Header */}
      <div className="max-w-5xl mx-auto w-full flex items-center justify-between">
        <Link
          href="/"
          className="flex items-center gap-2 text-slate-400 hover:text-white transition text-xs font-mono"
        >
          <ArrowLeft className="w-4 h-4" /> Return to Store
        </Link>
        <span className="text-xs font-mono uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-800/80 px-2.5 py-1 rounded-full">
          WebGL &amp; Three.js Lab
        </span>
      </div>

      {/* Main Experience Cards Grid */}
      <div className="max-w-5xl mx-auto w-full my-auto py-12 space-y-8">
        <div className="text-center max-w-xl mx-auto space-y-3">
          <div className="inline-flex p-3 rounded-2xl bg-zinc-900 border border-zinc-800 text-emerald-400 shadow-inner">
            <Sparkles className="w-6 h-6" />
          </div>
          <h1 className="text-3xl sm:text-4xl font-extrabold tracking-tight font-outfit">
            Daily Basket Visual Labs
          </h1>
          <p className="text-sm text-slate-400 font-inter">
            Explore next-generation 3D hardware-accelerated product renders and organic WebGL shaders.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Experience 1: Organic Shader Background */}
          <Link
            href="/experience/shader"
            className="group p-8 rounded-3xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-500/80 transition-all flex flex-col justify-between space-y-6 hover:shadow-[0_0_30px_rgba(0,107,35,0.2)]"
          >
            <div className="space-y-4">
              <div className="w-12 h-12 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 group-hover:scale-110 transition duration-300">
                <Layers className="w-6 h-6" />
              </div>
              <div>
                <h2 className="text-xl font-bold font-outfit group-hover:text-emerald-400 transition">
                  Organic Fluid Shader
                </h2>
                <p className="text-xs text-slate-400 mt-2 font-inter leading-relaxed">
                  Interactive simplex-noise canvas shader simulating living farm produce cells and moisture dynamics.
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2 text-xs font-bold text-emerald-400 font-mono">
              <span>Launch Shader Lab</span>
              <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition" />
            </div>
          </Link>

          {/* Experience 2: Three.js Interactive 3D */}
          <Link
            href="/experience/three-js"
            className="group p-8 rounded-3xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-500/80 transition-all flex flex-col justify-between space-y-6 hover:shadow-[0_0_30px_rgba(0,107,35,0.2)]"
          >
            <div className="space-y-4">
              <div className="w-12 h-12 rounded-2xl bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400 group-hover:scale-110 transition duration-300">
                <Box className="w-6 h-6" />
              </div>
              <div>
                <h2 className="text-xl font-bold font-outfit group-hover:text-purple-400 transition">
                  Three.js 3D Produce Model
                </h2>
                <p className="text-xs text-slate-400 mt-2 font-inter leading-relaxed">
                  Real-time orbit controls, PBR materials, and 60 FPS viewport inspections for premier fresh items.
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2 text-xs font-bold text-purple-400 font-mono">
              <span>Launch 3D Viewport</span>
              <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition" />
            </div>
          </Link>
        </div>
      </div>

      {/* Footer */}
      <div className="max-w-5xl mx-auto w-full text-center text-xs text-slate-600 font-mono">
        Daily Basket NextGen Graphics Engine • Powered by Three.js &amp; GLSL
      </div>
    </div>
  );
}
