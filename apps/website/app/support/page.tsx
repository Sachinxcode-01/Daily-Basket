'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  MessageSquare,
  Phone,
  Mail,
  Headphones,
  CheckCircle2,
  Clock,
  ShieldAlert,
  ArrowRight,
  Send,
  HelpCircle,
  FileQuestion,
  Sparkles,
} from 'lucide-react';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';

export default function SupportDeskPage() {
  const [formData, setFormData] = useState({
    name: '',
    emailOrPhone: '',
    category: 'account',
    orderId: '',
    message: '',
  });

  const [submittedTicket, setSubmittedTicket] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setTimeout(() => {
      const generatedId = `TKT-${Math.floor(10000 + Math.random() * 90000)}`;
      setSubmittedTicket(generatedId);
      setIsSubmitting(false);
    }, 600);
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-inter">
      <HeaderNavBar />

      <main className="flex-1 max-w-4xl w-full mx-auto px-4 sm:px-6 py-8 sm:py-12">
        {/* Header */}
        <div className="text-center max-w-2xl mx-auto mb-10">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-50 text-[#006b23] text-xs font-bold font-outfit uppercase tracking-wider mb-4 border border-emerald-200/60">
            <Headphones className="w-3.5 h-3.5" />
            <span>24/7 Priority Assistance</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 font-outfit tracking-tight">
            Daily Basket Support Desk
          </h1>
          <p className="text-sm text-slate-600 mt-2">
            Need help with account access, delivery status, refunds, or quality guarantees? We are here for you.
          </p>
        </div>

        {/* Channels Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-10">
          <div className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:border-emerald-300 transition flex flex-col justify-between">
            <div>
              <div className="w-10 h-10 rounded-xl bg-emerald-50 text-[#006b23] flex items-center justify-center mb-3">
                <MessageSquare className="w-5 h-5" />
              </div>
              <h2 className="text-sm font-bold text-slate-900 font-outfit">Live Chat Support</h2>
              <p className="text-xs text-slate-500 mt-1">Chat directly with a support specialist in under 60 seconds.</p>
            </div>
            <div className="pt-4 mt-4 border-t border-slate-100">
              <span className="text-[11px] font-bold text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-full">
                Active Now • 24/7
              </span>
            </div>
          </div>

          <div className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:border-emerald-300 transition flex flex-col justify-between">
            <div>
              <div className="w-10 h-10 rounded-xl bg-emerald-50 text-[#006b23] flex items-center justify-center mb-3">
                <Phone className="w-5 h-5" />
              </div>
              <h2 className="text-sm font-bold text-slate-900 font-outfit">Toll-Free Helpline</h2>
              <p className="text-xs text-slate-500 mt-1">Priority phone line for urgent delivery or address questions.</p>
            </div>
            <div className="pt-4 mt-4 border-t border-slate-100">
              <a
                href="tel:18001232275"
                className="text-xs font-bold text-slate-900 hover:text-[#006b23] font-outfit"
              >
                1800-123-BASKET
              </a>
            </div>
          </div>

          <div className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:border-emerald-300 transition flex flex-col justify-between">
            <div>
              <div className="w-10 h-10 rounded-xl bg-emerald-50 text-[#006b23] flex items-center justify-center mb-3">
                <Mail className="w-5 h-5" />
              </div>
              <h2 className="text-sm font-bold text-slate-900 font-outfit">Email Support</h2>
              <p className="text-xs text-slate-500 mt-1">Send us an email for documentation, invoices, or escalation.</p>
            </div>
            <div className="pt-4 mt-4 border-t border-slate-100">
              <a
                href="mailto:support@dailybasket.com"
                className="text-xs font-bold text-slate-900 hover:text-[#006b23] font-outfit"
              >
                support@dailybasket.com
              </a>
            </div>
          </div>
        </div>

        {/* Ticket Submission Form */}
        <div className="bg-white rounded-3xl p-6 sm:p-8 border border-slate-200/80 shadow-md mb-10">
          {submittedTicket ? (
            <div className="text-center py-8 space-y-4">
              <div className="w-16 h-16 rounded-full bg-emerald-100 text-[#006b23] flex items-center justify-center mx-auto">
                <CheckCircle2 className="w-8 h-8" />
              </div>
              <h2 className="text-2xl font-bold text-slate-900 font-outfit">Ticket Received Successfully!</h2>
              <p className="text-sm text-slate-600 max-w-md mx-auto">
                Your support reference number is <strong className="font-mono text-[#006b23]">{submittedTicket}</strong>. Our priority team will contact you via email or phone within 15 minutes.
              </p>
              <div className="pt-4 flex flex-wrap justify-center gap-3">
                <button
                  onClick={() => {
                    setSubmittedTicket(null);
                    setFormData({ name: '', emailOrPhone: '', category: 'account', orderId: '', message: '' });
                  }}
                  className="px-5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold font-outfit transition"
                >
                  Submit Another Query
                </button>
                <Link
                  href="/"
                  className="px-5 py-2.5 bg-[#006b23] hover:bg-[#00531a] text-white rounded-xl text-xs font-bold font-outfit transition"
                >
                  Return to Home
                </Link>
              </div>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-5">
              <div className="border-b border-slate-100 pb-4">
                <h2 className="text-lg font-bold text-slate-900 font-outfit">Open a Support Request</h2>
                <p className="text-xs text-slate-500 mt-0.5">
                  Fill in your details below and an agent will assist immediately.
                </p>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 font-outfit mb-1.5">
                    Your Name *
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="e.g. Rahul Sharma"
                    className="w-full h-11 px-4 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 focus:outline-none focus:border-[#006b23] focus:ring-2 focus:ring-[#006b23]/10"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 font-outfit mb-1.5">
                    Email or Mobile Number *
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.emailOrPhone}
                    onChange={(e) => setFormData({ ...formData, emailOrPhone: e.target.value })}
                    placeholder="e.g. rahul@example.com or 9876543210"
                    className="w-full h-11 px-4 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 focus:outline-none focus:border-[#006b23] focus:ring-2 focus:ring-[#006b23]/10"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 font-outfit mb-1.5">
                    Issue Category *
                  </label>
                  <select
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    className="w-full h-11 px-4 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 focus:outline-none focus:border-[#006b23] focus:ring-2 focus:ring-[#006b23]/10"
                  >
                    <option value="account">Account Access & Security Lock</option>
                    <option value="delivery">10-Minute Delivery Delay</option>
                    <option value="missing">Missing / Damaged Item in Basket</option>
                    <option value="payment">Payment / Refund / UPI Issue</option>
                    <option value="quality">Freshness / Quality Dispute</option>
                    <option value="other">General Feedback / Inquiry</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 font-outfit mb-1.5">
                    Order ID (Optional)
                  </label>
                  <input
                    type="text"
                    value={formData.orderId}
                    onChange={(e) => setFormData({ ...formData, orderId: e.target.value })}
                    placeholder="e.g. ORD-9824"
                    className="w-full h-11 px-4 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 focus:outline-none focus:border-[#006b23] focus:ring-2 focus:ring-[#006b23]/10 uppercase font-mono"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 font-outfit mb-1.5">
                  How can we help you? *
                </label>
                <textarea
                  required
                  rows={4}
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  placeholder="Describe your issue or question in detail..."
                  className="w-full p-4 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 focus:outline-none focus:border-[#006b23] focus:ring-2 focus:ring-[#006b23]/10 resize-none"
                />
              </div>

              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full h-12 bg-[#006b23] hover:bg-[#00531a] active:scale-98 text-white font-bold text-sm rounded-xl shadow-md transition-all flex items-center justify-center gap-2 font-outfit disabled:opacity-50"
              >
                <Send className="w-4 h-4" />
                <span>{isSubmitting ? 'Submitting Request...' : 'Submit Support Ticket'}</span>
              </button>
            </form>
          )}
        </div>

        {/* Knowledgebase Links Strip */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <Link
            href="/help"
            className="p-4 bg-white rounded-2xl border border-slate-200/80 hover:border-emerald-300 transition-all flex items-center justify-between group"
          >
            <div>
              <h3 className="text-xs font-bold text-slate-900 font-outfit group-hover:text-[#006b23]">
                Help Center FAQs
              </h3>
              <p className="text-[11px] text-slate-500 mt-0.5">Read quick answers to frequent questions.</p>
            </div>
            <ArrowRight className="w-4 h-4 text-slate-400 group-hover:text-[#006b23] transition-transform group-hover:translate-x-1" />
          </Link>

          <Link
            href="/tracking"
            className="p-4 bg-white rounded-2xl border border-slate-200/80 hover:border-emerald-300 transition-all flex items-center justify-between group"
          >
            <div>
              <h3 className="text-xs font-bold text-slate-900 font-outfit group-hover:text-[#006b23]">
                Live Order Tracking
              </h3>
              <p className="text-[11px] text-slate-500 mt-0.5">Locate your active grocery delivery.</p>
            </div>
            <ArrowRight className="w-4 h-4 text-slate-400 group-hover:text-[#006b23] transition-transform group-hover:translate-x-1" />
          </Link>

          <Link
            href="/status"
            className="p-4 bg-white rounded-2xl border border-slate-200/80 hover:border-emerald-300 transition-all flex items-center justify-between group"
          >
            <div>
              <h3 className="text-xs font-bold text-slate-900 font-outfit group-hover:text-[#006b23]">
                System Status
              </h3>
              <p className="text-[11px] text-slate-500 mt-0.5">Check live API & dispatch network health.</p>
            </div>
            <ArrowRight className="w-4 h-4 text-slate-400 group-hover:text-[#006b23] transition-transform group-hover:translate-x-1" />
          </Link>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-slate-200/80 py-8 px-4 text-center text-xs text-slate-500">
        <p>© 2026 Daily Basket Quick-Commerce Suite. 24/7 Dedicated Customer Resolution.</p>
      </footer>
    </div>
  );
}
