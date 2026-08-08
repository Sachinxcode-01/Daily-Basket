'use client';

import React, { useEffect, useState } from 'react';

interface StoreStatus {
  storeId: string;
  name: string;
  isOpen: boolean;
  businessHours: { open: string; close: string };
  deliveryRadiusKm: number;
  minOrderValue: number;
  storeCapacityPerHour: number;
  orderCutoffTime: string;
  isMaintenanceMode: boolean;
}

interface SupplierItem {
  id: string;
  name: string;
  code: string;
  contactPerson: string;
  phone: string;
  rating: number;
}

interface PurchaseOrderItem {
  id: string;
  poNumber: string;
  supplierName: string;
  status: string;
  totalAmount: number;
}

export default function StoreOperationsPage() {
  const [activeTab, setActiveTab] = useState<'store' | 'inventory' | 'purchase' | 'finance' | 'customers' | 'documents' | 'insights'>('store');

  const [storeStatus, setStoreStatus] = useState<StoreStatus>({
    storeId: 'store_01',
    name: 'Daily Basket Main Kirana Store',
    isOpen: true,
    businessHours: { open: '07:00', close: '22:00' },
    deliveryRadiusKm: 5.0,
    minOrderValue: 149.0,
    storeCapacityPerHour: 60,
    orderCutoffTime: '21:30',
    isMaintenanceMode: false,
  });

  const [suppliers, setSuppliers] = useState<SupplierItem[]>([
    { id: 'sup_01', name: 'Amul Dairy Distributors Pvt Ltd', code: 'AMUL_BLR', contactPerson: 'Ramesh Patel', phone: '+91 98765 43210', rating: 4.9 },
    { id: 'sup_02', name: 'ITC FMCG Supply Chain', code: 'ITC_SOUTH', contactPerson: 'Suresh Rao', phone: '+91 98123 45678', rating: 4.8 },
  ]);

  const [purchaseOrders, setPurchaseOrders] = useState<PurchaseOrderItem[]>([
    { id: 'po_101', poNumber: 'PO-2026-001', supplierName: 'Amul Dairy Distributors', status: 'APPROVED', totalAmount: 14500.0 },
    { id: 'po_102', poNumber: 'PO-2026-002', supplierName: 'ITC FMCG Supply Chain', status: 'SUBMITTED', totalAmount: 28400.0 },
  ]);

  const [statusMessage, setStatusMessage] = useState<string>('');

  const handleToggleStore = () => {
    const updated = !storeStatus.isOpen;
    setStoreStatus({ ...storeStatus, isOpen: updated });
    setStatusMessage(`Store status changed to ${updated ? 'OPEN' : 'CLOSED'}`);
    setTimeout(() => setStatusMessage(''), 3000);
  };

  const handleToggleMaintenance = () => {
    const updated = !storeStatus.isMaintenanceMode;
    setStoreStatus({ ...storeStatus, isMaintenanceMode: updated });
    setStatusMessage(`Maintenance mode ${updated ? 'ENABLED' : 'DISABLED'}`);
    setTimeout(() => setStatusMessage(''), 3000);
  };

  return (
    <div className="p-8 max-w-7xl mx-auto space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">
          🏪 Store Operations & Business Management Platform
        </h1>
        <p className="text-sm text-gray-500 mt-1">
          Single-store kirana operations control center for store settings, inventory audits, purchase orders, finance ledgers, and AI business insights.
        </p>
      </div>

      {statusMessage && (
        <div className="p-4 bg-emerald-100 border border-emerald-300 text-emerald-800 text-sm font-bold rounded-xl shadow-sm">
          {statusMessage}
        </div>
      )}

      {/* Navigation Tabs */}
      <div className="flex border-b border-gray-200 space-x-6 overflow-x-auto">
        <button
          onClick={() => setActiveTab('store')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'store'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🏪 Store Status & Hours
        </button>
        <button
          onClick={() => setActiveTab('inventory')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'inventory'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          📦 Inventory & Batches
        </button>
        <button
          onClick={() => setActiveTab('purchase')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'purchase'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🚚 Purchase Orders & Suppliers
        </button>
        <button
          onClick={() => setActiveTab('finance')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'finance'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          📊 Finance & P&L Statement
        </button>
        <button
          onClick={() => setActiveTab('customers')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'customers'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          👥 Customers & VIPs
        </button>
        <button
          onClick={() => setActiveTab('documents')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'documents'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          📁 Digital Document Vault
        </button>
        <button
          onClick={() => setActiveTab('insights')}
          className={`pb-4 text-sm font-semibold border-b-2 whitespace-nowrap transition-colors ${
            activeTab === 'insights'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          🤖 AI Insights & Forecasts
        </button>
      </div>

      {/* Tab 1: Store Status & Settings */}
      {activeTab === 'store' && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
            <h2 className="text-lg font-bold text-gray-900">Live Store Operating Status</h2>

            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-200">
              <div>
                <div className="text-sm font-bold text-gray-900">Store Open Status</div>
                <div className="text-xs text-gray-500">
                  {storeStatus.isOpen ? 'Store is accepting 10-min orders' : 'Store is currently closed to new orders'}
                </div>
              </div>
              <button
                onClick={handleToggleStore}
                className={`px-4 py-2 text-xs font-bold rounded-lg shadow-sm text-white ${
                  storeStatus.isOpen ? 'bg-emerald-600 hover:bg-emerald-700' : 'bg-red-600 hover:bg-red-700'
                }`}
              >
                {storeStatus.isOpen ? 'OPEN' : 'CLOSED'}
              </button>
            </div>

            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-200">
              <div>
                <div className="text-sm font-bold text-gray-900">Maintenance Mode</div>
                <div className="text-xs text-gray-500">Temporarily pause order intake for restocking</div>
              </div>
              <button
                onClick={handleToggleMaintenance}
                className={`px-4 py-2 text-xs font-bold rounded-lg shadow-sm text-white ${
                  storeStatus.isMaintenanceMode ? 'bg-amber-600 hover:bg-amber-700' : 'bg-gray-600 hover:bg-gray-700'
                }`}
              >
                {storeStatus.isMaintenanceMode ? 'ACTIVE' : 'INACTIVE'}
              </button>
            </div>
          </div>

          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-4">
            <h2 className="text-lg font-bold text-gray-900">Delivery & Store Capacity Parameters</h2>

            <div className="space-y-3">
              <div>
                <label className="text-xs font-bold text-gray-700">Delivery Radius (km)</label>
                <input
                  type="number"
                  value={storeStatus.deliveryRadiusKm}
                  onChange={(e) => setStoreStatus({ ...storeStatus, deliveryRadiusKm: parseFloat(e.target.value) })}
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-300 rounded-lg"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-gray-700">Minimum Order Value (₹)</label>
                <input
                  type="number"
                  value={storeStatus.minOrderValue}
                  onChange={(e) => setStoreStatus({ ...storeStatus, minOrderValue: parseFloat(e.target.value) })}
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-300 rounded-lg"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-gray-700">Daily Order Cutoff Time</label>
                <input
                  type="text"
                  value={storeStatus.orderCutoffTime}
                  onChange={(e) => setStoreStatus({ ...storeStatus, orderCutoffTime: e.target.value })}
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-300 rounded-lg"
                />
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Tab 2: Inventory & Batches */}
      {activeTab === 'inventory' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <div className="flex justify-between items-center">
            <h2 className="text-lg font-bold text-gray-900">Live Inventory Batches & Expiry Tracking</h2>
            <button className="px-4 py-2 bg-emerald-600 text-white text-xs font-bold rounded-lg hover:bg-emerald-700">
              + Add Stock Adjustment
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="p-3 font-bold text-gray-700">Item & Variant</th>
                  <th className="p-3 font-bold text-gray-700">Shelf Location</th>
                  <th className="p-3 font-bold text-gray-700">Stock Qty</th>
                  <th className="p-3 font-bold text-gray-700">Reorder Level</th>
                  <th className="p-3 font-bold text-gray-700">Expiry Date</th>
                  <th className="p-3 font-bold text-gray-700">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                <tr>
                  <td className="p-3 font-semibold text-gray-900">Amul Taaza Milk 1L</td>
                  <td className="p-3 text-gray-600 font-mono">COOLER-01</td>
                  <td className="p-3 font-bold text-emerald-600">42 units</td>
                  <td className="p-3 text-gray-500">20 units</td>
                  <td className="p-3 text-gray-700">2026-08-10</td>
                  <td className="p-3"><span className="px-2 py-1 bg-emerald-100 text-emerald-800 rounded font-bold">STOCKED</span></td>
                </tr>
                <tr>
                  <td className="p-3 font-semibold text-gray-900">Aashirvaad Chakki Atta 5kg</td>
                  <td className="p-3 text-gray-600 font-mono">SHELF-A3</td>
                  <td className="p-3 font-bold text-amber-600">6 units</td>
                  <td className="p-3 text-gray-500">10 units</td>
                  <td className="p-3 text-gray-700">2026-11-15</td>
                  <td className="p-3"><span className="px-2 py-1 bg-amber-100 text-amber-800 rounded font-bold">LOW STOCK</span></td>
                </tr>
                <tr>
                  <td className="p-3 font-semibold text-gray-900">Britannia Whole Wheat Bread</td>
                  <td className="p-3 text-gray-600 font-mono">SHELF-B1</td>
                  <td className="p-3 font-bold text-red-600">2 units</td>
                  <td className="p-3 text-gray-500">15 units</td>
                  <td className="p-3 text-gray-700">2026-08-09</td>
                  <td className="p-3"><span className="px-2 py-1 bg-red-100 text-red-800 rounded font-bold">NEAR EXPIRY</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Tab 3: Purchase Management */}
      {activeTab === 'purchase' && (
        <div className="space-y-8">
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
            <h2 className="text-lg font-bold text-gray-900">Purchase Orders (POs) & GRN Receipts</h2>
            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs">
                <thead className="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th className="p-3 font-bold text-gray-700">PO Number</th>
                    <th className="p-3 font-bold text-gray-700">Supplier</th>
                    <th className="p-3 font-bold text-gray-700">Total Amount</th>
                    <th className="p-3 font-bold text-gray-700">Status</th>
                    <th className="p-3 font-bold text-gray-700">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200">
                  {purchaseOrders.map((po) => (
                    <tr key={po.id}>
                      <td className="p-3 font-mono font-bold text-gray-900">{po.poNumber}</td>
                      <td className="p-3 text-gray-700">{po.supplierName}</td>
                      <td className="p-3 font-bold text-gray-900">₹{po.totalAmount.toLocaleString()}</td>
                      <td className="p-3">
                        <span className="px-2 py-1 bg-blue-100 text-blue-800 rounded font-bold">{po.status}</span>
                      </td>
                      <td className="p-3">
                        <button className="px-3 py-1 bg-emerald-600 text-white rounded font-bold hover:bg-emerald-700">
                          Receive GRN
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Tab 4: Finance */}
      {activeTab === 'finance' && (
        <div className="space-y-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">Gross Revenue</span>
              <div className="text-3xl font-extrabold text-gray-900 mt-2">₹4,82,900</div>
            </div>
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">Net Profit</span>
              <div className="text-3xl font-extrabold text-emerald-600 mt-2">₹86,900</div>
            </div>
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">GST Tax Collected</span>
              <div className="text-3xl font-extrabold text-gray-900 mt-2">₹43,461</div>
            </div>
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase">Daily Closing</span>
              <div className="text-sm font-extrabold text-emerald-600 mt-2">LOCKED & BALANCED</div>
            </div>
          </div>
        </div>
      )}

      {/* Tab 5: Customers */}
      {activeTab === 'customers' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">Customer Success & Tagging</h2>
          <div className="flex gap-4">
            <span className="px-3 py-1 bg-amber-100 text-amber-800 rounded font-bold text-xs">⭐ 14 VIP Customers</span>
            <span className="px-3 py-1 bg-emerald-100 text-emerald-800 rounded font-bold text-xs">💚 342 Loyal Shoppers</span>
            <span className="px-3 py-1 bg-red-100 text-red-800 rounded font-bold text-xs">🚫 2 Blocked Profiles</span>
          </div>
        </div>
      )}

      {/* Tab 6: Documents */}
      {activeTab === 'documents' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">Digital Document Vault</h2>
          <div className="space-y-2">
            <div className="flex justify-between p-3 bg-gray-50 border rounded-lg text-xs">
              <span className="font-bold text-gray-800">📄 GST Return Filing July 2026</span>
              <a href="#" className="text-emerald-600 font-bold hover:underline">Download PDF (1.2 MB)</a>
            </div>
            <div className="flex justify-between p-3 bg-gray-50 border rounded-lg text-xs">
              <span className="font-bold text-gray-800">📄 Amul Dairy Purchase Bill #INV-9821</span>
              <a href="#" className="text-emerald-600 font-bold hover:underline">Download PDF (480 KB)</a>
            </div>
          </div>
        </div>
      )}

      {/* Tab 7: AI Insights */}
      {activeTab === 'insights' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">🤖 AI Inventory Forecast & Profit Recommendations</h2>
          <div className="space-y-3">
            <div className="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-900 font-medium">
              💡 <strong>Profit Margin Tip:</strong> Increasing Amul Taaza Milk batch size by 15% on Friday will reduce supplier freight cost by ₹650.
            </div>
            <div className="p-4 bg-amber-50 border border-amber-200 rounded-xl text-xs text-amber-900 font-medium">
              ⚠️ <strong>Stock Depletion Alert:</strong> Aashirvaad Atta 5kg will deplete in 1.4 days based on current weekend purchase velocity.
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
