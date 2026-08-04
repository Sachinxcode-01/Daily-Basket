'use client';

import React, { useState } from 'react';
import { ShoppingCart, Filter, Clock, CheckCircle2, AlertCircle, RefreshCcw } from 'lucide-react';

export default function OrderManagementPage() {
  const [orders, setOrders] = useState([
    { id: 'ORD-9824', customer: 'Aarav Sharma', items: '2x Organic Hass Avocados, 1x Amul Milk', amount: '₹240', payment: 'UPI (GPay)', status: 'PACKING', darkStore: 'Indiranagar Hub', timer: '2m 14s' },
    { id: 'ORD-9825', name: 'Neha Gupta', items: '5x Vegetables & Greens', amount: '₹410', payment: 'Credit Card', status: 'OUT_FOR_DELIVERY', darkStore: 'Koramangala Hub', timer: '5m 02s' },
    { id: 'ORD-9826', name: 'Rahul Verma', items: '1x Exotic Fruit Box', amount: '₹299', payment: 'Wallet', status: 'CONFIRMED', darkStore: 'HSR Layout Hub', timer: '0m 45s' },
    { id: 'ORD-9827', name: 'Siddharth R.', items: '4x Snacks & Beverages', amount: '₹180', payment: 'Cash on Delivery', status: 'DELIVERED', darkStore: 'Indiranagar Hub', timer: '8m 40s' },
  ]);

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Order Management</h1>
          <p className="text-sm text-[#3f4a3d]">Monitor active 10-minute order pipeline, dispatch states, and dark store packing speeds.</p>
        </div>
      </div>

      {/* Pipeline Status Kanban Chips */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-white rounded-2xl p-4 border border-[#e2e2e5]">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase">1. Confirmed</span>
          <div className="text-2xl font-black text-[#1a1c1e] mt-1">12 orders</div>
        </div>

        <div className="bg-white rounded-2xl p-4 border border-[#e2e2e5]">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase">2. Packing</span>
          <div className="text-2xl font-black text-[#1a1c1e] mt-1">26 orders</div>
        </div>

        <div className="bg-white rounded-2xl p-4 border border-[#e2e2e5]">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase">3. Out For Delivery</span>
          <div className="text-2xl font-black text-[#006b23] mt-1">104 orders</div>
        </div>

        <div className="bg-white rounded-2xl p-4 border border-[#e2e2e5]">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase">4. Delivered Today</span>
          <div className="text-2xl font-black text-[#1a1c1e] mt-1">1,240 orders</div>
        </div>
      </div>

      {/* Orders Table */}
      <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-[#e2e2e5] text-[#3f4a3d] uppercase font-bold tracking-wider">
                <th className="pb-3">Order ID</th>
                <th className="pb-3">Customer</th>
                <th className="pb-3">Items Summary</th>
                <th className="pb-3">Amount</th>
                <th className="pb-3">Payment</th>
                <th className="pb-3">Hub</th>
                <th className="pb-3">Status</th>
                <th className="pb-3">SLA Clock</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e2e2e5]">
              {orders.map((ord) => (
                <tr key={ord.id} className="hover:bg-[#f3f3f6] transition">
                  <td className="py-3.5 font-mono font-bold text-[#006b23]">{ord.id}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{ord.customer || ord.name}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{ord.items}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{ord.amount}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{ord.payment}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{ord.darkStore}</td>
                  <td className="py-3.5">
                    <span className="px-2.5 py-1 bg-[#dce5dd] text-[#006b23] rounded-full font-bold text-[10px]">
                      {ord.status}
                    </span>
                  </td>
                  <td className="py-3.5 font-mono font-bold text-[#1a1c1e]">{ord.timer}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
