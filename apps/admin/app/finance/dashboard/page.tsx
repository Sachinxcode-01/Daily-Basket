'use client';

import React, { useState } from 'react';
import {
  ArrowLeft,
  DollarSign,
  TrendingUp,
  Landmark,
  Sparkles,
  AlertTriangle,
  Receipt,
  ShoppingCart,
  FileText,
  ArrowDownLeft,
  ArrowUpRight,
  RefreshCw,
  Plus,
  LayoutGrid,
  Smartphone,
  Grid,
  ShoppingBag,
  Store,
  Wallet,
} from 'lucide-react';

// Google Stitch Specs: Finance Dashboard
// ID: bed36b1f6f634b1395586a035fd48e7d

export default function FinanceDashboardPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const financeData = {
    todaysRevenue: '₹45,230',
    revenueTrend: '📈 12%',
    netProfit: '₹12,840',
    aiGrowthOpportunity: 'Dairy category revenue is projected to increase by 15% this weekend.',
    aiLossAlert: 'High spoilage rate in leafy greens causing 4% revenue leak.',
    transactions: [
      {
        id: 'Order #4429',
        time: 'Today, 10:42 AM',
        amount: '+₹1,250',
        amountColor: 'text-[#15803d]',
        badgeText: 'Payment',
        icon: ArrowDownLeft,
        iconBg: 'bg-emerald-100 text-[#15803d]',
      },
      {
        id: 'Fresh Farm Suppliers',
        time: 'Today, 09:15 AM',
        amount: '-₹4,500',
        amountColor: 'text-[#1e2923]',
        badgeText: 'Payout',
        icon: ArrowUpRight,
        iconBg: 'bg-amber-100 text-[#c2410c]',
      },
      {
        id: 'Refund: Order #4410',
        time: 'Yesterday, 04:30 PM',
        amount: '-₹320',
        amountColor: 'text-[#dc2626]',
        badgeText: 'Refund',
        icon: RefreshCw,
        iconBg: 'bg-rose-100 text-[#dc2626]',
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Header Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div className="flex items-center gap-3">
          <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-[#006837] tracking-tight">Finance Dashboard</h1>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">Google Stitch Screen ID: bed36b1f6f634b1395586a035fd48e7d</p>
          </div>
        </div>

        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('web')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Web Dashboard</span>
          </button>
          <button
            onClick={() => setViewMode('mobile')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Mobile Stitch View</span>
          </button>
        </div>
      </div>

      {/* Main Content */}
      {viewMode === 'mobile' ? (
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <ArrowLeft className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <span className="font-extrabold text-base text-[#006837]">Finance Dashboard</span>
              <Receipt className="w-5 h-5 text-[#1e2923] cursor-pointer" />
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              {/* Metrics 2-Columns Strip */}
              <div className="grid grid-cols-2 gap-3">
                <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex justify-between items-center">
                    <div className="p-2 bg-[#006837] text-white rounded-full">
                      <DollarSign className="w-4 h-4" />
                    </div>
                    <span className="px-2 py-0.5 bg-emerald-100 text-[#15803d] text-[10px] font-bold rounded-md">
                      {financeData.revenueTrend}
                    </span>
                  </div>
                  <span className="text-[11px] text-[#64748b] block">Today&apos;s Revenue</span>
                  <p className="text-xl font-black text-[#1e2923]">{financeData.todaysRevenue}</p>
                </div>

                <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="p-2 bg-[#dce6fe] text-[#2563eb] rounded-full w-fit">
                    <Landmark className="w-4 h-4" />
                  </div>
                  <span className="text-[11px] text-[#64748b] block">Net Profit</span>
                  <p className="text-xl font-black text-[#1e2923]">{financeData.netProfit}</p>
                </div>
              </div>

              {/* AI Insights Card */}
              <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                <div className="flex items-center gap-2">
                  <Sparkles className="w-4 h-4 text-[#006837]" />
                  <h4 className="font-black text-sm text-[#1e2923]">AI Insights</h4>
                </div>

                <div className="p-3 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-start gap-2.5">
                  <TrendingUp className="w-4 h-4 text-[#15803d] shrink-0 mt-0.5" />
                  <div>
                    <h5 className="font-bold text-xs text-[#1e2923]">Growth Opportunity</h5>
                    <p className="text-[11px] text-[#64748b] mt-0.5">{financeData.aiGrowthOpportunity}</p>
                  </div>
                </div>

                <div className="p-3 bg-[#fef2f2] rounded-2xl border border-[#fee2e2] flex items-start gap-2.5">
                  <AlertTriangle className="w-4 h-4 text-[#dc2626] shrink-0 mt-0.5" />
                  <div>
                    <h5 className="font-bold text-xs text-[#dc2626]">Loss Alert: Perishables</h5>
                    <p className="text-[11px] text-[#991b1b] mt-0.5">{financeData.aiLossAlert}</p>
                  </div>
                </div>
              </div>

              {/* Quick Actions */}
              <div className="space-y-2.5">
                <h4 className="font-black text-sm text-[#1e2923] flex items-center gap-1.5">
                  ⚡ Quick Actions
                </h4>

                <div className="grid grid-cols-2 gap-2.5">
                  <button
                    onClick={() => setActiveModal('Approve Refund')}
                    className="p-3.5 bg-[#f1f5f9] rounded-2xl flex flex-col items-center gap-1.5 hover:bg-[#e2e8f0]"
                  >
                    <Receipt className="w-5 h-5 text-[#15803d]" />
                    <span className="text-xs font-bold text-[#1e2923]">Approve Refund</span>
                  </button>

                  <button
                    onClick={() => setActiveModal('Create Expense')}
                    className="p-3.5 bg-[#f1f5f9] rounded-2xl flex flex-col items-center gap-1.5 hover:bg-[#e2e8f0]"
                  >
                    <ShoppingCart className="w-5 h-5 text-[#0284c7]" />
                    <span className="text-xs font-bold text-[#1e2923]">Create Expense</span>
                  </button>
                </div>

                <button
                  onClick={() => setActiveModal('Generate GST Report')}
                  className="w-full p-3.5 bg-[#f1f5f9] rounded-2xl flex items-center justify-center gap-2 hover:bg-[#e2e8f0]"
                >
                  <FileText className="w-4 h-4 text-[#c2410c]" />
                  <span className="text-xs font-bold text-[#1e2923]">Generate GST Report</span>
                </button>
              </div>

              {/* Recent Transactions */}
              <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                <div className="flex justify-between items-center">
                  <h4 className="font-black text-sm text-[#1e2923]">Recent Transactions</h4>
                  <span className="text-xs font-bold text-[#006837] cursor-pointer">View All</span>
                </div>

                <div className="space-y-3">
                  {financeData.transactions.map((tx) => {
                    const IconComp = tx.icon;
                    return (
                      <div key={tx.id} className="flex justify-between items-center">
                        <div className="flex items-center gap-3">
                          <div className={`p-2.5 rounded-full ${tx.iconBg}`}>
                            <IconComp className="w-4 h-4" />
                          </div>
                          <div>
                            <p className="font-bold text-xs text-[#1e2923]">{tx.id}</p>
                            <p className="text-[10px] text-[#64748b]">{tx.time}</p>
                          </div>
                        </div>

                        <div className="text-right">
                          <p className={`font-black text-sm ${tx.amountColor}`}>{tx.amount}</p>
                          <span className="px-1.5 py-0.5 bg-[#f1f5f9] text-[9px] font-bold text-[#64748b] rounded">
                            {tx.badgeText}
                          </span>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              <button
                onClick={() => setActiveModal('New Transaction')}
                className="absolute bottom-4 right-4 w-12 h-12 bg-[#006837] text-white rounded-full flex items-center justify-center shadow-lg hover:bg-[#00522b]"
              >
                <Plus className="w-6 h-6" />
              </button>
            </div>

            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#006837] text-white rounded-2xl"><Wallet className="w-4 h-4" /> Finance</div>
              <div className="flex flex-col items-center gap-0.5"><Store className="w-4 h-4" /> Suppliers</div>
            </div>
          </div>
        </div>
      ) : (
        /* Web View */
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#64748b] font-bold uppercase">Today&apos;s Revenue</span>
              <p className="text-3xl font-black text-[#1e2923]">{financeData.todaysRevenue}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#2563eb] font-bold uppercase">Net Profit</span>
              <p className="text-3xl font-black text-[#1e2923]">{financeData.netProfit}</p>
            </div>
          </div>
        </div>
      )}

      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal}</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for Finance module.</p>
            <button
              onClick={() => setActiveModal(null)}
              className="w-full py-3 bg-[#006837] text-white font-bold text-xs rounded-2xl hover:bg-[#00522b]"
            >
              Close Modal
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
