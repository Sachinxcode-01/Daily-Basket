import React from 'react';
import Link from 'next/link';
import { ArrowLeft, ShieldCheck } from 'lucide-react';

export const metadata = {
  title: 'Privacy Policy | Daily Basket',
  description: 'Daily Basket Privacy Policy and Data Protection Standards',
};

export default function PrivacyPage() {
  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-6 max-w-4xl mx-auto">
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Store</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white flex items-center gap-2">
          <ShieldCheck className="w-5 h-5 text-emerald-400" />
          Privacy Policy
        </h1>
        <div className="w-6" />
      </div>

      <div className="bg-slate-800/80 border border-slate-700/60 p-6 rounded-3xl space-y-6 text-sm text-slate-300 leading-relaxed">
        <p className="text-xs text-slate-400">Last Updated: August 3, 2026</p>
        
        <section className="space-y-2">
          <h2 className="text-base font-bold text-white">1. Data We Collect</h2>
          <p>Daily Basket collects phone numbers for login authentication, delivery address location coordinates for 10-minute dispatch routing, and order transaction history to fulfill quick-commerce orders.</p>
        </section>

        <section className="space-y-2">
          <h2 className="text-base font-bold text-white">2. How We Protect Your Information</h2>
          <p>All sensitive payment transactions are processed securely via Razorpay with HMAC SHA-256 signature verification. We do not store credit/debit card credentials on our servers.</p>
        </section>

        <section className="space-y-2">
          <h2 className="text-base font-bold text-white">3. Contact Us</h2>
          <p>If you have any questions regarding your data privacy, contact our Data Protection Officer at <span className="text-emerald-400 font-semibold">privacy@dailybasket.com</span>.</p>
        </section>
      </div>
    </div>
  );
}
