'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Share2,
  MoreVertical,
  CheckCircle2,
  Heart,
  Scale,
  QrCode,
  Scan,
  TrendingUp,
  Info,
  Sparkles,
  Eye,
  ShoppingBag,
  Percent,
  Edit,
  Package,
  Grid,
  BarChart3,
  Smartphone,
  LayoutGrid,
  DollarSign,
  Store,
  Tag,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Product Details & Edit (ID: e49ff5c6bb04452f9b966a260519ece8)

export default function ProductDetailsPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [isDescriptionExpanded, setIsDescriptionExpanded] = useState(false);
  const [stockCount, setStockCount] = useState(124);
  const [isUpdateStockOpen, setIsUpdateStockOpen] = useState(false);
  const [newStockInput, setNewStockInput] = useState('124');

  const handleUpdateStock = () => {
    const parsed = parseInt(newStockInput, 10);
    if (!isNaN(parsed)) {
      setStockCount(parsed);
      setIsUpdateStockOpen(false);
    }
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
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Product Details</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: e49ff5c6bb04452f9b966a260519ece8 • Real-time Catalog & Stock Sync
            </p>
          </div>
        </div>

        {/* View Mode Switches */}
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
        /* Mobile Device Frame View simulating exact phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#006837] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Product Details</span>
              <div className="flex items-center gap-2">
                <Share2 className="w-4 h-4 text-[#1e2923]" />
                <MoreVertical className="w-4 h-4 text-[#1e2923]" />
              </div>
            </div>

            {/* Scrollable Body */}
            <div className="flex-1 overflow-y-auto space-y-4 pb-4">
              {/* Hero Image Banner Carousel */}
              <div className="relative w-full h-56 bg-slate-100">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src="https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800"
                  alt="Organic Hass Avocados"
                  className="w-full h-full object-cover"
                />
                {/* Published Badge */}
                <div className="absolute top-3 left-3 bg-[#006837] text-white px-2.5 py-1 rounded-full flex items-center gap-1 text-[11px] font-bold shadow-sm">
                  <CheckCircle2 className="w-3.5 h-3.5" />
                  <span>Published</span>
                </div>
                {/* Saves Badge */}
                <div className="absolute bottom-3 right-3 bg-white/90 backdrop-blur px-2.5 py-1 rounded-full flex items-center gap-1 text-[11px] font-bold text-[#1e2923] shadow-sm">
                  <Heart className="w-3.5 h-3.5 text-pink-500 fill-pink-500" />
                  <span>245 Saves</span>
                </div>
                {/* Carousel Dots */}
                <div className="absolute bottom-3 left-3 flex items-center gap-1">
                  <span className="w-2 h-2 rounded-full bg-[#006837]" />
                  <span className="w-1.5 h-1.5 rounded-full bg-white/70" />
                  <span className="w-1.5 h-1.5 rounded-full bg-white/70" />
                </div>
              </div>

              {/* Header Info */}
              <div className="px-4 space-y-1">
                <span className="text-[10px] font-black text-[#64748b] tracking-wider uppercase">
                  PRODUCE &gt; FRUITS
                </span>
                <h2 className="text-xl font-black text-[#1e2923]">Organic Hass Avocados</h2>
                <p className="text-xs font-bold text-[#006837]">Fresh Farms</p>
                <p className="text-xs text-[#334155] leading-relaxed pt-1">
                  {isDescriptionExpanded
                    ? 'Premium quality organic Hass avocados sourced directly from sustainable farms. Rich, creamy texture perfect for guacamole or toast. Packed with healthy fats, potassium, and essential vitamins.'
                    : 'Premium quality organic Hass avocados sourced directly from sustainable farms. Rich, creamy texture perfect for guacamole or toast...'}
                  <button
                    onClick={() => setIsDescriptionExpanded(!isDescriptionExpanded)}
                    className="text-[#006837] font-bold ml-1 inline-block"
                  >
                    {isDescriptionExpanded ? 'Read Less' : 'Read More'}
                  </button>
                </p>
              </div>

              {/* Spec Cards Strip */}
              <div className="px-4 grid grid-cols-3 gap-2">
                <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                  <Scale className="w-4 h-4 text-[#006837] mx-auto" />
                  <span className="text-[10px] text-[#64748b] block">Weight</span>
                  <span className="font-bold text-xs text-[#1e2923] block">500g</span>
                </div>
                <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                  <QrCode className="w-4 h-4 text-[#006837] mx-auto" />
                  <span className="text-[10px] text-[#64748b] block">SKU</span>
                  <span className="font-bold text-xs text-[#1e2923] font-mono block">AV-ORG-001</span>
                </div>
                <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                  <Scan className="w-4 h-4 text-[#006837] mx-auto" />
                  <span className="text-[10px] text-[#64748b] block">Barcode</span>
                  <span className="font-bold text-xs text-[#1e2923] block">890123...</span>
                </div>
              </div>

              {/* Pricing Card */}
              <div className="mx-4 bg-white p-4 rounded-2xl border border-[#e2e8f0] space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 rounded-lg bg-[#dcfce7] text-[#006837]">
                      <DollarSign className="w-4 h-4" />
                    </div>
                    <span className="font-bold text-sm text-[#1e2923]">Pricing</span>
                  </div>
                  <span className="px-2 py-0.5 bg-[#f1f5f9] text-[10px] font-bold text-[#64748b] rounded-md">
                    Updated 2d ago
                  </span>
                </div>

                <div className="flex items-baseline gap-2">
                  <span className="text-2xl font-black text-[#1e2923]">₹149</span>
                  <span className="text-sm text-[#94a3b8] line-through">₹180</span>
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Margin</span>
                    <span className="font-black text-sm text-[#15803d]">18%</span>
                  </div>
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">GST</span>
                    <span className="font-black text-sm text-[#1e2923]">5%</span>
                  </div>
                </div>
              </div>

              {/* Inventory Card */}
              <div className="mx-4 bg-white p-4 rounded-2xl border border-[#e2e8f0] space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 rounded-lg bg-[#dcfce7] text-[#006837]">
                      <Store className="w-4 h-4" />
                    </div>
                    <span className="font-bold text-sm text-[#1e2923]">Inventory</span>
                  </div>
                  <span className="px-2.5 py-0.5 bg-[#dcfce7] text-[#15803d] text-[10px] font-bold rounded-md flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3" /> In Stock
                  </span>
                </div>

                <div>
                  <span className="text-2xl font-black text-[#006837]">{stockCount}</span>{' '}
                  <span className="text-xs text-[#64748b]">Available</span>
                </div>

                <div className="grid grid-cols-3 gap-2">
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Reserved</span>
                    <span className="font-black text-sm text-[#c2410c]">12</span>
                  </div>
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Min Stock</span>
                    <span className="font-black text-sm text-[#1e2923]">20</span>
                  </div>
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Location</span>
                    <span className="font-black text-sm text-[#15803d]">A1-04</span>
                  </div>
                </div>
              </div>

              {/* AI Insights Card */}
              <div className="mx-4 bg-[#f0fdf4] p-4 rounded-2xl border border-[#dcfce7] space-y-3">
                <div className="flex items-center gap-2">
                  <Sparkles className="w-4 h-4 text-[#006837]" />
                  <span className="font-bold text-sm text-[#1e2923]">AI Insights</span>
                </div>

                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <TrendingUp className="w-4 h-4 text-[#1e2923]" />
                    <div>
                      <span className="text-[10px] text-[#64748b] block">Suggested Price</span>
                      <span className="font-bold text-xs text-[#1e2923]">₹145 - ₹155</span>
                    </div>
                  </div>
                  <div className="w-8 h-8 rounded-full border-2 border-[#006837] bg-white flex items-center justify-center font-bold text-xs text-[#006837]">
                    92
                  </div>
                </div>

                <div className="bg-white p-2.5 rounded-xl flex items-start gap-2 text-xs">
                  <Info className="w-4 h-4 text-[#0284c7] shrink-0 mt-0.5" />
                  <p className="text-[#334155] text-[11px] leading-snug">
                    High demand expected this weekend due to local festival. Consider increasing stock
                    slightly.
                  </p>
                </div>
              </div>

              {/* Performance Section */}
              <div className="px-4 space-y-2">
                <h4 className="font-black text-sm text-[#1e2923]">Performance (30 Days)</h4>
                <div className="grid grid-cols-3 gap-2">
                  <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0]">
                    <div className="flex items-center gap-1 text-[#64748b] text-[10px]">
                      <Eye className="w-3 h-3" /> Views
                    </div>
                    <p className="font-black text-base text-[#1e2923] mt-1">2.4k</p>
                    <p className="text-[10px] font-bold text-[#15803d]">↑ 12%</p>
                  </div>

                  <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0]">
                    <div className="flex items-center gap-1 text-[#64748b] text-[10px]">
                      <ShoppingBag className="w-3 h-3" /> Orders
                    </div>
                    <p className="font-black text-base text-[#1e2923] mt-1">142</p>
                    <p className="text-[10px] font-bold text-[#15803d]">↑ 5%</p>
                  </div>

                  <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0]">
                    <div className="flex items-center gap-1 text-[#64748b] text-[10px]">
                      <Percent className="w-3 h-3" /> Conversion
                    </div>
                    <p className="font-black text-base text-[#1e2923] mt-1">5.8%</p>
                    <p className="text-[10px] font-bold text-[#dc2626]">↓ 1.2%</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Bottom Actions Row */}
            <div className="bg-white border-t border-[#f1f5f9] p-3 flex gap-2">
              <button
                onClick={() => setIsUpdateStockOpen(true)}
                className="flex-1 py-2.5 border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 hover:bg-[#f8fafc]"
              >
                <Package className="w-4 h-4" /> Update Stock
              </button>
              <button className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 shadow-sm hover:bg-[#00522b]">
                <Edit className="w-4 h-4" /> Edit Product
              </button>
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dce6fe] text-[#1e2923] rounded-2xl"><Tag className="w-4 h-4 text-[#006837]" /> Products</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          {/* Left Column (Span 7) */}
          <div className="lg:col-span-7 space-y-6">
            {/* Hero Image */}
            <div className="relative w-full h-80 rounded-3xl overflow-hidden shadow-sm">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src="https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800"
                alt="Organic Hass Avocados"
                className="w-full h-full object-cover"
              />
              <div className="absolute top-4 left-4 bg-[#006837] text-white px-3 py-1 rounded-full flex items-center gap-1.5 text-xs font-bold shadow-md">
                <CheckCircle2 className="w-4 h-4" /> Published
              </div>
              <div className="absolute bottom-4 right-4 bg-white/90 backdrop-blur px-3 py-1 rounded-full flex items-center gap-1.5 text-xs font-bold text-[#1e2923] shadow-md">
                <Heart className="w-4 h-4 text-pink-500 fill-pink-500" /> 245 Saves
              </div>
            </div>

            {/* Metadata Cards Strip */}
            <div className="grid grid-cols-3 gap-4">
              <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                <Scale className="w-5 h-5 text-[#006837] mx-auto" />
                <span className="text-xs text-[#64748b] block">Weight</span>
                <span className="font-bold text-sm text-[#1e2923] block">500g</span>
              </div>
              <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                <QrCode className="w-5 h-5 text-[#006837] mx-auto" />
                <span className="text-xs text-[#64748b] block">SKU</span>
                <span className="font-bold text-sm text-[#1e2923] font-mono block">AV-ORG-001</span>
              </div>
              <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                <Scan className="w-5 h-5 text-[#006837] mx-auto" />
                <span className="text-xs text-[#64748b] block">Barcode</span>
                <span className="font-bold text-sm text-[#1e2923] block">890123456789</span>
              </div>
            </div>

            {/* Performance (30 Days) */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
              <h3 className="font-black text-base text-[#1e2923]">Performance (30 Days)</h3>
              <div className="grid grid-cols-3 gap-4">
                <div className="bg-[#f8fafc] p-4 rounded-2xl border border-[#e2e8f0]">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                    <Eye className="w-4 h-4" /> Views
                  </div>
                  <p className="font-black text-2xl text-[#1e2923] mt-2">2.4k</p>
                  <p className="text-xs font-bold text-[#15803d] mt-1">↑ 12% vs last month</p>
                </div>

                <div className="bg-[#f8fafc] p-4 rounded-2xl border border-[#e2e8f0]">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                    <ShoppingBag className="w-4 h-4" /> Orders
                  </div>
                  <p className="font-black text-2xl text-[#1e2923] mt-2">142</p>
                  <p className="text-xs font-bold text-[#15803d] mt-1">↑ 5% vs last month</p>
                </div>

                <div className="bg-[#f8fafc] p-4 rounded-2xl border border-[#e2e8f0]">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                    <Percent className="w-4 h-4" /> Conversion
                  </div>
                  <p className="font-black text-2xl text-[#1e2923] mt-2">5.8%</p>
                  <p className="text-xs font-bold text-[#dc2626] mt-1">↓ 1.2% vs last month</p>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column (Span 5) */}
          <div className="lg:col-span-5 space-y-6">
            {/* Header Title & Description */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
              <span className="text-xs font-black text-[#64748b] tracking-wider uppercase block">
                PRODUCE &gt; FRUITS
              </span>
              <h2 className="text-2xl font-black text-[#1e2923]">Organic Hass Avocados</h2>
              <p className="text-sm font-bold text-[#006837]">Fresh Farms</p>
              <p className="text-xs text-[#334155] leading-relaxed">
                Premium quality organic Hass avocados sourced directly from sustainable farms. Rich,
                creamy texture perfect for guacamole or toast. Packed with healthy fats, potassium, and
                essential vitamins.
              </p>
            </div>

            {/* Pricing Card */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="p-2 rounded-xl bg-[#dcfce7] text-[#006837]">
                    <DollarSign className="w-5 h-5" />
                  </div>
                  <span className="font-bold text-base text-[#1e2923]">Pricing & Margins</span>
                </div>
                <span className="px-3 py-1 bg-[#f1f5f9] text-xs font-bold text-[#64748b] rounded-lg">
                  Updated 2d ago
                </span>
              </div>

              <div className="flex items-baseline gap-3">
                <span className="text-3xl font-black text-[#1e2923]">₹149</span>
                <span className="text-base text-[#94a3b8] line-through">₹180</span>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Margin</span>
                  <span className="font-black text-lg text-[#15803d]">18%</span>
                </div>
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">GST</span>
                  <span className="font-black text-lg text-[#1e2923]">5%</span>
                </div>
              </div>
            </div>

            {/* Inventory Card */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="p-2 rounded-xl bg-[#dcfce7] text-[#006837]">
                    <Store className="w-5 h-5" />
                  </div>
                  <span className="font-bold text-base text-[#1e2923]">Inventory Status</span>
                </div>
                <span className="px-3 py-1 bg-[#dcfce7] text-[#15803d] text-xs font-bold rounded-lg flex items-center gap-1.5">
                  <CheckCircle2 className="w-4 h-4" /> In Stock
                </span>
              </div>

              <div>
                <span className="text-3xl font-black text-[#006837]">{stockCount}</span>{' '}
                <span className="text-sm text-[#64748b]">Available Units</span>
              </div>

              <div className="grid grid-cols-3 gap-3">
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Reserved</span>
                  <span className="font-black text-base text-[#c2410c]">12</span>
                </div>
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Min Stock</span>
                  <span className="font-black text-base text-[#1e2923]">20</span>
                </div>
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Location</span>
                  <span className="font-black text-base text-[#15803d]">A1-04</span>
                </div>
              </div>

              <button
                onClick={() => setIsUpdateStockOpen(true)}
                className="w-full py-3 border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-2xl flex items-center justify-center gap-2 hover:bg-[#f8fafc]"
              >
                <Package className="w-4 h-4" /> Update Stock Count
              </button>
            </div>

            {/* AI Insights */}
            <div className="bg-[#f0fdf4] p-6 rounded-3xl border border-[#dcfce7] shadow-sm space-y-4">
              <div className="flex items-center gap-2">
                <Sparkles className="w-5 h-5 text-[#006837]" />
                <span className="font-bold text-base text-[#1e2923]">AI Insights</span>
              </div>

              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <TrendingUp className="w-5 h-5 text-[#1e2923]" />
                  <div>
                    <span className="text-xs text-[#64748b] block">Suggested Price</span>
                    <span className="font-bold text-sm text-[#1e2923]">₹145 - ₹155</span>
                  </div>
                </div>
                <div className="w-10 h-10 rounded-full border-2 border-[#006837] bg-white flex items-center justify-center font-bold text-sm text-[#006837]">
                  92
                </div>
              </div>

              <div className="bg-white p-3.5 rounded-2xl flex items-start gap-3 text-xs">
                <Info className="w-4 h-4 text-[#0284c7] shrink-0 mt-0.5" />
                <p className="text-[#334155] leading-relaxed">
                  High demand expected this weekend due to local festival. Consider increasing stock
                  slightly.
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal for Update Stock */}
      {isUpdateStockOpen && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-md w-full shadow-2xl space-y-4">
            <h3 className="text-lg font-bold text-[#1e2923]">Update Stock Quantity</h3>
            <p className="text-xs text-[#64748b]">
              Enter new dark store inventory count for SKU: AV-ORG-001
            </p>

            <input
              type="number"
              value={newStockInput}
              onChange={(e) => setNewStockInput(e.target.value)}
              className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-base font-bold text-[#1e2923] focus:outline-none focus:border-[#006837]"
            />

            <div className="flex gap-3 pt-2">
              <button
                onClick={() => setIsUpdateStockOpen(false)}
                className="flex-1 py-3 border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-2xl hover:bg-[#f8fafc]"
              >
                Cancel
              </button>
              <button
                onClick={handleUpdateStock}
                className="flex-1 py-3 bg-[#006837] text-white text-xs font-bold rounded-2xl hover:bg-[#00522b]"
              >
                Save & Broadcast WebSocket
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
