'use client';

import React, { useState } from 'react';
import { ArrowLeft, Sparkles, Send, Mic } from 'lucide-react';

// Google Stitch Specs: AI Business Copilot - Daily Basket Admin
// ID: 08e0fa2289074af1a38a365ced2fb035

export default function AiCopilotPage() {
  const [query, setQuery] = useState('');
  const [messages, setMessages] = useState([
    {
      sender: 'ai',
      text: 'Hello Admin! I am your Daily Basket AI Copilot powered by Gemini. How can I assist you with inventory forecasting or sales optimization today?',
    },
  ]);

  const handleSend = (textToSend?: string) => {
    const q = textToSend || query;
    if (!q.trim()) return;

    setMessages((prev) => [...prev, { sender: 'user', text: q }]);
    setQuery('');

    setTimeout(() => {
      setMessages((prev) => [
        ...prev,
        {
          sender: 'ai',
          text: `🤖 Analyzing Daily Basket telemetry for "${q}"... Forecast predicts a 15% surge in Avocado orders this weekend. Recommend restocking 40 units in WH-South.`,
        },
      ]);
    }, 600);
  };

  return (
    <div className="max-w-3xl mx-auto h-[80vh] flex flex-col font-sans">
      <div className="flex items-center gap-3 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm mb-4">
        <button className="p-2 rounded-xl hover:bg-[#f1f5f9] transition text-[#006837]">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="flex items-center gap-2">
          <Sparkles className="w-5 h-5 text-[#006837]" />
          <div>
            <h1 className="text-xl font-black text-[#006837]">AI Business Copilot</h1>
            <p className="text-xs text-[#64748b]">Google Stitch Screen ID: 08e0fa2289074af1a38a365ced2fb035</p>
          </div>
        </div>
      </div>

      <div className="flex gap-2 overflow-x-auto no-scrollbar pb-3">
        {[
          'Forecast Avocado demand',
          'Identify top revenue leaks',
          'Optimize Zone B rider routes',
        ].map((sug) => (
          <button
            key={sug}
            onClick={() => handleSend(sug)}
            className="px-3.5 py-1.5 bg-[#e6f4ea] text-[#006837] text-xs font-bold rounded-full border border-[#a7f3d0] shrink-0 hover:bg-[#d2ebd9]"
          >
            {sug}
          </button>
        ))}
      </div>

      <div className="flex-1 bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm overflow-y-auto space-y-4 mb-4">
        {messages.map((m, idx) => (
          <div
            key={idx}
            className={`flex ${m.sender === 'user' ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`p-4 rounded-3xl max-w-md text-xs leading-relaxed ${
                m.sender === 'user'
                  ? 'bg-[#006837] text-white'
                  : 'bg-[#f8fafc] border border-[#e2e8f0] text-[#1e2923]'
              }`}
            >
              {m.text}
            </div>
          </div>
        ))}
      </div>

      <div className="bg-white p-3 rounded-3xl border border-[#e2e8f0] shadow-sm flex items-center gap-2">
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleSend()}
          placeholder="Ask Copilot anything about inventory, sales..."
          className="flex-1 px-4 py-2 bg-transparent text-xs text-[#1e2923] outline-none"
        />
        <button className="p-2 text-[#64748b] hover:text-[#1e2923]">
          <Mic className="w-4 h-4" />
        </button>
        <button
          onClick={() => handleSend()}
          className="p-2.5 bg-[#006837] text-white rounded-2xl hover:bg-[#00522b]"
        >
          <Send className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
