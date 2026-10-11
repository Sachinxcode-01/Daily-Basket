'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, ArrowRight, Sparkles, ShieldCheck, TreePine, Leaf, Bike, ShoppingBag } from 'lucide-react';

export default function SustainabilityImpactPage() {
  return (
    <div className="min-h-screen bg-[#021810] text-white font-sans selection:bg-[#078730]/30 relative overflow-x-hidden">
      {/* Ambient Radial Mesh Glows */}
      <div className="fixed top-0 left-1/4 w-[600px] h-[600px] bg-emerald-600/10 rounded-full blur-[140px] pointer-events-none" />
      <div className="fixed bottom-10 right-10 w-[500px] h-[500px] bg-[#006823]/15 rounded-full blur-[140px] pointer-events-none" />
      <div className="fixed top-1/2 -left-40 w-[450px] h-[450px] bg-teal-500/10 rounded-full blur-[120px] pointer-events-none" />

      {/* ─── Top Bar Header ────────────────────────────────────────────── */}
      <header className="relative z-10 border-b border-[#0d4a32]/60 bg-[#021810]/80 backdrop-blur-md py-4 px-4 sm:px-8">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-xs sm:text-sm font-semibold text-[#a7f3d0] hover:text-white transition py-1 px-3 rounded-full bg-white/[0.04] border border-white/10 hover:border-emerald-500/30"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Store</span>
          </Link>

          <div className="flex items-center gap-2">
            <span className="w-2.5 h-2.5 rounded-full bg-[#4ade80] animate-pulse" />
            <span className="text-xs font-bold uppercase tracking-wider text-[#4ade80] font-outfit">
              LIVE SUSTAINABILITY METRICS
            </span>
          </div>
        </div>
      </header>

      {/* ─── Main Content Container ────────────────────────────────────── */}
      <main className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 md:px-8 py-8 sm:py-12 space-y-10">
        
        {/* Page Hero Header */}
        <section className="text-center max-w-3xl mx-auto space-y-3">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#0a3d28]/80 border border-[#145d3e] text-[#4ade80] text-xs font-bold uppercase tracking-wider shadow-sm">
            <Leaf className="w-3.5 h-3.5" />
            <span>DAILY BASKET GREEN PLEDGE</span>
          </div>
          <h1 className="text-3xl sm:text-4xl md:text-5xl font-extrabold font-outfit text-white tracking-tight">
            Your Sustainability Impact
          </h1>
          <p className="text-sm sm:text-base text-[#a7f3d0]/80 font-inter leading-relaxed">
            Every 10-minute order you place is delivered with 100% electric mobility, plastic-free biodegradable packaging, and sourced directly from certified organic farmers.
          </p>
        </section>

        {/* ─── FEATURED CARD: Exact User Mockup Design ─────────────────── */}
        <section className="relative overflow-hidden bg-[#042618] text-white rounded-[28px] p-6 sm:p-8 md:p-10 shadow-2xl border border-[#0d4a32] transition-all">
          {/* Subtle Ambient Radial Glow */}
          <div className="absolute -top-24 -right-24 w-96 h-96 bg-emerald-500/10 rounded-full blur-3xl pointer-events-none" />
          <div className="absolute -bottom-24 -left-24 w-96 h-96 bg-[#006823]/15 rounded-full blur-3xl pointer-events-none" />

          <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6 sm:mb-8">
            <div>
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#0a3d28]/80 border border-[#145d3e] text-[#4ade80] text-[11px] sm:text-xs font-bold uppercase tracking-wider mb-2 shadow-xs">
                <span>🌱</span>
                <span>MY SUSTAINABILITY IMPACT</span>
              </div>
              <h2 className="text-2xl sm:text-3xl md:text-4xl font-extrabold font-outfit text-white tracking-tight">
                Your Eco-Friendly Shopping Impact
              </h2>
            </div>
            <span className="text-xs sm:text-sm text-[#5ee398] font-medium flex items-center gap-1.5">
              <span>Verified 100% Organic Supply Chain</span>
              <ShieldCheck className="w-4 h-4 text-[#4ade80]" />
            </span>
          </div>

          {/* 4 Inner Translucent Metric Cards */}
          <div className="relative z-10 grid grid-cols-2 lg:grid-cols-4 gap-3.5 sm:gap-4">
            <div className="group bg-[#062f1f]/50 hover:bg-[#062f1f]/80 backdrop-blur-md border border-[#0d4f35]/80 hover:border-[#15724b] rounded-2xl p-5 sm:p-6 text-center transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-black/20">
              <span className="text-3xl sm:text-4xl inline-block mb-2 transform group-hover:scale-110 transition-transform">🚴</span>
              <div className="text-2xl sm:text-3xl font-extrabold text-[#4ade80] font-outfit tracking-tight">14.2 kg</div>
              <div className="text-xs sm:text-sm text-[#a7f3d0]/80 font-medium mt-1">CO2 Emissions Saved</div>
            </div>

            <div className="group bg-[#062f1f]/50 hover:bg-[#062f1f]/80 backdrop-blur-md border border-[#0d4f35]/80 hover:border-[#15724b] rounded-2xl p-5 sm:p-6 text-center transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-black/20">
              <span className="text-3xl sm:text-4xl inline-block mb-2 transform group-hover:scale-110 transition-transform">🛍️</span>
              <div className="text-2xl sm:text-3xl font-extrabold text-[#4ade80] font-outfit tracking-tight">3.8 kg</div>
              <div className="text-xs sm:text-sm text-[#a7f3d0]/80 font-medium mt-1">Plastic Waste Reduced</div>
            </div>

            <div className="group bg-[#062f1f]/50 hover:bg-[#062f1f]/80 backdrop-blur-md border border-[#0d4f35]/80 hover:border-[#15724b] rounded-2xl p-5 sm:p-6 text-center transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-black/20">
              <span className="text-3xl sm:text-4xl inline-block mb-2 transform group-hover:scale-110 transition-transform">🧑‍🌾</span>
              <div className="text-2xl sm:text-3xl font-extrabold text-[#4ade80] font-outfit tracking-tight">18 Farms</div>
              <div className="text-xs sm:text-sm text-[#a7f3d0]/80 font-medium mt-1">Local Farmers Supported</div>
            </div>

            <div className="group bg-[#062f1f]/50 hover:bg-[#062f1f]/80 backdrop-blur-md border border-[#0d4f35]/80 hover:border-[#15724b] rounded-2xl p-5 sm:p-6 text-center transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-black/20">
              <span className="text-3xl sm:text-4xl inline-block mb-2 transform group-hover:scale-110 transition-transform">🎖️</span>
              <div className="text-2xl sm:text-3xl font-extrabold text-[#4ade80] font-outfit tracking-tight">Tier 3 Eco</div>
              <div className="text-xs sm:text-sm text-[#a7f3d0]/80 font-medium mt-1">Sustainability Badge</div>
            </div>
          </div>
        </section>

        {/* ─── BENTO GRID: Transparent Professional Cards ─────────────── */}
        <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          
          {/* Earth Champion Status Card */}
          <div className="col-span-1 md:col-span-2 lg:col-span-2 bg-[#062f1f]/40 hover:bg-[#062f1f]/60 backdrop-blur-md border border-[#0d4f35]/70 rounded-[28px] p-6 sm:p-8 flex flex-col sm:flex-row items-center justify-between gap-6 transition-all duration-300">
            <div className="space-y-3">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-[#4ade80] text-xs font-bold uppercase tracking-wider">
                <Sparkles className="w-3.5 h-3.5" />
                <span>CUSTOMER RANKING</span>
              </div>
              <h3 className="text-3xl sm:text-4xl font-extrabold font-outfit text-white">
                Earth Champion
              </h3>
              <p className="text-sm text-[#a7f3d0]/80 leading-relaxed max-w-md">
                You are in the <strong className="text-white font-semibold">top 5%</strong> of eco-conscious grocery shoppers in Bengaluru this month! Next milestone unlocks at 1,500 points.
              </p>
              <div className="pt-2 flex items-center gap-4 text-xs font-semibold text-[#a7f3d0]">
                <span className="flex items-center gap-1">🌿 240 Orders Delivered Green</span>
                <span className="flex items-center gap-1">⚡ 100% Zero tailpipe emissions</span>
              </div>
            </div>

            <div className="flex flex-col items-center flex-shrink-0">
              <div className="w-32 h-32 rounded-full border-4 border-[#4ade80] flex items-center justify-center relative bg-emerald-950/60 shadow-lg shadow-emerald-500/10">
                <div className="text-center">
                  <span className="text-3xl font-extrabold font-outfit text-white block">1,240</span>
                  <span className="text-[10px] text-[#4ade80] font-bold uppercase tracking-wider">POINTS</span>
                </div>
              </div>
              <span className="text-xs text-[#a7f3d0]/80 font-medium mt-2">Level 3 of 5</span>
            </div>
          </div>

          {/* Plastic-Free Guarantee Card */}
          <div className="bg-[#062f1f]/40 hover:bg-[#062f1f]/60 backdrop-blur-md border border-[#0d4f35]/70 rounded-[28px] p-6 sm:p-7 flex flex-col justify-between transition-all duration-300">
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="w-11 h-11 rounded-2xl bg-emerald-900/60 border border-emerald-700/40 flex items-center justify-center text-[#4ade80]">
                  <ShoppingBag className="w-6 h-6 stroke-[2]" />
                </div>
                <span className="text-2xl font-extrabold text-[#4ade80] font-outfit">4.2 kg</span>
              </div>
              <h3 className="text-xl font-bold font-outfit text-white mb-1.5">
                Plastic Eliminated
              </h3>
              <p className="text-xs text-[#a7f3d0]/80 leading-relaxed mb-4">
                Saved 210 plastic bags by utilizing 100% biodegradable cornstarch compostable pouches.
              </p>
            </div>

            <div className="space-y-2">
              <div className="flex justify-between text-xs font-semibold">
                <span className="text-[#a7f3d0]/70">Monthly Goal (5.0 kg)</span>
                <span className="text-[#4ade80]">84% Reached</span>
              </div>
              <div className="w-full bg-[#032317] rounded-full h-2.5 overflow-hidden border border-emerald-900/50">
                <div className="bg-[#4ade80] h-full rounded-full transition-all duration-1000 shadow-sm shadow-[#4ade80]/50" style={{ width: '84%' }} />
              </div>
            </div>
          </div>

          {/* Electric Logistics CO2 Avoided */}
          <div className="bg-[#062f1f]/40 hover:bg-[#062f1f]/60 backdrop-blur-md border border-[#0d4f35]/70 rounded-[28px] p-6 sm:p-7 flex flex-col justify-between transition-all duration-300">
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="w-11 h-11 rounded-2xl bg-emerald-900/60 border border-emerald-700/40 flex items-center justify-center text-[#4ade80]">
                  <Bike className="w-6 h-6 stroke-[2]" />
                </div>
                <span className="text-2xl font-extrabold text-[#4ade80] font-outfit">12.5 kg</span>
              </div>
              <h3 className="text-xl font-bold font-outfit text-white mb-1.5">
                EV Fleet Deliveries
              </h3>
              <p className="text-xs text-[#a7f3d0]/80 leading-relaxed mb-4">
                100% of deliveries dispatched within your dark store zone are powered by electric bikes.
              </p>
            </div>

            <div className="space-y-2">
              <div className="flex justify-between text-xs font-semibold">
                <span className="text-[#a7f3d0]/70">Electric Fleet Route</span>
                <span className="text-[#4ade80]">100% EV</span>
              </div>
              <div className="w-full bg-[#032317] rounded-full h-2.5 overflow-hidden border border-emerald-900/50">
                <div className="bg-[#4ade80] h-full rounded-full transition-all duration-1000 shadow-sm shadow-[#4ade80]/50" style={{ width: '100%' }} />
              </div>
            </div>
          </div>

          {/* Local Organic Farmers Card */}
          <div className="bg-[#062f1f]/40 hover:bg-[#062f1f]/60 backdrop-blur-md border border-[#0d4f35]/70 rounded-[28px] p-6 sm:p-7 flex flex-col justify-between transition-all duration-300">
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="w-11 h-11 rounded-2xl bg-emerald-900/60 border border-emerald-700/40 flex items-center justify-center text-[#4ade80]">
                  <TreePine className="w-6 h-6 stroke-[2]" />
                </div>
                <span className="text-2xl font-extrabold text-[#4ade80] font-outfit">18 Farms</span>
              </div>
              <h3 className="text-xl font-bold font-outfit text-white mb-1.5">
                Local Organic Agriculture
              </h3>
              <p className="text-xs text-[#a7f3d0]/80 leading-relaxed mb-4">
                Direct farm partnerships with certified sustainable growers within 50 km from farm gate to your table.
              </p>
            </div>

            <div className="p-3 rounded-xl bg-white/[0.04] border border-white/5 text-xs text-[#a7f3d0]">
              🌾 Zero middleman markups • Fair trade harvest pricing
            </div>
          </div>

          {/* Zero Food Waste Commitment Card */}
          <div className="bg-[#062f1f]/40 hover:bg-[#062f1f]/60 backdrop-blur-md border border-[#0d4f35]/70 rounded-[28px] p-6 sm:p-7 flex flex-col justify-between transition-all duration-300">
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="w-11 h-11 rounded-2xl bg-emerald-900/60 border border-emerald-700/40 flex items-center justify-center text-[#4ade80]">
                  <ShieldCheck className="w-6 h-6 stroke-[2]" />
                </div>
                <span className="text-2xl font-extrabold text-[#4ade80] font-outfit">0.2%</span>
              </div>
              <h3 className="text-xl font-bold font-outfit text-white mb-1.5">
                Cold-Chain Food Waste
              </h3>
              <p className="text-xs text-[#a7f3d0]/80 leading-relaxed mb-4">
                Smart IoT dark store refrigeration preserves freshness and redistributes surplus daily to local charities.
              </p>
            </div>

            <div className="p-3 rounded-xl bg-white/[0.04] border border-white/5 text-xs text-[#a7f3d0]">
              🤝 1,400+ meals donated to local hunger relief programs
            </div>
          </div>

        </section>

        {/* ─── Bottom CTA Banner ───────────────────────────────────────── */}
        <section className="relative overflow-hidden bg-gradient-to-r from-[#032317] via-[#043321] to-[#032317] border border-[#0d4f35] rounded-[28px] p-8 sm:p-10 text-center space-y-5">
          <div className="max-w-2xl mx-auto space-y-3">
            <h3 className="text-2xl sm:text-3xl font-extrabold font-outfit text-white tracking-tight">
              Keep Shopping Clean, Local & Organic
            </h3>
            <p className="text-xs sm:text-sm text-[#a7f3d0]/80 leading-relaxed font-inter">
              Every basket delivered in 10 minutes helps plant the seeds for a cleaner, plastic-free neighborhood.
            </p>
          </div>

          <div className="flex flex-wrap items-center justify-center gap-4 pt-2">
            <Link
              href="/"
              className="px-8 py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-sm sm:text-base rounded-full shadow-lg shadow-[#006823]/30 flex items-center gap-2.5 transition-all duration-200"
            >
              <span>Explore Organic Produce</span>
              <ArrowRight className="w-5 h-5 stroke-[2.2]" />
            </Link>
          </div>
        </section>

      </main>

      {/* ─── Bottom Footer ─────────────────────────────────────────────── */}
      <footer className="relative z-10 border-t border-[#0d4a32]/60 py-8 px-4 text-center text-xs text-[#a7f3d0]/60">
        <p>© {new Date().getFullYear()} Daily Basket Sustainability Initiative. Koramangala, Bengaluru, India.</p>
      </footer>
    </div>
  );
}
