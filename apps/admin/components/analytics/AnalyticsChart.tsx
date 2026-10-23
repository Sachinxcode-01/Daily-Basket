'use client';

import React, { useState, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  TrendingUp,
  Clock,
  ShoppingCart,
  DollarSign,
  Maximize2,
  Calendar,
  Sparkles,
} from 'lucide-react';

export type TimeHorizon = '1H' | '24H' | '7D' | '30D';
export type MetricType = 'revenue' | 'orders' | 'sla' | 'margin';

interface ChartPoint {
  label: string;
  time: string;
  value: number;
  secondaryValue?: number;
}

const mockChartDatasets: Record<TimeHorizon, Record<MetricType, ChartPoint[]>> = {
  '1H': {
    revenue: [
      { label: '10m ago', time: '19:15', value: 3400, secondaryValue: 28 },
      { label: '8m ago', time: '19:17', value: 4100, secondaryValue: 35 },
      { label: '6m ago', time: '19:19', value: 3850, secondaryValue: 31 },
      { label: '4m ago', time: '19:21', value: 5200, secondaryValue: 44 },
      { label: '2m ago', time: '19:23', value: 4900, secondaryValue: 40 },
      { label: 'Just now', time: '19:25', value: 6150, secondaryValue: 52 },
    ],
    orders: [
      { label: '10m ago', time: '19:15', value: 28 },
      { label: '8m ago', time: '19:17', value: 35 },
      { label: '6m ago', time: '19:19', value: 31 },
      { label: '4m ago', time: '19:21', value: 44 },
      { label: '2m ago', time: '19:23', value: 40 },
      { label: 'Just now', time: '19:25', value: 52 },
    ],
    sla: [
      { label: '10m ago', time: '19:15', value: 8.8 },
      { label: '8m ago', time: '19:17', value: 9.1 },
      { label: '6m ago', time: '19:19', value: 8.9 },
      { label: '4m ago', time: '19:21', value: 9.4 },
      { label: '2m ago', time: '19:23', value: 9.2 },
      { label: 'Just now', time: '19:25', value: 8.7 },
    ],
    margin: [
      { label: '10m ago', time: '19:15', value: 22.4 },
      { label: '8m ago', time: '19:17', value: 23.1 },
      { label: '6m ago', time: '19:19', value: 22.8 },
      { label: '4m ago', time: '19:21', value: 24.2 },
      { label: '2m ago', time: '19:23', value: 23.9 },
      { label: 'Just now', time: '19:25', value: 24.8 },
    ],
  },
  '24H': {
    revenue: [
      { label: '06:00', time: '06:00 AM', value: 8400 },
      { label: '08:00', time: '08:00 AM', value: 21400 },
      { label: '10:00', time: '10:00 AM', value: 34200 },
      { label: '12:00', time: '12:00 PM', value: 28900 },
      { label: '14:00', time: '02:00 PM', value: 22100 },
      { label: '16:00', time: '04:00 PM', value: 31200 },
      { label: '18:00', time: '06:00 PM', value: 48900 },
      { label: '20:00', time: '08:00 PM', value: 54100 },
      { label: '22:00', time: '10:00 PM', value: 38200 },
    ],
    orders: [
      { label: '06:00', time: '06:00 AM', value: 65 },
      { label: '08:00', time: '08:00 AM', value: 182 },
      { label: '10:00', time: '10:00 AM', value: 295 },
      { label: '12:00', time: '12:00 PM', value: 240 },
      { label: '14:00', time: '02:00 PM', value: 190 },
      { label: '16:00', time: '04:00 PM', value: 275 },
      { label: '18:00', time: '06:00 PM', value: 410 },
      { label: '20:00', time: '08:00 PM', value: 460 },
      { label: '22:00', time: '10:00 PM', value: 320 },
    ],
    sla: [
      { label: '06:00', time: '06:00 AM', value: 7.9 },
      { label: '08:00', time: '08:00 AM', value: 8.6 },
      { label: '10:00', time: '10:00 AM', value: 9.8 },
      { label: '12:00', time: '12:00 PM', value: 9.1 },
      { label: '14:00', time: '02:00 PM', value: 8.4 },
      { label: '16:00', time: '04:00 PM', value: 9.3 },
      { label: '18:00', time: '06:00 PM', value: 10.2 },
      { label: '20:00', time: '08:00 PM', value: 9.6 },
      { label: '22:00', time: '10:00 PM', value: 8.5 },
    ],
    margin: [
      { label: '06:00', time: '06:00 AM', value: 21.8 },
      { label: '08:00', time: '08:00 AM', value: 23.4 },
      { label: '10:00', time: '10:00 AM', value: 24.1 },
      { label: '12:00', time: '12:00 PM', value: 23.0 },
      { label: '14:00', time: '02:00 PM', value: 22.5 },
      { label: '16:00', time: '04:00 PM', value: 23.8 },
      { label: '18:00', time: '06:00 PM', value: 25.2 },
      { label: '20:00', time: '08:00 PM', value: 24.7 },
      { label: '22:00', time: '10:00 PM', value: 23.6 },
    ],
  },
  '7D': {
    revenue: [
      { label: 'Mon', time: 'Oct 17', value: 184500 },
      { label: 'Tue', time: 'Oct 18', value: 212000 },
      { label: 'Wed', time: 'Oct 19', value: 198000 },
      { label: 'Thu', time: 'Oct 20', value: 245000 },
      { label: 'Fri', time: 'Oct 21', value: 298000 },
      { label: 'Sat', time: 'Oct 22', value: 342000 },
      { label: 'Sun', time: 'Oct 23 (Today)', value: 385000 },
    ],
    orders: [
      { label: 'Mon', time: 'Oct 17', value: 1420 },
      { label: 'Tue', time: 'Oct 18', value: 1650 },
      { label: 'Wed', time: 'Oct 19', value: 1530 },
      { label: 'Thu', time: 'Oct 20', value: 1890 },
      { label: 'Fri', time: 'Oct 21', value: 2280 },
      { label: 'Sat', time: 'Oct 22', value: 2650 },
      { label: 'Sun', time: 'Oct 23 (Today)', value: 2980 },
    ],
    sla: [
      { label: 'Mon', time: 'Oct 17', value: 9.1 },
      { label: 'Tue', time: 'Oct 18', value: 9.3 },
      { label: 'Wed', time: 'Oct 19', value: 8.9 },
      { label: 'Thu', time: 'Oct 20', value: 9.2 },
      { label: 'Fri', time: 'Oct 21', value: 9.5 },
      { label: 'Sat', time: 'Oct 22', value: 9.8 },
      { label: 'Sun', time: 'Oct 23 (Today)', value: 9.4 },
    ],
    margin: [
      { label: 'Mon', time: 'Oct 17', value: 22.8 },
      { label: 'Tue', time: 'Oct 18', value: 23.2 },
      { label: 'Wed', time: 'Oct 19', value: 23.5 },
      { label: 'Thu', time: 'Oct 20', value: 24.1 },
      { label: 'Fri', time: 'Oct 21', value: 24.9 },
      { label: 'Sat', time: 'Oct 22', value: 25.4 },
      { label: 'Sun', time: 'Oct 23 (Today)', value: 25.1 },
    ],
  },
  '30D': {
    revenue: [
      { label: 'Week 1', time: 'Sep 25 - Oct 01', value: 1240000 },
      { label: 'Week 2', time: 'Oct 02 - Oct 08', value: 1480000 },
      { label: 'Week 3', time: 'Oct 09 - Oct 15', value: 1620000 },
      { label: 'Week 4', time: 'Oct 16 - Oct 23', value: 1890000 },
    ],
    orders: [
      { label: 'Week 1', time: 'Sep 25 - Oct 01', value: 9800 },
      { label: 'Week 2', time: 'Oct 02 - Oct 08', value: 11400 },
      { label: 'Week 3', time: 'Oct 09 - Oct 15', value: 12600 },
      { label: 'Week 4', time: 'Oct 16 - Oct 23', value: 14800 },
    ],
    sla: [
      { label: 'Week 1', time: 'Sep 25 - Oct 01', value: 9.6 },
      { label: 'Week 2', time: 'Oct 02 - Oct 08', value: 9.4 },
      { label: 'Week 3', time: 'Oct 09 - Oct 15', value: 9.3 },
      { label: 'Week 4', time: 'Oct 16 - Oct 23', value: 9.2 },
    ],
    margin: [
      { label: 'Week 1', time: 'Sep 25 - Oct 01', value: 22.4 },
      { label: 'Week 2', time: 'Oct 02 - Oct 08', value: 23.1 },
      { label: 'Week 3', time: 'Oct 09 - Oct 15', value: 24.0 },
      { label: 'Week 4', time: 'Oct 16 - Oct 23', value: 24.8 },
    ],
  },
};

export default function AnalyticsChart() {
  const [timeHorizon, setTimeHorizon] = useState<TimeHorizon>('7D');
  const [metric, setMetric] = useState<MetricType>('revenue');
  const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);

  const dataset = useMemo(() => {
    return mockChartDatasets[timeHorizon][metric];
  }, [timeHorizon, metric]);

  const metricConfigs: Record<
    MetricType,
    { label: string; icon: any; prefix: string; suffix: string; color: string; decimals: number }
  > = {
    revenue: {
      label: 'Gross Revenue',
      icon: DollarSign,
      prefix: '₹',
      suffix: '',
      color: '#2d9d43',
      decimals: 0,
    },
    orders: {
      label: 'Order Volume',
      icon: ShoppingCart,
      prefix: '',
      suffix: ' orders',
      color: '#078730',
      decimals: 0,
    },
    sla: {
      label: 'Avg 10m SLA',
      icon: Clock,
      prefix: '',
      suffix: ' min',
      color: '#0369a1',
      decimals: 1,
    },
    margin: {
      label: 'Gross Margin',
      icon: TrendingUp,
      prefix: '',
      suffix: '%',
      color: '#70dd7a',
      decimals: 1,
    },
  };

  const currentConfig = metricConfigs[metric];

  // SVG Geometry Calculation
  const width = 800;
  const height = 260;
  const paddingX = 40;
  const paddingY = 40;

  const values = dataset.map((d) => d.value);
  const minVal = Math.min(...values) * 0.92;
  const maxVal = Math.max(...values) * 1.05;
  const range = maxVal - minVal || 1;

  const points = useMemo(() => {
    return dataset.map((item, index) => {
      const x = paddingX + (index / (dataset.length - 1)) * (width - paddingX * 2);
      const y = height - paddingY - ((item.value - minVal) / range) * (height - paddingY * 2);
      return { x, y, item };
    });
  }, [dataset, minVal, range]);

  // Smooth Bezier Curve generator
  const pathD = useMemo(() => {
    if (points.length === 0) return '';
    if (points.length === 1) return `M ${points[0].x} ${points[0].y}`;

    let d = `M ${points[0].x} ${points[0].y}`;
    for (let i = 0; i < points.length - 1; i++) {
      const p0 = points[i];
      const p1 = points[i + 1];
      const cx = (p0.x + p1.x) / 2;
      d += ` C ${cx} ${p0.y}, ${cx} ${p1.y}, ${p1.x} ${p1.y}`;
    }
    return d;
  }, [points]);

  const areaD = useMemo(() => {
    if (!pathD || points.length === 0) return '';
    const last = points[points.length - 1];
    const first = points[0];
    return `${pathD} L ${last.x} ${height - paddingY} L ${first.x} ${height - paddingY} Z`;
  }, [pathD, points]);

  const activePoint = hoveredIndex !== null ? points[hoveredIndex] : points[points.length - 1];

  return (
    <div className="glass-card rounded-2xl p-6 shadow-sm border border-zinc-200/80 relative overflow-hidden flex flex-col">
      {/* Top Header with Interactive Tabs */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6 relative z-10">
        <div>
          <div className="flex items-center gap-2">
            <span className="p-1.5 rounded-lg bg-[#2d9d43]/10 text-[#2d9d43]">
              <TrendingUp className="w-4 h-4" />
            </span>
            <h3 className="text-lg font-bold text-zinc-950 font-headline tracking-tight">
              Performance & Demand Velocity
            </h3>
            <span className="text-[10px] font-bold uppercase tracking-wider bg-emerald-100 text-emerald-800 px-2 py-0.5 rounded-full font-mono flex items-center gap-1">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-ping" />
              Live Telemetry
            </span>
          </div>
          <p className="text-xs text-zinc-500 font-body mt-0.5">
            Instantaneous dark store order stream, delivery SLA tracking, and margin analysis.
          </p>
        </div>

        {/* Time Horizon Pills with Animated Indicator */}
        <div className="flex items-center bg-zinc-100/80 p-1 rounded-xl border border-zinc-200/60 shrink-0">
          {(['1H', '24H', '7D', '30D'] as TimeHorizon[]).map((hz) => (
            <button
              key={hz}
              onClick={() => {
                setTimeHorizon(hz);
                setHoveredIndex(null);
              }}
              className={`relative px-3 py-1.5 rounded-lg text-xs font-bold transition-colors ${
                timeHorizon === hz ? 'text-zinc-950' : 'text-zinc-500 hover:text-zinc-800'
              }`}
            >
              {timeHorizon === hz && (
                <motion.div
                  layoutId="timeHorizonPill"
                  className="absolute inset-0 bg-white rounded-lg shadow-sm border border-zinc-200/70"
                  transition={{ type: 'spring', stiffness: 350, damping: 30 }}
                />
              )}
              <span className="relative z-10">{hz}</span>
            </button>
          ))}
        </div>
      </div>

      {/* Metric Selector Tabs */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5 mb-5 relative z-10">
        {(['revenue', 'orders', 'sla', 'margin'] as MetricType[]).map((mKey) => {
          const cfg = metricConfigs[mKey];
          const Icon = cfg.icon;
          const isSelected = metric === mKey;
          const latestValue = mockChartDatasets[timeHorizon][mKey].slice(-1)[0]?.value || 0;

          return (
            <button
              key={mKey}
              onClick={() => {
                setMetric(mKey);
                setHoveredIndex(null);
              }}
              className={`p-3 rounded-xl border text-left transition-all ${
                isSelected
                  ? 'bg-white border-[#2d9d43] shadow-md ring-1 ring-[#2d9d43]/30'
                  : 'bg-zinc-50/70 border-zinc-200/70 hover:bg-zinc-100/80'
              }`}
            >
              <div className="flex items-center justify-between text-zinc-500 text-[11px] font-semibold mb-1">
                <span>{cfg.label}</span>
                <Icon
                  className="w-3.5 h-3.5"
                  style={{ color: isSelected ? cfg.color : undefined }}
                />
              </div>
              <div className="text-base md:text-lg font-bold text-zinc-950 font-headline">
                {cfg.prefix}
                {latestValue.toLocaleString('en-IN', {
                  maximumFractionDigits: cfg.decimals,
                })}
                {cfg.suffix}
              </div>
            </button>
          );
        })}
      </div>

      {/* SVG Interactive Chart Area */}
      <div className="relative w-full h-[280px] select-none bg-gradient-to-b from-white/40 to-zinc-50/50 rounded-xl border border-zinc-200/50 p-2">
        {/* Scrubber Tooltip Overlay */}
        <AnimatePresence>
          {activePoint && (
            <motion.div
              key={activePoint.item.time}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.15 }}
              className="absolute z-20 pointer-events-none top-3 left-4 bg-zinc-950/90 text-white backdrop-blur-md px-3.5 py-2 rounded-xl shadow-xl border border-zinc-800 text-xs flex items-center gap-3"
            >
              <div>
                <span className="text-[10px] text-zinc-400 font-mono block">
                  {activePoint.item.time} ({activePoint.item.label})
                </span>
                <span className="font-bold text-sm font-headline text-emerald-400">
                  {currentConfig.prefix}
                  {activePoint.item.value.toLocaleString('en-IN', {
                    maximumFractionDigits: currentConfig.decimals,
                  })}
                  {currentConfig.suffix}
                </span>
              </div>
              <div className="h-6 w-[1px] bg-zinc-800" />
              <div className="text-[10px] text-zinc-400">
                <span>SLA Health</span>
                <span className="block font-bold text-white">99.2% on-time</span>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        <svg
          viewBox={`0 0 ${width} ${height}`}
          className="w-full h-full overflow-visible"
          preserveAspectRatio="none"
        >
          <defs>
            <linearGradient id="areaGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={currentConfig.color} stopOpacity="0.32" />
              <stop offset="70%" stopColor={currentConfig.color} stopOpacity="0.08" />
              <stop offset="100%" stopColor={currentConfig.color} stopOpacity="0.0" />
            </linearGradient>
            <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
              <feGaussianBlur stdDeviation="3" result="blur" />
              <feComposite in="SourceGraphic" in2="blur" operator="over" />
            </filter>
          </defs>

          {/* Horizontal Grid Lines */}
          {[0.2, 0.5, 0.8].map((ratio, idx) => {
            const y = height - paddingY - ratio * (height - paddingY * 2);
            return (
              <line
                key={idx}
                x1={paddingX}
                y1={y}
                x2={width - paddingX}
                y2={y}
                stroke="#e4e4e7"
                strokeWidth="1"
                strokeDasharray="4 4"
              />
            );
          })}

          {/* Area Gradient */}
          <motion.path
            d={areaD}
            fill="url(#areaGradient)"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
          />

          {/* Smooth Curve Path */}
          <motion.path
            d={pathD}
            fill="none"
            stroke={currentConfig.color}
            strokeWidth="3.2"
            strokeLinecap="round"
            strokeLinejoin="round"
            initial={{ pathLength: 0 }}
            animate={{ pathLength: 1 }}
            transition={{ duration: 0.8, ease: 'easeOut' }}
            filter="url(#glow)"
          />

          {/* Interactive Vertical Crosshair */}
          {activePoint && (
            <g>
              <line
                x1={activePoint.x}
                y1={paddingY - 10}
                x2={activePoint.x}
                y2={height - paddingY}
                stroke={currentConfig.color}
                strokeWidth="1.5"
                strokeDasharray="3 3"
                opacity="0.8"
              />
              <circle
                cx={activePoint.x}
                cy={activePoint.y}
                r="6"
                fill="#ffffff"
                stroke={currentConfig.color}
                strokeWidth="3.5"
              />
              <circle
                cx={activePoint.x}
                cy={activePoint.y}
                r="11"
                fill={currentConfig.color}
                opacity="0.2"
                className="animate-ping"
              />
            </g>
          )}

          {/* X-Axis Tick Labels */}
          {points.map((pt, idx) => (
            <text
              key={idx}
              x={pt.x}
              y={height - 12}
              textAnchor="middle"
              className="text-[11px] fill-zinc-400 font-mono select-none"
            >
              {pt.item.label}
            </text>
          ))}

          {/* Interactive Invisible Hover Columns */}
          {points.map((pt, idx) => {
            const colWidth = (width - paddingX * 2) / points.length;
            return (
              <rect
                key={idx}
                x={pt.x - colWidth / 2}
                y={0}
                width={colWidth}
                height={height}
                fill="transparent"
                className="cursor-pointer"
                onMouseEnter={() => setHoveredIndex(idx)}
              />
            );
          })}
        </svg>
      </div>

      {/* Bottom Summary Bar */}
      <div className="mt-4 pt-3 border-t border-zinc-100 flex flex-wrap items-center justify-between text-xs text-zinc-500 font-medium">
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-1.5">
            <span className="w-2 h-2 rounded-full bg-[#2d9d43]" />
            <span>Peak: {currentConfig.prefix}{Math.max(...values).toLocaleString('en-IN')}{currentConfig.suffix}</span>
          </div>
          <div className="flex items-center gap-1.5">
            <span className="w-2 h-2 rounded-full bg-zinc-400" />
            <span>Avg SLA: 9.4 min (98.8% Compliance)</span>
          </div>
        </div>
        <div className="flex items-center gap-1.5 text-[#078730] font-semibold">
          <Sparkles className="w-3.5 h-3.5" />
          <span>AI Prediction: Demand expected to surge +28% during 8 PM - 10 PM</span>
        </div>
      </div>
    </div>
  );
}
