import React from 'react';
import Link from 'next/link';
import './globals.css';
import {
  LayoutDashboard,
  TrendingUp,
  Package,
  ShoppingCart,
  Users,
  Edit3,
  Bike,
  Megaphone,
  Settings,
  Store,
  Bell,
  Search,
  Zap,
} from 'lucide-react';

export const metadata = {
  title: 'Daily Basket | Store Admin & Quick-Commerce Suite',
  description: 'Inventory management, daily mandi pricing, order dispatch, and rider tracking.',
};

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="light">
      <body className="bg-[#f9f9fc] text-[#1a1c1e] min-h-screen font-sans antialiased">
        <div className="flex min-h-screen">
          {/* Desktop Left Sidebar */}
          <aside className="w-64 bg-white border-r border-[#e2e2e5] flex flex-col fixed inset-y-0 z-50">
            {/* Brand Header */}
            <div className="h-16 px-6 border-b border-[#e2e2e5] flex items-center gap-3">
              <div className="w-8 h-8 rounded-xl bg-[#006b23] text-white flex items-center justify-center font-black text-sm">
                DB
              </div>
              <div>
                <h1 className="font-bold text-base text-[#1a1c1e] leading-none">Daily Basket</h1>
                <span className="text-[10px] uppercase font-bold text-[#006b23] tracking-widest">Admin Suite</span>
              </div>
            </div>

            {/* Nav Items */}
            <nav className="flex-1 p-3 space-y-4 overflow-y-auto scrollbar-thin">
              {/* Primary Fast Actions */}
              <div className="space-y-1">
                <Link
                  href="/"
                  className="flex items-center gap-3 px-3 py-2 rounded-xl text-xs font-bold text-[#1a1c1e] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <LayoutDashboard className="w-4 h-4 text-[#006b23]" />
                  <span>Overview</span>
                </Link>

                {/* Fast Daily Price Editor Highlight */}
                <Link
                  href="/products/daily-pricing"
                  className="flex items-center justify-between px-3 py-2 rounded-xl text-xs font-bold text-[#006b23] bg-[#006b23]/10 hover:bg-[#006b23]/15 transition border border-[#006b23]/20"
                >
                  <div className="flex items-center gap-2.5">
                    <Zap className="w-4 h-4 text-[#006b23] fill-current" />
                    <span>Daily Price Editor</span>
                  </div>
                  <span className="text-[9px] uppercase font-black bg-[#006b23] text-white px-1.5 py-0.5 rounded-md">
                    60s
                  </span>
                </Link>

                <Link
                  href="/orders"
                  className="flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <div className="flex items-center gap-3">
                    <ShoppingCart className="w-4 h-4" />
                    <span>Order Pipeline</span>
                  </div>
                  <span className="text-[10px] font-bold bg-emerald-100 text-emerald-800 px-1.5 py-0.5 rounded-full">
                    LIVE
                  </span>
                </Link>
              </div>

              {/* Operations & Dark Store */}
              <div className="space-y-1">
                <span className="text-[10px] font-extrabold uppercase tracking-wider text-slate-400 px-3 block">
                  Store Operations
                </span>
                <Link
                  href="/store-operations"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Store className="w-4 h-4" />
                  <span>Store Operations</span>
                </Link>
                <Link
                  href="/retail-os"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Package className="w-4 h-4" />
                  <span>Retail OS Hub</span>
                </Link>
                <Link
                  href="/checklist"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Zap className="w-4 h-4" />
                  <span>Daily Checklist</span>
                </Link>
                <Link
                  href="/grn"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Package className="w-4 h-4" />
                  <span>Inward GRN</span>
                </Link>
              </div>

              {/* Catalog & Inventory */}
              <div className="space-y-1">
                <span className="text-[10px] font-extrabold uppercase tracking-wider text-slate-400 px-3 block">
                  Catalog & Inventory
                </span>
                <Link
                  href="/products"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Package className="w-4 h-4" />
                  <span>Product Catalog</span>
                </Link>
                <Link
                  href="/products/editor"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Edit3 className="w-4 h-4" />
                  <span>Product Editor</span>
                </Link>
                <Link
                  href="/inventory"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Package className="w-4 h-4" />
                  <span>Inventory & Batches</span>
                </Link>
                <Link
                  href="/suppliers"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Users className="w-4 h-4" />
                  <span>Suppliers</span>
                </Link>
              </div>

              {/* Intelligence & Analytics */}
              <div className="space-y-1">
                <span className="text-[10px] font-extrabold uppercase tracking-wider text-slate-400 px-3 block">
                  AI & Analytics
                </span>
                <Link
                  href="/executive-analytics"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <TrendingUp className="w-4 h-4 text-[#006b23]" />
                  <span>Executive Analytics</span>
                </Link>
                <Link
                  href="/ai-analytics"
                  className="flex items-center justify-between px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <div className="flex items-center gap-3">
                    <TrendingUp className="w-4 h-4" />
                    <span>Demand Forecast</span>
                  </div>
                  <span className="text-[9px] font-extrabold bg-purple-100 text-purple-700 px-1.5 py-0.5 rounded">
                    AI
                  </span>
                </Link>
                <Link
                  href="/copilot"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Zap className="w-4 h-4 text-amber-500" />
                  <span>Store Copilot</span>
                </Link>
              </div>

              {/* Fleet & Customers */}
              <div className="space-y-1">
                <span className="text-[10px] font-extrabold uppercase tracking-wider text-slate-400 px-3 block">
                  Fleet & Customers
                </span>
                <Link
                  href="/riders"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Bike className="w-4 h-4" />
                  <span>Rider Performance</span>
                </Link>
                <Link
                  href="/customers"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Users className="w-4 h-4" />
                  <span>Customer Insights</span>
                </Link>
                <Link
                  href="/marketing/coupons"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Megaphone className="w-4 h-4" />
                  <span>Coupons & Promos</span>
                </Link>
              </div>

              {/* Settings & System */}
              <div className="space-y-1 pt-2 border-t border-slate-100">
                <Link
                  href="/finance/dashboard"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <TrendingUp className="w-4 h-4" />
                  <span>Finance Dashboard</span>
                </Link>
                <Link
                  href="/support"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Bell className="w-4 h-4" />
                  <span>Support Desk</span>
                </Link>
                <Link
                  href="/settings"
                  className="flex items-center gap-3 px-3 py-1.5 rounded-xl text-xs font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
                >
                  <Settings className="w-4 h-4" />
                  <span>System Settings</span>
                </Link>
              </div>
            </nav>

            {/* User Footer */}
            <div className="p-4 border-t border-[#e2e2e5] flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center font-bold text-xs">
                  KB
                </div>
                <div>
                  <p className="text-xs font-bold text-[#1a1c1e]">Kirana Owner</p>
                  <p className="text-[10px] text-[#3f4a3d]">Daily Basket Store #01</p>
                </div>
              </div>
            </div>
          </aside>

          {/* Main Content Area */}
          <div className="flex-1 md:pl-64 flex flex-col min-h-screen">
            {/* Top Navbar Header */}
            <header className="h-16 bg-white/80 backdrop-blur-xl border-b border-[#e2e2e5] sticky top-0 z-40 px-6 flex items-center justify-between">
              <div className="flex items-center gap-4 flex-1 max-w-md">
                <div className="relative w-full">
                  <Search className="w-4 h-4 text-[#3f4a3d] absolute left-3 top-1/2 -translate-y-1/2" />
                  <input
                    type="text"
                    placeholder="Search SKU, produce, or daily rates..."
                    className="w-full pl-9 pr-4 py-1.5 bg-[#f3f3f6] border border-transparent rounded-xl text-xs focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                  />
                </div>
              </div>

              <div className="flex items-center gap-3">
                <Link
                  href="/products/daily-pricing"
                  className="flex items-center gap-2 px-3 py-1.5 bg-[#006b23]/10 text-[#006b23] rounded-xl text-xs font-bold hover:bg-[#006b23]/20 transition"
                >
                  <Zap className="w-3.5 h-3.5" />
                  <span>Update Today’s Prices</span>
                </Link>

                <div className="flex items-center gap-2 px-3 py-1.5 bg-[#f3f3f6] text-[#1a1c1e] rounded-xl text-xs font-semibold">
                  <Store className="w-3.5 h-3.5 text-[#006b23]" />
                  <span>Main Kirana Hub</span>
                </div>

                <button className="p-2 text-[#3f4a3d] hover:bg-[#f3f3f6] rounded-xl transition relative">
                  <Bell className="w-4 h-4" />
                  <span className="w-2 h-2 rounded-full bg-[#ba1a1a] absolute top-1.5 right-1.5" />
                </button>
              </div>
            </header>

            {/* Page Content */}
            <main className="flex-1">{children}</main>
          </div>
        </div>
      </body>
    </html>
  );
}
