'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  ArrowLeft,
  ShieldCheck,
  Smartphone,
  Laptop,
  LogOut,
  CheckCircle2,
  Lock,
  Key,
  Fingerprint,
  AlertTriangle,
  History,
  Download,
  ShieldAlert,
  Sparkles,
} from 'lucide-react';

interface ActiveSession {
  id: string;
  device: string;
  ip: string;
  location: string;
  isCurrent: boolean;
  lastActive: string;
}

interface SecurityAuditItem {
  id: string;
  event: string;
  time: string;
  ip: string;
  status: 'SUCCESS' | 'SUSPICIOUS';
}

export default function SecurityManagementPage() {
  const [sessions, setSessions] = useState<ActiveSession[]>([
    {
      id: 'sess_1',
      device: 'Pixel 8 Pro (Flutter App)',
      ip: '157.34.12.8',
      location: 'Bengaluru, India',
      isCurrent: true,
      lastActive: 'Just now',
    },
    {
      id: 'sess_2',
      device: 'Chrome Web (Windows 11)',
      ip: '157.34.12.9',
      location: 'Bengaluru, India',
      isCurrent: false,
      lastActive: '2 hours ago',
    },
  ]);

  const [twoFactorEnabled, setTwoFactorEnabled] = useState(true);
  const [biometricEnabled, setBiometricEnabled] = useState(true);
  const [revokedMessage, setRevokedMessage] = useState<string | null>(null);

  const [auditLog] = useState<SecurityAuditItem[]>([
    {
      id: 'evt_1',
      event: 'Session Authenticated via Biometrics',
      time: 'Just now',
      ip: '157.34.12.8',
      status: 'SUCCESS',
    },
    {
      id: 'evt_2',
      event: 'CSRF & Security Headers Validated (Edge Middleware)',
      time: '12m ago',
      ip: '157.34.12.8',
      status: 'SUCCESS',
    },
    {
      id: 'evt_3',
      event: 'High-Security HTTPS Handshake (TLS 1.3)',
      time: '1h ago',
      ip: '157.34.12.8',
      status: 'SUCCESS',
    },
    {
      id: 'evt_4',
      event: 'Blocked External Reconnaissance Probe',
      time: '6h ago',
      ip: '45.134.20.11',
      status: 'SUSPICIOUS',
    },
  ]);

  const showNotification = (msg: string) => {
    setRevokedMessage(msg);
    setTimeout(() => setRevokedMessage(null), 3000);
  };

  const revokeSession = (id: string) => {
    setSessions((prev: ActiveSession[]) => prev.filter((s: ActiveSession) => s.id !== id));
    showNotification('Device session revoked successfully.');
  };

  const revokeAll = () => {
    setSessions((prev: ActiveSession[]) => prev.filter((s: ActiveSession) => s.isCurrent));
    showNotification('Logged out across all other devices.');
  };

  const handleExportSecurityLog = () => {
    const headers = ['Event ID,Event Name,Timestamp,IP Address,Status'];
    const rows = auditLog.map((l) => `"${l.id}","${l.event}","${l.time}","${l.ip}","${l.status}"`);
    const csvContent = 'data:text/csv;charset=utf-8,' + [headers, ...rows].join('\n');
    const link = document.createElement('a');
    link.setAttribute('href', encodeURI(csvContent));
    link.setAttribute('download', `daily_basket_security_audit_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    showNotification('Security audit trail exported.');
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-20 max-w-4xl mx-auto font-sans">
      {/* Top Header */}
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Store</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white flex items-center gap-2">
          <ShieldCheck className="w-5 h-5 text-emerald-400" />
          Security & Privacy Center
        </h1>
        <div className="w-6" />
      </div>

      <div className="space-y-6">
        {/* Status Notification */}
        {revokedMessage && (
          <div className="p-4 bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 rounded-2xl flex items-center gap-2 text-xs font-bold animate-in fade-in">
            <CheckCircle2 className="w-4 h-4 shrink-0" />
            <span>{revokedMessage}</span>
          </div>
        )}

        {/* Security Shield Header Card */}
        <div className="bg-gradient-to-r from-emerald-900/60 to-teal-900/40 border border-emerald-500/40 p-6 rounded-3xl shadow-xl flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wider mb-1">
              <Lock className="w-4 h-4" />
              <span>Cloudflare Hardened & CSP Protected</span>
            </div>
            <h2 className="text-2xl font-black text-white">High Security Hygiene</h2>
            <p className="text-xs text-emerald-200 mt-1">
              Content-Security-Policy (CSP), Strict HSTS, Anti-CSRF edge middleware, and TLS 1.3 active.
            </p>
          </div>
          <div className="w-14 h-14 rounded-2xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400 shrink-0">
            <ShieldCheck className="w-8 h-8" />
          </div>
        </div>

        {/* Security Controls Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {/* Two-Factor Authentication Toggle */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-3xl flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-emerald-500/10 text-emerald-400 rounded-2xl border border-emerald-500/20">
                <Key className="w-5 h-5" />
              </div>
              <div>
                <h4 className="font-bold text-sm text-white">Two-Factor Authentication</h4>
                <p className="text-xs text-slate-400 mt-0.5">Hardware & SMS OTP verification</p>
              </div>
            </div>
            <button
              onClick={() => {
                const next = !twoFactorEnabled;
                setTwoFactorEnabled(next);
                showNotification(`Two-Factor Authentication ${next ? 'enabled' : 'disabled'}.`);
              }}
              className={`w-12 h-6 flex items-center rounded-full p-1 transition ${
                twoFactorEnabled ? 'bg-emerald-500 justify-end' : 'bg-slate-700 justify-start'
              }`}
            >
              <div className="bg-white w-4 h-4 rounded-full shadow-md" />
            </button>
          </div>

          {/* Biometric Passkey / WebAuthn Toggle */}
          <div className="bg-slate-800/80 border border-slate-700/60 p-5 rounded-3xl flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-purple-500/10 text-purple-400 rounded-2xl border border-purple-500/20">
                <Fingerprint className="w-5 h-5" />
              </div>
              <div>
                <h4 className="font-bold text-sm text-white">Biometric Passkey</h4>
                <p className="text-xs text-slate-400 mt-0.5">TouchID / Windows Hello sign-in</p>
              </div>
            </div>
            <button
              onClick={() => {
                const next = !biometricEnabled;
                setBiometricEnabled(next);
                showNotification(`Biometric Passkey sign-in ${next ? 'enabled' : 'disabled'}.`);
              }}
              className={`w-12 h-6 flex items-center rounded-full p-1 transition ${
                biometricEnabled ? 'bg-emerald-500 justify-end' : 'bg-slate-700 justify-start'
              }`}
            >
              <div className="bg-white w-4 h-4 rounded-full shadow-md" />
            </button>
          </div>
        </div>

        {/* Active Logged-In Sessions */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-6 rounded-3xl space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-white">Active Device Sessions ({sessions.length})</h3>
            <button
              onClick={revokeAll}
              className="text-xs font-bold text-rose-400 hover:text-rose-300 flex items-center gap-1 transition"
            >
              <LogOut className="w-3.5 h-3.5" />
              <span>Log Out All Other Devices</span>
            </button>
          </div>

          <div className="space-y-3">
            {sessions.map((sess: ActiveSession) => (
              <div
                key={sess.id}
                className="p-4 bg-slate-900/70 rounded-2xl border border-slate-700/60 flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <div className="p-2.5 bg-slate-800 rounded-xl text-emerald-400">
                    {sess.device.includes('Chrome') ? (
                      <Laptop className="w-5 h-5" />
                    ) : (
                      <Smartphone className="w-5 h-5" />
                    )}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <h4 className="text-xs font-bold text-white">{sess.device}</h4>
                      {sess.isCurrent && (
                        <span className="text-[10px] bg-emerald-500/20 text-emerald-400 px-2 py-0.5 rounded-full font-bold">
                          Current Device
                        </span>
                      )}
                    </div>
                    <p className="text-[11px] text-slate-400 mt-0.5">
                      {sess.ip} • {sess.location} • {sess.lastActive}
                    </p>
                  </div>
                </div>

                {!sess.isCurrent && (
                  <button
                    onClick={() => revokeSession(sess.id)}
                    className="px-3 py-1.5 bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border border-rose-500/30 rounded-xl text-xs font-bold transition"
                  >
                    Revoke
                  </button>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Security Audit Trail */}
        <div className="bg-slate-800/80 border border-slate-700/60 p-6 rounded-3xl space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <History className="w-5 h-5 text-emerald-400" />
              <h3 className="text-base font-bold text-white">Recent Security Audit Events</h3>
            </div>
            <button
              onClick={handleExportSecurityLog}
              className="text-xs font-bold text-slate-400 hover:text-white flex items-center gap-1 transition"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Export Log</span>
            </button>
          </div>

          <div className="divide-y divide-slate-700/60">
            {auditLog.map((log) => (
              <div key={log.id} className="py-3 flex items-center justify-between text-xs">
                <div className="flex items-center gap-2.5">
                  {log.status === 'SUCCESS' ? (
                    <span className="w-2 h-2 rounded-full bg-emerald-400" />
                  ) : (
                    <span className="w-2 h-2 rounded-full bg-rose-400" />
                  )}
                  <div>
                    <p className="font-semibold text-slate-200">{log.event}</p>
                    <p className="text-[10px] text-slate-400 font-mono mt-0.5">
                      IP: {log.ip} • {log.time}
                    </p>
                  </div>
                </div>
                <span
                  className={`px-2 py-0.5 rounded text-[10px] font-mono font-bold ${
                    log.status === 'SUCCESS'
                      ? 'bg-emerald-500/10 text-emerald-400'
                      : 'bg-rose-500/10 text-rose-400'
                  }`}
                >
                  {log.status}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
