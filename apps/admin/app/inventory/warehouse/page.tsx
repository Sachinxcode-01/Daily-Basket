'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Search,
  Package,
  AlertTriangle,
  Truck,
  Lightbulb,
  Sparkles,
  MapPin,
  Edit,
  QrCode,
  History,
  Plus,
  LayoutGrid,
  Smartphone,
  Grid,
  ShoppingBag,
  Store,
  ShoppingCart,
  BarChart3,
} from 'lucide-react';

// Google Stitch Specs: Warehouse & Stock Transfer
// ID: 61fae24afaf04b269022aaeb5696ed71

export default function WarehouseStockPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [isSmartDismissed, setIsSmartDismissed] = useState(false);
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const warehouseData = {
    totalStock: '45.2k',
    totalStockTrend: '+2.4%',
    lowStockCount: 12,
    inTransitCount: 8,
    smartRecommendation: 'Demand forecast indicates potential shortage. Recommend transferring 50 units of Organic Milk from WH-South to WH-Central.',
    items: [
      {
        id: 'INV-001',
        name: 'Organic Farm Veggies',
        sku: 'SKU: VEG-ORG-001',
        location: 'WH-North • Shelf A4',
        status: 'OPTIMAL',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        available: 342,
        reserved: 45,
        image: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200',
      },
      {
        id: 'INV-002',
        name: 'Premium Avocados',
        sku: 'SKU: FRT-AVO-002',
        location: 'WH-South • Cold Zone B',
        status: 'LOW',
        statusBg: 'bg-rose-100 text-[#dc2626]',
        available: 12,
        reserved: 80,
        image: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200',
        hasAccent: true,
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Stitch Header Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Warehouse &amp; Stock</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">Google Stitch Screen ID: 61fae24afaf04b269022aaeb5696ed71</p>
          </div>
        </div>

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

      {/* Main View */}
      {viewMode === 'mobile' ? (
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Warehouse &amp; Stock</span>
              <Search className="w-5 h-5 text-[#1e2923] cursor-pointer" />
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              {/* Metrics Strip */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                <div className="min-w-[125px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1 text-[#64748b]">
                    <Package className="w-3.5 h-3.5" />
                    <span className="font-bold text-[10px] uppercase tracking-wider">Total Stock</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{warehouseData.totalStock}</p>
                  <p className="text-[10px] font-bold text-[#15803d]">📈 {warehouseData.totalStockTrend}</p>
                </div>

                <div className="min-w-[125px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1 text-[#dc2626]">
                    <AlertTriangle className="w-3.5 h-3.5" />
                    <span className="font-bold text-[10px] uppercase tracking-wider">Low Stock</span>
                  </div>
                  <p className="text-2xl font-black text-[#dc2626]">{warehouseData.lowStockCount}</p>
                  <p className="text-[10px] text-[#64748b]">Items require action</p>
                </div>

                <div className="min-w-[125px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1 text-[#0284c7]">
                    <Truck className="w-3.5 h-3.5" />
                    <span className="font-bold text-[10px] uppercase tracking-wider">In Transit</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{warehouseData.inTransitCount}</p>
                  <p className="text-[10px] text-[#64748b]">Active transfers</p>
                </div>
              </div>

              {/* Search Bar */}
              <div className="bg-[#f1f5f9] px-3.5 py-2.5 rounded-2xl border border-[#e2e8f0] flex items-center gap-2 text-xs">
                <QrCode className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  placeholder="Search Product, SKU, Barcode..."
                  className="bg-transparent border-none outline-none w-full text-[#1e2923]"
                />
              </div>

              {/* Filter Chips */}
              <div className="flex gap-2 text-xs overflow-x-auto no-scrollbar">
                {['All', 'Available', 'Low Stock ●', 'In Transit'].map((f) => (
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

              {/* Smart Optimization Banner */}
              {!isSmartDismissed && (
                <div className="bg-[#e6f4ea] p-4 rounded-3xl border border-[#a7f3d0] space-y-3">
                  <div className="flex items-center gap-2">
                    <Lightbulb className="w-5 h-5 text-[#006837]" />
                    <h4 className="font-black text-sm text-[#1e2923]">Smart Optimization</h4>
                  </div>
                  <p className="text-xs text-[#334155] leading-relaxed">{warehouseData.smartRecommendation}</p>
                  <div className="flex items-center gap-3">
                    <button
                      onClick={() => setActiveModal('Execute Transfer')}
                      className="px-4 py-2 bg-[#006837] text-white text-xs font-bold rounded-2xl flex items-center gap-1.5 hover:bg-[#00522b]"
                    >
                      Execute Transfer →
                    </button>
                    <button
                      onClick={() => setIsSmartDismissed(true)}
                      className="text-xs text-[#64748b] font-bold hover:text-[#1e2923]"
                    >
                      Dismiss
                    </button>
                  </div>
                </div>
              )}

              {/* Inventory List */}
              <div className="space-y-3">
                <h4 className="font-black text-sm text-[#1e2923]">Inventory List</h4>

                {warehouseData.items.map((item) => (
                  <div
                    key={item.id}
                    className={`bg-white p-4 rounded-3xl border ${
                      item.hasAccent ? 'border-[#fecaca] border-l-4 border-l-[#dc2626]' : 'border-[#e2e8f0]'
                    } shadow-sm space-y-3`}
                  >
                    <div className="flex items-center gap-3">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={item.image} alt={item.name} className="w-14 h-14 rounded-2xl object-cover" />
                      <div className="flex-1 space-y-1">
                        <div className="flex justify-between items-center">
                          <h5 className="font-bold text-sm text-[#1e2923]">{item.name}</h5>
                          <span className={`px-2 py-0.5 text-[9px] font-bold rounded-md ${item.statusBg}`}>
                            {item.status}
                          </span>
                        </div>
                        <p className="text-[11px] text-[#64748b] font-mono">{item.sku}</p>
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-[#f1f5f9] text-[10px] text-[#1e2923] font-semibold rounded-md">
                          <MapPin className="w-3 h-3 text-[#64748b]" /> {item.location}
                        </span>
                      </div>
                    </div>

                    <div className="pt-2 border-t border-[#f1f5f9] flex justify-between items-center text-xs">
                      <div>
                        <span className="text-[10px] font-bold text-[#64748b]">AVAILABLE</span>
                        <p className={`font-black text-base ${item.hasAccent ? 'text-[#dc2626]' : 'text-[#1e2923]'}`}>
                          {item.available} <span className="text-xs font-normal text-[#64748b]">units</span>
                        </p>
                      </div>
                      <div className="text-right">
                        <span className="text-[10px] font-bold text-[#64748b]">RESERVED</span>
                        <p className="font-black text-base text-[#1e2923]">
                          {item.reserved} <span className="text-xs font-normal text-[#64748b]">units</span>
                        </p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Quick Tools */}
              <div className="space-y-3">
                <h4 className="font-black text-sm text-[#1e2923]">Quick Tools</h4>
                <div className="grid grid-cols-3 gap-2">
                  <button
                    onClick={() => setActiveModal('Adjust Stock')}
                    className="p-3 bg-white rounded-2xl border border-[#e2e8f0] flex flex-col items-center gap-2 hover:bg-[#f8fafc]"
                  >
                    <div className="p-2 bg-[#dce6fe] rounded-full text-[#2563eb]">
                      <Edit className="w-4 h-4" />
                    </div>
                    <span className="text-[10px] font-bold text-[#1e2923]">Adjust Stock</span>
                  </button>

                  <button
                    onClick={() => setActiveModal('Scan Barcode')}
                    className="p-3 bg-white rounded-2xl border border-[#e2e8f0] flex flex-col items-center gap-2 hover:bg-[#f8fafc]"
                  >
                    <div className="p-2 bg-[#dcfce7] rounded-full text-[#15803d]">
                      <QrCode className="w-4 h-4" />
                    </div>
                    <span className="text-[10px] font-bold text-[#1e2923]">Scan Barcode</span>
                  </button>

                  <button
                    onClick={() => setActiveModal('Transfer History')}
                    className="p-3 bg-white rounded-2xl border border-[#e2e8f0] flex flex-col items-center gap-2 hover:bg-[#f8fafc]"
                  >
                    <div className="p-2 bg-[#fce7f3] rounded-full text-[#db2777]">
                      <History className="w-4 h-4" />
                    </div>
                    <span className="text-[10px] font-bold text-[#1e2923]">Transfer History</span>
                  </button>
                </div>
              </div>

              <button
                onClick={() => setActiveModal('Add Item')}
                className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
              >
                <Plus className="w-6 h-6" />
              </button>
            </div>

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
        /* Web View */
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#64748b] font-bold uppercase">Total Stock</span>
              <p className="text-3xl font-black text-[#1e2923]">{warehouseData.totalStock}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#dc2626] font-bold uppercase">Low Stock</span>
              <p className="text-3xl font-black text-[#dc2626]">{warehouseData.lowStockCount}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#0284c7] font-bold uppercase">In Transit</span>
              <p className="text-3xl font-black text-[#1e2923]">{warehouseData.inTransitCount}</p>
            </div>
          </div>

          <div className="bg-[#e6f4ea] p-6 rounded-3xl border border-[#a7f3d0] flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Sparkles className="w-6 h-6 text-[#006837]" />
              <p className="text-xs text-[#334155]">{warehouseData.smartRecommendation}</p>
            </div>
            <button
              onClick={() => setActiveModal('Execute Transfer')}
              className="px-5 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-2xl hover:bg-[#00522b]"
            >
              Execute Transfer
            </button>
          </div>
        </div>
      )}

      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal}</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for Warehouse module.</p>
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
