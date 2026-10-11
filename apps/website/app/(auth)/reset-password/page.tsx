'use client';

import React, { useState, Suspense } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ArrowLeft, Lock, KeyRound, Eye, EyeOff, AlertCircle, Loader2, RefreshCw, ArrowRight } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';
import { apiClient } from '@daily-basket/api-client';

function ResetPasswordForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const initialEmail = searchParams?.get('email') || '';
  const initialOtp = searchParams?.get('otp') || searchParams?.get('token') || '';

  const [email, setEmail] = useState(initialEmail);
  const [otp, setOtp] = useState(initialOtp);
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const cleanOtp = otp.trim();
    if (!cleanOtp) {
      setErrorMsg('Please enter your 6-digit Email OTP.');
      return;
    }
    if (!newPassword || newPassword.length < 8) {
      setErrorMsg('Password must be at least 8 characters long.');
      return;
    }
    if (newPassword !== confirmPassword) {
      setErrorMsg('Passwords do not match.');
      return;
    }

    setIsLoading(true);
    setErrorMsg('');
    try {
      await apiClient.resetPassword({
        email: email.trim(),
        otp: cleanOtp,
        token: cleanOtp,
        newPass: newPassword,
      });
      router.push('/success?type=reset');
    } catch (err: any) {
      setErrorMsg(err?.message || 'Invalid or expired OTP. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="w-full max-w-[420px] bg-white border border-slate-100/80 rounded-[24px] sm:rounded-[28px] p-5 sm:p-8 md:p-9 shadow-xl shadow-slate-200/50 animate-[fadeInUp_0.5s_ease-out] text-center my-auto">
      
      {/* Circular Refresh Security Badge */}
      <div className="flex justify-center mb-5 sm:mb-6">
        <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full bg-[#E5EFE7] flex items-center justify-center text-[#078730] shadow-xs">
          <div className="relative flex items-center justify-center">
            <RefreshCw className="w-8 h-8 sm:w-9 sm:h-9 stroke-[2.2] animate-[spin_16s_linear_infinite]" />
          </div>
        </div>
      </div>

      {/* Heading & Subtitle */}
      <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-2 tracking-tight">
        Reset Password
      </h2>
      <p className="text-slate-600 text-xs sm:text-sm font-inter leading-relaxed mb-5">
        Enter your 6-digit email OTP and choose a new password.
      </p>

      {/* Error Banner */}
      {errorMsg && (
        <div className="mb-5 p-3 sm:p-3.5 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-2.5 sm:gap-3 text-red-600 text-xs sm:text-sm font-medium text-left">
          <AlertCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0" />
          <span className="leading-snug">{errorMsg}</span>
        </div>
      )}

      {/* Reset Password Form */}
      <form onSubmit={handleSubmit} className="space-y-4 sm:space-y-5 text-left">
        
        {/* Email Address (if needed) */}
        {!initialEmail && (
          <div>
            <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
              Email Address
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="name@example.com"
              className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3 sm:py-3.5 px-4 text-slate-800 text-base font-medium placeholder-slate-400 outline-none transition-all duration-200"
              disabled={isLoading}
            />
          </div>
        )}

        {/* 6-Digit Email OTP */}
        <div>
          <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
            6-Digit Email OTP
          </label>
          <div className="relative flex items-center">
            <KeyRound className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
            <input
              type="text"
              inputMode="numeric"
              maxLength={6}
              value={otp}
              onChange={(e) => setOtp(e.target.value.replace(/\D/g, ''))}
              placeholder="123456"
              className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3 sm:py-3.5 pl-10 sm:pl-12 pr-4 text-slate-900 text-base sm:text-lg font-bold tracking-[0.2em] placeholder:tracking-normal placeholder-slate-400 outline-none transition-all duration-200"
              disabled={isLoading}
            />
          </div>
        </div>

        {/* Field 1: New Password */}
        <div>
          <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
            New Password
          </label>
          <div className="relative flex items-center">
            <Lock className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
            <input
              type={showNewPassword ? 'text' : 'password'}
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3 sm:py-3.5 pl-10 sm:pl-12 pr-11 sm:pr-12 text-slate-800 text-base font-medium placeholder-slate-400 outline-none transition-all duration-200"
              disabled={isLoading}
            />
            <button
              type="button"
              onClick={() => setShowNewPassword(!showNewPassword)}
              className="absolute right-3 sm:right-3.5 p-1 text-slate-500 hover:text-slate-700 transition"
              aria-label="Toggle password visibility"
            >
              {showNewPassword ? <EyeOff className="w-4 h-4 sm:w-5 sm:h-5" /> : <Eye className="w-4 h-4 sm:w-5 sm:h-5" />}
            </button>
          </div>
        </div>

        {/* Field 2: Confirm Password */}
        <div>
          <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
            Confirm Password
          </label>
          <div className="relative flex items-center">
            <Lock className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
            <input
              type={showConfirmPassword ? 'text' : 'password'}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3 sm:py-3.5 pl-10 sm:pl-12 pr-11 sm:pr-12 text-slate-800 text-base font-medium placeholder-slate-400 outline-none transition-all duration-200"
              disabled={isLoading}
            />
            <button
              type="button"
              onClick={() => setShowConfirmPassword(!showConfirmPassword)}
              className="absolute right-3 sm:right-3.5 p-1 text-slate-500 hover:text-slate-700 transition"
              aria-label="Toggle password visibility"
            >
              {showConfirmPassword ? <EyeOff className="w-4 h-4 sm:w-5 sm:h-5" /> : <Eye className="w-4 h-4 sm:w-5 sm:h-5" />}
            </button>
          </div>
        </div>

        {/* Primary Pill Button */}
        <button
          type="submit"
          disabled={isLoading}
          className="w-full py-3.5 sm:py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-sm sm:text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center gap-2 transition-all duration-200 disabled:opacity-50 cursor-pointer"
        >
          {isLoading ? (
            <Loader2 className="w-5 h-5 animate-spin" />
          ) : (
            <>
              <span>Reset Password</span>
              <ArrowRight className="w-4 h-4 sm:w-5 sm:h-5 stroke-[2.2]" />
            </>
          )}
        </button>

        {/* Back link */}
        <div className="pt-2 text-center">
          <Link
            href="/forgot-password"
            className="inline-flex items-center gap-1.5 text-xs sm:text-sm font-bold text-[#078730] hover:underline transition font-outfit py-1"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Request New OTP</span>
          </Link>
        </div>
      </form>

    </div>
  );
}

export default function ResetPasswordPage() {
  return (
    <div className="relative min-h-[100dvh] w-full flex flex-col justify-between bg-slate-50 font-sans overflow-x-hidden selection:bg-[#078730]/20">
      <OrganicShaderBackground />

      {/* ─── Top Bar Header ────────────────────────────────────────────── */}
      <header className="relative z-10 bg-white/90 backdrop-blur-md border-b border-slate-200/70 py-3.5 px-4 sm:px-6 flex items-center justify-between">
        <Link
          href="/forgot-password"
          className="text-slate-700 hover:text-[#078730] transition flex items-center justify-center p-2 rounded-full hover:bg-slate-100"
          aria-label="Back to Forgot Password"
        >
          <ArrowLeft className="w-5 h-5 stroke-[2.2]" />
        </Link>
        <h1 className="text-xl sm:text-2xl font-extrabold text-[#078730] font-outfit tracking-tight">
          Daily Basket
        </h1>
        <div className="w-9" />
      </header>

      {/* ─── Main Content Area ──────────────────────────────────────────── */}
      <main className="relative z-10 flex-1 flex items-center justify-center px-3.5 py-6 sm:p-6 my-auto">
        <Suspense fallback={<Loader2 className="w-8 h-8 text-[#078730] animate-spin" />}>
          <ResetPasswordForm />
        </Suspense>
      </main>

      {/* ─── Bottom Footer Section ───────────────────────────────────────── */}
      <footer className="relative z-10 bg-[#EDF3EF] border-t border-slate-200/60 py-6 px-4 text-center">
        <div className="max-w-md mx-auto space-y-2.5">
          <h3 className="text-lg font-extrabold text-[#078730] font-outfit tracking-tight">
            Daily Basket
          </h3>

          <div className="flex flex-wrap justify-center items-center gap-3 text-xs font-semibold text-slate-600 font-inter">
            <Link href="/privacy" className="hover:text-slate-900 transition">
              Privacy Policy
            </Link>
            <span className="text-slate-300">•</span>
            <Link href="/terms" className="hover:text-slate-900 transition">
              Terms of Service
            </Link>
            <span className="text-slate-300">•</span>
            <Link href="/support" className="hover:text-slate-900 transition">
              Help Center
            </Link>
          </div>

          <p className="text-[11px] text-slate-500 font-inter">
            © {new Date().getFullYear()} Daily Basket. All rights reserved.
          </p>
        </div>
      </footer>

    </div>
  );
}
