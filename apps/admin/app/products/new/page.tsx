'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  Camera,
  Sparkles,
  ArrowRight,
  ChevronDown,
  Grid,
  ShoppingBag,
  Package,
  Tag,
  BarChart3,
  Smartphone,
  LayoutGrid,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Add New Product - Basic Info (ID: 161ecffe647347dcb3399a8bf75f8be0)

export default function AddNewProductBasicInfoPage() {
  const [currentStep, setCurrentStep] = useState(1);
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [productName, setProductName] = useState('');
  const [brand, setBrand] = useState('');
  const [category, setCategory] = useState('');
  const [description, setDescription] = useState('');
  const [barcode, setBarcode] = useState('');
  const [aiNotice, setAiNotice] = useState(true);

  const handleGenerateAiDescription = () => {
    setDescription(
      'Farm-fresh organic produce, hand-harvested at peak ripeness to preserve natural flavors, rich nutrients, and optimum crispness.'
    );
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#1e2923]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Add New Product</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 161ecffe647347dcb3399a8bf75f8be0 • Step 1: Basic Info
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
            <span>Web Wizard</span>
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

      {/* Main Form Content */}
      {viewMode === 'mobile' ? (
        /* Mobile Device Frame View simulating exact Stitch phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[820px] bg-white rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#f1f5f9]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-black text-base text-[#1e2923]">Add New Product</span>
              <button className="text-xs font-bold text-[#006837]">Save Draft</button>
            </div>

            {/* Stepper Bar Header */}
            <div className="bg-white px-3 py-3 border-b border-[#f1f5f9] flex justify-around items-center text-center">
              {[
                { num: '1', label: 'Basic Info', active: true },
                { num: '2', label: 'Pricing', active: false },
                { num: '3', label: 'Inventory', active: false },
                { num: '4', label: 'Images', active: false },
                { num: '5', label: 'Review', active: false },
              ].map((s) => (
                <div key={s.num} className="flex flex-col items-center gap-1">
                  <div
                    className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold ${
                      s.active ? 'bg-[#006837] text-white' : 'bg-[#e2e8f0] text-[#64748b]'
                    }`}
                  >
                    {s.num}
                  </div>
                  <span
                    className={`text-[10px] ${
                      s.active ? 'font-bold text-[#006837]' : 'font-medium text-[#64748b]'
                    }`}
                  >
                    {s.label}
                  </span>
                </div>
              ))}
            </div>

            {/* Scrollable Form Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              {/* Primary Image Upload Box */}
              <div className="w-full h-40 bg-[#f8fafc] rounded-2xl border-2 border-dashed border-[#cbd5e1] flex flex-col items-center justify-center gap-2 cursor-pointer hover:border-[#006837] transition">
                <div className="p-3 rounded-2xl bg-[#dbeafe] text-[#2563eb]">
                  <Camera className="w-6 h-6" />
                </div>
                <span className="text-xs font-bold text-[#1e2923]">Tap to upload primary image</span>
              </div>

              {/* Product Name */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Product Name</label>
                <input
                  type="text"
                  value={productName}
                  onChange={(e) => setProductName(e.target.value)}
                  placeholder="e.g., Organic Avocados"
                  className="w-full px-3.5 py-2.5 bg-white border border-[#cbd5e1] rounded-xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
              </div>

              {/* Brand & Category 2-Col */}
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-[#1e2923] block">Brand</label>
                  <input
                    type="text"
                    value={brand}
                    onChange={(e) => setBrand(e.target.value)}
                    placeholder="Brand Name"
                    className="w-full px-3.5 py-2.5 bg-white border border-[#cbd5e1] rounded-xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-[#1e2923] block">Category</label>
                  <div className="relative">
                    <select
                      value={category}
                      onChange={(e) => setCategory(e.target.value)}
                      className="w-full px-3.5 py-2.5 bg-white border border-[#cbd5e1] rounded-xl text-xs text-[#1e2923] appearance-none focus:outline-none focus:border-[#006837]"
                    >
                      <option value="">Select...</option>
                      <option value="Produce">Produce</option>
                      <option value="Dairy & Eggs">Dairy & Eggs</option>
                      <option value="Bakery">Bakery</option>
                      <option value="Snacks">Snacks</option>
                      <option value="Beverages">Beverages</option>
                    </select>
                    <ChevronDown className="w-4 h-4 text-[#1e2923] absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none" />
                  </div>
                </div>
              </div>

              {/* AI Assistant Banner */}
              {aiNotice && (
                <div className="p-3.5 bg-[#eff6ff] border border-[#dbeafe] rounded-2xl flex items-start gap-3">
                  <div className="p-1.5 bg-[#475569] text-white rounded-full mt-0.5">
                    <Sparkles className="w-3.5 h-3.5" />
                  </div>
                  <div className="flex-1 text-xs">
                    <h5 className="font-bold text-[#1e2923]">AI Assistant</h5>
                    <p className="text-[#334155] mt-0.5 leading-relaxed">
                      Based on your recent uploads, suggesting category:{' '}
                      <span className="font-bold text-[#006837]">Produce</span>. Want me to generate a
                      description?
                    </p>
                    <button
                      onClick={handleGenerateAiDescription}
                      className="text-[#006837] font-bold underline mt-1.5 text-xs block"
                    >
                      Generate Description
                    </button>
                  </div>
                </div>
              )}

              {/* Description */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Description</label>
                <textarea
                  rows={3}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Enter product description..."
                  className="w-full px-3.5 py-2.5 bg-white border border-[#cbd5e1] rounded-xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
              </div>

              {/* Barcode / SKU */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Barcode / SKU</label>
                <input
                  type="text"
                  value={barcode}
                  onChange={(e) => setBarcode(e.target.value)}
                  placeholder="Scan or type barcode SKU..."
                  className="w-full px-3.5 py-2.5 bg-white border border-[#cbd5e1] rounded-xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            {/* Bottom Actions Row */}
            <div className="bg-white border-t border-[#f1f5f9] p-4 flex gap-3">
              <button className="flex-1 py-3 border-2 border-[#1e2923] text-[#1e2923] font-bold text-xs rounded-full hover:bg-[#f8fafc]">
                Cancel
              </button>
              <button className="flex-[1.5] py-3 bg-[#006837] text-white font-bold text-xs rounded-full flex items-center justify-center gap-2 shadow-md hover:bg-[#00522b]">
                <span>Next Step</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dce6fe] text-[#1e2923] rounded-2xl"><Tag className="w-4 h-4 text-[#006837]" /> Products</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Form View */
        <div className="bg-white rounded-3xl p-8 border border-[#e2e8f0] shadow-sm space-y-8">
          {/* Stepper Header */}
          <div className="flex items-center justify-between border-b border-[#e2e8f0] pb-6">
            {[
              { step: 1, title: 'Basic Info' },
              { step: 2, title: 'Pricing' },
              { step: 3, title: 'Inventory' },
              { step: 4, title: 'Images' },
              { step: 5, title: 'Review' },
            ].map((s) => (
              <div key={s.step} className="flex items-center gap-3">
                <div
                  className={`w-9 h-9 rounded-full flex items-center justify-center text-sm font-black ${
                    s.step === currentStep
                      ? 'bg-[#006837] text-white shadow-md'
                      : s.step < currentStep
                      ? 'bg-[#dcfce7] text-[#15803d]'
                      : 'bg-[#e2e8f0] text-[#64748b]'
                  }`}
                >
                  {s.step}
                </div>
                <span
                  className={`text-sm ${
                    s.step === currentStep
                      ? 'font-bold text-[#006837]'
                      : 'font-medium text-[#64748b]'
                  }`}
                >
                  {s.title}
                </span>
              </div>
            ))}
          </div>

          {/* Form Fields Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
            {/* Left Column (Span 7) */}
            <div className="lg:col-span-7 space-y-6">
              {/* Product Name */}
              <div className="space-y-2">
                <label className="text-sm font-bold text-[#1e2923] block">Product Name</label>
                <input
                  type="text"
                  value={productName}
                  onChange={(e) => setProductName(e.target.value)}
                  placeholder="e.g., Organic Avocados"
                  className="w-full px-4 py-3 bg-white border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
              </div>

              {/* Brand & Category 2-Col */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-bold text-[#1e2923] block">Brand</label>
                  <input
                    type="text"
                    value={brand}
                    onChange={(e) => setBrand(e.target.value)}
                    placeholder="Brand Name"
                    className="w-full px-4 py-3 bg-white border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                  />
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-bold text-[#1e2923] block">Category</label>
                  <select
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="w-full px-4 py-3 bg-white border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] focus:outline-none focus:border-[#006837]"
                  >
                    <option value="">Select...</option>
                    <option value="Produce">Produce</option>
                    <option value="Dairy & Eggs">Dairy & Eggs</option>
                    <option value="Bakery">Bakery</option>
                    <option value="Snacks">Snacks</option>
                    <option value="Beverages">Beverages</option>
                  </select>
                </div>
              </div>

              {/* AI Assistant Banner */}
              {aiNotice && (
                <div className="p-4 bg-[#eff6ff] border border-[#dbeafe] rounded-2xl flex items-start gap-4">
                  <div className="p-2 bg-[#475569] text-white rounded-full mt-0.5">
                    <Sparkles className="w-4 h-4" />
                  </div>
                  <div className="flex-1 text-xs">
                    <h5 className="font-bold text-[#1e2923] text-sm">AI Assistant</h5>
                    <p className="text-[#334155] mt-1 leading-relaxed">
                      Based on your recent uploads, suggesting category:{' '}
                      <span className="font-bold text-[#006837]">Produce</span>. Want me to generate a
                      description?
                    </p>
                    <button
                      onClick={handleGenerateAiDescription}
                      className="text-[#006837] font-bold underline mt-2 text-xs block hover:text-[#00522b]"
                    >
                      Generate Description
                    </button>
                  </div>
                </div>
              )}

              {/* Description */}
              <div className="space-y-2">
                <label className="text-sm font-bold text-[#1e2923] block">Description</label>
                <textarea
                  rows={4}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Enter product description..."
                  className="w-full px-4 py-3 bg-white border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
              </div>

              {/* Barcode / SKU */}
              <div className="space-y-2">
                <label className="text-sm font-bold text-[#1e2923] block">Barcode / SKU</label>
                <input
                  type="text"
                  value={barcode}
                  onChange={(e) => setBarcode(e.target.value)}
                  placeholder="Scan or type barcode SKU..."
                  className="w-full px-4 py-3 bg-white border border-[#cbd5e1] rounded-2xl text-sm font-mono text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            {/* Right Column: Image Upload Dropzone (Span 5) */}
            <div className="lg:col-span-5 space-y-6">
              <label className="text-sm font-bold text-[#1e2923] block">Primary Product Image</label>
              <div className="w-full h-80 bg-[#f8fafc] rounded-3xl border-2 border-dashed border-[#cbd5e1] flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-[#006837] transition">
                <div className="p-4 rounded-2xl bg-[#dbeafe] text-[#2563eb]">
                  <Camera className="w-8 h-8" />
                </div>
                <span className="text-sm font-bold text-[#1e2923]">Tap to upload primary image</span>
                <span className="text-xs text-[#64748b]">PNG, JPG up to 5MB</span>
              </div>
            </div>
          </div>

          {/* Footer Controls */}
          <div className="flex items-center justify-between border-t border-[#e2e8f0] pt-6">
            <button className="px-8 py-3 border-2 border-[#1e2923] text-[#1e2923] font-bold text-sm rounded-full hover:bg-[#f8fafc]">
              Cancel
            </button>
            <button
              onClick={() => setCurrentStep((prev) => Math.min(prev + 1, 5))}
              className="px-10 py-3.5 bg-[#006837] text-white font-bold text-sm rounded-full flex items-center gap-2 shadow-md hover:bg-[#00522b]"
            >
              <span>Next Step</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
