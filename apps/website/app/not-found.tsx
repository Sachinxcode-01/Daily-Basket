import React from 'react';
import Link from 'next/link';
import { ShoppingBasket, ArrowLeft, Search, Home } from 'lucide-react';

export const metadata = {
  title: '404 - Page Not Found | Daily Basket',
  description: 'The requested page or grocery item could not be found on Daily Basket.',
};

export default function NotFound() {
  return (
    <div className="min-h-screen bg-[#f9f9fc] text-[#1a1c1e] font-sans flex flex-col items-center justify-center p-6 text-center">
      <div className="max-w-md w-full bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-[#e2e2e5] space-y-6">
        {/* Visual Badge Icon */}
        <div className="w-24 h-24 mx-auto rounded-3xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center relative">
          <ShoppingBasket className="w-12 h-12" />
          <span className="absolute -top-2 -right-2 px-2.5 py-0.5 bg-[#ba1a1a] text-white text-xs font-black rounded-full shadow-sm">
            404
          </span>
        </div>

        <div className="space-y-2">
          <h1 className="text-3xl font-extrabold text-[#1a1c1e] tracking-tight">Basket Item Missing</h1>
          <p className="text-sm text-[#3f4a3d] leading-relaxed">
            The page or grocery category you are looking for has been moved, renamed, or is temporarily out of stock.
          </p>
        </div>

        <div className="space-y-3 pt-2">
          <Link
            href="/"
            className="w-full inline-flex items-center justify-center gap-2 py-3.5 bg-[#006b23] text-white rounded-xl font-bold text-sm hover:bg-[#078730] transition active:scale-95 shadow-sm"
          >
            <Home className="w-4 h-4" />
            <span>Return to Homepage</span>
          </Link>

          <Link
            href="/categories"
            className="w-full inline-flex items-center justify-center gap-2 py-3 bg-[#dce5dd] text-[#006b23] rounded-xl font-bold text-sm hover:bg-[#becab9] transition"
          >
            <Search className="w-4 h-4" />
            <span>Browse All Categories</span>
          </Link>
        </div>
      </div>
    </div>
  );
}
