'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { usePathname } from 'next/navigation';

interface HeaderNavBarProps {
  cartCount?: number;
  onSearch?: (query: string) => void;
}

export default function HeaderNavBar({ cartCount = 0, onSearch }: HeaderNavBarProps) {
  const pathname = usePathname();
  const [searchQuery, setSearchQuery] = useState('');

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    setSearchQuery(val);
    if (onSearch) onSearch(val);
  };

  const navItems = [
    { label: 'Home', href: '/' },
    { label: 'Features', href: '/features' },
    { label: 'How It Works', href: '/how-it-works' },
    { label: 'Freshness', href: '/freshness' },
    { label: 'About', href: '/about' },
  ];

  return (
    <header className="sticky top-0 z-50 bg-surface/90 backdrop-blur-md border-b border-outline-variant/20 shadow-sm">
      <div className="max-w-[1280px] mx-auto px-margin-mobile md:px-margin-desktop h-20 flex items-center justify-between gap-6">

        {/* Left: Logo & Location */}
        <div className="flex items-center gap-4">
          <Link href="/" className="flex items-center gap-2.5 hover:opacity-95 transition-opacity">
            <div className="w-10 h-10 rounded-xl bg-surface-container-lowest border border-outline-variant/30 flex items-center justify-center p-1 shadow-level-1">
              <Image src="/images/daily_basket_logo.png" alt="Daily Basket Logo" width={32} height={32} className="w-full h-full object-contain" />
            </div>
            <span className="font-title-md text-xl font-extrabold text-primary hidden sm:inline-block" style={{ fontFamily: 'Outfit' }}>
              Daily Basket
            </span>
          </Link>

          {/* 10 MINS Badge */}
          <div className="hidden lg:flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/10 border border-primary/20">
            <span className="text-xs">⚡</span>
            <span className="font-label-md text-xs text-primary font-bold tracking-wider">10 MINS DELIVERY</span>
          </div>

          {/* Location Selector */}
          <button className="hidden sm:flex flex-col text-left hover:opacity-80 transition-opacity">
            <span className="text-[10px] text-on-surface-variant font-medium">Delivery to 📍</span>
            <span className="text-xs font-bold text-on-surface truncate max-w-[170px]" style={{ fontFamily: 'Outfit' }}>
              Koramangala 4th Block...
            </span>
          </button>
        </div>

        {/* Center: Desktop Navigation Bar */}
        <nav className="hidden md:flex items-center gap-1">
          {navItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`font-body-lg text-sm transition-colors rounded-lg px-3 py-2 ${
                  isActive
                    ? 'text-primary font-bold border-b-2 border-primary'
                    : 'text-on-surface-variant hover:text-primary hover:bg-secondary-container/50'
                }`}
              >
                {item.label}
              </Link>
            );
          })}
        </nav>

        {/* Right: Search Bar & Cart Action */}
        <div className="flex items-center gap-4 flex-1 md:flex-initial justify-end">
          <div className="relative w-full max-w-xs hidden sm:block">
            <svg className="w-4 h-4 text-on-surface-variant absolute left-3 top-1/2 -translate-y-1/2" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}>
              <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <input
              type="text"
              value={searchQuery}
              onChange={handleSearchChange}
              placeholder='Search "milk", "tomatoes"...'
              className="w-full bg-surface-container-low border border-outline-variant/30 rounded-full pl-9 pr-4 py-2 text-xs focus:outline-none focus:border-primary transition-colors"
            />
          </div>

          {/* Cart Button */}
          <Link
            href="/cart"
            className="relative bg-primary text-on-primary font-label-md text-sm px-5 py-2.5 rounded-full hover:bg-surface-tint transition-all shadow-level-1 flex items-center gap-2 font-semibold active:scale-95"
          >
            <span>🛒 Basket</span>
            {cartCount > 0 && (
              <span className="w-5 h-5 bg-white text-primary rounded-full text-xs font-bold flex items-center justify-center">
                {cartCount}
              </span>
            )}
          </Link>
        </div>
      </div>
    </header>
  );
}
