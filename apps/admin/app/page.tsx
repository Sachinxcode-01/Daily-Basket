'use client';

import React, { useState } from 'react';
import {
  Store,
  Package,
  TrendingUp,
  AlertTriangle,
  Clock,
  CheckCircle2,
  Users,
  Search,
  Plus,
  ArrowUpRight,
  Filter,
  BarChart3,
  RefreshCw,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function AdminDashboardPage() {
  const [activeTab, setActiveTab] = useState<'OVERVIEW' | 'INVENTORY' | 'ORDERS' | 'ANALYTICS'>('OVERVIEW');

  const [inventoryList, setInventoryList] = useState([
    { id: 'inv_1', name: 'Fresh Organic Farm Tomatoes', category: 'Produce', sku: 'VEG-TOM-500G', stock: 45, reserved: 3, lowStock: false, price: 24 },
    { id: 'inv_2', name: 'Amul Taaza Toned Milk', category: 'Dairy', sku: 'DAI-MLK-1L', stock: 12, reserved: 5, lowStock: true, price: 54 },
    { id: 'inv_3', name: 'Brown Sandwich Bread', category: 'Bakery', sku: 'BAK-BRD-400G', stock: 8, reserved: 2, lowStock: true, price: 45 },
    { id: 'inv_4', name: 'Alphonso Mangoes Box', category: 'Produce', sku: 'FRU-MNG-1KG', stock: 28, reserved: 4, lowStock: false, price: 299 },
  ]);

  const [ordersQueue, setOrdersQueue] = useState([
    { id: 'DB-892104', customer: 'Ananya Sharma', items: '2x Tomatoes, 1x Milk', total: 102, status: 'CONFIRMED', time: '2 Mins ago' },
    { id: 'DB-892105', customer: 'Vikram Mehta', items: '1x Mangoes Box', total: 299, status: 'PACKING', time: '4 Mins ago' },
    { id: 'DB-892106', customer: 'Priya Nair', items: '1x Brown Bread, 2x Milk', total: 153, status: 'READY_FOR_PICKUP', time: '7 Mins ago' },
  ]);

  const updateStock = (id: string, delta: number) => {
    setInventoryList((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          const newStock = Math.max(0, item.stock + delta);
          return { ...item, stock: newStock, lowStock: newStock < 15 };
        }
        return item;
      }),
    );
  };

  const advanceOrderStatus = (id: string) => {
    setOrdersQueue((prev) =>
      prev.map((order) => {
        if (order.id === id) {
          let nextStatus = 'PACKING';
          if (order.status === 'CONFIRMED') nextStatus = 'PACKING';
          else if (order.status === 'PACKING') nextStatus = 'READY_FOR_PICKUP';
          else if (order.status === 'READY_FOR_PICKUP') nextStatus = 'OUT_FOR_DELIVERY';
          return { ...order, status: nextStatus };
        }
        return order;
      }),
    );
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-6">
      {/* Top Admin Header */}
      <header className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8 pb-4 border-b border-slate-800">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-2xl bg-emerald-600 flex items-center justify-center text-white shadow-lg shadow-emerald-900/40">
            <Store className="w-6 h-6" />
          </div>
          <div>
            <h1 className="text-xl font-extrabold text-white">Daily Basket Store Manager</h1>
            <p className="text-xs text-slate-400">Kirana Hub #01 • Koramangala, Bengaluru</p>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <span className="bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 px-3 py-1.5 rounded-full text-xs font-semibold flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            Store Open & Active
          </span>
        </div>
      </header>

      {/* KPI Overview Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Today's Sales Revenue</span>
            <TrendingUp className="w-4 h-4 text-emerald-400" />
          </div>
          <h3 className="text-2xl font-black text-emerald-400">₹38,450</h3>
          <p className="text-[10px] text-emerald-300/80 mt-1">↑ 18% vs yesterday</p>
        </div>

        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Orders Processed</span>
            <Package className="w-4 h-4 text-sky-400" />
          </div>
          <h3 className="text-2xl font-black text-white">142 Orders</h3>
          <p className="text-[10px] text-slate-400 mt-1">Avg 14 orders/hr</p>
        </div>

        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Low Stock Alerts</span>
            <AlertTriangle className="w-4 h-4 text-amber-400" />
          </div>
          <h3 className="text-2xl font-black text-amber-400">2 SKUs Warning</h3>
          <p className="text-[10px] text-amber-300/80 mt-1">Restock required today</p>
        </div>

        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Avg Dispatch Time</span>
            <Clock className="w-4 h-4 text-purple-400" />
          </div>
          <h3 className="text-2xl font-black text-white">2.4 Mins</h3>
          <p className="text-[10px] text-purple-300/80 mt-1">Target: &lt; 3.0 Mins</p>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="flex gap-2 border-b border-slate-800 mb-6">
        {(['OVERVIEW', 'INVENTORY', 'ORDERS', 'ANALYTICS'] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-5 py-2.5 text-xs font-bold rounded-t-xl transition ${
              activeTab === tab
                ? 'bg-slate-800 text-emerald-400 border-t-2 border-emerald-500'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Tab 1: OVERVIEW */}
      {activeTab === 'OVERVIEW' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
            <h3 className="text-sm font-bold text-white mb-4">Active Orders Queue</h3>
            <div className="space-y-3">
              {ordersQueue.map((ord) => (
                <div key={ord.id} className="p-3.5 bg-slate-900/60 rounded-xl flex items-center justify-between border border-slate-700/40">
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="text-xs font-bold text-white">{ord.id}</span>
                      <span className="text-[10px] text-slate-400">• {ord.time}</span>
                    </div>
                    <p className="text-xs text-slate-300 font-medium mt-0.5">{ord.customer}</p>
                    <p className="text-[11px] text-slate-400">{ord.items}</p>
                  </div>
                  <div className="text-right">
                    <span className="text-xs font-bold text-emerald-400 block">{formatCurrency(ord.total)}</span>
                    <button
                      onClick={() => advanceOrderStatus(ord.id)}
                      className="mt-1.5 px-3 py-1 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-[10px] rounded-lg shadow"
                    >
                      {ord.status === 'CONFIRMED' ? 'Start Packing' : ord.status === 'PACKING' ? 'Ready Pickup' : 'Dispatch'}
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-2xl">
            <h3 className="text-sm font-bold text-white mb-4">Low Stock Restock Warnings</h3>
            <div className="space-y-3">
              {inventoryList
                .filter((item) => item.lowStock)
                .map((item) => (
                  <div key={item.id} className="p-3.5 bg-amber-500/10 border border-amber-500/30 rounded-xl flex items-center justify-between">
                    <div>
                      <h4 className="text-xs font-bold text-white">{item.name}</h4>
                      <p className="text-[10px] text-amber-300">SKU: {item.sku}</p>
                    </div>
                    <div className="flex items-center gap-3">
                      <span className="text-xs font-extrabold text-amber-400">{item.stock} left</span>
                      <button onClick={() => updateStock(item.id, 20)} className="px-3 py-1 bg-amber-600 hover:bg-amber-500 text-slate-950 font-extrabold text-[10px] rounded-lg">
                        + Restock 20
                      </button>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        </div>
      )}

      {/* Tab 2: INVENTORY */}
      {activeTab === 'INVENTORY' && (
        <div className="bg-slate-800/80 border border-slate-700/60 rounded-2xl p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-bold text-white">Store Inventory Catalog ({inventoryList.length} SKUs)</h3>
            <button className="px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl flex items-center gap-1.5 shadow">
              <Plus className="w-4 h-4" />
              <span>Add New Product</span>
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs text-slate-300">
              <thead className="bg-slate-900/60 text-slate-400 font-semibold border-b border-slate-700">
                <tr>
                  <th className="p-3">Product Name</th>
                  <th className="p-3">SKU</th>
                  <th className="p-3">Price</th>
                  <th className="p-3">Available Stock</th>
                  <th className="p-3">Reserved</th>
                  <th className="p-3">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-700/60">
                {inventoryList.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-800/50">
                    <td className="p-3 font-bold text-white">{item.name}</td>
                    <td className="p-3 text-slate-400 font-mono">{item.sku}</td>
                    <td className="p-3 text-emerald-400 font-bold">{formatCurrency(item.price)}</td>
                    <td className="p-3 font-extrabold">
                      <span className={item.lowStock ? 'text-amber-400' : 'text-white'}>{item.stock}</span>
                    </td>
                    <td className="p-3 text-slate-400">{item.reserved}</td>
                    <td className="p-3">
                      <div className="flex items-center gap-1.5">
                        <button onClick={() => updateStock(item.id, -1)} className="px-2 py-1 bg-slate-700 hover:bg-slate-600 rounded text-xs font-bold text-white">
                          -
                        </button>
                        <button onClick={() => updateStock(item.id, 1)} className="px-2 py-1 bg-slate-700 hover:bg-slate-600 rounded text-xs font-bold text-white">
                          +
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

      {/* Tab 3: ORDERS QUEUE */}
      {activeTab === 'ORDERS' && (
        <div className="bg-slate-800/80 border border-slate-700/60 rounded-2xl p-5 space-y-4">
          <h3 className="text-sm font-bold text-white">Real-Time Store Fulfillment Queue</h3>
          <div className="space-y-3">
            {ordersQueue.map((ord) => (
              <div key={ord.id} className="p-4 bg-slate-900/70 rounded-xl border border-slate-700 flex items-center justify-between">
                <div>
                  <div className="flex items-center gap-3">
                    <span className="text-sm font-extrabold text-white">{ord.id}</span>
                    <span className="text-xs bg-emerald-500/20 text-emerald-400 px-2.5 py-0.5 rounded-full font-bold">{ord.status}</span>
                  </div>
                  <p className="text-xs text-slate-300 font-semibold mt-1">Customer: {ord.customer}</p>
                  <p className="text-xs text-slate-400 mt-0.5">{ord.items}</p>
                </div>
                <div className="flex items-center gap-3">
                  <span className="text-sm font-extrabold text-emerald-400">{formatCurrency(ord.total)}</span>
                  <button onClick={() => advanceOrderStatus(ord.id)} className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow">
                    Advance Status
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Tab 4: ANALYTICS */}
      {activeTab === 'ANALYTICS' && (
        <div className="bg-slate-800/80 border border-slate-700/60 rounded-2xl p-5 space-y-4">
          <h3 className="text-sm font-bold text-white">Top Selling Products Breakdown</h3>
          <div className="space-y-3">
            {[
              { name: 'Fresh Organic Farm Tomatoes', sold: '420 Units', revenue: '₹10,080' },
              { name: 'Amul Taaza Toned Milk', sold: '350 Units', revenue: '₹18,900' },
              { name: 'Brown Sandwich Bread', sold: '210 Units', revenue: '₹9,450' },
            ].map((p, idx) => (
              <div key={p.name} className="p-3 bg-slate-900/60 rounded-xl flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <span className="w-6 h-6 rounded-full bg-slate-700 flex items-center justify-center text-xs font-bold text-slate-300">{idx + 1}</span>
                  <div>
                    <p className="text-xs font-bold text-white">{p.name}</p>
                    <p className="text-[10px] text-slate-400">{p.sold}</p>
                  </div>
                </div>
                <span className="text-xs font-extrabold text-emerald-400">{p.revenue}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
