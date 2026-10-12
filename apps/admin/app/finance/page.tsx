'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  TrendingUp,
  DollarSign,
  Download,
  CreditCard,
  Building,
  ArrowUpRight,
  ArrowDownLeft,
  Calendar,
  Filter,
  CheckCircle2,
  Clock,
  Sparkles,
  FileSpreadsheet,
} from 'lucide-react';
import Button from '../../components/ui/Button';
import Badge from '../../components/ui/Badge';

export default function FinanceOverviewPage() {
  const [selectedPeriod, setSelectedPeriod] = useState<'today' | 'week' | 'month'>('today');
  const [filterType, setFilterType] = useState<'all' | 'sales' | 'payouts' | 'refunds'>('all');

  const stats = {
    gmv: '₹1,84,920',
    netRevenue: '₹1,42,380',
    grossMarginPercent: '23.4%',
    pendingSettlement: '₹42,150',
    lastPayoutDate: 'Today, 06:00 AM',
  };

  const unitEconomics = [
    { label: 'COGS (Produce & FMCG)', amount: '₹1,18,340', pct: '64.0%', color: 'bg-zinc-800' },
    { label: 'Last-Mile Delivery Payouts', amount: '₹14,790', pct: '8.0%', color: 'bg-blue-600' },
    { label: 'Dark Store Overhead & Labor', amount: '₹9,240', pct: '5.0%', color: 'bg-amber-600' },
    { label: 'Gateway & Tech Fees', amount: '₹3,690', pct: '2.0%', color: 'bg-purple-600' },
    { label: 'Net Operating Profit', amount: '₹38,860', pct: '21.0%', color: 'bg-emerald-600' },
  ];

  const transactions = [
    {
      id: 'TXN-98129',
      source: 'Customer Order Pipeline',
      type: 'SALE',
      method: 'Razorpay UPI',
      time: '10 mins ago',
      amount: '₹840.00',
      status: 'SETTLED',
      badgeVariant: 'success' as const,
    },
    {
      id: 'TXN-98128',
      source: 'Mandi Vegetable Procurement #418',
      type: 'PAYOUT',
      method: 'NEFT Direct',
      time: '34 mins ago',
      amount: '-₹18,500.00',
      status: 'PROCESSING',
      badgeVariant: 'warning' as const,
    },
    {
      id: 'TXN-98127',
      source: 'Rider Batch Incentive #12',
      type: 'PAYOUT',
      method: 'Instant UPI',
      time: '1 hour ago',
      amount: '-₹3,400.00',
      status: 'SETTLED',
      badgeVariant: 'success' as const,
    },
    {
      id: 'TXN-98126',
      source: 'Customer Order Pipeline',
      type: 'SALE',
      method: 'Cash On Delivery',
      time: '1.5 hours ago',
      amount: '₹1,240.00',
      status: 'PENDING_RECON',
      badgeVariant: 'default' as const,
    },
    {
      id: 'TXN-98125',
      source: 'Damaged Produce Customer Return',
      type: 'REFUND',
      method: 'UPI Instant Refund',
      time: '2 hours ago',
      amount: '-₹180.00',
      status: 'REFUNDED',
      badgeVariant: 'danger' as const,
    },
  ];

  const filteredTxns = transactions.filter((t) => {
    if (filterType === 'sales') return t.type === 'SALE';
    if (filterType === 'payouts') return t.type === 'PAYOUT';
    if (filterType === 'refunds') return t.type === 'REFUND';
    return true;
  });

  return (
    <div className="space-y-8 animate-in fade-in duration-200">
      {/* Page Title & Quick Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <h1 className="text-2xl md:text-3xl font-extrabold tracking-tight text-zinc-950">
              Finance &amp; Treasury
            </h1>
            <Badge variant="mono" pulse>
              REAL-TIME RECON
            </Badge>
          </div>
          <p className="text-xs md:text-sm text-zinc-500">
            Automated GMV tracking, vendor mandi settlements, unit economics, and Razorpay reconciliations.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          {/* Period selector */}
          <div className="bg-zinc-100 p-1 rounded-xl flex items-center border border-zinc-200/80">
            {(['today', 'week', 'month'] as const).map((p) => (
              <button
                key={p}
                type="button"
                onClick={() => setSelectedPeriod(p)}
                className={`px-3 py-1.5 rounded-lg text-xs font-semibold uppercase tracking-wider transition ${
                  selectedPeriod === p
                    ? 'bg-white text-zinc-950 shadow-sm'
                    : 'text-zinc-500 hover:text-zinc-900'
                }`}
              >
                {p}
              </button>
            ))}
          </div>

          <Link href="/finance/dashboard">
            <Button variant="secondary" size="sm">
              Live Terminal
            </Button>
          </Link>

          <Button
            variant="brand"
            size="sm"
            leftIcon={<Download className="w-3.5 h-3.5" />}
            onClick={() => alert('Exporting audited fiscal reconciliation to Excel / Tally format.')}
          >
            Export Ledger
          </Button>
        </div>
      </div>

      {/* Top Metric Cards (Vercel Style) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Gross Merchandise Value (GMV)
            </span>
            <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center font-bold">
              <DollarSign className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            {stats.gmv}
          </div>
          <div className="flex items-center gap-1.5 text-xs text-emerald-700 font-semibold">
            <ArrowUpRight className="w-3.5 h-3.5" /> +16.8% vs last week
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Net Profit Margin
            </span>
            <div className="w-8 h-8 rounded-lg bg-zinc-100 text-zinc-800 flex items-center justify-center font-bold">
              <TrendingUp className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            {stats.grossMarginPercent}
          </div>
          <div className="text-xs text-zinc-500">
            ₹38,860 daily operational EBITDA
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Pending Settlement
            </span>
            <div className="w-8 h-8 rounded-lg bg-amber-50 text-amber-700 flex items-center justify-center font-bold">
              <Clock className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            {stats.pendingSettlement}
          </div>
          <div className="text-xs text-zinc-500">
            T+1 cycle • Next payout 02:00 PM
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-mono uppercase tracking-wider text-zinc-500">
              Gateway Reconciled
            </span>
            <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center font-bold">
              <CheckCircle2 className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-zinc-950 tracking-tight">
            99.8%
          </div>
          <div className="text-xs text-emerald-700 font-semibold">
            0 unresolved chargebacks
          </div>
        </div>
      </div>

      {/* Unit Economics Breakdown Card */}
      <div className="bg-white rounded-2xl p-6 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-base font-bold text-zinc-950">Unit Economics &amp; Cost Stack</h2>
            <p className="text-xs text-zinc-500">Cost allocation per ₹100 of gross basket order.</p>
          </div>
          <Badge variant="brand">Target EBITDA: &gt; 20%</Badge>
        </div>

        {/* Stacked bar visual */}
        <div className="h-4 rounded-full overflow-hidden flex bg-zinc-100 p-0.5 gap-0.5">
          {unitEconomics.map((item) => (
            <div
              key={item.label}
              style={{ width: item.pct }}
              className={`${item.color} rounded-sm transition-all`}
              title={`${item.label}: ${item.pct}`}
            />
          ))}
        </div>

        {/* Breakdown Legend Table */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3 pt-2">
          {unitEconomics.map((item) => (
            <div key={item.label} className="p-3 bg-zinc-50 rounded-xl border border-zinc-200/60 space-y-1">
              <div className="flex items-center gap-1.5">
                <span className={`w-2.5 h-2.5 rounded-full ${item.color}`} />
                <span className="text-[11px] font-medium text-zinc-600 truncate">{item.label}</span>
              </div>
              <div className="text-sm font-bold text-zinc-950">{item.amount}</div>
              <div className="text-[10px] text-zinc-400 font-mono">{item.pct} share</div>
            </div>
          ))}
        </div>
      </div>

      {/* Transaction & Settlement Ledger */}
      <div className="bg-white rounded-2xl p-6 border border-zinc-200/80 shadow-[0_1px_3px_rgba(0,0,0,0.03)] space-y-5">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <h2 className="text-base font-bold text-zinc-950">Settlement Ledger &amp; Audited Inflows</h2>
            <p className="text-xs text-zinc-500">Direct integration with dark store POS and online checkouts.</p>
          </div>

          <div className="flex items-center gap-2">
            {(['all', 'sales', 'payouts', 'refunds'] as const).map((t) => (
              <button
                key={t}
                type="button"
                onClick={() => setFilterType(t)}
                className={`px-3 py-1 rounded-lg text-xs font-semibold capitalize transition ${
                  filterType === t
                    ? 'bg-zinc-900 text-white'
                    : 'bg-zinc-100 text-zinc-600 hover:text-zinc-950'
                }`}
              >
                {t}
              </button>
            ))}
          </div>
        </div>

        {/* Ledger Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-zinc-200/80 text-zinc-500 font-mono uppercase text-[11px]">
                <th className="pb-3 font-semibold">Transaction ID</th>
                <th className="pb-3 font-semibold">Channel / Counterparty</th>
                <th className="pb-3 font-semibold">Method</th>
                <th className="pb-3 font-semibold">Time</th>
                <th className="pb-3 font-semibold text-right">Amount</th>
                <th className="pb-3 font-semibold text-right">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100">
              {filteredTxns.map((row) => (
                <tr key={row.id} className="hover:bg-zinc-50/80 transition-colors">
                  <td className="py-3.5 font-mono font-semibold text-zinc-950">
                    {row.id}
                  </td>
                  <td className="py-3.5 text-zinc-700 font-medium">
                    {row.source}
                  </td>
                  <td className="py-3.5 text-zinc-500 font-mono text-[11px]">
                    {row.method}
                  </td>
                  <td className="py-3.5 text-zinc-400">
                    {row.time}
                  </td>
                  <td
                    className={`py-3.5 text-right font-bold font-mono ${
                      row.amount.startsWith('-') ? 'text-zinc-900' : 'text-emerald-700'
                    }`}
                  >
                    {row.amount}
                  </td>
                  <td className="py-3.5 text-right">
                    <Badge variant={row.badgeVariant}>
                      {row.status}
                    </Badge>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
