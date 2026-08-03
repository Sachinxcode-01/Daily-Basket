'use client';

import React from 'react';
import Link from 'next/link';

export default function HowItWorksPage() {
  return (
    <div className="min-h-screen bg-background text-on-background font-body-lg antialiased">
      {/* TopNavBar */}
      <header className="sticky top-0 w-full shadow-sm z-50 bg-surface/80 backdrop-blur-md">
        <div className="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto">
          <Link href="/" className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-surface-container-lowest border border-outline-variant/30 flex items-center justify-center p-1 shadow-level-1">
              <img src="/images/daily_basket_logo.png" alt="Daily Basket Logo" className="w-full h-full object-contain" />
            </div>
            <span className="font-title-md text-title-md font-bold text-primary" style={{ fontFamily: 'Outfit' }}>Daily Basket</span>
          </Link>
          <nav className="hidden md:flex items-center gap-lg">
            <Link href="/" className="font-body-lg text-body-lg text-on-surface-variant hover:text-primary transition-colors hover:bg-secondary-container/50 rounded-lg px-3 py-2">Home</Link>
            <Link href="/features" className="font-body-lg text-body-lg text-on-surface-variant hover:text-primary transition-colors hover:bg-secondary-container/50 rounded-lg px-3 py-2">Features</Link>
            <Link href="/how-it-works" className="font-body-lg text-body-lg text-primary font-bold border-b-2 border-primary pb-1 rounded-lg px-3 py-2">How It Works</Link>
            <Link href="/about" className="font-body-lg text-body-lg text-on-surface-variant hover:text-primary transition-colors hover:bg-secondary-container/50 rounded-lg px-3 py-2">About</Link>
          </nav>
          <div className="flex items-center gap-sm">
            <Link href="/" className="bg-primary text-on-primary font-label-md text-label-md px-lg py-sm rounded-full hover:bg-surface-tint transition-all shadow-level-1">
              Start Shopping
            </Link>
          </div>
        </div>
      </header>

      <main className="flex-grow flex flex-col w-full relative overflow-hidden">
        {/* Hero Section */}
        <section className="relative pt-16 pb-12 px-margin-mobile md:px-margin-desktop w-full max-w-[1280px] mx-auto text-center z-10">
          <div className="inline-block mb-4 px-4 py-1.5 rounded-full bg-secondary-container/50 border border-outline-variant/30 text-on-secondary-container font-label-md text-label-md uppercase tracking-wider">
            Simplicity in Every Step
          </div>
          <h1 className="font-display-lg text-display-lg md:text-[56px] font-bold text-on-background mb-6 max-w-3xl mx-auto" style={{ fontFamily: 'Outfit' }}>
            Fresh Groceries, Delivered in <span className="text-primary">Minutes.</span>
          </h1>
          <p className="font-body-lg text-body-lg text-on-surface-variant max-w-2xl mx-auto mb-8 text-lg">
            Experience the magic of instant grocery delivery. Our smart app and optimized local hubs ensure your daily essentials arrive before you even realize you need them.
          </p>
        </section>

        {/* Steps Section */}
        <section className="py-8 px-margin-mobile md:px-margin-desktop w-full max-w-[1280px] mx-auto z-10 relative">
          <div className="grid grid-cols-1 md:grid-cols-12 gap-gutter">
            
            {/* Step 1: Browse */}
            <div className="md:col-span-8 bg-surface-container-lowest rounded-3xl p-8 md:p-10 shadow-level-1 border border-outline-variant/20 relative overflow-hidden">
              <div className="flex flex-col md:flex-row gap-8 items-center">
                <div className="flex-1 flex flex-col justify-center">
                  <div className="w-12 h-12 rounded-2xl bg-secondary-container flex items-center justify-center mb-4 text-primary font-bold text-xl">
                    🔍
                  </div>
                  <div className="text-primary font-label-md text-label-md mb-2 tracking-widest uppercase font-bold">Step 01</div>
                  <h3 className="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg text-on-surface mb-4" style={{ fontFamily: 'Outfit' }}>Browse 5000+ Fresh Products</h3>
                  <p className="font-body-lg text-body-lg text-on-surface-variant">
                    Explore a curated selection of organic produce, premium pantry staples, and local artisan goods. Our intuitive interface makes finding what you crave effortless.
                  </p>
                </div>
                <div className="w-full md:w-1/2 h-60 rounded-2xl overflow-hidden bg-surface-container-low p-4 flex items-center justify-center">
                  <img src="/illustrations/web_how_it_works_3d.png" alt="How it works 3D" className="h-full object-contain drop-shadow-md" />
                </div>
              </div>
            </div>

            {/* Step 2: Add to Basket */}
            <div className="md:col-span-4 bg-primary text-on-primary rounded-3xl p-8 shadow-level-2 flex flex-col justify-between">
              <div>
                <div className="w-12 h-12 rounded-2xl bg-on-primary/20 flex items-center justify-center mb-4 font-bold text-xl">
                  🛒
                </div>
                <div className="font-label-md text-label-md mb-2 tracking-widest text-primary-fixed uppercase font-bold">Step 02</div>
                <h3 className="font-headline-lg-mobile text-headline-lg-mobile mb-4" style={{ fontFamily: 'Outfit' }}>Add to your Smart Basket</h3>
                <p className="font-body-sm text-body-sm opacity-90 mb-6">
                  One tap adds items to your basket. Our intelligent system suggests perfect pairings and remembers your favorites for lightning-fast reordering.
                </p>
              </div>
              <div className="bg-surface-container-lowest text-on-surface rounded-xl p-4 flex items-center justify-between shadow-level-1">
                <div className="font-body-sm text-body-sm font-semibold">Fresh Hass Avocado</div>
                <span className="bg-secondary-container text-primary font-bold px-3 py-1 rounded-full text-xs">2 units</span>
              </div>
            </div>

            {/* Step 3: Fast Checkout */}
            <div className="md:col-span-5 bg-surface-container-lowest rounded-3xl p-8 shadow-level-1 border border-outline-variant/20 flex flex-col justify-between">
              <div>
                <div className="w-12 h-12 rounded-2xl bg-error-container/50 flex items-center justify-center mb-4 text-error font-bold text-xl">
                  ⚡
                </div>
                <div className="text-error font-label-md text-label-md mb-2 tracking-widest uppercase font-bold">Step 03</div>
                <h3 className="font-headline-lg-mobile text-headline-lg-mobile text-on-surface mb-4" style={{ fontFamily: 'Outfit' }}>Fast Checkout & Secure Payment</h3>
                <p className="font-body-lg text-body-lg text-on-surface-variant mb-6">
                  Frictionless payment with Apple Pay, Google Pay, UPI, or saved cards. Bank-level encryption ensures your data is always safe.
                </p>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="bg-surface-container-low rounded-xl p-3 text-center font-label-md text-label-md">🔒 Secure 256-Bit</div>
                <div className="bg-surface-container-low rounded-xl p-3 text-center font-label-md text-label-md">⚡ 1-Tap Checkout</div>
              </div>
            </div>

            {/* Step 4: 10 Minute Delivery */}
            <div className="md:col-span-7 bg-secondary-container/30 rounded-3xl p-8 md:p-10 shadow-level-1 border border-outline-variant/20 flex flex-col md:flex-row gap-8 items-center">
              <div className="flex-1 flex flex-col justify-center">
                <div className="w-12 h-12 rounded-2xl bg-primary text-on-primary flex items-center justify-center mb-4 font-bold text-xl shadow-level-1">
                  🛵
                </div>
                <div className="text-primary font-label-md text-label-md mb-2 tracking-widest uppercase font-bold">Step 04</div>
                <h3 className="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg text-on-surface mb-4" style={{ fontFamily: 'Outfit' }}>Delivered in under 10 minutes</h3>
                <p className="font-body-lg text-body-lg text-on-surface-variant mb-6">
                  Track your rider in real-time. Our hyper-local hubs mean your ice cream arrives frozen and your bread arrives fresh.
                </p>
                <Link href="/" className="bg-primary text-on-primary font-label-md text-label-md h-12 px-6 rounded-xl w-fit flex items-center gap-2 hover:bg-surface-tint transition-all shadow-level-1">
                  Start Shopping Now →
                </Link>
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
