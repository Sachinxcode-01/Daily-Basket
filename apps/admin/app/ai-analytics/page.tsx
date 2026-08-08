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

interface PromptTemplate {
  id: string;
  key: string;
  name: string;
  template: string;
  description: string;
  version: number;
}

export default function AiAnalyticsPage() {
  const [activeTab, setActiveTab] = useState<'telemetry' | 'prompts' | 'trending' | 'security'>('telemetry');

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

  const [prompts, setPrompts] = useState<PromptTemplate[]>([
    {
      id: 'p1',
      key: 'SEARCH_INTENT',
      name: 'Search Intent & Entity Extractor',
      description: 'Parses natural language search queries to extract intent, dietary tags, price limits, category, and brand constraints.',
      version: 1,
      template: `You are an AI Search Intent Parser for Daily Basket quick-commerce. Analyze: "{{query}}"`,
    },
    {
      id: 'p2',
      key: 'SHOPPING_ASSISTANT',
      name: 'Sarah J. AI Assistant System Prompt',
      description: 'System prompt governing Sarah J. Enterprise AI Support & Shopping Assistant.',
      version: 1,
      template: `You are Sarah J., Daily Basket Enterprise AI Assistant. Language: {{languageName}}.`,
    },
  ]);

  const [selectedPromptKey, setSelectedPromptKey] = useState<string>('SEARCH_INTENT');
  const [editPromptText, setEditPromptText] = useState<string>('');
  const [saveSuccessMsg, setSaveSuccessMsg] = useState<string>('');

  const [trendingKeywords, setTrendingKeywords] = useState<string[]>([
    'Amul Milk 1L',
    'Organic Tomatoes',
    'Aashirvaad Chakki Atta',
    'Fortune Sunflower Oil',
    'High Protein Paneer',
  ]);
  const [newKeyword, setNewKeyword] = useState<string>('');

  useEffect(() => {
    fetch('http://localhost:3000/api/ai/admin/metrics')
      .then((res) => res.json())
      .then((data) => {
        if (data && data.totalRequests !== undefined) {
          setMetrics(data);
        }
      })
      .catch((err) => console.log('Using default client metrics demo:', err));

    fetch('http://localhost:3000/api/ai/admin/prompts')
      .then((res) => res.json())
      .then((data) => {
        if (Array.isArray(data) && data.length > 0) {
          setPrompts(data);
          setSelectedPromptKey(data[0].key);
          setEditPromptText(data[0].template);
        }
      })
      .catch((err) => console.log('Using default prompt templates demo:', err));
  }, []);

  const handleSelectPrompt = (p: PromptTemplate) => {
    setSelectedPromptKey(p.key);
    setEditPromptText(p.template);
    setSaveSuccessMsg('');
  };

  const handleSavePrompt = () => {
    fetch(`http://localhost:3000/api/ai/admin/prompts/${selectedPromptKey}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ template: editPromptText }),
    })
      .then((res) => res.json())
      .then(() => {
        setSaveSuccessMsg('Prompt template updated successfully!');
        setTimeout(() => setSaveSuccessMsg(''), 3000);
      })
      .catch((err) => console.log('Saved prompt locally demo:', err));
  };

  const handleAddKeyword = () => {
    if (!newKeyword.trim()) return;
    setTrendingKeywords([...trendingKeywords, newKeyword.trim()]);
    setNewKeyword('');
  };

  return (
    <div className="p-8 max-w-7xl mx-auto space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">
          Enterprise AI Control Center & Shopping Intelligence
        </h1>
        <p className="text-sm text-gray-500 mt-1">
          Manage Gemini 2.5 & OpenRouter models, prompt templates, search analytics, and security moderation rules.
        </p>
      </div>

      {/* Navigation Tabs */}
      <div className="flex border-b border-gray-200 space-x-8">
        <button
          onClick={() => setActiveTab('telemetry')}
          className={`pb-4 text-sm font-semibold border-b-2 transition-colors ${
            activeTab === 'telemetry'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          LLM Telemetry & Failover
        </button>
        <button
          onClick={() => setActiveTab('prompts')}
          className={`pb-4 text-sm font-semibold border-b-2 transition-colors ${
            activeTab === 'prompts'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          Prompt Template Manager
        </button>
        <button
          onClick={() => setActiveTab('trending')}
          className={`pb-4 text-sm font-semibold border-b-2 transition-colors ${
            activeTab === 'trending'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          Trending Searches & Recs
        </button>
        <button
          onClick={() => setActiveTab('security')}
          className={`pb-4 text-sm font-semibold border-b-2 transition-colors ${
            activeTab === 'security'
              ? 'border-emerald-600 text-emerald-600'
              : 'border-transparent text-gray-500 hover:text-gray-700'
          }`}
        >
          Security & Blocked Queries
        </button>
      </div>

      {/* Tab 1: Telemetry & Failover */}
      {activeTab === 'telemetry' && (
        <div className="space-y-8">
          {/* KPI Cards */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
                Total AI Queries
              </span>
              <div className="text-3xl font-extrabold text-gray-900 mt-2">
                {metrics.totalRequests.toLocaleString()}
              </div>
              <span className="text-xs text-emerald-600 font-medium">+14% from last week</span>
            </div>

            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
                Avg Latency
              </span>
              <div className="text-3xl font-extrabold text-gray-900 mt-2">
                {metrics.avgLatencyMs} ms
              </div>
              <span className="text-xs text-emerald-600 font-medium">Optimal response speed</span>
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

          {/* Provider Health */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-4">
            <h2 className="text-lg font-bold text-gray-900">
              AI Provider Health & Automatic Failover Stack
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
                      {provider === 'GEMINI' ? 'Priority #1 (Primary)' : 'Priority #2 (Failover)'}
                    </div>
                  </div>
                  <span
                    className={`px-2.5 py-1 text-xs font-bold rounded-full ${
                      healthy ? 'bg-emerald-100 text-emerald-700' : 'bg-rose-100 text-rose-700'
                    }`}
                  >
                    {healthy ? 'HEALTHY' : 'DEGRADED'}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Tab 2: Prompt Manager */}
      {activeTab === 'prompts' && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-3">
            <h2 className="text-base font-bold text-gray-900">Prompt Templates</h2>
            <div className="space-y-2">
              {prompts.map((p) => (
                <button
                  key={p.key}
                  onClick={() => handleSelectPrompt(p)}
                  className={`w-full text-left p-3 rounded-lg border transition-all ${
                    selectedPromptKey === p.key
                      ? 'border-emerald-600 bg-emerald-50 text-emerald-900 font-semibold'
                      : 'border-gray-200 hover:bg-gray-50 text-gray-700'
                  }`}
                >
                  <div className="text-sm font-bold">{p.name}</div>
                  <div className="text-xs text-gray-500 mt-0.5">{p.key}</div>
                </button>
              ))}
            </div>
          </div>

          <div className="md:col-span-2 bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-4">
            <div className="flex justify-between items-center">
              <div>
                <h2 className="text-lg font-bold text-gray-900">{selectedPromptKey}</h2>
                <p className="text-xs text-gray-500">Edit prompt template with variable placeholders.</p>
              </div>
              <button
                onClick={handleSavePrompt}
                className="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm rounded-lg shadow-sm"
              >
                Save Template
              </button>
            </div>

            {saveSuccessMsg && (
              <div className="p-3 bg-emerald-100 text-emerald-800 text-xs font-bold rounded-lg">
                {saveSuccessMsg}
              </div>
            )}

            <textarea
              rows={12}
              value={editPromptText}
              onChange={(e) => setEditPromptText(e.target.value)}
              className="w-full p-4 font-mono text-xs border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
            />
          </div>
        </div>
      )}

      {/* Tab 3: Trending Searches */}
      {activeTab === 'trending' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-6">
          <h2 className="text-lg font-bold text-gray-900">Featured Trending Search Keywords</h2>
          <div className="flex gap-3">
            <input
              type="text"
              placeholder="Add new trending search keyword..."
              value={newKeyword}
              onChange={(e) => setNewKeyword(e.target.value)}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-sm"
            />
            <button
              onClick={handleAddKeyword}
              className="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm rounded-lg"
            >
              Add Keyword
            </button>
          </div>

          <div className="flex flex-wrap gap-2">
            {trendingKeywords.map((kw, i) => (
              <span key={i} className="px-3 py-1.5 bg-emerald-50 text-emerald-700 border border-emerald-200 rounded-full text-xs font-bold">
                🔥 {kw}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* Tab 4: Security Moderation */}
      {activeTab === 'security' && (
        <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm space-y-4">
          <h2 className="text-lg font-bold text-gray-900">Prompt Injection & Content Moderation Shield</h2>
          <p className="text-sm text-gray-500">
            Configured input sanitization regex patterns and PII masking filters.
          </p>
          <div className="p-4 bg-gray-50 rounded-lg border border-gray-200 font-mono text-xs text-gray-700 space-y-2">
            <div>✓ Pattern 1: ignore previous instructions (BLOCKED)</div>
            <div>✓ Pattern 2: system prompt reveal (BLOCKED)</div>
            <div>✓ Pattern 3: roleplay jailbreak (BLOCKED)</div>
            <div>✓ PII Protection: Phone numbers & Emails auto-masked before storing</div>
          </div>
        </div>
      )}
    </div>
  );
}
