'use client';

import React from 'react';
import Link from 'next/link';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';

export default function FeaturesPage() {
  return (
    <div className="min-h-screen bg-background text-on-background font-body-lg antialiased">
      {/* Unified Navigation Bar */}
      <HeaderNavBar />

      <main className="w-full">
        {/* Hero Section */}
        <section className="relative w-full pt-16 pb-20 px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto overflow-hidden">
          <div className="flex flex-col items-center text-center max-w-3xl mx-auto z-10 relative">
            <span className="px-4 py-1.5 rounded-full bg-secondary-container text-on-secondary-container font-label-md text-label-md mb-6 uppercase tracking-widest">Platform Features</span>
            <h1 className="font-display-lg text-display-lg text-on-background mb-6 leading-tight" style={{ fontFamily: 'Outfit' }}>
              Grocery Shopping, <br />
              <span className="text-primary">Reimagined in 10 Mins.</span>
            </h1>
            <p className="font-body-lg text-body-lg text-on-surface-variant mb-10 max-w-xl">
              Experience the fastest, smartest, and most rewarding way to get your daily essentials. Built for modern urban professionals who value time and quality.
            </p>
          </div>
        </section>

        {/* Bento Grid Features */}
        <section className="w-full py-8 px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-12 gap-gutter">
            
            {/* Feature 1: Live Order Tracking */}
            <div className="md:col-span-8 bg-surface-container-lowest rounded-2xl p-8 shadow-level-1 border border-outline-variant/20 flex flex-col md:flex-row gap-8 items-center">
              <div className="flex-1 flex flex-col justify-center">
                <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center mb-4 text-primary font-bold text-xl">
                  📍
                </div>
                <h3 className="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg mb-3" style={{ fontFamily: 'Outfit' }}>Live Order Tracking</h3>
                <p className="font-body-lg text-body-lg text-on-surface-variant">
                  Watch your groceries move from our dark store to your doorstep in real-time. Know exactly when your fresh produce will arrive with minute-by-minute updates.
                </p>
              </div>
              <div className="w-full md:w-1/2 h-64 rounded-xl overflow-hidden bg-surface-container-low p-4 flex items-center justify-center">
                <img src="/illustrations/web_features_3d.png" alt="Live Tracking 3D" className="h-full object-contain drop-shadow-md" />
              </div>
            </div>

            {/* Feature 2: Smart Basket */}
            <div className="md:col-span-4 bg-secondary-container/30 rounded-2xl p-8 border border-outline-variant/20 flex flex-col justify-between shadow-level-1">
              <div>
                <div className="w-12 h-12 rounded-xl bg-surface-container-lowest flex items-center justify-center mb-4 text-primary font-bold text-xl shadow-level-1">
                  ✨
                </div>
                <h3 className="font-title-md text-title-md font-bold mb-3" style={{ fontFamily: 'Outfit' }}>Smart Basket AI</h3>
                <p className="font-body-sm text-body-sm text-on-surface-variant mb-6">
                  Our AI learns your habits and suggests essentials you might have forgotten before checkout. Never run out of milk again.
                </p>
              </div>
              <div className="bg-surface-container-lowest p-4 rounded-xl shadow-level-1 border border-outline-variant/10">
                <div className="font-label-md text-label-md text-on-surface-variant mb-2">💡 Suggested for you</div>
                <div className="flex items-center justify-between">
                  <span className="font-body-sm text-body-sm font-semibold">Organic Eggs (6 Pack)</span>
                  <span className="text-primary font-bold">+ Add</span>
                </div>
              </div>
            </div>

            {/* Feature 3: Flash Deals & Rewards */}
            <div className="md:col-span-4 bg-surface-container-lowest rounded-2xl p-8 shadow-level-1 border border-outline-variant/20 flex flex-col justify-between">
              <div>
                <div className="w-12 h-12 rounded-xl bg-error-container/50 flex items-center justify-center mb-4 text-error font-bold text-xl">
                  🎁
                </div>
                <h3 className="font-title-md text-title-md font-bold mb-3" style={{ fontFamily: 'Outfit' }}>Flash Deals & Rewards</h3>
                <p className="font-body-sm text-body-sm text-on-surface-variant mb-6">
                  Earn points on every purchase and unlock exclusive localized deals based on your neighborhood&apos;s harvest.
                </p>
              </div>
              <div className="bg-primary text-on-primary p-5 rounded-xl">
                <div className="font-label-md text-label-md opacity-80 uppercase tracking-wider mb-1">Total Reward Balance</div>
                <div className="font-title-md text-title-md text-[28px] font-bold" style={{ fontFamily: 'Outfit' }}>2,450 pts</div>
              </div>
            </div>

            {/* Feature 4: Seamless Checkout */}
            <div className="md:col-span-8 bg-surface-container-low rounded-2xl p-8 border border-outline-variant/20 flex flex-col md:flex-row items-center justify-between gap-8 shadow-level-1">
              <div className="md:w-1/2">
                <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center mb-4 text-primary font-bold text-xl">
                  💳
                </div>
                <h3 className="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg mb-3" style={{ fontFamily: 'Outfit' }}>Seamless Checkout</h3>
                <p className="font-body-lg text-body-lg text-on-surface-variant mb-4">
                  Multiple secure payment options designed for speed. Apple Pay, Google Pay, UPI, saved cards, or cash on delivery. One tap and it&apos;s on the way.
                </p>
                <div className="flex flex-wrap gap-2">
                  <span className="px-3 py-1 bg-surface-container-lowest border border-outline-variant/20 rounded-full font-label-md text-label-md text-on-surface-variant">Credit/Debit</span>
                  <span className="px-3 py-1 bg-surface-container-lowest border border-outline-variant/20 rounded-full font-label-md text-label-md text-on-surface-variant">UPI & Digital Wallets</span>
                  <span className="px-3 py-1 bg-surface-container-lowest border border-outline-variant/20 rounded-full font-label-md text-label-md text-on-surface-variant">Cash on Delivery</span>
                </div>
              </div>
              <div className="md:w-1/2 w-full max-w-sm bg-surface-container-lowest rounded-2xl shadow-level-2 p-6 border border-outline-variant/20">
                <div className="flex justify-between items-center mb-4 border-b border-outline-variant/10 pb-3">
                  <span className="font-body-lg text-body-lg font-semibold">Total Amount</span>
                  <span className="font-title-md text-title-md text-primary font-bold" style={{ fontFamily: 'Outfit' }}>₹348.00</span>
                </div>
                <button className="w-full h-12 rounded-xl bg-primary text-on-primary font-semibold hover:bg-surface-tint transition-colors shadow-level-1">
                  Pay Now with 1-Tap
                </button>
              </div>
            </div>

          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-surface-container-low w-full border-t border-outline-variant/20 mt-xl py-xl px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto">
        <div className="flex flex-col md:flex-row justify-between items-center gap-md">
          <div className="flex items-center gap-2">
            <img src="/images/daily_basket_logo.png" alt="Daily Basket Logo" className="w-6 h-6 object-contain" />
            <span className="font-title-md text-title-md font-bold text-on-surface" style={{ fontFamily: 'Outfit' }}>Daily Basket</span>
          </div>
          <p className="font-body-sm text-body-sm text-on-surface-variant">
            © 2024 Daily Basket Inc. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
  );
}
