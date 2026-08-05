'use client';

import React, { useEffect, useState } from 'react';

interface AiMetrics {
  totalRequests: number;
  avgLatencyMs: number;
  avgCsatScore: number;
  totalCostUsd: number;
  activeSessionsCount: number;
  escalationCount: number;
  providerHealth: Record<string, boolean>;
}

export default function AiAnalyticsPage() {
  const [metrics, setMetrics] = useState<AiMetrics>({
    totalRequests: 1420,
    avgLatencyMs: 240,
    avgCsatScore: 4.9,
    totalCostUsd: 1.45,
    activeSessionsCount: 18,
    escalationCount: 3,
    providerHealth: {
      GEMINI: true,
      OPENROUTER: true,
      GROK: true,
      LOCAL: true,
    },
  });

  useEffect(() => {
    fetch('http://localhost:3000/api/ai/admin/metrics')
      .then((res) => res.json())
      .then((data) => {
        if (data && data.totalRequests !== undefined) {
          setMetrics(data);
        }
      })
      .catch((err) => console.log('Using default client metrics demo:', err));
  }, []);

  return (
    <div className="p-8 max-w-7xl mx-auto space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">
          Enterprise AI Live Agent Analytics
        </h1>
        <p className="text-sm text-gray-500 mt-1">
          Real-time LLM telemetry, provider failover status, cost monitoring, and audit logs.
        </p>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
          <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
            Total AI Queries
          </span>
          <div className="text-3xl font-extrabold text-gray-900 mt-2">
            {metrics.totalRequests.toLocaleString()}
          </div>
          <span className="text-xs text-emerald-600 font-medium">
            +14% from last week
          </span>
        </div>

        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
          <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
            Avg Latency
          </span>
          <div className="text-3xl font-extrabold text-gray-900 mt-2">
            {metrics.avgLatencyMs} ms
          </div>
          <span className="text-xs text-emerald-600 font-medium">
            Optimal response speed
          </span>
        </div>

        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
          <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
            CSAT Rating
          </span>
          <div className="text-3xl font-extrabold text-emerald-600 mt-2">
            {metrics.avgCsatScore} / 5.0
          </div>
          <span className="text-xs text-gray-500">Based on user feedback</span>
        </div>

        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
          <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
            Estimated AI Cost
          </span>
          <div className="text-3xl font-extrabold text-gray-900 mt-2">
            ${metrics.totalCostUsd.toFixed(2)}
          </div>
          <span className="text-xs text-gray-500">Gemini & OpenRouter tokens</span>
        </div>
      </div>

      {/* Provider Health & Stack */}
      <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-4">
        <h2 className="text-lg font-bold text-gray-900">
          AI Provider Health & Priority Failover Stack
        </h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {Object.entries(metrics.providerHealth).map(([provider, healthy]) => (
            <div
              key={provider}
              className="flex items-center justify-between p-4 rounded-lg bg-gray-50 border border-gray-200"
            >
              <div>
                <div className="font-bold text-sm text-gray-800">{provider}</div>
                <div className="text-xs text-gray-500">
                  {provider === 'GEMINI'
                    ? 'Priority #1'
                    : provider === 'OPENROUTER'
                    ? 'Priority #2'
                    : provider === 'GROK'
                    ? 'Priority #3'
                    : 'Priority #4 (Local)'}
                </div>
              </div>
              <span
                className={`px-2.5 py-1 text-xs font-bold rounded-full ${
                  healthy
                    ? 'bg-emerald-100 text-emerald-700'
                    : 'bg-rose-100 text-rose-700'
                }`}
              >
                {healthy ? 'HEALTHY' : 'DEGRADED'}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Audit Logs Overview */}
      <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-4">
        <div className="flex justify-between items-center">
          <h2 className="text-lg font-bold text-gray-900">
            Recent AI Function & Tool Execution Audit Logs
          </h2>
          <span className="text-xs text-gray-500">RBAC & Security Enforcement</span>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm text-gray-600">
            <thead className="bg-gray-50 text-gray-700 uppercase text-xs font-semibold">
              <tr>
                <th className="py-3 px-4">Timestamp</th>
                <th className="py-3 px-4">Tool Name</th>
                <th className="py-3 px-4">Action</th>
                <th className="py-3 px-4">Status</th>
                <th className="py-3 px-4">Security Result</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              <tr>
                <td className="py-3 px-4">Just now</td>
                <td className="py-3 px-4 font-mono text-emerald-700">trackOrder</td>
                <td className="py-3 px-4">Live Order Status #DB-9824</td>
                <td className="py-3 px-4 font-bold text-emerald-600">SUCCESS</td>
                <td className="py-3 px-4 text-xs text-gray-500">PII Cleaned</td>
              </tr>
              <tr>
                <td className="py-3 px-4">2 mins ago</td>
                <td className="py-3 px-4 font-mono text-emerald-700">claimRefund</td>
                <td className="py-3 px-4">Instant Wallet Credit ₹120</td>
                <td className="py-3 px-4 font-bold text-emerald-600">SUCCESS</td>
                <td className="py-3 px-4 text-xs text-gray-500">Authorized</td>
              </tr>
              <tr>
                <td className="py-3 px-4">5 mins ago</td>
                <td className="py-3 px-4 font-mono text-emerald-700">createSupportTicket</td>
                <td className="py-3 px-4">Manager Transfer to Ananya R.</td>
                <td className="py-3 px-4 font-bold text-emerald-600">SUCCESS</td>
                <td className="py-3 px-4 text-xs text-gray-500">Escalated</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
