/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  ArrowLeft,
  Search,
  ShoppingCart,
  Star,
  Sparkles,
  Leaf,
  Plus,
  Check,
} from 'lucide-react';
import { ALL_WEBSITE_PRODUCTS, WebsiteProduct, CATEGORY_DISPLAY_MAP } from '../../lib/catalog';
import { formatCurrency } from '@daily-basket/shared-utils';
import { useCart } from '../../store/useCart';

export default function ProductCatalogIndexPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('ALL');
  const [addedId, setAddedId] = useState<string | null>(null);
  const { addItem } = useCart();

  const categories = [
    { label: 'All Products', slug: 'ALL' },
    { label: 'Fresh Vegetables', slug: 'fresh-vegetables' },
    { label: 'Fresh Milk', slug: 'milk' },
    { label: 'Bread & Pav', slug: 'bread-pav' },
    { label: 'Curd & Yogurt', slug: 'curd-yogurt' },
    { label: 'Flakes & Cereals', slug: 'flakes-kids-cereals' },
    { label: 'Grains & Poha', slug: 'poha-daliya-grains' },
  ];

  const filteredProducts = ALL_WEBSITE_PRODUCTS.filter((p) => {
    const matchesSearch =
      p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.description?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.category?.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCat =
      selectedCategory === 'ALL' ||
      p.categorySlug === selectedCategory ||
      p.category.toLowerCase().includes(selectedCategory.toLowerCase());
    return matchesSearch && matchesCat;
  });

  const handleAddToCart = (product: WebsiteProduct, e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    addItem.mutate({
      variantId: product.variantId,
      productName: product.name,
      unitName: product.unitName,
      price: product.price,
      quantity: 1,
    });
    setAddedId(product.id);
    setTimeout(() => setAddedId(null), 1200);
  };

  return (
    <div className="min-h-screen bg-[#f7f9fb] text-[#191c1e] pb-24">
      {/* Header */}
      <header className="sticky top-0 z-40 bg-white/80 backdrop-blur-md border-b border-[#e2e2e5] px-4 sm:px-8 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <Link
              href="/"
              className="p-2 rounded-xl hover:bg-slate-100 text-slate-700 transition"
            >
              <ArrowLeft className="w-5 h-5" />
            </Link>
            <div>
              <h1 className="font-outfit font-extrabold text-xl text-slate-900 leading-tight">
                Fresh Produce &amp; Groceries
              </h1>
              <p className="text-xs text-slate-500 font-inter">
                Direct from local farms • 10-Minute Delivery
              </p>
            </div>
          </div>

          <Link
            href="/cart"
            className="flex items-center gap-2 px-4 py-2 bg-[#006b23] text-white rounded-xl text-xs font-bold hover:bg-[#078730] transition shadow-sm"
          >
            <ShoppingCart className="w-4 h-4" />
            <span>View Cart</span>
          </Link>
        </div>
      </header>

      {/* Filter and Search Bar */}
      <div className="max-w-7xl mx-auto px-4 sm:px-8 py-6 space-y-4">
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1">
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search farm mangoes, milk, spinach, herbs..."
              className="w-full pl-10 pr-4 py-2.5 bg-white border border-slate-200 rounded-xl text-sm placeholder-slate-400 focus:outline-none focus:border-[#006b23] focus:ring-1 focus:ring-[#006b23] transition"
            />
          </div>

          {/* Categories Horizontal Tabs */}
          <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none">
            {categories.map((c) => (
              <button
                key={c.slug}
                type="button"
                onClick={() => setSelectedCategory(c.slug)}
                className={`px-3.5 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition ${
                  selectedCategory === c.slug
                    ? 'bg-[#006b23] text-white shadow-sm'
                    : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
                }`}
              >
                {c.label}
              </button>
            ))}
          </div>
        </div>

        {/* Product Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4 pt-2">
          {filteredProducts.map((p) => {
            const isAdded = addedId === p.id;
            const isMutating = addItem.isPending && addedId === p.id;

            return (
              <Link
                key={p.id}
                href={`/product/${p.id}`}
                className="bg-white rounded-2xl border border-slate-200/80 p-3.5 flex flex-col justify-between hover:shadow-md hover:border-emerald-300 transition group"
              >
                <div className="space-y-2">
                  <div className="relative aspect-square rounded-xl overflow-hidden bg-slate-50">
                    <img
                      src={p.image || (p.images && p.images[0]) || '/images/daily_basket_logo.png'}
                      alt={p.name}
                      className="w-full h-full object-contain p-2 group-hover:scale-105 transition duration-300"
                    />
                    {p.isOrganic && (
                      <div className="absolute top-2 left-2 bg-emerald-500/90 text-white text-[10px] font-extrabold px-1.5 py-0.5 rounded-md flex items-center gap-1 backdrop-blur-xs">
                        <Leaf className="w-2.5 h-2.5" /> Organic
                      </div>
                    )}
                  </div>

                  <div>
                    <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                      {p.category || 'Produce'}
                    </span>
                    <h3 className="text-xs sm:text-sm font-bold text-slate-900 line-clamp-1 group-hover:text-[#006b23] transition">
                      {p.name}
                    </h3>
                    <p className="text-[11px] text-slate-500">
                      {p.unitName}
                    </p>
                  </div>
                </div>

                <div className="pt-3 border-t border-slate-100 mt-2 flex items-center justify-between">
                  <div>
                    <div className="text-sm font-black text-slate-900">
                      {formatCurrency(p.price)}
                    </div>
                    {p.mrp > p.price && (
                      <div className="text-[10px] text-slate-400 line-through">
                        {formatCurrency(p.mrp)}
                      </div>
                    )}
                  </div>

                  <button
                    type="button"
                    onClick={(e) => handleAddToCart(p, e)}
                    disabled={isMutating}
                    className={`p-2 rounded-xl text-xs font-bold transition flex items-center gap-1 ${
                      isAdded
                        ? 'bg-emerald-600 text-white'
                        : 'bg-emerald-50 text-[#006b23] hover:bg-[#006b23] hover:text-white'
                    }`}
                  >
                    {isAdded ? (
                      <Check className="w-3.5 h-3.5" />
                    ) : (
                      <Plus className="w-3.5 h-3.5" />
                    )}
                  </button>
                </div>
              </Link>
            );
          })}
        </div>
      </div>
    </div>
  );
}
