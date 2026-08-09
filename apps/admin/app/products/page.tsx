'use client';

import React, { useState } from 'react';
import {
  Menu,
  Bell,
  Bot,
  Search,
  QrCode,
  Mic,
  Edit,
  Package,
  Tag,
  ShoppingCart,
  Plus,
  Grid,
  ShoppingBag,
  BarChart3,
  User,
  AlertTriangle,
  Leaf,
  Smartphone,
  LayoutGrid,
  Table as TableIcon,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Product Management Dashboard (ID: 7f4ce4c9d581414bbd9ee1df7768f876)

const INITIAL_PRODUCTS = [
  {
    id: 'FR-BAN-001',
    brand: 'FRESH FARMS',
    name: 'Organic Bananas (Robusta)',
    sku: 'SKU: FR-BAN-001',
    category: 'Fruits',
    price: '$1.99',
    originalPrice: '$2.35',
    discount: '-15%',
    margin: 'Margin: 42%',
    stockAvailable: 345,
    reserved: 12,
    stockBadge: 'Good',
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300',
  },
  {
    id: 'DY-MLK-042',
    brand: 'VALLEY DAIRY',
    name: 'Whole Milk (1L Glass)',
    sku: 'SKU: DY-MLK-042',
    category: 'Dairy',
    price: '$4.50',
    originalPrice: '$4.50',
    discount: null,
    margin: 'Margin: 28%',
    stockAvailable: 14,
    reserved: 4,
    stockBadge: 'Alert',
    isLowStock: true,
    image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300',
  },
  {
    id: 'BD-SD-003',
    brand: 'ARTISAN BAKERY',
    name: 'Sourdough Loaf (Whole Grain)',
    sku: 'SKU: BD-SD-003',
    category: 'Bakery',
    price: '$5.99',
    originalPrice: '$6.99',
    discount: '-14%',
    margin: 'Margin: 38%',
    stockAvailable: 88,
    reserved: 6,
    stockBadge: 'Good',
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300',
  },
  {
    id: 'BEV-JUC-012',
    brand: 'TROPICAL SUN',
    name: 'Cold Pressed Orange Juice 1L',
    sku: 'SKU: BEV-JUC-012',
    category: 'Beverages',
    price: '$3.75',
    originalPrice: '$4.20',
    discount: '-10%',
    margin: 'Margin: 35%',
    stockAvailable: 120,
    reserved: 8,
    stockBadge: 'Good',
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300',
  },
];

export default function ProductsManagementPage() {
  const [selectedStatusFilter, setSelectedStatusFilter] = useState('All Products');
  const [selectedCategoryFilter, setSelectedCategoryFilter] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [viewMode, setViewMode] = useState<'card' | 'table' | 'mobile'>('card');
  const [products] = useState(INITIAL_PRODUCTS);

  const filteredProducts = products.filter((p) => {
    const matchesStatus =
      selectedStatusFilter === 'All Products' ||
      (selectedStatusFilter === 'Low Stock' && p.isLowStock) ||
      (selectedStatusFilter === 'Published' && !p.isLowStock);

    const matchesCategory =
      selectedCategoryFilter === 'All' ||
      p.category.toLowerCase() === selectedCategoryFilter.toLowerCase();

    const query = searchQuery.toLowerCase();
    const matchesQuery =
      !query ||
      p.name.toLowerCase().includes(query) ||
      p.sku.toLowerCase().includes(query) ||
      p.brand.toLowerCase().includes(query);

    return matchesStatus && matchesCategory && matchesQuery;
  });

  return (
    <div className="space-y-6 max-w-7xl mx-auto font-sans">
      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#1e2923]">
            <Menu className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Products</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 7f4ce4c9d581414bbd9ee1df7768f876 • Catalog Management
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
        /* Mobile Device Frame View simulating exact Stitch phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[820px] bg-[#f4f6f4] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <div className="flex items-center gap-2">
                <Menu className="w-5 h-5 text-[#1e2923]" />
                <span className="font-extrabold text-xl text-[#006837]">Products</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="relative">
                  <Bell className="w-4 h-4 text-[#1e2923]" />
                  <span className="w-2 h-2 rounded-full bg-red-600 absolute top-0 right-0" />
                </div>
                <Bot className="w-4 h-4 text-[#1e2923]" />
                <div className="w-7 h-7 rounded-full bg-[#006837]/10 flex items-center justify-center font-bold text-xs text-[#006837]">
                  AR
                </div>
              </div>
            </div>

            {/* Scrollable Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              {/* Stat Cards Strip */}
              <div className="flex gap-3 overflow-x-auto pb-1 no-scrollbar">
                <div className="min-w-[150px] bg-gradient-to-br from-[#22c55e] to-[#15803d] p-3.5 rounded-2xl text-white shadow-sm flex flex-col justify-between">
                  <span className="text-[10px] font-extrabold tracking-wider opacity-90">TOTAL PRODUCTS</span>
                  <p className="text-2xl font-black mt-2">10,100</p>
                </div>

                <div className="min-w-[150px] bg-[#c7d2fe]/60 border border-[#a5b4fc] p-3.5 rounded-2xl shadow-sm flex flex-col justify-between">
                  <span className="text-[10px] font-extrabold text-[#475569] tracking-wider">PUBLISHED</span>
                  <p className="text-2xl font-black text-[#047857] mt-2">8,306</p>
                </div>
              </div>

              {/* Search Box */}
              <div className="flex items-center gap-2 bg-white border border-[#cbd5e1] px-3 py-2 rounded-xl">
                <Search className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search by name, SKU, barco..."
                  className="bg-transparent text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none flex-1"
                />
                <QrCode className="w-4 h-4 text-[#1e2923]" />
                <Mic className="w-4 h-4 text-[#006837]" />
              </div>

              {/* Filter Pills Row 1: Status */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                {['All Products', 'Published', 'Draft', 'Low Stock'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedStatusFilter(f)}
                    className={`px-4 py-1.5 rounded-full font-bold whitespace-nowrap transition ${
                      selectedStatusFilter === f
                        ? 'bg-[#006837] text-white'
                        : 'bg-white text-[#334155] border border-[#cbd5e1]'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>

              {/* Filter Pills Row 2: Categories */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                {['All', 'Fruits', 'Vegetables', 'Dairy', 'Snacks', 'Beverages'].map((c) => (
                  <button
                    key={c}
                    onClick={() => setSelectedCategoryFilter(c)}
                    className={`px-3 py-1 rounded-xl font-medium whitespace-nowrap transition ${
                      selectedCategoryFilter === c
                        ? 'bg-[#e2e8f0] text-[#1e2923] font-bold'
                        : 'bg-[#f1f5f9] text-[#64748b]'
                    }`}
                  >
                    {c}
                  </button>
                ))}
              </div>

              {/* Product Cards */}
              {filteredProducts.map((p) => (
                <div key={p.id} className="bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-3">
                  <div className="flex gap-3">
                    <div className="relative">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={p.image} alt={p.name} className="w-16 h-16 rounded-xl object-cover" />
                      <div className="absolute top-1 left-1 bg-white p-0.5 rounded-full shadow-sm">
                        <Leaf className="w-3 h-3 text-[#006837]" />
                      </div>
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between">
                        <span className="text-[10px] font-bold text-[#64748b] tracking-wide">{p.brand}</span>
                        {p.isLowStock && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-[#fee2e2] text-[#b91c1c] text-[10px] font-bold">
                            <AlertTriangle className="w-3 h-3" /> Low Stock
                          </span>
                        )}
                      </div>
                      <h4 className="font-extrabold text-sm text-[#1e2923] truncate mt-0.5">{p.name}</h4>
                      <div className="flex items-center gap-2 mt-1">
                        <span className="px-1.5 py-0.5 bg-[#f1f5f9] text-[10px] font-mono font-bold text-[#1e2923] rounded">
                          {p.sku}
                        </span>
                        <span className="text-[11px] text-[#64748b]">| {p.category}</span>
                      </div>
                    </div>
                  </div>

                  {/* Pricing & Stock Details Grid */}
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl flex items-center justify-between text-xs">
                    <div>
                      <div className="flex items-center gap-1.5">
                        <span className="text-[#64748b] text-[11px]">Price</span>
                        {p.discount && (
                          <span className="px-1.5 py-0.2 rounded bg-[#dcfce7] text-[#15803d] text-[9px] font-bold">
                            {p.discount}
                          </span>
                        )}
                      </div>
                      <div className="flex items-baseline gap-1 mt-0.5">
                        <span className="font-black text-base text-[#1e2923]">{p.price}</span>
                        {p.discount && (
                          <span className="text-[10px] text-[#94a3b8] line-through">{p.originalPrice}</span>
                        )}
                      </div>
                      <p className="text-[10px] font-bold text-[#15803d] mt-0.5">{p.margin}</p>
                    </div>

                    <div className="w-[1px] h-9 bg-[#e2e8f0]" />

                    <div>
                      <div className="flex items-center gap-1.5">
                        <span className="text-[#64748b] text-[11px]">Stock (Units)</span>
                        <span
                          className={`px-1.5 py-0.2 rounded text-[9px] font-bold ${
                            p.isLowStock ? 'bg-[#ffedd5] text-[#c2410c]' : 'bg-[#dcfce7] text-[#15803d]'
                          }`}
                        >
                          {p.stockBadge}
                        </span>
                      </div>
                      <p className="font-black text-base mt-0.5 text-[#1e2923]">
                        <span className={p.isLowStock ? 'text-[#c2410c]' : 'text-[#1e2923]'}>
                          {p.stockAvailable}
                        </span>{' '}
                        <span className="text-[10px] font-normal text-[#64748b]">Available</span>
                      </p>
                      <p className="text-[10px] text-[#64748b] mt-0.5">Reserved: {p.reserved}</p>
                    </div>
                  </div>

                  {/* Actions Row */}
                  <div className="flex gap-2 pt-1">
                    {p.isLowStock ? (
                      <>
                        <button className="flex-1 py-1.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 hover:bg-[#f8fafc]">
                          <Edit className="w-3.5 h-3.5" /> Edit
                        </button>
                        <button className="flex-1 py-1.5 bg-[#006837] text-white text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 shadow-sm hover:bg-[#00522b]">
                          <ShoppingCart className="w-3.5 h-3.5" /> Restock
                        </button>
                      </>
                    ) : (
                      <>
                        <button className="flex-1 py-1.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-1 hover:bg-[#f8fafc]">
                          <Edit className="w-3.5 h-3.5" /> Edit
                        </button>
                        <button className="flex-1 py-1.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-1 hover:bg-[#f8fafc]">
                          <Package className="w-3.5 h-3.5" /> Stock
                        </button>
                        <button className="flex-1 py-1.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-1 hover:bg-[#f8fafc]">
                          <Tag className="w-3.5 h-3.5" /> Price
                        </button>
                      </>
                    )}
                  </div>
                </div>
              ))}
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dce6fe] text-[#1e2923] rounded-2xl"><Tag className="w-4 h-4 text-[#006837]" /> Products</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
            </div>

            {/* Floating Action Button */}
            <button className="absolute right-6 bottom-16 w-11 h-11 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:scale-105 transition">
              <Plus className="w-6 h-6" />
            </button>
          </div>
        </div>
      ) : viewMode === 'card' ? (
        /* Web Grid / Card View */
        <>
          {/* Summary Stat Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div className="bg-gradient-to-br from-[#22c55e] to-[#15803d] p-6 rounded-3xl text-white shadow-sm flex items-center justify-between">
              <div>
                <span className="text-xs font-extrabold uppercase tracking-wider opacity-90">TOTAL PRODUCTS</span>
                <p className="text-4xl font-black mt-2">10,100</p>
              </div>
              <div className="p-4 bg-white/10 rounded-2xl">
                <Tag className="w-10 h-10 text-white" />
              </div>
            </div>

            <div className="bg-[#c7d2fe]/60 border border-[#a5b4fc] p-6 rounded-3xl shadow-sm flex items-center justify-between">
              <div>
                <span className="text-xs font-extrabold text-[#475569] uppercase tracking-wider">PUBLISHED</span>
                <p className="text-4xl font-black text-[#047857] mt-2">8,306</p>
              </div>
              <div className="p-4 bg-white/50 rounded-2xl text-[#047857]">
                <Package className="w-10 h-10" />
              </div>
            </div>
          </div>

          {/* Search Bar & Filters */}
          <div className="space-y-4">
            <div className="flex flex-col md:flex-row items-center justify-between gap-4">
              <div className="relative flex-1 w-full max-w-lg">
                <Search className="w-4 h-4 text-[#64748b] absolute left-3.5 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search by name, SKU, barcode..."
                  className="w-full pl-10 pr-10 py-2.5 bg-white border border-[#cbd5e1] rounded-2xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
                <Mic className="w-4 h-4 text-[#006837] absolute right-3.5 top-1/2 -translate-y-1/2 cursor-pointer" />
              </div>

              {/* Status Filters */}
              <div className="flex gap-2 overflow-x-auto w-full md:w-auto pb-1 no-scrollbar text-xs">
                {['All Products', 'Published', 'Draft', 'Low Stock'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedStatusFilter(f)}
                    className={`px-4 py-2 rounded-full font-bold whitespace-nowrap transition ${
                      selectedStatusFilter === f
                        ? 'bg-[#006837] text-white shadow-sm'
                        : 'bg-white text-[#334155] border border-[#cbd5e1] hover:bg-[#f8fafc]'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>
            </div>

            {/* Category Filters */}
            <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
              {['All', 'Fruits', 'Vegetables', 'Dairy', 'Snacks', 'Beverages'].map((c) => (
                <button
                  key={c}
                  onClick={() => setSelectedCategoryFilter(c)}
                  className={`px-4 py-1.5 rounded-xl font-medium whitespace-nowrap transition ${
                    selectedCategoryFilter === c
                      ? 'bg-[#e2e8f0] text-[#1e2923] font-bold'
                      : 'bg-[#f1f5f9] text-[#64748b] hover:bg-[#e2e8f0]'
                  }`}
                >
                  {c}
                </button>
              ))}
            </div>
          </div>

          {/* Product Cards Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {filteredProducts.map((p) => (
              <div key={p.id} className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                <div className="flex gap-4">
                  <div className="relative">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src={p.image} alt={p.name} className="w-20 h-20 rounded-2xl object-cover" />
                    <div className="absolute top-1 left-1 bg-white p-1 rounded-full shadow-sm">
                      <Leaf className="w-3.5 h-3.5 text-[#006837]" />
                    </div>
                  </div>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-bold text-[#64748b] tracking-wide">{p.brand}</span>
                      {p.isLowStock && (
                        <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-[#fee2e2] text-[#b91c1c] text-xs font-bold">
                          <AlertTriangle className="w-3.5 h-3.5" /> Low Stock
                        </span>
                      )}
                    </div>
                    <h3 className="font-extrabold text-base text-[#1e2923] truncate mt-1">{p.name}</h3>
                    <div className="flex items-center gap-2 mt-1.5">
                      <span className="px-2 py-0.5 bg-[#f1f5f9] text-xs font-mono font-bold text-[#1e2923] rounded-md">
                        {p.sku}
                      </span>
                      <span className="text-xs text-[#64748b]">| {p.category}</span>
                    </div>
                  </div>
                </div>

                {/* Details Breakdown */}
                <div className="bg-[#f8fafc] p-4 rounded-2xl flex items-center justify-between text-xs">
                  <div>
                    <div className="flex items-center gap-1.5">
                      <span className="text-[#64748b]">Price</span>
                      {p.discount && (
                        <span className="px-2 py-0.5 rounded bg-[#dcfce7] text-[#15803d] text-[10px] font-bold">
                          {p.discount}
                        </span>
                      )}
                    </div>
                    <div className="flex items-baseline gap-2 mt-1">
                      <span className="font-black text-xl text-[#1e2923]">{p.price}</span>
                      {p.discount && (
                        <span className="text-xs text-[#94a3b8] line-through">{p.originalPrice}</span>
                      )}
                    </div>
                    <p className="text-xs font-bold text-[#15803d] mt-1">{p.margin}</p>
                  </div>

                  <div className="w-[1px] h-12 bg-[#e2e8f0]" />

                  <div>
                    <div className="flex items-center gap-1.5">
                      <span className="text-[#64748b]">Stock (Units)</span>
                      <span
                        className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                          p.isLowStock ? 'bg-[#ffedd5] text-[#c2410c]' : 'bg-[#dcfce7] text-[#15803d]'
                        }`}
                      >
                        {p.stockBadge}
                      </span>
                    </div>
                    <p className="font-black text-xl mt-1 text-[#1e2923]">
                      <span className={p.isLowStock ? 'text-[#c2410c]' : 'text-[#1e2923]'}>
                        {p.stockAvailable}
                      </span>{' '}
                      <span className="text-xs font-normal text-[#64748b]">Available</span>
                    </p>
                    <p className="text-xs text-[#64748b] mt-1">Reserved: {p.reserved}</p>
                  </div>
                </div>

                {/* Action Buttons */}
                <div className="flex gap-3 pt-1">
                  {p.isLowStock ? (
                    <>
                      <button className="flex-1 py-2.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-2 hover:bg-[#f8fafc]">
                        <Edit className="w-4 h-4" /> Edit
                      </button>
                      <button className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-xl flex items-center justify-center gap-2 shadow-sm hover:bg-[#00522b]">
                        <ShoppingCart className="w-4 h-4" /> Restock
                      </button>
                    </>
                  ) : (
                    <>
                      <button className="flex-1 py-2.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-2 hover:bg-[#f8fafc]">
                        <Edit className="w-4 h-4" /> Edit
                      </button>
                      <button className="flex-1 py-2.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-2 hover:bg-[#f8fafc]">
                        <Package className="w-4 h-4" /> Stock
                      </button>
                      <button className="flex-1 py-2.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-2 hover:bg-[#f8fafc]">
                        <Tag className="w-4 h-4" /> Price
                      </button>
                    </>
                  )}
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
                  <th className="pb-3">SKU</th>
                  <th className="pb-3">Brand & Product Name</th>
                  <th className="pb-3">Category</th>
                  <th className="pb-3">Price / Discount</th>
                  <th className="pb-3">Margin</th>
                  <th className="pb-3">Stock Units</th>
                  <th className="pb-3">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#e2e8f0]">
                {filteredProducts.map((p) => (
                  <tr key={p.id} className="hover:bg-[#f8fafc] transition">
                    <td className="py-3.5 font-bold font-mono text-[#006837]">{p.sku}</td>
                    <td className="py-3.5 font-bold text-[#1e2923]">
                      <div>{p.name}</div>
                      <div className="text-[10px] text-[#64748b] uppercase">{p.brand}</div>
                    </td>
                    <td className="py-3.5 text-[#64748b]">{p.category}</td>
                    <td className="py-3.5 font-black text-[#1e2923]">{p.price}</td>
                    <td className="py-3.5 font-bold text-[#15803d]">{p.margin}</td>
                    <td className="py-3.5 font-mono font-bold text-[#1e2923]">{p.stockAvailable} units</td>
                    <td className="py-3.5">
                      <button
                        className={`px-3 py-1.5 text-white rounded-xl text-xs font-bold ${
                          p.isLowStock ? 'bg-[#b91c1c]' : 'bg-[#006837]'
                        }`}
                      >
                        {p.isLowStock ? 'Restock' : 'Edit'}
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
