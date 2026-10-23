'use client';

import React, { useEffect, useState } from 'react';
import { motion, useSpring, useTransform } from 'framer-motion';
import { LucideIcon } from 'lucide-react';

interface AnimatedKpiCardProps {
  title: string;
  value: number;
  prefix?: string;
  suffix?: string;
  decimals?: number;
  changePercent?: number;
  changeLabel?: string;
  icon: LucideIcon;
  sparklineData?: number[];
  accentColor?: string; // e.g. '#2d9d43'
  isLoading?: boolean;
  onClick?: () => void;
}

export function AnimatedCounter({
  value,
  prefix = '',
  suffix = '',
  decimals = 0,
}: {
  value: number;
  prefix?: string;
  suffix?: string;
  decimals?: number;
}) {
  const spring = useSpring(0, { mass: 0.8, stiffness: 75, damping: 15 });
  const display = useTransform(spring, (current) => {
    return `${prefix}${current.toLocaleString('en-IN', {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals,
    })}${suffix}`;
  });

  const [renderedValue, setRenderedValue] = useState(`${prefix}0${suffix}`);

  useEffect(() => {
    spring.set(value);
  }, [spring, value]);

  useEffect(() => {
    const unsubscribe = display.on('change', (latest) => {
      setRenderedValue(latest);
    });
    return () => unsubscribe();
  }, [display]);

  return <span className="tabular-nums font-bold tracking-tight">{renderedValue}</span>;
}

export default function AnimatedKpiCard({
  title,
  value,
  prefix = '',
  suffix = '',
  decimals = 0,
  changePercent,
  changeLabel = 'vs yesterday',
  icon: Icon,
  sparklineData = [12, 18, 15, 24, 22, 30, 28, 35, 42],
  accentColor = '#2d9d43',
  isLoading = false,
  onClick,
}: AnimatedKpiCardProps) {
  const isPositive = (changePercent ?? 0) >= 0;

  // Generate SVG path for sparkline
  const min = Math.min(...sparklineData);
  const max = Math.max(...sparklineData);
  const range = max - min || 1;
  const width = 120;
  const height = 36;
  const points = sparklineData
    .map((val, i) => {
      const x = (i / (sparklineData.length - 1)) * width;
      const y = height - ((val - min) / range) * (height - 8) - 4;
      return `${x},${y}`;
    })
    .join(' ');

  const areaPoints = `0,${height} ${points} ${width},${height}`;

  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.35, ease: [0.16, 1, 0.3, 1] }}
      whileHover={{ y: -3, transition: { duration: 0.2 } }}
      onClick={onClick}
      className={`glass-card rounded-2xl p-5 relative overflow-hidden flex flex-col justify-between group cursor-pointer transition-shadow hover:shadow-lg ${
        onClick ? 'active:scale-[0.99]' : ''
      }`}
    >
      {/* Decorative Aura Accent */}
      <div
        className="absolute -right-6 -top-6 w-28 h-28 rounded-full blur-2xl opacity-15 pointer-events-none transition-opacity group-hover:opacity-30"
        style={{ backgroundColor: accentColor }}
      />

      {/* Top Header Row */}
      <div className="flex items-start justify-between relative z-10 mb-3">
        <div className="flex items-center gap-2.5">
          <div
            className="w-9 h-9 rounded-xl flex items-center justify-center transition-transform group-hover:scale-110 shadow-sm"
            style={{
              backgroundColor: `${accentColor}18`,
              color: accentColor,
            }}
          >
            <Icon className="w-4 h-4" />
          </div>
          <div>
            <p className="text-xs font-semibold text-zinc-500 font-body uppercase tracking-wider">
              {title}
            </p>
          </div>
        </div>

        {changePercent !== undefined && (
          <motion.div
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[11px] font-bold font-mono ${
              isPositive
                ? 'bg-emerald-50 text-emerald-700 border border-emerald-200/60'
                : 'bg-rose-50 text-rose-700 border border-rose-200/60'
            }`}
          >
            <span>{isPositive ? '↑' : '↓'}</span>
            <span>{Math.abs(changePercent)}%</span>
          </motion.div>
        )}
      </div>

      {/* Metric Main Value */}
      <div className="relative z-10 my-1">
        {isLoading ? (
          <div className="h-9 w-32 bg-zinc-200 animate-pulse rounded-lg" />
        ) : (
          <div className="text-2xl md:text-3xl font-extrabold text-zinc-950 font-headline flex items-baseline gap-1">
            <AnimatedCounter
              value={value}
              prefix={prefix}
              suffix={suffix}
              decimals={decimals}
            />
          </div>
        )}
      </div>

      {/* Sparkline & Comparison Footer */}
      <div className="relative z-10 mt-3 pt-3 border-t border-zinc-100 flex items-center justify-between gap-2">
        <span className="text-[11px] text-zinc-400 font-medium truncate">
          {changeLabel}
        </span>

        {/* Mini SVG Sparkline */}
        <div className="w-[100px] h-[28px] overflow-visible">
          <svg
            viewBox={`0 0 ${width} ${height}`}
            className="w-full h-full overflow-visible"
          >
            <defs>
              <linearGradient id={`grad-${title.replace(/\s+/g, '')}`} x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={accentColor} stopOpacity="0.25" />
                <stop offset="100%" stopColor={accentColor} stopOpacity="0.0" />
              </linearGradient>
            </defs>
            <polygon
              points={areaPoints}
              fill={`url(#grad-${title.replace(/\s+/g, '')})`}
            />
            <motion.polyline
              fill="none"
              stroke={accentColor}
              strokeWidth="2.2"
              strokeLinecap="round"
              strokeLinejoin="round"
              points={points}
              initial={{ pathLength: 0 }}
              animate={{ pathLength: 1 }}
              transition={{ duration: 1, ease: 'easeOut' }}
            />
          </svg>
        </div>
      </div>
    </motion.div>
  );
}
