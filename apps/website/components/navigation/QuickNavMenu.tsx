'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { Menu, X, LayoutGrid, ShoppingBag, UserCheck, ShieldAlert, Sparkles, Navigation } from 'lucide-react';

interface RouteGroup {
  category: string;
  items: { label: string; href: string; badge?: string }[];
}

const allRoutes: RouteGroup[] = [
  {
    category: 'Store & Shopping',
    items: [
      { label: 'Home Page', href: '/' },
      { label: 'Search Results', href: '/search' },
      { label: 'Browse Categories', href: '/categories' },
      { label: 'Fresh Produce Explorer', href: '/freshness' },
      { label: 'Shopping Cart', href: '/cart' },
      { label: 'Empty Cart State', href: '/cart/empty' },
      { label: 'Checkout', href: '/checkout' },
      { label: 'Order Success', href: '/order-success' },
    ],
  },
  {
    category: 'Delivery & Account Services',
    items: [
      { label: 'Live Delivery Tracking', href: '/tracking/ORD-9824', badge: 'LIVE' },
      { label: 'Rate Your Delivery', href: '/rate-delivery' },
      { label: 'Notification Center', href: '/notifications' },
      { label: 'Wallet & Transactions', href: '/wallet' },
      { label: 'Daily Basket Plus VIP', href: '/loyalty', badge: 'VIP' },
      { label: 'Help Center & Support', href: '/help' },
    ],
  },
  {
    category: 'Authentication & Security',
    items: [
      { label: 'Login Options', href: '/login' },
      { label: 'Create Account', href: '/register' },
      { label: 'Verify Email', href: '/verify-email' },
      { label: 'Email Verified Success', href: '/success' },
      { label: 'Forgot Password', href: '/forgot-password' },
      { label: 'Reset Password', href: '/reset-password' },
      { label: 'Enable Biometrics', href: '/enable-biometrics' },
      { label: 'Account Locked', href: '/account-locked' },
    ],
  },
  {
    category: 'Company & Info',
    items: [
      { label: 'App Features', href: '/features' },
      { label: 'How It Works', href: '/how-it-works' },
      { label: 'About Us', href: '/about' },
      { label: 'Security Overview', href: '/security' },
      { label: 'AI Shopping Assistant', href: '/ai-assistant' },
      { label: 'Terms of Service', href: '/terms' },
      { label: 'Privacy Policy', href: '/privacy' },
    ],
  },
];

export default function QuickNavMenu() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      {/* Quick Nav Hub Trigger Button */}
      <button
        onClick={() => setIsOpen(true)}
        className="fixed bottom-6 left-6 z-50 px-4 py-3 bg-[#006b23] hover:bg-[#00531a] active:scale-95 text-white font-bold text-xs sm:text-sm font-outfit rounded-full shadow-2xl border border-emerald-400/40 flex items-center gap-2 transition-all duration-200"
        aria-label="Open Screen Navigator"
      >
        <LayoutGrid className="w-4 h-4" />
        <span>All Screens ({allRoutes.reduce((acc, g) => acc + g.items.length, 0)})</span>
      </button>

      {/* Modal Backdrop */}
      {isOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4 sm:p-6 animate-[fadeIn_0.2s_ease-out]">
          <div className="bg-white rounded-3xl max-w-3xl w-full max-h-[85vh] flex flex-col shadow-2xl border border-slate-100 overflow-hidden">
            
            {/* Modal Header */}
            <div className="p-5 sm:p-6 bg-slate-50 border-b border-slate-200/80 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-10 h-10 rounded-full bg-[#006b23] text-white flex items-center justify-center">
                  <Navigation className="w-5 h-5" />
                </div>
                <div>
                  <h2 className="text-xl font-extrabold text-slate-900 font-outfit">
                    Screen Navigator Hub
                  </h2>
                  <p className="text-xs text-slate-500 font-inter">
                    Direct access to all Daily Basket application pages
                  </p>
                </div>
              </div>

              <button
                onClick={() => setIsOpen(false)}
                className="p-2 text-slate-400 hover:text-slate-700 hover:bg-slate-200/60 rounded-full transition"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            {/* Modal Body: Categorized Screen Grid */}
            <div className="p-6 overflow-y-auto space-y-6 flex-1">
              {allRoutes.map((group) => (
                <div key={group.category} className="space-y-3">
                  <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400 font-outfit">
                    {group.category}
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                    {group.items.map((item) => (
                      <Link
                        key={item.href}
                        href={item.href}
                        onClick={() => setIsOpen(false)}
                        className="p-3 bg-slate-50 hover:bg-emerald-50 border border-slate-100 hover:border-emerald-200 rounded-xl text-sm font-semibold font-outfit text-slate-800 hover:text-[#006b23] flex items-center justify-between transition group"
                      >
                        <span>{item.label}</span>
                        {item.badge && (
                          <span className="text-[10px] font-extrabold bg-[#006b23] text-white px-2 py-0.5 rounded-full">
                            {item.badge}
                          </span>
                        )}
                      </Link>
                    ))}
                  </div>
                </div>
              ))}
            </div>

            {/* Modal Footer */}
            <div className="p-4 bg-slate-50 border-t border-slate-200/80 text-center text-xs text-slate-500 font-inter font-medium">
              Daily Basket Quick-Commerce Suite • All 27+ Screens Active
            </div>

          </div>
        </div>
      )}
    </>
  );
}
