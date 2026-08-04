'use client';

import React, { useState } from 'react';
import { Settings, Save, ShieldCheck, Bell, Store, Key, Lock } from 'lucide-react';

export default function SystemSettingsPage() {
  const [settings, setSettings] = useState({
    darkStoreRadiusKm: '3.5',
    maxPackingSlaMins: '3',
    surgeMultiplier: '1.2',
    enableAutoReplenishment: true,
    mfaRequired: true,
    apiWebhookUrl: 'https://api.dailybasket.app/webhooks/orders',
  });

  return (
    <div className="space-y-8 max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-[#e2e2e5] pb-6">
        <div>
          <h1 className="text-2xl md:text-3xl font-extrabold text-[#1a1c1e] tracking-tight">System Settings</h1>
          <p className="text-sm text-[#3f4a3d]">Configure dark store operating parameters, dispatch SLAs, and security webhooks.</p>
        </div>

        <div className="flex items-center gap-3">
          <button className="inline-flex items-center gap-2 px-6 py-2.5 bg-[#006b23] text-white rounded-xl text-xs font-bold hover:bg-[#078730] transition active:scale-95 shadow-sm">
            <Save className="w-4 h-4" />
            <span>Save Configurations</span>
          </button>
        </div>
      </div>

      {/* Settings Grid */}
      <div className="space-y-6">
        {/* Dark Store Parameters */}
        <div className="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] space-y-4">
          <div className="flex items-center gap-2 text-[#006b23]">
            <Store className="w-5 h-5" />
            <h2 className="text-lg font-bold text-[#1a1c1e]">Dark Store Operating Parameters</h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
            <div>
              <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">Delivery Radius (km)</label>
              <input
                type="text"
                value={settings.darkStoreRadiusKm}
                onChange={(e) => setSettings({ ...settings, darkStoreRadiusKm: e.target.value })}
                className="w-full px-3.5 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-bold"
              />
            </div>

            <div>
              <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">Max Packing SLA (mins)</label>
              <input
                type="text"
                value={settings.maxPackingSlaMins}
                onChange={(e) => setSettings({ ...settings, maxPackingSlaMins: e.target.value })}
                className="w-full px-3.5 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-bold"
              />
            </div>

            <div>
              <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">Surge Pricing Multiplier</label>
              <input
                type="text"
                value={settings.surgeMultiplier}
                onChange={(e) => setSettings({ ...settings, surgeMultiplier: e.target.value })}
                className="w-full px-3.5 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-bold"
              />
            </div>
          </div>
        </div>

        {/* Security & Webhook */}
        <div className="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] space-y-4">
          <div className="flex items-center gap-2 text-[#006b23]">
            <Key className="w-5 h-5" />
            <h2 className="text-lg font-bold text-[#1a1c1e]">Integrations & Webhooks</h2>
          </div>

          <div className="space-y-4 pt-2">
            <div>
              <label className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider block mb-1">Production Webhook Endpoint</label>
              <input
                type="text"
                value={settings.apiWebhookUrl}
                onChange={(e) => setSettings({ ...settings, apiWebhookUrl: e.target.value })}
                className="w-full px-3.5 py-2 bg-[#f3f3f6] border border-transparent rounded-xl text-sm font-mono font-bold"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
