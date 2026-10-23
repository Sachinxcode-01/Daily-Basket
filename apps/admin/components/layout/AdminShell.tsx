'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
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
  LogOut,
  ChevronDown,
  Shield,
  CheckCircle,
  ExternalLink,
  Menu,
  X,
  Sparkles,
} from 'lucide-react';
import { useAdminAuth } from '../../app/lib/auth-context';
import Button from '../ui/Button';
import Badge from '../ui/Badge';

const availableStores = [
  { name: 'Koramangala Mega Dark Store #01', code: 'BLR-KRM-01', status: 'Optimal' },
  { name: 'Indiranagar Urban Hub #04', code: 'BLR-IND-04', status: 'High Demand' },
  { name: 'HSR Layout Sector 2 Hub', code: 'BLR-HSR-02', status: 'Surge' },
  { name: 'Whitefield Tech Hub #08', code: 'BLR-WTF-08', status: 'Optimal' },
];

export default function AdminShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const { user, role, logout, switchRole } = useAdminAuth();
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [showStoreMenu, setShowStoreMenu] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [activeStore, setActiveStore] = useState(availableStores[0].name);

  // If on login page, render children clean and full-screen
  if (pathname?.startsWith('/login')) {
    return <>{children}</>;
  }

  const navLinks = [
    {
      group: 'Core Operations',
      items: [
        { href: '/', label: 'Overview', icon: LayoutDashboard },
        {
          href: '/products/daily-pricing',
          label: 'Daily Price Editor',
          icon: Zap,
          badge: '60s',
          badgeVariant: 'brand' as const,
        },
        {
          href: '/orders',
          label: 'Order Pipeline',
          icon: ShoppingCart,
          badge: 'LIVE',
          badgeVariant: 'success' as const,
        },
        { href: '/store-operations', label: 'Store Operations', icon: Store },
        { href: '/retail-os', label: 'Retail OS Hub', icon: Package },
        { href: '/checklist', label: 'Daily Checklist', icon: CheckCircle },
        { href: '/grn', label: 'Inward GRN', icon: Package },
      ],
    },
    {
      group: 'Catalog & Inventory',
      items: [
        { href: '/products', label: 'Product Catalog', icon: Package },
        { href: '/products/editor', label: 'Product Editor', icon: Edit3 },
        { href: '/inventory', label: 'Inventory & Batches', icon: Package },
        { href: '/suppliers', label: 'Suppliers', icon: Users },
      ],
    },
    {
      group: 'AI & Analytics',
      items: [
        { href: '/executive-analytics', label: 'Executive Analytics', icon: TrendingUp },
        {
          href: '/ai-analytics',
          label: 'Demand Forecast',
          icon: TrendingUp,
          badge: 'AI',
          badgeVariant: 'mono' as const,
        },
        { href: '/copilot', label: 'Store Copilot', icon: Zap },
      ],
    },
    {
      group: 'Fleet & Growth',
      items: [
        { href: '/riders', label: 'Rider Performance', icon: Bike },
        { href: '/customers', label: 'Customer Insights', icon: Users },
        { href: '/marketing/coupons', label: 'Coupons & Promos', icon: Megaphone },
      ],
    },
    {
      group: 'Financials & Administration',
      items: [
        { href: '/finance', label: 'Finance & GMV', icon: TrendingUp },
        { href: '/finance/dashboard', label: 'Finance Dashboard', icon: TrendingUp },
        { href: '/support', label: 'Support Desk', icon: Bell },
        { href: '/settings', label: 'System Settings', icon: Settings },
      ],
    },
  ];

  const sidebarContent = (
    <div className="flex flex-col h-full bg-white">
      {/* Brand Header */}
      <div className="h-16 px-5 border-b border-zinc-200/80 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2.5 group">
          <div className="w-8 h-8 rounded-xl bg-[#2d9d43] text-white flex items-center justify-center font-black text-xs shadow-sm group-hover:scale-105 transition-all">
            DB
          </div>
          <div>
            <div className="font-bold text-sm tracking-tight text-zinc-950 flex items-center gap-1.5">
              <span>Daily Basket</span>
              <span className="text-[10px] bg-emerald-100 text-[#078730] px-1.5 py-0.5 rounded font-mono font-bold">
                OS
              </span>
            </div>
            <span className="text-[10px] uppercase font-bold text-[#2d9d43] tracking-wider block">
              Dark Store Control
            </span>
          </div>
        </Link>
      </div>

      {/* Navigation Groups */}
      <nav className="flex-1 p-3 space-y-4 overflow-y-auto scrollbar-thin">
        {navLinks.map((grp) => (
          <div key={grp.group} className="space-y-1">
            <span className="text-[10px] font-bold uppercase tracking-wider text-zinc-400 px-3 block font-mono">
              {grp.group}
            </span>
            {grp.items.map((item) => {
              const Icon = item.icon;
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setMobileMenuOpen(false)}
                  className={`flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold transition-all group relative ${
                    isActive
                      ? 'bg-zinc-950 text-white shadow-sm'
                      : 'text-zinc-600 hover:text-zinc-950 hover:bg-zinc-100/80'
                  }`}
                >
                  <div className="flex items-center gap-2.5 truncate">
                    <Icon
                      className={`w-4 h-4 shrink-0 transition-colors ${
                        isActive
                          ? 'text-[#8cfa93]'
                          : 'text-zinc-400 group-hover:text-zinc-900'
                      }`}
                    />
                    <span className="truncate">{item.label}</span>
                  </div>
                  {item.badge && (
                    <span
                      className={`text-[9px] font-bold px-1.5 py-0.5 rounded-md font-mono ${
                        isActive
                          ? 'bg-zinc-800 text-white'
                          : item.badgeVariant === 'success'
                          ? 'bg-emerald-100 text-emerald-800'
                          : item.badgeVariant === 'brand'
                          ? 'bg-[#2d9d43]/15 text-[#078730]'
                          : 'bg-purple-100 text-purple-700'
                      }`}
                    >
                      {item.badge}
                    </span>
                  )}
                </Link>
              );
            })}
          </div>
        ))}
      </nav>

      {/* User Footer Profile & Role Selector */}
      <div className="p-3 border-t border-zinc-200/80 bg-zinc-50/60 relative">
        <div className="flex items-center justify-between p-2 rounded-xl hover:bg-white border border-transparent hover:border-zinc-200/80 transition-all cursor-pointer">
          <button
            type="button"
            onClick={() => setShowUserMenu(!showUserMenu)}
            className="flex items-center gap-2.5 text-left flex-1 min-w-0"
          >
            <div className="w-8 h-8 rounded-full bg-zinc-950 text-white flex items-center justify-center font-bold text-xs shrink-0 shadow-sm">
              {user?.name ? user.name.slice(0, 2).toUpperCase() : 'AD'}
            </div>
            <div className="min-w-0 flex-1">
              <div className="text-xs font-bold text-zinc-900 truncate">
                {user?.name || 'Administrator'}
              </div>
              <div className="text-[10px] text-zinc-500 truncate flex items-center gap-1 font-mono">
                <span className="w-1.5 h-1.5 rounded-full bg-[#2d9d43] inline-block" />
                {role.replace('_', ' ')}
              </div>
            </div>
            <ChevronDown className="w-4 h-4 text-zinc-400 shrink-0" />
          </button>
        </div>

        {/* Interactive Role Switcher & Logout Dropdown Menu */}
        <AnimatePresence>
          {showUserMenu && (
            <motion.div
              initial={{ opacity: 0, y: 8, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 8, scale: 0.98 }}
              transition={{ duration: 0.15 }}
              className="absolute bottom-16 left-3 right-3 bg-white border border-zinc-200 rounded-2xl shadow-xl p-2 space-y-1.5 z-50"
            >
              <div className="px-2 py-1 text-[10px] font-mono uppercase text-zinc-400 font-bold">
                Quick Role Simulator
              </div>
              {(['SUPER_ADMIN', 'STORE_MANAGER', 'DISPATCH_HEAD', 'INVENTORY_LEAD'] as const).map(
                (r) => (
                  <button
                    key={r}
                    type="button"
                    onClick={() => {
                      switchRole(r);
                      setShowUserMenu(false);
                    }}
                    className={`w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium transition flex items-center justify-between ${
                      role === r
                        ? 'bg-zinc-100 text-zinc-950 font-bold'
                        : 'text-zinc-600 hover:bg-zinc-50 hover:text-zinc-900'
                    }`}
                  >
                    <span>{r.replace('_', ' ')}</span>
                    {role === r && <Shield className="w-3 h-3 text-[#2d9d43]" />}
                  </button>
                )
              )}

              <div className="pt-1 border-t border-zinc-100">
                <button
                  type="button"
                  onClick={() => {
                    setShowUserMenu(false);
                    logout();
                  }}
                  className="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-semibold text-rose-600 hover:bg-rose-50 transition flex items-center gap-2"
                >
                  <LogOut className="w-3.5 h-3.5" />
                  <span>Terminate Session (Logout)</span>
                </button>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );

  return (
    <div className="flex min-h-screen bg-[#f7f8fa] text-zinc-900 font-sans antialiased">
      {/* Desktop Left Sidebar */}
      <aside className="w-64 bg-white border-r border-zinc-200/90 hidden md:flex flex-col fixed inset-y-0 z-40 shadow-[1px_0_4px_rgba(0,0,0,0.02)]">
        {sidebarContent}
      </aside>

      {/* Mobile Sidebar Overlay Drawer */}
      <AnimatePresence>
        {mobileMenuOpen && (
          <div className="fixed inset-0 z-50 flex md:hidden">
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setMobileMenuOpen(false)}
              className="fixed inset-0 bg-black/40 backdrop-blur-xs"
            />
            <motion.div
              initial={{ x: '-100%' }}
              animate={{ x: 0 }}
              exit={{ x: '-100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 250 }}
              className="relative w-72 max-w-[85vw] h-full shadow-2xl z-10"
            >
              {sidebarContent}
            </motion.div>
          </div>
        )}
      </AnimatePresence>

      {/* Main Content Area */}
      <div className="flex-1 md:pl-64 flex flex-col min-h-screen">
        {/* Top Navbar Header */}
        <header className="h-16 bg-white/85 backdrop-blur-md border-b border-zinc-200/80 sticky top-0 z-30 px-4 md:px-6 flex items-center justify-between gap-3">
          {/* Mobile Menu Button */}
          <button
            type="button"
            onClick={() => setMobileMenuOpen(true)}
            className="md:hidden p-2 rounded-xl text-zinc-600 hover:text-zinc-900 hover:bg-zinc-100"
          >
            <Menu className="w-5 h-5" />
          </button>

          {/* Search bar */}
          <div className="flex items-center gap-3 flex-1 max-w-md">
            <div className="relative w-full">
              <Search className="w-4 h-4 text-zinc-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                placeholder="Search dark store SKU, produce, rates, or riders..."
                className="w-full pl-10 pr-4 py-2 bg-zinc-100/70 hover:bg-zinc-100 border border-transparent hover:border-zinc-200/80 rounded-xl text-xs text-zinc-900 placeholder-zinc-400 focus:outline-none focus:border-[#2d9d43] focus:bg-white transition"
              />
            </div>
          </div>

          {/* Action buttons with unified Button design */}
          <div className="flex items-center gap-2 shrink-0">
            {/* Quick Mandi Price Button */}
            <Link href="/products/daily-pricing" className="hidden sm:inline-flex">
              <Button
                variant="brand"
                size="sm"
                leftIcon={<Zap className="w-3.5 h-3.5 text-white" />}
              >
                60s Mandi Sync
              </Button>
            </Link>

            {/* Active Store Selector Dropdown */}
            <div className="relative hidden lg:block">
              <button
                type="button"
                onClick={() => setShowStoreMenu(!showStoreMenu)}
                className="flex items-center gap-2 px-3 py-1.5 bg-zinc-100/80 hover:bg-zinc-100 border border-zinc-200/60 text-zinc-800 rounded-xl text-xs font-semibold transition"
              >
                <Store className="w-3.5 h-3.5 text-[#2d9d43]" />
                <span className="truncate max-w-[150px]">{activeStore.split(' ')[0]} Hub</span>
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
                <ChevronDown className="w-3 h-3 text-zinc-400" />
              </button>

              <AnimatePresence>
                {showStoreMenu && (
                  <motion.div
                    initial={{ opacity: 0, y: 6, scale: 0.98 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 6, scale: 0.98 }}
                    className="absolute right-0 top-10 w-64 bg-white border border-zinc-200 rounded-2xl shadow-xl p-2 z-50 space-y-1"
                  >
                    <div className="px-2 py-1 text-[10px] font-mono uppercase text-zinc-400 font-bold">
                      Switch Micro-Warehouse Hub
                    </div>
                    {availableStores.map((st) => (
                      <button
                        key={st.code}
                        type="button"
                        onClick={() => {
                          setActiveStore(st.name);
                          setShowStoreMenu(false);
                        }}
                        className={`w-full text-left p-2 rounded-xl text-xs transition flex items-center justify-between ${
                          activeStore === st.name
                            ? 'bg-emerald-50 text-[#078730] font-bold border border-emerald-200'
                            : 'text-zinc-700 hover:bg-zinc-50'
                        }`}
                      >
                        <div>
                          <div className="truncate font-semibold">{st.name}</div>
                          <span className="text-[10px] text-zinc-400 font-mono">{st.code}</span>
                        </div>
                        <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-zinc-100 text-zinc-600 font-mono">
                          {st.status}
                        </span>
                      </button>
                    ))}
                  </motion.div>
                )}
              </AnimatePresence>
            </div>

            {/* Notification alert button */}
            <button
              type="button"
              className="p-2 text-zinc-500 hover:text-zinc-900 hover:bg-zinc-100 rounded-xl transition relative border border-transparent hover:border-zinc-200"
              title="Operational Alerts"
            >
              <Bell className="w-4 h-4" />
              <span className="w-2 h-2 rounded-full bg-[#2d9d43] absolute top-1.5 right-1.5 ring-2 ring-white" />
            </button>

            {/* Quick logout icon button */}
            <button
              type="button"
              onClick={logout}
              className="p-2 text-zinc-400 hover:text-rose-600 hover:bg-rose-50 rounded-xl transition border border-transparent hover:border-rose-200"
              title="Secure Logout"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </header>

        {/* Page Content Body with Silky Smooth Transition */}
        <motion.main
          key={pathname}
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.28, ease: [0.16, 1, 0.3, 1] }}
          className="flex-1 p-4 sm:p-6 md:p-8 max-w-7xl w-full mx-auto"
        >
          {children}
        </motion.main>
      </div>
    </div>
  );
}
