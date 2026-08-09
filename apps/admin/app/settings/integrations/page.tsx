'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Search,
  CheckCircle2,
  Settings,
  RefreshCw,
  Plus,
  CreditCard,
  Truck,
  Building2,
  MessageSquare,
  Activity,
  AlertCircle,
  Webhook,
  LayoutGrid,
  Smartphone,
} from 'lucide-react';

// Google Stitch Specs: Integrations & Connected Services
// ID: 9bc94728c71e4ce3826b231fa838436f

export default function IntegrationsPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const integrationsData = {
    activeServices: 14,
    apiHealth: '99.9%',
    syncErrors: 0,
    webhooksCount: 28,
    services: [
      {
        id: 'srv-1',
        name: 'Razorpay Payment Gateway',
        category: 'Payments',
        status: 'Connected',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        subtitle: 'Primary Gateway • Webhooks Active',
        icon: CreditCard,
        iconBg: 'bg-indigo-100 text-[#2563eb]',
      },
      {
        id: 'srv-2',
        name: 'Shadowfax Logistics',
        category: 'Logistics',
        status: 'Connected',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        subtitle: 'Hyperlocal Express • Live Tracking',
        icon: Truck,
        iconBg: 'bg-amber-100 text-[#c2410c]',
      },
      {
        id: 'srv-3',
        name: 'Tally Prime ERP',
        category: 'ERP & Tax',
        status: 'Sync Active',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        subtitle: 'Auto Sync every 15 mins',
        icon: Building2,
        iconBg: 'bg-slate-100 text-[#475569]',
      },
      {
        id: 'srv-4',
        name: 'Twilio SMS & OTP',
        category: 'Messaging',
        status: 'Connected',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        subtitle: 'Customer OTP & Instant Notifications',
        icon: MessageSquare,
        iconBg: 'bg-pink-100 text-[#db2777]',
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Integrations &amp; Services</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch Screen ID: 9bc94728c71e4ce3826b231fa838436f
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('web')}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Web Dashboard</span>
          </button>
          <button
            onClick={() => setViewMode('mobile')}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Mobile Stitch View</span>
          </button>
        </div>
      </div>

      {/* Main View */}
      {viewMode === 'mobile' ? (
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Connected Services</span>
              <RefreshCw className="w-5 h-5 text-[#1e2923] cursor-pointer" />
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              <div>
                <h2 className="text-xl font-black text-[#1e2923]">Integrations &amp; Services</h2>
                <p className="text-xs text-[#64748b] mt-0.5">Manage third-party APIs, payment gateways &amp; ERP sync.</p>
              </div>

              {/* Metrics Strip */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#15803d]">
                    <span className="font-bold text-[11px] text-[#64748b]">Active Services</span>
                    <CheckCircle2 className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{integrationsData.activeServices}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#0284c7]">
                    <span className="font-bold text-[11px] text-[#64748b]">API Health</span>
                    <Activity className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{integrationsData.apiHealth}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#64748b]">
                    <span className="font-bold text-[11px] text-[#64748b]">Sync Errors</span>
                    <AlertCircle className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{integrationsData.syncErrors}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center text-[#c2410c]">
                    <span className="font-bold text-[11px] text-[#64748b]">Webhooks</span>
                    <Webhook className="w-4 h-4" />
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{integrationsData.webhooksCount}</p>
                </div>
              </div>

              {/* Search Bar */}
              <div className="bg-[#f1f5f9] px-3.5 py-2.5 rounded-2xl border border-[#e2e8f0] flex items-center gap-2 text-xs">
                <Search className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  placeholder="Search integrations, API keys..."
                  className="bg-transparent border-none outline-none w-full text-[#1e2923]"
                />
              </div>

              {/* Filter Chips */}
              <div className="flex gap-2 text-xs overflow-x-auto no-scrollbar">
                {['All', 'Payments', 'Logistics', 'ERP & Tax', 'Messaging'].map((c) => (
                  <button
                    key={c}
                    onClick={() => setSelectedCategory(c)}
                    className={`px-4 py-1.5 rounded-full font-bold transition shrink-0 ${
                      selectedCategory === c
                        ? 'bg-[#006837] text-white shadow-sm'
                        : 'bg-white text-[#64748b] border border-[#e2e8f0]'
                    }`}
                  >
                    {c}
                  </button>
                ))}
              </div>

              {/* Services List */}
              <div className="space-y-3">
                <h4 className="font-black text-sm text-[#1e2923]">Connected Integrations</h4>

                {integrationsData.services.map((srv) => {
                  const IconComp = srv.icon;
                  return (
                    <div key={srv.id} className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className={`p-3 rounded-full ${srv.iconBg}`}>
                          <IconComp className="w-5 h-5" />
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <h5 className="font-bold text-sm text-[#1e2923]">{srv.name}</h5>
                            <span className={`px-2 py-0.5 text-[9px] font-bold rounded-md ${srv.statusBg}`}>
                              {srv.status}
                            </span>
                          </div>
                          <p className="text-xs text-[#64748b] mt-0.5">{srv.subtitle}</p>
                        </div>
                      </div>

                      <button
                        onClick={() => setActiveModal(`Configure ${srv.name}`)}
                        className="p-2 text-[#64748b] hover:text-[#1e2923]"
                      >
                        <Settings className="w-5 h-5" />
                      </button>
                    </div>
                  );
                })}
              </div>

              <button
                onClick={() => setActiveModal('Add Integration')}
                className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
              >
                <Plus className="w-6 h-6" />
              </button>
            </div>
          </div>
        </div>
      ) : (
        /* Web View */
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#15803d] font-bold uppercase">Active Services</span>
              <p className="text-3xl font-black text-[#1e2923]">{integrationsData.activeServices}</p>
            </div>
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#0284c7] font-bold uppercase">API Health</span>
              <p className="text-3xl font-black text-[#1e2923]">{integrationsData.apiHealth}</p>
            </div>
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#64748b] font-bold uppercase">Sync Errors</span>
              <p className="text-3xl font-black text-[#1e2923]">{integrationsData.syncErrors}</p>
            </div>
            <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#c2410c] font-bold uppercase">Webhooks</span>
              <p className="text-3xl font-black text-[#1e2923]">{integrationsData.webhooksCount}</p>
            </div>
          </div>

          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
            <h3 className="font-black text-lg text-[#1e2923]">Connected Integrations</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {integrationsData.services.map((srv) => (
                <div key={srv.id} className="p-5 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex justify-between items-center">
                  <div>
                    <h4 className="font-bold text-base text-[#1e2923]">{srv.name}</h4>
                    <p className="text-xs text-[#64748b]">{srv.subtitle}</p>
                  </div>
                  <span className={`px-3 py-1 text-xs font-bold rounded-full ${srv.statusBg}`}>{srv.status}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal}</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for Integrations module.</p>
            <button
              onClick={() => setActiveModal(null)}
              className="w-full py-3 bg-[#006837] text-white font-bold text-xs rounded-2xl hover:bg-[#00522b]"
            >
              Close Modal
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
