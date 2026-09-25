'use client';

import React, { useState, useEffect, useRef } from 'react';
import { getAdminSocket, joinAdminRoom, leaveAdminRoom } from '../lib/socket';
import {
  Search,
  Mic,
  Bell,
  ArrowLeft,
  Package,
  AlertTriangle,
  Hourglass,
  QrCode,
  MoreVertical,
  Plus,
  Minus,
  ShoppingCart,
  Zap,
  Tag,
  Edit,
  Grid,
  ShoppingBag,
  BarChart3,
  User,
  TrendingUp,
  Smartphone,
  LayoutGrid,
  Table as TableIcon,
  CheckCircle2,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Inventory Management Dashboard (ID: 97fc58a67cca4a028c337f14f0d1233c)

const INITIAL_INVENTORY = [
  {
    id: 'VEG-TOM-001',
    name: 'Fresh Hybrid Tomatoes',
    sku: 'SKU: VEG-TOM-001',
    price: '₹42',
    unit: '/ 1 kg',
    stock: 85,
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
  },
  {
    id: 'MLK-NAN-002',
    name: 'Nandini Toned Fresh Milk',
    sku: 'SKU: MLK-NAN-002',
    price: '₹24',
    unit: '/ 500 ml',
    stock: 8,
    isLowStock: true,
    image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300',
  },
  {
    id: 'BRD-ENG-003',
    name: 'English Oven 100% Whole Wheat Bread',
    sku: 'SKU: BRD-ENG-003',
    price: '₹50',
    unit: '/ 400 g',
    stock: 34,
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300',
  },
  {
    id: 'EGG-FRM-004',
    name: 'Fresh Farm Free-Range Eggs',
    sku: 'SKU: EGG-FRM-004',
    price: '₹95',
    unit: '/ 12 pcs',
    stock: 62,
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=300',
  },
  {
    id: 'FRT-MAN-005',
    name: 'Alphonso Mangoes Ratnagiri',
    sku: 'SKU: FRT-MAN-005',
    price: '₹280',
    unit: '/ 1 kg',
    stock: 14,
    isLowStock: true,
    image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=300',
  },
  {
    id: 'FLK-KEL-006',
    name: "Kellogg's Corn Flakes Original",
    sku: 'SKU: FLK-KEL-006',
    price: '₹195',
    unit: '/ 500 g',
    stock: 48,
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1584473457406-6240486418e9?w=300',
  },
  {
    id: 'VER-BAM-007',
    name: 'Bambino Roasted Short Vermicelli',
    sku: 'SKU: VER-BAM-007',
    price: '₹45',
    unit: '/ 400 g',
    stock: 52,
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=300',
  },
  {
    id: 'GRA-POH-008',
    name: 'Fortune Thick Raw Poha',
    sku: 'SKU: GRA-POH-008',
    price: '₹38',
    unit: '/ 500 g',
    stock: 40,
    isLowStock: false,
    image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=300',
  },
  {
    id: 'CRD-MLK-009',
    name: 'Milky Mist Natural Set Curd',
    sku: 'SKU: CRD-MLK-009',
    price: '₹40',
    unit: '/ 400 g',
    stock: 18,
    isLowStock: true,
    image: 'https://images.unsplash.com/photo-1571212515416-fef01fc43637?w=300',
  },
];

export default function InventoryManagementPage() {
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [viewMode, setViewMode] = useState<'card' | 'table' | 'mobile'>('card');
  const [items, setItems] = useState(INITIAL_INVENTORY);
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const toastTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    const socket = getAdminSocket('admin_inventory');
    joinAdminRoom('admin');

    return () => {
      leaveAdminRoom('admin');
      if (toastTimeoutRef.current) {
        clearTimeout(toastTimeoutRef.current);
      }
    };
  }, []);

  const handleUpdateStock = (id: string, delta: number) => {
    const currentItem = items.find((it) => it.id === id);
    if (!currentItem) return;

    const newStock = Math.max(0, currentItem.stock + delta);
    const isLow = newStock < 20;

    // Pure state updater with zero side effects
    setItems((prev) =>
      prev.map((it) => (it.id === id ? { ...it, stock: newStock, isLowStock: isLow } : it))
    );

    // Side effects executed outside updater
    const socket = getAdminSocket();
    socket.emit('stock_updated', {
      productId: currentItem.id,
      newStock,
      isAvailable: newStock > 0,
    });

    if (toastTimeoutRef.current) {
      clearTimeout(toastTimeoutRef.current);
    }
    setToastMessage(`Stock updated: ${currentItem.name} ➔ ${newStock} units`);
    toastTimeoutRef.current = setTimeout(() => {
      setToastMessage(null);
    }, 3000);
  };

  const handleRestock = (id: string) => {
    handleUpdateStock(id, 50);
  };

  const filteredItems = items.filter((item) => {
    const matchesFilter =
      selectedFilter === 'All' ||
      (selectedFilter === 'Low Stock' && item.isLowStock) ||
      (selectedFilter === 'Near Expiry' && item.stock < 20);

    const query = searchQuery.toLowerCase();
    const matchesQuery =
      !query ||
      item.name.toLowerCase().includes(query) ||
      item.sku.toLowerCase().includes(query);

    return matchesFilter && matchesQuery;
  });

  return (
    <div className="space-y-6 max-w-7xl mx-auto font-sans">
      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#1e2923]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Inventory</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 97fc58a67cca4a028c337f14f0d1233c • Real-time Stock Tracking
            </p>
          </div>
        </div>

        {/* View Mode Switches */}
        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('card')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'card' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Cards</span>
          </button>
          <button
            onClick={() => setViewMode('table')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'table' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <TableIcon className="w-3.5 h-3.5" />
            <span>Table</span>
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

      {/* Live Inventory Update Toast */}
      {toastMessage && (
        <div className="bg-[#006837] text-white p-3.5 rounded-2xl flex items-center justify-between shadow-xl animate-bounce">
          <div className="flex items-center gap-2.5">
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-300 animate-ping" />
            <p className="text-sm font-extrabold">{toastMessage}</p>
          </div>
          <button
            onClick={() => setToastMessage(null)}
            className="text-xs bg-white/20 hover:bg-white/30 px-2.5 py-1 rounded-lg font-bold"
          >
            Dismiss
          </button>
        </div>
      )}

      {/* Main Content Area */}
      {viewMode === 'mobile' ? (
        /* Mobile Device Frame View simulating exact phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[820px] bg-[#f4f6f4] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <div className="flex items-center gap-2">
                <ArrowLeft className="w-5 h-5 text-[#1e2923]" />
                <span className="font-extrabold text-xl text-[#006837]">Inventory</span>
              </div>
              <div className="flex items-center gap-2">
                <Search className="w-4 h-4 text-[#1e2923]" />
                <div className="relative">
                  <Bell className="w-4 h-4 text-[#1e2923]" />
                  <span className="w-2 h-2 rounded-full bg-red-600 absolute top-0 right-0" />
                </div>
              </div>
            </div>

            {/* Scrollable Mobile Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              {/* Stat Cards Row */}
              <div className="flex gap-3 overflow-x-auto pb-1 no-scrollbar">
                <div className="min-w-[140px] bg-white border border-[#e2e8f0] p-3 rounded-2xl shadow-sm flex flex-col justify-between">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 rounded-lg bg-[#dcfce7] text-[#006837]">
                      <Package className="w-4 h-4" />
                    </div>
                    <span className="text-xs font-bold text-[#475569]">Products</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923] mt-2">1,248</p>
                  <p className="text-[10px] font-bold text-[#16a34a] mt-0.5">📈 +12 this week</p>
                </div>

                <div className="min-w-[140px] bg-white border border-[#fca5a5] p-3 rounded-2xl shadow-sm flex flex-col justify-between">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 rounded-lg bg-[#ffedd5] text-[#c2410c]">
                      <AlertTriangle className="w-4 h-4" />
                    </div>
                    <span className="text-xs font-bold text-[#475569]">Low Stock</span>
                  </div>
                  <p className="text-2xl font-black text-[#dc2626] mt-2">32</p>
                  <p className="text-[10px] font-bold text-[#c2410c] mt-0.5">❗ Needs attention</p>
                </div>

                <div className="min-w-[140px] bg-white border border-[#e2e8f0] p-3 rounded-2xl shadow-sm flex flex-col justify-between">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 rounded-lg bg-[#e0f2fe] text-[#0284c7]">
                      <Hourglass className="w-4 h-4" />
                    </div>
                    <span className="text-xs font-bold text-[#475569]">Near Expiry</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923] mt-2">15</p>
                  <p className="text-[10px] font-bold text-[#64748b] mt-0.5">📅 Next 7 days</p>
                </div>
              </div>

              {/* Search Box */}
              <div className="flex items-center gap-2 bg-white border border-[#cbd5e1] px-3 py-2 rounded-xl">
                <Search className="w-4 h-4 text-[#64748b]" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search inventory, SKU..."
                  className="bg-transparent text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none flex-1"
                />
                <QrCode className="w-4 h-4 text-[#1e2923]" />
                <Mic className="w-4 h-4 text-[#006837]" />
              </div>

              {/* Filter Pills */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                {['All', 'Low Stock', 'Near Expiry', 'Best Seller'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedFilter(f)}
                    className={`px-4 py-1.5 rounded-full font-bold whitespace-nowrap transition ${
                      selectedFilter === f
                        ? 'bg-[#006837] text-white'
                        : 'bg-white text-[#334155] border border-[#cbd5e1]'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>

              {/* Inventory Cards */}
              {filteredItems.map((item) => (
                <div
                  key={item.id}
                  className={`p-3.5 rounded-2xl border shadow-sm space-y-3 ${
                    item.isLowStock
                      ? 'bg-[#fff5f5] border-[#fca5a5]'
                      : 'bg-white border-[#e2e8f0]'
                  }`}
                >
                  <div className="flex gap-3">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src={item.image} alt={item.name} className="w-16 h-16 rounded-xl object-cover" />
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between">
                        <h4 className="font-extrabold text-sm text-[#1e2923] truncate">{item.name}</h4>
                        <MoreVertical className="w-4 h-4 text-[#64748b]" />
                      </div>
                      <p className="text-[11px] text-[#64748b]">{item.sku}</p>

                      <div className="flex items-center justify-between mt-2">
                        <p className="font-black text-base text-[#006837]">
                          {item.price} <span className="text-xs font-normal text-[#64748b]">{item.unit}</span>
                        </p>
                        <span
                          className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold ${
                            item.isLowStock
                              ? 'bg-[#fee2e2] text-[#b91c1c]'
                              : 'bg-[#dcfce7] text-[#15803d]'
                          }`}
                        >
                          <span
                            className={`w-1.5 h-1.5 rounded-full ${
                              item.isLowStock ? 'bg-[#dc2626]' : 'bg-[#16a34a]'
                            }`}
                          />
                          {item.isLowStock ? `Low Stock (${item.stock})` : `In Stock (${item.stock})`}
                        </span>
                      </div>
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="flex gap-2 pt-1">
                    <button
                      onClick={() => handleRestock(item.id)}
                      className={`flex-1 py-2 text-white text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 shadow-sm transition active:scale-95 ${
                        item.isLowStock ? 'bg-[#b91c1c] hover:bg-[#991b1b]' : 'bg-[#006837] hover:bg-[#00522b]'
                      }`}
                    >
                      {item.isLowStock ? <Zap className="w-3.5 h-3.5 text-white" /> : <ShoppingCart className="w-3.5 h-3.5 text-white" />}
                      <span>{item.isLowStock ? 'Urgent Restock (+50)' : 'Restock (+50)'}</span>
                    </button>
                    <button
                      onClick={() => handleUpdateStock(item.id, 10)}
                      className="flex-1 py-2 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-1.5 hover:bg-[#f8fafc] active:scale-95 transition"
                    >
                      <Plus className="w-3.5 h-3.5 text-[#006837]" />
                      <span>Quick +10</span>
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dcfce7] text-[#006837] rounded-2xl"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
              <div className="flex flex-col items-center gap-0.5"><User className="w-4 h-4" /> Profile</div>
            </div>

            {/* Floating Action Button */}
            <button className="absolute right-6 bottom-16 w-11 h-11 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:scale-105 transition">
              <Plus className="w-6 h-6" />
            </button>
          </div>
        </div>
      ) : viewMode === 'card' ? (
        /* Web Grid/Card View */
        <>
          {/* Summary Stat Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="bg-white border border-[#e2e8f0] p-5 rounded-3xl shadow-sm flex items-center justify-between">
              <div>
                <span className="text-xs font-extrabold text-[#475569] uppercase">Products</span>
                <p className="text-3xl font-black text-[#1e2923] mt-1">1,248</p>
                <p className="text-xs font-bold text-[#16a34a] mt-1">📈 +12 this week</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#dcfce7] text-[#006837]">
                <Package className="w-8 h-8" />
              </div>
            </div>

            <div className="bg-white border border-[#fca5a5] p-5 rounded-3xl shadow-sm flex items-center justify-between">
              <div>
                <span className="text-xs font-extrabold text-[#c2410c] uppercase">Low Stock</span>
                <p className="text-3xl font-black text-[#dc2626] mt-1">32</p>
                <p className="text-xs font-bold text-[#c2410c] mt-1">❗ Needs attention</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#ffedd5] text-[#c2410c]">
                <AlertTriangle className="w-8 h-8" />
              </div>
            </div>

            <div className="bg-white border border-[#e2e8f0] p-5 rounded-3xl shadow-sm flex items-center justify-between">
              <div>
                <span className="text-xs font-extrabold text-[#475569] uppercase">Near Expiry</span>
                <p className="text-3xl font-black text-[#1e2923] mt-1">15</p>
                <p className="text-xs font-bold text-[#64748b] mt-1">📅 Next 7 days</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#e0f2fe] text-[#0284c7]">
                <Hourglass className="w-8 h-8" />
              </div>
            </div>
          </div>

          {/* Controls & Search */}
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="relative flex-1 w-full max-w-lg">
              <Search className="w-4 h-4 text-[#64748b] absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search inventory, SKU..."
                className="w-full pl-10 pr-10 py-2.5 bg-white border border-[#cbd5e1] rounded-2xl text-xs text-[#1e2923] placeholder-[#94a3b8] focus:outline-none focus:border-[#006837]"
              />
              <Mic className="w-4 h-4 text-[#006837] absolute right-3.5 top-1/2 -translate-y-1/2 cursor-pointer" />
            </div>

            {/* Filter Pills */}
            <div className="flex gap-2 overflow-x-auto w-full md:w-auto pb-1 no-scrollbar text-xs">
              {['All', 'Low Stock', 'Near Expiry', 'Best Seller'].map((f) => (
                <button
                  key={f}
                  onClick={() => setSelectedFilter(f)}
                  className={`px-4 py-2 rounded-full font-bold whitespace-nowrap transition ${
                    selectedFilter === f
                      ? 'bg-[#006837] text-white shadow-sm'
                      : 'bg-white text-[#334155] border border-[#cbd5e1] hover:bg-[#f8fafc]'
                  }`}
                >
                  {f}
                </button>
              ))}
            </div>
          </div>

          {/* Inventory Items Cards Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {filteredItems.map((item) => (
              <div
                key={item.id}
                className={`p-5 rounded-3xl border shadow-sm hover:shadow-md transition space-y-4 ${
                  item.isLowStock ? 'bg-[#fff5f5] border-[#fca5a5]' : 'bg-white border-[#e2e8f0]'
                }`}
              >
                <div className="flex gap-4">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={item.image} alt={item.name} className="w-20 h-20 rounded-2xl object-cover" />
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between">
                      <h3 className="font-extrabold text-base text-[#1e2923] truncate">{item.name}</h3>
                      <MoreVertical className="w-5 h-5 text-[#64748b] cursor-pointer" />
                    </div>
                    <p className="text-xs text-[#64748b]">{item.sku}</p>

                    <div className="flex items-center justify-between mt-3">
                      <p className="font-black text-lg text-[#006837]">
                        {item.price} <span className="text-xs font-normal text-[#64748b]">{item.unit}</span>
                      </p>
                      <div className="flex items-center gap-2">
                        <span
                          className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold ${
                            item.isLowStock
                              ? 'bg-[#fee2e2] text-[#b91c1c]'
                              : 'bg-[#dcfce7] text-[#15803d]'
                          }`}
                        >
                          <span
                            className={`w-2 h-2 rounded-full ${
                              item.isLowStock ? 'bg-[#dc2626]' : 'bg-[#16a34a]'
                            }`}
                          />
                          {item.isLowStock ? `Low (${item.stock})` : `In Stock (${item.stock})`}
                        </span>

                        {/* Quick Stock Counter +/- */}
                        <div className="flex items-center gap-1 bg-slate-100 p-0.5 rounded-xl border border-slate-200">
                          <button
                            onClick={() => handleUpdateStock(item.id, -5)}
                            className="w-6 h-6 rounded-lg bg-white hover:bg-slate-200 flex items-center justify-center font-bold text-xs shadow-xs text-slate-700"
                            title="Decrease stock by 5"
                          >
                            <Minus className="w-3 h-3" />
                          </button>
                          <span className="font-mono font-bold text-xs px-1 text-slate-900">{item.stock}</span>
                          <button
                            onClick={() => handleUpdateStock(item.id, 5)}
                            className="w-6 h-6 rounded-lg bg-white hover:bg-slate-200 flex items-center justify-center font-bold text-xs shadow-xs text-[#006837]"
                            title="Increase stock by 5"
                          >
                            <Plus className="w-3 h-3" />
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex gap-3 pt-1">
                  <button
                    onClick={() => handleRestock(item.id)}
                    className={`flex-1 py-2.5 text-white text-xs font-bold rounded-xl flex items-center justify-center gap-2 shadow-sm transition ${
                      item.isLowStock ? 'bg-[#b91c1c] hover:bg-[#991b1b]' : 'bg-[#006837] hover:bg-[#00522b]'
                    }`}
                  >
                    {item.isLowStock ? <Zap className="w-4 h-4 text-white" /> : <ShoppingCart className="w-4 h-4 text-white" />}
                    <span>{item.isLowStock ? 'Urgent Restock (+50)' : 'Restock (+50)'}</span>
                  </button>
                  <button
                    onClick={() => handleUpdateStock(item.id, 10)}
                    className="flex-1 py-2.5 bg-white border border-[#cbd5e1] text-[#1e2923] text-xs font-bold rounded-xl flex items-center justify-center gap-2 hover:bg-[#f8fafc]"
                  >
                    <Plus className="w-4 h-4 text-[#006837]" />
                    <span>Quick +10</span>
                  </button>
                </div>
              </div>
            ))}
          </div>
        </>
      ) : (
        /* Table View */
        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e8f0] space-y-4">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-[#e2e8f0] text-[#64748b] uppercase font-bold tracking-wider">
                  <th className="pb-3">SKU ID</th>
                  <th className="pb-3">Product Name</th>
                  <th className="pb-3">Price</th>
                  <th className="pb-3">Stock Count</th>
                  <th className="pb-3">Status</th>
                  <th className="pb-3">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#e2e8f0]">
                {filteredItems.map((item) => (
                  <tr key={item.id} className="hover:bg-[#f8fafc] transition">
                    <td className="py-3.5 font-bold text-[#006837]">{item.sku}</td>
                    <td className="py-3.5 font-bold text-[#1e2923]">{item.name}</td>
                    <td className="py-3.5 font-black text-[#1e2923]">{item.price} {item.unit}</td>
                    <td className="py-3.5 font-mono font-bold text-[#1e2923]">{item.stock} units</td>
                    <td className="py-3.5">
                      <span
                        className={`px-2.5 py-1 rounded-full font-bold text-[10px] ${
                          item.isLowStock
                            ? 'bg-[#fee2e2] text-[#b91c1c]'
                            : 'bg-[#dcfce7] text-[#15803d]'
                        }`}
                      >
                        {item.isLowStock ? 'Low Stock' : 'In Stock'}
                      </span>
                    </td>
                    <td className="py-3.5">
                      <div className="flex items-center gap-2">
                        <div className="flex items-center gap-1 bg-slate-100 p-0.5 rounded-lg border border-slate-200">
                          <button
                            onClick={() => handleUpdateStock(item.id, -5)}
                            className="w-5 h-5 rounded bg-white hover:bg-slate-200 flex items-center justify-center font-bold text-xs shadow-xs text-slate-700"
                            title="Decrease by 5"
                          >
                            <Minus className="w-3 h-3" />
                          </button>
                          <span className="font-mono font-bold text-xs px-1 text-slate-900">{item.stock}</span>
                          <button
                            onClick={() => handleUpdateStock(item.id, 5)}
                            className="w-5 h-5 rounded bg-white hover:bg-slate-200 flex items-center justify-center font-bold text-xs shadow-xs text-[#006837]"
                            title="Increase by 5"
                          >
                            <Plus className="w-3 h-3" />
                          </button>
                        </div>
                        <button
                          onClick={() => handleRestock(item.id)}
                          className={`px-3 py-1.5 text-white rounded-xl text-xs font-bold transition hover:opacity-90 active:scale-95 ${
                            item.isLowStock ? 'bg-[#b91c1c]' : 'bg-[#006837]'
                          }`}
                        >
                          {item.isLowStock ? 'Urgent (+50)' : 'Restock (+50)'}
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
