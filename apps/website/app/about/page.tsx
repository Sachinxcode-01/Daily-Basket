'use client';

import React from 'react';
import Link from 'next/link';
import HeaderNavBar from '../../components/navigation/HeaderNavBar';

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-background text-on-background font-body-lg antialiased">
      {/* Unified Navigation Bar */}
      <HeaderNavBar />

      <main>
        {/* Hero Section */}
        <section className="w-full px-margin-mobile md:px-margin-desktop py-xl md:py-[64px] max-w-[1280px] mx-auto">
          <div className="flex flex-col md:flex-row gap-xl items-center">
            <div className="w-full md:w-1/2 flex flex-col gap-md">
              <span className="px-4 py-1.5 rounded-full bg-secondary-container text-on-secondary-container font-label-md text-label-md w-fit uppercase tracking-widest">About Daily Basket</span>
              <h1 className="font-headline-lg-mobile text-headline-lg-mobile md:font-display-lg md:text-display-lg text-primary leading-tight" style={{ fontFamily: 'Outfit' }}>
                Our Mission to Deliver Freshness
              </h1>
              <p className="font-body-lg text-body-lg text-on-surface-variant max-w-lg">
                We believe that premium, organic quality shouldn&apos;t come at the cost of your time. Daily Basket bridges the gap between local fields and your kitchen counter, flawlessly and fast.
              </p>
            </div>
            <div className="w-full md:w-1/2 h-[300px] md:h-[420px] rounded-2xl overflow-hidden shadow-level-2 bg-surface-container-lowest flex items-center justify-center p-4 border border-outline-variant/20">
              <img
                src="/illustrations/web_about_3d.png"
                alt="3D About Daily Basket Illustration"
                className="w-full h-full object-contain drop-shadow-xl"
              />
            </div>
          </div>
        </section>

        {/* Brand Story Section */}
        <section className="w-full bg-surface-container-low py-xl md:py-[80px]">
          <div className="px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto">
            <div className="grid grid-cols-1 md:grid-cols-12 gap-gutter items-center">
              <div className="md:col-span-5 h-[360px] rounded-2xl overflow-hidden shadow-level-1 border border-outline-variant/10 bg-surface-container-lowest p-4 flex items-center justify-center order-2 md:order-1">
                <img
                  src="/illustrations/web_freshness_3d.png"
                  alt="Farm Freshness 3D Illustration"
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="md:col-span-1 md:order-2 hidden md:block"></div>
              <div className="md:col-span-6 flex flex-col gap-md order-1 md:order-3">
                <h2 className="font-headline-lg-mobile text-headline-lg-mobile md:font-headline-lg md:text-headline-lg text-on-surface" style={{ fontFamily: 'Outfit' }}>
                  From local farms to your doorstep
                </h2>
                <p className="font-body-lg text-body-lg text-on-surface-variant">
                  Our journey began with a simple observation: urban professionals crave the quality of a farmer&apos;s market but lack the time to seek it out. We built a network of trusted, sustainable producers who share our uncompromising standards.
                </p>
                <p className="font-body-lg text-body-lg text-on-surface-variant">
                  By streamlining the supply chain and leveraging smart technology, we ensure that the crispness of the harvest morning is preserved all the way to your dining table.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* Core Values Section */}
        <section className="w-full px-margin-mobile md:px-margin-desktop py-xl md:py-[80px] max-w-[1280px] mx-auto">
          <div className="text-center mb-xl">
            <h2 className="font-headline-lg-mobile text-headline-lg-mobile md:font-headline-lg md:text-headline-lg text-on-surface mb-sm" style={{ fontFamily: 'Outfit' }}>
              Our Core Values
            </h2>
            <p className="font-body-lg text-body-lg text-on-surface-variant">The principles that guide every order we pack.</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-gutter">
            <div className="bg-surface-container-lowest p-xl rounded-2xl shadow-level-1 flex flex-col gap-md border border-outline-variant/20 hover:-translate-y-1 transition-all duration-300">
              <div className="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center text-primary font-bold text-xl">
                ✓
              </div>
              <h3 className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>Uncompromising Quality</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">
                Every item is hand-selected. If it doesn&apos;t meet our rigorous standards for freshness and appearance, it doesn&apos;t make it into your basket.
              </p>
            </div>

            <div className="bg-surface-container-lowest p-xl rounded-2xl shadow-level-1 flex flex-col gap-md border border-outline-variant/20 hover:-translate-y-1 transition-all duration-300">
              <div className="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center text-primary font-bold text-xl">
                ⚡
              </div>
              <h3 className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>Effortless Speed</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">
                Your time is valuable. Our hyper-local fulfillment centers are optimized to pick, pack, and deliver your essentials in 10 minutes.
              </p>
            </div>

            <div className="bg-surface-container-lowest p-xl rounded-2xl shadow-level-1 flex flex-col gap-md border border-outline-variant/20 hover:-translate-y-1 transition-all duration-300">
              <div className="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center text-primary font-bold text-xl">
                🌱
              </div>
              <h3 className="font-title-md text-title-md text-on-surface font-semibold" style={{ fontFamily: 'Outfit' }}>Deep Sustainability</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">
                From supporting regenerative agriculture to utilizing eco-friendly packaging, we operate with deep respect for the environment.
              </p>
            </div>
          </div>
        </section>

        {/* Partner Network Section */}
        <section className="w-full bg-primary text-on-primary py-xl md:py-[80px]">
          <div className="px-margin-mobile md:px-margin-desktop max-w-[1280px] mx-auto flex flex-col items-center text-center gap-md">
            <span className="text-4xl">🌾</span>
            <h2 className="font-headline-lg-mobile text-headline-lg-mobile md:font-headline-lg md:text-headline-lg" style={{ fontFamily: 'Outfit' }}>
              Rooted in the Community
            </h2>
            <p className="font-body-lg text-body-lg max-w-2xl text-on-primary/90">
              We are proud to partner with over 50 independent local farms and artisanal producers. By choosing Daily Basket, you are directly supporting local agriculture.
            </p>
            <Link href="/" className="mt-md bg-surface-container-lowest text-primary font-label-md text-label-md px-lg py-sm rounded-full hover:bg-surface-container-low transition-colors shadow-level-1">
              Shop Farm Fresh
            </Link>
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
