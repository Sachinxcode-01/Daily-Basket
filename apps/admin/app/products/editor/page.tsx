'use client';

import React, { useState } from 'react';
import { Edit3, Save, Upload, Sparkles, ArrowLeft, Image as ImageIcon } from 'lucide-react';

export default function ProductEditorPage() {
  const [product, setProduct] = useState({
    title: 'Organic Hass Avocados (2 units)',
    category: 'Fresh Produce',
    sku: 'FRU-AVO-2X',
    mrp: '150',
    sellingPrice: '120',
    stockCount: '45',
    unitDetails: '2 units (Approx. 400g)',
    description: 'Farm-fresh organic Hass avocados rich in healthy fats, hand-picked for optimum ripeness.',
    shelfLifeDays: '5',
    isOrganic: true,
  });

  return (
    <div className="space-y-8 max-w-5xl mx-auto">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-[#e2e2e5] pb-6">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Product Editor</h1>
          <p className="text-sm text-[#3f4a3d]">Create or modify SKU catalog details, price margins, and dark store inventory specifications.</p>
        </div>

        <div className="flex items-center gap-3">
          <button className="inline-flex items-center gap-2 px-6 py-2.5 bg-[#006b23] text-white rounded-xl text-xs font-bold hover:bg-[#078730] transition active:scale-95 shadow-sm">
            <Save className="w-4 h-4" />
            <span>Save SKU Changes</span>
          </button>
        </div>
      </div>

      {/* Editor Form Bento */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* Main Details (Span 8) */}
        <div className="lg:col-span-8 bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] space-y-6">
          <h2 className="text-lg font-bold text-[#1a1c1e]">General Catalog Information</h2>

          <div className="space-y-4">
            <div>
              <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1.5">Product Title</label>
              <input
                type="text"
                value={product.title}
                onChange={(e) => setProduct({ ...product, title: e.target.value })}
                className="w-full px-4 py-2.5 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-semibold focus:outline-none focus:border-[#006b23] focus:bg-white transition"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1.5">Category</label>
                <select
                  value={product.category}
                  onChange={(e) => setProduct({ ...product, category: e.target.value })}
                  className="w-full px-4 py-2.5 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-semibold focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                >
                  <option value="Fresh Produce">Fresh Produce</option>
                  <option value="Dairy & Eggs">Dairy & Eggs</option>
                  <option value="Bakery & Snacks">Bakery & Snacks</option>
                  <option value="Beverages">Beverages</option>
                </select>
              </div>

              <div>
                <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1.5">SKU Code</label>
                <input
                  type="text"
                  value={product.sku}
                  onChange={(e) => setProduct({ ...product, sku: e.target.value })}
                  className="w-full px-4 py-2.5 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-mono font-bold focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                />
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1.5">Product Description</label>
              <textarea
                rows={4}
                value={product.description}
                onChange={(e) => setProduct({ ...product, description: e.target.value })}
                className="w-full px-4 py-2.5 bg-[#f3f3f6] border border-transparent rounded-xl text-sm focus:outline-none focus:border-[#006b23] focus:bg-white transition"
              />
            </div>
          </div>
        </div>

        {/* Pricing & Stock Details (Span 4) */}
        <div className="lg:col-span-4 space-y-6">
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
            <h3 className="text-base font-bold text-[#1a1c1e]">Pricing & Margins</h3>

            <div className="space-y-3">
              <div>
                <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">MRP (₹)</label>
                <input
                  type="number"
                  value={product.mrp}
                  onChange={(e) => setProduct({ ...product, mrp: e.target.value })}
                  className="w-full px-3 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-bold"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">Selling Price (₹)</label>
                <input
                  type="number"
                  value={product.sellingPrice}
                  onChange={(e) => setProduct({ ...product, sellingPrice: e.target.value })}
                  className="w-full px-3 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-bold text-[#006b23]"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">Initial Dark Store Stock</label>
                <input
                  type="number"
                  value={product.stockCount}
                  onChange={(e) => setProduct({ ...product, stockCount: e.target.value })}
                  className="w-full px-3 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-bold"
                />
              </div>
            </div>
          </div>

          {/* Media Upload Box */}
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] text-center space-y-3">
            <h3 className="text-sm font-bold text-[#1a1c1e]">Product Media</h3>
            <div className="border-2 border-dashed border-[#e2e2e5] rounded-2xl p-6 flex flex-col items-center justify-center space-y-2 hover:border-[#006b23] transition cursor-pointer">
              <ImageIcon className="w-8 h-8 text-[#3f4a3d]" />
              <span className="text-xs font-bold text-[#006b23]">Drag & drop high-res images</span>
              <span className="text-[10px] text-[#3f4a3d]">PNG, JPG up to 5MB</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
