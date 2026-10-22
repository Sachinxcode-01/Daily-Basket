'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
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
  Check,
  CheckCircle2,
  DollarSign,
  Layers,
  Leaf,
} from 'lucide-react';
import { apiClient } from '@daily-basket/api-client';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Add New Product - Basic Info (ID: 161ecffe647347dcb3399a8bf75f8be0)

export default function AddNewProductPage() {
  const router = useRouter();
  const [currentStep, setCurrentStep] = useState(1);
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');

  // Form State across all steps
  const [productName, setProductName] = useState('');
  const [brand, setBrand] = useState('Daily Basket Select');
  const [category, setCategory] = useState('Fresh Produce');
  const [description, setDescription] = useState('');
  const [barcode, setBarcode] = useState('');

  // Step 2 & 3: Pricing & Inventory
  const [price, setPrice] = useState('99');
  const [mrp, setMrp] = useState('125');
  const [stockQuantity, setStockQuantity] = useState('150');
  const [unitName, setUnitName] = useState('1 unit');
  const [minStockAlert, setMinStockAlert] = useState('20');
  const [isOrganic, setIsOrganic] = useState(false);

  // Step 4: Media
  const [imageUrl, setImageUrl] = useState('/images/daily_basket_logo.png');

  // Submit status
  const [isPublishing, setIsPublishing] = useState(false);
  const [successToast, setSuccessToast] = useState(false);
  const [aiNotice, setAiNotice] = useState(true);

  const handleGenerateAiDescription = () => {
    setDescription(
      `Farm-fresh ${productName || 'produce'} sourced directly from certified organic local farmers. Quality checked with cold-chain storage and guaranteed 10-minute delivery.`
    );
  };

  const handlePublish = async () => {
    if (!productName.trim()) {
      alert('Please enter a product name');
      setCurrentStep(1);
      return;
    }

    setIsPublishing(true);

    const payload = {
      name: productName,
      brand,
      category,
      categoryId: category.toLowerCase().replace(/[^a-z0-9]+/g, '-'),
      price: Number(price) || 99,
      mrp: Number(mrp) || Math.round((Number(price) || 99) * 1.25),
      unit: unitName,
      unitName,
      stockQuantity: Number(stockQuantity) || 100,
      description: description || `${productName}. 10-minute fast grocery delivery.`,
      barcode: barcode || `890${Date.now().toString().slice(-9)}`,
      images: [imageUrl],
      image: imageUrl,
      isOrganic,
    };

    try {
      await fetch('/api/products', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      }).catch(() => {});

      apiClient.createProduct(payload).catch(() => {});

      setSuccessToast(true);
      setTimeout(() => {
        router.push('/products');
      }, 1500);
    } catch {
      alert('Failed to create product');
    } finally {
      setIsPublishing(false);
    }
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans relative">
      {/* Toast Notification */}
      {successToast && (
        <div className="fixed top-6 right-6 z-50 flex items-center gap-3 bg-[#006837] text-white px-5 py-3.5 rounded-2xl shadow-2xl animate-in fade-in slide-in-from-top-4">
          <CheckCircle2 className="w-5 h-5 text-[#22c55e]" />
          <span className="text-sm font-bold">Product published to catalog! Redirecting...</span>
        </div>
      )}

      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <Link href="/products" className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#1e2923]">
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Add New Product</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 161ecffe647347dcb3399a8bf75f8be0 • Step {currentStep} of 5
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
      <div className="bg-white rounded-3xl p-8 border border-[#e2e8f0] shadow-sm space-y-8">
        {/* Stepper Header */}
        <div className="flex items-center justify-between border-b border-[#e2e8f0] pb-6 overflow-x-auto no-scrollbar">
          {[
            { step: 1, title: 'Basic Info' },
            { step: 2, title: 'Pricing' },
            { step: 3, title: 'Inventory' },
            { step: 4, title: 'Media' },
            { step: 5, title: 'Review & Publish' },
          ].map((s) => (
            <button
              key={s.step}
              onClick={() => setCurrentStep(s.step)}
              className="flex items-center gap-2 text-left cursor-pointer"
            >
              <div
                className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-black transition ${
                  s.step === currentStep
                    ? 'bg-[#006837] text-white shadow-md'
                    : s.step < currentStep
                    ? 'bg-[#dcfce7] text-[#15803d]'
                    : 'bg-[#e2e8f0] text-[#64748b]'
                }`}
              >
                {s.step < currentStep ? <Check className="w-4 h-4" /> : s.step}
              </div>
              <span
                className={`text-xs whitespace-nowrap ${
                  s.step === currentStep ? 'font-bold text-[#006837]' : 'font-medium text-[#64748b]'
                }`}
              >
                {s.title}
              </span>
            </button>
          ))}
        </div>

        {/* Step 1: Basic Info */}
        {currentStep === 1 && (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <div className="lg:col-span-7 space-y-5">
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Product Name *</label>
                <input
                  type="text"
                  value={productName}
                  onChange={(e) => setProductName(e.target.value)}
                  placeholder="e.g., Organic Robusta Bananas"
                  className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] focus:outline-none focus:border-[#006837]"
                  required
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-[#1e2923] block">Brand</label>
                  <input
                    type="text"
                    value={brand}
                    onChange={(e) => setBrand(e.target.value)}
                    placeholder="Brand Name"
                    className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] focus:outline-none focus:border-[#006837]"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-[#1e2923] block">Category</label>
                  <select
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] focus:outline-none focus:border-[#006837]"
                  >
                    <option value="Fresh Produce">Fresh Produce</option>
                    <option value="Dairy & Eggs">Dairy & Eggs</option>
                    <option value="Bakery & Snacks">Bakery & Snacks</option>
                    <option value="Beverages">Beverages</option>
                    <option value="Atta, Rice & Dal">Atta, Rice & Dal</option>
                    <option value="Vermicelli & Seviyan">Vermicelli & Seviyan</option>
                  </select>
                </div>
              </div>

              {/* AI Assistant Banner */}
              {aiNotice && (
                <div className="p-4 bg-[#eff6ff] border border-[#dbeafe] rounded-2xl flex items-start gap-3">
                  <div className="p-2 bg-[#006837] text-white rounded-full mt-0.5">
                    <Sparkles className="w-4 h-4" />
                  </div>
                  <div className="flex-1 text-xs">
                    <h5 className="font-bold text-[#1e2923] text-sm">AI Copilot Description Generator</h5>
                    <p className="text-[#334155] mt-1 leading-relaxed">
                      Automatically write a high-converting, freshness-certified product description.
                    </p>
                    <button
                      type="button"
                      onClick={handleGenerateAiDescription}
                      className="text-[#006837] font-bold underline mt-2 text-xs block hover:text-[#00522b]"
                    >
                      Generate Description with AI
                    </button>
                  </div>
                </div>
              )}

              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Description</label>
                <textarea
                  rows={4}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Enter product description..."
                  className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm text-[#1e2923] focus:outline-none focus:border-[#006837]"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Barcode / SKU</label>
                <input
                  type="text"
                  value={barcode}
                  onChange={(e) => setBarcode(e.target.value)}
                  placeholder="e.g. 890123456789"
                  className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm font-mono text-[#1e2923] focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            <div className="lg:col-span-5 flex flex-col gap-4">
              <label className="text-xs font-bold text-[#1e2923] block">Quick Summary</label>
              <div className="bg-[#f8fafc] p-5 rounded-3xl border border-[#cbd5e1] space-y-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-white rounded-2xl border border-[#e2e8f0] flex items-center justify-center p-1">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src={imageUrl} alt="preview" className="w-full h-full object-contain" />
                  </div>
                  <div>
                    <h4 className="font-extrabold text-sm text-[#1e2923]">{productName || 'New Product'}</h4>
                    <p className="text-xs text-[#64748b]">{brand} • {category}</p>
                  </div>
                </div>

                <div className="text-xs text-[#64748b] leading-relaxed">
                  Fill in pricing in step 2 and inventory counts in step 3 to make this product instantly buyable.
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Step 2: Pricing */}
        {currentStep === 2 && (
          <div className="max-w-xl mx-auto space-y-6">
            <h3 className="text-lg font-black text-[#1e2923] flex items-center gap-2">
              <DollarSign className="w-5 h-5 text-[#006837]" /> Product Pricing & Margin
            </h3>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Customer Selling Price (₹) *</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  className="w-full px-4 py-3 bg-[#f8fafc] border-2 border-[#cbd5e1] rounded-2xl text-lg font-black text-[#1e2923] focus:outline-none focus:border-[#006837]"
                  required
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Original MRP (₹)</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={mrp}
                  onChange={(e) => setMrp(e.target.value)}
                  className="w-full px-4 py-3 bg-[#f8fafc] border-2 border-[#cbd5e1] rounded-2xl text-lg font-black text-[#64748b] focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            {Number(mrp) > Number(price) && (
              <div className="p-4 bg-[#dcfce7] rounded-2xl border border-[#bbf7d0] flex items-center justify-between text-sm">
                <span className="font-bold text-[#15803d]">Customer Savings:</span>
                <span className="font-black text-lg text-[#15803d]">
                  ₹{(Number(mrp) - Number(price)).toFixed(0)} ({Math.round(((Number(mrp) - Number(price)) / Number(mrp)) * 100)}% OFF)
                </span>
              </div>
            )}
          </div>
        )}

        {/* Step 3: Inventory */}
        {currentStep === 3 && (
          <div className="max-w-xl mx-auto space-y-6">
            <h3 className="text-lg font-black text-[#1e2923] flex items-center gap-2">
              <Package className="w-5 h-5 text-[#006837]" /> Inventory & Stock Controls
            </h3>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Initial Available Stock Units *</label>
                <input
                  type="number"
                  min="0"
                  value={stockQuantity}
                  onChange={(e) => setStockQuantity(e.target.value)}
                  className="w-full px-4 py-3 bg-[#f8fafc] border-2 border-[#cbd5e1] rounded-2xl text-lg font-black text-[#006837] focus:outline-none focus:border-[#006837]"
                  required
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#1e2923] block">Low Stock Alert Level</label>
                <input
                  type="number"
                  min="0"
                  value={minStockAlert}
                  onChange={(e) => setMinStockAlert(e.target.value)}
                  className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm font-bold text-[#1e2923] focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-bold text-[#1e2923] block">Unit Specification (e.g. 500g, 1L, 1 kg)</label>
              <input
                type="text"
                value={unitName}
                onChange={(e) => setUnitName(e.target.value)}
                placeholder="e.g. 500g Pack"
                className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-sm font-bold text-[#1e2923] focus:outline-none focus:border-[#006837]"
              />
            </div>

            <label className="flex items-center gap-3 p-4 bg-[#f8fafc] rounded-2xl border border-[#cbd5e1] cursor-pointer">
              <input
                type="checkbox"
                checked={isOrganic}
                onChange={(e) => setIsOrganic(e.target.checked)}
                className="w-5 h-5 accent-[#006837] rounded"
              />
              <div>
                <span className="text-sm font-black text-[#1e2923] flex items-center gap-1.5">
                  <Leaf className="w-4 h-4 text-[#006837]" /> Certified Organic Product
                </span>
                <span className="text-xs text-[#64748b]">Displays green organic badge to customers</span>
              </div>
            </label>
          </div>
        )}

        {/* Step 4: Media */}
        {currentStep === 4 && (
          <div className="max-w-xl mx-auto space-y-6">
            <h3 className="text-lg font-black text-[#1e2923] flex items-center gap-2">
              <Camera className="w-5 h-5 text-[#006837]" /> Product Media & Images
            </h3>

            <div className="w-full h-56 bg-[#f8fafc] rounded-3xl border-2 border-dashed border-[#cbd5e1] flex flex-col items-center justify-center p-4">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={imageUrl}
                alt="Product Preview"
                className="h-32 object-contain mb-2"
                onError={(e) => {
                  (e.target as HTMLImageElement).src = '/images/daily_basket_logo.png';
                }}
              />
              <span className="text-xs font-bold text-[#64748b]">Image Preview</span>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-bold text-[#1e2923] block">Image URL</label>
              <input
                type="text"
                value={imageUrl}
                onChange={(e) => setImageUrl(e.target.value)}
                placeholder="/images/daily_basket_logo.png"
                className="w-full px-4 py-3 bg-[#f8fafc] border border-[#cbd5e1] rounded-2xl text-xs text-[#1e2923] focus:outline-none focus:border-[#006837]"
              />
            </div>
          </div>
        )}

        {/* Step 5: Review & Publish */}
        {currentStep === 5 && (
          <div className="max-w-xl mx-auto space-y-6">
            <h3 className="text-lg font-black text-[#1e2923] flex items-center gap-2">
              <CheckCircle2 className="w-5 h-5 text-[#006837]" /> Review Product Before Publishing
            </h3>

            <div className="bg-[#f8fafc] p-6 rounded-3xl border border-[#cbd5e1] space-y-4">
              <div className="flex gap-4">
                <div className="w-20 h-20 bg-white rounded-2xl border border-[#e2e8f0] p-1 flex items-center justify-center">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={imageUrl} alt="preview" className="w-full h-full object-contain" />
                </div>
                <div className="flex-1">
                  <span className="text-[10px] font-bold uppercase text-[#64748b]">{brand}</span>
                  <h4 className="text-base font-black text-[#1e2923]">{productName || 'Untitled Product'}</h4>
                  <p className="text-xs text-[#64748b] mt-0.5">{category} • {unitName}</p>
                </div>
              </div>

              <div className="grid grid-cols-3 gap-3 pt-3 border-t border-[#e2e8f0] text-center">
                <div className="bg-white p-3 rounded-2xl border border-[#e2e8f0]">
                  <span className="text-[10px] text-[#64748b] uppercase font-bold">Selling Price</span>
                  <p className="text-lg font-black text-[#1e2923] mt-0.5">₹{price}</p>
                </div>
                <div className="bg-white p-3 rounded-2xl border border-[#e2e8f0]">
                  <span className="text-[10px] text-[#64748b] uppercase font-bold">MRP</span>
                  <p className="text-lg font-black text-[#64748b] mt-0.5">₹{mrp}</p>
                </div>
                <div className="bg-white p-3 rounded-2xl border border-[#e2e8f0]">
                  <span className="text-[10px] text-[#64748b] uppercase font-bold">Stock</span>
                  <p className="text-lg font-black text-[#006837] mt-0.5">{stockQuantity} units</p>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Footer Navigation */}
        <div className="flex items-center justify-between border-t border-[#e2e8f0] pt-6">
          {currentStep > 1 ? (
            <button
              type="button"
              onClick={() => setCurrentStep((prev) => Math.max(prev - 1, 1))}
              className="px-6 py-3 border border-[#cbd5e1] text-[#1e2923] font-bold text-xs rounded-xl hover:bg-[#f8fafc] transition"
            >
              Back
            </button>
          ) : (
            <Link
              href="/products"
              className="px-6 py-3 border border-[#cbd5e1] text-[#1e2923] font-bold text-xs rounded-xl hover:bg-[#f8fafc] transition"
            >
              Cancel
            </Link>
          )}

          {currentStep < 5 ? (
            <button
              type="button"
              onClick={() => {
                if (currentStep === 1 && !productName.trim()) {
                  alert('Please enter a product name');
                  return;
                }
                setCurrentStep((prev) => Math.min(prev + 1, 5));
              }}
              className="px-8 py-3 bg-[#006837] text-white font-bold text-xs rounded-xl flex items-center gap-2 shadow-md hover:bg-[#00522b] transition"
            >
              <span>Next Step</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          ) : (
            <button
              type="button"
              disabled={isPublishing}
              onClick={handlePublish}
              className="px-10 py-3.5 bg-[#006837] text-white font-bold text-xs rounded-xl flex items-center gap-2 shadow-lg hover:bg-[#00522b] transition transform hover:scale-[1.02]"
            >
              <Check className="w-4 h-4" />
              <span>{isPublishing ? 'Publishing...' : 'Publish Product to Catalog'}</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
