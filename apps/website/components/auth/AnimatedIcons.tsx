'use client';

import React from 'react';
import { Check, Mail, Settings, Lock } from 'lucide-react';

/**
 * Official 4-Color Google G Logo SVG
 */
export function GoogleGLogo({ className = 'w-5 h-5' }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24">
      <path
        fill="#4285F4"
        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
      />
      <path
        fill="#34A853"
        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
      />
      <path
        fill="#FBBC05"
        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"
      />
      <path
        fill="#EA4335"
        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"
      />
    </svg>
  );
}

/**
 * Line-art Green Envelope with Flying Paper Plane & Dashed Flight Path
 * Matching user screenshot mockup exactly!
 */
export function EnvelopeWithPaperPlane() {
  return (
    <div className="relative flex items-center justify-center w-40 h-36 my-2">
      {/* Background Soft Glow */}
      <div className="absolute w-32 h-32 rounded-full bg-emerald-100/60 blur-2xl animate-pulse" />

      <div className="relative w-full h-full flex flex-col items-center justify-center">
        {/* Paper Plane Flying */}
        <div className="absolute top-2 right-6 animate-[bounce_2.5s_easeInOut_infinite]">
          {/* Dashed trajectory line */}
          <svg className="absolute -left-8 top-4 w-10 h-6 overflow-visible pointer-events-none">
            <path
              d="M 0 12 Q 15 2, 30 0"
              fill="none"
              stroke="#078730"
              strokeWidth="1.5"
              strokeDasharray="3 3"
              opacity="0.6"
            />
          </svg>
          {/* Green paper plane icon */}
          <svg className="w-8 h-8 text-[#078730]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="m3 3 3 9 9 3-9 3-3 9 18-12Z" />
            <path d="M6 12h9" />
          </svg>
        </div>

        {/* Green Line-Art Envelope */}
        <div className="mt-8 text-[#078730]">
          <svg className="w-24 h-20" viewBox="0 0 64 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
            <rect x="2" y="6" width="60" height="38" rx="6" />
            <path d="M4 8 L32 28 L60 8" />
            <path d="M4 42 L22 24" />
            <path d="M60 42 L42 24" />
          </svg>
        </div>
      </div>
    </div>
  );
}

/**
 * Success Screen: Animated checkmark icon with pop-in and glowing ripple ring
 */
export function AnimatedCheckmark() {
  return (
    <div className="relative flex items-center justify-center w-24 h-24 my-2">
      <div className="absolute inset-0 rounded-full bg-emerald-500/20 animate-ping opacity-75" />
      <div className="absolute inset-2 rounded-full bg-gradient-to-br from-emerald-400/30 to-lime-500/20 border border-emerald-500/40 blur-xs" />
      <div className="relative w-16 h-16 rounded-full bg-gradient-to-tr from-emerald-600 to-emerald-500 text-white flex items-center justify-center shadow-lg shadow-emerald-600/30 transform transition-transform duration-500 hover:scale-110">
        <Check className="w-9 h-9 stroke-[3] animate-[bounce_1.5s_infinite]" />
      </div>
    </div>
  );
}

/**
 * Email Verification: Animated floating envelope with bobbing & glow
 */
export function FloatingEnvelope() {
  return <EnvelopeWithPaperPlane />;
}

/**
 * Security Flow: Animated rotating security gear icon with central lock symbol
 */
export function RotatingSecurityGear() {
  return (
    <div className="relative flex items-center justify-center w-28 h-28 my-2">
      <div className="absolute w-20 h-20 text-emerald-500/40 animate-[spin_10s_linear_infinite]">
        <Settings className="w-full h-full stroke-[1.5]" />
      </div>
      <div className="relative w-14 h-14 rounded-2xl bg-gradient-to-tr from-emerald-600 to-lime-600 text-white flex items-center justify-center shadow-lg shadow-emerald-700/25">
        <Lock className="w-7 h-7 stroke-[2.5]" />
      </div>
    </div>
  );
}
