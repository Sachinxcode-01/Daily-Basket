'use client';

import React from 'react';
import Link from 'next/link';

export default function FreshnessPage() {
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
            <Link href="/how-it-works" className="font-body-lg text-body-lg text-on-surface-variant hover:text-primary transition-colors hover:bg-secondary-container/50 rounded-lg px-3 py-2">How It Works</Link>
            <Link href="/freshness" className="font-body-lg text-body-lg text-primary font-bold border-b-2 border-primary pb-1 rounded-lg px-3 py-2">Freshness</Link>
            <Link href="/about" className="font-body-lg text-body-lg text-on-surface-variant hover:text-primary transition-colors hover:bg-secondary-container/50 rounded-lg px-3 py-2">About</Link>
          </nav>
          <div className="flex items-center gap-sm">
            <Link href="/" className="bg-primary text-on-primary font-label-md text-label-md px-lg py-sm rounded-full hover:bg-surface-tint transition-all shadow-level-1">
              Start Shopping
            </Link>
          </div>
        </div>
      </header>

      <main>
        {/* Hero Section */}
        <section className="relative w-full overflow-hidden bg-surface-container-low min-h-[500px] flex items-center border-b border-outline-variant/10">
          <div className="relative z-10 w-full px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto grid grid-cols-1 md:grid-cols-2 gap-xl items-center py-xl">
            <div className="flex flex-col gap-lg items-start">
              <span className="bg-primary-container text-on-primary-container font-label-md text-label-md px-3 py-1 rounded-full uppercase tracking-wider inline-block">10 Minute Delivery</span>
              <h1 className="font-display-lg text-display-lg text-on-background max-w-lg leading-tight" style={{ fontFamily: 'Outfit' }}>Fresh groceries, delivered in minutes.</h1>
              <p className="font-body-lg text-body-lg text-on-surface-variant max-w-md">Experience the joy of organic, locally sourced produce and daily essentials arriving at your door before you even finish your coffee.</p>
              <div className="flex flex-col sm:flex-row gap-md mt-sm w-full sm:w-auto">
                <Link href="/" className="bg-primary text-on-primary font-label-md text-label-md px-8 py-4 rounded-xl hover:bg-surface-tint transition-all duration-300 flex items-center justify-center gap-2 active:scale-95 shadow-level-1">
                  Shop Now →
                </Link>
              </div>
            </div>
            <div className="w-full h-[360px] rounded-2xl overflow-hidden shadow-level-2 bg-surface-container-lowest p-4 flex items-center justify-center border border-outline-variant/20">
              <img
                src="/illustrations/web_freshness_3d.png"
                alt="Freshness Guarantee 3D"
                className="w-full h-full object-contain drop-shadow-xl"
              />
            </div>
          </div>
        </section>

        {/* Feature Grid */}
        <section className="py-xl px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-gutter">
            <div className="bg-surface-container-lowest p-lg rounded-2xl shadow-level-1 border border-outline-variant/20 flex flex-col items-center text-center gap-md hover:-translate-y-1 transition-transform duration-300">
              <div className="w-16 h-16 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container mb-2 text-2xl font-bold">
                ⚡
              </div>
              <h3 className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>Fast Delivery</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">Get your order delivered in under 10 minutes, guaranteed.</p>
            </div>
            
            <div className="bg-surface-container-lowest p-lg rounded-2xl shadow-level-1 border border-outline-variant/20 flex flex-col items-center text-center gap-md hover:-translate-y-1 transition-transform duration-300">
              <div className="w-16 h-16 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container mb-2 text-2xl font-bold">
                🌿
              </div>
              <h3 className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>Freshness Guarantee</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">100% money-back guarantee if you aren't completely satisfied with the freshness.</p>
            </div>

            <div className="bg-surface-container-lowest p-lg rounded-2xl shadow-level-1 border border-outline-variant/20 flex flex-col items-center text-center gap-md hover:-translate-y-1 transition-transform duration-300">
              <div className="w-16 h-16 rounded-full bg-tertiary-container flex items-center justify-center text-on-tertiary-container mb-2 text-2xl font-bold">
                🏷️
              </div>
              <h3 className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>Best Prices</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">We match local supermarket prices to ensure you always get the best deal.</p>
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
