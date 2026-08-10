'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function AdminProductEditorPage() {
  const [name, setName] = useState('Organic Hass Avocados');
  const [sku, setSku] = useState('PROD-AVO-001');
  const [category, setCategory] = useState('Fresh Produce');
  const [price, setPrice] = useState('180');
  const [mrp, setMrp] = useState('220');
  const [stock, setStock] = useState('145');
  const [unit, setUnit] = useState('Pack of 4');
  const [description, setDescription] = useState('Fresh, hand-picked organic Hass avocados imported directly from partner farms.');
  const [imageUrl, setImageUrl] = useState('https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80');
  const [isSaved, setIsSaved] = useState(false);

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSaved(true);
    setTimeout(() => setIsSaved(false), 2000);
  };

  return (
    <div className="p-6 max-w-5xl mx-auto flex flex-col gap-6">
      {/* Header & Actions */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <div className="flex items-center gap-2 text-xs text-on-surface-variant mb-1">
            <Link href="/products" className="hover:text-primary">Products</Link>
            <span>/</span>
            <span className="text-on-surface font-medium">Edit Product</span>
          </div>
          <h1 className="font-headline text-2xl font-bold text-on-surface">Product Editor</h1>
        </div>
        <div className="flex items-center gap-3">
          <Link
            href="/products"
            className="px-4 py-2 border border-outline-variant rounded-xl text-on-surface font-label text-sm hover:bg-surface-container transition-colors"
          >
            Cancel
          </Link>
          <button
            onClick={handleSave}
            className="px-5 py-2 bg-primary text-on-primary rounded-xl font-label text-sm font-semibold hover:bg-primary-container transition-colors shadow-sm flex items-center gap-2"
          >
            <span className="material-symbols-outlined text-sm">save</span>
            {isSaved ? 'Saved!' : 'Save Product'}
          </button>
        </div>
      </div>

      <form onSubmit={handleSave} className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left 2 Cols: Form Fields */}
        <div className="lg:col-span-2 flex flex-col gap-6">
          {/* General Information */}
          <div className="bg-surface-container-lowest p-6 rounded-2xl border border-surface-variant/40 shadow-sm flex flex-col gap-4">
            <h2 className="font-headline text-lg font-semibold text-on-surface">Basic Information</h2>

            <div className="flex flex-col gap-1">
              <label className="font-label text-xs font-semibold text-on-surface-variant">Product Name</label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                required
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="flex flex-col gap-1">
                <label className="font-label text-xs font-semibold text-on-surface-variant">SKU Code</label>
                <input
                  type="text"
                  value={sku}
                  onChange={(e) => setSku(e.target.value)}
                  className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  required
                />
              </div>
              <div className="flex flex-col gap-1">
                <label className="font-label text-xs font-semibold text-on-surface-variant">Category</label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                >
                  <option>Fresh Produce</option>
                  <option>Dairy & Eggs</option>
                  <option>Bakery & Snacks</option>
                  <option>Beverages</option>
                </select>
              </div>
            </div>

            <div className="flex flex-col gap-1">
              <label className="font-label text-xs font-semibold text-on-surface-variant">Description</label>
              <textarea
                rows={4}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          {/* Pricing & Stock */}
          <div className="bg-surface-container-lowest p-6 rounded-2xl border border-surface-variant/40 shadow-sm flex flex-col gap-4">
            <h2 className="font-headline text-lg font-semibold text-on-surface">Pricing & Inventory</h2>

            <div className="grid grid-cols-3 gap-4">
              <div className="flex flex-col gap-1">
                <label className="font-label text-xs font-semibold text-on-surface-variant">Selling Price (₹)</label>
                <input
                  type="number"
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  required
                />
              </div>
              <div className="flex flex-col gap-1">
                <label className="font-label text-xs font-semibold text-on-surface-variant">MRP (₹)</label>
                <input
                  type="number"
                  value={mrp}
                  onChange={(e) => setMrp(e.target.value)}
                  className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  required
                />
              </div>
              <div className="flex flex-col gap-1">
                <label className="font-label text-xs font-semibold text-on-surface-variant">Stock Quantity</label>
                <input
                  type="number"
                  value={stock}
                  onChange={(e) => setStock(e.target.value)}
                  className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  required
                />
              </div>
            </div>

            <div className="flex flex-col gap-1">
              <label className="font-label text-xs font-semibold text-on-surface-variant">Unit Specification</label>
              <input
                type="text"
                value={unit}
                onChange={(e) => setUnit(e.target.value)}
                className="w-full px-4 py-2.5 bg-surface rounded-xl border border-outline-variant text-on-surface text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                required
              />
            </div>
          </div>
        </div>

        {/* Right 1 Col: Image Dropzone & Status */}
        <div className="flex flex-col gap-6">
          <div className="bg-surface-container-lowest p-6 rounded-2xl border border-surface-variant/40 shadow-sm flex flex-col gap-4">
            <h2 className="font-headline text-lg font-semibold text-on-surface">Product Image</h2>

            <div className="w-full aspect-square rounded-2xl overflow-hidden bg-surface border-2 border-dashed border-outline-variant relative group flex items-center justify-center">
              <img src={imageUrl} alt="Product Preview" className="w-full h-full object-cover" />
              <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col items-center justify-center text-white p-4 text-center">
                <span className="material-symbols-outlined text-3xl mb-1">cloud_upload</span>
                <span className="font-label text-xs">Click or drag image to replace</span>
              </div>
            </div>

            <div className="flex flex-col gap-1">
              <label className="font-label text-xs font-semibold text-on-surface-variant">Image URL</label>
              <input
                type="url"
                value={imageUrl}
                onChange={(e) => setImageUrl(e.target.value)}
                className="w-full px-3 py-2 bg-surface rounded-xl border border-outline-variant text-xs text-on-surface focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          <div className="bg-surface-container-lowest p-6 rounded-2xl border border-surface-variant/40 shadow-sm flex flex-col gap-4">
            <h2 className="font-headline text-lg font-semibold text-on-surface">Publish Status</h2>

            <div className="flex items-center justify-between">
              <div>
                <span className="font-body text-sm font-semibold text-on-surface block">Active Status</span>
                <span className="font-body text-xs text-on-surface-variant">Visible in customer catalog</span>
              </div>
              <div className="w-10 h-5 rounded-full bg-primary relative flex items-center px-0.5">
                <div className="w-4 h-4 rounded-full bg-white shadow-md transform translate-x-5" />
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  );
}
