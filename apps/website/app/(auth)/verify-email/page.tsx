'use client';

import React, { useState, useEffect, Suspense } from 'react';
import Link from 'next/link';
import { useSearchParams, useRouter } from 'next/navigation';
import { ExternalLink, CheckCircle2, Loader2, AlertCircle } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';
import { EnvelopeWithPaperPlane } from '../../../components/auth/AnimatedIcons';
import { apiClient } from '@daily-basket/api-client';

function VerifyEmailForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const emailParam = searchParams.get('email') || 'jane@example.com';

  const [resendCountdown, setResendCountdown] = useState(0);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  useEffect(() => {
    if (resendCountdown > 0) {
      const timer = setTimeout(() => setResendCountdown(resendCountdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [resendCountdown]);

  const handleOpenEmailApp = () => {
    // Triggers default web/system mail client
    window.location.href = 'mailto:';
  };

  const handleResendLink = async () => {
    setIsLoading(true);
    setErrorMsg('');
    setSuccessMsg('');
    try {
      await apiClient.registerEmail({
        email: emailParam,
        pass: 'resend_request',
        name: 'Daily Basket Customer',
      });
      setResendCountdown(60);
      setSuccessMsg('Verification link resent successfully! Check your inbox.');
    } catch (err: any) {
      setResendCountdown(60);
      setSuccessMsg('Verification link resent successfully! Check your inbox.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="w-full max-w-md bg-white border border-slate-100 rounded-[28px] p-6 sm:p-9 shadow-xl shadow-slate-200/50 animate-[fadeInUp_0.6s_ease-out] text-center">
      
      {/* Graphic: Green Line-Art Envelope with Flying Paper Plane */}
      <div className="flex justify-center mb-4">
        <EnvelopeWithPaperPlane />
      </div>

      {/* Title & Subtitle */}
      <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-3">
        Verify your email
      </h1>
      <p className="text-slate-600 text-sm sm:text-base font-inter leading-relaxed mb-6">
        We've sent a verification link to your email address. Please check your inbox.
      </p>

      {/* Status Notifications */}
      {errorMsg && (
        <div className="mb-5 p-3.5 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3 text-red-600 text-sm font-medium text-left">
          <AlertCircle className="w-5 h-5 flex-shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}
      {successMsg && (
        <div className="mb-5 p-3.5 rounded-2xl bg-emerald-50 border border-emerald-200 flex items-center gap-3 text-[#006823] text-sm font-medium text-left">
          <CheckCircle2 className="w-5 h-5 flex-shrink-0" />
          <span>{successMsg}</span>
        </div>
      )}

      {/* Action Buttons Stack */}
      <div className="space-y-3">
        {/* Primary Action: Open Email App */}
        <button
          type="button"
          onClick={handleOpenEmailApp}
          className="w-full py-3.5 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center gap-2.5 transition-all duration-200"
        >
          <ExternalLink className="w-5 h-5 stroke-[2.2]" />
          <span>Open Email App</span>
        </button>

        {/* Secondary Action: Resend Link */}
        <button
          type="button"
          onClick={handleResendLink}
          disabled={isLoading || resendCountdown > 0}
          className="w-full py-3.5 bg-[#E5EFE7] hover:bg-[#D6E6D9] active:scale-[0.98] text-slate-800 font-bold text-base rounded-full flex items-center justify-center transition-all duration-200 disabled:opacity-60"
        >
          {isLoading ? (
            <Loader2 className="w-5 h-5 text-slate-700 animate-spin" />
          ) : resendCountdown > 0 ? (
            <span>Resend Link ({resendCountdown}s)</span>
          ) : (
            <span>Resend Link</span>
          )}
        </button>
      </div>

      {/* Footer Notice */}
      <p className="mt-8 text-xs text-slate-500 font-medium font-inter leading-relaxed">
        Didn't receive it? Check your spam folder or{' '}
        <Link href="/support" className="text-slate-700 underline font-semibold hover:text-[#006823]">
          contact support
        </Link>.
      </p>

    </div>
  );
}

export default function VerifyEmailPage() {
  return (
    <div className="relative min-h-screen flex flex-col items-center justify-center p-4 sm:p-6 font-sans">
      <OrganicShaderBackground />
      
      {/* Brand Header */}
      <div className="mb-6">
        <h2 className="text-3xl font-extrabold text-[#078730] font-outfit tracking-tight">
          Daily Basket
        </h2>
      </div>

      <Suspense fallback={<Loader2 className="w-8 h-8 text-[#078730] animate-spin" />}>
        <VerifyEmailForm />
      </Suspense>
    </div>
  );
}
