'use client';

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Sparkles,
  Send,
  Mic,
  Bot,
  User,
  Zap,
  TrendingUp,
  Package,
  Bike,
  CheckCircle2,
  ArrowRight,
  RefreshCw,
  Copy,
  ThumbsUp,
} from 'lucide-react';
import Button from '../../components/ui/Button';
import Badge from '../../components/ui/Badge';

interface Message {
  id: string;
  sender: 'ai' | 'user';
  text: string;
  timestamp: string;
  suggestionAction?: {
    label: string;
    actionType: 'RESTOCK' | 'PRICE_SYNC' | 'FLEET_REALLOCATE';
    details: string;
  };
}

export default function AiCopilotPage() {
  const [query, setQuery] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [actionExecuted, setActionExecuted] = useState<string | null>(null);

  const [messages, setMessages] = useState<Message[]>([
    {
      id: 'msg-1',
      sender: 'ai',
      text: 'Good evening Sachin! I am your Daily Basket AI Copilot connected to real-time dark store telemetry, APMC wholesale mandi rates, and Ather EV fleet coordinates. How can I optimize store operations right now?',
      timestamp: '20:30',
    },
  ]);

  const handleSend = (textToSend?: string) => {
    const q = textToSend || query;
    if (!q.trim() || isTyping) return;

    const userMsg: Message = {
      id: `msg-${Date.now()}`,
      sender: 'user',
      text: q,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };

    setMessages((prev) => [...prev, userMsg]);
    setQuery('');
    setIsTyping(true);

    setTimeout(() => {
      let replyText = '';
      let suggestionAction: Message['suggestionAction'] = undefined;

      const lower = q.toLowerCase();
      if (lower.includes('avocado') || lower.includes('demand') || lower.includes('forecast')) {
        replyText =
          'Demand Forecast Analysis: Weekend orders for Organic Hass Avocados are projected to surge +24% in Koramangala and HSR Layout. Current dark store stock stands at 28 units (depletion expected by Saturday 11:00 AM).';
        suggestionAction = {
          label: 'Auto-Trigger Restock: 60 Units via Fresh Farm APMC',
          actionType: 'RESTOCK',
          details: 'PO #PO-9821 will be transmitted to Supplier ID: SUP-01.',
        };
      } else if (lower.includes('leak') || lower.includes('margin') || lower.includes('revenue')) {
        replyText =
          'Margin Intelligence: Gross margins in the Organic Dairy category improved to 26.4%, but produce spoilage in Leafy Greens caused a ₹1,420 loss in Indiranagar Hub. Recommend reducing spinach shelf buffer from 12 hours to 6 hours.';
        suggestionAction = {
          label: 'Apply Dynamic Shelf Buffer (6hr)',
          actionType: 'PRICE_SYNC',
          details: 'Adjusts replenishment batch sizes for perishable leafy greens.',
        };
      } else if (lower.includes('route') || lower.includes('rider') || lower.includes('fleet')) {
        replyText =
          'Fleet Optimization: Koramangala Hub is experiencing a surge (44 active orders, 9.8m avg SLA). Whitefield Hub has 6 idle EV riders with 91% battery. Reallocating 4 riders will restore sub-9.0 minute delivery promise.';
        suggestionAction = {
          label: 'Dispatch 4 Ather EVs to Koramangala Hub #01',
          actionType: 'FLEET_REALLOCATE',
          details: 'Riders RID-401, RID-404 notified on partner app.',
        };
      } else {
        replyText = `Telemetry Analysis: Store metrics healthy across 4 micro-hubs. Total GMV today is ₹48,250 with 98.6% 10-minute SLA adherence. Ready to assist with SKU updates, inventory alerts, or price changes.`;
      }

      setMessages((prev) => [
        ...prev,
        {
          id: `msg-${Date.now() + 1}`,
          sender: 'ai',
          text: replyText,
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
          suggestionAction,
        },
      ]);
      setIsTyping(false);
    }, 700);
  };

  const handleExecuteAction = (action: Message['suggestionAction']) => {
    if (!action) return;
    setActionExecuted(action.label);
    setTimeout(() => {
      setActionExecuted(null);
    }, 3000);
  };

  return (
    <div className="max-w-4xl mx-auto h-[82vh] flex flex-col space-y-4">
      {/* ─── Header ──────────────────────────────────────────────────────────── */}
      <div className="glass-card p-5 rounded-2xl border border-zinc-200/80 shadow-sm flex items-center justify-between shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#2d9d43] text-white flex items-center justify-center shadow-md">
            <Sparkles className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-lg font-bold text-zinc-950 font-headline">
                Store Operations AI Copilot
              </h1>
              <Badge variant="brand" pulse>
                Gemini Pro Live
              </Badge>
            </div>
            <p className="text-xs text-zinc-500 font-body">
              Grounded with real-time quick-commerce inventory, mandi rates & GPS fleet telemetry.
            </p>
          </div>
        </div>

        <div className="hidden sm:flex items-center gap-2 text-xs font-mono text-zinc-400">
          <span>Latency: 210ms</span>
          <span>•</span>
          <span className="text-[#078730]">Context Synced</span>
        </div>
      </div>

      {/* ─── Action Toast Banner ──────────────────────────────────────────────── */}
      <AnimatePresence>
        {actionExecuted && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="p-3.5 bg-emerald-50 border border-emerald-300 text-emerald-900 rounded-xl text-xs font-semibold flex items-center justify-between shadow-sm"
          >
            <div className="flex items-center gap-2">
              <CheckCircle2 className="w-4 h-4 text-[#2d9d43]" />
              <span>Executed: {actionExecuted}</span>
            </div>
            <span className="font-mono text-[10px] bg-emerald-200/60 px-2 py-0.5 rounded">
              Status: Applied
            </span>
          </motion.div>
        )}
      </AnimatePresence>

      {/* ─── Quick Prompt Chips ───────────────────────────────────────────────── */}
      <div className="flex gap-2 overflow-x-auto pb-1 shrink-0 hide-scrollbar">
        {[
          'Forecast Avocado & Dairy demand for weekend peak',
          'Identify top margin leakages across SKUs',
          'Reallocate idle electric fleet to Koramangala',
          'Simulate 60s Mandi wholesale rate sync',
        ].map((sug) => (
          <button
            key={sug}
            onClick={() => handleSend(sug)}
            className="px-3.5 py-1.5 bg-white hover:bg-zinc-50 text-zinc-700 hover:text-zinc-950 text-xs font-medium rounded-xl border border-zinc-200/80 shrink-0 shadow-2xs transition active:scale-95 flex items-center gap-1.5"
          >
            <Sparkles className="w-3 h-3 text-[#2d9d43]" />
            <span>{sug}</span>
          </button>
        ))}
      </div>

      {/* ─── Chat Messages Stream ─────────────────────────────────────────────── */}
      <div className="flex-1 bg-white p-6 rounded-2xl border border-zinc-200/80 shadow-sm overflow-y-auto space-y-5">
        {messages.map((m) => {
          const isUser = m.sender === 'user';
          return (
            <motion.div
              key={m.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className={`flex gap-3 ${isUser ? 'justify-end' : 'justify-start'}`}
            >
              {!isUser && (
                <div className="w-8 h-8 rounded-lg bg-[#2d9d43] text-white flex items-center justify-center shrink-0 mt-1 shadow-sm">
                  <Bot className="w-4 h-4" />
                </div>
              )}

              <div
                className={`p-4 rounded-2xl max-w-xl text-xs leading-relaxed space-y-2.5 ${
                  isUser
                    ? 'bg-[#2d9d43] text-white shadow-sm'
                    : 'bg-zinc-50/90 border border-zinc-200/70 text-zinc-800'
                }`}
              >
                <div className="flex items-center justify-between gap-4">
                  <span
                    className={`font-bold text-[10px] uppercase font-mono ${
                      isUser ? 'text-emerald-100' : 'text-zinc-400'
                    }`}
                  >
                    {isUser ? 'Admin' : 'Daily Basket Copilot'}
                  </span>
                  <span
                    className={`text-[10px] font-mono ${
                      isUser ? 'text-emerald-200' : 'text-zinc-400'
                    }`}
                  >
                    {m.timestamp}
                  </span>
                </div>

                <p className="font-body text-xs md:text-sm whitespace-pre-line">{m.text}</p>

                {/* AI Suggestion Interactive Action Card */}
                {m.suggestionAction && (
                  <div className="mt-3 p-3 bg-white rounded-xl border border-emerald-200/80 space-y-2 shadow-2xs">
                    <div className="flex items-center gap-1.5 text-[#078730] font-bold text-xs">
                      <Zap className="w-3.5 h-3.5" />
                      <span>Recommended Autonomous Action</span>
                    </div>
                    <p className="text-[11px] text-zinc-500 font-body">
                      {m.suggestionAction.details}
                    </p>
                    <Button
                      variant="brand"
                      size="xs"
                      onClick={() => handleExecuteAction(m.suggestionAction)}
                      rightIcon={<ArrowRight className="w-3 h-3" />}
                    >
                      {m.suggestionAction.label}
                    </Button>
                  </div>
                )}
              </div>

              {isUser && (
                <div className="w-8 h-8 rounded-lg bg-zinc-950 text-white flex items-center justify-center shrink-0 mt-1 shadow-sm font-bold text-xs">
                  AD
                </div>
              )}
            </motion.div>
          );
        })}

        {isTyping && (
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-lg bg-[#2d9d43] text-white flex items-center justify-center shrink-0 shadow-sm">
              <Bot className="w-4 h-4 animate-spin" />
            </div>
            <div className="p-3 bg-zinc-50 border border-zinc-200/70 rounded-2xl flex items-center gap-2">
              <span className="w-1.5 h-1.5 rounded-full bg-[#2d9d43] animate-ping" />
              <span className="text-xs text-zinc-500 font-medium">
                Gleaning dark store telemetry...
              </span>
            </div>
          </div>
        )}
      </div>

      {/* ─── Query Input Box ─────────────────────────────────────────────────── */}
      <div className="bg-white p-2.5 rounded-2xl border border-zinc-200/80 shadow-sm flex items-center gap-2 shrink-0">
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleSend()}
          placeholder="Ask Copilot: 'Restock avocados', 'Check peak SLA delay', 'Rider allocation'..."
          className="flex-1 px-4 py-2 bg-transparent text-xs md:text-sm text-zinc-900 placeholder-zinc-400 focus:outline-none"
        />
        <button
          title="Voice input simulated"
          className="p-2 text-zinc-400 hover:text-zinc-700 rounded-xl hover:bg-zinc-100 transition"
        >
          <Mic className="w-4 h-4" />
        </button>
        <Button
          variant="brand"
          size="sm"
          onClick={() => handleSend()}
          disabled={!query.trim() || isTyping}
          leftIcon={<Send className="w-3.5 h-3.5 text-white" />}
        >
          Ask
        </Button>
      </div>
    </div>
  );
}
