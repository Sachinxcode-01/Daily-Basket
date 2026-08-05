'use client';

import React from 'react';
import Link from 'next/link';
import {
  ArrowLeft,
  Mail,
  Phone,
  MapPin,
  Clock,
  Send,
  MessageSquare,
  Sparkles,
  Search,
  ShoppingBag,
} from 'lucide-react';

export default function ContactUsPage() {
  return (
    <div className="min-h-screen bg-[#f9f9fc] text-[#1a1c1e] font-sans pt-20 pb-16">
      {/* Top Navbar */}
      <header className="fixed top-0 inset-x-0 z-50 bg-[#f9f9fc]/80 backdrop-blur-xl border-b border-[#e2e2e5]">
        <div className="max-w-7xl mx-auto px-4 md:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center gap-6">
            <Link href="/" className="flex items-center gap-2 text-[#006b23] font-bold text-xl tracking-tight">
              <span className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center font-black text-sm">DB</span>
              Daily Basket
            </Link>
            <div className="hidden md:flex items-center relative w-64">
              <Search className="w-4 h-4 text-[#3f4a3d] absolute left-3" />
              <input
                type="text"
                placeholder="Search groceries..."
                className="w-full pl-9 pr-4 py-1.5 bg-[#dce5dd]/50 border-none rounded-full text-sm focus:ring-2 focus:ring-[#006b23] focus:bg-white transition"
              />
            </div>
          </div>
          <nav className="hidden md:flex items-center gap-6 font-medium text-sm text-[#3f4a3d]">
            <Link href="/" className="hover:text-[#006b23] transition">Home</Link>
            <Link href="/categories" className="hover:text-[#006b23] transition">Categories</Link>
            <Link href="/about" className="hover:text-[#006b23] transition">About</Link>
            <Link href="/careers" className="hover:text-[#006b23] transition">Careers</Link>
          </nav>
          <div className="flex items-center gap-3">
            <Link
              href="/cart"
              className="flex items-center gap-2 bg-[#006b23] text-white px-4 py-2 rounded-xl text-sm font-semibold hover:bg-[#078730] transition active:scale-95"
            >
              <ShoppingBag className="w-4 h-4" />
              <span>Cart</span>
            </Link>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 md:px-8 pt-6">
        {/* Hero Header */}
        <div className="relative rounded-3xl overflow-hidden mb-12 bg-gradient-to-r from-[#006b23] to-[#078730] text-white p-8 md:p-14 shadow-lg text-center">
          <div className="max-w-2xl mx-auto space-y-4">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/20 text-white text-xs font-semibold backdrop-blur-md">
              <Sparkles className="w-3.5 h-3.5" /> 24/7 Customer Support
            </span>
            <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight">How can we help?</h1>
            <p className="text-emerald-100 text-base md:text-lg">
              Whether you have a question about an order, want to partner with us, or just want to say hi, our team is ready to assist you with 10-minute speed.
            </p>
          </div>
        </div>

        {/* Bento Grid Layout */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          {/* Contact Form (Span 7) */}
          <div className="lg:col-span-7 bg-white rounded-3xl p-6 md:p-10 shadow-sm border border-[#e2e2e5]">
            <h2 className="text-2xl font-bold text-[#1a1c1e] mb-2">Send us a message</h2>
            <p className="text-sm text-[#3f4a3d] mb-8">We aim to respond to all inquiries within 15 minutes during active delivery hours.</p>

            <form className="space-y-6" onSubmit={(e) => e.preventDefault()}>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label htmlFor="name" className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Full Name</label>
                  <input
                    id="name"
                    type="text"
                    placeholder="Jane Doe"
                    className="w-full px-4 py-3 bg-[#f3f3f6] border border-transparent rounded-xl text-sm focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <label htmlFor="email" className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Email Address</label>
                  <input
                    id="email"
                    type="email"
                    placeholder="jane@example.com"
                    className="w-full px-4 py-3 bg-[#f3f3f6] border border-transparent rounded-xl text-sm focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                    required
                  />
                </div>
              </div>

              <div className="space-y-2">
                <label htmlFor="subject" className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Subject</label>
                <select
                  id="subject"
                  className="w-full px-4 py-3 bg-[#f3f3f6] border border-transparent rounded-xl text-sm focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                >
                  <option value="">Select a topic...</option>
                  <option value="order">Order Support (Missing item, delayed delivery)</option>
                  <option value="product">Product Inquiry & Freshness Guarantee</option>
                  <option value="partnership">Partner with Dark Store Network</option>
                  <option value="other">Other Inquiry</option>
                </select>
              </div>

              <div className="space-y-2">
                <label htmlFor="message" className="text-xs font-bold text-[#3f4a3d] uppercase tracking-wider">Message</label>
                <textarea
                  id="message"
                  rows={5}
                  placeholder="How can we assist you today?"
                  className="w-full px-4 py-3 bg-[#f3f3f6] border border-transparent rounded-xl text-sm focus:outline-none focus:border-[#006b23] focus:bg-white transition"
                  required
                />
              </div>

              <button
                type="submit"
                className="w-full md:w-auto inline-flex items-center justify-center gap-2 px-8 py-3.5 bg-[#006b23] text-white rounded-xl font-bold text-sm hover:bg-[#078730] transition active:scale-95 shadow-sm"
              >
                <Send className="w-4 h-4" />
                <span>Send Message</span>
              </button>
            </form>
          </div>

          {/* Contact Details & Info (Span 5) */}
          <div className="lg:col-span-5 space-y-6">
            <div className="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] space-y-6">
              <h3 className="text-xl font-bold text-[#1a1c1e]">Direct Contact Lines</h3>

              <div className="space-y-4">
                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center shrink-0">
                    <Phone className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-[#1a1c1e]">Customer Helpline</h4>
                    <p className="text-sm text-[#3f4a3d]">1800-DAILY-BASKET (1800-324-5922)</p>
                    <span className="text-xs text-emerald-700 font-medium">Instant 10-sec response</span>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center shrink-0">
                    <Mail className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-[#1a1c1e]">Support Email</h4>
                    <p className="text-sm text-[#3f4a3d]">support@dailybasket.app</p>
                    <span className="text-xs text-[#3f4a3d]">Average response &lt; 15 mins</span>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center shrink-0">
                    <MapPin className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-[#1a1c1e]">Headquarters</h4>
                    <p className="text-sm text-[#3f4a3d]">Daily Basket Tech Towers, Sector 44, Bengaluru, KA 560102</p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 rounded-xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center shrink-0">
                    <Clock className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-[#1a1c1e]">Operating Hours</h4>
                    <p className="text-sm text-[#3f4a3d]">6:00 AM – 11:00 PM (7 days a week)</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Live Chat Support Card */}
            <div className="bg-gradient-to-br from-[#1a1c1e] to-[#2f3133] text-white rounded-3xl p-6 md:p-8 shadow-sm space-y-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-[#8cfa93] text-[#002106] flex items-center justify-center font-bold">
                  <MessageSquare className="w-5 h-5" />
                </div>
                <div>
                  <h4 className="font-bold text-base">Need instant live chat?</h4>
                  <p className="text-xs text-slate-300">Connect with an agent in under 30 seconds.</p>
                </div>
              </div>
              <Link
                href="/help"
                className="w-full inline-flex items-center justify-center gap-2 py-3 bg-[#8cfa93] text-[#002106] rounded-xl font-bold text-sm hover:bg-[#70dd7a] transition"
              >
                Start Live Support Chat
              </Link>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
