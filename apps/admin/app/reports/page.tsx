'use client';

import React from 'react';
import { ArrowLeft, Download, BarChart2, Package, Truck, Receipt } from 'lucide-react';

// Google Stitch Specs: Reports & Analytics Center - Daily Basket Admin
// ID: 744f3887c5604ad183aca8a23d31dcb8

export default function ReportsCenterPage() {
  const reports = [
    { title: 'Sales & Revenue Summary', subtitle: 'Monthly revenue, order volume & AOV', icon: BarChart2 },
    { title: 'Inventory Spoilage Report', subtitle: 'Perishable wastage & stock loss ledger', icon: Package },
    { title: 'Delivery Partner Performance', subtitle: 'Rider SLA, rating & payout ledger', icon: Truck },
    { title: 'GST Tax Liability Statement', subtitle: 'Input tax credit & CGST/SGST breakdown', icon: Receipt },
  ];

  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="flex items-center justify-between bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837]">Reports &amp; Analytics Center</h1>
            <p className="text-xs text-[#64748b] mt-0.5">Google Stitch Screen ID: 744f3887c5604ad183aca8a23d31dcb8</p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
          <span className="text-xs font-bold text-[#64748b] uppercase">Gross Revenue</span>
          <p className="text-3xl font-black text-[#1e2923]">₹45.8L</p>
        </div>
        <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
          <span className="text-xs font-bold text-[#15803d] uppercase">Total Orders</span>
          <p className="text-3xl font-black text-[#15803d]">12,840</p>
        </div>
      </div>

      <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
        <h3 className="font-black text-lg text-[#1e2923]">Exportable Reports</h3>

        <div className="space-y-3">
          {reports.map((rep) => {
            const IconComp = rep.icon;
            return (
              <div key={rep.title} className="p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-3 bg-emerald-100 text-[#15803d] rounded-2xl">
                    <IconComp className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="font-bold text-sm text-[#1e2923]">{rep.title}</h4>
                    <p className="text-xs text-[#64748b]">{rep.subtitle}</p>
                  </div>
                </div>

                <button className="p-2.5 bg-[#006837] text-white rounded-xl hover:bg-[#00522b] transition">
                  <Download className="w-4 h-4" />
                </button>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
