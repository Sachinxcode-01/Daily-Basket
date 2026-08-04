'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ShoppingBasket, Mail, Lock, Eye, EyeOff, ArrowRight, AlertCircle, Loader2 } from 'lucide-react';
import OrganicShaderBackground from '../../../components/auth/OrganicShaderBackground';
import { GoogleGLogo } from '../../../components/auth/AnimatedIcons';
import { apiClient } from '@daily-basket/api-client';
import { useAuthStore } from '../../../store/useAuthStore';

export default function LoginPage() {
  const router = useRouter();
  const setAuth = useAuthStore((state) => state.setAuth);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleEmailSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !email.includes('@')) {
      setErrorMsg('Please enter a valid email address.');
      return;
    }
    if (!password) {
      setErrorMsg('Please enter your password.');
      return;
    }
    setIsLoading(true);
    setErrorMsg('');
    try {
      const res = await apiClient.loginEmail({ email, pass: password });
      setAuth(res.user, res.accessToken || res.token || 'demo_jwt_token');
      router.push('/success');
    } catch (err: any) {
      setErrorMsg(err.message || 'Invalid email or password.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    setIsLoading(true);
    setErrorMsg('');
    try {
      const res = await apiClient.googleOAuthLogin('mock_google_id_token');
      setAuth(res.user, res.accessToken || res.token || 'demo_google_token');
      router.push('/success');
    } catch (err: any) {
      setErrorMsg('Google login failed.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="relative min-h-screen flex flex-col items-center justify-center p-4 sm:p-6 font-sans">
      {/* Organic Moving Canvas Background */}
      <OrganicShaderBackground />

      <div className="w-full max-w-md bg-white border border-slate-100 rounded-[28px] p-6 sm:p-9 shadow-xl shadow-slate-200/50 animate-[fadeInUp_0.6s_ease-out]">
        
        {/* Brand Header: Green Circular Badge + Daily Basket Text */}
        <div className="flex items-center gap-3 mb-8">
          <div className="w-11 h-11 rounded-full bg-[#078730] flex items-center justify-center text-white shadow-md shadow-[#078730]/20">
            <ShoppingBasket className="w-6 h-6 stroke-[2.2]" />
          </div>
          <h2 className="text-2xl font-extrabold tracking-tight text-[#078730] font-outfit">
            Daily Basket
          </h2>
        </div>

        {/* Title & Subtitle */}
        <div className="mb-8">
          <h1 className="text-3xl font-extrabold text-slate-900 font-outfit mb-2">
            Welcome back
          </h1>
          <p className="text-slate-600 text-sm sm:text-base font-inter">
            Enter your details to access your account.
          </p>
        </div>

        {/* Error Notification */}
        {errorMsg && (
          <div className="mb-6 p-3.5 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3 text-red-600 text-sm font-medium">
            <AlertCircle className="w-5 h-5 flex-shrink-0" />
            <span>{errorMsg}</span>
          </div>
        )}

        {/* EMAIL LOGIN FORM */}
        <form onSubmit={handleEmailSubmit} className="space-y-5">
          
          {/* Email Address Field */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2 font-outfit">
              EMAIL ADDRESS
            </label>
            <div className="relative flex items-center">
              <Mail className="absolute left-4 w-5 h-5 text-slate-500" />
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="name@example.com"
                className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3.5 pl-12 pr-4 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
                disabled={isLoading}
              />
            </div>
          </div>

          {/* Password Field */}
          <div>
            <div className="flex justify-between items-center mb-2">
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider font-outfit">
                PASSWORD
              </label>
              <Link
                href="/forgot-password"
                className="text-xs font-bold text-[#078730] hover:underline transition font-outfit"
              >
                Forgot Password?
              </Link>
            </div>
            <div className="relative flex items-center">
              <Lock className="absolute left-4 w-5 h-5 text-slate-500" />
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full bg-[#E5EFE7]/80 border border-slate-300/60 focus:border-[#078730] focus:bg-white focus:ring-2 focus:ring-[#078730]/20 rounded-xl py-3.5 pl-12 pr-12 text-slate-800 font-medium placeholder-slate-400 outline-none transition-all duration-200"
                disabled={isLoading}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-4 text-slate-500 hover:text-slate-700 transition"
              >
                {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
          </div>

          {/* Primary Pill Button: Login -> */}
          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-4 bg-[#006823] hover:bg-[#00531a] active:scale-[0.98] text-white font-bold text-base rounded-full shadow-md shadow-[#006823]/20 flex items-center justify-center gap-2.5 transition-all duration-200 disabled:opacity-50"
          >
            {isLoading ? (
              <Loader2 className="w-5 h-5 animate-spin" />
            ) : (
              <>
                <span>Login</span>
                <ArrowRight className="w-5 h-5 stroke-[2.2]" />
              </>
            )}
          </button>
        </form>

        {/* Divider */}
        <div className="relative flex items-center justify-center my-6">
          <div className="border-t border-slate-200 w-full" />
          <span className="bg-white px-3 text-xs text-slate-400 font-bold uppercase tracking-wider font-outfit">
            OR
          </span>
          <div className="border-t border-slate-200 w-full" />
        </div>

        {/* Official 4-Color Google OAuth Button */}
        <button
          type="button"
          onClick={handleGoogleLogin}
          disabled={isLoading}
          className="w-full py-3.5 bg-white border border-slate-200 hover:bg-slate-50 active:scale-[0.98] text-slate-800 font-bold text-sm rounded-full shadow-xs flex items-center justify-center gap-3 transition-all duration-200"
        >
          <GoogleGLogo className="w-5 h-5" />
          <span>Continue with Google</span>
        </button>

        {/* Footer Link: Don't have an account? Sign up */}
        <div className="mt-8 text-center text-sm font-medium text-slate-600 font-inter">
          Don't have an account?{' '}
          <Link
            href="/register"
            className="text-[#078730] font-bold hover:underline transition font-outfit text-base ml-1"
          >
            Sign up
          </Link>
        </div>

      </div>
    </div>
  );
}
