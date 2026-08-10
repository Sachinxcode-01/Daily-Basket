// Google Stitch Screen ID: dc03d5c76b814f639becc038ad8805bb
// Title: Daily Basket - Premium Home Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';

import Link from 'next/link';
import Image from 'next/image';
import { formatCurrency } from '@daily-basket/shared-utils';
import HeaderNavBar from '../components/navigation/HeaderNavBar';

interface Product {
  id: string;
  name: string;
  brand: string;
  unitName: string;
  price: number;
  mrp: number;
  rating: number;
  reviews: number;
  category: string;
  tag?: string;
  image: string;
}

const catalog: Product[] = [
  // Dairy
  { id: 'mlk1', name: 'Full Cream Milk', brand: 'Amul', unitName: '1 L Pouch', price: 64, mrp: 68, rating: 4.7, reviews: 8420, category: 'Dairy', tag: 'Bestseller', image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&q=80' },
  { id: 'mlk2', name: 'Toned Milk', brand: 'Mother Dairy', unitName: '500 ml Pouch', price: 30, mrp: 32, rating: 4.6, reviews: 6210, category: 'Dairy', image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500&q=80' },
  { id: 'mlk3', name: 'Double Toned Milk', brand: 'Nandini', unitName: '1 L Pouch', price: 54, mrp: 58, rating: 4.5, reviews: 3120, category: 'Dairy', image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&q=80' },
  { id: 'mlk4', name: 'Organic Cow Milk', brand: 'Akshayakalpa', unitName: '500 ml Bottle', price: 46, mrp: 50, rating: 4.8, reviews: 2890, category: 'Dairy', tag: 'Organic', image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500&q=80' },
  { id: 'crd1', name: 'Set Curd Cup', brand: 'Amul', unitName: '400 g Cup', price: 42, mrp: 45, rating: 4.6, reviews: 5340, category: 'Dairy', image: 'https://images.unsplash.com/photo-1571512599285-9b05c2b06e99?w=500&q=80' },
  { id: 'lsi1', name: 'Sweet Lassi Bottle', brand: 'Amul', unitName: '200 ml Bottle', price: 25, mrp: 28, rating: 4.7, reviews: 4120, category: 'Dairy', image: 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=500&q=80' },

  // Beverages
  { id: 'tea1', name: 'Brooke Bond Red Label Tea', brand: 'Red Label', unitName: '500 g Pack', price: 198, mrp: 210, rating: 4.8, reviews: 12400, category: 'Beverages', tag: 'Top Rated', image: 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=500&q=80' },
  { id: 'tea2', name: 'Taj Mahal Natural Care Tea', brand: 'Taj Mahal', unitName: '250 g Pack', price: 138, mrp: 150, rating: 4.7, reviews: 9800, category: 'Beverages', image: 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=500&q=80' },
  { id: 'tea3', name: 'Masala Tea Powder', brand: 'Wagh Bakri', unitName: '250 g Pack', price: 115, mrp: 125, rating: 4.6, reviews: 7300, category: 'Beverages', image: 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=500&q=80' },
  { id: 'tea4', name: 'Green Tea Bags', brand: 'Tata Gold', unitName: '100 g Pack', price: 89, mrp: 99, rating: 4.5, reviews: 5210, category: 'Beverages', image: 'https://images.unsplash.com/photo-1564890369478-c89ca3d9cde4?w=500&q=80' },

  // Confectionery
  { id: 'chc1', name: 'Dairy Milk Silk Bar', brand: 'Cadbury', unitName: '150 g Bar', price: 155, mrp: 170, rating: 4.8, reviews: 15600, category: 'Confectionery', tag: 'Trending', image: 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=500&q=80' },
  { id: 'chc2', name: 'KitKat 4 Finger Bar', brand: 'Nestle', unitName: '41.5 g Bar', price: 30, mrp: 35, rating: 4.7, reviews: 11200, category: 'Confectionery', image: 'https://images.unsplash.com/photo-1526081347589-7fa3cb41d55b?w=500&q=80' },
  { id: 'chc3', name: '5 Star Chocolate Bar', brand: 'Cadbury', unitName: '42 g Bar', price: 30, mrp: 35, rating: 4.6, reviews: 9300, category: 'Confectionery', image: 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=500&q=80' },

  // Personal Care
  { id: 'shp1', name: 'Anti-Dandruff Shampoo', brand: 'Head & Shoulders', unitName: '340 ml Bottle', price: 265, mrp: 295, rating: 4.5, reviews: 18900, category: 'Personal Care', image: 'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=500&q=80' },
  { id: 'shp2', name: 'Intense Damage Repair Shampoo', brand: 'Dove', unitName: '340 ml Bottle', price: 272, mrp: 295, rating: 4.6, reviews: 14300, category: 'Personal Care', image: 'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=500&q=80' },
  { id: 'sop1', name: 'Dettol Original Soap', brand: 'Dettol', unitName: '75g x 4 Pack', price: 115, mrp: 128, rating: 4.7, reviews: 21000, category: 'Personal Care', tag: 'Essential', image: 'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=500&q=80' },
  { id: 'sop2', name: 'Dove Cream Beauty Bar', brand: 'Dove', unitName: '100 g Bar', price: 54, mrp: 60, rating: 4.7, reviews: 18400, category: 'Personal Care', image: 'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=500&q=80' },

  // Household
  { id: 'wsh1', name: 'Surf Excel Easy Wash', brand: 'Surf Excel', unitName: '1 kg Pack', price: 155, mrp: 172, rating: 4.6, reviews: 24500, category: 'Household', tag: 'Popular', image: 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=500&q=80' },
  { id: 'wsh2', name: 'Ariel Complete Powder', brand: 'Ariel', unitName: '1 kg Pack', price: 165, mrp: 185, rating: 4.7, reviews: 19800, category: 'Household', image: 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=500&q=80' },

  // Staples
  { id: 'att1', name: 'Chakki Fresh Atta', brand: 'Aashirvaad', unitName: '5 kg Bag', price: 242, mrp: 265, rating: 4.7, reviews: 28900, category: 'Staples', tag: 'Staple', image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=500&q=80' },
  { id: 'dal1', name: 'Unpolished Toor Dal', brand: 'Tata Sampann', unitName: '1 kg Pack', price: 145, mrp: 160, rating: 4.6, reviews: 14300, category: 'Staples', image: 'https://images.unsplash.com/photo-1546548970-71785318a17b?w=500&q=80' },

  // Oil & Spices
  { id: 'oil1', name: 'Parachute Pure Coconut Oil', brand: 'Parachute', unitName: '500 ml Jar', price: 188, mrp: 210, rating: 4.8, reviews: 32400, category: 'Oil', tag: 'Original', image: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500&q=80' },
  { id: 'msl1', name: 'MDH Garam Masala', brand: 'MDH', unitName: '100 g Pack', price: 78, mrp: 88, rating: 4.7, reviews: 22400, category: 'Spices', image: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500&q=80' },

  // Stationery
  { id: 'stn1', name: 'HB Pencils 10 pcs Set', brand: 'Apsara', unitName: '10 Pencils Pack', price: 38, mrp: 45, rating: 4.5, reviews: 8900, category: 'Stationery', image: 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=500&q=80' },
  { id: 'stn3', name: 'Colour Pencils 24 Shades', brand: 'Camlin', unitName: '24 pcs Tin Box', price: 125, mrp: 140, rating: 4.7, reviews: 11800, category: 'Stationery', image: 'https://images.unsplash.com/photo-1607344645866-009c320b63e0?w=500&q=80' },
];

const categoryList = ['All', 'Dairy', 'Beverages', 'Confectionery', 'Personal Care', 'Household', 'Staples', 'Oil', 'Spices', 'Stationery'];

export default function HomePage() {
  const [cartItems, setCartItems] = useState<Record<string, number>>({ mlk1: 1, tea1: 1, crd1: 2 });
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [isCartOpen, setIsCartOpen] = useState(false);
  const [couponCode, setCouponCode] = useState('');
  const [appliedCoupon, setAppliedCoupon] = useState<string | null>(null);

  const updateQty = (id: string, delta: number) => {
    setCartItems((prev) => {
      const current = prev[id] || 0;
      const updated = Math.max(0, current + delta);
      if (updated === 0) {
        const { [id]: _, ...rest } = prev;
        return rest;
      }
      return { ...prev, [id]: updated };
    });
  };

  const filteredProducts = catalog.filter((p) => {
    const matchesCat = selectedCategory === 'All' || p.category === selectedCategory;
    const matchesSearch = searchQuery === '' || p.name.toLowerCase().includes(searchQuery.toLowerCase()) || p.brand.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCat && matchesSearch;
  });

  const totalCartCount = Object.values(cartItems).reduce((a, b) => a + b, 0);

  const cartSubtotal = Object.entries(cartItems).reduce((sum, [id, qty]) => {
    const prod = catalog.find((p) => p.id === id);
    return sum + (prod ? prod.price * qty : 0);
  }, 0);

  const deliveryFee = cartSubtotal >= 199 || cartSubtotal === 0 ? 0 : 25;
  const couponDiscount = appliedCoupon === 'DAILY50' ? Math.min(50, cartSubtotal) : 0;
  const grandTotal = Math.max(0, cartSubtotal + deliveryFee - couponDiscount);

  return (
    <div className="min-h-screen bg-background text-on-background font-body-lg antialiased pb-24 relative">

      {/* ─── Sticky Header Navbar ─────────────────────────────────────────── */}
      <HeaderNavBar
        cartCount={totalCartCount}
        onSearch={(q) => setSearchQuery(q)}
        onCartClick={() => setIsCartOpen(true)}
      />

      {/* ─── Main Desktop Storefront Canvas (1440px max) ───────────────────── */}
      <main className="max-w-[1440px] mx-auto px-margin-mobile md:px-margin-desktop space-y-12 pt-6">

        {/* ─── Live Order Tracker Alert Strip ─────────────────────────────── */}
        <section className="bg-gradient-to-r from-emerald-900 to-[#006b23] text-white rounded-2xl p-4 shadow-level-1 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center text-xl animate-pulse">
              🛵
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xs font-extrabold uppercase tracking-wider bg-emerald-400 text-emerald-950 px-2 py-0.5 rounded-full">
                  LIVE ORDER #DB-88294
                </span>
                <span className="text-xs text-emerald-200">ETA: 4 Mins</span>
              </div>
              <p className="text-sm font-semibold font-outfit mt-0.5">
                Rider Rajesh is 450 meters away from your door • Koramangala 4th Block
              </p>
            </div>
          </div>
          <Link href="/tracking" className="bg-white text-[#006b23] font-bold text-xs px-5 py-2.5 rounded-full hover:bg-emerald-50 transition-all shadow-md">
            Track Live Map →
          </Link>
        </section>

        {/* ─── Hero Section ────────────────────────────────────────────────── */}
        <section className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          
          {/* Main Hero Card with full-card background image */}
          <div className="lg:col-span-8 rounded-3xl p-8 sm:p-10 shadow-level-2 relative overflow-hidden min-h-[340px] flex items-center">
            
            {/* Full Card Background Image */}
            <Image
              src="/illustrations/web_hero_banner_3d.png"
              alt="Fresh Produce Background"
              fill
              unoptimized
              className="object-cover object-right z-0 transform hover:scale-105 transition-transform duration-700"
            />

            {/* Dark Green Gradient Overlay for crisp text contrast */}
            <div className="absolute inset-0 bg-gradient-to-r from-[#006b23] via-[#006b23]/90 sm:via-[#006b23]/80 to-[#006b23]/40 sm:to-transparent z-0" />

            {/* Hero Card Content */}
            <div className="space-y-4 max-w-lg text-center sm:text-left z-10 relative">
              <span className="inline-block px-3.5 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider text-white shadow-sm border border-white/20">
                🥬 FARM FRESH PRODUCE & KIRANA
              </span>
              <h1 className="text-3xl sm:text-5xl font-extrabold font-outfit leading-tight text-white drop-shadow-sm">
                Delivered in <span className="text-emerald-300">10 Mins</span>
              </h1>
              <p className="text-white/95 text-xs sm:text-sm font-inter leading-relaxed max-w-md drop-shadow-sm">
                Directly harvested from local organic farms to your doorstep. Unbeatable prices & 100% fresh guarantee.
              </p>
              <div className="pt-2 flex flex-wrap gap-3 justify-center sm:justify-start">
                <button
                  onClick={() => setSelectedCategory('Dairy')}
                  className="bg-white text-[#006b23] font-bold text-xs px-6 py-3 rounded-full hover:bg-emerald-50 transition-all shadow-lg active:scale-95"
                >
                  Shop Fresh Milk & Dairy
                </button>
                <Link
                  href="/freshness"
                  className="bg-black/30 hover:bg-black/40 backdrop-blur-md text-white font-medium text-xs px-5 py-3 rounded-full transition-all border border-white/30 shadow-md"
                >
                  Trace Harvest Origin →
                </Link>
              </div>
            </div>
          </div>

          {/* Quick Buy Essentials + DB Plus Pass Card */}
          <div className="lg:col-span-4 flex flex-col justify-between gap-6">
            
            {/* DB Plus VIP Pass Banner */}
            <div className="bg-gradient-to-br from-amber-500 via-amber-600 to-amber-700 text-white rounded-3xl p-6 shadow-level-2 relative overflow-hidden flex flex-col justify-between">
              <div className="flex justify-between items-start">
                <div>
                  <span className="bg-black/20 text-amber-100 font-extrabold text-[10px] uppercase px-2.5 py-1 rounded-full tracking-wider">
                    DAILY BASKET PLUS VIP
                  </span>
                  <h3 className="text-2xl font-bold font-outfit mt-2">Unlimited Free Delivery</h3>
                </div>
                <span className="text-3xl">👑</span>
              </div>
              <p className="text-amber-100 text-xs font-inter mt-2">
                Save up to ₹450 every month. Get priority picking, zero surge fees, & exclusive 15% cashback.
              </p>
              <Link href="/loyalty" className="mt-4 bg-white text-amber-900 text-xs font-bold px-4 py-2.5 rounded-full text-center hover:bg-amber-50 transition-colors shadow-md">
                Try 30 Days Free →
              </Link>
            </div>

            {/* Quick Buy Card */}
            <div className="bg-surface-container-low rounded-3xl p-6 border border-outline-variant/20 flex flex-col justify-between">
              <div className="flex justify-between items-center mb-3">
                <h4 className="font-bold text-sm font-outfit text-on-surface flex items-center gap-1.5">
                  <span>⚡</span> 1-Tap Quick Buy Essentials
                </h4>
                <Link href="/cart" className="text-xs text-primary font-bold hover:underline">Reorder All</Link>
              </div>
              <div className="flex items-center gap-3 bg-surface-container-lowest p-3 rounded-2xl border border-outline-variant/10 shadow-sm">
                <Image src={catalog[0].image} alt="Milk" width={48} height={48} unoptimized className="w-12 h-12 rounded-xl object-cover" />
                <div className="flex-1 min-w-0">
                  <div className="text-xs font-bold truncate">{catalog[0].name}</div>
                  <div className="text-[10px] text-on-surface-variant">{catalog[0].brand} • {catalog[0].unitName}</div>
                  <div className="text-xs font-bold text-primary mt-0.5">{formatCurrency(catalog[0].price)}</div>
                </div>
                <button
                  onClick={() => updateQty(catalog[0].id, 1)}
                  className="bg-primary text-white text-xs font-bold px-3 py-1.5 rounded-full hover:bg-surface-tint active:scale-95 transition-all"
                >
                  + Add
                </button>
              </div>
            </div>

          </div>
        </section>

        {/* ─── My Impact & Sustainability Section ────────────────────────────── */}
        <section className="bg-emerald-950 text-white rounded-3xl p-6 sm:p-8 shadow-level-2 border border-emerald-800">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6 mb-6">
            <div>
              <span className="text-xs font-extrabold uppercase tracking-wider text-emerald-400 bg-emerald-900/60 px-3 py-1 rounded-full">
                🌱 MY SUSTAINABILITY IMPACT
              </span>
              <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-white mt-2">
                Your Eco-Friendly Shopping Impact
              </h2>
            </div>
            <Link href="/about" className="text-xs text-emerald-300 font-bold hover:underline flex items-center gap-1">
              Learn about our 100% Organic Supply Chain →
            </Link>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">🚴</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">14.2 kg</div>
              <div className="text-xs text-emerald-200 font-medium">CO2 Emissions Saved</div>
            </div>
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">🛍️</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">3.8 kg</div>
              <div className="text-xs text-emerald-200 font-medium">Plastic Waste Reduced</div>
            </div>
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">👩‍🌾</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">18 Farms</div>
              <div className="text-xs text-emerald-200 font-medium">Local Farmers Supported</div>
            </div>
            <div className="bg-emerald-900/40 border border-emerald-800 rounded-2xl p-4 text-center">
              <span className="text-2xl">🎖️</span>
              <div className="text-xl sm:text-2xl font-bold text-emerald-300 font-outfit mt-1">Tier 3 Eco</div>
              <div className="text-xs text-emerald-200 font-medium">Sustainability Badge</div>
            </div>
          </div>
        </section>

        {/* ─── Kirana & Essentials Storefront Catalog ─────────────────────── */}
        <section className="space-y-6">
          
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl sm:text-3xl font-bold font-outfit text-on-surface">
                Kirana & Daily Essentials Catalog
              </h2>
              <p className="text-xs sm:text-sm text-on-surface-variant">
                Showing {filteredProducts.length} items from leading Indian Kirana brands
              </p>
            </div>

            {/* Category Filter Pills */}
            <div className="flex items-center gap-2 overflow-x-auto scrollbar-none pb-2 max-w-full">
              {categoryList.map((cat) => {
                const isSelected = selectedCategory === cat;
                return (
                  <button
                    key={cat}
                    onClick={() => setSelectedCategory(cat)}
                    className={`text-xs font-bold px-4 py-2 rounded-full whitespace-nowrap transition-all duration-200 ${
                      isSelected
                        ? 'bg-primary text-white shadow-sm scale-105'
                        : 'bg-surface-container-lowest text-on-surface-variant hover:bg-surface-container-low border border-outline-variant/20'
                    }`}
                  >
                    {cat}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Product Grid (Responsive: 2-col mobile, 3-col tablet, 4-col laptop, 5-col desktop, 6-col wide) */}
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4 sm:gap-5">
            {filteredProducts.map((p) => {
              const qty = cartItems[p.id] || 0;
              return (
                <div
                  key={p.id}
                  className="bg-surface-container-lowest border border-outline-variant/20 rounded-2xl p-3.5 flex flex-col justify-between hover:shadow-level-2 transition-all duration-300 group relative"
                >
                  {/* Tag badge */}
                  {p.tag && (
                    <span className="absolute top-3 left-3 z-10 bg-primary text-on-primary text-[10px] font-bold px-2 py-0.5 rounded-full shadow-sm">
                      {p.tag}
                    </span>
                  )}

                  <div>
                    {/* Image */}
                    <div className="relative w-full aspect-square bg-surface-container-low rounded-xl overflow-hidden mb-3">
                      <Image
                        src={p.image}
                        alt={p.name}
                        fill
                        unoptimized
                        className="object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                    </div>

                    {/* Details */}
                    <div className="text-[10px] font-bold text-primary uppercase tracking-wider">{p.brand}</div>
                    <h3 className="font-title-md text-xs sm:text-sm font-bold text-on-surface leading-tight mt-0.5 line-clamp-2" style={{ fontFamily: 'Outfit' }}>
                      {p.name}
                    </h3>
                    <div className="text-[10px] text-on-surface-variant mt-1">{p.unitName}</div>

                    {/* Rating */}
                    <div className="flex items-center gap-1 mt-1.5">
                      <span className="text-amber-500 text-xs">★</span>
                      <span className="text-xs font-bold text-on-surface">{p.rating}</span>
                      <span className="text-[10px] text-on-surface-variant">({(p.reviews / 1000).toFixed(1)}k)</span>
                    </div>
                  </div>

                  {/* Price & Add */}
                  <div className="mt-3 pt-2.5 border-t border-outline-variant/10 flex items-center justify-between">
                    <div>
                      <div className="font-title-md text-sm sm:text-base text-primary font-bold" style={{ fontFamily: 'Outfit' }}>
                        {formatCurrency(p.price)}
                      </div>
                      {p.mrp > p.price && (
                        <div className="text-[10px] text-on-surface-variant line-through">
                          {formatCurrency(p.mrp)}
                        </div>
                      )}
                    </div>

                    {qty === 0 ? (
                      <button
                        onClick={() => updateQty(p.id, 1)}
                        className="px-3 py-1.5 bg-primary text-white text-xs font-bold rounded-full hover:bg-surface-tint active:scale-95 transition-all shadow-sm"
                      >
                        + Add
                      </button>
                    ) : (
                      <div className="flex items-center gap-1.5 bg-primary/10 border border-primary/20 rounded-full px-1.5 py-0.5">
                        <button
                          onClick={() => updateQty(p.id, -1)}
                          className="w-5 h-5 rounded-full bg-primary text-white font-bold flex items-center justify-center text-xs hover:bg-surface-tint"
                        >
                          −
                        </button>
                        <span className="text-xs font-bold text-primary min-w-[14px] text-center">
                          {qty}
                        </span>
                        <button
                          onClick={() => updateQty(p.id, 1)}
                          className="w-5 h-5 rounded-full bg-primary text-white font-bold flex items-center justify-center text-xs hover:bg-surface-tint"
                        >
                          +
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </section>

        {/* ─── Fresh Produce Traceability Banner ─────────────────────────── */}
        <section className="bg-surface-container-low border border-outline-variant/20 rounded-3xl p-8 flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="space-y-2">
            <span className="text-xs font-bold text-primary uppercase tracking-widest bg-primary/10 px-3 py-1 rounded-full">
              🔍 100% Traceable Harvest
            </span>
            <h3 className="text-2xl font-bold font-outfit text-on-surface">
              Know the exact farm and harvest time of your produce
            </h3>
            <p className="text-xs text-on-surface-variant max-w-xl">
              Every organic vegetable bag comes with a QR code showing farm soil reports, harvest time, and pesticide-free certificates.
            </p>
          </div>
          <Link
            href="/freshness"
            className="bg-primary text-white text-xs font-bold px-6 py-3 rounded-full hover:bg-surface-tint transition-all shadow-level-1 whitespace-nowrap"
          >
            Open Fresh Produce Explorer →
          </Link>
        </section>

      </main>

      {/* ─── Slide-over Interactive Cart Drawer ───────────────────────────── */}
      {isCartOpen && (
        <div className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm flex justify-end animate-fadeIn">
          <div className="w-full max-w-md bg-white h-full shadow-2xl flex flex-col justify-between overflow-hidden">
            
            {/* Header */}
            <div className="p-5 border-b border-slate-100 bg-slate-50 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-xl">🛒</span>
                <h3 className="font-bold text-lg font-outfit">Your Basket ({totalCartCount})</h3>
              </div>
              <button onClick={() => setIsCartOpen(false)} className="w-8 h-8 rounded-full bg-slate-200 text-slate-700 flex items-center justify-center font-bold hover:bg-slate-300">
                ✕
              </button>
            </div>

            {/* Items List */}
            <div className="p-5 overflow-y-auto flex-1 space-y-4">
              {Object.keys(cartItems).length === 0 ? (
                <div className="text-center py-12 text-slate-400 space-y-3">
                  <span className="text-4xl">🧺</span>
                  <p className="font-bold text-slate-600">Your basket is empty</p>
                  <button onClick={() => setIsCartOpen(false)} className="text-xs bg-[#006b23] text-white px-4 py-2 rounded-full font-bold">
                    Start Adding Items
                  </button>
                </div>
              ) : (
                Object.entries(cartItems).map(([id, qty]) => {
                  const prod = catalog.find((p) => p.id === id);
                  if (!prod) return null;
                  return (
                    <div key={id} className="flex items-center gap-3 p-3 bg-slate-50 rounded-2xl border border-slate-100">
                      <Image src={prod.image} alt={prod.name} width={56} height={56} unoptimized className="w-14 h-14 rounded-xl object-cover" />
                      <div className="flex-1 min-w-0">
                        <div className="text-xs font-bold truncate">{prod.name}</div>
                        <div className="text-[10px] text-slate-500">{prod.unitName}</div>
                        <div className="text-xs font-bold text-[#006b23] mt-0.5">{formatCurrency(prod.price * qty)}</div>
                      </div>
                      <div className="flex items-center gap-2 bg-white border border-slate-200 rounded-full px-2 py-1">
                        <button onClick={() => updateQty(id, -1)} className="w-5 h-5 rounded-full bg-slate-100 text-slate-700 font-bold flex items-center justify-center text-xs hover:bg-slate-200">
                          −
                        </button>
                        <span className="text-xs font-bold text-[#006b23] min-w-[14px] text-center">{qty}</span>
                        <button onClick={() => updateQty(id, 1)} className="w-5 h-5 rounded-full bg-[#006b23] text-white font-bold flex items-center justify-center text-xs">
                          +
                        </button>
                      </div>
                    </div>
                  );
                })
              )}
            </div>

            {/* Coupon & Total Footer */}
            {Object.keys(cartItems).length > 0 && (
              <div className="p-5 border-t border-slate-200 bg-slate-50 space-y-4">
                
                {/* Coupon applicator */}
                <div className="flex gap-2">
                  <input
                    type="text"
                    placeholder="Enter coupon (e.g. DAILY50)"
                    value={couponCode}
                    onChange={(e) => setCouponCode(e.target.value.toUpperCase())}
                    className="flex-1 text-xs border border-slate-200 rounded-full px-4 py-2 focus:outline-none focus:border-[#006b23]"
                  />
                  <button
                    onClick={() => {
                      if (couponCode === 'DAILY50') setAppliedCoupon('DAILY50');
                    }}
                    className="bg-[#006b23] text-white text-xs font-bold px-4 py-2 rounded-full hover:bg-emerald-800"
                  >
                    Apply
                  </button>
                </div>
                {appliedCoupon && (
                  <div className="text-xs font-bold text-emerald-700 bg-emerald-100 px-3 py-1 rounded-full flex justify-between">
                    <span>Coupon DAILY50 Applied</span>
                    <span>-₹50</span>
                  </div>
                )}

                {/* Calculation */}
                <div className="space-y-1 text-xs text-slate-600">
                  <div className="flex justify-between">
                    <span>Items Subtotal</span>
                    <span>{formatCurrency(cartSubtotal)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Delivery Charge (10 Mins)</span>
                    <span>{deliveryFee === 0 ? <span className="text-emerald-600 font-bold">FREE</span> : formatCurrency(deliveryFee)}</span>
                  </div>
                  {couponDiscount > 0 && (
                    <div className="flex justify-between text-emerald-600 font-bold">
                      <span>Discount</span>
                      <span>-{formatCurrency(couponDiscount)}</span>
                    </div>
                  )}
                  <div className="flex justify-between font-bold text-sm text-slate-900 pt-2 border-t border-slate-200">
                    <span>To Pay</span>
                    <span className="text-[#006b23]">{formatCurrency(grandTotal)}</span>
                  </div>
                </div>

                <Link
                  href="/checkout"
                  className="w-full bg-[#006b23] text-white font-bold text-sm py-3.5 rounded-full text-center block shadow-lg hover:bg-emerald-800 transition-colors"
                >
                  Proceed to Checkout ({formatCurrency(grandTotal)}) →
                </Link>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="bg-surface-container-low w-full border-t border-outline-variant/20 mt-16 py-10 px-margin-mobile md:px-margin-desktop">
        <div className="max-w-[1440px] mx-auto flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="flex items-center gap-2">
            <Image src="/images/daily_basket_logo.png" alt="Daily Basket Logo" width={24} height={24} className="object-contain" />
            <span className="font-title-md text-lg font-bold text-on-surface" style={{ fontFamily: 'Outfit' }}>Daily Basket</span>
          </div>
          <p className="font-body-sm text-xs text-on-surface-variant">
            © 2026 Daily Basket Inc. All rights reserved. 10-Minute Grocery Delivery Suite.
          </p>
        </div>
      </footer>
    </div>
  );
}
