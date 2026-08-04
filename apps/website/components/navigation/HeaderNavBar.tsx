'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { usePathname } from 'next/navigation';

interface HeaderNavBarProps {
  cartCount?: number;
  onSearch?: (query: string) => void;
  onCartClick?: () => void;
}

export default function HeaderNavBar({ cartCount = 0, onSearch, onCartClick }: HeaderNavBarProps) {
  const pathname = usePathname();
  const [searchQuery, setSearchQuery] = useState('');

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    setSearchQuery(val);
    if (onSearch) onSearch(val);
  };

  const navItems = [
    { label: 'Home', href: '/' },
    { label: 'Categories', href: '/categories' },
    { label: 'Freshness Explorer', href: '/freshness', badge: 'NEW' },
    { label: 'Features', href: '/features' },
    { label: 'How It Works', href: '/how-it-works' },
    { label: 'DB Plus VIP', href: '/loyalty', badge: 'VIP' },
    { label: 'About', href: '/about' },
  ];

  return (
    <header className="sticky top-0 z-50 bg-surface/95 backdrop-blur-md border-b border-outline-variant/20 shadow-sm">
      
      {/* ─── Top Notification Banner ────────────────────────────────────────── */}
      <div className="bg-primary text-on-primary text-[11px] font-semibold py-1.5 px-4 text-center tracking-wide flex items-center justify-center gap-2">
        <span className="bg-white/20 px-2 py-0.5 rounded-full text-[10px] uppercase font-bold">10 MIN DELIVERY</span>
        <span>⚡ Superfast grocery delivery active in Koramangala & Indiranagar • Free delivery on orders over ₹199!</span>
        <Link href="/loyalty" className="underline font-bold hover:opacity-90 ml-1">Join DB Plus →</Link>
      </div>

      {/* ─── Main Desktop Navigation Bar (Full Width Stretched) ─────────────── */}
      <div className="w-full px-4 sm:px-8 md:px-10 lg:px-12 h-20 flex items-center justify-between gap-6">

        {/* Left: Logo & Location Selector */}
        <div className="flex items-center gap-5">
          <Link href="/" className="flex items-center gap-2.5 hover:opacity-95 transition-opacity">
            <div className="w-10 h-10 rounded-xl bg-surface-container-lowest border border-outline-variant/30 flex items-center justify-center p-1 shadow-level-1">
              <Image src="/images/daily_basket_logo.png" alt="Daily Basket Logo" width={32} height={32} className="w-full h-full object-contain" />
            </div>
            <div className="flex flex-col">
              <span className="font-title-md text-xl font-extrabold text-primary leading-none" style={{ fontFamily: 'Outfit' }}>
                Daily Basket
              </span>
              <span className="text-[10px] text-on-surface-variant font-medium tracking-wider uppercase mt-0.5">Quick Commerce</span>
            </div>
          </Link>

          {/* Location Selector */}
          <div className="hidden xl:flex items-center gap-2 bg-surface-container-low border border-outline-variant/30 px-3.5 py-1.5 rounded-full">
            <span className="text-xs">📍</span>
            <div className="flex flex-col text-left">
              <span className="text-[9px] text-on-surface-variant font-medium uppercase tracking-wider">Delivering to</span>
              <span className="text-xs font-bold text-on-surface truncate max-w-[150px]" style={{ fontFamily: 'Outfit' }}>
                Koramangala 4th Block
              </span>
            </div>
            <span className="text-xs text-on-surface-variant">▾</span>
          </div>
        </div>

        {/* Center: Desktop Navigation Bar */}
        <nav className="hidden lg:flex items-center gap-1">
          {navItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`font-body-lg text-xs font-medium transition-all rounded-full px-3.5 py-2 flex items-center gap-1.5 ${
                  isActive
                    ? 'bg-primary text-on-primary font-bold shadow-sm'
                    : 'text-on-surface-variant hover:text-primary hover:bg-secondary-container/40'
                }`}
              >
                <span>{item.label}</span>
                {item.badge && (
                  <span className={`text-[9px] font-extrabold px-1.5 py-0.2 rounded-full uppercase ${isActive ? 'bg-white text-primary' : 'bg-primary/10 text-primary'}`}>
                    {item.badge}
                  </span>
                )}
              </Link>
            );
          })}
        </nav>

        {/* Right: Search, Wallet & Cart Actions */}
        <div className="flex items-center gap-3 flex-1 lg:flex-initial justify-end">
          
          {/* Search Bar */}
          <div className="relative w-full max-w-xs hidden sm:block">
            <svg className="w-4 h-4 text-on-surface-variant absolute left-3.5 top-1/2 -translate-y-1/2" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}>
              <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <input
              type="text"
              value={searchQuery}
              onChange={handleSearchChange}
              placeholder='Search "milk", "tomatoes", "tea"...'
              className="w-full bg-surface-container-low border border-outline-variant/30 rounded-full pl-10 pr-4 py-2 text-xs focus:outline-none focus:border-primary transition-colors"
            />
          </div>

          {/* Wallet Balance Badge */}
          <Link
            href="/wallet"
            className="hidden md:flex items-center gap-1.5 bg-secondary-container/40 border border-outline-variant/30 px-3 py-2 rounded-full hover:bg-secondary-container transition-colors"
          >
            <span className="text-xs">👛</span>
            <div className="flex flex-col text-left leading-none">
              <span className="text-[9px] text-on-surface-variant font-medium">DB Wallet</span>
              <span className="text-xs font-bold text-primary" style={{ fontFamily: 'Outfit' }}>₹450.00</span>
            </div>
          </Link>

          {/* Notifications Bell */}
          <Link
            href="/notifications"
            className="w-9 h-9 rounded-full bg-surface-container-low border border-outline-variant/30 flex items-center justify-center relative hover:bg-surface-container-lowest transition-colors text-on-surface-variant"
            aria-label="Notifications"
          >
            <span className="text-sm">🔔</span>
            <span className="absolute top-1 right-1 w-2 h-2 bg-error rounded-full" />
          </Link>

          {/* Shopping Basket Button */}
          {onCartClick ? (
            <button
              onClick={onCartClick}
              className="relative bg-primary text-on-primary font-label-md text-xs px-4 py-2.5 rounded-full hover:bg-surface-tint transition-all shadow-level-1 flex items-center gap-2 font-bold active:scale-95"
            >
              <span>🛒 Basket</span>
              {cartCount > 0 && (
                <span className="w-5 h-5 bg-white text-primary rounded-full text-xs font-extrabold flex items-center justify-center">
                  {cartCount}
                </span>
              )}
            </button>
          ) : (
            <Link
              href="/cart"
              className="relative bg-primary text-on-primary font-label-md text-xs px-4 py-2.5 rounded-full hover:bg-surface-tint transition-all shadow-level-1 flex items-center gap-2 font-bold active:scale-95"
            >
              <span>🛒 Basket</span>
              {cartCount > 0 && (
                <span className="w-5 h-5 bg-white text-primary rounded-full text-xs font-bold flex items-center justify-center">
                  {cartCount}
                </span>
              )}
            </Link>
          )}

        </div>
      </div>
    </header>
  );
}
