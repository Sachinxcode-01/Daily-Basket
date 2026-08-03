'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, ShieldCheck, Smartphone, Laptop, LogOut, CheckCircle2, Lock } from 'lucide-react';

interface ActiveSession {
  id: string;
  device: string;
  ip: string;
  location: string;
  isCurrent: boolean;
  lastActive: string;
}

export default function SecurityManagementPage() {
  const [sessions, setSessions] = useState<ActiveSession[]>([
    { id: 'sess_1', device: 'Pixel 8 Pro (Flutter App)', ip: '157.34.12.8', location: 'Bengaluru, India', isCurrent: true, lastActive: 'Just now' },
    { id: 'sess_2', device: 'Chrome Web (Windows 11)', ip: '157.34.12.9', location: 'Bengaluru, India', isCurrent: false, lastActive: '2 hours ago' },
  ]);

  const [revokedMessage, setRevokedMessage] = useState<string | null>(null);

  const revokeSession = (id: string) => {
    setSessions((prev: ActiveSession[]) => prev.filter((s: ActiveSession) => s.id !== id));
    setRevokedMessage('Device session revoked successfully.');
    setTimeout(() => setRevokedMessage(null), 3000);
  };

  const revokeAll = () => {
    setSessions((prev: ActiveSession[]) => prev.filter((s: ActiveSession) => s.isCurrent));
    setRevokedMessage('Logged out across all other devices.');
    setTimeout(() => setRevokedMessage(null), 3000);
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 p-4 pb-20 max-w-4xl mx-auto">
      {/* Top Header */}
      <div className="flex items-center justify-between py-4 border-b border-slate-800 mb-6">
        <Link href="/" className="flex items-center gap-2 text-slate-300 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span className="font-bold text-sm">Back to Store</span>
        </Link>
        <h1 className="text-lg font-extrabold text-white flex items-center gap-2">
          <ShieldCheck className="w-5 h-5 text-emerald-400" />
          Security & Active Sessions
        </h1>
        <div className="w-6" />
      </div>

      <div className="space-y-6">
        {/* Status Notification */}
        {revokedMessage && (
          <div className="p-4 bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 rounded-2xl flex items-center gap-2 text-xs font-bold animate-fade-in">
            <CheckCircle2 className="w-4 h-4" />
            <span>{revokedMessage}</span>
          </div>
        )}

        {/* Security Shield Header Card */}
        <div className="bg-gradient-to-r from-emerald-900/60 to-teal-900/40 border border-emerald-500/40 p-6 rounded-3xl shadow-xl flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wider mb-1">
              <Lock className="w-4 h-4" />
              <span>Security Shield Active</span>
            </div>
            <h2 className="text-2xl font-black text-white">256-Bit SSL Encrypted</h2>
            <p className="text-xs text-emerald-200 mt-1">Razorpay HMAC SHA-256 Signature Verification Enabled</p>
          </div>
          <div className="w-14 h-14 rounded-2xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400">
            <ShieldCheck className="w-8 h-8" />
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
              <div key={sess.id} className="p-4 bg-slate-900/70 rounded-2xl border border-slate-700/60 flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-2.5 bg-slate-800 rounded-xl text-emerald-400">
                    {sess.device.includes('Chrome') ? <Laptop className="w-5 h-5" /> : <Smartphone className="w-5 h-5" />}
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
                    <p className="text-[11px] text-slate-400 mt-0.5">{sess.ip} • {sess.location} • {sess.lastActive}</p>
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
      </div>
    </div>
  );
}
