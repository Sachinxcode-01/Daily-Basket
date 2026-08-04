'use client';

import React, { Suspense } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { CheckCircle2, Loader2 } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';

function SuccessCard() {
  const router = useRouter();

  const handleContinue = () => {
    router.push('/');
  };

  return (
    <div className="w-full max-w-md bg-white border border-slate-100 rounded-[28px] p-8 sm:p-10 shadow-xl shadow-slate-200/50 animate-[fadeInUp_0.6s_ease-out] text-center">
      
      {/* Solid Green Checkmark Badge Icon */}
      <div className="flex justify-center mb-6">
        <div className="w-24 h-24 rounded-full bg-[#006823] flex items-center justify-center text-white shadow-lg shadow-[#006823]/25 animate-[bounce_2s_infinite]">
          <CheckCircle2 className="w-14 h-14 stroke-[2.5]" />
        </div>
      </div>

      {/* Heading */}
      <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-outfit mb-3">
        Email Verified Successfully
      </h1>

      {/* Subtitle */}
      <p className="text-slate-600 text-sm sm:text-base font-inter leading-relaxed mb-8">
        Your account has been confirmed.<br />
        You are ready to start shopping for<br />
        fresh, organic groceries.
      </p>

      {/* Primary Action Button: Continue to App */}
      <button
        type="button"
        onClick={handleContinue}
        className="w-full py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center transition-all duration-200"
      >
        Continue to App
      </button>

    </div>
  );
}

export default function SuccessPage() {
  return (
    <div className="relative min-h-screen flex flex-col items-center justify-center p-4 sm:p-6 font-sans">
      <OrganicShaderBackground />
      <Suspense fallback={<Loader2 className="w-8 h-8 text-[#078730] animate-spin" />}>
        <SuccessCard />
      </Suspense>
    </div>
  );
}
