// Google Stitch Screen ID: 21b0d1cd8c694caf86f64df52d3f99c2
// Title: Customer Profile Dashboard - Daily Basket
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { User, MapPin, CreditCard, ShoppingBag, Award, ArrowLeft, Zap, ChevronRight } from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';
import { useCurrentUserId } from '../../store/useCart';
import { useAuthStore } from '../../store/useAuthStore';

export default function CustomerProfileDashboardPage() {
  const [activeTab, setActiveTab] = useState<'profile' | 'orders' | 'addresses' | 'wallet'>('profile');
  const userId = useCurrentUserId();
  const { user: authUser, isAuthenticated } = useAuthStore();

  const { data: ordersData, isLoading: ordersLoading } = useQuery({
    queryKey: ['orders', userId],
    queryFn: () => apiClient.listOrders(userId),
  });
  const orders: any[] = Array.isArray(ordersData) ? ordersData : [];

  const { data: addressesData } = useQuery({
    queryKey: ['addresses', userId],
    queryFn: () => apiClient.getAddresses(userId),
  });
  const addresses: any[] = Array.isArray(addressesData) ? addressesData : [];

  const au: any = authUser || {};
  const user = {
    name: au.name || au.fullName || 'Guest Shopper',
    email: au.email || '—',
    phone: au.phone || au.phoneNumber || '—',
    loyaltyPoints: 0,
    walletBalance: 0,
  };

  return (
    <div className="min-h-screen bg-[#F9F9FC] text-[#1A1C1E] flex flex-col">
      <HeaderNavBar />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 py-8">
        <Link href="/" className="inline-flex items-center gap-2 text-sm text-[#006B23] font-medium hover:underline mb-6">
          <ArrowLeft className="w-4 h-4" />
          <span>Back to Home</span>
        </Link>

        {!isAuthenticated && (
          <div className="mb-6 p-4 rounded-2xl bg-emerald-50 border border-emerald-100 flex items-center justify-between gap-4">
            <p className="text-sm text-[#006B23] font-medium">Sign in to view your saved details, orders and addresses.</p>
            <Link href="/login" className="text-sm font-bold text-white bg-[#006B23] hover:bg-[#00531a] px-5 py-2.5 rounded-full whitespace-nowrap transition">
              Login
            </Link>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Left Column: Sidebar & Profile Badge */}
          <div className="lg:col-span-1 space-y-6">
            <div className="bg-white rounded-3xl p-6 border border-gray-100 shadow-xl text-center">
              <div className="w-24 h-24 bg-gradient-to-tr from-[#006B23] to-[#078730] text-white rounded-full flex items-center justify-center text-3xl font-extrabold font-outfit mx-auto mb-4 shadow-lg">
                {user.name.split(' ').map((n) => n[0]).join('')}
              </div>
              <h2 className="text-xl font-bold font-outfit text-gray-900">{user.name}</h2>
              <p className="text-xs text-gray-500 mb-4">{user.email}</p>

              <div className="inline-flex items-center gap-1.5 bg-[#8CFA93] text-[#006B23] text-xs font-black px-3 py-1.5 rounded-full">
                <Zap className="w-3.5 h-3.5 fill-current" />
                <span>PLATINUM VIP MEMBER</span>
              </div>
            </div>

            {/* Navigation Tabs */}
            <div className="bg-white rounded-3xl p-3 border border-gray-100 shadow-xl space-y-1">
              <button
                onClick={() => setActiveTab('profile')}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold transition ${
                  activeTab === 'profile'
                    ? 'bg-emerald-50 text-[#006B23]'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <User className="w-4 h-4" />
                <span>Personal Details</span>
              </button>
              <button
                onClick={() => setActiveTab('orders')}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold transition ${
                  activeTab === 'orders'
                    ? 'bg-emerald-50 text-[#006B23]'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <ShoppingBag className="w-4 h-4" />
                <span>Order History</span>
              </button>
              <button
                onClick={() => setActiveTab('addresses')}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold transition ${
                  activeTab === 'addresses'
                    ? 'bg-emerald-50 text-[#006B23]'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <MapPin className="w-4 h-4" />
                <span>Saved Addresses</span>
              </button>
              <button
                onClick={() => setActiveTab('wallet')}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold transition ${
                  activeTab === 'wallet'
                    ? 'bg-emerald-50 text-[#006B23]'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <CreditCard className="w-4 h-4" />
                <span>Wallet & Pass</span>
              </button>
            </div>
          </div>

          {/* Right Column: Main Content Area */}
          <div className="lg:col-span-3 space-y-6">
            {activeTab === 'profile' && (
              <div className="bg-white rounded-3xl p-8 border border-gray-100 shadow-xl space-y-6">
                <h3 className="text-xl font-bold font-outfit text-gray-900 border-b border-gray-100 pb-4">
                  Account Details
                </h3>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="text-xs font-semibold text-gray-400 block mb-1">Full Name</label>
                    <div className="p-3.5 rounded-xl bg-gray-50 text-sm font-medium text-gray-900 border border-gray-100">
                      {user.name}
                    </div>
                  </div>
                  <div>
                    <label className="text-xs font-semibold text-gray-400 block mb-1">Email Address</label>
                    <div className="p-3.5 rounded-xl bg-gray-50 text-sm font-medium text-gray-900 border border-gray-100">
                      {user.email}
                    </div>
                  </div>
                  <div>
                    <label className="text-xs font-semibold text-gray-400 block mb-1">Phone Number</label>
                    <div className="p-3.5 rounded-xl bg-gray-50 text-sm font-medium text-gray-900 border border-gray-100">
                      {user.phone}
                    </div>
                  </div>
                  <div>
                    <label className="text-xs font-semibold text-gray-400 block mb-1">Loyalty Rewards Balance</label>
                    <div className="p-3.5 rounded-xl bg-emerald-50 text-sm font-bold text-[#006B23] border border-emerald-100 flex items-center justify-between">
                      <span>{user.loyaltyPoints} Points</span>
                      <Award className="w-4 h-4" />
                    </div>
                  </div>
                </div>
              </div>
            )}

            {activeTab === 'orders' && (
              <div className="bg-white rounded-3xl p-8 border border-gray-100 shadow-xl space-y-6">
                <h3 className="text-xl font-bold font-outfit text-gray-900 border-b border-gray-100 pb-4">
                  Recent Orders
                </h3>
                {ordersLoading ? (
                  <div className="space-y-3">
                    {[0, 1, 2].map((i) => (
                      <div key={i} className="p-5 rounded-2xl border border-gray-100 animate-pulse h-16 bg-gray-50" />
                    ))}
                  </div>
                ) : orders.length === 0 ? (
                  <div className="text-center py-10 space-y-3">
                    <ShoppingBag className="w-12 h-12 text-gray-300 mx-auto" />
                    <p className="text-sm text-gray-500">No orders yet.</p>
                    <Link href="/" className="inline-block text-sm font-bold text-[#006B23] hover:underline">Start shopping →</Link>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {orders.map((ord) => (
                      <Link
                        key={ord.id}
                        href={`/tracking/${ord.id}`}
                        className="p-5 rounded-2xl border border-gray-100 hover:border-emerald-200 transition flex items-center justify-between"
                      >
                        <div>
                          <div className="font-bold text-gray-900">{ord.orderNumber}</div>
                          <div className="text-xs text-gray-500">
                            {new Date(ord.createdAt).toLocaleDateString()} • {ord.items?.length ?? 0} items
                          </div>
                        </div>
                        <div className="text-right flex items-center gap-3">
                          <div>
                            <div className="font-bold text-gray-900">{formatCurrency(ord.totalAmount)}</div>
                            <span className="text-[11px] font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-md">
                              {ord.status}
                            </span>
                          </div>
                          <ChevronRight className="w-4 h-4 text-gray-400" />
                        </div>
                      </Link>
                    ))}
                  </div>
                )}
              </div>
            )}

            {activeTab === 'addresses' && (
              <div className="bg-white rounded-3xl p-8 border border-gray-100 shadow-xl space-y-6">
                <h3 className="text-xl font-bold font-outfit text-gray-900 border-b border-gray-100 pb-4">
                  Saved Delivery Addresses
                </h3>
                {addresses.length === 0 ? (
                  <div className="text-center py-10 space-y-3">
                    <MapPin className="w-12 h-12 text-gray-300 mx-auto" />
                    <p className="text-sm text-gray-500">No saved addresses.</p>
                    <Link href="/add-address" className="inline-block text-sm font-bold text-[#006B23] hover:underline">Add an address →</Link>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {addresses.map((addr) => (
                      <div key={addr.id} className="p-5 rounded-2xl border border-gray-100 flex items-start gap-4">
                        <MapPin className="w-5 h-5 text-[#006B23] mt-0.5" />
                        <div>
                          <div className="font-bold text-sm text-gray-900 flex items-center gap-2">
                            <span>{addr.label}</span>
                            {addr.isDefault && (
                              <span className="text-[10px] bg-emerald-100 text-[#006B23] px-2 py-0.5 rounded-full font-bold">
                                DEFAULT
                              </span>
                            )}
                          </div>
                          <p className="text-xs text-gray-600 mt-1 leading-relaxed">
                            {addr.houseNo}, {addr.street}, {addr.city} - {addr.pincode}
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}

            {activeTab === 'wallet' && (
              <div className="bg-white rounded-3xl p-8 border border-gray-100 shadow-xl space-y-6">
                <h3 className="text-xl font-bold font-outfit text-gray-900 border-b border-gray-100 pb-4">
                  Daily Basket Cash & Wallet
                </h3>
                <div className="bg-gradient-to-br from-[#006B23] to-[#078730] text-white p-6 rounded-2xl shadow-lg flex items-center justify-between">
                  <div>
                    <div className="text-xs text-emerald-100 font-medium mb-1">Available Wallet Balance</div>
                    <div className="text-3xl font-black font-outfit">₹{user.walletBalance.toFixed(2)}</div>
                  </div>
                  <CreditCard className="w-10 h-10 text-[#8CFA93]" />
                </div>
              </div>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
