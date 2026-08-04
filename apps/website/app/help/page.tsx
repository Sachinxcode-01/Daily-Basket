'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowLeft, Search, Package, RefreshCw, CreditCard, User, ChevronDown, MessageSquare, PhoneCall } from 'lucide-react';

interface FAQItem {
  question: string;
  answer: string;
}

const faqs: FAQItem[] = [
  {
    question: 'How fast is Daily Basket delivery?',
    answer: 'Daily Basket delivers fresh groceries within 10 to 15 minutes in selected service areas through our hyper-local micro-fulfillment dark stores.',
  },
  {
    question: 'What is the return & refund policy for fresh produce?',
    answer: 'We offer a 100% no-questions-asked instant refund or replacement at your doorstep if you are unsatisfied with the freshness or quality of any delivered item.',
  },
  {
    question: 'What payment methods are supported?',
    answer: 'We accept UPI (Google Pay, PhonePe, Paytm), Credit/Debit cards, Net Banking, and Cash/UPI on delivery.',
  },
  {
    question: 'How do I cancel or modify my active order?',
    answer: 'Because orders are packed within 2 minutes of placement, you can cancel directly from the order tracking screen within 60 seconds of placing it.',
  },
];

export default function HelpPage() {
  const [openFaq, setOpenFaq] = useState<number | null>(0);
  const [searchQuery, setSearchQuery] = useState('');

  const toggleFaq = (index: number) => {
    setOpenFaq(openFaq === index ? null : index);
  };

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl sm:text-2xl font-extrabold text-slate-900 font-outfit">
              Help Center & Support
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-8">
        
        {/* Search Header Hero */}
        <div className="bg-[#006b23] text-white rounded-3xl p-6 sm:p-10 shadow-lg text-center relative overflow-hidden">
          <h2 className="text-2xl sm:text-3xl font-extrabold font-outfit mb-2">
            How can we help you today?
          </h2>
          <p className="text-white/80 text-sm font-inter mb-6">
            Search our knowledge base or pick a topic below
          </p>

          <div className="relative max-w-xl mx-auto">
            <Search className="w-5 h-5 text-slate-400 absolute left-4 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search help articles, refunds, delivery..."
              className="w-full h-12 bg-white text-slate-900 placeholder:text-slate-400 text-sm font-medium rounded-2xl pl-12 pr-4 shadow-sm focus:ring-2 focus:ring-emerald-400 focus:outline-none"
            />
          </div>
        </div>

        {/* Quick Topic Cards */}
        <div>
          <h3 className="text-lg font-bold text-slate-900 font-outfit mb-4">
            Popular Topics
          </h3>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            {[
              { icon: Package, title: 'Orders & Delivery', color: 'bg-emerald-50 text-[#006b23]' },
              { icon: RefreshCw, title: 'Refunds & Returns', color: 'bg-blue-50 text-blue-600' },
              { icon: CreditCard, title: 'Payments & Offers', color: 'bg-amber-50 text-amber-600' },
              { icon: User, title: 'Account Settings', color: 'bg-purple-50 text-purple-600' },
            ].map((topic) => (
              <div
                key={topic.title}
                className="bg-white rounded-2xl p-4 border border-slate-100 shadow-sm hover:shadow-md transition cursor-pointer flex flex-col items-center text-center gap-3"
              >
                <div className={`w-12 h-12 rounded-full flex items-center justify-center ${topic.color}`}>
                  <topic.icon className="w-6 h-6" />
                </div>
                <span className="font-outfit font-semibold text-sm text-slate-800">
                  {topic.title}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* FAQs Section */}
        <div>
          <h3 className="text-lg font-bold text-slate-900 font-outfit mb-4">
            Frequently Asked Questions
          </h3>
          <div className="space-y-3">
            {faqs.map((faq, idx) => (
              <div
                key={faq.question}
                className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden"
              >
                <button
                  onClick={() => toggleFaq(idx)}
                  className="w-full p-4 sm:p-5 flex items-center justify-between text-left font-outfit font-semibold text-base text-slate-900 hover:bg-slate-50 transition"
                >
                  <span>{faq.question}</span>
                  <ChevronDown
                    className={`w-5 h-5 text-slate-400 transition-transform duration-200 ${
                      openFaq === idx ? 'rotate-180 text-[#006b23]' : ''
                    }`}
                  />
                </button>

                {openFaq === idx && (
                  <div className="px-4 sm:px-5 pb-5 text-sm text-slate-600 font-inter leading-relaxed border-t border-slate-50 pt-3">
                    {faq.answer}
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Live Support CTA */}
        <div className="bg-slate-900 text-white rounded-3xl p-6 sm:p-8 flex flex-col sm:flex-row items-center justify-between gap-6 shadow-md">
          <div>
            <h3 className="text-xl font-bold font-outfit mb-1">Still need assistance?</h3>
            <p className="text-slate-400 text-sm font-inter">
              Our 24/7 customer support team is available live to assist you.
            </p>
          </div>

          <div className="flex gap-3 w-full sm:w-auto">
            <button className="flex-1 sm:flex-initial px-5 py-3 bg-[#006b23] hover:bg-[#00531a] text-white rounded-full font-bold text-sm font-outfit flex items-center justify-center gap-2 transition">
              <MessageSquare className="w-4 h-4" />
              <span>Live Chat</span>
            </button>

            <button className="flex-1 sm:flex-initial px-5 py-3 bg-slate-800 hover:bg-slate-700 text-white rounded-full font-bold text-sm font-outfit flex items-center justify-center gap-2 transition">
              <PhoneCall className="w-4 h-4" />
              <span>Call Us</span>
            </button>
          </div>
        </div>

      </main>
    </div>
  );
}
