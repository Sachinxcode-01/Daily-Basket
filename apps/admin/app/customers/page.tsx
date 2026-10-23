'use client';

import React, { useState, useMemo } from 'react';
import {
  ArrowLeft,
  MoreVertical,
  CheckCircle2,
  Phone,
  MessageSquare,
  Bell,
  IndianRupee,
  PlusCircle,
  ShoppingCart,
  Receipt,
  Wallet,
  TrendingUp,
  Bot,
  Tag,
  RefreshCw,
  Truck,
  Grid,
  ShoppingBag,
  Package,
  BarChart3,
  Smartphone,
  LayoutGrid,
  ShieldCheck,
  Search,
  Filter,
  Download,
  UserPlus,
  Users,
  Eye,
  AlertTriangle,
  Lock,
  Unlock,
  Check,
  XCircle,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
// Screen: Customer Profile (360° View) (ID: 3b8d81b5e2a4402290eddfb1c9e7b8e9)

export interface CustomerRecord {
  id: string;
  name: string;
  email: string;
  phone: string;
  joined: string;
  avatar: string;
  totalOrders: number;
  totalSpent: string;
  walletBalance: string;
  ltvScore: 'High' | 'Medium' | 'Low';
  churnRisk: string;
  churnRiskLevel: 'low' | 'med' | 'high';
  avgBasket: string;
  loyaltyTag: string;
  shopperTag: string;
  status: 'ACTIVE' | 'BLOCKED';
  affinityFresh: number;
  affinityDairy: number;
  affinitySnacks: number;
  recentOrders: {
    id: string;
    time: string;
    amount: string;
    status: string;
    statusColor: string;
    badgeBg: string;
    isActive: boolean;
  }[];
}

const CUSTOMERS_ROSTER: CustomerRecord[] = [
  {
    id: '#DB-CUS-782',
    name: 'Rahul Sharma',
    email: 'rahul.sharma@gmail.com',
    phone: '+91 98450 91823',
    joined: 'Joined Mar 2022',
    avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300',
    totalOrders: 142,
    totalSpent: '₹84,200',
    walletBalance: '₹1,240',
    ltvScore: 'High',
    churnRisk: 'Low (5%)',
    churnRiskLevel: 'low',
    avgBasket: '₹850',
    loyaltyTag: 'High Loyalty',
    shopperTag: 'Frequent Shopper',
    status: 'ACTIVE',
    affinityFresh: 70,
    affinityDairy: 50,
    affinitySnacks: 30,
    recentOrders: [
      {
        id: 'Order #ORD-8923',
        time: 'Today, 10:42 AM',
        amount: '₹1,240',
        status: 'Out for Delivery',
        statusColor: 'text-[#0284c7]',
        badgeBg: 'bg-sky-50',
        isActive: true,
      },
      {
        id: 'Order #ORD-8810',
        time: '2 days ago',
        amount: '₹850',
        status: 'Delivered',
        statusColor: 'text-[#15803d]',
        badgeBg: 'bg-emerald-50',
        isActive: false,
      },
    ],
  },
  {
    id: '#DB-CUS-783',
    name: 'Sneha Patel',
    email: 'sneha.patel@outlook.com',
    phone: '+91 98210 44556',
    joined: 'Joined Jun 2023',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    totalOrders: 89,
    totalSpent: '₹52,400',
    walletBalance: '₹850',
    ltvScore: 'High',
    churnRisk: 'Low (8%)',
    churnRiskLevel: 'low',
    avgBasket: '₹620',
    loyaltyTag: 'Gold Member',
    shopperTag: 'Daily Groceries',
    status: 'ACTIVE',
    affinityFresh: 85,
    affinityDairy: 60,
    affinitySnacks: 20,
    recentOrders: [
      {
        id: 'Order #ORD-8919',
        time: 'Yesterday, 6:15 PM',
        amount: '₹620',
        status: 'Delivered',
        statusColor: 'text-[#15803d]',
        badgeBg: 'bg-emerald-50',
        isActive: false,
      },
    ],
  },
  {
    id: '#DB-CUS-784',
    name: 'Amit Deshmukh',
    email: 'amit.deshmukh@yahoo.com',
    phone: '+91 97110 33221',
    joined: 'Joined Jan 2024',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
    totalOrders: 34,
    totalSpent: '₹18,900',
    walletBalance: '₹200',
    ltvScore: 'Medium',
    churnRisk: 'Medium (38%)',
    churnRiskLevel: 'med',
    avgBasket: '₹550',
    loyaltyTag: 'Regular',
    shopperTag: 'Weekend Shopper',
    status: 'ACTIVE',
    affinityFresh: 45,
    affinityDairy: 75,
    affinitySnacks: 65,
    recentOrders: [
      {
        id: 'Order #ORD-8750',
        time: '5 days ago',
        amount: '₹740',
        status: 'Delivered',
        statusColor: 'text-[#15803d]',
        badgeBg: 'bg-emerald-50',
        isActive: false,
      },
    ],
  },
  {
    id: '#DB-CUS-785',
    name: 'Ananya Krishnan',
    email: 'ananya.k@hotmail.com',
    phone: '+91 99001 98822',
    joined: 'Joined Aug 2022',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300',
    totalOrders: 112,
    totalSpent: '₹96,500',
    walletBalance: '₹3,400',
    ltvScore: 'High',
    churnRisk: 'Low (3%)',
    churnRiskLevel: 'low',
    avgBasket: '₹910',
    loyaltyTag: 'VIP Platinum',
    shopperTag: 'Organic Focused',
    status: 'ACTIVE',
    affinityFresh: 90,
    affinityDairy: 40,
    affinitySnacks: 15,
    recentOrders: [
      {
        id: 'Order #ORD-8930',
        time: 'Today, 2:10 PM',
        amount: '₹1,540',
        status: 'Packing in Dark Store',
        statusColor: 'text-[#ca8a04]',
        badgeBg: 'bg-amber-50',
        isActive: true,
      },
    ],
  },
  {
    id: '#DB-CUS-786',
    name: 'Pooja Mehta',
    email: 'pooja.mehta@gmail.com',
    phone: '+91 98440 22331',
    joined: 'Joined Feb 2023',
    avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300',
    totalOrders: 12,
    totalSpent: '₹6,400',
    walletBalance: '₹0',
    ltvScore: 'Low',
    churnRisk: 'High (74%)',
    churnRiskLevel: 'high',
    avgBasket: '₹480',
    loyaltyTag: 'At Risk',
    shopperTag: 'Dormant Shopper',
    status: 'ACTIVE',
    affinityFresh: 30,
    affinityDairy: 30,
    affinitySnacks: 80,
    recentOrders: [
      {
        id: 'Order #ORD-8400',
        time: '3 weeks ago',
        amount: '₹480',
        status: 'Delivered',
        statusColor: 'text-[#15803d]',
        badgeBg: 'bg-emerald-50',
        isActive: false,
      },
    ],
  },
  {
    id: '#DB-CUS-787',
    name: 'Vikram Singhania',
    email: 'vikram.singh@corp.in',
    phone: '+91 99880 77665',
    joined: 'Joined Dec 2023',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
    totalOrders: 6,
    totalSpent: '₹3,200',
    walletBalance: '₹0',
    ltvScore: 'Low',
    churnRisk: 'High (85%)',
    churnRiskLevel: 'high',
    avgBasket: '₹530',
    loyaltyTag: 'Flagged Account',
    shopperTag: 'Chargeback Dispute',
    status: 'BLOCKED',
    affinityFresh: 20,
    affinityDairy: 20,
    affinitySnacks: 60,
    recentOrders: [
      {
        id: 'Order #ORD-8100',
        time: '1 month ago',
        amount: '₹950',
        status: 'Refunded / Cancelled',
        statusColor: 'text-[#dc2626]',
        badgeBg: 'bg-rose-50',
        isActive: false,
      },
    ],
  },
];

export default function CustomerProfile360Page() {
  const [activeTab, setActiveTab] = useState<'directory' | '360'>('directory');
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [activeModal, setActiveModal] = useState<string | null>(null);
  const [customers, setCustomers] = useState<CustomerRecord[]>(CUSTOMERS_ROSTER);
  const [selectedCustomerId, setSelectedCustomerId] = useState<string>(CUSTOMERS_ROSTER[0].id);
  const [searchQuery, setSearchQuery] = useState('');
  const [segmentFilter, setSegmentFilter] = useState('ALL');
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Selected customer for 360 profile
  const customer = useMemo(() => {
    return customers.find((c) => c.id === selectedCustomerId) || customers[0];
  }, [customers, selectedCustomerId]);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  // Filtered customers
  const filteredCustomers = useMemo(() => {
    return customers.filter((c) => {
      const matchesSearch =
        c.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        c.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
        c.phone.includes(searchQuery) ||
        c.id.toLowerCase().includes(searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (segmentFilter === 'VIP') return c.ltvScore === 'High';
      if (segmentFilter === 'AT_RISK') return c.churnRiskLevel === 'high';
      if (segmentFilter === 'BLOCKED') return c.status === 'BLOCKED';
      if (segmentFilter === 'ACTIVE') return c.status === 'ACTIVE';

      return true;
    });
  }, [customers, searchQuery, segmentFilter]);

  // Toggle customer block status
  const handleToggleBlock = (custId: string) => {
    setCustomers((prev) =>
      prev.map((c) => {
        if (c.id === custId) {
          const next = c.status === 'ACTIVE' ? 'BLOCKED' : 'ACTIVE';
          showToast(`Customer ${c.name} account is now ${next}.`);
          return { ...c, status: next };
        }
        return c;
      })
    );
  };

  // Export CSV
  const handleExportCSV = () => {
    const headers = ['Customer ID,Name,Email,Phone,Joined,Total Orders,Total Spent,Wallet Balance,LTV Score,Churn Risk,Status'];
    const rows = filteredCustomers.map((c) =>
      `"${c.id}","${c.name}","${c.email}","${c.phone}","${c.joined}","${c.totalOrders}","${c.totalSpent}","${c.walletBalance}","${c.ltvScore}","${c.churnRisk}","${c.status}"`
    );
    const csvContent = 'data:text/csv;charset=utf-8,' + [headers, ...rows].join('\n');
    const link = document.createElement('a');
    link.setAttribute('href', encodeURI(csvContent));
    link.setAttribute('download', `daily_basket_customers_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    showToast('Customer directory exported.');
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-zinc-950 text-white px-4 py-3 rounded-2xl shadow-2xl flex items-center gap-3 border border-zinc-800 animate-in fade-in">
          <CheckCircle2 className="w-5 h-5 text-[#2d9d43] shrink-0" />
          <span className="text-xs font-semibold">{toastMessage}</span>
        </div>
      )}

      {/* Top Header & View Modes */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-xs">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-emerald-50 text-[#006837] flex items-center justify-center font-bold">
            <Users className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-2xl font-black text-[#006837] tracking-tight">Customer Management & 360°</h1>
              <span className="text-[10px] bg-emerald-100 text-[#006837] px-2 py-0.5 rounded font-mono font-bold">
                PROD
              </span>
            </div>
            <p className="text-xs text-[#64748b] mt-0.5 font-medium">
              Google Stitch ID: 3b8d81b5e2a4402290eddfb1c9e7b8e9 • Directory, LTV Intelligence & 360° CRM
            </p>
          </div>
        </div>

        {/* Tab Switcher: Directory vs 360 View */}
        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setActiveTab('directory')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              activeTab === 'directory'
                ? 'bg-[#006837] text-white shadow-xs'
                : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Users className="w-3.5 h-3.5" />
            <span>Customer Directory</span>
          </button>

          <button
            onClick={() => setActiveTab('360')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              activeTab === '360'
                ? 'bg-[#006837] text-white shadow-xs'
                : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Bot className="w-3.5 h-3.5" />
            <span>360° Profile & Stitch View</span>
          </button>
        </div>
      </div>

      {activeTab === 'directory' ? (
        /* CUSTOMER DIRECTORY VIEW */
        <div className="space-y-6">
          {/* Metrics 4-Grid */}
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
              <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Total Customers</span>
              <div className="text-2xl font-black text-zinc-950 mt-1">18,420</div>
              <div className="text-[11px] text-emerald-600 font-bold mt-0.5">+14.2% MoM growth</div>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
              <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Active Shoppers</span>
              <div className="text-2xl font-black text-zinc-950 mt-1">1,842 Today</div>
              <div className="text-[11px] text-zinc-500 mt-0.5">Average 4.2 orders/month</div>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
              <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Average LTV</span>
              <div className="text-2xl font-black text-[#006837] mt-1">₹42,800</div>
              <div className="text-[11px] text-emerald-600 font-bold mt-0.5">₹850 avg basket size</div>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
              <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Retention Rate</span>
              <div className="text-2xl font-black text-zinc-950 mt-1">94.2%</div>
              <div className="text-[11px] text-zinc-500 mt-0.5">Ultrafast Kirana Loyalty</div>
            </div>
          </div>

          {/* Search, Filter & Actions Bar */}
          <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs flex flex-col md:flex-row gap-3 items-center justify-between">
            <div className="flex flex-1 gap-3 w-full">
              <div className="relative flex-1">
                <Search className="w-4 h-4 text-zinc-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  placeholder="Search customer by name, mobile phone, email, or ID..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-10 pr-4 py-2 bg-zinc-50/80 border border-zinc-200 rounded-xl text-xs text-zinc-900 focus:outline-hidden focus:ring-2 focus:ring-[#006837] focus:bg-white"
                />
              </div>

              <select
                value={segmentFilter}
                onChange={(e) => setSegmentFilter(e.target.value)}
                className="px-3 py-2 bg-zinc-50/80 border border-zinc-200 rounded-xl text-xs text-zinc-700 font-medium focus:outline-hidden focus:ring-2 focus:ring-[#006837]"
              >
                <option value="ALL">All Segments</option>
                <option value="VIP">VIP & High LTV</option>
                <option value="ACTIVE">Active Accounts</option>
                <option value="AT_RISK">High Churn Risk</option>
                <option value="BLOCKED">Blocked Customers</option>
              </select>
            </div>

            <div className="flex items-center gap-2 self-end md:self-auto">
              <button
                onClick={handleExportCSV}
                className="flex items-center gap-1.5 px-3 py-2 border border-zinc-200 rounded-xl text-xs font-semibold text-zinc-700 hover:bg-zinc-50"
              >
                <Download className="w-3.5 h-3.5" />
                <span>Export</span>
              </button>
            </div>
          </div>

          {/* Customer Table */}
          <div className="bg-white rounded-3xl border border-zinc-200/90 shadow-xs overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-zinc-50/90 border-b border-zinc-200/80 text-[11px] font-bold uppercase tracking-wider text-zinc-500 font-mono">
                    <th className="py-3 px-4">Customer Details</th>
                    <th className="py-3 px-4">Loyalty Segment</th>
                    <th className="py-3 px-4">Total Orders</th>
                    <th className="py-3 px-4">Lifetime Spend</th>
                    <th className="py-3 px-4">Wallet Balance</th>
                    <th className="py-3 px-4">Churn Risk</th>
                    <th className="py-3 px-4">Status</th>
                    <th className="py-3 px-4 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-200/70 text-xs">
                  {filteredCustomers.map((c) => (
                    <tr key={c.id} className="hover:bg-zinc-50/60 transition group">
                      <td className="py-3.5 px-4">
                        <div className="flex items-center gap-3">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img
                            src={c.avatar}
                            alt={c.name}
                            className="w-9 h-9 rounded-xl object-cover shrink-0 shadow-2xs"
                          />
                          <div>
                            <div className="font-bold text-zinc-950 flex items-center gap-1.5">
                              <span>{c.name}</span>
                              <span className="text-[10px] text-zinc-400 font-mono font-normal">({c.id})</span>
                            </div>
                            <div className="text-[11px] text-zinc-500 flex items-center gap-2 mt-0.5">
                              <span>{c.phone}</span>
                              <span>•</span>
                              <span>{c.email}</span>
                            </div>
                          </div>
                        </div>
                      </td>

                      <td className="py-3.5 px-4">
                        <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-[#dcfce7] text-[#15803d]">
                          {c.loyaltyTag}
                        </span>
                      </td>

                      <td className="py-3.5 px-4 font-bold text-zinc-900">{c.totalOrders} orders</td>

                      <td className="py-3.5 px-4 font-black text-[#006837]">{c.totalSpent}</td>

                      <td className="py-3.5 px-4 font-semibold text-zinc-800">{c.walletBalance}</td>

                      <td className="py-3.5 px-4">
                        <span
                          className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                            c.churnRiskLevel === 'low'
                              ? 'bg-emerald-50 text-emerald-800'
                              : c.churnRiskLevel === 'med'
                              ? 'bg-amber-50 text-amber-800'
                              : 'bg-rose-50 text-rose-800'
                          }`}
                        >
                          {c.churnRisk}
                        </span>
                      </td>

                      <td className="py-3.5 px-4">
                        {c.status === 'ACTIVE' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-bold">
                            <span className="w-1.5 h-1.5 rounded-full bg-emerald-600" />
                            Active
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-rose-100 text-rose-800 text-[10px] font-bold">
                            <span className="w-1.5 h-1.5 rounded-full bg-rose-600" />
                            Blocked
                          </span>
                        )}
                      </td>

                      <td className="py-3.5 px-4 text-right">
                        <div className="flex items-center justify-end gap-1.5">
                          <button
                            onClick={() => {
                              setSelectedCustomerId(c.id);
                              setActiveTab('360');
                            }}
                            className="flex items-center gap-1 px-2.5 py-1 bg-emerald-50 hover:bg-emerald-100 text-[#006837] rounded-lg text-xs font-bold transition"
                            title="Open 360 Profile"
                          >
                            <Eye className="w-3.5 h-3.5" />
                            <span>360° View</span>
                          </button>

                          <button
                            onClick={() => handleToggleBlock(c.id)}
                            className="p-1.5 text-zinc-400 hover:text-zinc-800 hover:bg-zinc-100 rounded-lg transition"
                            title={c.status === 'ACTIVE' ? 'Block Customer' : 'Unblock Customer'}
                          >
                            {c.status === 'ACTIVE' ? <Lock className="w-3.5 h-3.5" /> : <Unlock className="w-3.5 h-3.5 text-emerald-600" />}
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      ) : (
        /* CUSTOMER 360° PROFILE VIEW (STITCH SPEC 3b8d81b5e2a4402290eddfb1c9e7b8e9) */
        <div className="space-y-6">
          {/* Customer Selector & View Switcher */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white p-4 rounded-2xl border border-zinc-200">
            <div className="flex items-center gap-2">
              <span className="text-xs font-bold text-zinc-500 uppercase font-mono">Viewing Profile:</span>
              <select
                value={selectedCustomerId}
                onChange={(e) => setSelectedCustomerId(e.target.value)}
                className="px-3 py-1.5 bg-zinc-50 border border-zinc-200 rounded-xl text-xs font-bold text-[#006837] focus:ring-2 focus:ring-[#006837]"
              >
                {customers.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name} ({c.id}) - {c.loyaltyTag}
                  </option>
                ))}
              </select>
            </div>

            <div className="flex items-center gap-2 bg-[#f1f5f9] p-1 rounded-xl">
              <button
                onClick={() => setViewMode('web')}
                className={`flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold transition ${
                  viewMode === 'web' ? 'bg-[#006837] text-white shadow-xs' : 'text-[#64748b] hover:text-[#1e2923]'
                }`}
              >
                <LayoutGrid className="w-3.5 h-3.5" />
                <span>Web Dashboard</span>
              </button>
              <button
                onClick={() => setViewMode('mobile')}
                className={`flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold transition ${
                  viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-xs' : 'text-[#64748b] hover:text-[#1e2923]'
                }`}
              >
                <Smartphone className="w-3.5 h-3.5" />
                <span>Mobile Stitch View</span>
              </button>
            </div>
          </div>

          {/* Main Content Area */}
          {viewMode === 'mobile' ? (
            /* Mobile Device Frame View simulating exact phone screen */
            <div className="flex justify-center py-6">
              <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
                {/* Phone Top Notch */}
                <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
                  <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
                </div>

                {/* Mobile App Bar */}
                <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
                  <ArrowLeft
                    onClick={() => setActiveTab('directory')}
                    className="w-5 h-5 text-[#1e2923] cursor-pointer"
                  />
                  <span className="font-extrabold text-base text-[#006837]">Customer Profile</span>
                  <MoreVertical className="w-5 h-5 text-[#1e2923] cursor-pointer" />
                </div>

                {/* Scrollable Body */}
                <div className="flex-1 overflow-y-auto p-4 space-y-4">
                  {/* Identity Header Card */}
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm text-center space-y-3">
                    <div className="relative inline-block mx-auto">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img
                        src={customer.avatar}
                        alt={customer.name}
                        className="w-20 h-20 rounded-2xl object-cover"
                      />
                      <div className="absolute bottom-0 right-0 p-0.5 bg-white rounded-full">
                        <div className="p-0.5 bg-emerald-600 rounded-full text-white">
                          <CheckCircle2 className="w-3.5 h-3.5" />
                        </div>
                      </div>
                    </div>

                    <div>
                      <h2 className="text-xl font-black text-[#1e2923]">{customer.name}</h2>
                      <p className="text-xs text-[#64748b]">
                        ID: {customer.id} • {customer.joined}
                      </p>
                    </div>

                    <div className="flex justify-center gap-2">
                      <span className="px-3.5 py-1 bg-[#dcfce7] text-[#15803d] text-xs font-bold rounded-full">
                        {customer.loyaltyTag}
                      </span>
                      <span className="px-3.5 py-1 bg-[#dce6fe] text-[#2563eb] text-xs font-bold rounded-full">
                        Verified
                      </span>
                    </div>
                  </div>

                  {/* Quick Actions Strip */}
                  <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                    {[
                      { icon: Phone, label: 'Call' },
                      { icon: MessageSquare, label: 'Chat' },
                      { icon: Bell, label: 'Notify' },
                      { icon: IndianRupee, label: 'Refund' },
                      { icon: PlusCircle, label: 'Credit' },
                    ].map((act) => (
                      <button
                        key={act.label}
                        onClick={() => setActiveModal(act.label)}
                        className="min-w-[68px] bg-white border border-[#e2e8f0] py-3 rounded-2xl flex flex-col items-center gap-1 shadow-sm hover:bg-[#f8fafc]"
                      >
                        <act.icon className="w-4 h-4 text-[#006837]" />
                        <span className="text-[11px] font-bold text-[#1e2923]">{act.label}</span>
                      </button>
                    ))}
                  </div>

                  {/* Metrics 2x2 Grid */}
                  <div className="grid grid-cols-2 gap-3">
                    <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                      <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                        <ShoppingCart className="w-4 h-4" /> Total Orders
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{customer.totalOrders}</p>
                    </div>

                    <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                      <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                        <Receipt className="w-4 h-4" /> Total Spent
                      </div>
                      <p className="text-2xl font-black text-[#006837]">{customer.totalSpent}</p>
                    </div>

                    <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                      <div className="flex items-center gap-1.5 text-[#64748b] text-xs">
                        <Wallet className="w-4 h-4" /> Wallet
                      </div>
                      <p className="text-2xl font-black text-[#1e2923]">{customer.walletBalance}</p>
                    </div>

                    <div className="bg-[#e6f4ea] p-4 rounded-3xl border border-[#a7f3d0] shadow-sm space-y-1">
                      <div className="flex items-center gap-1.5 text-[#047857] text-xs font-bold">
                        <TrendingUp className="w-4 h-4" /> LTV Score
                      </div>
                      <p className="text-2xl font-black text-[#006837]">{customer.ltvScore}</p>
                    </div>
                  </div>

                  {/* AI Insights Card */}
                  <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                    <div className="flex items-center gap-2">
                      <Bot className="w-5 h-5 text-[#006837]" />
                      <h4 className="font-black text-base text-[#1e2923]">AI Insights</h4>
                    </div>

                    <div className="flex gap-2">
                      <span className="px-3 py-1 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1">
                        <Tag className="w-3.5 h-3.5" /> {customer.loyaltyTag}
                      </span>
                      <span className="px-3 py-1 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1">
                        <RefreshCw className="w-3.5 h-3.5" /> {customer.shopperTag}
                      </span>
                    </div>

                    <div className="space-y-2 text-xs pt-1">
                      <div className="flex justify-between items-center">
                        <span className="text-[#64748b]">Churn Risk</span>
                        <span className="px-2.5 py-0.5 bg-[#dcfce7] text-[#15803d] font-bold rounded-md">
                          {customer.churnRisk}
                        </span>
                      </div>
                      <div className="w-full h-[1px] bg-[#f1f5f9]" />
                      <div className="flex justify-between items-center">
                        <span className="text-[#64748b]">Avg. Basket</span>
                        <span className="font-black text-sm text-[#1e2923]">{customer.avgBasket}</span>
                      </div>
                    </div>

                    {/* Category Affinity Bars */}
                    <div className="space-y-2 pt-2">
                      <h5 className="font-bold text-xs text-[#1e2923]">Category Affinity</h5>
                      <div className="space-y-1.5 text-[11px]">
                        <div className="flex items-center gap-2">
                          <span className="w-12 text-[#64748b]">Fresh</span>
                          <div className="flex-1 h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                            <div className="h-full bg-[#006837]" style={{ width: `${customer.affinityFresh}%` }} />
                          </div>
                        </div>
                        <div className="flex items-center gap-2">
                          <span className="w-12 text-[#64748b]">Dairy</span>
                          <div className="flex-1 h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                            <div className="h-full bg-[#475569]" style={{ width: `${customer.affinityDairy}%` }} />
                          </div>
                        </div>
                        <div className="flex items-center gap-2">
                          <span className="w-12 text-[#64748b]">Snacks</span>
                          <div className="flex-1 h-2 bg-[#f1f5f9] rounded-full overflow-hidden">
                            <div className="h-full bg-[#9f1239]" style={{ width: `${customer.affinitySnacks}%` }} />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Recent Orders Timeline */}
                  <div className="bg-white p-4 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-3">
                    <div className="flex items-center justify-between">
                      <h4 className="font-black text-base text-[#1e2923]">Recent Orders</h4>
                      <button className="text-xs font-bold text-[#006837]">View All</button>
                    </div>

                    <div className="space-y-3 text-xs">
                      {customer.recentOrders.map((ord) => (
                        <div key={ord.id} className="flex gap-3 items-start">
                          <span
                            className={`w-2.5 h-2.5 rounded-full mt-1 shrink-0 ${
                              ord.isActive ? 'bg-[#006837]' : 'bg-[#cbd5e1]'
                            }`}
                          />
                          <div className="flex-1 space-y-0.5">
                            <div className="flex justify-between items-center">
                              <span className="font-bold text-[#1e2923]">{ord.id}</span>
                              <span className="font-black text-[#1e2923]">{ord.amount}</span>
                            </div>
                            <p className="text-[11px] text-[#64748b]">{ord.time}</p>
                            <div className={`font-bold flex items-center gap-1 ${ord.statusColor}`}>
                              {ord.isActive ? <Truck className="w-3.5 h-3.5" /> : <CheckCircle2 className="w-3.5 h-3.5" />}
                              <span>{ord.status}</span>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>

                {/* Bottom Nav Bar */}
                <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
                  <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#dce6fe] text-[#1e2923] rounded-2xl"><Grid className="w-4 h-4 text-[#006837]" /> Dashboard</div>
                  <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
                  <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
                  <div className="flex flex-col items-center gap-0.5"><Tag className="w-4 h-4" /> Products</div>
                  <div className="flex flex-col items-center gap-0.5"><BarChart3 className="w-4 h-4" /> Analytics</div>
                </div>
              </div>
            </div>
          ) : (
            /* Web Dashboard View */
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              {/* Left Column: Identity & Metrics (Span 5) */}
              <div className="lg:col-span-5 space-y-6">
                {/* Identity Card */}
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm text-center space-y-4">
                  <div className="relative inline-block mx-auto">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img
                      src={customer.avatar}
                      alt={customer.name}
                      className="w-24 h-24 rounded-3xl object-cover"
                    />
                    <div className="absolute bottom-0 right-0 p-1 bg-white rounded-full">
                      <div className="p-1 bg-emerald-600 rounded-full text-white">
                        <CheckCircle2 className="w-4 h-4" />
                      </div>
                    </div>
                  </div>

                  <div>
                    <h2 className="text-2xl font-black text-[#1e2923]">{customer.name}</h2>
                    <p className="text-xs text-[#64748b] mt-1">
                      ID: {customer.id} • {customer.joined}
                    </p>
                  </div>

                  <div className="flex justify-center gap-3">
                    <span className="px-4 py-1.5 bg-[#dcfce7] text-[#15803d] text-xs font-bold rounded-full flex items-center gap-1">
                      <ShieldCheck className="w-4 h-4" /> {customer.loyaltyTag}
                    </span>
                    <span className="px-4 py-1.5 bg-[#dce6fe] text-[#2563eb] text-xs font-bold rounded-full">
                      Verified
                    </span>
                  </div>

                  {/* Quick Action Buttons Bar */}
                  <div className="pt-2 grid grid-cols-5 gap-2 text-xs">
                    {[
                      { icon: Phone, label: 'Call' },
                      { icon: MessageSquare, label: 'Chat' },
                      { icon: Bell, label: 'Notify' },
                      { icon: IndianRupee, label: 'Refund' },
                      { icon: PlusCircle, label: 'Credit' },
                    ].map((act) => (
                      <button
                        key={act.label}
                        onClick={() => setActiveModal(act.label)}
                        className="bg-[#f8fafc] border border-[#e2e8f0] py-3 rounded-2xl flex flex-col items-center gap-1 shadow-sm hover:bg-white hover:border-[#006837] transition"
                      >
                        <act.icon className="w-4 h-4 text-[#006837]" />
                        <span className="text-[11px] font-bold text-[#1e2923]">{act.label}</span>
                      </button>
                    ))}
                  </div>
                </div>

                {/* Metrics 2x2 Grid */}
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                    <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                      <ShoppingCart className="w-4 h-4" /> Total Orders
                    </div>
                    <p className="text-3xl font-black text-[#1e2923] mt-2">{customer.totalOrders}</p>
                  </div>

                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                    <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                      <Receipt className="w-4 h-4" /> Total Spent
                    </div>
                    <p className="text-3xl font-black text-[#006837] mt-2">{customer.totalSpent}</p>
                  </div>

                  <div className="bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-1">
                    <div className="flex items-center gap-1.5 text-[#64748b] text-xs font-bold">
                      <Wallet className="w-4 h-4" /> Wallet Balance
                    </div>
                    <p className="text-3xl font-black text-[#1e2923] mt-2">{customer.walletBalance}</p>
                  </div>

                  <div className="bg-[#e6f4ea] p-5 rounded-3xl border border-[#a7f3d0] shadow-sm space-y-1">
                    <div className="flex items-center gap-1.5 text-[#047857] text-xs font-bold">
                      <TrendingUp className="w-4 h-4" /> LTV Score
                    </div>
                    <p className="text-3xl font-black text-[#006837] mt-2">{customer.ltvScore}</p>
                  </div>
                </div>
              </div>

              {/* Right Column: AI Insights & Recent Orders (Span 7) */}
              <div className="lg:col-span-7 space-y-6">
                {/* AI Insights Card */}
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-5">
                  <div className="flex items-center gap-2">
                    <Bot className="w-6 h-6 text-[#006837]" />
                    <h3 className="font-black text-lg text-[#1e2923]">AI Insights & Behavior Analysis</h3>
                  </div>

                  <div className="flex gap-3">
                    <span className="px-4 py-1.5 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1.5">
                      <Tag className="w-4 h-4" /> {customer.loyaltyTag}
                    </span>
                    <span className="px-4 py-1.5 bg-[#f1f5f9] text-[#334155] text-xs font-bold rounded-full flex items-center gap-1.5">
                      <RefreshCw className="w-4 h-4" /> {customer.shopperTag}
                    </span>
                  </div>

                  <div className="grid grid-cols-2 gap-4 text-xs">
                    <div className="bg-[#f8fafc] p-4 rounded-2xl space-y-1">
                      <span className="text-[#64748b]">Predicted Churn Risk</span>
                      <p className="text-base font-black text-[#15803d]">{customer.churnRisk}</p>
                    </div>
                    <div className="bg-[#f8fafc] p-4 rounded-2xl space-y-1">
                      <span className="text-[#64748b]">Average Basket Size</span>
                      <p className="text-base font-black text-[#1e2923]">{customer.avgBasket}</p>
                    </div>
                  </div>

                  {/* Category Affinity Bars */}
                  <div className="space-y-3 pt-2">
                    <h4 className="font-bold text-sm text-[#1e2923]">Category Affinity Index</h4>
                    <div className="space-y-2.5 text-xs">
                      <div className="flex items-center gap-3">
                        <span className="w-16 font-bold text-[#64748b]">Fresh</span>
                        <div className="flex-1 h-3 bg-[#f1f5f9] rounded-full overflow-hidden">
                          <div className="h-full bg-[#006837]" style={{ width: `${customer.affinityFresh}%` }} />
                        </div>
                        <span className="w-10 text-right font-bold text-[#1e2923]">{customer.affinityFresh}%</span>
                      </div>

                      <div className="flex items-center gap-3">
                        <span className="w-16 font-bold text-[#64748b]">Dairy</span>
                        <div className="flex-1 h-3 bg-[#f1f5f9] rounded-full overflow-hidden">
                          <div className="h-full bg-[#475569]" style={{ width: `${customer.affinityDairy}%` }} />
                        </div>
                        <span className="w-10 text-right font-bold text-[#1e2923]">{customer.affinityDairy}%</span>
                      </div>

                      <div className="flex items-center gap-3">
                        <span className="w-16 font-bold text-[#64748b]">Snacks</span>
                        <div className="flex-1 h-3 bg-[#f1f5f9] rounded-full overflow-hidden">
                          <div className="h-full bg-[#9f1239]" style={{ width: `${customer.affinitySnacks}%` }} />
                        </div>
                        <span className="w-10 text-right font-bold text-[#1e2923]">{customer.affinitySnacks}%</span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Recent Orders Timeline */}
                <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
                  <div className="flex items-center justify-between">
                    <h3 className="font-black text-lg text-[#1e2923]">Recent Orders</h3>
                    <button className="text-xs font-bold text-[#006837] hover:underline">View All Orders</button>
                  </div>

                  <div className="space-y-4 text-xs">
                    {customer.recentOrders.map((ord) => (
                      <div key={ord.id} className="p-4 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex items-center justify-between">
                        <div className="flex items-center gap-3">
                          <span
                            className={`w-3 h-3 rounded-full ${
                              ord.isActive ? 'bg-[#006837]' : 'bg-[#cbd5e1]'
                            }`}
                          />
                          <div>
                            <p className="font-extrabold text-sm text-[#1e2923]">{ord.id}</p>
                            <p className="text-xs text-[#64748b]">{ord.time}</p>
                          </div>
                        </div>

                        <div className="text-right">
                          <p className="font-black text-base text-[#1e2923]">{ord.amount}</p>
                          <p className={`font-bold text-xs flex items-center justify-end gap-1 ${ord.statusColor}`}>
                            {ord.isActive ? <Truck className="w-3.5 h-3.5" /> : <CheckCircle2 className="w-3.5 h-3.5" />}
                            <span>{ord.status}</span>
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Action Workflow Modals */}
      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal} Customer Workflow</h3>
            <p className="text-xs text-[#64748b]">
              Executing action &quot;{activeModal}&quot; for customer {customer.name} ({customer.id}).
            </p>
            <button
              onClick={() => {
                showToast(`Action "${activeModal}" dispatched for ${customer.name}`);
                setActiveModal(null);
              }}
              className="w-full py-3 bg-[#006837] text-white font-bold text-xs rounded-2xl hover:bg-[#00522b] transition"
            >
              Confirm & Dispatch
            </button>
            <button
              onClick={() => setActiveModal(null)}
              className="w-full py-2 bg-zinc-100 text-zinc-700 font-bold text-xs rounded-2xl hover:bg-zinc-200 transition"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
