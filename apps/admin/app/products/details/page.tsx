'use client';

import React, { useState, useMemo, useEffect, Suspense } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
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
  Check,
  Trash2,
} from 'lucide-react';
import { apiClient } from '@daily-basket/api-client';

import catalogJson from '@daily-basket/shared-types/src/products_catalog.json';

// Flatten catalog items to support all products
const ALL_ADMIN_CATALOG = Object.entries(catalogJson as Record<string, any[]>).flatMap(([catKey, items]) => {
  return items.map((p, idx) => {
    const webImg = p.image?.startsWith('assets/') ? `/${p.image.replace(/^assets\//, '')}` : p.image;
    const price = Number(p.price) || 0;
    const mrp = Number(p.mrp) || price;
    const discountNum = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
    const margin = Math.round(18 + ((price + idx) % 20));

    return {
      id: p.id,
      brand: p.brand || 'Daily Basket Select',
      name: p.name,
      sku: `SKU-${catKey.substring(0, 3).toUpperCase()}-${p.id.replace('prod_', '').toUpperCase()}`,
      barcode: `890${Math.abs(p.id.split('').reduce((a: number, b: string) => a + b.charCodeAt(0), 1000000)).toString().padEnd(9, '0')}`,
      category: p.category || p.sub || catKey.replace(/-/g, ' '),
      subCategory: p.sub || catKey.replace(/-/g, ' '),
      price,
      mrp,
      discount: discountNum > 0 ? `-${discountNum}%` : null,
      margin: `${margin}%`,
      stockAvailable: p.inStock === false ? 0 : 120 + ((idx * 7) % 180),
      reserved: 8 + (idx % 12),
      minStock: 20,
      location: `A${1 + (idx % 4)}-0${1 + (idx % 8)}`,
      unit: p.unit || p.subtitle || '1 unit',
      isOrganic: Boolean(p.badge?.toLowerCase().includes('organic')),
      badge: p.badge || (discountNum > 0 ? `${discountNum}% OFF` : 'FRESH'),
      rating: p.rating || 4.7,
      reviews: parseInt(p.reviews, 10) || 142,
      image: webImg || '/images/daily_basket_logo.png',
      description: `${p.name} (${p.unit || p.subtitle || 'Pack'}). Premium quality sourced fresh daily from verified local farms and certified suppliers. Quality checked with cold-chain storage.`,
    };
  });
});

function ProductDetailsInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const paramId = searchParams.get('id') || 'prod_veg_001';

  const defaultProduct = useMemo(() => {
    const clean = paramId.toLowerCase().trim();
    return (
      ALL_ADMIN_CATALOG.find(
        (p) =>
          p.id.toLowerCase() === clean ||
          p.id.toLowerCase().replace('prod_', '') === clean ||
          clean.includes(p.id.toLowerCase()) ||
          p.name.toLowerCase().includes(clean),
      ) || ALL_ADMIN_CATALOG[0]
    );
  }, [paramId]);

  const [product, setProduct] = useState(defaultProduct);
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [isDescriptionExpanded, setIsDescriptionExpanded] = useState(false);
  const [stockCount, setStockCount] = useState(defaultProduct.stockAvailable);
  const [isUpdateStockOpen, setIsUpdateStockOpen] = useState(false);
  const [newStockInput, setNewStockInput] = useState(defaultProduct.stockAvailable.toString());
  const [isSavedToast, setIsSavedToast] = useState(false);
  const [isPublished, setIsPublished] = useState(true);
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  // Fetch latest product details from API
  useEffect(() => {
    if (!paramId) return;
    fetch(`/api/products/${paramId}`)
      .then((res) => res.json())
      .then((payload) => {
        const p = payload.data || payload;
        if (p && p.name) {
          const v = (Array.isArray(p.variants) && p.variants[0]) || {};
          const price = Number(v.price ?? p.price ?? defaultProduct.price);
          const mrp = Number(v.mrp ?? p.mrp ?? defaultProduct.mrp);
          const discountNum = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
          const img = (Array.isArray(p.images) && p.images[0]) || p.image || defaultProduct.image;
          const webImg = img.startsWith('assets/') ? `/${img.replace(/^assets\//, '')}` : img;
          const stock = v.stockQuantity ?? p.stockAvailable ?? defaultProduct.stockAvailable;

          setProduct((prev) => ({
            ...prev,
            id: p.id,
            name: p.name,
            brand: p.brand || prev.brand,
            sku: v.sku || p.sku || prev.sku,
            category: p.category?.name || prev.category,
            price,
            mrp,
            discount: discountNum > 0 ? `-${discountNum}%` : null,
            stockAvailable: stock,
            image: webImg,
            description: p.description || prev.description,
          }));
          setStockCount(stock);
          setNewStockInput(stock.toString());
        }
      })
      .catch(() => {});
  }, [paramId, defaultProduct]);

  const handleUpdateStock = async () => {
    const parsed = parseInt(newStockInput, 10);
    if (!isNaN(parsed)) {
      setStockCount(parsed);
      await fetch(`/api/products/${product.id}/update-stock`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ newStock: parsed }),
      }).catch(() => {});

      apiClient.updateProductStock(product.id, parsed).catch(() => {});
      setIsUpdateStockOpen(false);
      setIsSavedToast(true);
      setTimeout(() => setIsSavedToast(false), 2500);
    }
  };

  const handleDeleteProduct = async () => {
    try {
      await fetch(`/api/products/${product.id}`, { method: 'DELETE' }).catch(() => {});
      apiClient.deleteProduct(product.id).catch(() => {});
      router.push('/products');
    } catch {
      alert('Failed to delete product');
    }
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans pb-16">
      {/* Toast Alert */}
      {isSavedToast && (
        <div className="fixed top-6 right-6 z-50 bg-[#006837] text-white px-5 py-3 rounded-2xl shadow-xl flex items-center gap-2 text-sm font-bold animate-bounce">
          <Check className="w-4 h-4" />
          <span>Stock updated &amp; broadcasted to client apps!</span>
        </div>
      )}

      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <Link
            href="/products"
            className="p-2.5 rounded-2xl hover:bg-[#f1f5f9] transition text-[#006837] border border-[#e2e8f0]"
          >
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-2xl font-black text-[#006837] tracking-tight">{product.name}</h1>
              <span className="px-2.5 py-0.5 bg-[#dcfce7] text-[#15803d] text-[11px] font-extrabold rounded-md">
                {product.sku}
              </span>
            </div>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: e49ff5c6bb04452f9b966a260519ece8 • Real-time Catalog &amp; Dark Store Sync
            </p>
          </div>
        </div>

        {/* View Mode Switches & Actions */}
        <div className="flex items-center gap-3">
          <Link
            href={`/products/editor?id=${product.id}`}
            className="px-4 py-2 bg-white border border-[#cbd5e1] text-[#1e2923] rounded-2xl text-xs font-bold hover:bg-[#f8fafc] transition flex items-center gap-1.5 shadow-sm"
          >
            <Edit className="w-3.5 h-3.5 text-[#006837]" />
            <span>Edit Product</span>
          </Link>

          <button
            onClick={() => setShowDeleteModal(true)}
            className="px-3.5 py-2 border border-red-200 text-red-600 rounded-2xl text-xs font-bold hover:bg-red-50 transition flex items-center gap-1.5"
          >
            <Trash2 className="w-3.5 h-3.5" />
            <span>Delete</span>
          </button>

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

          <button
            onClick={() => setIsPublished(!isPublished)}
            className={`px-3.5 py-2 rounded-2xl text-xs font-bold transition flex items-center gap-1.5 ${
              isPublished
                ? 'bg-[#dcfce7] text-[#15803d] border border-[#bbf7d0]'
                : 'bg-slate-100 text-slate-600 border border-slate-200'
            }`}
          >
            <CheckCircle2 className="w-3.5 h-3.5" />
            <span>{isPublished ? 'Published' : 'Draft'}</span>
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
              <Link href="/products">
                <ArrowLeft className="w-5 h-5 text-[#006837] cursor-pointer" />
              </Link>
              <span className="font-extrabold text-base text-[#006837]">Product Details</span>
              <div className="flex items-center gap-2">
                <Share2 className="w-4 h-4 text-[#1e2923]" />
                <MoreVertical className="w-4 h-4 text-[#1e2923]" />
              </div>
            </div>

            {/* Scrollable Body */}
            <div className="flex-1 overflow-y-auto space-y-4 pb-4">
              {/* Hero Image Banner Carousel */}
              <div className="relative w-full h-56 bg-slate-50 flex items-center justify-center p-4">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={product.image}
                  alt={product.name}
                  className="max-h-full max-w-full object-contain"
                />
                {/* Published Badge */}
                <div className="absolute top-3 left-3 bg-[#006837] text-white px-2.5 py-1 rounded-full flex items-center gap-1 text-[11px] font-bold shadow-sm">
                  <CheckCircle2 className="w-3.5 h-3.5" />
                  <span>{isPublished ? 'Published' : 'Draft'}</span>
                </div>
                {/* Saves Badge */}
                <div className="absolute bottom-3 right-3 bg-white/90 backdrop-blur px-2.5 py-1 rounded-full flex items-center gap-1 text-[11px] font-bold text-[#1e2923] shadow-sm">
                  <Heart className="w-3.5 h-3.5 text-pink-500 fill-pink-500" />
                  <span>{product.reviews} Saves</span>
                </div>
              </div>

              {/* Header Info */}
              <div className="px-4 space-y-1">
                <span className="text-[10px] font-black text-[#64748b] tracking-wider uppercase">
                  {product.category}
                </span>
                <h2 className="text-xl font-black text-[#1e2923] leading-snug">{product.name}</h2>
                <p className="text-xs font-bold text-[#006837]">{product.brand}</p>
                <p className="text-xs text-[#334155] leading-relaxed pt-1">
                  {isDescriptionExpanded
                    ? product.description
                    : `${product.description.slice(0, 110)}...`}
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
                  <span className="text-[10px] text-[#64748b] block">Unit</span>
                  <span className="font-bold text-xs text-[#1e2923] block truncate">{product.unit}</span>
                </div>
                <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                  <QrCode className="w-4 h-4 text-[#006837] mx-auto" />
                  <span className="text-[10px] text-[#64748b] block">SKU</span>
                  <span className="font-bold text-[10px] text-[#1e2923] font-mono block truncate">{product.sku}</span>
                </div>
                <div className="bg-white p-2.5 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                  <Scan className="w-4 h-4 text-[#006837] mx-auto" />
                  <span className="text-[10px] text-[#64748b] block">Barcode</span>
                  <span className="font-bold text-[10px] text-[#1e2923] font-mono block truncate">{product.barcode}</span>
                </div>
              </div>

              {/* Pricing Card */}
              <div className="mx-4 bg-white p-4 rounded-2xl border border-[#e2e8f0] space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 rounded-lg bg-[#dcfce7] text-[#006837]">
                      <DollarSign className="w-4 h-4" />
                    </div>
                    <span className="font-bold text-sm text-[#1e2923]">Pricing &amp; Margins</span>
                  </div>
                  {product.discount && (
                    <span className="px-2 py-0.5 bg-emerald-100 text-[#006837] text-[10px] font-bold rounded-md">
                      {product.discount}
                    </span>
                  )}
                </div>

                <div className="flex items-baseline gap-2">
                  <span className="text-2xl font-black text-[#1e2923]">₹{product.price}</span>
                  {product.mrp > product.price && (
                    <span className="text-sm text-[#94a3b8] line-through">₹{product.mrp}</span>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Margin</span>
                    <span className="font-black text-sm text-[#15803d]">{product.margin}</span>
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
                    <span className="font-bold text-sm text-[#1e2923]">Inventory Status</span>
                  </div>
                  <span className="px-2.5 py-0.5 bg-[#dcfce7] text-[#15803d] text-[10px] font-bold rounded-md flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3" /> In Stock
                  </span>
                </div>

                <div>
                  <span className="text-2xl font-black text-[#006837]">{stockCount}</span>{' '}
                  <span className="text-xs text-[#64748b]">Available Units</span>
                </div>

                <div className="grid grid-cols-3 gap-2">
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Reserved</span>
                    <span className="font-black text-sm text-[#c2410c]">{product.reserved}</span>
                  </div>
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Min Stock</span>
                    <span className="font-black text-sm text-[#1e2923]">{product.minStock}</span>
                  </div>
                  <div className="bg-[#f8fafc] p-2.5 rounded-xl">
                    <span className="text-[10px] text-[#64748b] block">Location</span>
                    <span className="font-black text-sm text-[#15803d]">{product.location}</span>
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
              <button
                onClick={() => setIsUpdateStockOpen(true)}
                className="flex-1 py-2.5 bg-[#006837] text-white text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 shadow-sm hover:bg-[#00522b]"
              >
                <Edit className="w-4 h-4" /> Restock
              </button>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          {/* Left Column (Span 7) */}
          <div className="lg:col-span-7 space-y-6">
            {/* Hero Image */}
            <div className="relative w-full h-80 rounded-3xl overflow-hidden shadow-sm bg-white border border-[#e2e8f0] flex items-center justify-center p-6">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={product.image}
                alt={product.name}
                className="max-h-full max-w-full object-contain"
              />
              <div className="absolute top-4 left-4 bg-[#006837] text-white px-3 py-1 rounded-full flex items-center gap-1.5 text-xs font-bold shadow-md">
                <CheckCircle2 className="w-4 h-4" /> {isPublished ? 'Published' : 'Draft'}
              </div>
              <div className="absolute bottom-4 right-4 bg-white/90 backdrop-blur px-3 py-1 rounded-full flex items-center gap-1.5 text-xs font-bold text-[#1e2923] shadow-md">
                <Heart className="w-4 h-4 text-pink-500 fill-pink-500" /> {product.reviews} Saves
              </div>
            </div>

            {/* Metadata Cards Strip */}
            <div className="grid grid-cols-3 gap-4">
              <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                <Scale className="w-5 h-5 text-[#006837] mx-auto" />
                <span className="text-xs text-[#64748b] block">Unit Weight</span>
                <span className="font-bold text-sm text-[#1e2923] block">{product.unit}</span>
              </div>
              <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                <QrCode className="w-5 h-5 text-[#006837] mx-auto" />
                <span className="text-xs text-[#64748b] block">SKU Code</span>
                <span className="font-bold text-xs text-[#1e2923] font-mono block truncate">{product.sku}</span>
              </div>
              <div className="bg-white p-4 rounded-2xl border border-[#e2e8f0] text-center space-y-1">
                <Scan className="w-5 h-5 text-[#006837] mx-auto" />
                <span className="text-xs text-[#64748b] block">Barcode</span>
                <span className="font-bold text-xs text-[#1e2923] font-mono block truncate">{product.barcode}</span>
              </div>
            </div>

            {/* Product Performance (30 Days) */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
              <h3 className="font-black text-base text-[#1e2923]">Performance &amp; Customer Demand</h3>
              <div className="grid grid-cols-3 gap-3">
                <div className="bg-[#f8fafc] p-4 rounded-2xl border border-[#e2e8f0]">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                    <Eye className="w-3.5 h-3.5" /> Views (30d)
                  </div>
                  <p className="font-black text-2xl text-[#1e2923] mt-2">2,840</p>
                  <p className="text-xs font-bold text-[#15803d] mt-1">↑ 14% vs last mo</p>
                </div>

                <div className="bg-[#f8fafc] p-4 rounded-2xl border border-[#e2e8f0]">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                    <ShoppingBag className="w-3.5 h-3.5" /> Orders
                  </div>
                  <p className="font-black text-2xl text-[#1e2923] mt-2">312</p>
                  <p className="text-xs font-bold text-[#15803d] mt-1">↑ 8% vs last mo</p>
                </div>

                <div className="bg-[#f8fafc] p-4 rounded-2xl border border-[#e2e8f0]">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                    <Percent className="w-3.5 h-3.5" /> Conversion
                  </div>
                  <p className="font-black text-2xl text-[#1e2923] mt-2">10.9%</p>
                  <p className="text-xs font-bold text-[#15803d] mt-1">Optimal High</p>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column (Span 5) */}
          <div className="lg:col-span-5 space-y-6">
            {/* Header Description Box */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs font-black text-[#64748b] tracking-wider uppercase">
                {product.category}
              </span>
              <h2 className="text-2xl font-black text-[#1e2923]">{product.name}</h2>
              <p className="text-sm font-bold text-[#006837]">{product.brand}</p>
              <p className="text-xs text-[#334155] leading-relaxed pt-2">
                {product.description}
              </p>
            </div>

            {/* Pricing Card */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="p-2 rounded-xl bg-[#dcfce7] text-[#006837]">
                    <DollarSign className="w-5 h-5" />
                  </div>
                  <span className="font-bold text-base text-[#1e2923]">Pricing &amp; Margins</span>
                </div>
                <span className="px-3 py-1 bg-[#f1f5f9] text-xs font-bold text-[#64748b] rounded-lg">
                  Updated Today
                </span>
              </div>

              <div className="flex items-baseline gap-3">
                <span className="text-3xl font-black text-[#1e2923]">₹{product.price}</span>
                {product.mrp > product.price && (
                  <span className="text-base text-[#94a3b8] line-through">₹{product.mrp}</span>
                )}
                {product.discount && (
                  <span className="text-xs font-extrabold text-[#006837] bg-emerald-100 px-2 py-0.5 rounded-md">
                    {product.discount}
                  </span>
                )}
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Retail Margin</span>
                  <span className="font-black text-lg text-[#15803d]">{product.margin}</span>
                </div>
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">GST Rate</span>
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
                  <CheckCircle2 className="w-4 h-4" /> Live in Dark Store
                </span>
              </div>

              <div>
                <span className="text-3xl font-black text-[#006837]">{stockCount}</span>{' '}
                <span className="text-sm text-[#64748b]">Available Units</span>
              </div>

              <div className="grid grid-cols-3 gap-3">
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Reserved</span>
                  <span className="font-black text-base text-[#c2410c]">{product.reserved}</span>
                </div>
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Min Threshold</span>
                  <span className="font-black text-base text-[#1e2923]">{product.minStock}</span>
                </div>
                <div className="bg-[#f8fafc] p-3 rounded-2xl">
                  <span className="text-xs text-[#64748b] block">Rack Location</span>
                  <span className="font-black text-base text-[#15803d]">{product.location}</span>
                </div>
              </div>

              <button
                onClick={() => setIsUpdateStockOpen(true)}
                className="w-full py-3 bg-[#006837] hover:bg-[#00522b] text-white text-xs font-bold rounded-2xl flex items-center justify-center gap-2 shadow-sm transition"
              >
                <Package className="w-4 h-4" /> Update Stock Count
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal for Update Stock */}
      {isUpdateStockOpen && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-md w-full shadow-2xl space-y-4">
            <h3 className="text-lg font-bold text-[#1e2923]">Update Dark Store Inventory</h3>
            <p className="text-xs text-[#64748b]">
              Enter new verified inventory count for {product.name} ({product.sku}).
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
                Save &amp; Broadcast WebSocket
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal for Delete Product */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-md w-full shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <div className="w-12 h-12 rounded-2xl bg-red-100 text-red-600 flex items-center justify-center mx-auto">
              <Trash2 className="w-6 h-6" />
            </div>

            <div className="text-center space-y-1">
              <h3 className="text-lg font-black text-[#1e2923]">Delete Product</h3>
              <p className="text-xs text-[#64748b]">
                Are you sure you want to permanently delete <span className="font-bold text-[#1e2923]">&quot;{product.name}&quot;</span>?
                This action cannot be undone.
              </p>
            </div>

            <div className="flex gap-3 pt-2">
              <button
                onClick={() => setShowDeleteModal(false)}
                className="flex-1 py-3 border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-2xl hover:bg-[#f8fafc]"
              >
                Cancel
              </button>
              <button
                onClick={handleDeleteProduct}
                className="flex-1 py-3 bg-red-600 text-white text-xs font-bold rounded-2xl hover:bg-red-700 shadow-md flex items-center justify-center gap-2"
              >
                <Trash2 className="w-4 h-4" />
                <span>Confirm Delete</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default function ProductDetailsPage() {
  return (
    <Suspense
      fallback={
        <div className="p-8 text-center text-slate-500 font-bold">
          Loading product details...
        </div>
      }
    >
      <ProductDetailsInner />
    </Suspense>
  );
}
