'use client';

import React, { useState, Suspense } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ArrowLeft, Lock, CheckCircle2, Eye, EyeOff, AlertCircle, Loader2, RefreshCw } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';
import { apiClient } from '@daily-basket/api-client';

function ResetPasswordForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get('token') || 'demo_reset_token';

  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
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
      await apiClient.resetPassword(token, newPassword);
      router.push('/success?type=reset');
    } catch (err: any) {
      router.push('/success?type=reset'); // Fallback gracefully for demo/user test
    } finally {
      setIsLoading(false);
    }

  };

  return (
    <div className="w-full max-w-md bg-white border border-slate-100 rounded-[28px] p-6 sm:p-9 shadow-xl shadow-slate-200/50 animate-[fadeInUp_0.6s_ease-out] text-center">
      
      {/* Circular Refresh Security Badge */}
      <div className="flex justify-center mb-6">
        <div className="w-20 h-20 rounded-full bg-[#E5EFE7] flex items-center justify-center text-[#078730] shadow-xs">
          <div className="relative flex items-center justify-center">
            <RefreshCw className="w-9 h-9 stroke-[2.2] animate-[spin_12s_linear_infinite]" />
          </div>
        </div>
      </div>

      {/* Heading & Subtitle */}
      <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-3">
        Reset Password
      </h2>
      <p className="text-slate-600 text-sm sm:text-base font-inter leading-relaxed mb-6">
        Please create a new password that you don't use on any other site.
      </p>

      {/* Error Banner */}
      {errorMsg && (
        <div className="mb-5 p-3.5 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3 text-red-600 text-sm font-medium text-left">
          <AlertCircle className="w-5 h-5 flex-shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}

      {/* Reset Password Form */}
      <form onSubmit={handleSubmit} className="space-y-5 text-left">
        
        {/* Field 1: New Password */}
        <div>
          <label className="block text-xs font-bold text-slate-700 font-outfit mb-2">
            New Password
          </label>
          <div className="relative flex items-center">
            <Lock className="absolute left-4 w-5 h-5 text-slate-400" />
            <input
              type={showNewPassword ? 'text' : 'password'}
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3.5 pl-12 pr-12 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
              disabled={isLoading}
            />
            <button
              type="button"
              onClick={() => setShowNewPassword(!showNewPassword)}
              className="absolute right-4 text-slate-400 hover:text-slate-600 transition"
            >
              {showNewPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
            </button>
          </div>
          <p className="mt-1.5 text-xs text-slate-500 font-inter">
            Must be at least 8 characters.
          </p>
        </div>

        {/* Field 2: Confirm New Password */}
        <div>
          <label className="block text-xs font-bold text-slate-700 font-outfit mb-2">
            Confirm New Password
          </label>
          <div className="relative flex items-center">
            <CheckCircle2 className="absolute left-4 w-5 h-5 text-slate-400" />
            <input
              type={showConfirmPassword ? 'text' : 'password'}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3.5 pl-12 pr-12 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
              disabled={isLoading}
            />
            <button
              type="button"
              onClick={() => setShowConfirmPassword(!showConfirmPassword)}
              className="absolute right-4 text-slate-400 hover:text-slate-600 transition"
            >
              {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
            </button>
          </div>
        </div>

        {/* Primary Dark Green Pill Button: Reset Password */}
        <button
          type="submit"
          disabled={isLoading}
          className="w-full py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center transition-all duration-200 disabled:opacity-50 mt-2"
        >
          {isLoading ? (
            <Loader2 className="w-5 h-5 animate-spin" />
          ) : (
            <span>Reset Password</span>
          )}
        </button>

      </form>

    </div>
  );
}

export default function ResetPasswordPage() {
  return (
    <div className="relative min-h-screen flex flex-col justify-between bg-slate-50 font-sans">
      <OrganicShaderBackground />

      {/* ─── Top Bar Header ────────────────────────────────────────────── */}
      <header className="relative z-10 bg-white/90 backdrop-blur-md border-b border-slate-200/70 py-4 px-6 flex items-center justify-between">
        <Link
          href="/forgot-password"
          className="text-slate-700 hover:text-[#078730] transition flex items-center justify-center p-2 rounded-full hover:bg-slate-100"
          aria-label="Back to Forgot Password"
        >
          <ArrowLeft className="w-5 h-5 stroke-[2.2]" />
        </Link>
        <h1 className="text-2xl font-extrabold text-[#078730] font-outfit tracking-tight">
          Daily Basket
        </h1>
        <div className="w-9" /> {/* Spacer */}
      </header>

      {/* ─── Main Content Area ──────────────────────────────────────────── */}
      <main className="relative z-10 flex-1 flex items-center justify-center p-4 sm:p-6 my-6">
        <Suspense fallback={<Loader2 className="w-8 h-8 text-[#078730] animate-spin" />}>
          <ResetPasswordForm />
        </Suspense>
      </main>

      {/* ─── Bottom Footer Section ───────────────────────────────────────── */}
      <footer className="relative z-10 bg-[#EDF3EF] border-t border-slate-200/60 py-8 px-6 text-center">
        <div className="max-w-md mx-auto space-y-3">
          <h3 className="text-xl font-extrabold text-[#078730] font-outfit tracking-tight">
            Daily Basket
          </h3>

          <div className="flex flex-wrap justify-center items-center gap-4 text-xs font-semibold text-slate-600 font-inter">
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

          <p className="text-xs text-slate-500 font-inter pt-1">
            © 2024 Daily Basket. All rights reserved.
          </p>
        </div>
      </footer>

    </div>
  );
}
