'use client';

import React from 'react';
import { ArrowLeft, Rocket, CheckCircle2, Circle } from 'lucide-react';

// Google Stitch Specs: Go Live & Launch Checklist - Daily Basket Admin
// ID: eece7072c79f45dc8785946e46beab3b

export default function LaunchChecklistPage() {
  const tasks = [
    { title: 'NestJS Production Database Connection', done: true },
    { title: 'Stripe & Razorpay Live API Keys Configured', done: true },
    { title: 'Dark Store Warehouses & Inventory Seeded', done: true },
    { title: 'Delivery Partner Geofencing & Zone Bounds Set', done: true },
    { title: 'Domain SSL Certificate & DNS Verification', done: false },
    { title: 'Push Notification Firebase Service Account JSON', done: false },
  ];

  return (
    <div className="max-w-3xl mx-auto space-y-6 font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="flex items-center gap-2">
          <Rocket className="w-6 h-6 text-[#006837]" />
          <div>
            <h1 className="text-2xl font-black text-[#006837]">Go Live &amp; Launch Checklist</h1>
            <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: eece7072c79f45dc8785946e46beab3b</p>
          </div>
        </div>
      </div>

      <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
        <div className="flex justify-between items-center">
          <h3 className="font-black text-base text-[#1e2923]">System Readiness Score</h3>
          <span className="font-black text-lg text-[#006837]">85% Ready</span>
        </div>
        <div className="w-full h-2.5 bg-[#f1f5f9] rounded-full overflow-hidden">
          <div className="h-full bg-[#006837]" style={{ width: '85%' }} />
        </div>
      </div>

      <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
        <h3 className="font-black text-lg text-[#1e2923]">Pre-Launch Verification Tasks</h3>

        <div className="space-y-3">
          {tasks.map((t) => (
            <div key={t.title} className="p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-center gap-3">
              {t.done ? (
                <CheckCircle2 className="w-5 h-5 text-[#006837] shrink-0" />
              ) : (
                <Circle className="w-5 h-5 text-[#64748b] shrink-0" />
              )}
              <span className={`text-xs ${t.done ? 'font-bold text-[#1e2923]' : 'text-[#64748b]'}`}>{t.title}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
