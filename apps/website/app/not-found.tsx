import React from 'react';
import Link from 'next/link';
import { ShoppingBag, ArrowLeft } from 'lucide-react';

export default function NotFoundPage() {
  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-6 flex flex-col items-center justify-center text-center max-w-md mx-auto">
      <div className="w-20 h-20 rounded-3xl bg-slate-800 border border-slate-700 flex items-center justify-center text-emerald-400 mb-6 shadow-xl">
        <ShoppingBag className="w-10 h-10" />
      </div>

      <h1 className="text-4xl font-black text-white mb-2">404</h1>
      <h2 className="text-xl font-bold text-slate-200 mb-3">Page Not Found</h2>
      <p className="text-xs text-slate-400 mb-8">
        The item or page you are looking for might have been moved or is out of stock.
      </p>

      <Link
        href="/"
        className="w-full py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl shadow-lg flex items-center justify-center gap-2 transition"
      >
        <ArrowLeft className="w-4 h-4" />
        <span>Return to Home Store</span>
      </Link>
    </div>
  );
}
