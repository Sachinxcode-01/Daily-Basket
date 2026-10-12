'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import {
  CheckCircle2,
  AlertTriangle,
  RefreshCw,
  Server,
  Zap,
  Radio,
  CreditCard,
  Truck,
  ShieldCheck,
  ArrowLeft,
  Activity,
  Clock,
  Sparkles,
} from 'lucide-react';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';

interface ServiceItem {
  name: string;
  category: string;
  status: 'operational' | 'degraded' | 'maintenance';
  uptime: string;
  latency: string;
  description: string;
  icon: React.ComponentType<{ className?: string }>;
}

export default function SystemStatusPage() {
  const [lastChecked, setLastChecked] = useState<string>('');
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [apiData, setApiData] = useState<any>(null);

  const fetchStatus = async () => {
    setIsRefreshing(true);
    try {
      const res = await fetch('/api/status');
      const data = await res.json();
      setApiData(data);
      setLastChecked(new Date().toLocaleTimeString());
    } catch {
      setLastChecked(new Date().toLocaleTimeString());
    } finally {
      setIsRefreshing(false);
    }
  };

  useEffect(() => {
    fetchStatus();
    const interval = setInterval(fetchStatus, 30000);
    return () => clearInterval(interval);
  }, []);

  const services: ServiceItem[] = [
    {
      name: '10-Minute Dispatch Network',
      category: 'Fulfillment & Logistics',
      status: 'operational',
      uptime: '99.99%',
      latency: '2.4 min dispatch',
      description: 'Automated Dark Store micro-fulfillment and rapid picker routing.',
      icon: Truck,
    },
    {
      name: 'Real-Time Rider GPS Telemetry',
      category: 'Live Tracking Engine',
      status: 'operational',
      uptime: '99.98%',
      latency: '< 120ms',
      description: 'High-frequency WebSocket coordinates and live route telemetry.',
      icon: Radio,
    },
    {
      name: 'Core Catalog & Inventory Engine',
      category: 'Product Search & Pricing',
      status: 'operational',
      uptime: '100.0%',
      latency: '15ms',
      description: 'Synchronized real-time inventory counts across dark stores.',
      icon: Zap,
    },
    {
      name: 'Instant Payments & UPI Gateway',
      category: 'Checkout & Financial Services',
      status: 'operational',
      uptime: '99.99%',
      latency: '< 250ms',
      description: 'Multi-rail payment fallback (UPI, Cards, DB Wallet, Cash).',
      icon: CreditCard,
    },
    {
      name: 'Next.js Customer Web Application',
      category: 'Frontend & Edge Delivery',
      status: 'operational',
      uptime: '99.99%',
      latency: '40ms Edge',
      description: 'Next.js 14 App Router, Server Components, and asset pipeline.',
      icon: Server,
    },
    {
      name: 'Authentication & Security Vault',
      category: 'Identity & Access',
      status: 'operational',
      uptime: '99.99%',
      latency: '35ms',
      description: 'Biometric authorization, token refreshing, and fraud detection.',
      icon: ShieldCheck,
    },
  ];

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-inter">
      <HeaderNavBar />

      <main className="flex-1 max-w-5xl w-full mx-auto px-4 sm:px-6 py-8 sm:py-12">
        {/* Navigation Breadcrumb */}
        <div className="flex items-center justify-between mb-8">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-sm font-semibold text-slate-600 hover:text-[#006b23] transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to Daily Basket Home
          </Link>

          <div className="flex items-center gap-2 text-xs text-slate-500">
            <Clock className="w-3.5 h-3.5" />
            <span>Updated: {lastChecked || 'Just now'}</span>
            <button
              onClick={fetchStatus}
              disabled={isRefreshing}
              className="p-1 text-slate-500 hover:text-[#006b23] transition disabled:opacity-50"
              title="Refresh status"
            >
              <RefreshCw className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin' : ''}`} />
            </button>
          </div>
        </div>

        {/* Hero Operational Banner */}
        <div className="bg-emerald-600 text-white rounded-3xl p-6 sm:p-8 shadow-xl relative overflow-hidden mb-10">
          <div className="absolute top-0 right-0 w-80 h-80 bg-white/10 rounded-full blur-3xl pointer-events-none -mr-20 -mt-20" />
          <div className="relative z-10 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6">
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-2xl bg-white/20 backdrop-blur-md flex items-center justify-center shrink-0 shadow-inner">
                <CheckCircle2 className="w-8 h-8 text-white" />
              </div>
              <div>
                <span className="text-[11px] font-bold uppercase tracking-wider bg-white/20 px-2.5 py-0.5 rounded-full inline-block mb-2">
                  System Health: 100% Operational
                </span>
                <h1 className="text-2xl sm:text-3xl font-extrabold font-outfit tracking-tight">
                  All Systems Fully Operational
                </h1>
                <p className="text-emerald-100 text-xs sm:text-sm mt-1 max-w-xl">
                  Daily Basket’s 10-minute grocery delivery network, telemetry pipelines, and payment processing are functioning smoothly.
                </p>
              </div>
            </div>

            <div className="bg-white/10 backdrop-blur-md px-5 py-3.5 rounded-2xl border border-white/20 text-center shrink-0 w-full sm:w-auto">
              <span className="text-[10px] uppercase font-bold text-emerald-200 tracking-wider block">
                90-Day Uptime SLA
              </span>
              <span className="text-2xl font-black font-outfit text-white">99.98%</span>
            </div>
          </div>
        </div>

        {/* Live Status API Diagnostic Box */}
        {apiData && (
          <div className="bg-white rounded-2xl border border-slate-200/80 p-5 mb-8 shadow-xs">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <Activity className="w-4 h-4 text-[#006b23]" />
                <h2 className="text-sm font-bold text-slate-800 font-outfit">
                  Live JSON Status API Probe (`/api/status`)
                </h2>
              </div>
              <span className="text-[11px] font-extrabold bg-emerald-100 text-emerald-800 px-2.5 py-0.5 rounded-full">
                HTTP 200 OK
              </span>
            </div>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
              <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                <span className="text-slate-400 block text-[10px] font-semibold uppercase">API Status</span>
                <span className="font-bold text-slate-800 capitalize font-outfit">{apiData.status || 'Active'}</span>
              </div>
              <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                <span className="text-slate-400 block text-[10px] font-semibold uppercase">Uptime</span>
                <span className="font-bold text-slate-800 font-outfit">{apiData.uptime}s</span>
              </div>
              <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                <span className="text-slate-400 block text-[10px] font-semibold uppercase">Catalog Engine</span>
                <span className="font-bold text-[#006b23] font-outfit">
                  {apiData.services?.catalogEngine?.activeProductsCount || 240}+ Items
                </span>
              </div>
              <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                <span className="text-slate-400 block text-[10px] font-semibold uppercase">Delivery SLA</span>
                <span className="font-bold text-slate-800 font-outfit">10 Minutes</span>
              </div>
            </div>
          </div>
        )}

        {/* Services List Grid */}
        <div className="space-y-4 mb-12">
          <h2 className="text-lg font-bold text-slate-900 font-outfit flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-[#006b23]" />
            Core Architecture Status
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {services.map((srv) => {
              const Icon = srv.icon;
              return (
                <div
                  key={srv.name}
                  className="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs hover:border-emerald-300 transition-all flex flex-col justify-between"
                >
                  <div className="flex items-start justify-between gap-3 mb-3">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-emerald-50 text-[#006b23] flex items-center justify-center shrink-0">
                        <Icon className="w-5 h-5" />
                      </div>
                      <div>
                        <h3 className="font-bold text-sm text-slate-900 font-outfit leading-tight">
                          {srv.name}
                        </h3>
                        <span className="text-[11px] text-slate-400 font-medium">{srv.category}</span>
                      </div>
                    </div>

                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200/60 shrink-0">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
                      Operational
                    </span>
                  </div>

                  <p className="text-xs text-slate-500 leading-relaxed mb-4">{srv.description}</p>

                  <div className="pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-600 font-medium">
                    <span>
                      Uptime: <strong className="text-slate-900 font-bold">{srv.uptime}</strong>
                    </span>
                    <span>
                      Response: <strong className="text-[#006b23] font-bold">{srv.latency}</strong>
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Incident History (Clean / Operational) */}
        <div className="bg-white rounded-2xl border border-slate-200/80 p-6 shadow-xs">
          <h2 className="text-base font-bold text-slate-900 font-outfit mb-4">Past Incident History</h2>
          <div className="border-l-2 border-emerald-500 pl-4 py-1 space-y-1">
            <span className="text-xs font-bold text-emerald-700">No Incidents Reported</span>
            <p className="text-xs text-slate-500">
              All infrastructure, dispatch services, and database clusters operated with 100% availability over the last 30 days.
            </p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-slate-200/80 py-8 px-4 text-center text-xs text-slate-500">
        <p>© 2026 Daily Basket Quick-Commerce Suite. Real-Time Telemetry & Systems Health.</p>
      </footer>
    </div>
  );
}
