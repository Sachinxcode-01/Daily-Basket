'use client';

import React from 'react';
import { ArrowLeft, Headphones, BookOpen } from 'lucide-react';

// Google Stitch Specs: Help & Support - Daily Basket Admin
// ID: 91bf727083b347b4b71f60a23bb4a2b8

export default function HelpSupportPage() {
  const faqs = [
    { q: 'How do I configure automatic PO generation?', a: 'Go to Purchase Management > Suppliers, select a preferred supplier and enable Auto Restock threshold.' },
    { q: 'What is the SLA for 10-minute delivery dispatch?', a: 'Orders must be picked and packed within 3 minutes of customer checkout for optimal rider assignment.' },
    { q: 'How do I process custom GST tax overrides?', a: 'Navigate to Settings > Finance > GST Liability and upload your state-specific HSN/SAC matrix.' },
  ];

  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-black text-[#006837]">Help &amp; Support Center</h1>
          <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: 91bf727083b347b4b71f60a23bb4a2b8</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm flex items-center gap-4">
          <div className="p-3 bg-emerald-100 text-[#006837] rounded-2xl">
            <Headphones className="w-6 h-6" />
          </div>
          <div>
            <h3 className="font-bold text-base text-[#1e2923]">Live Technical Support</h3>
            <p className="text-xs text-[#64748b]">24/7 dedicated merchant helpline</p>
          </div>
        </div>

        <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm flex items-center gap-4">
          <div className="p-3 bg-sky-100 text-[#0284c7] rounded-2xl">
            <BookOpen className="w-6 h-6" />
          </div>
          <div>
            <h3 className="font-bold text-base text-[#1e2923]">Docs &amp; API Specs</h3>
            <p className="text-xs text-[#64748b]">Explore developer documentation</p>
          </div>
        </div>
      </div>

      <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
        <h3 className="font-black text-lg text-[#1e2923]">Frequently Asked Questions</h3>
        <div className="space-y-3">
          {faqs.map((f, i) => (
            <div key={i} className="p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] space-y-1">
              <h4 className="font-bold text-sm text-[#1e2923]">{f.q}</h4>
              <p className="text-xs text-[#64748b] leading-relaxed">{f.a}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
