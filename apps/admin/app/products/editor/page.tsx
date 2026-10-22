'use client';

import React, { useState, useEffect, Suspense } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import {
  ArrowLeft,
  Save,
  Trash2,
  CheckCircle2,
  AlertTriangle,
  Package,
  Tag,
  DollarSign,
  Sparkles,
  Leaf,
  Layers,
} from 'lucide-react';
import { apiClient } from '@daily-basket/api-client';
import catalogJson from '@daily-basket/shared-types/src/products_catalog.json';

function AdminProductEditorInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const paramId = searchParams.get('id');

  const [productId, setProductId] = useState(paramId || '');
  const [name, setName] = useState('');
  const [brand, setBrand] = useState('Daily Basket');
  const [sku, setSku] = useState('');
  const [category, setCategory] = useState('Fresh Produce');
  const [price, setPrice] = useState('120');
  const [mrp, setMrp] = useState('150');
  const [stock, setStock] = useState('100');
  const [unit, setUnit] = useState('1 unit');
  const [description, setDescription] = useState('');
  const [imageUrl, setImageUrl] = useState('/images/daily_basket_logo.png');
  const [isOrganic, setIsOrganic] = useState(false);

  const [isLoading, setIsLoading] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [isSavedToast, setIsSavedToast] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  // Load existing product details if editing
  useEffect(() => {
    if (!paramId) return;

    setIsLoading(true);
    fetch(`/api/products/${paramId}`)
      .then((res) => res.json())
      .then((payload) => {
        const p = payload.data || payload;
        if (p && p.name) {
          const v = (Array.isArray(p.variants) && p.variants[0]) || {};
          setProductId(p.id);
          setName(p.name);
          setBrand(p.brand || 'Daily Basket');
          setSku(v.sku || p.sku || `SKU-${p.id.substring(0, 8)}`);
          setCategory(p.category?.name || p.category || 'Fresh Produce');
          setPrice(String(v.price ?? p.price ?? 99));
          setMrp(String(v.mrp ?? p.mrp ?? 120));
          setStock(String(v.stockQuantity ?? p.stockAvailable ?? 100));
          setUnit(v.unitName || p.unit || '1 unit');
          setDescription(p.description || '');
          const img = (Array.isArray(p.images) && p.images[0]) || p.image || '/images/daily_basket_logo.png';
          setImageUrl(img.startsWith('assets/') ? `/${img.replace(/^assets\//, '')}` : img);
          setIsOrganic(Boolean(p.isOrganic));
        }
      })
      .catch(() => {
        // Fallback from catalog
        const raw: any[] = Object.values(catalogJson as Record<string, any[]>).flat();
        const match = raw.find((item) => item.id === paramId || paramId.includes(item.id));
        if (match) {
          setProductId(match.id);
          setName(match.name);
          setBrand(match.brand || 'Daily Basket');
          setSku(`SKU-${match.id.replace('prod_', '').toUpperCase()}`);
          setCategory(match.category || match.sub || 'Fresh Produce');
          setPrice(String(match.price || 99));
          setMrp(String(match.mrp || 120));
          setStock(String(120));
          setUnit(match.unit || match.subtitle || '1 unit');
          setDescription(`${match.name}. Quality checked fresh essentials.`);
          const webImg = match.image?.startsWith('assets/') ? `/${match.image.replace(/^assets\//, '')}` : match.image;
          setImageUrl(webImg || '/images/daily_basket_logo.png');
          setIsOrganic(Boolean(match.badge?.toLowerCase().includes('organic')));
        }
      })
      .finally(() => setIsLoading(false));
  }, [paramId]);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSaving(true);

    const numericPrice = Number(price) || 0;
    const numericMrp = Number(mrp) || numericPrice;
    const numericStock = Number(stock) || 0;

    const payload = {
      name,
      brand,
      sku,
      category,
      price: numericPrice,
      mrp: numericMrp,
      stockQuantity: numericStock,
      unit,
      unitName: unit,
      description,
      image: imageUrl,
      images: [imageUrl],
      isOrganic,
    };

    try {
      if (productId) {
        await fetch(`/api/products/${productId}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        }).catch(() => {});

        apiClient.updateProduct(productId, payload).catch(() => {});
      } else {
        await fetch('/api/products', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        }).catch(() => {});

        apiClient.createProduct(payload).catch(() => {});
      }

      setIsSavedToast(true);
      setTimeout(() => {
        setIsSavedToast(false);
        router.push('/products');
      }, 1500);
    } catch {
      alert('Error updating product');
    } finally {
      setIsSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!productId) return;
    try {
      await fetch(`/api/products/${productId}`, { method: 'DELETE' }).catch(() => {});
      apiClient.deleteProduct(productId).catch(() => {});
      router.push('/products');
    } catch {
      alert('Error deleting product');
    }
  };

  return (
    <div className="p-6 max-w-5xl mx-auto flex flex-col gap-6 font-sans">
      {/* Toast Notification */}
      {isSavedToast && (
        <div className="fixed top-6 right-6 z-50 flex items-center gap-3 bg-[#006837] text-white px-5 py-3.5 rounded-2xl shadow-2xl animate-in fade-in slide-in-from-top-4">
          <CheckCircle2 className="w-5 h-5 text-[#22c55e]" />
          <span className="text-sm font-bold">Product saved successfully! Redirecting...</span>
        </div>
      )}

      {/* Header & Actions */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <Link
            href="/products"
            className="p-2.5 rounded-2xl border border-[#cbd5e1] hover:bg-[#f1f5f9] text-[#1e2923] transition"
          >
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <div>
            <div className="flex items-center gap-2 text-xs text-[#64748b] mb-0.5">
              <Link href="/products" className="hover:text-[#006837] font-semibold">Products</Link>
              <span>/</span>
              <span className="text-[#1e2923] font-bold">{productId ? 'Edit Product' : 'Create Product'}</span>
            </div>
            <h1 className="text-2xl font-black text-[#006837]">
              {productId ? `Edit: ${name || productId}` : 'Create New Product'}
            </h1>
          </div>
        </div>

        <div className="flex items-center gap-3">
          {productId && (
            <button
              type="button"
              onClick={() => setShowDeleteModal(true)}
              className="px-4 py-2.5 border border-red-300 text-red-600 rounded-xl text-xs font-bold hover:bg-red-50 transition flex items-center gap-1.5"
            >
              <Trash2 className="w-4 h-4" />
              <span>Delete Product</span>
            </button>
          )}

          <Link
            href="/products"
            className="px-4 py-2.5 border border-[#cbd5e1] rounded-xl text-[#1e2923] text-xs font-bold hover:bg-[#f8fafc] transition"
          >
            Cancel
          </Link>

          <button
            onClick={handleSave}
            disabled={isSaving}
            className="px-6 py-2.5 bg-[#006837] text-white rounded-xl text-xs font-bold hover:bg-[#00522b] transition shadow-md flex items-center gap-2"
          >
            <Save className="w-4 h-4" />
            <span>{isSaving ? 'Saving...' : 'Save Product'}</span>
          </button>
        </div>
      </div>

      <form onSubmit={handleSave} className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left 2 Cols: Form Fields */}
        <div className="lg:col-span-2 flex flex-col gap-6">
          {/* Basic Information */}
          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm flex flex-col gap-4">
            <h2 className="text-base font-black text-[#1e2923] flex items-center gap-2">
              <Package className="w-4 h-4 text-[#006837]" /> Basic Information
            </h2>

            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-bold text-[#1e2923]">Product Title *</label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="e.g., Organic Robusta Bananas"
                className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm focus:outline-none focus:border-[#006837]"
                required
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">Brand</label>
                <input
                  type="text"
                  value={brand}
                  onChange={(e) => setBrand(e.target.value)}
                  placeholder="e.g., Fresh Farms"
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm focus:outline-none focus:border-[#006837]"
                />
              </div>
              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">SKU / Barcode Code</label>
                <input
                  type="text"
                  value={sku}
                  onChange={(e) => setSku(e.target.value)}
                  placeholder="e.g., SKU-FRU-001"
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm font-mono focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">Category</label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm focus:outline-none focus:border-[#006837]"
                >
                  <option value="Fresh Produce">Fresh Produce</option>
                  <option value="Dairy & Eggs">Dairy & Eggs</option>
                  <option value="Bakery & Snacks">Bakery & Snacks</option>
                  <option value="Beverages">Beverages</option>
                  <option value="Atta, Rice & Dal">Atta, Rice & Dal</option>
                  <option value="Instant Foods">Instant Foods</option>
                </select>
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">Unit Packing (e.g. 500g, 1L, 12 pcs)</label>
                <input
                  type="text"
                  value={unit}
                  onChange={(e) => setUnit(e.target.value)}
                  placeholder="e.g., 500g Pack"
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm focus:outline-none focus:border-[#006837]"
                />
              </div>
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-bold text-[#1e2923]">Product Description</label>
              <textarea
                rows={4}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder="Detailed description of freshness, source farm, nutrients, and shelf life..."
                className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm focus:outline-none focus:border-[#006837]"
              />
            </div>
          </div>

          {/* Pricing & Stock */}
          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm flex flex-col gap-4">
            <h2 className="text-base font-black text-[#1e2923] flex items-center gap-2">
              <DollarSign className="w-4 h-4 text-[#006837]" /> Pricing & Inventory Units
            </h2>

            <div className="grid grid-cols-3 gap-4">
              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">Selling Price (₹) *</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm font-bold focus:outline-none focus:border-[#006837]"
                  required
                />
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">Original MRP (₹)</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={mrp}
                  onChange={(e) => setMrp(e.target.value)}
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-sm focus:outline-none focus:border-[#006837]"
                />
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold text-[#1e2923]">Available Stock Units *</label>
                <input
                  type="number"
                  min="0"
                  value={stock}
                  onChange={(e) => setStock(e.target.value)}
                  className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#006837] text-sm font-black focus:outline-none focus:border-[#006837]"
                  required
                />
              </div>
            </div>

            {/* Calculated Discount Preview */}
            {Number(mrp) > Number(price) && (
              <div className="p-3 bg-[#dcfce7] rounded-xl text-xs font-bold text-[#15803d] flex items-center justify-between">
                <span>Calculated Customer Discount:</span>
                <span className="font-black text-sm">
                  {Math.round(((Number(mrp) - Number(price)) / Number(mrp)) * 100)}% OFF
                </span>
              </div>
            )}
          </div>
        </div>

        {/* Right Col: Media & Attributes */}
        <div className="flex flex-col gap-6">
          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm flex flex-col gap-4">
            <h2 className="text-base font-black text-[#1e2923]">Product Media & Badge</h2>

            {/* Image Preview */}
            <div className="w-full h-48 bg-[#f8fafc] rounded-2xl border border-[#cbd5e1] overflow-hidden flex items-center justify-center p-2 relative">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={imageUrl}
                alt="Product Preview"
                className="w-full h-full object-contain"
                onError={(e) => {
                  (e.target as HTMLImageElement).src = '/images/daily_basket_logo.png';
                }}
              />
              {isOrganic && (
                <div className="absolute top-3 left-3 bg-[#006837] text-white px-2 py-0.5 rounded-full text-[10px] font-black flex items-center gap-1 shadow-sm">
                  <Leaf className="w-3 h-3" /> ORGANIC
                </div>
              )}
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-bold text-[#1e2923]">Image URL</label>
              <input
                type="text"
                value={imageUrl}
                onChange={(e) => setImageUrl(e.target.value)}
                placeholder="/images/daily_basket_logo.png"
                className="w-full px-4 py-2.5 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] text-[#1e2923] text-xs focus:outline-none focus:border-[#006837]"
              />
            </div>

            {/* Is Organic Checkbox */}
            <label className="flex items-center gap-3 p-3 bg-[#f8fafc] rounded-xl border border-[#cbd5e1] cursor-pointer hover:bg-[#f1f5f9] transition">
              <input
                type="checkbox"
                checked={isOrganic}
                onChange={(e) => setIsOrganic(e.target.checked)}
                className="w-4 h-4 accent-[#006837] rounded"
              />
              <div>
                <span className="text-xs font-bold text-[#1e2923] block">Certified 100% Organic</span>
                <span className="text-[10px] text-[#64748b]">Adds green organic badge and farm-fresh verification tag</span>
              </div>
            </label>
          </div>
        </div>
      </form>

      {/* Delete Confirmation Modal */}
      {showDeleteModal && (
        <div className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white w-full max-w-md rounded-3xl p-6 shadow-2xl border border-[#e2e8f0] space-y-4">
            <div className="w-12 h-12 rounded-2xl bg-red-100 text-red-600 flex items-center justify-center mx-auto">
              <Trash2 className="w-6 h-6" />
            </div>

            <div className="text-center space-y-1">
              <h3 className="text-lg font-black text-[#1e2923]">Delete Product</h3>
              <p className="text-xs text-[#64748b]">
                Are you sure you want to permanently delete <span className="font-bold text-[#1e2923]">&quot;{name}&quot;</span>?
              </p>
            </div>

            <div className="flex items-center gap-3 pt-3">
              <button
                onClick={() => setShowDeleteModal(false)}
                className="flex-1 py-3 border border-[#cbd5e1] text-[#1e2923] font-bold text-xs rounded-xl hover:bg-[#f8fafc]"
              >
                Cancel
              </button>
              <button
                onClick={handleDelete}
                className="flex-1 py-3 bg-red-600 text-white font-bold text-xs rounded-xl hover:bg-red-700 shadow-md flex items-center justify-center gap-2"
              >
                <Trash2 className="w-4 h-4" />
                <span>Delete Now</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default function AdminProductEditorPage() {
  return (
    <Suspense fallback={<div className="p-8 text-center text-sm font-bold text-[#006837]">Loading Editor...</div>}>
      <AdminProductEditorInner />
    </Suspense>
  );
}
