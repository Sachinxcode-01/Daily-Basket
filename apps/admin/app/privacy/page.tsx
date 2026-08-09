'use client';

import React from 'react';
import { ArrowLeft, ShieldCheck } from 'lucide-react';

// Google Stitch Specs: Privacy Policy & Terms - Daily Basket Admin
// ID: 5d9958f69a2144ddbdd4f1f8d89d44b6

export default function PrivacyPolicyPage() {
  return (
    <div className="max-w-3xl mx-auto space-y-6 font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-black text-[#006837]">Privacy Policy &amp; Legal</h1>
          <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: 5d9958f69a2144ddbdd4f1f8d89d44b6</p>
        </div>
      </div>

      <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
        <div className="flex items-center gap-2 text-[#006837]">
          <ShieldCheck className="w-5 h-5" />
          <h3 className="font-black text-base">Data Protection &amp; Security Standard</h3>
        </div>
        <p className="text-xs text-[#334155] leading-relaxed">
          Daily Basket platform complies with DPDP regulations and GDPR standards. All customer telemetry and payment tokens are encrypted at rest using AES-256 and in transit via TLS 1.3.
        </p>
        <p className="text-xs font-bold text-[#006837]">Last Updated: August 9, 2026</p>
      </div>
    </div>
  );
}
