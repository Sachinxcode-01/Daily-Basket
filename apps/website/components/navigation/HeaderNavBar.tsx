'use client';

import React, { useState, useEffect, useRef } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { usePathname, useRouter } from 'next/navigation';
import { useQueryClient } from '@tanstack/react-query';
import {
  MapPin,
  ChevronDown,
  Search,
  X,
  Wallet,
  Bell,
  ShoppingBag,
  User,
  LogOut,
  Truck,
  Sparkles,
  Tag,
  LayoutGrid,
  Menu,
  Zap,
  ShieldCheck,
  Compass,
  Mic,
} from 'lucide-react';
import { useAuthStore } from '../../store/useAuthStore';
import { useCart } from '../../store/useCart';
import { VoiceSearchModal } from '../VoiceSearchModal';

interface HeaderNavBarProps {
  cartCount?: number;
  onSearch?: (query: string) => void;
  onCartClick?: () => void;
}

export default function HeaderNavBar({ cartCount, onSearch, onCartClick }: HeaderNavBarProps) {
  const rawPathname = usePathname();
  const pathname = rawPathname || '/';
  const router = useRouter();
  const queryClient = useQueryClient();
  const { user, isAuthenticated, logout } = useAuthStore();
  const { itemCount } = useCart();
  const effectiveCartCount = cartCount !== undefined ? cartCount : itemCount;

  const [searchQuery, setSearchQuery] = useState('');
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isProfileMenuOpen, setIsProfileMenuOpen] = useState(false);
  const [isVoiceModalOpen, setIsVoiceModalOpen] = useState(false);
  const profileMenuRef = useRef<HTMLDivElement>(null);

  // Close profile dropdown on outside click
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (profileMenuRef.current && !profileMenuRef.current.contains(e.target as Node)) {
        setIsProfileMenuOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Close menus on route change
  useEffect(() => {
    setIsMobileMenuOpen(false);
    setIsProfileMenuOpen(false);
  }, [pathname]);

  const handleLogout = () => {
    logout();
    queryClient.invalidateQueries({ queryKey: ['cart'] });
    queryClient.invalidateQueries({ queryKey: ['orders'] });
    setIsProfileMenuOpen(false);
    router.push('/');
  };

  const displayName = (user as any)?.name || (user as any)?.fullName || 'Account';
  const initials = String(displayName)
    .split(' ')
    .map((n: string) => n[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    setSearchQuery(val);
    if (onSearch) {
      onSearch(val);
    }
  };

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const query = searchQuery.trim();
    if (onSearch) {
      onSearch(query);
    }
    if (pathname !== '/' || !onSearch) {
      if (query) {
        router.push(`/search?q=${encodeURIComponent(query)}`);
      } else {
        router.push('/search');
      }
    }
  };

  const clearSearch = () => {
    setSearchQuery('');
    if (onSearch) {
      onSearch('');
    }
  };

  const navLinks = [
    { label: 'All Categories', href: '/categories', icon: LayoutGrid },
    { label: 'Fresh Vegetables', href: '/categories/fresh-vegetables' },
    { label: 'Dairy & Bread', href: '/categories/dairy-bread-eggs' },
    { label: 'Fresh Milk', href: '/categories/milk' },
    { label: 'Kirana Essentials', href: '/categories/poha-daliya-grains' },
    { label: 'Freshness Explorer', href: '/freshness', icon: Sparkles, badge: 'NEW' },
    { label: 'Coupons & Deals', href: '/offers', icon: Tag, badge: 'OFFERS' },
    { label: 'Live Tracking', href: '/tracking', icon: Truck },
    { label: 'DB Plus VIP', href: '/loyalty', icon: Zap, badge: 'VIP' },
  ];

  return (
    <>
      {/* Real-Time Voice Search Modal */}
      <VoiceSearchModal
        isOpen={isVoiceModalOpen}
        onClose={() => setIsVoiceModalOpen(false)}
        onProductSelect={(productId) => router.push(`/product/${productId}`)}
      />

      <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-slate-200/80 shadow-xs">
      
      {/* ─── Top Micro-Ticker Announcement Banner ───────────────────────────── */}
      <div className="bg-[#00531a] text-white text-[11px] font-semibold py-1.5 px-4 text-center tracking-wide flex items-center justify-center gap-2">
        <span className="relative flex h-2 w-2">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75" />
          <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-400" />
        </span>
        <span className="bg-white/15 px-2 py-0.5 rounded-full text-[9px] uppercase font-bold tracking-wider">
          10 MIN DELIVERY
        </span>
        <span className="hidden sm:inline text-white/90">
          ⚡ Superfast grocery delivery active in Koramangala & Indiranagar • Free delivery on orders over ₹199!
        </span>
        <span className="sm:hidden text-white/90">
          ⚡ Free delivery on orders over ₹199!
        </span>
        <Link href="/loyalty" className="underline font-bold text-emerald-200 hover:text-white transition-colors ml-1">
          Join DB Plus VIP →
        </Link>
      </div>

      {/* ─── Main Desktop Navigation Bar (72px height, 40px unified controls) ─── */}
      <div className="w-full max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8 h-[72px] flex items-center justify-between gap-4 lg:gap-6">

        {/* Left: Brand Identity & Delivery Location Trigger */}
        <div className="flex items-center gap-4 lg:gap-5 shrink-0">
          <Link href="/" className="flex items-center gap-3 shrink-0 group">
            <div className="w-10 h-10 rounded-xl bg-white border border-slate-200/80 p-1 flex items-center justify-center shadow-xs group-hover:border-[#006b23]/40 group-hover:shadow-sm transition-all">
              <Image
                src="/images/daily_basket_logo.png"
                alt="Daily Basket Logo"
                width={32}
                height={32}
                className="w-full h-full object-contain"
                priority
              />
            </div>
            <div className="flex flex-col">
              <span className="font-extrabold text-xl text-[#006b23] tracking-tight leading-none" style={{ fontFamily: 'Outfit' }}>
                Daily Basket
              </span>
              <span className="text-[10px] text-slate-500 font-semibold tracking-wider uppercase mt-1 flex items-center gap-1">
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                10-Min Delivery
              </span>
            </div>
          </Link>

          {/* Delivery Location Selector Pill (Strictly h-10 = 40px) */}
          <Link
            href="/select-location"
            className="hidden md:flex items-center gap-2.5 h-10 px-3.5 rounded-full bg-slate-100/90 hover:bg-slate-100 border border-slate-200/80 hover:border-slate-300 transition-all text-slate-700 shrink-0"
            title="Change delivery location"
          >
            <MapPin className="w-4 h-4 text-[#006b23] shrink-0" />
            <div className="flex flex-col text-left leading-none">
              <span className="text-[9px] text-slate-400 font-bold uppercase tracking-wider">Delivering To</span>
              <span className="text-xs font-bold text-slate-800 truncate max-w-[120px] xl:max-w-[150px] mt-0.5" style={{ fontFamily: 'Outfit' }}>
                Koramangala 4th Block
              </span>
            </div>
            <ChevronDown className="w-3.5 h-3.5 text-slate-400 shrink-0" />
          </Link>
        </div>

        {/* Center: Expansive Pro Search Bar (Strictly h-10 = 40px) */}
        <form onSubmit={handleSearchSubmit} className="flex-1 max-w-xl hidden sm:block">
          <div className="relative h-10 w-full rounded-full bg-slate-100/90 hover:bg-slate-100 focus-within:bg-white border border-slate-200/90 focus-within:border-[#006b23] focus-within:ring-2 focus-within:ring-[#006b23]/15 transition-all flex items-center px-3.5 gap-2.5">
            <Search className="w-4 h-4 text-slate-400 shrink-0" />
            <input
              type="text"
              value={searchQuery}
              onChange={handleSearchChange}
              placeholder='Search "milk", "farm fresh tomatoes", "bread", "atta"...'
              className="w-full h-full bg-transparent text-xs font-medium text-slate-800 placeholder-slate-400 focus:outline-none"
            />
            {searchQuery ? (
              <button
                type="button"
                onClick={clearSearch}
                className="p-1 rounded-full text-slate-400 hover:text-slate-600 transition-colors"
                aria-label="Clear search"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            ) : null}
            <button
              type="button"
              onClick={() => setIsVoiceModalOpen(true)}
              className="p-1.5 rounded-full text-slate-400 hover:text-[#006b23] hover:bg-emerald-50 transition-colors"
              title="Search with Voice"
              aria-label="Voice Search"
            >
              <Mic className="w-4 h-4 text-[#006b23]" />
            </button>
          </div>
        </form>

        {/* Right: Symmetrical Pro Control Hub (Every interactive element is exactly h-10 = 40px) */}
        <div className="flex items-center gap-2.5 sm:gap-3 shrink-0">

          {/* Wallet Balance Pill (Strictly h-10 = 40px) */}
          <Link
            href="/wallet"
            className="hidden lg:flex items-center gap-2 h-10 px-3.5 rounded-full bg-emerald-50/90 hover:bg-emerald-100/80 border border-emerald-200/70 text-emerald-900 transition-all shrink-0 hover:shadow-xs"
            title="Daily Basket Wallet"
          >
            <Wallet className="w-4 h-4 text-[#006b23] shrink-0" />
            <div className="flex flex-col text-left leading-none">
              <span className="text-[9px] text-emerald-700 font-bold uppercase tracking-wider">DB Wallet</span>
              <span className="text-xs font-bold text-[#006b23] mt-0.5" style={{ fontFamily: 'Outfit' }}>₹450.00</span>
            </div>
          </Link>

          {/* Notification Bell Circle (Strictly h-10 w-10 = 40px) */}
          <Link
            href="/notifications"
            className="h-10 w-10 rounded-full bg-slate-100/90 hover:bg-slate-100 border border-slate-200/80 flex items-center justify-center relative text-slate-600 hover:text-slate-900 transition-all shrink-0 hover:shadow-xs"
            aria-label="Notifications"
            title="Notifications"
          >
            <Bell className="w-4 h-4" />
            <span className="absolute top-2.5 right-2.5 w-2 h-2 bg-emerald-500 rounded-full ring-2 ring-white" />
          </Link>

          {/* Account Profile / Login (Strictly h-10 = 40px) */}
          {isAuthenticated ? (
            <div className="relative shrink-0" ref={profileMenuRef}>
              <button
                onClick={() => setIsProfileMenuOpen(!isProfileMenuOpen)}
                className="flex items-center gap-2 h-10 pl-1.5 pr-3 rounded-full bg-slate-100/90 hover:bg-slate-100 border border-slate-200/80 text-slate-800 transition-all shrink-0 hover:shadow-xs"
                title={displayName}
              >
                <span className="w-7 h-7 rounded-full bg-[#006b23] text-white text-[11px] font-extrabold flex items-center justify-center shadow-xs shrink-0">
                  {initials}
                </span>
                <span className="text-xs font-bold text-slate-800 max-w-[90px] truncate hidden xl:block" style={{ fontFamily: 'Outfit' }}>
                  {displayName}
                </span>
                <ChevronDown className={`w-3.5 h-3.5 text-slate-400 transition-transform duration-200 ${isProfileMenuOpen ? 'rotate-180' : ''}`} />
              </button>

              {/* Profile Dropdown Menu */}
              {isProfileMenuOpen && (
                <div className="absolute right-0 mt-2 w-56 bg-white rounded-2xl shadow-xl border border-slate-200/80 py-2 z-50 animate-[fadeIn_0.15s_ease-out]">
                  <div className="px-4 py-2 border-b border-slate-100">
                    <p className="text-xs text-slate-400 font-medium">Signed in as</p>
                    <p className="text-sm font-bold text-slate-800 truncate" style={{ fontFamily: 'Outfit' }}>{displayName}</p>
                  </div>
                  <Link
                    href="/profile"
                    className="flex items-center gap-2.5 px-4 py-2.5 text-xs font-semibold text-slate-700 hover:bg-emerald-50 hover:text-[#006b23] transition-colors"
                  >
                    <User className="w-4 h-4 text-slate-400" />
                    <span>My Profile & Addresses</span>
                  </Link>
                  <Link
                    href="/tracking"
                    className="flex items-center gap-2.5 px-4 py-2.5 text-xs font-semibold text-slate-700 hover:bg-emerald-50 hover:text-[#006b23] transition-colors"
                  >
                    <Truck className="w-4 h-4 text-slate-400" />
                    <span>Track Active Orders</span>
                  </Link>
                  <Link
                    href="/wallet"
                    className="flex items-center gap-2.5 px-4 py-2.5 text-xs font-semibold text-slate-700 hover:bg-emerald-50 hover:text-[#006b23] transition-colors"
                  >
                    <Wallet className="w-4 h-4 text-slate-400" />
                    <span>DB Wallet (₹450)</span>
                  </Link>
                  <Link
                    href="/loyalty"
                    className="flex items-center gap-2.5 px-4 py-2.5 text-xs font-semibold text-slate-700 hover:bg-emerald-50 hover:text-[#006b23] transition-colors"
                  >
                    <Zap className="w-4 h-4 text-amber-500" />
                    <span>DB Plus VIP Membership</span>
                  </Link>
                  <div className="border-t border-slate-100 my-1" />
                  <button
                    onClick={handleLogout}
                    className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-bold text-red-600 hover:bg-red-50 transition-colors text-left"
                  >
                    <LogOut className="w-4 h-4 text-red-500" />
                    <span>Sign Out</span>
                  </button>
                </div>
              )}
            </div>
          ) : (
            <Link
              href="/login"
              className="h-10 px-4 rounded-full bg-white hover:bg-slate-50 border border-slate-300 hover:border-[#006b23] text-[#006b23] font-bold text-xs flex items-center gap-2 transition-all shrink-0 hover:shadow-xs"
            >
              <User className="w-4 h-4" />
              <span>Login</span>
            </Link>
          )}

          {/* Shopping Basket Button (Strictly h-10 = 40px) */}
          {onCartClick ? (
            <button
              onClick={onCartClick}
              className="h-10 px-4 rounded-full bg-[#006b23] hover:bg-[#00531a] active:scale-95 text-white font-bold text-xs flex items-center gap-2 shadow-sm hover:shadow transition-all shrink-0"
              aria-label="Open Shopping Basket"
            >
              <ShoppingBag className="w-4 h-4" />
              <span className="hidden sm:inline">My Basket</span>
              {effectiveCartCount > 0 && (
                <span className="min-w-[20px] h-5 px-1.5 rounded-full bg-white text-[#006b23] text-[11px] font-extrabold flex items-center justify-center shadow-xs">
                  {effectiveCartCount}
                </span>
              )}
            </button>
          ) : (
            <Link
              href="/cart"
              className="h-10 px-4 rounded-full bg-[#006b23] hover:bg-[#00531a] active:scale-95 text-white font-bold text-xs flex items-center gap-2 shadow-sm hover:shadow transition-all shrink-0"
              aria-label="View Shopping Cart"
            >
              <ShoppingBag className="w-4 h-4" />
              <span className="hidden sm:inline">My Basket</span>
              {effectiveCartCount > 0 && (
                <span className="min-w-[20px] h-5 px-1.5 rounded-full bg-white text-[#006b23] text-[11px] font-extrabold flex items-center justify-center shadow-xs">
                  {effectiveCartCount}
                </span>
              )}
            </Link>
          )}

          {/* Mobile Menu Hamburger (Strictly h-10 w-10 = 40px) */}
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="md:hidden h-10 w-10 rounded-full bg-slate-100/90 hover:bg-slate-100 border border-slate-200/80 flex items-center justify-center text-slate-700 transition-all shrink-0"
            aria-label="Toggle Navigation Menu"
          >
            {isMobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
          </button>
        </div>
      </div>

      {/* ─── Mobile Search Bar (Only shown on small screens) ────────────────── */}
      <div className="sm:hidden px-4 pb-3">
        <form onSubmit={handleSearchSubmit}>
          <div className="relative h-10 w-full rounded-full bg-slate-100/90 border border-slate-200/90 flex items-center px-3.5 gap-2.5">
            <Search className="w-4 h-4 text-slate-400 shrink-0" />
            <input
              type="text"
              value={searchQuery}
              onChange={handleSearchChange}
              placeholder='Search groceries, fruits, milk...'
              className="w-full h-full bg-transparent text-xs font-medium text-slate-800 placeholder-slate-400 focus:outline-none"
            />
            {searchQuery && (
              <button
                type="button"
                onClick={clearSearch}
                className="p-1 rounded-full text-slate-400 hover:text-slate-600"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            )}
          </div>
        </form>
      </div>

      {/* ─── Secondary Category Navigation Strip (Clean horizontal rhythm) ──── */}
      <div className="w-full border-t border-slate-200/70 bg-white/90 backdrop-blur-md hidden md:block">
        <div className="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8 h-11 flex items-center justify-between gap-4">
          <nav className="flex items-center gap-1 overflow-x-auto scrollbar-none py-1">
            {navLinks.map((item) => {
              const isActive = item.href === '/' ? pathname === '/' : pathname.startsWith(item.href);
              const Icon = item.icon;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`text-xs font-semibold px-3 py-1.5 rounded-lg flex items-center gap-1.5 whitespace-nowrap transition-all ${
                    isActive
                      ? 'bg-emerald-50 text-[#006b23] font-bold shadow-xs'
                      : 'text-slate-600 hover:text-[#006b23] hover:bg-slate-100/80'
                  }`}
                >
                  {Icon && <Icon className="w-3.5 h-3.5 shrink-0" />}
                  <span>{item.label}</span>
                  {item.badge && (
                    <span
                      className={`text-[9px] font-extrabold px-1.5 py-0.2 rounded-full uppercase tracking-wider ${
                        item.badge === 'VIP'
                          ? 'bg-amber-100 text-amber-800 border border-amber-200'
                          : item.badge === 'OFFERS'
                          ? 'bg-red-100 text-red-700 border border-red-200'
                          : 'bg-emerald-100 text-emerald-800 border border-emerald-200'
                      }`}
                    >
                      {item.badge}
                    </span>
                  )}
                </Link>
              );
            })}
          </nav>

          {/* Trust Badge on the Far Right */}
          <div className="hidden xl:flex items-center gap-2 text-[11px] font-semibold text-emerald-800 bg-emerald-50/70 border border-emerald-200/50 px-3 py-1 rounded-full shrink-0">
            <ShieldCheck className="w-3.5 h-3.5 text-[#006b23]" />
            <span>100% Quality Inspected Produce</span>
          </div>
        </div>
      </div>

      {/* ─── Mobile Slide-Out Drawer (Clean mobile accessibility) ────────────── */}
      {isMobileMenuOpen && (
        <div className="md:hidden border-t border-slate-200 bg-white px-4 py-4 space-y-4 shadow-xl animate-[fadeIn_0.15s_ease-out]">
          {/* Mobile Location */}
          <Link
            href="/select-location"
            className="flex items-center justify-between p-3 rounded-2xl bg-slate-50 border border-slate-200/80"
          >
            <div className="flex items-center gap-2.5">
              <MapPin className="w-4 h-4 text-[#006b23]" />
              <div>
                <p className="text-[10px] text-slate-400 font-bold uppercase">Delivering To</p>
                <p className="text-xs font-bold text-slate-800">Koramangala 4th Block</p>
              </div>
            </div>
            <span className="text-xs text-[#006b23] font-bold">Change →</span>
          </Link>

          {/* Quick Links Grid */}
          <div className="grid grid-cols-2 gap-2 pt-1">
            {navLinks.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="p-2.5 bg-slate-50 hover:bg-emerald-50 rounded-xl text-xs font-semibold text-slate-700 hover:text-[#006b23] border border-slate-100 flex items-center justify-between"
              >
                <span>{item.label}</span>
                {item.badge && (
                  <span className="text-[9px] font-extrabold px-1.5 py-0.5 rounded-full bg-emerald-100 text-[#006b23]">
                    {item.badge}
                  </span>
                )}
              </Link>
            ))}
          </div>

          {/* Mobile Wallet & Account */}
          <div className="pt-2 border-t border-slate-100 flex items-center justify-between">
            <Link
              href="/wallet"
              className="flex items-center gap-2 text-xs font-bold text-[#006b23] bg-emerald-50 px-3 py-2 rounded-xl border border-emerald-200/70"
            >
              <Wallet className="w-4 h-4" />
              <span>Wallet: ₹450.00</span>
            </Link>
            {isAuthenticated ? (
              <button
                onClick={handleLogout}
                className="text-xs font-bold text-red-600 hover:bg-red-50 px-3 py-2 rounded-xl transition"
              >
                Sign Out
              </button>
            ) : (
              <Link
                href="/login"
                className="text-xs font-bold text-white bg-[#006b23] px-4 py-2 rounded-xl shadow-xs"
              >
                Sign In
              </Link>
            )}
          </div>
        </div>
      )}
    </header>
    </>
  );
}
