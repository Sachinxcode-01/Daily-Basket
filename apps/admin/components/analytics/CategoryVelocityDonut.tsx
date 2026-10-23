'use client';

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { PieChart, TrendingUp, Sparkles, ArrowRight } from 'lucide-react';
import Link from 'next/link';

interface CategoryItem {
  id: string;
  name: string;
  sharePercent: number;
  revenue: number;
  unitsSold: number;
  color: string;
  trend: string;
  turnVelocity: 'VERY_FAST' | 'FAST' | 'STEADY';
}

const categoriesData: CategoryItem[] = [
  {
    id: 'cat-1',
    name: 'Farm Fresh Vegetables',
    sharePercent: 38,
    revenue: 146300,
    unitsSold: 3240,
    color: '#2d9d43',
    trend: '+18.4%',
    turnVelocity: 'VERY_FAST',
  },
  {
    id: 'cat-2',
    name: 'Organic Milk & Dairy',
    sharePercent: 26,
    revenue: 100100,
    unitsSold: 2180,
    color: '#078730',
    trend: '+12.1%',
    turnVelocity: 'VERY_FAST',
  },
  {
    id: 'cat-3',
    name: 'Artisan Bakery & Breads',
    sharePercent: 16,
    revenue: 61600,
    unitsSold: 1120,
    color: '#b45309',
    trend: '+8.6%',
    turnVelocity: 'FAST',
  },
  {
    id: 'cat-4',
    name: 'Staples & Instant Cooking',
    sharePercent: 12,
    revenue: 46200,
    unitsSold: 890,
    color: '#0369a1',
    trend: '+5.4%',
    turnVelocity: 'STEADY',
  },
  {
    id: 'cat-5',
    name: 'Cold Pressed Juices & Sodas',
    sharePercent: 8,
    revenue: 30800,
    unitsSold: 640,
    color: '#70dd7a',
    trend: '+22.0%',
    turnVelocity: 'VERY_FAST',
  },
];

export default function CategoryVelocityDonut() {
  const [hoveredId, setHoveredId] = useState<string | null>(null);

  const radius = 64;
  const strokeWidth = 18;
  const circumference = 2 * Math.PI * radius;

  let cumulativePercent = 0;

  const activeCategory =
    categoriesData.find((c) => c.id === hoveredId) || categoriesData[0];

  return (
    <div className="glass-card rounded-2xl p-6 shadow-sm border border-zinc-200/80 flex flex-col justify-between">
      {/* Header */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <span className="p-1.5 rounded-lg bg-[#2d9d43]/10 text-[#2d9d43]">
              <PieChart className="w-4 h-4" />
            </span>
            <h3 className="text-lg font-bold text-zinc-950 font-headline tracking-tight">
              Category Turnover Velocity
            </h3>
          </div>
          <Link
            href="/inventory"
            className="text-xs font-semibold text-[#078730] hover:text-[#2d9d43] flex items-center gap-1 transition-colors"
          >
            <span>Batches</span>
            <ArrowRight className="w-3 h-3" />
          </Link>
        </div>
        <p className="text-xs text-zinc-500 font-body mb-5">
          Real-time product category contribution to gross basket volume.
        </p>
      </div>

      {/* Donut and Legend Layout */}
      <div className="flex flex-col sm:flex-row items-center gap-6 my-2">
        {/* SVG Animated Donut */}
        <div className="relative w-44 h-44 shrink-0 flex items-center justify-center">
          <svg className="w-full h-full -rotate-90" viewBox="0 0 160 160">
            {categoriesData.map((cat) => {
              const strokeDasharray = `${(cat.sharePercent / 100) * circumference} ${circumference}`;
              const strokeDashoffset = -((cumulativePercent / 100) * circumference);
              cumulativePercent += cat.sharePercent;
              const isHovered = hoveredId === cat.id;

              return (
                <motion.circle
                  key={cat.id}
                  cx="80"
                  cy="80"
                  r={radius}
                  fill="transparent"
                  stroke={cat.color}
                  strokeWidth={isHovered ? strokeWidth + 4 : strokeWidth}
                  strokeDasharray={strokeDasharray}
                  strokeDashoffset={strokeDashoffset}
                  strokeLinecap="round"
                  className="cursor-pointer transition-all duration-200"
                  onMouseEnter={() => setHoveredId(cat.id)}
                  onMouseLeave={() => setHoveredId(null)}
                  initial={{ strokeDasharray: `0 ${circumference}` }}
                  animate={{ strokeDasharray }}
                  transition={{ duration: 0.8, ease: 'easeOut' }}
                />
              );
            })}
          </svg>

          {/* Central Animated Content */}
          <div className="absolute inset-0 flex flex-col items-center justify-center text-center pointer-events-none p-3">
            <span className="text-[10px] text-zinc-400 font-mono uppercase tracking-wider block">
              Top Velocity
            </span>
            <span className="text-xl font-black text-zinc-950 font-headline">
              {activeCategory.sharePercent}%
            </span>
            <span className="text-[10px] font-bold text-zinc-500 truncate max-w-[85px]">
              {activeCategory.name.split(' ')[0]}
            </span>
          </div>
        </div>

        {/* Categories Breakdown List */}
        <div className="flex-1 space-y-2.5 w-full">
          {categoriesData.map((cat) => {
            const isHovered = hoveredId === cat.id;
            return (
              <div
                key={cat.id}
                onMouseEnter={() => setHoveredId(cat.id)}
                onMouseLeave={() => setHoveredId(null)}
                className={`p-2 rounded-xl transition-all flex items-center justify-between cursor-pointer border ${
                  isHovered
                    ? 'bg-zinc-100/90 border-zinc-300 shadow-2xs'
                    : 'bg-transparent border-transparent hover:bg-zinc-50'
                }`}
              >
                <div className="flex items-center gap-2.5 min-w-0">
                  <span
                    className="w-3 h-3 rounded-full shrink-0"
                    style={{ backgroundColor: cat.color }}
                  />
                  <div className="truncate">
                    <div className="text-xs font-bold text-zinc-900 truncate">
                      {cat.name}
                    </div>
                    <div className="text-[10px] text-zinc-400 font-mono">
                      {cat.unitsSold.toLocaleString()} units sold
                    </div>
                  </div>
                </div>

                <div className="text-right shrink-0">
                  <div className="text-xs font-bold text-zinc-950 font-mono">
                    {cat.sharePercent}%
                  </div>
                  <div className="text-[10px] font-bold text-emerald-600">
                    {cat.trend}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* AI Velocity Alert Footer */}
      <div className="mt-4 flex items-center gap-2 text-xs text-zinc-600 font-medium bg-emerald-50/60 p-2.5 rounded-xl border border-emerald-100">
        <Sparkles className="w-3.5 h-3.5 text-[#2d9d43] shrink-0" />
        <span className="text-[11px] leading-tight">
          Vegetable restock suggested at 21:00 to prevent stockouts during morning delivery window.
        </span>
      </div>
    </div>
  );
}
