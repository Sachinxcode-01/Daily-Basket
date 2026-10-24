'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { Menu, X, LayoutGrid, ShoppingBag, UserCheck, ShieldAlert, Sparkles, Navigation, Activity } from 'lucide-react';

interface RouteGroup {
  category: string;
  items: { label: string; href: string; badge?: string }[];
}

const allRoutes: RouteGroup[] = [
  {
    category: 'Store & Shopping Experience',
    items: [
      { label: 'Home Page', href: '/' },
      { label: 'Search Results', href: '/search' },
      { label: 'Browse Categories', href: '/categories' },
      { label: 'Fresh Vegetables Category', href: '/categories/fresh-vegetables' },
      { label: 'Dairy & Bread Category', href: '/categories/dairy-bread-eggs' },
      { label: 'Fresh Produce Explorer', href: '/freshness', badge: 'PRODUCE' },
      { label: 'Coupons & Deals Hub', href: '/offers', badge: 'OFFERS' },
      { label: 'Quick Buy (Reorder)', href: '/quick-buy' },
      { label: 'Saved Wishlist', href: '/wishlist' },
      { label: 'Shopping Cart', href: '/cart' },
      { label: 'Empty Cart State', href: '/cart/empty' },
      { label: 'Checkout', href: '/checkout' },
      { label: 'Order Success Confirmation', href: '/order-success' },
    ],
  },
  {
    category: 'Delivery, Logistics & User Account',
    items: [
      { label: 'Order Tracking Hub', href: '/tracking', badge: 'NEW' },
      { label: 'Live GPS Order Tracking (Demo)', href: '/tracking/ORD-9824', badge: 'LIVE GPS' },
      { label: 'Select Delivery Location', href: '/select-location' },
      { label: 'Add New Address', href: '/add-address' },
      { label: 'Rate Your Delivery', href: '/rate-delivery' },
      { label: 'User Profile & Preferences', href: '/profile' },
      { label: 'Wallet & Transactions', href: '/wallet' },
      { label: 'Notification Center', href: '/notifications' },
      { label: 'Daily Basket Plus VIP', href: '/loyalty', badge: 'VIP' },
      { label: 'Product Reviews & Ratings', href: '/reviews' },
      { label: 'Stock Alerts & Back-in-Stock', href: '/stock-alerts' },
      { label: 'Support Desk (Priority Help)', href: '/support', badge: '24/7' },
      { label: 'Help Center & FAQs', href: '/help' },
    ],
  },
  {
    category: 'System Health & Operations',
    items: [
      { label: 'System Status Dashboard', href: '/status', badge: 'LIVE HEALTH' },
      { label: 'Status JSON API Endpoint', href: '/api/status', badge: 'API' },
      { label: 'Store Closed / Maintenance', href: '/store-closed' },
      { label: 'Brand Reveal Experience', href: '/brand-reveal' },
      { label: '3D Visual Experience', href: '/experience/three-js' },
      { label: 'Shader Visual Experience', href: '/experience/shader' },
    ],
  },
  {
    category: 'Authentication & Account Security',
    items: [
      { label: 'Login Options', href: '/login' },
      { label: 'Create Account', href: '/register' },
      { label: 'Verify Email OTP', href: '/verify-email' },
      { label: 'Email Verified Success', href: '/success' },
      { label: 'Forgot Password', href: '/forgot-password' },
      { label: 'Reset Password', href: '/reset-password' },
      { label: 'Enable Biometrics (WebAuthn)', href: '/enable-biometrics' },
      { label: 'Account Locked Safeguard', href: '/account-locked' },
    ],
  },
  {
    category: 'Company, Impact & Policies',
    items: [
      { label: 'App Features & Tech Stack', href: '/features' },
      { label: 'How 10-Min Delivery Works', href: '/how-it-works' },
      { label: 'About Us', href: '/about' },
      { label: 'Contact Us', href: '/contact' },
      { label: 'Careers at Daily Basket', href: '/careers' },
      { label: 'Environmental Impact', href: '/impact' },
      { label: 'Security & Encryption Overview', href: '/security' },
      { label: 'AI Shopping Assistant', href: '/ai-assistant', badge: 'AI' },
      { label: 'Terms of Service', href: '/terms' },
      { label: 'Privacy Policy', href: '/privacy' },
    ],
  },
];

export default function QuickNavMenu() {
  const [isOpen, setIsOpen] = useState(false);
  const totalScreens = allRoutes.reduce((acc, g) => acc + g.items.length, 0);

  const [isDismissed, setIsDismissed] = useState(false);

  if (isDismissed) return null;

  return (
    <>
      {/* Quick Nav Hub Discreet Trigger Button */}
      <div className="fixed bottom-5 right-5 z-40 flex items-center gap-1.5 bg-[#006b23]/95 hover:bg-[#00531a] text-white p-1.5 pl-3.5 pr-2 rounded-full shadow-lg border border-emerald-400/30 backdrop-blur-md transition-all duration-200">
        <button
          onClick={() => setIsOpen(true)}
          className="flex items-center gap-2 font-bold text-xs font-outfit cursor-pointer"
          aria-label="Open Screen Navigator"
        >
          <LayoutGrid className="w-3.5 h-3.5" />
          <span>Dev Screens ({totalScreens})</span>
        </button>
        <button
          onClick={() => setIsDismissed(true)}
          className="w-5 h-5 rounded-full hover:bg-black/20 flex items-center justify-center text-white/70 hover:text-white transition cursor-pointer"
          aria-label="Hide navigation pill"
          title="Dismiss Navigator"
        >
          <X className="w-3 h-3" />
        </button>
      </div>

      {/* Modal Backdrop */}
      {isOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4 sm:p-6 animate-[fadeIn_0.2s_ease-out]">
          <div className="bg-white rounded-3xl max-w-3xl w-full max-h-[88vh] flex flex-col shadow-2xl border border-slate-100 overflow-hidden">
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
                    Direct access to all {totalScreens} Daily Basket application pages & features
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
                        <span className="truncate pr-2">{item.label}</span>
                        {item.badge && (
                          <span className="text-[10px] font-extrabold bg-[#006b23] text-white px-2 py-0.5 rounded-full shrink-0">
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
            <div className="p-4 bg-slate-50 border-t border-slate-200/80 text-center text-xs text-slate-500 font-inter font-medium flex items-center justify-center gap-4">
              <span>Daily Basket Quick-Commerce Suite</span>
              <span>•</span>
              <span className="font-bold text-[#006b23]">{totalScreens} Production Screens Operational</span>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
