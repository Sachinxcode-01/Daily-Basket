'use client';

import React, { useState } from 'react';
import {
  Menu,
  Search,
  Bell,
  Star,
  Truck,
  FileText,
  AlertTriangle,
  Sparkles,
  TrendingDown,
  Plus,
  ArrowLeft,
  Calendar,
  Grid,
  ShoppingBag,
  Package,
  Store,
  BarChart3,
  Smartphone,
  LayoutGrid,
  Clock,
  CheckCircle2,
  Download,
  ShoppingCart,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen 1: Supplier Management (ID: cbebf2e047194f8989458a08bc60da09)
// Screen 2: Purchase Order Management (ID: 1ed38b1be9d84fa6a1eabb2b964f9a70)

export default function SuppliersAndPurchaseOrdersPage() {
  const [activeTab, setActiveTab] = useState<'suppliers' | 'orders'>('suppliers');
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [supplierFilter, setSupplierFilter] = useState('All');
  const [poFilter, setPoFilter] = useState('All');
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const suppliersData = {
    totalSuppliers: 124,
    activeCount: 112,
    pendingCount: 18,
    suppliers: [
      {
        id: 'SUP-001',
        name: 'Organic Roots Co.',
        rating: '4.9',
        status: 'Preferred',
        statusBg: 'bg-emerald-100 text-[#15803d]',
        accent: 'border-l-[#006837]',
        lastDelivery: '2h ago',
        pendingPOs: 3,
        hasDelay: false,
        logo: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=100',
      },
      {
        id: 'SUP-002',
        name: 'Heritage Dairy',
        rating: '4.7',
        status: 'Active',
        statusBg: 'bg-slate-100 text-[#475569]',
        accent: 'border-l-[#006837]',
        lastDelivery: 'Yesterday',
        pendingPOs: 0,
        hasDelay: false,
        logo: 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?w=100',
      },
      {
        id: 'SUP-003',
        name: 'Sunrise Bakery',
        rating: '4.2',
        status: 'Review Pending',
        statusBg: 'bg-amber-100 text-[#c2410c]',
        accent: 'border-l-[#c2410c]',
        lastDelivery: '3 days ago',
        pendingPOs: 1,
        hasDelay: true,
        delayedPoNumber: '#1042',
        logo: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100',
      },
    ],
  };

  const poData = {
    totalPOs: '1,240',
    pendingCount: 18,
    inTransitCount: 12,
    aiPurchaseInsight: 'Suggested 15% increase in Avocado orders for next week based on local festival demand forecast.',
    orders: [
      {
        id: 'PO #1084',
        status: 'IN TRANSIT',
        statusBg: 'bg-sky-100 text-[#0284c7]',
        amount: '₹14,500',
        supplier: 'Organic Roots Co.',
        expectedDate: '24 Oct',
        progress: 70,
        action1Label: 'Download PDF',
        action2Label: 'Receive Goods',
      },
      {
        id: 'PO #1085',
        status: 'PENDING',
        statusBg: 'bg-amber-100 text-[#c2410c]',
        amount: '₹8,200',
        supplier: 'Fresh Farms Ltd.',
        expectedDate: '26 Oct',
        progress: 30,
        action1Label: 'Review',
        action2Label: 'Approve',
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Stitch Header Title & Navigation Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">
              {activeTab === 'suppliers' ? 'Supplier Management' : 'Purchase Orders'}
            </h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: {activeTab === 'suppliers' ? 'cbebf2e047194f8989458a08bc60da09' : '1ed38b1be9d84fa6a1eabb2b964f9a70'}
            </p>
          </div>
        </div>

        {/* Controls Row: Tab Switcher & View Mode Toggle */}
        <div className="flex flex-wrap items-center gap-3">
          <div className="flex items-center bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
            <button
              onClick={() => setActiveTab('suppliers')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                activeTab === 'suppliers' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
              }`}
            >
              Suppliers
            </button>
            <button
              onClick={() => setActiveTab('orders')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                activeTab === 'orders' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
              }`}
            >
              Purchase Orders
            </button>
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
      </div>

      {/* Main Content */}
      {viewMode === 'mobile' ? (
        /* Mobile Device Frame View simulating exact phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              {activeTab === 'suppliers' ? (
                <Menu className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              ) : (
                <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              )}
              <span className="font-extrabold text-base text-[#006837]">
                {activeTab === 'suppliers' ? 'Suppliers' : 'Daily Basket'}
              </span>
              <div className="flex items-center gap-2">
                <Search className="w-4 h-4 text-[#1e2923]" />
                <Bell className="w-4 h-4 text-[#1e2923]" />
              </div>
            </div>

            {/* Scrollable Mobile Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              {activeTab === 'suppliers' ? (
                /* Supplier Management Screen */
                <>
                  {/* Top Metrics Strip */}
                  <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <p className="text-[11px] text-[#64748b]">Total Suppliers</p>
                      <p className="text-2xl font-black text-[#1e2923]">{suppliersData.totalSuppliers}</p>
                    </div>
                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <p className="text-[11px] text-[#64748b]">Active</p>
                      <p className="text-2xl font-black text-[#15803d]">{suppliersData.activeCount}</p>
                    </div>
                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                      <p className="text-[11px] text-[#64748b]">Pending</p>
                      <p className="text-2xl font-black text-[#c2410c]">{suppliersData.pendingCount}</p>
                    </div>
                  </div>

                  {/* Search Bar */}
                  <div className="bg-[#f1f5f9] px-3.5 py-2.5 rounded-2xl border border-[#e2e8f0] flex items-center gap-2 text-xs">
                    <Search className="w-4 h-4 text-[#64748b]" />
                    <input
                      type="text"
                      placeholder="Search suppliers, GST..."
                      className="bg-transparent border-none outline-none w-full text-[#1e2923]"
                    />
                  </div>

                  {/* Filter Chips Row */}
                  <div className="flex gap-2 text-xs">
                    {['All', 'Preferred', 'Active', 'Pending'].map((f) => (
                      <button
                        key={f}
                        onClick={() => setSupplierFilter(f)}
                        className={`px-3.5 py-1.5 rounded-full font-bold transition ${
                          supplierFilter === f
                            ? 'bg-[#dce6fe] text-[#1e2923] border border-[#006837]'
                            : 'bg-white text-[#64748b] border border-[#e2e8f0]'
                        }`}
                      >
                        {f}
                      </button>
                    ))}
                  </div>

                  {/* Supplier Directory */}
                  <div className="space-y-3">
                    <h4 className="font-black text-sm text-[#1e2923]">Supplier Directory</h4>

                    {suppliersData.suppliers.map((sup) => (
                      <div
                        key={sup.id}
                        className={`bg-white p-3.5 rounded-3xl border border-[#e2e8f0] border-l-4 ${sup.accent} shadow-sm space-y-2`}
                      >
                        <div className="flex items-center gap-3">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img src={sup.logo} alt={sup.name} className="w-11 h-11 rounded-2xl object-cover" />
                          <div className="flex-1 space-y-1">
                            <h5 className="font-bold text-sm text-[#1e2923]">{sup.name}</h5>
                            <div className="flex items-center gap-2">
                              <span className="px-1.5 py-0.5 bg-[#f1f5f9] text-[10px] font-bold text-[#1e2923] rounded flex items-center gap-0.5">
                                <Star className="w-3 h-3 text-[#64748b]" /> {sup.rating}
                              </span>
                              <span className={`px-2.5 py-0.5 text-[10px] font-bold rounded-full ${sup.statusBg}`}>
                                {sup.status}
                              </span>
                            </div>
                          </div>
                        </div>

                        <div className="pt-2 border-t border-[#f1f5f9] flex justify-between items-center text-[11px] text-[#64748b]">
                          <span className="flex items-center gap-1"><Truck className="w-3.5 h-3.5" /> Last Delivery: {sup.lastDelivery}</span>
                          {sup.hasDelay ? (
                            <span className="font-bold text-[#c2410c] flex items-center gap-1"><AlertTriangle className="w-3.5 h-3.5" /> Delayed PO: {sup.delayedPoNumber}</span>
                          ) : (
                            <span className="font-bold text-[#1e2923] flex items-center gap-1"><FileText className="w-3.5 h-3.5" /> Pending POs: {sup.pendingPOs}</span>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Smart Insights Card */}
                  <div className="bg-[#e6f4ea] p-4 rounded-3xl border border-[#a7f3d0] space-y-3">
                    <div className="flex items-center gap-2">
                      <Sparkles className="w-4 h-4 text-[#006837]" />
                      <h4 className="font-black text-sm text-[#006837]">Smart Insights</h4>
                    </div>

                    <div className="bg-white p-3.5 rounded-2xl border border-[#e2e8f0] space-y-2">
                      <span className="text-[10px] font-bold text-[#64748b] tracking-wider uppercase">
                        TOP PERFORMING CATEGORY
                      </span>
                      <div className="flex justify-between items-center">
                        <span className="font-black text-base text-[#1e2923]">Fresh Produce</span>
                        <TrendingDown className="w-4 h-4 text-[#15803d]" />
                      </div>
                      <p className="text-xs font-bold text-[#15803d]">📉 2.4% cost reduction</p>
                      <div className="w-full h-[1px] bg-[#f1f5f9]" />
                      <p className="text-[11px] text-[#334155] leading-snug">
                        Consider consolidating dairy orders with <span className="font-bold">Heritage Dairy</span> to unlock volume discounts.
                      </p>
                    </div>
                  </div>

                  {/* Floating Action Button */}
                  <button
                    onClick={() => setActiveModal('New Supplier')}
                    className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
                  >
                    <Plus className="w-6 h-6" />
                  </button>
                </>
              ) : (
                /* Purchase Order Management Screen */
                <>
                  {/* AI Purchase Insight Banner */}
                  <div className="bg-[#f0f7ff] p-4 rounded-3xl border border-[#dce6fe] flex items-start gap-3">
                    <Sparkles className="w-5 h-5 text-[#006837] shrink-0 mt-0.5" />
                    <div>
                      <h4 className="font-bold text-xs text-[#1e2923]">AI Purchase Insight</h4>
                      <p className="text-[11px] text-[#334155] leading-snug mt-1">{poData.aiPurchaseInsight}</p>
                    </div>
                  </div>

                  {/* Metrics Cards Strip */}
                  <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] border-l-4 border-l-slate-600 shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-[#64748b]">
                        <span className="text-[11px]">Total POs</span>
                        <FileText className="w-4 h-4" />
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{poData.totalPOs}</p>
                    </div>

                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] border-l-4 border-l-amber-600 shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-[#c2410c]">
                        <span className="text-[11px] text-[#64748b]">Pending</span>
                        <Clock className="w-4 h-4" />
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{poData.pendingCount}</p>
                    </div>

                    <div className="min-w-[130px] bg-white p-3 rounded-2xl border border-[#e2e8f0] border-l-4 border-l-sky-600 shadow-sm space-y-2">
                      <div className="flex justify-between items-center text-[#0284c7]">
                        <span className="text-[11px] text-[#64748b]">In Transit</span>
                        <Truck className="w-4 h-4" />
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{poData.inTransitCount}</p>
                    </div>
                  </div>

                  {/* Search Bar */}
                  <div className="bg-[#f1f5f9] px-3.5 py-2.5 rounded-2xl border border-[#e2e8f0] flex items-center gap-2 text-xs">
                    <Search className="w-4 h-4 text-[#64748b]" />
                    <input
                      type="text"
                      placeholder="Search PO#, Supplier, Product..."
                      className="bg-transparent border-none outline-none w-full text-[#1e2923]"
                    />
                  </div>

                  {/* Filter Chips Row */}
                  <div className="flex gap-2 text-xs overflow-x-auto no-scrollbar">
                    {['All', 'Draft', 'Pending', 'Approved', 'Shipped'].map((f) => (
                      <button
                        key={f}
                        onClick={() => setPoFilter(f)}
                        className={`px-4 py-1.5 rounded-full font-bold transition shrink-0 ${
                          poFilter === f
                            ? 'bg-[#006837] text-white shadow-sm'
                            : 'bg-white text-[#64748b] border border-[#e2e8f0]'
                        }`}
                      >
                        {f}
                      </button>
                    ))}
                  </div>

                  {/* Active Orders List */}
                  <div className="space-y-3">
                    <h4 className="font-black text-sm text-[#1e2923]">Active Orders</h4>

                    {poData.orders.map((po) => (
                      <div key={po.id} className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                        <div className="flex justify-between items-center">
                          <div className="flex items-center gap-2">
                            <span className="font-black text-base text-[#1e2923]">{po.id}</span>
                            <span className={`px-2 py-0.5 text-[10px] font-bold rounded-md ${po.statusBg}`}>
                              {po.status}
                            </span>
                          </div>
                          <span className="font-black text-lg text-[#006837]">{po.amount}</span>
                        </div>

                        <p className="text-xs text-[#64748b]">{po.supplier}</p>
                        <p className="text-[11px] text-[#64748b] flex items-center gap-1">
                          <Calendar className="w-3.5 h-3.5" /> Expected: {po.expectedDate}
                        </p>

                        <div className="w-full h-1.5 bg-[#f1f5f9] rounded-full overflow-hidden">
                          <div className="h-full bg-[#006837]" style={{ width: `${po.progress}%` }} />
                        </div>

                        <div className="flex gap-2 pt-1">
                          <button
                            onClick={() => setActiveModal(po.action1Label)}
                            className="flex-1 py-2.5 border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-2xl flex items-center justify-center gap-1 hover:bg-[#f8fafc]"
                          >
                            <Download className="w-3.5 h-3.5" /> {po.action1Label}
                          </button>
                          <button
                            onClick={() => setActiveModal(po.action2Label)}
                            className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-2xl flex items-center justify-center gap-1 hover:bg-[#00522b]"
                          >
                            <CheckCircle2 className="w-3.5 h-3.5" /> {po.action2Label}
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Floating Action Button */}
                  <button
                    onClick={() => setActiveModal('New PO')}
                    className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
                  >
                    <Plus className="w-6 h-6" />
                  </button>
                </>
              )}
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              {activeTab === 'suppliers' ? (
                <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#006837] text-white rounded-2xl"><Store className="w-4 h-4" /> Suppliers</div>
              ) : (
                <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#006837] text-white rounded-2xl"><ShoppingCart className="w-4 h-4" /> Purchase</div>
              )}
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="space-y-6">
          {activeTab === 'suppliers' ? (
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              {/* Left Column (Span 7) */}
              <div className="lg:col-span-7 space-y-6">
                {/* Top Metrics Cards */}
                <div className="grid grid-cols-3 gap-4">
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                    <p className="text-xs text-[#64748b]">Total Suppliers</p>
                    <p className="text-3xl font-black text-[#1e2923]">{suppliersData.totalSuppliers}</p>
                  </div>
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                    <p className="text-xs text-[#64748b]">Active</p>
                    <p className="text-3xl font-black text-[#15803d]">{suppliersData.activeCount}</p>
                  </div>
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                    <p className="text-xs text-[#64748b]">Pending</p>
                    <p className="text-3xl font-black text-[#c2410c]">{suppliersData.pendingCount}</p>
                  </div>
                </div>

                {/* Directory List */}
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                  <h3 className="font-black text-lg text-[#1e2923]">Supplier Directory</h3>

                  <div className="space-y-3">
                    {suppliersData.suppliers.map((sup) => (
                      <div
                        key={sup.id}
                        className={`p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] border-l-4 ${sup.accent} flex items-center justify-between`}
                      >
                        <div className="flex items-center gap-3">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img src={sup.logo} alt={sup.name} className="w-12 h-12 rounded-2xl object-cover" />
                          <div>
                            <p className="font-bold text-sm text-[#1e2923]">{sup.name}</p>
                            <p className="text-xs text-[#64748b]">Last Delivery: {sup.lastDelivery}</p>
                          </div>
                        </div>

                        <div className="text-right">
                          <span className={`px-3 py-1 text-xs font-bold rounded-full ${sup.statusBg}`}>
                            {sup.status}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* Right Column (Span 5) */}
              <div className="lg:col-span-5 space-y-6">
                {/* Smart Insights */}
                <div className="bg-[#e6f4ea] p-6 rounded-3xl border border-[#a7f3d0] space-y-4">
                  <div className="flex items-center gap-2">
                    <Sparkles className="w-5 h-5 text-[#006837]" />
                    <h3 className="font-black text-base text-[#006837]">Smart Insights</h3>
                  </div>

                  <div className="bg-white p-5 rounded-2xl border border-[#e2e8f0] space-y-3">
                    <span className="text-xs font-bold text-[#64748b] tracking-wider uppercase">
                      TOP PERFORMING CATEGORY
                    </span>
                    <p className="text-xl font-black text-[#1e2923]">Fresh Produce</p>
                    <p className="text-xs font-bold text-[#15803d]">📉 2.4% cost reduction</p>
                    <p className="text-xs text-[#334155] leading-relaxed">
                      Consider consolidating dairy orders with <span className="font-bold">Heritage Dairy</span> to unlock volume discounts.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            /* Web Purchase Orders */
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              <div className="lg:col-span-12 space-y-6">
                <div className="bg-[#f0f7ff] p-6 rounded-3xl border border-[#dce6fe] flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <Sparkles className="w-6 h-6 text-[#006837]" />
                    <div>
                      <h3 className="font-bold text-sm text-[#1e2923]">AI Purchase Insight</h3>
                      <p className="text-xs text-[#334155] mt-0.5">{poData.aiPurchaseInsight}</p>
                    </div>
                  </div>
                </div>

                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                  <h3 className="font-black text-lg text-[#1e2923]">Active Purchase Orders</h3>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {poData.orders.map((po) => (
                      <div key={po.id} className="p-5 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] space-y-3">
                        <div className="flex justify-between items-center">
                          <span className="font-black text-lg text-[#1e2923]">{po.id}</span>
                          <span className="font-black text-xl text-[#006837]">{po.amount}</span>
                        </div>
                        <p className="text-xs text-[#64748b]">{po.supplier}</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Action Modals */}
      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal} Modal</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for supplier ecosystem.</p>
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
