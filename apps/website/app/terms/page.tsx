import React from 'react';
import Link from 'next/link';
import { ArrowLeft, FileText } from 'lucide-react';

export const metadata = {
  title: 'Terms & Conditions | Daily Basket',
  description: 'Daily Basket Terms and Conditions of Service',
};

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-6 max-w-4xl mx-auto">
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Store</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white flex items-center gap-2">
          <FileText className="w-5 h-5 text-emerald-400" />
          Terms & Conditions
        </h1>
        <div className="w-6" />
      </div>

      <div className="bg-slate-800/80 border border-slate-700/60 p-6 rounded-3xl space-y-6 text-sm text-slate-300 leading-relaxed">
        <p className="text-xs text-slate-400">Effective Date: August 3, 2026</p>
        
        <section className="space-y-2">
          <h2 className="text-base font-bold text-white">1. 10-Minute Delivery Guarantee</h2>
          <p>Daily Basket strives to deliver fresh groceries within 10 minutes of order placement within designated dark store service zones in Koramangala, Bengaluru.</p>
        </section>

        <section className="space-y-2">
          <h2 className="text-base font-bold text-white">2. Order Acceptance & Pricing</h2>
          <p>Prices listed include applicable taxes. Promotional coupons (`DAILY100`) must be applied prior to payment checkout.</p>
        </section>

        <section className="space-y-2">
          <h2 className="text-base font-bold text-white">3. Customer Support</h2>
          <p>For instant order support, contact our 24x7 customer care team at <span className="text-emerald-400 font-semibold">support@dailybasket.com</span>.</p>
        </section>
      </div>
    </div>
  );
}
