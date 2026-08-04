'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Wallet, Plus, ArrowUpRight, ArrowDownLeft, ShieldCheck, History } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

interface Transaction {
  id: string;
  title: string;
  date: string;
  amount: number;
  type: 'credit' | 'debit';
  status: string;
}

const transactions: Transaction[] = [
  {
    id: 't1',
    title: 'Order #ORD-9824 Paid',
    date: 'Today, 10:42 AM',
    amount: 249,
    type: 'debit',
    status: 'Completed',
  },
  {
    id: 't2',
    title: 'Cashback Added',
    date: 'Yesterday, 4:15 PM',
    amount: 50,
    type: 'credit',
    status: 'Credited',
  },
  {
    id: 't3',
    title: 'Wallet Top-up via UPI',
    date: '02 Aug 2026, 6:30 PM',
    amount: 500,
    type: 'credit',
    status: 'Completed',
  },
];

export default function WalletPage() {
  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl font-extrabold text-slate-900 font-outfit">
              Daily Basket Wallet
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-6">
        
        {/* Wallet Balance Hero Card */}
        <div className="bg-[#006b23] text-white rounded-3xl p-6 sm:p-8 shadow-lg relative overflow-hidden space-y-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2 text-white/80 text-sm font-semibold font-inter">
              <Wallet className="w-5 h-5" />
              <span>Available Balance</span>
            </div>
            <span className="text-xs bg-white/20 backdrop-blur-md text-white font-bold px-3 py-1 rounded-full uppercase tracking-wider">
              Active
            </span>
          </div>

          <div>
            <h2 className="text-4xl sm:text-5xl font-extrabold font-outfit tracking-tight">
              {formatCurrency(450)}
            </h2>
            <p className="text-xs text-white/80 font-inter mt-1">
              Use instantly at checkout for 1-click order placement
            </p>
          </div>

          <div className="flex gap-3 pt-2">
            <button className="flex-1 py-3 bg-white text-[#006b23] hover:bg-emerald-50 rounded-2xl font-bold text-sm font-outfit flex items-center justify-center gap-2 shadow-md transition">
              <Plus className="w-4 h-4 stroke-[3]" />
              <span>Add Money</span>
            </button>
          </div>
        </div>

        {/* Transaction History */}
        <div className="bg-white rounded-2xl p-6 border border-slate-100 shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-outfit font-bold text-base text-slate-900 flex items-center gap-2">
              <History className="w-5 h-5 text-[#006b23]" />
              <span>Transaction History</span>
            </h3>
          </div>

          <div className="space-y-3">
            {transactions.map((tx) => (
              <div
                key={tx.id}
                className="p-4 rounded-xl border border-slate-100 flex items-center justify-between gap-4 hover:bg-slate-50 transition"
              >
                <div className="flex items-center gap-3.5">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                    tx.type === 'credit' ? 'bg-emerald-100 text-[#006b23]' : 'bg-slate-100 text-slate-600'
                  }`}>
                    {tx.type === 'credit' ? (
                      <ArrowDownLeft className="w-5 h-5" />
                    ) : (
                      <ArrowUpRight className="w-5 h-5" />
                    )}
                  </div>

                  <div>
                    <h4 className="font-outfit font-semibold text-sm text-slate-900">
                      {tx.title}
                    </h4>
                    <p className="text-xs text-slate-400 font-inter mt-0.5">{tx.date}</p>
                  </div>
                </div>

                <div className="text-right">
                  <span className={`font-outfit font-bold text-base ${
                    tx.type === 'credit' ? 'text-[#006b23]' : 'text-slate-900'
                  }`}>
                    {tx.type === 'credit' ? '+' : '-'}{formatCurrency(tx.amount)}
                  </span>
                  <span className="block text-[10px] text-slate-400 font-medium font-inter mt-0.5">
                    {tx.status}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

      </main>
    </div>
  );
}
