'use client';

import React, { useState } from 'react';
import {
  Bike,
  Navigation,
  Phone,
  CheckCircle2,
  DollarSign,
  MapPin,
  Clock,
  ShieldCheck,
  Power,
  ChevronRight,
  AlertCircle,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function DeliveryRiderDashboardPage() {
  const [isOnline, setIsOnline] = useState(true);
  const [orderStep, setOrderStep] = useState<'ASSIGNED' | 'PICKED_UP' | 'ARRIVED' | 'DELIVERED'>('ASSIGNED');
  const [otpInput, setOtpInput] = useState('');
  const [otpError, setOtpError] = useState(false);
  const [showOtpModal, setShowOtpModal] = useState(false);

  const activeOrder = {
    id: 'DB-892104',
    pickup: 'Hub Store #01 Koramangala',
    dropoff: '#42 100 Feet Rd, Koramangala 4th Block',
    customer: 'Ananya Sharma',
    phone: '+91 98765 12345',
    items: '3 Items (Tomatoes, Milk)',
    earnings: 45,
    distance: '1.8 km',
    validOtp: '4821',
  };

  const handleVerifyOtp = () => {
    if (otpInput === activeOrder.validOtp) {
      setOrderStep('DELIVERED');
      setShowOtpModal(false);
      setOtpError(false);
    } else {
      setOtpError(true);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-20 max-w-md mx-auto">
      {/* Top Header & Duty Toggle */}
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-emerald-600 flex items-center justify-center text-white font-bold shadow-lg">
            <Bike className="w-5 h-5" />
          </div>
          <div>
            <h1 className="text-base font-extrabold text-white">Ramesh Kumar</h1>
            <p className="text-xs text-slate-400">KA 01 EB 4821 • ⭐ 4.9</p>
          </div>
        </div>

        <button
          onClick={() => setIsOnline(!isOnline)}
          className={`px-4 py-2 rounded-full font-bold text-xs flex items-center gap-2 border transition ${
            isOnline
              ? 'bg-emerald-500/10 border-emerald-500 text-emerald-400'
              : 'bg-rose-500/10 border-rose-500 text-rose-400'
          }`}
        >
          <Power className="w-3.5 h-3.5" />
          <span>{isOnline ? 'ONLINE' : 'OFFLINE'}</span>
        </button>
      </div>

      {/* Today's Wallet Earnings summary */}
      <div className="bg-gradient-to-r from-emerald-900/60 to-teal-900/40 border border-emerald-500/40 p-5 rounded-3xl mb-6 shadow-xl flex items-center justify-between">
        <div>
          <p className="text-xs text-emerald-300 font-bold uppercase tracking-wider">Today's Earnings</p>
          <h2 className="text-3xl font-black text-white mt-0.5">₹850</h2>
          <p className="text-[11px] text-emerald-200 mt-1">18 Orders Completed • ₹150 Incentive</p>
        </div>
        <div className="w-12 h-12 rounded-2xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400">
          <DollarSign className="w-6 h-6" />
        </div>
      </div>

      {/* Active Order Delivery Card */}
      {!isOnline ? (
        <div className="bg-slate-800/80 border border-slate-700/60 p-8 rounded-3xl text-center space-y-3">
          <Power className="w-12 h-12 text-slate-500 mx-auto" />
          <h3 className="text-lg font-bold text-white">You are Offline</h3>
          <p className="text-xs text-slate-400">Switch status to ONLINE above to start receiving 10-minute quick-commerce orders.</p>
        </div>
      ) : orderStep === 'DELIVERED' ? (
        <div className="bg-slate-800/80 border border-emerald-500/60 p-8 rounded-3xl text-center space-y-4">
          <CheckCircle2 className="w-16 h-16 text-emerald-400 mx-auto animate-bounce" />
          <h3 className="text-xl font-black text-white">Order Delivered!</h3>
          <p className="text-sm font-bold text-emerald-400">+₹45 Added to Wallet</p>
          <button
            onClick={() => setOrderStep('ASSIGNED')}
            className="w-full py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm transition"
          >
            Ready for Next Order
          </button>
        </div>
      ) : (
        <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-3xl space-y-4 shadow-lg">
          <div className="flex items-center justify-between border-b border-slate-700/60 pb-3">
            <div>
              <span className="text-xs font-bold text-emerald-400">Active Order #{activeOrder.id}</span>
              <p className="text-[11px] text-slate-400">{activeOrder.distance} • Est. Earnings: ₹{activeOrder.earnings}</p>
            </div>
            <span className="bg-amber-500/20 text-amber-400 border border-amber-500/30 px-2.5 py-1 rounded-full text-[10px] font-bold">
              {orderStep}
            </span>
          </div>

          {/* Pickup Store */}
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-slate-700 flex items-center justify-center text-slate-300 font-bold text-xs flex-shrink-0">
              1
            </div>
            <div>
              <p className="text-xs font-bold text-slate-400">PICKUP FROM STORE</p>
              <h4 className="text-sm font-bold text-white">{activeOrder.pickup}</h4>
            </div>
          </div>

          {/* Dropoff Customer */}
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-emerald-600 flex items-center justify-center text-white font-bold text-xs flex-shrink-0">
              2
            </div>
            <div>
              <p className="text-xs font-bold text-slate-400">DELIVER TO CUSTOMER</p>
              <h4 className="text-sm font-bold text-white">{activeOrder.customer}</h4>
              <p className="text-xs text-slate-300 mt-0.5">{activeOrder.dropoff}</p>
            </div>
          </div>

          {/* Action CTAs */}
          <div className="pt-2 grid grid-cols-2 gap-3">
            <a
              href={`tel:${activeOrder.phone}`}
              className="py-2.5 bg-slate-700 hover:bg-slate-600 text-slate-200 font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition"
            >
              <Phone className="w-4 h-4 text-emerald-400" />
              <span>Call Customer</span>
            </a>
            <button className="py-2.5 bg-slate-700 hover:bg-slate-600 text-slate-200 font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition">
              <Navigation className="w-4 h-4 text-sky-400" />
              <span>Open Maps</span>
            </button>
          </div>

          {/* Main Delivery Step Action Button */}
          {orderStep === 'ASSIGNED' && (
            <button
              onClick={() => setOrderStep('PICKED_UP')}
              className="w-full py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm shadow-lg shadow-emerald-900/40 transition"
            >
              Confirm Order Picked Up
            </button>
          )}

          {orderStep === 'PICKED_UP' && (
            <button
              onClick={() => setOrderStep('ARRIVED')}
              className="w-full py-3.5 bg-amber-600 hover:bg-amber-500 text-slate-950 font-extrabold rounded-xl text-sm shadow-lg transition"
            >
              Arrived at Doorstep
            </button>
          )}

          {orderStep === 'ARRIVED' && (
            <button
              onClick={() => setShowOtpModal(true)}
              className="w-full py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm shadow-lg transition flex items-center justify-center gap-2"
            >
              <ShieldCheck className="w-5 h-5" />
              <span>Enter Customer Delivery OTP</span>
            </button>
          )}
        </div>
      )}

      {/* OTP Delivery Verification Modal */}
      {showOtpModal && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-800 border border-slate-700 p-6 rounded-3xl w-full max-w-xs text-center space-y-4 shadow-2xl">
            <ShieldCheck className="w-12 h-12 text-emerald-400 mx-auto" />
            <h3 className="text-lg font-bold text-white">Delivery OTP Verification</h3>
            <p className="text-xs text-slate-400">Ask customer for the 4-digit verification code sent to their phone.</p>

            <input
              type="text"
              maxLength={4}
              value={otpInput}
              onChange={(e) => setOtpInput(e.target.value)}
              placeholder="4821"
              className="w-full text-center text-2xl font-mono tracking-widest py-3 bg-slate-900 border border-slate-700 rounded-xl text-white focus:border-emerald-500 outline-none"
            />

            {otpError && (
              <p className="text-xs text-rose-400 font-bold flex items-center justify-center gap-1">
                <AlertCircle className="w-4 h-4" />
                Invalid OTP. Try 4821
              </p>
            )}

            <div className="flex gap-2">
              <button
                onClick={() => setShowOtpModal(false)}
                className="flex-1 py-2.5 bg-slate-700 text-slate-300 font-bold text-xs rounded-xl"
              >
                Cancel
              </button>
              <button
                onClick={handleVerifyOtp}
                className="flex-1 py-2.5 bg-emerald-600 text-white font-bold text-xs rounded-xl"
              >
                Verify & Complete
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
