'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Search,
  CheckCircle2,
  AlertTriangle,
  Clock,
  Eye,
  QrCode,
  Plus,
  LayoutGrid,
  Smartphone,
  Menu,
  Bell,
  Grid,
  ShoppingBag,
  Package,
  Store,
  ShoppingCart,
  BarChart3,
} from 'lucide-react';

// Google Stitch Specs: Goods Receipt Note (GRN)
// ID: 2976f395e6a74cda8bb155e7eb488a81

export default function GrnManagementPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [selectedFilter, setSelectedFilter] = useState('Pending');
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const grnData = {
    pendingCount: 12,
    receivedToday: 45,
    rejectedCount: 3,
    records: [
      {
        id: 'GRN-9921',
        supplier: 'Fresh Farms Ltd.',
        poNumber: 'PO-2023-0891',
        invNumber: 'INV-9921',
        status: 'Partial',
        statusBg: 'bg-amber-100 text-[#c2410c]',
        receivedItems: 45,
        totalItems: 50,
        progress: 90,
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
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Goods Receipt (GRN)</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">Google Stitch Screen ID: 2976f395e6a74cda8bb155e7eb488a81</p>
          </div>
        </div>

        {/* View Mode Switcher */}
        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('web')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Web Dashboard</span>
          </button>
          <button
            onClick={() => setViewMode('mobile')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Mobile Stitch View</span>
          </button>
        </div>
      </div>

      {/* Main Content */}
      {viewMode === 'mobile' ? (
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Daily Basket</span>
              <span className="px-2.5 py-1 bg-[#e2e8f0] text-[11px] font-black text-[#1e2923] rounded-lg">AU</span>
            </div>

            {/* Scrollable Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              <h2 className="text-xl font-black text-[#1e2923]">Goods Receipt (GRN)</h2>

              {/* Search Bar */}
              <div className="bg-[#f1f5f9] px-3.5 py-2.5 rounded-2xl border border-[#e2e8f0] flex items-center gap-2 text-xs">
                <Search className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  placeholder="Search GRN #, PO #, or Supplier..."
                  className="bg-transparent border-none outline-none w-full text-[#1e2923]"
                />
              </div>

              {/* Top Metrics Cards Strip */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                <div className="min-w-[125px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1.5 text-[#c2410c]">
                    <Clock className="w-4 h-4" />
                    <span className="font-bold text-[11px]">Pending</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{grnData.pendingCount}</p>
                  <p className="text-[10px] text-[#64748b]">Require action</p>
                </div>

                <div className="min-w-[125px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1.5 text-[#15803d]">
                    <CheckCircle2 className="w-4 h-4" />
                    <span className="font-bold text-[11px]">Received</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{grnData.receivedToday}</p>
                  <p className="text-[10px] text-[#64748b]">Today</p>
                </div>

                <div className="min-w-[125px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1.5 text-[#dc2626]">
                    <AlertTriangle className="w-4 h-4" />
                    <span className="font-bold text-[11px]">Rejected</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{grnData.rejectedCount}</p>
                  <p className="text-[10px] text-[#64748b]">Items damaged</p>
                </div>
              </div>

              {/* Filter Chips */}
              <div className="flex gap-2 text-xs overflow-x-auto no-scrollbar">
                {['Pending', 'Partial', 'Completed', 'Damaged'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedFilter(f)}
                    className={`px-4 py-1.5 rounded-full font-bold transition shrink-0 ${
                      selectedFilter === f
                        ? 'bg-[#006837] text-white shadow-sm'
                        : 'bg-white text-[#64748b] border border-[#e2e8f0]'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>

              {/* GRN Record Card */}
              {grnData.records.map((rec) => (
                <div key={rec.id} className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                  <div className="flex justify-between items-center">
                    <span className="font-black text-base text-[#1e2923]">{rec.supplier}</span>
                    <span className={`px-2.5 py-0.5 text-[10px] font-bold rounded-md ${rec.statusBg}`}>
                      {rec.status}
                    </span>
                  </div>
                  <p className="text-xs text-[#64748b]">{rec.poNumber} • {rec.invNumber}</p>

                  <div className="flex justify-between items-center text-xs">
                    <span className="text-[#64748b]">Received</span>
                    <span className="font-bold text-[#1e2923]">{rec.receivedItems} / {rec.totalItems} items</span>
                  </div>

                  <div className="w-full h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                    <div className="h-full bg-[#006837]" style={{ width: `${rec.progress}%` }} />
                  </div>

                  <div className="flex gap-2 pt-1">
                    <button
                      onClick={() => setActiveModal('Review')}
                      className="flex-1 py-2.5 border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-2xl flex items-center justify-center gap-1.5 hover:bg-[#f8fafc]"
                    >
                      <Eye className="w-3.5 h-3.5" /> Review
                    </button>
                    <button
                      onClick={() => setActiveModal('Scan Barcode')}
                      className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-2xl flex items-center justify-center gap-1.5 hover:bg-[#00522b]"
                    >
                      <QrCode className="w-3.5 h-3.5" /> Scan
                    </button>
                  </div>
                </div>
              ))}

              {/* Floating Action Button */}
              <button
                onClick={() => setActiveModal('Create GRN')}
                className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
              >
                <Plus className="w-6 h-6" />
              </button>
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#006837] text-white rounded-2xl"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><Store className="w-4 h-4" /> Suppliers</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingCart className="w-4 h-4" /> Purchase</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#64748b] font-bold uppercase tracking-wider">Pending Action</span>
              <p className="text-3xl font-black text-[#1e2923]">{grnData.pendingCount}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#15803d] font-bold uppercase tracking-wider">Received Today</span>
              <p className="text-3xl font-black text-[#15803d]">{grnData.receivedToday}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#dc2626] font-bold uppercase tracking-wider">Rejected Items</span>
              <p className="text-3xl font-black text-[#dc2626]">{grnData.rejectedCount}</p>
            </div>
          </div>

          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
            <h3 className="font-black text-lg text-[#1e2923]">Recent GRN Records</h3>
            {grnData.records.map((rec) => (
              <div key={rec.id} className="p-5 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-center justify-between">
                <div>
                  <h4 className="font-bold text-base text-[#1e2923]">{rec.supplier}</h4>
                  <p className="text-xs text-[#64748b]">{rec.poNumber} • {rec.invNumber}</p>
                </div>
                <div className="text-right space-y-1">
                  <span className={`px-3 py-1 text-xs font-bold rounded-full ${rec.statusBg}`}>{rec.status}</span>
                  <p className="text-xs text-[#1e2923] font-bold">{rec.receivedItems} / {rec.totalItems} items</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Action Modals */}
      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal}</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for GRN module.</p>
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
