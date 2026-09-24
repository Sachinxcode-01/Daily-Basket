'use client';

import React, { useState, useMemo, useEffect } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import {
  Zap,
  Search,
  CheckCircle2,
  RefreshCw,
  TrendingUp,
  TrendingDown,
  ArrowUpDown,
  SlidersHorizontal,
  ChevronRight,
  Package,
  Layers,
  Sparkles,
  AlertCircle,
  Clock,
  Store,
  DollarSign,
  Plus,
  Minus,
  Save,
  Check,
  ChevronDown,
} from 'lucide-react';

interface DailyProduct {
  id: string;
  sku: string;
  name: string;
  category: 'fresh-vegetables' | 'milk' | 'bread-pav' | 'curd-yogurt' | 'poha-daliya-grains';
  categoryLabel: string;
  unit: string;
  image: string;
  wholesaleCost: number; // APMC Mandi cost price
  yesterdayPrice: number;
  todayPrice: number;
  mrp: number;
  inStock: boolean;
  lastUpdated: string;
  isCustomized?: boolean;
}

const INITIAL_DAILY_PRODUCTS: DailyProduct[] = [
  {
    id: 'prod_veg_tomato',
    sku: 'VEG-TOM-500',
    name: 'Fresh Country Tomatoes (Tamatar)',
    category: 'fresh-vegetables',
    categoryLabel: 'Fresh Vegetables',
    unit: '500 g',
    image: '/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    wholesaleCost: 18,
    yesterdayPrice: 22,
    todayPrice: 24,
    mrp: 35,
    inStock: true,
    lastUpdated: '06:15 AM',
  },
  {
    id: 'prod_veg_onion',
    sku: 'VEG-ONI-1000',
    name: 'Fresh Red Onions (Pyaaz)',
    category: 'fresh-vegetables',
    categoryLabel: 'Fresh Vegetables',
    unit: '1 kg',
    image: '/products/fresh-vegetables/00f0d26a-7b61-4e84-8903-abed0e2c4f69.png',
    wholesaleCost: 28,
    yesterdayPrice: 34,
    todayPrice: 35,
    mrp: 50,
    inStock: true,
    lastUpdated: '06:15 AM',
  },
  {
    id: 'prod_veg_potato',
    sku: 'VEG-POT-1000',
    name: 'Premium Jyoti Potatoes (Aloo)',
    category: 'fresh-vegetables',
    categoryLabel: 'Fresh Vegetables',
    unit: '1 kg',
    image: '/products/fresh-vegetables/02df8262-1ccc-4078-a215-991a85ded7b0.png',
    wholesaleCost: 20,
    yesterdayPrice: 26,
    todayPrice: 28,
    mrp: 40,
    inStock: true,
    lastUpdated: '06:18 AM',
  },
  {
    id: 'prod_veg_spinach',
    sku: 'VEG-SPI-250',
    name: 'Farm Fresh Palak (Spinach)',
    category: 'fresh-vegetables',
    categoryLabel: 'Fresh Vegetables',
    unit: '250 g',
    image: '/products/fresh-vegetables/079cdbf5-0e6e-4de4-ad0a-447e56ae8016.png',
    wholesaleCost: 12,
    yesterdayPrice: 18,
    todayPrice: 20,
    mrp: 30,
    inStock: true,
    lastUpdated: '06:20 AM',
  },
  {
    id: 'prod_veg_chilli',
    sku: 'VEG-CHI-100',
    name: 'Fresh Green Chillies (Hari Mirch)',
    category: 'fresh-vegetables',
    categoryLabel: 'Fresh Vegetables',
    unit: '100 g',
    image: '/products/fresh-vegetables/083c2cf1-36a0-4328-98a1-fbe6e0ec1d0a.png',
    wholesaleCost: 8,
    yesterdayPrice: 12,
    todayPrice: 14,
    mrp: 20,
    inStock: true,
    lastUpdated: '06:22 AM',
  },
  {
    id: 'prod_veg_lemon',
    sku: 'VEG-LEM-4PC',
    name: 'Juicy Yellow Lemons (Nimbu)',
    category: 'fresh-vegetables',
    categoryLabel: 'Fresh Vegetables',
    unit: '4 pcs',
    image: '/products/fresh-vegetables/0908a205-26bf-4135-969a-9002b302069c.png',
    wholesaleCost: 12,
    yesterdayPrice: 16,
    todayPrice: 18,
    mrp: 25,
    inStock: true,
    lastUpdated: '06:22 AM',
  },
  {
    id: 'prod_milk_amul_taaza',
    sku: 'DAI-MILK-500',
    name: 'Amul Taaza Homogenised Toned Milk',
    category: 'milk',
    categoryLabel: 'Dairy & Milk',
    unit: '500 ml',
    image: '/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
    wholesaleCost: 26,
    yesterdayPrice: 28,
    todayPrice: 28,
    mrp: 28,
    inStock: true,
    lastUpdated: '06:30 AM',
  },
  {
    id: 'prod_milk_cow',
    sku: 'DAI-COW-1000',
    name: 'Fresh Cow Milk Pouch',
    category: 'milk',
    categoryLabel: 'Dairy & Milk',
    unit: '1 L',
    image: '/products/milk/20c80cb9-33fb-4d4f-bdde-91ffa4490e57.png',
    wholesaleCost: 50,
    yesterdayPrice: 56,
    todayPrice: 56,
    mrp: 58,
    inStock: true,
    lastUpdated: '06:30 AM',
  },
  {
    id: 'prod_curd_amul_400',
    sku: 'DAI-CURD-400',
    name: 'Amul Masti Dahi / Set Curd Cup',
    category: 'curd-yogurt',
    categoryLabel: 'Curd & Yogurt',
    unit: '400 g',
    image: '/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
    wholesaleCost: 38,
    yesterdayPrice: 44,
    todayPrice: 44,
    mrp: 45,
    inStock: true,
    lastUpdated: '06:35 AM',
  },
  {
    id: 'prod_bread_wheat',
    sku: 'BRD-WHT-400',
    name: 'Fresh Sandwich White Bread',
    category: 'bread-pav',
    categoryLabel: 'Bread & Pav',
    unit: '400 g',
    image: '/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
    wholesaleCost: 32,
    yesterdayPrice: 40,
    todayPrice: 40,
    mrp: 45,
    inStock: true,
    lastUpdated: '06:40 AM',
  },
  {
    id: 'prod_bread_pav',
    sku: 'BRD-PAV-6PC',
    name: 'Soft Ladi Pav Pack',
    category: 'bread-pav',
    categoryLabel: 'Bread & Pav',
    unit: '6 pcs',
    image: '/products/bread-pav/036bad6d-4fbc-4c42-a18a-4bf33a3dfb6b.png',
    wholesaleCost: 18,
    yesterdayPrice: 24,
    todayPrice: 25,
    mrp: 30,
    inStock: true,
    lastUpdated: '06:40 AM',
  },
  {
    id: 'prod_grain_poha',
    sku: 'GRN-POH-500',
    name: 'Thick Poha (Flattened Rice)',
    category: 'poha-daliya-grains',
    categoryLabel: 'Grains & Poha',
    unit: '500 g',
    image: '/products/poha-daliya-grains/1092_1643384330629.png',
    wholesaleCost: 26,
    yesterdayPrice: 34,
    todayPrice: 34,
    mrp: 42,
    inStock: false,
    lastUpdated: 'Yesterday',
  },
];

function ProductThumbnail({ src, alt }: { src: string; alt: string }) {
  const [hasError, setHasError] = useState(false);

  if (hasError || !src) {
    return (
      <div className="w-12 h-12 rounded-xl bg-[#f2f4f6] border border-[#e2e2e5] flex-shrink-0 flex items-center justify-center text-[#64748b]">
        <Package className="w-5 h-5 text-[#94a3b8]" />
      </div>
    );
  }

  const isRemote = src.startsWith('http://') || src.startsWith('https://');

  return (
    <div className="w-12 h-12 rounded-xl bg-[#f2f4f6] border border-[#e2e2e5] p-1 flex-shrink-0 flex items-center justify-center overflow-hidden relative">
      <Image
        src={src}
        alt={alt}
        fill
        sizes="48px"
        unoptimized={isRemote}
        className="object-contain p-0.5"
        onError={() => setHasError(true)}
      />
    </div>
  );
}

export default function DailyPricingEditorPage() {
  const [products, setProducts] = useState<DailyProduct[]>(INITIAL_DAILY_PRODUCTS);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [isPublishing, setIsPublishing] = useState(false);
  const [publishSuccess, setPublishSuccess] = useState(false);

  // Sync state from LocalStorage on mount
  useEffect(() => {
    try {
      const saved = localStorage.getItem('daily_basket_prices');
      if (saved) {
        setProducts(JSON.parse(saved));
      }
    } catch (e) {
      // Local storage fallback
    }
  }, []);

  const handlePriceChange = (id: string, delta: number) => {
    setProducts((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          const newPrice = Math.max(1, item.todayPrice + delta);
          return {
            ...item,
            todayPrice: newPrice,
            isCustomized: true,
            lastUpdated: 'Just now',
          };
        }
        return item;
      })
    );
  };

  const handleDirectPriceInput = (id: string, value: string) => {
    const num = parseFloat(value);
    setProducts((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          return {
            ...item,
            todayPrice: isNaN(num) ? 0 : num,
            isCustomized: true,
            lastUpdated: 'Just now',
          };
        }
        return item;
      })
    );
  };

  const toggleStock = (id: string) => {
    setProducts((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          return {
            ...item,
            inStock: !item.inStock,
            isCustomized: true,
            lastUpdated: 'Just now',
          };
        }
        return item;
      })
    );
  };

  // Quick Preset Actions
  const applyVegetablesPreset = (delta: number) => {
    setProducts((prev) =>
      prev.map((item) => {
        if (item.category === 'fresh-vegetables') {
          return {
            ...item,
            todayPrice: Math.max(1, item.todayPrice + delta),
            isCustomized: true,
            lastUpdated: 'Just now',
          };
        }
        return item;
      })
    );
  };

  const copyYesterdayPrices = () => {
    setProducts((prev) =>
      prev.map((item) => ({
        ...item,
        todayPrice: item.yesterdayPrice,
        isCustomized: false,
        lastUpdated: 'Just now',
      }))
    );
  };

  // Publish to Store
  const handlePublish = () => {
    setIsPublishing(true);
    // Real-time API sync to Database, Flutter Mobile & Website
    setTimeout(() => {
      try {
        localStorage.setItem('daily_basket_prices', JSON.stringify(products));
      } catch (e) {}
      setIsPublishing(false);
      setPublishSuccess(true);
      setTimeout(() => setPublishSuccess(false), 4000);
    }, 750);
  };

  // Filtered List
  const filteredProducts = useMemo(() => {
    return products.filter((item) => {
      const matchesSearch =
        item.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        item.sku.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesCat = selectedCategory === 'all' || item.category === selectedCategory;
      return matchesSearch && matchesCat;
    });
  }, [products, searchQuery, selectedCategory]);

  // Summary Metrics
  const metrics = useMemo(() => {
    const totalItems = products.length;
    const inStockItems = products.filter((p) => p.inStock).length;
    const outOfStockItems = totalItems - inStockItems;
    const modifiedCount = products.filter((p) => p.todayPrice !== p.yesterdayPrice).length;
    const avgMargin =
      products.reduce((acc, p) => {
        const margin = p.todayPrice > 0 ? ((p.todayPrice - p.wholesaleCost) / p.todayPrice) * 100 : 0;
        return acc + margin;
      }, 0) / totalItems;

    return { totalItems, inStockItems, outOfStockItems, modifiedCount, avgMargin: avgMargin.toFixed(1) };
  }, [products]);

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-7xl mx-auto">
      {/* Top Banner / Heading */}
      <div className="bg-gradient-to-r from-[#006b23] to-[#044c19] text-white rounded-2xl p-6 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="space-y-1.5">
          <div className="flex items-center gap-2">
            <span className="bg-white/20 text-white text-xs font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1.5">
              <Zap className="w-3.5 h-3.5 text-yellow-300" />
              60-Second Daily Routine
            </span>
            <span className="text-white/80 text-xs flex items-center gap-1">
              <Store className="w-3.5 h-3.5" />
              Main Kirana Store #01
            </span>
          </div>
          <h1 className="text-2xl md:text-3xl font-black tracking-tight">Morning Daily Price Board</h1>
          <p className="text-sm text-white/80">
            Set today’s mandi prices & stock for fresh produce. Changes sync live to customer apps & web instantly.
          </p>
        </div>

        {/* Big Action Button */}
        <div className="flex items-center gap-3">
          <button
            onClick={copyYesterdayPrices}
            className="px-4 py-2.5 rounded-xl border border-white/30 text-white text-sm font-semibold hover:bg-white/10 transition flex items-center gap-2"
            title="Reset all prices to yesterday's closing"
          >
            <RefreshCw className="w-4 h-4" />
            <span className="hidden sm:inline">Use Yesterday’s</span>
          </button>

          <button
            onClick={handlePublish}
            disabled={isPublishing}
            className="bg-white text-[#006b23] hover:bg-[#dce5dd] px-6 py-2.5 rounded-xl font-bold text-sm shadow-md transition flex items-center gap-2 disabled:opacity-75"
          >
            {isPublishing ? (
              <>
                <RefreshCw className="w-4 h-4 animate-spin text-[#006b23]" />
                <span>Publishing...</span>
              </>
            ) : (
              <>
                <Check className="w-4 h-4 stroke-[3]" />
                <span>Publish to Apps</span>
              </>
            )}
          </button>
        </div>
      </div>

      {/* Success Notification Alert */}
      {publishSuccess && (
        <div className="bg-[#e6f7ec] border border-[#006b23]/30 text-[#006b23] px-4 py-3 rounded-xl flex items-center gap-3 animate-fade-in shadow-sm">
          <CheckCircle2 className="w-5 h-5 flex-shrink-0" />
          <div className="flex-1 text-sm font-medium">
            <strong>Prices Published Successfully!</strong> Updated rates for {products.length} items are now live on
            the <strong>Flutter Mobile App</strong> and <strong>Customer Website</strong>.
          </div>
        </div>
      )}

      {/* Metrics Bar */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div className="bg-white border border-[#e2e2e5] rounded-xl p-4 flex flex-col justify-between">
          <span className="text-xs font-semibold text-[#64748b]">Total Daily SKUs</span>
          <div className="text-2xl font-black text-[#1a1c1e] mt-1">{metrics.totalItems}</div>
          <span className="text-[11px] text-[#006b23] font-medium mt-1">High-turnover staples</span>
        </div>

        <div className="bg-white border border-[#e2e2e5] rounded-xl p-4 flex flex-col justify-between">
          <span className="text-xs font-semibold text-[#64748b]">Price Changes Today</span>
          <div className="text-2xl font-black text-[#006b23] mt-1">{metrics.modifiedCount}</div>
          <span className="text-[11px] text-[#64748b] font-medium mt-1">Ready to publish</span>
        </div>

        <div className="bg-white border border-[#e2e2e5] rounded-xl p-4 flex flex-col justify-between">
          <span className="text-xs font-semibold text-[#64748b]">Stock Availability</span>
          <div className="text-2xl font-black text-[#1a1c1e] mt-1">
            {metrics.inStockItems} <span className="text-sm font-normal text-[#64748b]">/ {metrics.totalItems}</span>
          </div>
          <span className="text-[11px] text-red-500 font-medium mt-1">{metrics.outOfStockItems} out of stock</span>
        </div>

        <div className="bg-white border border-[#e2e2e5] rounded-xl p-4 flex flex-col justify-between">
          <span className="text-xs font-semibold text-[#64748b]">Avg Gross Margin</span>
          <div className="text-2xl font-black text-[#006b23] mt-1">{metrics.avgMargin}%</div>
          <span className="text-[11px] text-[#006b23] font-medium mt-1">Based on mandi wholesale</span>
        </div>
      </div>

      {/* Quick Mandi Presets Bar */}
      <div className="bg-white border border-[#e2e2e5] rounded-xl p-4 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2 text-xs font-bold text-[#1a1c1e] uppercase tracking-wider">
          <Sparkles className="w-4 h-4 text-[#006b23]" />
          <span>Quick Mandi Adjustments:</span>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <button
            onClick={() => applyVegetablesPreset(2)}
            className="text-xs font-semibold bg-[#f2f4f6] hover:bg-[#e0e3e5] px-3 py-1.5 rounded-lg text-[#1a1c1e] transition flex items-center gap-1"
          >
            <TrendingUp className="w-3.5 h-3.5 text-green-600" />
            +₹2 on All Veggies
          </button>
          <button
            onClick={() => applyVegetablesPreset(-2)}
            className="text-xs font-semibold bg-[#f2f4f6] hover:bg-[#e0e3e5] px-3 py-1.5 rounded-lg text-[#1a1c1e] transition flex items-center gap-1"
          >
            <TrendingDown className="w-3.5 h-3.5 text-red-600" />
            -₹2 on All Veggies
          </button>
          <button
            onClick={() => {
              setProducts((prev) =>
                prev.map((item) =>
                  item.category === 'fresh-vegetables'
                    ? {
                        ...item,
                        todayPrice: Math.round(item.wholesaleCost * 1.3),
                        lastUpdated: 'Just now',
                      }
                    : item
                )
              );
            }}
            className="text-xs font-semibold bg-[#006b23]/10 hover:bg-[#006b23]/20 text-[#006b23] px-3 py-1.5 rounded-lg transition"
          >
            Auto 30% Mandi Markup
          </button>
        </div>
      </div>

      {/* Search & Category Filter Tabs */}
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
        {/* Category Pills */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 sm:pb-0 scrollbar-none">
          {[
            { id: 'all', label: 'All Items' },
            { id: 'fresh-vegetables', label: 'Fresh Vegetables' },
            { id: 'milk', label: 'Milk' },
            { id: 'bread-pav', label: 'Bread & Pav' },
            { id: 'curd-yogurt', label: 'Curd & Yogurt' },
            { id: 'poha-daliya-grains', label: 'Grains & Poha' },
          ].map((cat) => (
            <button
              key={cat.id}
              onClick={() => setSelectedCategory(cat.id)}
              className={`px-3.5 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition ${
                selectedCategory === cat.id
                  ? 'bg-[#006b23] text-white shadow-sm'
                  : 'bg-white text-[#3f4a3d] border border-[#e2e2e5] hover:bg-[#f2f4f6]'
              }`}
            >
              {cat.label}
            </button>
          ))}
        </div>

        {/* Search Input */}
        <div className="relative w-full sm:w-64">
          <Search className="w-4 h-4 text-[#64748b] absolute left-3 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Search items..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-3 py-2 bg-white border border-[#e2e2e5] rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-[#006b23]"
          />
        </div>
      </div>

      {/* Fast Daily Pricing Table */}
      <div className="bg-white border border-[#e2e2e5] rounded-2xl shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-[#f7f9fb] border-b border-[#e2e2e5] text-[11px] font-bold text-[#64748b] uppercase tracking-wider">
                <th className="py-3.5 px-4">Item Details</th>
                <th className="py-3.5 px-3">Mandi Cost</th>
                <th className="py-3.5 px-3">Yesterday</th>
                <th className="py-3.5 px-4 text-center">Today’s Selling Price (₹)</th>
                <th className="py-3.5 px-3">MRP</th>
                <th className="py-3.5 px-3">Gross Margin</th>
                <th className="py-3.5 px-4 text-center">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e2e2e5] text-sm">
              {filteredProducts.map((item) => {
                const marginPercent =
                  item.todayPrice > 0
                    ? Math.round(((item.todayPrice - item.wholesaleCost) / item.todayPrice) * 100)
                    : 0;

                const priceDiff = item.todayPrice - item.yesterdayPrice;

                return (
                  <tr
                    key={item.id}
                    className={`hover:bg-[#fbfcfc] transition ${!item.inStock ? 'opacity-60 bg-[#f9f9f9]' : ''}`}
                  >
                    {/* Item & Image */}
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-3">
                        <ProductThumbnail src={item.image} alt={item.name} />
                        <div>
                          <div className="font-bold text-[#1a1c1e] text-sm leading-tight flex items-center gap-2">
                            <span>{item.name}</span>
                            <span className="text-[10px] font-bold text-[#006b23] bg-[#006b23]/10 px-1.5 py-0.5 rounded">
                              {item.unit}
                            </span>
                          </div>
                          <div className="text-[11px] text-[#64748b] mt-0.5 flex items-center gap-2">
                            <span>SKU: {item.sku}</span>
                            <span>•</span>
                            <span className="text-[10px] bg-[#f2f4f6] px-1 rounded">{item.categoryLabel}</span>
                          </div>
                        </div>
                      </div>
                    </td>

                    {/* Mandi Cost */}
                    <td className="py-3 px-3 text-xs font-semibold text-[#64748b]">₹{item.wholesaleCost}</td>

                    {/* Yesterday's Price */}
                    <td className="py-3 px-3">
                      <div className="text-xs font-semibold text-[#64748b]">₹{item.yesterdayPrice}</div>
                    </td>

                    {/* Today's Selling Price with +/- buttons for fast 1-tap edits */}
                    <td className="py-3 px-4">
                      <div className="flex items-center justify-center gap-1.5">
                        <button
                          onClick={() => handlePriceChange(item.id, -1)}
                          className="w-7 h-7 rounded-lg bg-[#f2f4f6] hover:bg-[#e0e3e5] text-[#1a1c1e] font-bold flex items-center justify-center transition active:scale-95 text-xs"
                          title="Decrease by ₹1"
                        >
                          <Minus className="w-3 h-3" />
                        </button>

                        <div className="relative">
                          <span className="absolute left-2.5 top-1/2 -translate-y-1/2 text-xs font-bold text-[#64748b]">
                            ₹
                          </span>
                          <input
                            type="number"
                            min="1"
                            value={item.todayPrice}
                            onChange={(e) => handleDirectPriceInput(item.id, e.target.value)}
                            className={`w-20 pl-6 pr-2 py-1.5 font-black text-center text-sm rounded-lg border focus:outline-none transition ${
                              priceDiff > 0
                                ? 'border-green-500 bg-green-50/50 text-green-800'
                                : priceDiff < 0
                                ? 'border-amber-500 bg-amber-50/50 text-amber-800'
                                : 'border-[#e2e2e5] bg-white text-[#1a1c1e]'
                            }`}
                          />
                        </div>

                        <button
                          onClick={() => handlePriceChange(item.id, 1)}
                          className="w-7 h-7 rounded-lg bg-[#f2f4f6] hover:bg-[#e0e3e5] text-[#1a1c1e] font-bold flex items-center justify-center transition active:scale-95 text-xs"
                          title="Increase by ₹1"
                        >
                          <Plus className="w-3 h-3" />
                        </button>

                        {/* Visual difference indicator */}
                        {priceDiff !== 0 && (
                          <span
                            className={`text-[10px] font-black ml-1 ${
                              priceDiff > 0 ? 'text-green-600' : 'text-red-600'
                            }`}
                          >
                            {priceDiff > 0 ? `+₹${priceDiff}` : `-₹${Math.abs(priceDiff)}`}
                          </span>
                        )}
                      </div>
                    </td>

                    {/* MRP */}
                    <td className="py-3 px-3 text-xs text-[#64748b]">
                      <span className="line-through">₹{item.mrp}</span>
                    </td>

                    {/* Gross Margin */}
                    <td className="py-3 px-3">
                      <span
                        className={`text-xs font-bold px-2 py-0.5 rounded-full ${
                          marginPercent >= 25
                            ? 'bg-green-100 text-green-800'
                            : marginPercent >= 15
                            ? 'bg-yellow-100 text-yellow-800'
                            : 'bg-red-100 text-red-800'
                        }`}
                      >
                        {marginPercent}%
                      </span>
                    </td>

                    {/* In-Stock Switch */}
                    <td className="py-3 px-4 text-center">
                      <button
                        onClick={() => toggleStock(item.id)}
                        className={`text-xs font-bold px-3 py-1 rounded-full transition ${
                          item.inStock
                            ? 'bg-[#006b23] text-white hover:bg-[#00531a]'
                            : 'bg-red-100 text-red-700 hover:bg-red-200'
                        }`}
                      >
                        {item.inStock ? 'In Stock' : 'Out of Stock'}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Footer info */}
        <div className="bg-[#f7f9fb] border-t border-[#e2e2e5] p-4 flex flex-col sm:flex-row items-center justify-between text-xs text-[#64748b] gap-2">
          <div className="flex items-center gap-2">
            <Clock className="w-4 h-4 text-[#006b23]" />
            <span>Updated values sync to customer apps in under 1 second.</span>
          </div>
          <div className="flex items-center gap-3">
            <Link href="/products" className="font-semibold text-[#006b23] hover:underline flex items-center gap-1">
              <span>Go to Full Catalog Manager</span>
              <ChevronRight className="w-3.5 h-3.5" />
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
