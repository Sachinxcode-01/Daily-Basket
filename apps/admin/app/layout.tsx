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
} from 'lucide-react';

export const metadata = {
  title: 'Daily Basket | Store Admin & Quick-Commerce Suite',
  description: 'Inventory management, order dispatch, rider tracking, and analytics dashboard.',
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
            <nav className="flex-1 p-3 space-y-1 overflow-y-auto">
              <Link
                href="/"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#1a1c1e] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <LayoutDashboard className="w-4 h-4 text-[#006b23]" />
                <span>Overview</span>
              </Link>

              <Link
                href="/executive-analytics"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-primary hover:bg-primary-container/20 transition"
              >
                <TrendingUp className="w-4 h-4 text-primary" />
                <span className="font-bold">Executive Analytics</span>
              </Link>

              <Link
                href="/inventory"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <Package className="w-4 h-4" />
                <span>Inventory</span>
              </Link>

              <Link
                href="/orders"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <ShoppingCart className="w-4 h-4" />
                <span>Order Pipeline</span>
              </Link>

              <Link
                href="/customers"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <Users className="w-4 h-4" />
                <span>Customer Insights</span>
              </Link>

              <Link
                href="/products/editor"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <Edit3 className="w-4 h-4" />
                <span>Product Editor</span>
              </Link>

              <Link
                href="/riders"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <Bike className="w-4 h-4" />
                <span>Rider Performance</span>
              </Link>

              <Link
                href="/marketing"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <Megaphone className="w-4 h-4" />
                <span>Marketing & Promos</span>
              </Link>

              <Link
                href="/settings"
                className="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-[#3f4a3d] hover:bg-[#dce5dd]/60 hover:text-[#006b23] transition"
              >
                <Settings className="w-4 h-4" />
                <span>System Settings</span>
              </Link>
            </nav>

            {/* User Footer */}
            <div className="p-4 border-t border-[#e2e2e5] flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center font-bold text-xs">
                  AD
                </div>
                <div>
                  <p className="text-xs font-bold text-[#1a1c1e]">Admin Supervisor</p>
                  <p className="text-[10px] text-[#3f4a3d]">Dark Store #402 (BLR)</p>
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
                    placeholder="Search SKU, order ID, or rider name..."
                    className="w-full pl-9 pr-4 py-1.5 bg-[#f3f3f6] border border-transparent rounded-xl text-xs focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                  />
                </div>
              </div>

              <div className="flex items-center gap-3">
                <button className="flex items-center gap-2 px-3 py-1.5 bg-[#f3f3f6] text-[#1a1c1e] rounded-xl text-xs font-semibold hover:bg-[#e2e2e5] transition">
                  <Store className="w-3.5 h-3.5 text-[#006b23]" />
                  <span>Dark Store: Indiranagar Hub</span>
                </button>
                <button className="p-2 text-[#3f4a3d] hover:bg-[#f3f3f6] rounded-xl transition relative">
                  <Bell className="w-4 h-4" />
                  <span className="w-2 h-2 rounded-full bg-[#ba1a1a] absolute top-1.5 right-1.5" />
                </button>
              </div>
            </header>

            {/* Page Content */}
            <main className="p-6 md:p-8 flex-1">{children}</main>
          </div>
        </div>
      </body>
    </html>
  );
}
