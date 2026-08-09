'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  MoreVertical,
  CheckCircle2,
  Phone,
  MessageSquare,
  Bell,
  IndianRupee,
  PlusCircle,
  ShoppingCart,
  Receipt,
  Wallet,
  TrendingUp,
  Bot,
  Tag,
  RefreshCw,
  Truck,
  Grid,
  ShoppingBag,
  Package,
  BarChart3,
  Smartphone,
  LayoutGrid,
  ShieldCheck,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Customer Profile (360° View) (ID: 3b8d81b5e2a4402290eddfb1c9e7b8e9)

export default function CustomerProfile360Page() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const customer = {
    id: '#DB-CUS-782',
    name: 'Rahul Sharma',
    joined: 'Joined Mar 2022',
    avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300',
    totalOrders: 142,
    totalSpent: '₹84,200',
    walletBalance: '₹1,240',
    ltvScore: 'High',
    churnRisk: 'Low (5%)',
    avgBasket: '₹850',
    loyaltyTag: 'High Loyalty',
    shopperTag: 'Frequent Shopper',
    affinityFresh: 70,
    affinityDairy: 50,
    affinitySnacks: 30,
    recentOrders: [
      {
        id: 'Order #ORD-8923',
        time: 'Today, 10:42 AM',
        amount: '₹1,240',
        status: 'Out for Delivery',
        statusColor: 'text-[#0284c7]',
        badgeBg: 'bg-sky-50',
        isActive: true,
      },
      {
        id: 'Order #ORD-8810',
        time: '2 days ago',
        amount: '₹850',
        status: 'Delivered',
        statusColor: 'text-[#15803d]',
        badgeBg: 'bg-emerald-50',
        isActive: false,
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Stitch Header Title & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Customer Profile</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 3b8d81b5e2a4402290eddfb1c9e7b8e9 • 360° Customer Intelligence
            </p>
          </div>
        </div>

        {/* View Mode Switches */}
        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('web')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Web Dashboard</span>
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

      {/* Main Content Area */}
      {viewMode === 'mobile' ? (
        /* Mobile Device Frame View simulating exact phone screen */
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Customer Profile</span>
              <MoreVertical className="w-5 h-5 text-[#1e2923] cursor-pointer" />
            </div>

            {/* Scrollable Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              {/* Identity Header Card */}
              <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm text-center space-y-3">
                <div className="relative inline-block mx-auto">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={customer.avatar}
                    alt={customer.name}
                    className="w-20 h-20 rounded-2xl object-cover"
                  />
                  <div className="absolute bottom-0 right-0 p-0.5 bg-white rounded-full">
                    <div className="p-0.5 bg-emerald-600 rounded-full text-white">
                      <CheckCircle2 className="w-3.5 h-3.5" />
                    </div>
                  </div>
                </div>

                <div>
                  <h2 className="text-xl font-black text-[#1e2923]">{customer.name}</h2>
                  <p className="text-xs text-[#64748b]">
                    ID: {customer.id} • {customer.joined}
                  </p>
                </div>

                <div className="flex justify-center gap-2">
                  <span className="px-3.5 py-1 bg-[#dcfce7] text-[#15803d] text-xs font-bold rounded-full">
                    VIP Member
                  </span>
                  <span className="px-3.5 py-1 bg-[#dce6fe] text-[#2563eb] text-xs font-bold rounded-full">
                    Verified
                  </span>
                </div>
              </div>

              {/* Quick Actions Strip */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                {[
                  { icon: Phone, label: 'Call' },
                  { icon: MessageSquare, label: 'Chat' },
                  { icon: Bell, label: 'Notify' },
                  { icon: IndianRupee, label: 'Refund' },
                  { icon: PlusCircle, label: 'Credit' },
                ].map((act) => (
                  <button
                    key={act.label}
                    onClick={() => setActiveModal(act.label)}
                    className="min-w-[68px] bg-white border border-[#e2e8f0] py-3 rounded-2xl flex flex-col items-center gap-1 shadow-sm hover:bg-[#f8fafc]"
                  >
                    <act.icon className="w-4 h-4 text-[#006837]" />
                    <span className="text-[11px] font-bold text-[#1e2923]">{act.label}</span>
                  </button>
                ))}
              </div>

              {/* Metrics 2x2 Grid */}
              <div className="grid grid-cols-2 gap-3">
                <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                    <ShoppingCart className="w-4 h-4" /> Total Orders
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{customer.totalOrders}</p>
                </div>

                <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                    <Receipt className="w-4 h-4" /> Total Spent
                  </div>
                  <p className="text-2xl font-black text-[#006837]">{customer.totalSpent}</p>
                </div>

                <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                  <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                    <Wallet className="w-4 h-4" /> Wallet
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{customer.walletBalance}</p>
                </div>

                <div className="bg-[#e6f4ea] p-4 rounded-3xl border border-[#a7f3d0] shadow-sm space-y-1">
                  <div className="flex items-center gap-1.5 text-[#047857] text-xs font-bold">
                    <TrendingUp className="w-4 h-4" /> LTV Score
                  </div>
                  <p className="text-2xl font-black text-[#006837]">{customer.ltvScore}</p>
                </div>
              </div>

              {/* AI Insights Card */}
              <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                <div className="flex items-center gap-2">
                  <Bot className="w-5 h-5 text-[#006837]" />
                  <h4 className="font-black text-base text-[#1e2923]">AI Insights</h4>
                </div>

                <div className="flex gap-2">
                  <span className="px-3 py-1 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1">
                    <Tag className="w-3.5 h-3.5" /> {customer.loyaltyTag}
                  </span>
                  <span className="px-3 py-1 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1">
                    <RefreshCw className="w-3.5 h-3.5" /> {customer.shopperTag}
                  </span>
                </div>

                <div className="space-y-2 text-xs pt-1">
                  <div className="flex justify-between items-center">
                    <span className="text-[#64748b]">Churn Risk</span>
                    <span className="px-2.5 py-0.5 bg-[#dcfce7] text-[#15803d] font-bold rounded-md">
                      {customer.churnRisk}
                    </span>
                  </div>
                  <div className="w-full h-[1px] bg-[#f1f5f9]" />
                  <div className="flex justify-between items-center">
                    <span className="text-[#64748b]">Avg. Basket</span>
                    <span className="font-black text-sm text-[#1e2923]">{customer.avgBasket}</span>
                  </div>
                </div>

                {/* Category Affinity Bars */}
                <div className="space-y-2 pt-2">
                  <h5 className="font-bold text-xs text-[#1e2923]">Category Affinity</h5>

                  <div className="space-y-1.5 text-[11px]">
                    <div className="flex items-center gap-2">
                      <span className="w-12 text-[#64748b]">Fresh</span>
                      <div className="flex-1 h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                        <div className="h-full bg-[#006837]" style={{ width: `${customer.affinityFresh}%` }} />
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      <span className="w-12 text-[#64748b]">Dairy</span>
                      <div className="flex-1 h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                        <div className="h-full bg-[#475569]" style={{ width: `${customer.affinityDairy}%` }} />
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      <span className="w-12 text-[#64748b]">Snacks</span>
                      <div className="flex-1 h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                        <div className="h-full bg-[#9f1239]" style={{ width: `${customer.affinitySnacks}%` }} />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Recent Orders Timeline */}
              <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                <div className="flex items-center justify-between">
                  <h4 className="font-black text-base text-[#1e2923]">Recent Orders</h4>
                  <button className="text-xs font-bold text-[#006837]">View All</button>
                </div>

                <div className="space-y-3 text-xs">
                  {customer.recentOrders.map((ord) => (
                    <div key={ord.id} className="flex gap-3 items-start">
                      <span
                        className={`w-2.5 h-2.5 rounded-full mt-1 shrink-0 ${
                          ord.isActive ? 'bg-[#006837]' : 'bg-[#cbd5e1]'
                        }`}
                      />
                      <div className="flex-1 space-y-0.5">
                        <div className="flex justify-between items-center">
                          <span className="font-bold text-[#1e2923]">{ord.id}</span>
                          <span className="font-black text-[#1e2923]">{ord.amount}</span>
                        </div>
                        <p className="text-[11px] text-[#64748b]">{ord.time}</p>
                        <div className={`font-bold flex items-center gap-1 ${ord.statusColor}`}>
                          {ord.isActive ? <Truck className="w-3.5 h-3.5" /> : <CheckCircle2 className="w-3.5 h-3.5" />}
                          <span>{ord.status}</span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dce6fe] text-[#1e2923] rounded-2xl"><Grid className="w-4 h-4 text-[#006837]" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><Tag className="w-4 h-4" /> Products</div>
              <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          {/* Left Column: Identity & Metrics (Span 5) */}
          <div className="lg:col-span-5 space-y-6">
            {/* Identity Card */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm text-center space-y-4">
              <div className="relative inline-block mx-auto">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={customer.avatar}
                  alt={customer.name}
                  className="w-24 h-24 rounded-3xl object-cover"
                />
                <div className="absolute bottom-0 right-0 p-1 bg-white rounded-full">
                  <div className="p-1 bg-emerald-600 rounded-full text-white">
                    <CheckCircle2 className="w-4 h-4" />
                  </div>
                </div>
              </div>

              <div>
                <h2 className="text-2xl font-black text-[#1e2923]">{customer.name}</h2>
                <p className="text-xs text-[#64748b] mt-1">
                  ID: {customer.id} • {customer.joined}
                </p>
              </div>

              <div className="flex justify-center gap-3">
                <span className="px-4 py-1.5 bg-[#dcfce7] text-[#15803d] text-xs font-bold rounded-full flex items-center gap-1">
                  <ShieldCheck className="w-4 h-4" /> VIP Member
                </span>
                <span className="px-4 py-1.5 bg-[#dce6fe] text-[#2563eb] text-xs font-bold rounded-full">
                  Verified
                </span>
              </div>

              {/* Quick Action Buttons Bar */}
              <div className="pt-2 grid grid-cols-5 gap-2 text-xs">
                {[
                  { icon: Phone, label: 'Call' },
                  { icon: MessageSquare, label: 'Chat' },
                  { icon: Bell, label: 'Notify' },
                  { icon: IndianRupee, label: 'Refund' },
                  { icon: PlusCircle, label: 'Credit' },
                ].map((act) => (
                  <button
                    key={act.label}
                    onClick={() => setActiveModal(act.label)}
                    className="bg-[#f8fafc] border border-[#e2e8f0] py-3 rounded-2xl flex flex-col items-center gap-1 shadow-sm hover:bg-white hover:border-[#006837] transition"
                  >
                    <act.icon className="w-4 h-4 text-[#006837]" />
                    <span className="text-[11px] font-bold text-[#1e2923]">{act.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Metrics 2x2 Grid */}
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                  <ShoppingCart className="w-4 h-4" /> Total Orders
                </div>
                <p className="text-3xl font-black text-[#1e2923] mt-2">{customer.totalOrders}</p>
              </div>

              <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                  <Receipt className="w-4 h-4" /> Total Spent
                </div>
                <p className="text-3xl font-black text-[#006837] mt-2">{customer.totalSpent}</p>
              </div>

              <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                  <Wallet className="w-4 h-4" /> Wallet Balance
                </div>
                <p className="text-3xl font-black text-[#1e2923] mt-2">{customer.walletBalance}</p>
              </div>

              <div className="bg-[#e6f4ea] p-5 rounded-3xl border border-[#a7f3d0] shadow-sm space-y-1">
                <div className="flex items-center gap-1.5 text-[#047857] text-xs font-bold">
                  <TrendingUp className="w-4 h-4" /> LTV Score
                </div>
                <p className="text-3xl font-black text-[#006837] mt-2">{customer.ltvScore}</p>
              </div>
            </div>
          </div>

          {/* Right Column: AI Insights & Recent Orders (Span 7) */}
          <div className="lg:col-span-7 space-y-6">
            {/* AI Insights Card */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-5">
              <div className="flex items-center gap-2">
                <Bot className="w-6 h-6 text-[#006837]" />
                <h3 className="font-black text-lg text-[#1e2923]">AI Insights & Behavior Analysis</h3>
              </div>

              <div className="flex gap-3">
                <span className="px-4 py-1.5 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1.5">
                  <Tag className="w-4 h-4" /> {customer.loyaltyTag}
                </span>
                <span className="px-4 py-1.5 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1.5">
                  <RefreshCw className="w-4 h-4" /> {customer.shopperTag}
                </span>
              </div>

              <div className="grid grid-cols-2 gap-4 text-xs">
                <div className="bg-[#f8fafc] p-4 rounded-2xl space-y-1">
                  <span className="text-[#64748b]">Predicted Churn Risk</span>
                  <p className="text-base font-black text-[#15803d]">{customer.churnRisk}</p>
                </div>
                <div className="bg-[#f8fafc] p-4 rounded-2xl space-y-1">
                  <span className="text-[#64748b]">Average Basket Size</span>
                  <p className="text-base font-black text-[#1e2923]">{customer.avgBasket}</p>
                </div>
              </div>

              {/* Category Affinity Bars */}
              <div className="space-y-3 pt-2">
                <h4 className="font-bold text-sm text-[#1e2923]">Category Affinity Index</h4>

                <div className="space-y-2.5 text-xs">
                  <div className="flex items-center gap-3">
                    <span className="w-16 font-bold text-[#64748b]">Fresh</span>
                    <div className="flex-1 h-3 bg-[#f1f5f9] rounded-full overflow-hidden">
                      <div className="h-full bg-[#006837]" style={{ width: `${customer.affinityFresh}%` }} />
                    </div>
                    <span className="w-10 text-right font-bold text-[#1e2923]">70%</span>
                  </div>

                  <div className="flex items-center gap-3">
                    <span className="w-16 font-bold text-[#64748b]">Dairy</span>
                    <div className="flex-1 h-3 bg-[#f1f5f9] rounded-full overflow-hidden">
                      <div className="h-full bg-[#475569]" style={{ width: `${customer.affinityDairy}%` }} />
                    </div>
                    <span className="w-10 text-right font-bold text-[#1e2923]">50%</span>
                  </div>

                  <div className="flex items-center gap-3">
                    <span className="w-16 font-bold text-[#64748b]">Snacks</span>
                    <div className="flex-1 h-3 bg-[#f1f5f9] rounded-full overflow-hidden">
                      <div className="h-full bg-[#9f1239]" style={{ width: `${customer.affinitySnacks}%` }} />
                    </div>
                    <span className="w-10 text-right font-bold text-[#1e2923]">30%</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Recent Orders Timeline */}
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="font-black text-lg text-[#1e2923]">Recent Orders</h3>
                <button className="text-xs font-bold text-[#006837] hover:underline">View All Orders</button>
              </div>

              <div className="space-y-4 text-xs">
                {customer.recentOrders.map((ord) => (
                  <div key={ord.id} className="p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <span
                        className={`w-3 h-3 rounded-full ${
                          ord.isActive ? 'bg-[#006837]' : 'bg-[#cbd5e1]'
                        }`}
                      />
                      <div>
                        <p className="font-extrabold text-sm text-[#1e2923]">{ord.id}</p>
                        <p className="text-xs text-[#64748b]">{ord.time}</p>
                      </div>
                    </div>

                    <div className="text-right">
                      <p className="font-black text-base text-[#1e2923]">{ord.amount}</p>
                      <p className={`font-bold text-xs flex items-center justify-end gap-1 ${ord.statusColor}`}>
                        {ord.isActive ? <Truck className="w-3.5 h-3.5" /> : <CheckCircle2 className="w-3.5 h-3.5" />}
                        <span>{ord.status}</span>
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Action Workflow Modals */}
      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal} Customer Workflow</h3>
            <p className="text-xs text-[#64748b]">
              Executing action &quot;{activeModal}&quot; for customer Rahul Sharma ({customer.id}).
            </p>
            <button
              onClick={() => setActiveModal(null)}
              className="w-full py-3 bg-[#006837] text-white font-bold text-xs rounded-2xl hover:bg-[#00522b]"
            >
              Close Window
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
