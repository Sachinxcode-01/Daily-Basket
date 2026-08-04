'use client';

import React from 'react';
import { Users, TrendingUp, DollarSign, Award, ArrowUpRight, Search } from 'lucide-react';

export default function CustomerInsightsPage() {
  const customers = [
    { id: 'CUST-8910', name: 'Ananya Sharma', email: 'ananya@example.com', ordersCount: 42, totalSpent: '₹14,820', cohort: 'Daily Basket Plus', status: 'ACTIVE' },
    { id: 'CUST-8911', name: 'Vikram Mehta', email: 'vikram.m@example.com', ordersCount: 28, totalSpent: '₹9,450', cohort: 'Regular', status: 'ACTIVE' },
    { id: 'CUST-8912', name: 'Priya Nair', email: 'priya.nair@example.com', ordersCount: 15, totalSpent: '₹5,120', cohort: 'Regular', status: 'ACTIVE' },
    { id: 'CUST-8913', name: 'Rohan Gupta', email: 'rohan.g@example.com', ordersCount: 3, totalSpent: '₹890', cohort: 'New Customer', status: 'AT_RISK' },
  ];

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Customer Insights</h1>
          <p className="text-sm text-[#3f4a3d]">Analyze buyer cohorts, lifetime value (LTV), retention rates, and basket size.</p>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Total Customers</span>
          <div className="text-3xl font-black text-[#1a1c1e]">48,920</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            <ArrowUpRight className="w-3.5 h-3.5" /> +8.4% this month
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Average LTV</span>
          <div className="text-3xl font-black text-[#1a1c1e]">₹3,420</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            <ArrowUpRight className="w-3.5 h-3.5" /> +12.1% YoY
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">30-Day Retention Rate</span>
          <div className="text-3xl font-black text-[#1a1c1e]">78.4%</div>
          <div className="flex items-center gap-1 text-xs text-[#3f4a3d]">
            Top tier quick commerce retention
          </div>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-2">
          <span className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Daily Basket Plus Members</span>
          <div className="text-3xl font-black text-[#1a1c1e]">12,450</div>
          <div className="flex items-center gap-1 text-xs text-emerald-700 font-bold">
            25.4% member penetration
          </div>
        </div>
      </div>

      {/* Customers Table */}
      <div className="bg-white rounded-3xl p-6 shadow-sm border border-[#e2e2e5] space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-bold text-[#1a1c1e]">Customer Roster & Cohorts</h2>
          <div className="relative w-64">
            <Search className="w-4 h-4 text-[#3f4a3d] absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search customer email..."
              className="w-full pl-9 pr-4 py-1.5 bg-[#f3f3f6] border border-transparent rounded-xl text-xs focus:outline-none focus:border-[#006b23] focus:bg-white transition"
            />
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-[#e2e2e5] text-[#3f4a3d] uppercase font-bold tracking-wider">
                <th className="pb-3">Customer ID</th>
                <th className="pb-3">Name</th>
                <th className="pb-3">Email</th>
                <th className="pb-3">Orders Count</th>
                <th className="pb-3">Total LTV Spent</th>
                <th className="pb-3">Cohort Segment</th>
                <th className="pb-3">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e2e2e5]">
              {customers.map((c) => (
                <tr key={c.id} className="hover:bg-[#f3f3f6] transition">
                  <td className="py-3.5 font-mono font-bold text-[#006b23]">{c.id}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{c.name}</td>
                  <td className="py-3.5 text-[#3f4a3d]">{c.email}</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{c.ordersCount} orders</td>
                  <td className="py-3.5 font-bold text-[#1a1c1e]">{c.totalSpent}</td>
                  <td className="py-3.5 font-semibold text-[#006b23]">{c.cohort}</td>
                  <td className="py-3.5">
                    <span className="px-2.5 py-1 bg-[#dce5dd] text-[#006b23] rounded-full font-bold text-[10px]">
                      {c.status}
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
