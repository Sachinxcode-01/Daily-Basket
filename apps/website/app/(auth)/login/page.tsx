'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { ShoppingBasket, Phone, ArrowRight, ShieldCheck, CheckCircle2, AlertCircle, Loader2 } from 'lucide-react';
import { apiClient } from '@daily-basket/api-client';
import { useAuthStore } from '../../../store/useAuthStore';

export default function LoginPage() {
  const router = useRouter();
  const setAuth = useAuthStore((state) => state.setAuth);

  const [step, setStep] = useState<'PHONE' | 'OTP' | 'SUCCESS'>('PHONE');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [otpCode, setOtpCode] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleRequestOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!phoneNumber || phoneNumber.length < 10) {
      setErrorMsg('Please enter a valid 10-digit mobile number.');
      return;
    }
    setIsLoading(true);
    setErrorMsg('');
    try {
      await apiClient.requestOtp(phoneNumber);
      setStep('OTP');
    } catch (err: any) {
      setErrorMsg(err.message || 'Failed to send OTP. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleVerifyOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!otpCode || otpCode.length < 6) {
      setErrorMsg('Please enter 6-digit OTP code.');
      return;
    }
    setIsLoading(true);
    setErrorMsg('');
    try {
      const res = await apiClient.verifyOtp(phoneNumber, otpCode);
      setAuth(res.user, res.token || 'demo_jwt_access_token');
      setStep('SUCCESS');
      setTimeout(() => {
        router.push('/');
      }, 1200);
    } catch (err: any) {
      setErrorMsg(err.message || 'Invalid OTP code.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 flex flex-col justify-center items-center p-4">
      {/* Brand Header */}
      <div className="flex items-center gap-3 mb-8">
        <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-emerald-600 to-lime-500 flex items-center justify-center shadow-lg shadow-emerald-900/40">
          <ShoppingBasket className="w-7 h-7 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-extrabold bg-gradient-to-r from-emerald-400 to-lime-400 bg-clip-text text-transparent">
            Daily Basket
          </h1>
          <p className="text-xs text-slate-400 font-medium">⚡ 10-Minute Grocery Delivery</p>
        </div>
      </div>

      {/* Card Container */}
      <div className="w-full max-w-md bg-slate-800/80 border border-slate-700/50 backdrop-blur-xl rounded-3xl p-6 sm:p-8 shadow-2xl">
        {errorMsg && (
          <div className="mb-6 p-4 rounded-2xl bg-red-500/10 border border-red-500/30 flex items-start gap-3 text-red-400 text-sm">
            <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
            <span>{errorMsg}</span>
          </div>
        )}

        {step === 'PHONE' && (
          <form onSubmit={handleRequestOtp} className="space-y-6">
            <div>
              <h2 className="text-xl font-bold text-white mb-1">Get Started</h2>
              <p className="text-slate-400 text-sm">Enter your phone number to login or signup</p>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-300 uppercase tracking-wider">Phone Number</label>
              <div className="relative flex items-center">
                <span className="absolute left-4 text-slate-400 font-semibold text-sm">+91</span>
                <input
                  type="tel"
                  maxLength={10}
                  value={phoneNumber}
                  onChange={(e) => setPhoneNumber(e.target.value.replace(/\D/g, ''))}
                  placeholder="9876543210"
                  className="w-full bg-slate-900/90 border border-slate-700 focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 rounded-xl py-3.5 pl-14 pr-4 text-white font-medium placeholder-slate-500 outline-none transition"
                  disabled={isLoading}
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={isLoading || phoneNumber.length < 10}
              className="w-full py-4 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white font-bold rounded-xl shadow-lg shadow-emerald-900/30 flex items-center justify-center gap-2 transition"
            >
              {isLoading ? (
                <Loader2 className="w-5 h-5 animate-spin" />
              ) : (
                <>
                  <span>Continue with Phone</span>
                  <ArrowRight className="w-5 h-5" />
                </>
              )}
            </button>

            <div className="relative flex items-center justify-center my-6">
              <div className="border-t border-slate-700/60 w-full" />
              <span className="bg-slate-800 px-3 text-xs text-slate-400 uppercase font-semibold">Or</span>
              <div className="border-t border-slate-700/60 w-full" />
            </div>

            <button
              type="button"
              onClick={() => {
                setPhoneNumber('9876543210');
                setStep('OTP');
              }}
              className="w-full py-3.5 border border-slate-700 hover:bg-slate-700/50 text-slate-200 font-semibold rounded-xl flex items-center justify-center gap-3 transition"
            >
              <ShieldCheck className="w-5 h-5 text-emerald-400" />
              <span>Continue with Google</span>
            </button>
          </form>
        )}

        {step === 'OTP' && (
          <form onSubmit={handleVerifyOtp} className="space-y-6">
            <div>
              <h2 className="text-xl font-bold text-white mb-1">Verify OTP</h2>
              <p className="text-slate-400 text-sm">
                Sent 6-digit code to <span className="text-emerald-400 font-semibold">+91 {phoneNumber}</span>
              </p>
              <p className="text-xs text-slate-400 mt-1">Demo code: <code className="text-lime-400 font-bold">123456</code></p>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-300 uppercase tracking-wider">6-Digit Code</label>
              <input
                type="text"
                maxLength={6}
                value={otpCode}
                onChange={(e) => setOtpCode(e.target.value)}
                placeholder="123456"
                className="w-full bg-slate-900/90 border border-slate-700 focus:border-emerald-500 rounded-xl py-3.5 px-4 text-center text-2xl tracking-widest font-extrabold text-white outline-none transition"
                disabled={isLoading}
              />
            </div>

            <button
              type="submit"
              disabled={isLoading || otpCode.length < 6}
              className="w-full py-4 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white font-bold rounded-xl shadow-lg shadow-emerald-900/30 flex items-center justify-center gap-2 transition"
            >
              {isLoading ? (
                <Loader2 className="w-5 h-5 animate-spin" />
              ) : (
                <span>Verify & Login</span>
              )}
            </button>

            <button
              type="button"
              onClick={() => setStep('PHONE')}
              className="w-full text-center text-xs text-slate-400 hover:text-slate-200 transition"
            >
              Change Phone Number
            </button>
          </form>
        )}

        {step === 'SUCCESS' && (
          <div className="py-8 flex flex-col items-center text-center space-y-4">
            <div className="w-16 h-16 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center text-emerald-400 animate-bounce">
              <CheckCircle2 className="w-10 h-10" />
            </div>
            <h3 className="text-2xl font-extrabold text-white">Login Successful!</h3>
            <p className="text-slate-400 text-sm">Redirecting to Daily Basket fresh store...</p>
          </div>
        )}
      </div>
    </div>
  );
}
