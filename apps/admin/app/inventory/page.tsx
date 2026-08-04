'use client';

import React, { useState } from 'react';
import { Package, Search, Plus, AlertTriangle, Filter, CheckCircle2, ArrowUpDown } from 'lucide-react';

export default function InventoryManagementPage() {
  const [searchTerm, setSearchTerm] = useState('');

  const [items, setItems] = useState([
    { id: 'INV-101', name: 'Fresh Organic Hass Avocados', sku: 'FRU-AVO-2X', category: 'Fruits', stock: 45, price: '₹120', mrp: '₹150', darkStore: 'Indiranagar Hub', status: 'IN_STOCK' },
    { id: 'INV-102', name: 'Amul Taaza Toned Milk 1L', sku: 'DAI-MLK-1L', category: 'Dairy', stock: 4, price: '₹54', mrp: '₹54', darkStore: 'Indiranagar Hub', status: 'LOW_STOCK' },
    { id: 'INV-103', name: 'Brown Sandwich Bread 400g', sku: 'BAK-BRD-400G', category: 'Bakery', skuCode: 'BAK-BRD', stock: 2, price: '₹45', mrp: '₹50', darkStore: 'Koramangala Hub', status: 'LOW_STOCK' },
    { id: 'INV-104', name: 'Farm Fresh Tomatoes 500g', sku: 'VEG-TOM-500G', category: 'Vegetables', stock: 120, price: '₹24', mrp: '₹30', darkStore: 'HSR Layout Hub', status: 'IN_STOCK' },
    { id: 'INV-105', name: 'A2 Desi Cow Ghee 500ml', sku: 'DAI-GHEE-500M', category: 'Dairy', stock: 0, price: '₹599', mrp: '₹650', darkStore: 'Indiranagar Hub', status: 'OUT_OF_STOCK' },
  ]);

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Inventory Management</h1>
          <p className="text-sm text-[#3f4a3d]">Track dark store stock counts, batch expirations, and low stock thresholds.</p>
        </div>

        <div className="flex items-center gap-3">
          <button className="inline-flex items-center gap-2 px-4 py-2 bg-[#006b23] text-white rounded-xl text-xs font-bold hover:bg-[#078730] transition active:scale-95 shadow-sm">
            <Plus className="w-4 h-4" />
            <span>Add New SKU</span>
          </button>
        </div>
      </div>

      {/* Control Bar & Search */}
      <div className="bg-white rounded-3xl p-4 shadow-sm border border-[#e2e2e5] flex flex-col md:flex-row items-center justify-between gap-4">
        <div className="relative w-full md:w-96">
          <Search className="w-4 h-4 text-[#3f4a3d] absolute left-3 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Search by SKU name, code, or category..."
            className="w-full pl-9 pr-4 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-xs focus:outline-none focus:border-[#006b23] focus:bg-white transition"
          />
        </div>

        <div className="flex items-center gap-3 w-full md:w-auto overflow-x-auto">
          <button className="px-3 py-1.5 bg-[#dce5dd] text-[#006b23] text-xs font-bold rounded-full">All Items (1,420)</button>
          <button className="px-3 py-1.5 bg-[#f3f3f6] text-[#3f4a3d] text-xs font-bold rounded-full">Low Stock (14)</button>
          <button className="px-3 py-1.5 bg-[#f3f3f6] text-[#3f4a3d] text-xs font-bold rounded-full">Out of Stock (3)</button>
        </div>
      </div>

      {/* Inventory Table */}
      <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-[#e2e2e5] text-[#3f4a3d] uppercase font-bold tracking-wider">
                <th className="pb-3">SKU ID</th>
                <th className="pb-3">Product Name</th>
                <th className="pb-3">Category</th>
                <th className="pb-3">Dark Store</th>
                <th className="pb-3">Price / MRP</th>
                <th className="pb-3">Stock Count</th>
                <th className="pb-3">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e2e2e5]">
              {items.map((item) => (
                <tr key={item.id} className="hover:bg-[#f3f3f6] transition">
                  <td className="py-3.5 font-mono font-bold text-[#006b23]">{item.sku}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{item.name}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{item.category}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{item.darkStore}</td>
                  <td className="py-3.5 font-semibold text-[#1a1c1e]">
                    {item.price} <span className="text-[10px] text-[#3f4a3d] line-through">{item.mrp}</span>
                  </td>
                  <td className="py-3.5 font-mono font-bold text-[#1a1c1e]">{item.stock} units</td>
                  <td className="py-3.5">
                    <span
                      className={`px-2.5 py-1 rounded-full font-bold text-[10px] ${
                        item.status === 'IN_STOCK'
                          ? 'bg-[#dce5dd] text-[#006b23]'
                          : item.status === 'LOW_STOCK'
                          ? 'bg-amber-100 text-amber-800'
                          : 'bg-[#ffdad6] text-[#ba1a1a]'
                      }`}
                    >
                      {item.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
