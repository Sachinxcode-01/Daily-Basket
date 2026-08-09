'use client';

import React, { useState } from 'react';
import { ArrowLeft, Bell, AlertTriangle, ShoppingBag, ShieldAlert, CheckCheck } from 'lucide-react';

// Google Stitch Specs: Notifications Center - Daily Basket Admin
// ID: 3f473a8ee82f41de86019498bed97103

export default function NotificationsCenterPage() {
  const [filter, setFilter] = useState('All');
  const [notifications, setNotifications] = useState([
    {
      id: 'n-1',
      title: 'Low Stock Alert',
      body: 'Premium Avocados inventory dropped below 15 units in WH-South.',
      time: '10m ago',
      type: 'Inventory',
      isUnread: true,
      icon: AlertTriangle,
      iconBg: 'bg-rose-100 text-[#dc2626]',
    },
    {
      id: 'n-2',
      title: 'High Value Order Placed',
      body: 'Order #4429 for ₹4,850 placed by VIP Customer Anita Sharma.',
      time: '30m ago',
      type: 'Orders',
      isUnread: true,
      icon: ShoppingBag,
      iconBg: 'bg-emerald-100 text-[#15803d]',
    },
    {
      id: 'n-3',
      title: 'Security Alert: Failed Login',
      body: 'Multiple failed login attempts detected from IP 192.168.1.42.',
      time: '2h ago',
      type: 'Security',
      isUnread: false,
      icon: ShieldAlert,
      iconBg: 'bg-amber-100 text-[#c2410c]',
    },
  ]);

  const markAllRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, isUnread: false })));
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="flex items-center justify-between bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837]">Notifications Center</h1>
            <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: 3f473a8ee82f41de86019498bed97103</p>
          </div>
        </div>

        <button
          onClick={markAllRead}
          className="flex items-center gap-1.5 px-4 py-2 bg-[#e6f4ea] text-[#006837] text-xs font-bold rounded-2xl hover:bg-[#d2ebd9]"
        >
          <CheckCheck className="w-4 h-4" /> Mark All Read
        </button>
      </div>

      <div className="flex gap-2 overflow-x-auto no-scrollbar">
        {['All', 'Unread', 'Orders', 'Inventory', 'Security'].map((f) => (
          <button
            key={f}
            onClick={() => setFilter(f)}
            className={`px-4 py-2 rounded-full text-xs font-bold transition shrink-0 ${
              filter === f ? 'bg-[#006837] text-white shadow-sm' : 'bg-white text-[#64748b] border border-[#e2e8f0]'
            }`}
          >
            {f}
          </button>
        ))}
      </div>

      <div className="space-y-3">
        {notifications.map((n) => {
          const IconComp = n.icon;
          return (
            <div
              key={n.id}
              className={`p-4 rounded-3xl border ${
                n.isUnread ? 'bg-[#f0fdf4] border-[#a7f3d0]' : 'bg-white border-[#e2e8f0]'
              } shadow-sm flex items-start gap-3.5`}
            >
              <div className={`p-2.5 rounded-full ${n.iconBg}`}>
                <IconComp className="w-5 h-5" />
              </div>
              <div className="flex-1 space-y-1">
                <div className="flex justify-between items-center">
                  <h4 className="font-bold text-sm text-[#1e2923]">{n.title}</h4>
                  <span className="text-xs text-[#64748b]">{n.time}</span>
                </div>
                <p className="text-xs text-[#64748b]">{n.body}</p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
