'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  ArrowLeft,
  Mail,
  Lock,
  Eye,
  EyeOff,
  ArrowRight,
  CheckCircle2,
  AlertCircle,
  Loader2,
  KeyRound,
  ShieldCheck,
  RefreshCw,
} from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';
import { apiClient } from '@daily-basket/api-client';

type Step = 'EMAIL' | 'OTP' | 'SUCCESS';

export default function ForgotPasswordPage() {
  const router = useRouter();
  const [step, setStep] = useState<Step>('EMAIL');
  const [email, setEmail] = useState('');
  const [otp, setOtp] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [cooldown, setCooldown] = useState(0);

  // 60-second Resend OTP Cooldown Timer
  useEffect(() => {
    if (cooldown <= 0) return;
    const timer = setInterval(() => {
      setCooldown((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, [cooldown]);

  // Step 1: Request 6-digit Email OTP
  const handleRequestOtp = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    const cleanEmail = email.trim();
    if (!cleanEmail || !cleanEmail.includes('@')) {
      setErrorMsg('Please enter a valid email address.');
      return;
    }

    setIsLoading(true);
    setErrorMsg('');
    try {
      await apiClient.forgotPassword(cleanEmail);
      setStep('OTP');
      setCooldown(60);
    } catch (err: any) {
      // In case of demo or error, still allow progression for seamless user experience
      setStep('OTP');
      setCooldown(60);
    } finally {
      setIsLoading(false);
    }
  };

  // Step 2: Verify OTP & Set New Password
  const handleResetWithOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg('');

    const cleanOtp = otp.trim();
    if (!cleanOtp || cleanOtp.length < 4) {
      setErrorMsg('Please enter the verification OTP code.');
      return;
    }
    if (!newPassword || newPassword.length < 8) {
      setErrorMsg('New password must be at least 8 characters.');
      return;
    }
    if (newPassword !== confirmPassword) {
      setErrorMsg('Passwords do not match.');
      return;
    }

    setIsLoading(true);
    try {
      await apiClient.resetPassword({
        email: email.trim(),
        otp: cleanOtp,
        newPass: newPassword,
      });
      setStep('SUCCESS');
    } catch (err: any) {
      setErrorMsg(err?.message || 'Invalid or expired OTP code. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="relative min-h-[100dvh] w-full flex flex-col justify-between bg-slate-50 font-sans overflow-x-hidden selection:bg-[#078730]/20">
      <OrganicShaderBackground />

      {/* ─── Top Bar Header ────────────────────────────────────────────── */}
      <header className="relative z-10 bg-white/90 backdrop-blur-md border-b border-slate-200/70 py-3.5 px-4 sm:px-6 flex items-center justify-between">
        <Link
          href="/login"
          className="text-slate-700 hover:text-[#078730] transition flex items-center justify-center p-2 rounded-full hover:bg-slate-100"
          aria-label="Back to Login"
        >
          <ArrowLeft className="w-5 h-5 stroke-[2.2]" />
        </Link>
        <h1 className="text-xl sm:text-2xl font-extrabold text-[#078730] font-outfit tracking-tight">
          Daily Basket
        </h1>
        <div className="w-9" />
      </header>

      {/* ─── Main Content Card ──────────────────────────────────────────── */}
      <main className="relative z-10 flex-1 flex items-center justify-center px-3.5 py-6 sm:p-6 my-auto">
        <div className="w-full max-w-[420px] bg-white border border-slate-100/80 rounded-[24px] sm:rounded-[28px] p-5 sm:p-8 md:p-9 shadow-xl shadow-slate-200/50 animate-[fadeInUp_0.5s_ease-out] text-center">
          
          {/* ─── Security Lock Badge ─── */}
          <div className="flex justify-center mb-5 sm:mb-6">
            <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full bg-[#E5EFE7] flex items-center justify-center text-[#078730] shadow-xs">
              {step === 'SUCCESS' ? (
                <ShieldCheck className="w-8 h-8 sm:w-10 sm:h-10 stroke-[2.2]" />
              ) : step === 'OTP' ? (
                <KeyRound className="w-8 h-8 sm:w-10 sm:h-10 stroke-[2.2]" />
              ) : (
                <RefreshCw className="w-8 h-8 sm:w-9 sm:h-9 stroke-[2.2] animate-[spin_16s_linear_infinite]" />
              )}
            </div>
          </div>

          {/* ─── Error Notification ─── */}
          {errorMsg && (
            <div className="mb-5 p-3 sm:p-3.5 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-2.5 sm:gap-3 text-red-600 text-xs sm:text-sm font-medium text-left">
              <AlertCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0" />
              <span className="leading-snug">{errorMsg}</span>
            </div>
          )}

          {/* ═════════════════════════════════════════════════════════════════ */}
          {/* STEP 1: Enter Email to Request OTP                                */}
          {/* ═════════════════════════════════════════════════════════════════ */}
          {step === 'EMAIL' && (
            <div>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-2 tracking-tight">
                Forgot Password
              </h2>
              <p className="text-slate-600 text-xs sm:text-sm font-inter leading-relaxed mb-6">
                Enter your registered email address and we will send a 6-digit verification OTP to your inbox.
              </p>

              <form onSubmit={handleRequestOtp} className="space-y-4 sm:space-y-5 text-left">
                <div>
                  <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
                    Email Address
                  </label>
                  <div className="relative flex items-center">
                    <Mail className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="your@email.com"
                      className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3 sm:py-3.5 pl-10 sm:pl-12 pr-4 text-slate-800 text-base font-medium placeholder-slate-400 outline-none transition-all duration-200"
                      disabled={isLoading}
                      autoFocus
                      autoComplete="email"
                    />
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={isLoading}
                  className="w-full py-3.5 sm:py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-sm sm:text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center gap-2 transition-all duration-200 disabled:opacity-50 cursor-pointer"
                >
                  {isLoading ? (
                    <Loader2 className="w-5 h-5 animate-spin" />
                  ) : (
                    <>
                      <span>Send Verification OTP</span>
                      <ArrowRight className="w-4 h-4 sm:w-5 sm:h-5 stroke-[2.2]" />
                    </>
                  )}
                </button>

                <div className="pt-2 text-center">
                  <Link
                    href="/login"
                    className="inline-flex items-center gap-1.5 text-xs sm:text-sm font-bold text-[#078730] hover:underline transition font-outfit py-1"
                  >
                    <ArrowLeft className="w-4 h-4" />
                    <span>Back to Login</span>
                  </Link>
                </div>
              </form>
            </div>
          )}

          {/* ═════════════════════════════════════════════════════════════════ */}
          {/* STEP 2: Enter Email OTP & Set New Password                        */}
          {/* ═════════════════════════════════════════════════════════════════ */}
          {step === 'OTP' && (
            <div>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-2 tracking-tight">
                Enter Email OTP
              </h2>
              <p className="text-slate-600 text-xs sm:text-sm font-inter leading-relaxed mb-5">
                We sent a 6-digit code to{' '}
                <strong className="text-slate-900 break-all">{email}</strong>.
                <button
                  type="button"
                  onClick={() => setStep('EMAIL')}
                  className="text-[#078730] font-bold ml-1.5 hover:underline"
                >
                  Change
                </button>
              </p>

              <form onSubmit={handleResetWithOtp} className="space-y-4 sm:space-y-5 text-left">
                {/* 6-Digit OTP Code Input */}
                <div>
                  <div className="flex justify-between items-center mb-1.5 sm:mb-2">
                    <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider font-outfit">
                      6-DIGIT OTP CODE
                    </label>
                    <span className="text-[11px] text-slate-500 font-medium font-inter">
                      Expires in 10 mins
                    </span>
                  </div>
                  <div className="relative flex items-center">
                    <KeyRound className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
                    <input
                      type="text"
                      inputMode="numeric"
                      maxLength={6}
                      value={otp}
                      onChange={(e) => setOtp(e.target.value.replace(/\D/g, ''))}
                      placeholder="123456"
                      className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3 sm:py-3.5 pl-10 sm:pl-12 pr-4 text-slate-900 text-lg sm:text-xl font-bold tracking-[0.25em] placeholder:tracking-normal placeholder-slate-400 outline-none transition-all duration-200"
                      disabled={isLoading}
                      autoFocus
                    />
                  </div>
                </div>

                {/* New Password */}
                <div>
                  <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
                    NEW PASSWORD
                  </label>
                  <div className="relative flex items-center">
                    <Lock className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
                    <input
                      type={showNewPassword ? 'text' : 'password'}
                      value={newPassword}
                      onChange={(e) => setNewPassword(e.target.value)}
                      placeholder="At least 8 characters"
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

                {/* Confirm Password */}
                <div>
                  <label className="block text-[11px] sm:text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 sm:mb-2 font-outfit">
                    CONFIRM PASSWORD
                  </label>
                  <div className="relative flex items-center">
                    <Lock className="absolute left-3.5 sm:left-4 w-4 h-4 sm:w-5 sm:h-5 text-slate-500 pointer-events-none" />
                    <input
                      type={showConfirmPassword ? 'text' : 'password'}
                      value={confirmPassword}
                      onChange={(e) => setConfirmPassword(e.target.value)}
                      placeholder="Re-enter new password"
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

                {/* Primary Button: Reset Password */}
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

                {/* Resend OTP Button & Countdown */}
                <div className="pt-2 flex items-center justify-between text-xs font-semibold font-outfit">
                  <span className="text-slate-500">Didn&apos;t receive code?</span>
                  {cooldown > 0 ? (
                    <span className="text-slate-400 font-medium font-inter">
                      Resend in {cooldown}s
                    </span>
                  ) : (
                    <button
                      type="button"
                      onClick={() => handleRequestOtp()}
                      disabled={isLoading}
                      className="text-[#078730] hover:underline cursor-pointer disabled:opacity-50"
                    >
                      Resend OTP
                    </button>
                  )}
                </div>
              </form>
            </div>
          )}

          {/* ═════════════════════════════════════════════════════════════════ */}
          {/* STEP 3: Success Confirmation                                      */}
          {/* ═════════════════════════════════════════════════════════════════ */}
          {step === 'SUCCESS' && (
            <div className="space-y-5 animate-[fadeIn_0.4s_ease-out]">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-emerald-100 text-[#078730]">
                <CheckCircle2 className="w-10 h-10 stroke-[2.2]" />
              </div>

              <div>
                <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-2 tracking-tight">
                  Password Reset!
                </h2>
                <p className="text-slate-600 text-xs sm:text-sm font-inter leading-relaxed">
                  Your password has been successfully updated via verified Email OTP. You can now log into your account.
                </p>
              </div>

              <div className="p-3.5 rounded-2xl bg-emerald-50 border border-emerald-200 text-[#078730] text-xs sm:text-sm font-medium">
                Active sessions have been refreshed for your security.
              </div>

              <Link
                href="/login"
                className="w-full py-3.5 sm:py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-sm sm:text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center gap-2 transition-all duration-200"
              >
                <span>Proceed to Login</span>
                <ArrowRight className="w-4 h-4 sm:w-5 sm:h-5 stroke-[2.2]" />
              </Link>
            </div>
          )}

        </div>
      </main>

      {/* ─── Bottom Footer ─────────────────────────────────────────────── */}
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
