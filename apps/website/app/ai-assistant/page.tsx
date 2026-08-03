'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Sparkles, Send, ShoppingBag, CheckCircle2, Zap } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';

export default function AiAssistantPage() {
  const [query, setQuery] = useState('');
  const [isSearching, setIsSearching] = useState(false);
  const [aiResult, setAiResult] = useState<{
    aiIntent: string;
    aiTip: string;
    suggestedProducts: Array<{ id: string; name: string; unit: string; price: number }>;
  } | null>({
    aiIntent: 'HEALTHY_SALAD_RECIPE',
    aiTip: 'Great choice! These fresh organic vegetables will make a nutrient-rich garden salad delivered in 10 minutes.',
    suggestedProducts: [
      { id: 'p1', name: 'Organic Farm Tomatoes', unit: '500g', price: 24 },
      { id: 'p4', name: 'Fresh Hydroponic Cucumbers', unit: '500g', price: 20 },
    ],
  });

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (!query) return;
    setIsSearching(true);
    setTimeout(() => {
      setAiResult({
        aiIntent: 'AI_RECIPE_BUNDLE',
        aiTip: `Found top items for "${query}". Optimized for instant 10-minute delivery.`,
        suggestedProducts: [
          { id: 'p1', name: 'Organic Farm Tomatoes', unit: '500g', price: 24 },
          { id: 'p2', name: 'Amul Fresh Toned Milk', unit: '1 Litre', price: 54 },
        ],
      });
      setIsSearching(false);
    }, 600);
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
          <Sparkles className="w-5 h-5 text-emerald-400 fill-emerald-400" />
          AI Grocery Assistant
        </h1>
        <div className="w-6" />
      </div>

      <div className="space-y-6">
        {/* Natural Language Prompt Input */}
        <form onSubmit={handleSearch} className="bg-slate-800/80 border border-slate-700/60 p-4 rounded-3xl flex items-center gap-3 shadow-xl">
          <Sparkles className="w-5 h-5 text-emerald-400 flex-shrink-0" />
          <input
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder='Try "Healthy salad under ₹100" or "Breakfast bundle"...'
            className="w-full bg-transparent text-sm text-white placeholder-slate-400 outline-none"
          />
          <button
            type="submit"
            disabled={isSearching}
            className="p-3 bg-emerald-600 hover:bg-emerald-500 text-white rounded-2xl flex-shrink-0 transition"
          >
            <Send className="w-4 h-4" />
          </button>
        </form>

        {/* AI Insight Response Box */}
        {aiResult && (
          <div className="bg-gradient-to-r from-slate-800 to-slate-900 border border-emerald-500/40 p-6 rounded-3xl space-y-4 shadow-xl">
            <div className="flex items-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wider">
              <Zap className="w-4 h-4" />
              <span>AI Recommendation Engine</span>
            </div>
            <p className="text-sm text-slate-200 leading-relaxed font-medium">{aiResult.aiTip}</p>

            {/* Suggested Products Bundle Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
              {aiResult.suggestedProducts.map((p) => (
                <div key={p.id} className="p-3.5 bg-slate-900/80 border border-slate-700/60 rounded-2xl flex items-center justify-between">
                  <div>
                    <h4 className="text-xs font-bold text-white">{p.name}</h4>
                    <p className="text-[10px] text-slate-400">{p.unit}</p>
                    <p className="text-xs font-extrabold text-emerald-400 mt-1">{formatCurrency(p.price)}</p>
                  </div>
                  <button className="px-3 py-1.5 bg-emerald-600/20 hover:bg-emerald-600 border border-emerald-500/50 text-emerald-400 hover:text-white font-bold text-xs rounded-xl transition">
                    + Add
                  </button>
                </div>
              ))}
            </div>

            <button className="w-full py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-lg transition flex items-center justify-center gap-2">
              <ShoppingBag className="w-4 h-4" />
              <span>Add Complete Bundle to Basket</span>
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
