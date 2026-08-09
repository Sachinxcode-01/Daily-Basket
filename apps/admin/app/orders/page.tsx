'use client';

import React, { useState } from 'react';
import {
  Search,
  Mic,
  Bell,
  ArrowLeft,
  Flame,
  Phone,
  Clock,
  CheckCircle2,
  Printer,
  Plus,
  Grid,
  ShoppingBag,
  Package,
  BarChart3,
  User,
  TrendingUp,
  SlidersHorizontal,
  Smartphone,
  LayoutGrid,
  Table as TableIcon
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Orders Management Dashboard (ID: 1a0e4c0c22d9478697693d8a728bfc22)

const INITIAL_ORDERS = [
  {
    id: '#DB-9842',
    customer: 'Rahul Sharma',
    address: '12, Green Park Avenue, Block C, HSR',
    phone: '+91 98765 43210',
    avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    amount: '₹1,240',
    isPriority: true,
    statusStep: 1, // 0: New, 1: Accept, 2: Pack, 3: Assign, 4: Done
    time: '10:24 AM (5m ago)',
    paymentMethod: 'Paid via UPI',
    items: ['Organic Avocados x4', 'Aashirvaad Atta 5kg', 'Amul Butter 500g'],
  },
  {
    id: '#DB-9840',
    customer: 'Priya Desai',
    address: 'Sector 4, HSR Layout, Bengaluru',
    phone: '+91 98765 12345',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    amount: '₹450',
    isPriority: false,
    statusStep: 2,
    time: '09:45 AM (44m ago)',
    paymentMethod: 'Paid via Card',
    items: ['Fresh Paneer 200g', 'Free-range Eggs 6pk'],
  },
  {
    id: '#DB-9838',
    customer: 'Ananya R.',
    address: '102, Sun City Apts, Sarjapur Road',
    phone: '+91 91234 56789',
    avatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    amount: '₹890',
    isPriority: true,
    statusStep: 0,
    time: '10:28 AM (1m ago)',
    paymentMethod: 'Paid via Wallet',
    items: ['Greek Yogurt 400g', 'Cold Pressed Juice 1L', 'Blueberries 125g'],
  },
  {
    id: '#DB-9835',
    customer: 'Vikram Malhotra',
    address: '45, Koramangala 5th Block, Bengaluru',
    phone: '+91 99887 76655',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    amount: '₹1,560',
    isPriority: false,
    statusStep: 3,
    time: '09:12 AM (1h ago)',
    paymentMethod: 'Paid via UPI',
    items: ['Basmati Rice 5kg', 'Sunflower Oil 2L', 'Toor Dal 1kg'],
  },
];

const STEP_LABELS = ['New', 'Accept', 'Pack', 'Assign', 'Done'];

export default function OrderManagementPage() {
  const [selectedFilter, setSelectedFilter] = useState('All Orders');
  const [searchQuery, setSearchQuery] = useState('');
  const [viewMode, setViewMode] = useState<'card' | 'table' | 'mobile'>('card');
  const [orders, setOrders] = useState(INITIAL_ORDERS);
  const [selectedOrderForPrint, setSelectedOrderForPrint] = useState<string | null>(null);

  const handleAdvanceStep = (orderId: string) => {
    setOrders((prev) =>
      prev.map((o) => {
        if (o.id === orderId && o.statusStep < 4) {
          return { ...o, statusStep: o.statusStep + 1 };
        }
        return o;
      })
    );
  };

  const filteredOrders = orders.filter((o) => {
    const matchesFilter =
      selectedFilter === 'All Orders' ||
      (selectedFilter === 'New (12)' && o.statusStep === 0) ||
      (selectedFilter === 'Pending' && o.statusStep === 1) ||
      (selectedFilter === 'Packed' && o.statusStep === 2) ||
      (selectedFilter === 'Dispatched' && o.statusStep === 3);

    const query = searchQuery.toLowerCase();
    const matchesQuery =
      !query ||
      o.id.toLowerCase().includes(query) ||
      o.customer.toLowerCase().includes(query) ||
      o.address.toLowerCase().includes(query);

    return matchesFilter && matchesQuery;
  });

  return (
    <div className="space-y-6 max-w-7xl mx-auto font-sans">
      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#1e2923]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl font-black text-[#1e2923] tracking-tight">Orders</h1>
              {/* "● Open" Pill Badge */}
              <span className="inline-flex items-center gap-1.5 px-3 py-1 bg-[#dcfce7] border border-[#86efac] text-[#15803d] rounded-full text-xs font-bold">
                <span className="w-2 h-2 rounded-full bg-[#16a34a] animate-pulse" />
                Open
              </span>
            </div>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 1a0e4c0c22d9478697693d8a728bfc22 • Live Order Management
            </p>
          </div>
        </div>

        {/* View Mode Switches */}
        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('card')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'card' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Cards</span>
          </button>
          <button
            onClick={() => setViewMode('table')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'table' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <TableIcon className="w-3.5 h-3.5" />
            <span>Table</span>
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

      {/* Main Content Area */}
      {viewMode === 'mobile' ? (
        /* Mobile Device Frame View simulating exact phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[820px] bg-[#f4f6f4] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <div className="flex items-center gap-2">
                <ArrowLeft className="w-5 h-5 text-[#1e2923]" />
                <span className="font-extrabold text-lg text-[#1e2923]">Orders</span>
                <span className="inline-flex items-center gap-1 px-2.5 py-0.5 bg-[#dcfce7] border border-[#86efac] text-[#15803d] rounded-full text-[10px] font-bold">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#16a34a]" />
                  Open
                </span>
              </div>
              <div className="flex items-center gap-2">
                <Search className="w-4 h-4 text-[#006837]" />
                <div className="relative">
                  <Bell className="w-4 h-4 text-[#1e2923]" />
                  <span className="w-2 h-2 rounded-full bg-red-600 absolute top-0 right-0" />
                </div>
              </div>
            </div>

            {/* Scrollable Mobile Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              {/* Search Box */}
              <div className="flex items-center gap-2 bg-[#eef2ef] border border-[#e2e8f0] px-3 py-2 rounded-xl">
                <Search className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search Order ID, Customer..."
                  className="bg-transparent text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none flex-1"
                />
                <Mic className="w-4 h-4 text-[#006837]" />
              </div>

              {/* Filter Pills */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                {['All Orders', 'New (12)', 'Pending', 'Packed', 'Dispatched'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedFilter(f)}
                    className={`px-3 py-1.5 rounded-full font-bold whitespace-nowrap transition ${
                      selectedFilter === f
                        ? 'bg-[#006837] text-white'
                        : 'bg-white text-[#334155] border border-[#cbd5e1]'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>

              {/* Stat Cards Row */}
              <div className="flex gap-3 overflow-x-auto pb-1 no-scrollbar">
                <div className="min-w-[140px] bg-[#f4faf6] border border-[#d0e5d7] p-3 rounded-2xl relative">
                  <p className="text-[10px] font-extrabold text-[#475569] uppercase tracking-wider">Today&apos;s Orders</p>
                  <p className="text-2xl font-black text-[#006837] mt-1">142</p>
                  <TrendingUp className="w-5 h-5 text-[#006837] absolute right-3 bottom-3" />
                </div>
                <div className="min-w-[140px] bg-[#fff7ed] border border-[#ffedd5] p-3 rounded-2xl relative">
                  <p className="text-[10px] font-extrabold text-[#c2410c] uppercase tracking-wider">Pending</p>
                  <p className="text-2xl font-black text-[#c2410c] mt-1">24</p>
                  <ShoppingBag className="w-5 h-5 text-[#c2410c] absolute right-3 bottom-3" />
                </div>
              </div>

              {/* Order Cards */}
              {filteredOrders.map((ord) => (
                <div key={ord.id} className="bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <span className="font-extrabold text-sm text-[#1e2923]">{ord.id}</span>
                      {ord.isPriority && (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-[#fee2e2] border border-[#fca5a5] text-[#b91c1c] text-[10px] font-bold rounded-md">
                          <Flame className="w-3 h-3 text-[#b91c1c]" /> Priority
                        </span>
                      )}
                    </div>
                    <span className="font-black text-base text-[#006837]">{ord.amount}</span>
                  </div>

                  {/* Customer Inner Box */}
                  <div className="bg-[#f1f5f9] p-2.5 rounded-xl flex items-center justify-between">
                    <div className="flex items-center gap-2.5">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={ord.avatar} alt={ord.customer} className="w-9 h-9 rounded-full object-cover" />
                      <div>
                        <p className="font-bold text-xs text-[#1e2923]">{ord.customer}</p>
                        <p className="text-[10px] text-[#64748b] truncate max-w-[160px]">{ord.address}</p>
                      </div>
                    </div>
                    <button className="w-8 h-8 rounded-full bg-[#e0f2fe] flex items-center justify-center text-[#0284c7]">
                      <Phone className="w-4 h-4" />
                    </button>
                  </div>

                  {/* Stepper Bar */}
                  <div className="space-y-1">
                    <div className="flex items-center justify-between">
                      {STEP_LABELS.map((step, idx) => (
                        <React.Fragment key={step}>
                          <div
                            className={`w-3.5 h-3.5 rounded-full flex items-center justify-center ${
                              idx <= ord.statusStep
                                ? 'bg-[#006837] text-white ring-2 ring-[#86efac]'
                                : 'bg-[#e2e8f0]'
                            }`}
                          />
                          {idx < STEP_LABELS.length - 1 && (
                            <div
                              className={`flex-1 h-1 ${
                                idx < ord.statusStep ? 'bg-[#006837]' : 'bg-[#e2e8f0]'
                              }`}
                            />
                          )}
                        </React.Fragment>
                      ))}
                    </div>
                    <div className="flex justify-between text-[9px] font-bold text-[#64748b]">
                      {STEP_LABELS.map((s, idx) => (
                        <span key={s} className={idx <= ord.statusStep ? 'text-[#006837]' : ''}>
                          {s}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Footer & Action */}
                  <div className="flex items-center justify-between text-[11px] text-[#64748b]">
                    <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {ord.time}</span>
                    <span className="flex items-center gap-1 text-[#006837] font-bold"><CheckCircle2 className="w-3 h-3" /> {ord.paymentMethod}</span>
                  </div>

                  <div className="flex gap-2 pt-1">
                    <button
                      onClick={() => handleAdvanceStep(ord.id)}
                      className="flex-1 py-2 bg-[#006837] text-white text-xs font-bold rounded-xl hover:bg-[#00522b] transition"
                    >
                      {ord.statusStep === 0 && 'Accept Order'}
                      {ord.statusStep === 1 && 'Mark as Packed'}
                      {ord.statusStep === 2 && 'Assign Delivery'}
                      {ord.statusStep === 3 && 'Mark Delivered'}
                      {ord.statusStep === 4 && 'Completed'}
                    </button>
                    <button
                      onClick={() => setSelectedOrderForPrint(ord.id)}
                      className="p-2 border border-[#cbd5e1] rounded-xl hover:bg-[#f8fafc] text-[#1e2923]"
                    >
                      <Printer className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Home</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dcfce7] text-[#006837] rounded-2xl"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
              <div className="flex flex-col items-center gap-0.5"><User className="w-4 h-4" /> Profile</div>
            </div>

            {/* Floating Action Button */}
            <button className="absolute right-6 bottom-16 w-11 h-11 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:scale-105 transition">
              <Plus className="w-6 h-6" />
            </button>
          </div>
        </div>
      ) : viewMode === 'card' ? (
        /* Web Grid/Card View */
        <>
          {/* Controls & Filter Bar */}
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="relative flex-1 w-full max-w-lg">
              <Search className="w-4 h-4 text-[#64748b] absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search Order ID, Customer, or Address..."
                className="w-full pl-10 pr-10 py-2.5 bg-[#eef2ef] border border-[#e2e8f0] rounded-2xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
              />
              <Mic className="w-4 h-4 text-[#006837] absolute right-3.5 top-1/2 -translate-y-1/2 cursor-pointer" />
            </div>

            {/* Filter Pills */}
            <div className="flex gap-2 overflow-x-auto w-full md:w-auto pb-1 no-scrollbar text-xs">
              {['All Orders', 'New (12)', 'Pending', 'Packed', 'Dispatched'].map((f) => (
                <button
                  key={f}
                  onClick={() => setSelectedFilter(f)}
                  className={`px-4 py-2 rounded-full font-bold whitespace-nowrap transition ${
                    selectedFilter === f
                      ? 'bg-[#006837] text-white shadow-sm'
                      : 'bg-white text-[#334155] border border-[#cbd5e1] hover:bg-[#f8fafc]'
                  }`}
                >
                  {f}
                </button>
              ))}
            </div>
          </div>

          {/* Summary Stat Cards Strip */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-[#f4faf6] border border-[#d0e5d7] p-4 rounded-3xl relative shadow-sm">
              <p className="text-xs font-extrabold text-[#475569] uppercase tracking-wider">Today&apos;s Orders</p>
              <p className="text-3xl font-black text-[#006837] mt-1">142</p>
              <TrendingUp className="w-6 h-6 text-[#006837] absolute right-4 bottom-4" />
            </div>

            <div className="bg-[#fff7ed] border border-[#ffedd5] p-4 rounded-3xl relative shadow-sm">
              <p className="text-xs font-extrabold text-[#c2410c] uppercase tracking-wider">Pending</p>
              <p className="text-3xl font-black text-[#c2410c] mt-1">24</p>
              <ShoppingBag className="w-6 h-6 text-[#c2410c] absolute right-4 bottom-4" />
            </div>

            <div className="bg-[#f0f9ff] border border-[#bae6fd] p-4 rounded-3xl relative shadow-sm">
              <p className="text-xs font-extrabold text-[#0369a1] uppercase tracking-wider">Packed</p>
              <p className="text-3xl font-black text-[#0284c7] mt-1">18</p>
              <Package className="w-6 h-6 text-[#0284c7] absolute right-4 bottom-4" />
            </div>

            <div className="bg-[#f0fdf4] border border-[#bbf7d0] p-4 rounded-3xl relative shadow-sm">
              <p className="text-xs font-extrabold text-[#15803d] uppercase tracking-wider">Delivered Today</p>
              <p className="text-3xl font-black text-[#16a34a] mt-1">100</p>
              <CheckCircle2 className="w-6 h-6 text-[#16a34a] absolute right-4 bottom-4" />
            </div>
          </div>

          {/* Orders Cards Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {filteredOrders.map((ord) => (
              <div
                key={ord.id}
                className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm hover:shadow-md transition space-y-4"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span className="font-extrabold text-base text-[#1e2923]">{ord.id}</span>
                    {ord.isPriority && (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-[#fee2e2] border border-[#fca5a5] text-[#b91c1c] text-xs font-bold rounded-lg">
                        <Flame className="w-3.5 h-3.5 text-[#b91c1c]" /> Priority
                      </span>
                    )}
                  </div>
                  <span className="font-black text-xl text-[#006837]">{ord.amount}</span>
                </div>

                {/* Customer Box */}
                <div className="bg-[#f1f5f9] p-3 rounded-2xl flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src={ord.avatar} alt={ord.customer} className="w-10 h-10 rounded-full object-cover" />
                    <div>
                      <p className="font-bold text-sm text-[#1e2923]">{ord.customer}</p>
                      <p className="text-xs text-[#64748b]">{ord.address}</p>
                    </div>
                  </div>
                  <button className="w-9 h-9 rounded-full bg-[#e0f2fe] flex items-center justify-center text-[#0284c7] hover:bg-[#bae6fd] transition">
                    <Phone className="w-4 h-4" />
                  </button>
                </div>

                {/* Stepper Timeline */}
                <div className="space-y-1.5 pt-1">
                  <div className="flex items-center justify-between">
                    {STEP_LABELS.map((step, idx) => (
                      <React.Fragment key={step}>
                        <div
                          className={`w-4 h-4 rounded-full flex items-center justify-center ${
                            idx <= ord.statusStep
                              ? 'bg-[#006837] text-white ring-4 ring-[#86efac]/40'
                              : 'bg-[#e2e8f0]'
                          }`}
                        />
                        {idx < STEP_LABELS.length - 1 && (
                          <div
                            className={`flex-1 h-1 ${
                              idx < ord.statusStep ? 'bg-[#006837]' : 'bg-[#e2e8f0]'
                            }`}
                          />
                        )}
                      </React.Fragment>
                    ))}
                  </div>
                  <div className="flex justify-between text-xs font-bold text-[#64748b]">
                    {STEP_LABELS.map((s, idx) => (
                      <span key={s} className={idx <= ord.statusStep ? 'text-[#006837]' : ''}>
                        {s}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Meta details */}
                <div className="flex items-center justify-between text-xs text-[#64748b]">
                  <span className="flex items-center gap-1.5"><Clock className="w-3.5 h-3.5" /> {ord.time}</span>
                  <span className="flex items-center gap-1.5 text-[#006837] font-bold"><CheckCircle2 className="w-3.5 h-3.5" /> {ord.paymentMethod}</span>
                </div>

                {/* Actions */}
                <div className="flex gap-3 pt-1">
                  <button
                    onClick={() => handleAdvanceStep(ord.id)}
                    className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-xl hover:bg-[#00522b] transition shadow-sm"
                  >
                    {ord.statusStep === 0 && 'Accept Order'}
                    {ord.statusStep === 1 && 'Mark as Packed'}
                    {ord.statusStep === 2 && 'Assign Delivery Rider'}
                    {ord.statusStep === 3 && 'Mark as Delivered'}
                    {ord.statusStep === 4 && 'Completed'}
                  </button>
                  <button
                    onClick={() => setSelectedOrderForPrint(ord.id)}
                    className="p-2.5 border border-[#cbd5e1] rounded-xl hover:bg-[#f8fafc] text-[#1e2923] transition"
                  >
                    <Printer className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </>
      ) : (
        /* Table View */
        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e8f0] space-y-4">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-[#e2e8f0] text-[#64748b] uppercase font-bold tracking-wider">
                  <th className="pb-3">Order ID</th>
                  <th className="pb-3">Customer</th>
                  <th className="pb-3">Address</th>
                  <th className="pb-3">Amount</th>
                  <th className="pb-3">Status</th>
                  <th className="pb-3">Payment</th>
                  <th className="pb-3">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#e2e8f0]">
                {filteredOrders.map((ord) => (
                  <tr key={ord.id} className="hover:bg-[#f8fafc] transition">
                    <td className="py-3.5 font-bold text-[#006837]">{ord.id}</td>
                    <td className="py-3.5 font-bold text-[#1e2923]">{ord.customer}</td>
                    <td className="py-3.5 text-[#64748b]">{ord.address}</td>
                    <td className="py-3.5 font-black text-[#1e2923]">{ord.amount}</td>
                    <td className="py-3.5">
                      <span className="px-2.5 py-1 bg-[#dcfce7] text-[#15803d] rounded-full font-bold text-[10px]">
                        {STEP_LABELS[ord.statusStep]}
                      </span>
                    </td>
                    <td className="py-3.5 text-[#64748b]">{ord.paymentMethod}</td>
                    <td className="py-3.5">
                      <button
                        onClick={() => handleAdvanceStep(ord.id)}
                        className="px-3 py-1.5 bg-[#006837] text-white rounded-xl text-xs font-bold hover:bg-[#00522b]"
                      >
                        Advance Step
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Thermal Print Modal */}
      {selectedOrderForPrint && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full space-y-4 shadow-2xl text-center">
            <Printer className="w-12 h-12 text-[#006837] mx-auto" />
            <h3 className="text-lg font-extrabold text-[#1e2923]">Print Invoice {selectedOrderForPrint}</h3>
            <p className="text-xs text-[#64748b]">
              Sending receipt print command to thermal dark store printer over local network...
            </p>
            <button
              onClick={() => setSelectedOrderForPrint(null)}
              className="w-full py-2.5 bg-[#006837] text-white rounded-xl font-bold text-xs"
            >
              Done
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

