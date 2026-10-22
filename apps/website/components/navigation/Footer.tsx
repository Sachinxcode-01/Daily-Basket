'use client';

import React from 'react';
import Link from 'next/link';
import Image from 'next/image';

export default function Footer() {
  return (
    <footer className="bg-white border-t border-slate-200/90 mt-20 pt-16 pb-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-[1440px] mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8 lg:gap-10 pb-12 border-b border-slate-100">
          {/* Brand Col */}
          <div className="lg:col-span-2 space-y-4">
            <div className="flex items-center gap-3">
              <Image src="/images/daily_basket_logo.png" alt="Daily Basket Logo" width={32} height={32} className="object-contain" />
              <span className="text-2xl font-black text-[#006b23] tracking-tight font-outfit">Daily Basket</span>
            </div>
            <p className="text-xs text-slate-500 leading-relaxed max-w-sm">
              India’s pioneer 10-minute instant grocery delivery platform. Farm-fresh vegetables, dairy, staples, and bakery delivered from local micro-fulfillment dark stores right to your doorstep.
            </p>
            <div className="flex items-center gap-2 pt-2">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse" />
              <span className="text-xs font-bold text-slate-700">10-Minute Rapid Delivery Active</span>
            </div>
          </div>

          {/* Categories Col */}
          <div className="space-y-3">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400 font-outfit">Popular Categories</h3>
            <ul className="space-y-2 text-xs font-medium text-slate-600">
              <li><Link href="/categories/fresh-vegetables" className="hover:text-[#006b23] transition">Fresh Vegetables</Link></li>
              <li><Link href="/categories/dairy-bread-eggs" className="hover:text-[#006b23] transition">Dairy, Bread & Eggs</Link></li>
              <li><Link href="/categories/milk" className="hover:text-[#006b23] transition">Fresh Milk & Dairy</Link></li>
              <li><Link href="/freshness" className="hover:text-[#006b23] transition">Farm Fresh Produce</Link></li>
              <li><Link href="/categories" className="hover:text-[#006b23] transition">All Categories →</Link></li>
            </ul>
          </div>

          {/* Customer Services Col */}
          <div className="space-y-3">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400 font-outfit">Customer Service</h3>
            <ul className="space-y-2 text-xs font-medium text-slate-600">
              <li><Link href="/tracking" className="hover:text-[#006b23] transition">Live Order Tracking</Link></li>
              <li><Link href="/offers" className="hover:text-[#006b23] transition">Coupons & Deals</Link></li>
              <li><Link href="/support" className="hover:text-[#006b23] transition">Support Desk (24/7)</Link></li>
              <li><Link href="/help" className="hover:text-[#006b23] transition">Help Center & FAQs</Link></li>
              <li><Link href="/wallet" className="hover:text-[#006b23] transition">DB Wallet & Refunds</Link></li>
            </ul>
          </div>

          {/* Company & Operations Col */}
          <div className="space-y-3">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400 font-outfit">Company & Health</h3>
            <ul className="space-y-2 text-xs font-medium text-slate-600">
              <li><Link href="/about" className="hover:text-[#006b23] transition">About Us</Link></li>
              <li><Link href="/careers" className="hover:text-[#006b23] transition">Careers</Link></li>
              <li><Link href="/impact" className="hover:text-[#006b23] transition">Environmental Impact</Link></li>
              <li><Link href="/status" className="hover:text-[#006b23] transition flex items-center gap-1.5"><span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />System Status</Link></li>
              <li><Link href="/security" className="hover:text-[#006b23] transition">Security Overview</Link></li>
            </ul>
          </div>
        </div>

        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-500">
          <p>© 2026 Daily Basket Quick-Commerce Suite. All rights reserved.</p>
          <div className="flex items-center gap-6">
            <Link href="/privacy" className="hover:text-slate-800 transition">Privacy Policy</Link>
            <Link href="/terms" className="hover:text-slate-800 transition">Terms of Service</Link>
            <Link href="/contact" className="hover:text-slate-800 transition">Contact Us</Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
