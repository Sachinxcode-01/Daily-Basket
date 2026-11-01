'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
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
  UserCheck,
  ExternalLink,
  Menu,
  X,
  Sparkles,
} from 'lucide-react';
import { useAdminAuth } from '../../app/lib/auth-context';
import Button from '../ui/Button';
import Badge from '../ui/Badge';
import CommandPalette from '../ui/CommandPalette';

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
  const [commandPaletteOpen, setCommandPaletteOpen] = useState(false);

  // Global Ctrl+K / Cmd+K shortcut listener
  React.useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        setCommandPaletteOpen((prev) => !prev);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

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
      group: 'Team & User Management',
      items: [
        {
          href: '/users',
          label: 'Staff & Team Users',
          icon: Users,
          badge: 'STAFF',
          badgeVariant: 'brand' as const,
        },
        { href: '/customers', label: 'Customer Directory', icon: UserCheck },
        { href: '/roles', label: 'Roles & Permissions', icon: Shield },
      ],
    },
    {
      group: 'Fleet & Growth',
      items: [
        { href: '/riders', label: 'Rider Performance', icon: Bike },
        { href: '/marketing/coupons', label: 'Coupons & Promos', icon: Megaphone },
        { href: '/reviews', label: 'Review Moderation', icon: Sparkles },
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
    <div className="flex flex-col h-full bg-surface-container-lowest">
      {/* Brand Header */}
      <div className="h-16 px-4 border-b border-outline-variant/30 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-3 group">
          <div className="w-9 h-9 rounded-xl bg-white border border-outline-variant/40 p-1 flex items-center justify-center shadow-xs group-hover:scale-105 group-hover:border-primary/50 transition-all shrink-0">
            <Image
              src="/images/daily_basket_logo.png"
              alt="Daily Basket Logo"
              width={32}
              height={32}
              className="w-full h-full object-contain"
              priority
            />
          </div>
          <div>
            <div className="font-bold text-sm tracking-tight text-on-surface flex items-center gap-1.5">
              <span>Daily Basket</span>
              <span className="text-[10px] bg-primary/15 text-primary-container px-1.5 py-0.5 rounded font-mono font-bold">
                OS
              </span>
            </div>
            <span className="text-[10px] uppercase font-bold text-primary tracking-wider block">
              Dark Store Control
            </span>
          </div>
        </Link>
      </div>

      {/* Navigation Groups */}
      <nav className="flex-1 p-3 space-y-4 overflow-y-auto scrollbar-thin">
        {navLinks.map((grp) => (
          <div key={grp.group} className="space-y-1">
            <span className="text-[10px] font-bold uppercase tracking-wider text-on-surface-subtle px-3 block font-mono">
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
                      ? 'bg-primary text-white shadow-sm shadow-primary/25 font-bold'
                      : 'text-on-surface-variant hover:text-on-surface hover:bg-surface-container-low'
                  }`}
                >
                  <div className="flex items-center gap-2.5 truncate">
                    <Icon
                      className={`w-4 h-4 shrink-0 transition-colors ${
                        isActive
                          ? 'text-white'
                          : 'text-on-surface-subtle group-hover:text-primary'
                      }`}
                    />
                    <span className="truncate">{item.label}</span>
                  </div>
                  {item.badge && (
                    <span
                      className={`text-[9px] font-bold px-1.5 py-0.5 rounded-md font-mono ${
                        isActive
                          ? 'bg-primary-container text-white'
                          : item.badgeVariant === 'success'
                          ? 'bg-status-success/15 text-status-success'
                          : item.badgeVariant === 'brand'
                          ? 'bg-primary/15 text-primary-container'
                          : 'bg-surface-container-high text-on-surface'
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
      <div className="p-3 border-t border-outline-variant/30 bg-surface-container-low/60 relative">
        <div className="flex items-center justify-between p-2 rounded-xl hover:bg-surface-container-lowest border border-transparent hover:border-outline-variant/30 transition-all cursor-pointer">
          <button
            type="button"
            onClick={() => setShowUserMenu(!showUserMenu)}
            className="flex items-center gap-2.5 text-left flex-1 min-w-0"
          >
            <div className="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center font-bold text-xs shrink-0 shadow-sm">
              {user?.name ? user.name.slice(0, 2).toUpperCase() : 'AD'}
            </div>
            <div className="min-w-0 flex-1">
              <div className="text-xs font-bold text-on-surface truncate">
                {user?.name || 'Administrator'}
              </div>
              <div className="text-[10px] text-on-surface-subtle truncate flex items-center gap-1 font-mono">
                <span className="w-1.5 h-1.5 rounded-full bg-primary inline-block" />
                {role.replace('_', ' ')}
              </div>
            </div>
            <ChevronDown className="w-4 h-4 text-on-surface-subtle shrink-0" />
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
              className="absolute bottom-16 left-3 right-3 bg-surface-container-lowest border border-outline-variant/40 rounded-2xl shadow-xl p-2 space-y-1.5 z-50"
            >
              <div className="px-2 py-1 text-[10px] font-mono uppercase text-on-surface-subtle font-bold">
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
                        ? 'bg-primary/10 text-primary font-bold'
                        : 'text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface'
                    }`}
                  >
                    <span>{r.replace('_', ' ')}</span>
                    {role === r && <Shield className="w-3 h-3 text-primary" />}
                  </button>
                )
              )}

              <div className="pt-1 border-t border-outline-variant/30">
                <button
                  type="button"
                  onClick={() => {
                    setShowUserMenu(false);
                    logout();
                  }}
                  className="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-semibold text-status-error hover:bg-status-error/10 transition flex items-center gap-2"
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
    <div className="flex min-h-screen bg-surface text-on-surface font-sans antialiased">
      {/* Desktop Left Sidebar */}
      <aside className="w-64 bg-surface-container-lowest border-r border-outline-variant/30 hidden md:flex flex-col fixed inset-y-0 z-40 shadow-[1px_0_4px_rgba(0,0,0,0.02)]">
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
        <header className="h-16 bg-surface/80 backdrop-blur-xl border-b border-outline-variant/30 sticky top-0 z-30 px-4 md:px-6 flex items-center justify-between gap-3">
          {/* Mobile Menu Button */}
          <button
            type="button"
            onClick={() => setMobileMenuOpen(true)}
            className="md:hidden p-2 rounded-xl text-on-surface-variant hover:text-on-surface hover:bg-surface-container-low"
          >
            <Menu className="w-5 h-5" />
          </button>

          {/* Search bar & Command Palette Trigger */}
          <div className="flex items-center gap-3 flex-1 max-w-md">
            <button
              type="button"
              onClick={() => setCommandPaletteOpen(true)}
              className="w-full relative flex items-center justify-between pl-10 pr-3 py-2 bg-surface-container-low hover:bg-surface-container border border-outline-variant/40 hover:border-primary/40 rounded-full text-xs text-on-surface-subtle hover:text-on-surface transition text-left group"
            >
              <Search className="w-4 h-4 text-on-surface-subtle group-hover:text-primary absolute left-3.5 top-1/2 -translate-y-1/2" />
              <span className="truncate">Search commands, dark stores, SKUs...</span>
              <kbd className="hidden sm:inline-flex items-center gap-0.5 px-1.5 py-0.5 text-[10px] font-mono font-bold bg-surface-container-lowest text-on-surface-subtle border border-outline-variant/40 rounded-md shadow-2xs">
                <span>⌘</span>K
              </kbd>
            </button>
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
                className="flex items-center gap-2 px-3 py-1.5 bg-surface-container-low hover:bg-surface-container border border-outline-variant/40 text-on-surface rounded-xl text-xs font-semibold transition"
              >
                <Store className="w-3.5 h-3.5 text-primary" />
                <span className="truncate max-w-[150px]">{activeStore.split(' ')[0]} Hub</span>
                <span className="w-1.5 h-1.5 rounded-full bg-primary animate-pulse" />
                <ChevronDown className="w-3 h-3 text-on-surface-subtle" />
              </button>

              <AnimatePresence>
                {showStoreMenu && (
                  <motion.div
                    initial={{ opacity: 0, y: 6, scale: 0.98 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 6, scale: 0.98 }}
                    className="absolute right-0 top-10 w-64 bg-surface-container-lowest border border-outline-variant/40 rounded-2xl shadow-xl p-2 z-50 space-y-1"
                  >
                    <div className="px-2 py-1 text-[10px] font-mono uppercase text-on-surface-subtle font-bold">
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
                            ? 'bg-primary/10 text-primary-container font-bold border border-primary/30'
                            : 'text-on-surface-variant hover:bg-surface-container-low'
                        }`}
                      >
                        <div>
                          <div className="truncate font-semibold text-on-surface">{st.name}</div>
                          <span className="text-[10px] text-on-surface-subtle font-mono">{st.code}</span>
                        </div>
                        <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-surface-container-low text-on-surface-subtle font-mono">
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
              className="p-2 text-on-surface-subtle hover:text-on-surface hover:bg-surface-container-low rounded-xl transition relative border border-transparent hover:border-outline-variant/30"
              title="Operational Alerts"
            >
              <Bell className="w-4 h-4" />
              <span className="w-2 h-2 rounded-full bg-primary absolute top-1.5 right-1.5 ring-2 ring-white" />
            </button>

            {/* Quick logout icon button */}
            <button
              type="button"
              onClick={logout}
              className="p-2 text-on-surface-subtle hover:text-status-error hover:bg-status-error/10 rounded-xl transition border border-transparent hover:border-status-error/20"
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

        {/* Global Command Palette */}
        <CommandPalette
          isOpen={commandPaletteOpen}
          onClose={() => setCommandPaletteOpen(false)}
        />
      </div>
    </div>
  );
}
