'use client';

import React, { useEffect, useState } from 'react';

interface StoreItem {
  id: string;
  name: string;
  code: string;
  city: string;
  type: string;
  isOpen: boolean;
  activeOrders: number;
}

interface WarehouseItem {
  id: string;
  name: string;
  code: string;
  capacitySqFt: number;
  occupancyPercent: number;
}

export default function EnterpriseOperationsPage() {
  const [activeTab, setActiveTab] = useState<'stores' | 'warehouses' | 'transfers' | 'fleet' | 'franchise' | 'employees' | 'observability'>('stores');

  const [stores, setStores] = useState<StoreItem[]>([
    { id: 'store_01', name: 'Daily Basket Main Kirana (Indiranagar)', code: 'DB_BLR_01', city: 'Bengaluru', type: 'OWNED', isOpen: true, activeOrders: 8 },
    { id: 'store_02', name: 'Daily Basket Express (Koramangala)', code: 'DB_BLR_02', city: 'Bengaluru', type: 'FRANCHISE', isOpen: true, activeOrders: 14 },
    { id: 'store_03', name: 'Daily Basket Superstore (HSR Layout)', code: 'DB_BLR_03', city: 'Bengaluru', type: 'OWNED', isOpen: true, activeOrders: 11 },
  ]);

  const [warehouses, setWarehouses] = useState<WarehouseItem[]>([
    { id: 'wh_01', name: 'Central Fulfillment Hub - Whitefield', code: 'WH_BLR_01', capacitySqFt: 35000, occupancyPercent: 68.4 },
    { id: 'wh_02', name: 'North Micro-Warehouse - Peenya', code: 'WH_BLR_02', capacitySqFt: 18000, occupancyPercent: 52.1 },
  ]);

  return (
    <div className="p-8 max-w-7xl mx-auto space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">
          🌐 Enterprise Multi-Store & Supply Chain Platform
        </h1>
        <p className="text-sm text-gray-500 mt-1">
          Enterprise command center for multi-store networks, dark warehouses, inter-location stock transfers, EV fleets, franchise revenue sharing, and system observability.
        </p>
      </div>

      {/* Navigation Tabs */}
      <div className="flex border-b border-gray-200 space-x-6 overflow-x-auto">
        <button
          onClick={() => setActiveTab('stores')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'stores'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🏬 Multi-Store Registry (3)
        </button>
        <button
          onClick={() => setActiveTab('warehouses')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'warehouses'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🏭 Dark Warehouses (2)
        </button>
        <button
          onClick={() => setActiveTab('transfers')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'transfers'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🔄 Stock Transfers
        </button>
        <button
          onClick={() => setActiveTab('fleet')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'fleet'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🚚 EV Fleet & Zones
        </button>
        <button
          onClick={() => setActiveTab('franchise')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'franchise'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🤝 Franchise Network
        </button>
        <button
          onClick={() => setActiveTab('employees')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'employees'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          👥 Employee Roster
        </button>
        <button
          onClick={() => setActiveTab('observability')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'observability'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          📈 System Observability
        </button>
      </div>

      {/* Tab 1: Multi-Store Registry */}
      {activeTab === 'stores' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <div className="flex justify-between items-center">
            <h2 className="text-lg font-bold text-gray-900">Multi-Store Network Registry</h2>
            <button className="px-4 py-2 bg-emerald-600 text-white text-xs font-bold rounded-lg hover:bg-emerald-700">
              + Onboard New Store
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="p-3 font-bold text-gray-700">Store Name & Code</th>
                  <th className="p-3 font-bold text-gray-700">City</th>
                  <th className="p-3 font-bold text-gray-700">Type</th>
                  <th className="p-3 font-bold text-gray-700">Active Orders</th>
                  <th className="p-3 font-bold text-gray-700">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {stores.map((s) => (
                  <tr key={s.id}>
                    <td className="p-3 font-semibold text-gray-900">{s.name} <span className="text-gray-400 font-mono">({s.code})</span></td>
                    <td className="p-3 text-gray-700">{s.city}</td>
                    <td className="p-3"><span className="px-2 py-0.5 bg-blue-50 text-blue-700 border border-blue-200 rounded font-bold">{s.type}</span></td>
                    <td className="p-3 font-bold text-emerald-600">{s.activeOrders} active</td>
                    <td className="p-3"><span className="px-2 py-0.5 bg-emerald-100 text-emerald-800 rounded font-bold">ONLINE</span></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Tab 2: Dark Warehouses */}
      {activeTab === 'warehouses' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <div className="flex justify-between items-center">
            <h2 className="text-lg font-bold text-gray-900">Dark Warehouse Fulfillment Hubs</h2>
            <button className="px-4 py-2 bg-emerald-600 text-white text-xs font-bold rounded-lg hover:bg-emerald-700">
              + Register Dark Warehouse
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {warehouses.map((wh) => (
              <div key={wh.id} className="p-5 border border-gray-200 rounded-xl space-y-3 bg-gray-50">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="font-bold text-gray-900">{wh.name}</h3>
                    <div className="text-xs text-gray-500 font-mono">{wh.code}</div>
                  </div>
                  <span className="px-2 py-1 bg-emerald-100 text-emerald-800 text-xs font-bold rounded">ACTIVE</span>
                </div>
                <div className="text-xs text-gray-600">Capacity: <strong>{wh.capacitySqFt.toLocaleString()} sq. ft.</strong></div>
                <div>
                  <div className="flex justify-between text-xs font-bold text-gray-700 mb-1">
                    <span>Storage Occupancy</span>
                    <span>{wh.occupancyPercent}%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-emerald-600 h-2 rounded-full" style={{ width: `${wh.occupancyPercent}%` }}></div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Tab 3: Stock Transfers */}
      {activeTab === 'transfers' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">Inter-Location Stock Transfers</h2>
          <div className="p-4 bg-gray-50 border rounded-xl flex justify-between items-center text-xs">
            <div>
              <span className="font-mono font-bold text-gray-900">TR-2026-089</span> — Whitefield Central Hub ➔ Indiranagar Main Kirana (14 items)
            </div>
            <span className="px-2 py-1 bg-blue-100 text-blue-800 font-bold rounded">IN_TRANSIT</span>
          </div>
        </div>
      )}

      {/* Tab 4: Fleet */}
      {activeTab === 'fleet' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">EV Delivery Fleet & Zone Management</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-xs">
            <div className="p-4 bg-emerald-50 border border-emerald-200 rounded-xl">
              <div className="font-bold text-emerald-900">🛵 EV Scooter KA-01-EQ-9821</div>
              <div className="text-emerald-700">Driver: Rohan Kumar • Battery: 92%</div>
            </div>
            <div className="p-4 bg-emerald-50 border border-emerald-200 rounded-xl">
              <div className="font-bold text-emerald-900">🛵 EV Scooter KA-05-EQ-1142</div>
              <div className="text-emerald-700">Driver: Sunil Gowda • Battery: 68%</div>
            </div>
          </div>
        </div>
      )}

      {/* Tab 5: Franchise */}
      {activeTab === 'franchise' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">Franchise Revenue Sharing & Settlement</h2>
          <div className="p-4 bg-gray-50 border rounded-xl flex justify-between items-center text-xs">
            <div>
              <div className="font-bold text-gray-900">Koramangala Franchise Store #02</div>
              <div className="text-gray-500">Apex Retail Enterprises LLP • Commission Rate: 8.5%</div>
            </div>
            <div className="text-right">
              <div className="font-bold text-emerald-600">₹87,210 Commission</div>
              <div className="text-gray-400">Monthly gross ₹10,26,000</div>
            </div>
          </div>
        </div>
      )}

      {/* Tab 6: Employees */}
      {activeTab === 'employees' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">Employee Roster & Shifts</h2>
          <div className="text-xs text-gray-600">38 Store & Warehouse Employees active across shift rosters.</div>
        </div>
      )}

      {/* Tab 7: Observability */}
      {activeTab === 'observability' && (
        <div className="space-y-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">API Gateway Latency</span>
              <div className="text-3xl font-extrabold text-emerald-600 mt-2">22 ms</div>
            </div>
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">Redis Pub/Sub</span>
              <div className="text-3xl font-extrabold text-emerald-600 mt-2">2 ms</div>
            </div>
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">BullMQ Queue Depth</span>
              <div className="text-3xl font-extrabold text-gray-900 mt-2">0 jobs</div>
            </div>
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">Prisma Connections</span>
              <div className="text-3xl font-extrabold text-gray-900 mt-2">14 / 50</div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
