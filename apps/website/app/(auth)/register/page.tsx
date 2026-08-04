'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { User, Mail, Lock, Eye, EyeOff, Loader2, AlertCircle } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';
import { apiClient } from '@daily-basket/api-client';

export default function RegisterPage() {
  const router = useRouter();

  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg('');

    if (!fullName.trim()) {
      setErrorMsg('Please enter your full name.');
      return;
    }
    if (!email || !email.includes('@')) {
      setErrorMsg('Please enter a valid email address.');
      return;
    }
    if (!password || password.length < 6) {
      setErrorMsg('Password must be at least 6 characters long.');
      return;
    }
    if (password !== confirmPassword) {
      setErrorMsg('Passwords do not match.');
      return;
    }

    setIsLoading(true);
    try {
      await apiClient.registerEmail({
        email,
        pass: password,
        name: fullName,
      });
      // Navigate to email verification screen
      router.push(`/verify-email?email=${encodeURIComponent(email)}`);
    } catch (err: any) {
      setErrorMsg(err.message || 'Failed to create account. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="relative min-h-screen flex flex-col items-center justify-center p-4 sm:p-6 font-sans">
      {/* Real-time Organic Shader Background */}
      <OrganicShaderBackground />

      {/* Main Card Container with Fade-In-Up Motion */}
      <div className="w-full max-w-md bg-white/80 backdrop-blur-xl border border-white/60 rounded-3xl p-6 sm:p-8 shadow-xl shadow-emerald-950/5 animate-[fadeInUp_0.6s_ease-out]">
        
        {/* Branded Touchpoint: Logo Container */}
        <div className="flex flex-col items-center mb-6">
          <div className="w-16 h-16 rounded-2xl bg-white border border-slate-100 shadow-md flex items-center justify-center p-2 mb-3">
            <img
              src="/images/daily_basket_logo.png"
              alt="Daily Basket Logo"
              className="w-12 h-12 object-contain"
              onError={(e) => {
                // Fallback SVG icon if logo asset missing
                (e.target as HTMLElement).style.display = 'none';
              }}
            />
          </div>
          <h2 className="text-2xl font-bold tracking-tight text-[#078730] font-outfit">
            Daily Basket
          </h2>
        </div>

        {/* Heading & Subtitle */}
        <div className="text-center mb-6">
          <h1 className="text-3xl font-extrabold text-slate-900 font-outfit mb-2">
            Create Account
          </h1>
          <p className="text-slate-500 text-sm sm:text-base font-inter">
            Join us to start filling your basket with fresh, organic goods.
          </p>
        </div>

        {/* Error Alert */}
        {errorMsg && (
          <div className="mb-5 p-3.5 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3 text-red-600 text-sm font-medium">
            <AlertCircle className="w-5 h-5 flex-shrink-0" />
            <span>{errorMsg}</span>
          </div>
        )}

        {/* Registration Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          
          {/* Full Name Field */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-outfit">
              Full Name
            </label>
            <div className="relative flex items-center">
              <User className="absolute left-4 w-5 h-5 text-slate-400" />
              <input
                type="text"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                placeholder="Jane Doe"
                className="w-full bg-slate-50/80 border border-slate-200 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-2xl py-3.5 pl-12 pr-4 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
                disabled={isLoading}
              />
            </div>
          </div>

          {/* Email Address Field */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-outfit">
              Email Address
            </label>
            <div className="relative flex items-center">
              <Mail className="absolute left-4 w-5 h-5 text-slate-400" />
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="jane@example.com"
                className="w-full bg-slate-50/80 border border-slate-200 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-2xl py-3.5 pl-12 pr-4 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
                disabled={isLoading}
              />
            </div>
          </div>

          {/* Password Field */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-outfit">
              Password
            </label>
            <div className="relative flex items-center">
              <Lock className="absolute left-4 w-5 h-5 text-slate-400" />
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full bg-slate-50/80 border border-slate-200 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-2xl py-3.5 pl-12 pr-12 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
                disabled={isLoading}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-4 text-slate-400 hover:text-slate-600 transition"
              >
                {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
          </div>

          {/* Confirm Password Field */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-outfit">
              Confirm Password
            </label>
            <div className="relative flex items-center">
              <Lock className="absolute left-4 w-5 h-5 text-slate-400" />
              <input
                type={showPassword ? 'text' : 'password'}
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full bg-slate-50/80 border border-slate-200 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-2xl py-3.5 pl-12 pr-4 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
                disabled={isLoading}
              />
            </div>
          </div>

          {/* Primary High-Contrast Button with Active Scale Effect */}
          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-4 mt-2 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-base rounded-2xl shadow-lg shadow-[#006823]/25 flex items-center justify-center gap-2 transition-all duration-200 disabled:opacity-50"
          >
            {isLoading ? (
              <Loader2 className="w-5 h-5 animate-spin" />
            ) : (
              <span>Create Account</span>
            )}
          </button>
        </form>

        {/* Footer Link */}
        <div className="mt-6 text-center text-sm font-medium text-slate-600">
          Already have an account?{' '}
          <Link
            href="/login"
            className="text-[#006823] font-bold hover:underline transition"
          >
            Log in
          </Link>
        </div>

      </div>
    </div>
  );
}
