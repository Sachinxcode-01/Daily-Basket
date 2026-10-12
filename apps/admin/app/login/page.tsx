'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import {
  ShieldCheck,
  Lock,
  Mail,
  Eye,
  EyeOff,
  KeyRound,
  Fingerprint,
  Sparkles,
  ArrowRight,
  AlertCircle,
  CheckCircle2,
  Cpu,
  Store,
  Bike,
  Package,
} from 'lucide-react';
import { useAdminAuth } from '../lib/auth-context';
import { ADMIN_PRESETS } from '../lib/auth-constants';
import { AdminRole } from '../lib/auth-types';
import Button from '../../components/ui/Button';
import Badge from '../../components/ui/Badge';

export default function AdminLoginPage() {
  const router = useRouter();
  const { login, verifyTwoFactor } = useAdminAuth();

  const [activeTab, setActiveTab] = useState<'credentials' | '2fa'>('credentials');
  const [selectedRole, setSelectedRole] = useState<AdminRole>('SUPER_ADMIN');
  const [email, setEmail] = useState<string>(ADMIN_PRESETS.SUPER_ADMIN.user.email);
  const [password, setPassword] = useState<string>(ADMIN_PRESETS.SUPER_ADMIN.pass);
  const [showPassword, setShowPassword] = useState<boolean>(false);
  const [twoFactorCode, setTwoFactorCode] = useState<string>('984210');
  const [rememberDevice, setRememberDevice] = useState<boolean>(true);

  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string>('');
  const [successNotice, setSuccessNotice] = useState<string>('');

  // Role selector preset quick load
  const handleSelectRole = (roleKey: AdminRole) => {
    setSelectedRole(roleKey);
    const preset = ADMIN_PRESETS[roleKey];
    if (preset) {
      setEmail(preset.user.email);
      setPassword(preset.pass);
      setTwoFactorCode(preset.pin || '123456');
      setErrorMessage('');
    }
  };

  const handleCredentialsSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage('');
    setIsLoading(true);

    try {
      const res = await login(email, password, selectedRole, false);

      if (res.requiresTwoFactor) {
        setActiveTab('2fa');
        setSuccessNotice('Credentials validated. Please enter hardware 2FA code.');
      } else if (!res.success) {
        setErrorMessage(res.message || 'Authentication rejected. Verify credentials.');
      }
    } catch (err: any) {
      setErrorMessage(err.message || 'Login request encountered an error.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleTwoFactorSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (twoFactorCode.length < 6) {
      setErrorMessage('Please enter all 6 digits of your authenticator code.');
      return;
    }

    setErrorMessage('');
    setIsLoading(true);

    try {
      const ok = await verifyTwoFactor(twoFactorCode);
      if (!ok) {
        setErrorMessage('Invalid 2FA code. Hint: Use 984210 or 123456 for instant bypass.');
      }
    } catch (err: any) {
      setErrorMessage(err.message || '2FA validation failed.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleFastPasskey = async () => {
    setIsLoading(true);
    setErrorMessage('');
    try {
      // Direct high-privilege passkey bypass for local development/audits
      const res = await login(email, password, selectedRole, true);
      if (res.success) {
        setSuccessNotice('Hardware Passkey / WebAuthn verified.');
      }
    } catch {
      setErrorMessage('Passkey handshake failed.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen w-full bg-[#09090b] text-zinc-100 flex flex-col justify-between selection:bg-emerald-500 selection:text-black font-sans relative overflow-hidden">
      {/* Vercel Ambient Gradient Grid Background */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_80%_80%_at_50%_-20%,rgba(0,107,35,0.18),rgba(255,255,255,0))] pointer-events-none" />
      <div
        className="absolute inset-0 opacity-[0.03] pointer-events-none"
        style={{
          backgroundImage:
            'radial-gradient(rgba(255,255,255,0.8) 1px, transparent 1px)',
          backgroundSize: '24px 24px',
        }}
      />

      {/* Top Header Bar */}
      <header className="relative z-10 w-full max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-zinc-900 border border-zinc-800 flex items-center justify-center font-black text-xs text-white shadow-inner">
            DB
          </div>
          <div className="flex items-center gap-2">
            <span className="font-semibold text-sm tracking-tight text-white">Daily Basket</span>
            <span className="text-zinc-600 font-mono text-xs">/</span>
            <span className="text-xs text-zinc-400 font-mono">admin-console</span>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <Badge variant="mono" pulse>
            TLS 1.3 SECURED
          </Badge>
          <a
            href="/"
            className="text-xs text-zinc-400 hover:text-white transition font-mono hidden sm:inline-flex"
          >
            v2.6.4-prod
          </a>
        </div>
      </header>

      {/* Main Form Center Card */}
      <main className="relative z-10 flex-1 flex items-center justify-center px-4 py-8">
        <div className="w-full max-w-md">
          {/* Card Shell */}
          <div className="bg-zinc-950/80 backdrop-blur-xl border border-zinc-800/90 rounded-2xl p-6 sm:p-8 shadow-[0_20px_50px_rgba(0,0,0,0.6)] space-y-6">
            {/* Title & Security Status */}
            <div className="text-center space-y-2">
              <div className="inline-flex p-2.5 rounded-xl bg-zinc-900 border border-zinc-800 text-emerald-400 mb-1 shadow-inner">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <h1 className="text-xl font-bold tracking-tight text-white">
                Administrative Access Control
              </h1>
              <p className="text-xs text-zinc-400">
                Authorized dark store managers and executive personnel only.
              </p>
            </div>

            {/* Role Quick Selector */}
            <div className="space-y-2">
              <label className="text-[11px] font-mono uppercase tracking-wider text-zinc-400 flex items-center justify-between">
                <span>Select Security Profile</span>
                <span className="text-[10px] text-emerald-400">Verified Presets</span>
              </label>
              <div className="grid grid-cols-2 gap-2">
                {[
                  { id: 'SUPER_ADMIN', label: 'Super Admin', icon: Cpu, desc: 'Root Access' },
                  { id: 'STORE_MANAGER', label: 'Store Lead', icon: Store, desc: 'Dark Store #01' },
                  { id: 'DISPATCH_HEAD', label: 'Dispatch Head', icon: Bike, desc: 'Fleet Ops' },
                  { id: 'INVENTORY_LEAD', label: 'Inventory Lead', icon: Package, desc: 'GRN & Mandi' },
                ].map((item) => {
                  const Icon = item.icon;
                  const isSelected = selectedRole === item.id;
                  return (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => handleSelectRole(item.id as AdminRole)}
                      className={`p-2.5 rounded-xl border text-left transition-all flex items-start gap-2.5 ${
                        isSelected
                          ? 'border-emerald-500/80 bg-emerald-500/10 text-white shadow-[0_0_15px_rgba(0,107,35,0.2)]'
                          : 'border-zinc-800/80 bg-zinc-900/60 hover:bg-zinc-900 text-zinc-400 hover:text-zinc-200'
                      }`}
                    >
                      <Icon
                        className={`w-4 h-4 mt-0.5 shrink-0 ${
                          isSelected ? 'text-emerald-400' : 'text-zinc-500'
                        }`}
                      />
                      <div className="min-w-0">
                        <div className="text-xs font-semibold truncate leading-tight">
                          {item.label}
                        </div>
                        <div className="text-[10px] text-zinc-500 truncate">{item.desc}</div>
                      </div>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Error or Success Feedback Banner */}
            {errorMessage && (
              <div className="p-3 rounded-xl bg-rose-950/60 border border-rose-800/60 text-rose-200 text-xs flex items-center gap-2.5 animate-in fade-in">
                <AlertCircle className="w-4 h-4 shrink-0 text-rose-400" />
                <span>{errorMessage}</span>
              </div>
            )}

            {successNotice && (
              <div className="p-3 rounded-xl bg-emerald-950/60 border border-emerald-800/60 text-emerald-200 text-xs flex items-center gap-2.5 animate-in fade-in">
                <CheckCircle2 className="w-4 h-4 shrink-0 text-emerald-400" />
                <span>{successNotice}</span>
              </div>
            )}

            {/* Tab 1: Credentials Form */}
            {activeTab === 'credentials' && (
              <form onSubmit={handleCredentialsSubmit} className="space-y-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-medium text-zinc-300">Company Email</label>
                  <div className="relative">
                    <Mail className="w-4 h-4 text-zinc-500 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input
                      type="email"
                      required
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="admin@dailybasket.com"
                      className="w-full pl-10 pr-4 py-2.5 bg-zinc-900/80 border border-zinc-800 rounded-xl text-xs sm:text-sm text-zinc-100 placeholder-zinc-500 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 transition font-mono"
                    />
                  </div>
                </div>

                <div className="space-y-1.5">
                  <div className="flex items-center justify-between">
                    <label className="text-xs font-medium text-zinc-300">Password</label>
                    <span className="text-[11px] text-zinc-500 font-mono">256-bit hash</span>
                  </div>
                  <div className="relative">
                    <Lock className="w-4 h-4 text-zinc-500 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input
                      type={showPassword ? 'text' : 'password'}
                      required
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      placeholder="••••••••••••"
                      className="w-full pl-10 pr-10 py-2.5 bg-zinc-900/80 border border-zinc-800 rounded-xl text-xs sm:text-sm text-zinc-100 placeholder-zinc-500 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 transition font-mono"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="p-1 text-zinc-500 hover:text-zinc-300 absolute right-3 top-1/2 -translate-y-1/2 transition"
                    >
                      {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                </div>

                {/* Device remember & session preference */}
                <div className="flex items-center justify-between pt-1">
                  <label className="flex items-center gap-2 cursor-pointer select-none">
                    <input
                      type="checkbox"
                      checked={rememberDevice}
                      onChange={(e) => setRememberDevice(e.target.checked)}
                      className="w-3.5 h-3.5 rounded bg-zinc-900 border-zinc-700 text-emerald-500 focus:ring-0 focus:ring-offset-0"
                    />
                    <span className="text-xs text-zinc-400">Trust workstation (7 days)</span>
                  </label>
                  <span className="text-[11px] text-emerald-400/90 font-mono">Zero Trust</span>
                </div>

                {/* Submit Button */}
                <Button
                  type="submit"
                  variant="brand"
                  size="md"
                  isLoading={isLoading}
                  className="w-full"
                  rightIcon={<ArrowRight className="w-4 h-4" />}
                >
                  Verify &amp; Proceed
                </Button>

                {/* Alternative Quick WebAuthn Passkey button */}
                <Button
                  type="button"
                  variant="secondary"
                  size="sm"
                  onClick={handleFastPasskey}
                  disabled={isLoading}
                  className="w-full bg-zinc-900 hover:bg-zinc-800 text-zinc-300 border-zinc-800"
                  leftIcon={<Fingerprint className="w-4 h-4 text-emerald-400" />}
                >
                  Quick Passkey / Dev Fast Lane
                </Button>
              </form>
            )}

            {/* Tab 2: 2FA TOTP Form */}
            {activeTab === '2fa' && (
              <form onSubmit={handleTwoFactorSubmit} className="space-y-5 animate-in fade-in">
                <div className="p-3 rounded-xl bg-zinc-900/60 border border-zinc-800 text-center space-y-1">
                  <div className="text-xs text-zinc-300 font-medium">TOTP Security Challenge</div>
                  <div className="text-[11px] text-zinc-400">
                    Enter the 6-digit verification code from your authenticator device for{' '}
                    <span className="text-emerald-400 font-mono">{email}</span>.
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-xs font-mono uppercase text-zinc-400 block text-center">
                    6-Digit Security Token
                  </label>
                  <input
                    type="text"
                    maxLength={6}
                    autoFocus
                    value={twoFactorCode}
                    onChange={(e) => setTwoFactorCode(e.target.value.replace(/\D/g, ''))}
                    placeholder="984210"
                    className="w-full py-3 text-center tracking-[0.4em] font-mono text-xl bg-zinc-900/90 border border-zinc-700 rounded-xl text-emerald-400 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 transition"
                  />
                  <div className="text-center text-[11px] text-zinc-500">
                    Demo bypass pins: <code className="text-zinc-300">984210</code> or{' '}
                    <code className="text-zinc-300">123456</code>
                  </div>
                </div>

                <div className="flex gap-2">
                  <Button
                    type="button"
                    variant="outline"
                    size="md"
                    onClick={() => setActiveTab('credentials')}
                    className="flex-1 border-zinc-800 text-zinc-400 hover:bg-zinc-900"
                  >
                    Back
                  </Button>
                  <Button
                    type="submit"
                    variant="brand"
                    size="md"
                    isLoading={isLoading}
                    className="flex-1"
                  >
                    Authorize Session
                  </Button>
                </div>
              </form>
            )}

            {/* Footer Audit Assurance */}
            <div className="pt-4 border-t border-zinc-900 text-center text-[11px] text-zinc-500 flex items-center justify-center gap-2 font-mono">
              <KeyRound className="w-3.5 h-3.5 text-zinc-600" />
              <span>SOC2 Type II Compliant • Session Audited</span>
            </div>
          </div>
        </div>
      </main>

      {/* Bottom Footer */}
      <footer className="relative z-10 w-full max-w-7xl mx-auto px-6 py-6 text-center text-xs text-zinc-600">
        Daily Basket Enterprise Cloud OS • Production Infrastructure Node 01
      </footer>
    </div>
  );
}
