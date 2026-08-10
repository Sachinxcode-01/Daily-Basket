'use client';

import React from 'react';
import Link from 'next/link';

export default function SustainabilityImpactPage() {
  return (
    <main className="min-h-screen bg-surface text-on-surface py-8 px-4 md:px-12 max-w-7xl mx-auto flex flex-col gap-8">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-on-surface-variant">
        <Link href="/" className="hover:text-primary">Home</Link>
        <span>/</span>
        <span className="text-on-surface font-medium">Sustainability Impact</span>
      </div>

      {/* Hero Header */}
      <section>
        <div className="flex items-center gap-3 mb-2">
          <span className="material-symbols-outlined text-primary text-4xl">eco</span>
          <h1 className="font-headline text-3xl md:text-4xl font-bold text-on-surface">Your Impact</h1>
        </div>
        <p className="font-body text-base md:text-lg text-on-surface-variant">
          Together, we are making quick-commerce sustainable. Here is your lifetime contribution.
        </p>
      </section>

      {/* Bento Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Hero Card: Overall Earth Champion Status */}
        <div className="col-span-1 md:col-span-2 lg:col-span-3 bg-primary text-on-primary rounded-3xl p-6 md:p-8 flex flex-col md:flex-row items-center justify-between shadow-lg relative overflow-hidden">
          <div className="z-10 w-full md:w-2/3">
            <p className="font-label text-xs uppercase tracking-wider text-primary-fixed-dim mb-2 font-bold">
              Current Status
            </p>
            <h2 className="font-headline text-4xl md:text-5xl font-extrabold mb-3">Earth Champion</h2>
            <p className="font-body text-base md:text-lg text-on-primary/90">
              You are in the top 5% of eco-conscious shoppers in your area this month.
            </p>
          </div>
          <div className="z-10 mt-6 md:mt-0 flex flex-col items-center">
            <div className="w-32 h-32 rounded-full border-4 border-primary-fixed-dim flex items-center justify-center relative bg-primary/20">
              <span className="font-headline text-3xl font-bold">1,240</span>
            </div>
            <span className="font-label text-sm mt-2 text-primary-fixed-dim font-medium">Impact Points</span>
          </div>
        </div>

        {/* Plastic Saved */}
        <div className="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-variant/40 flex flex-col justify-between">
          <div className="flex justify-between items-start mb-6">
            <div>
              <div className="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-primary mb-3">
                <span className="material-symbols-outlined">recycling</span>
              </div>
              <h3 className="font-headline text-xl font-semibold text-on-surface">Plastic Saved</h3>
            </div>
            <span className="font-headline text-2xl font-bold text-primary">4.2 kg</span>
          </div>
          <div>
            <div className="flex justify-between font-label text-sm text-on-surface-variant mb-2">
              <span>Goal: 5.0 kg</span>
              <span className="font-semibold text-primary">84%</span>
            </div>
            <div className="w-full bg-surface-variant rounded-full h-3 overflow-hidden">
              <div className="bg-primary h-3 rounded-full transition-all duration-1000" style={{ width: '84%' }} />
            </div>
            <p className="font-body text-xs text-on-surface-variant mt-3">
              Equivalent to saving 210 plastic bottles from landfills.
            </p>
          </div>
        </div>

        {/* CO2 Reduced */}
        <div className="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-variant/40 flex flex-col justify-between">
          <div className="flex justify-between items-start mb-6">
            <div>
              <div className="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-primary mb-3">
                <span className="material-symbols-outlined">electric_moped</span>
              </div>
              <h3 className="font-headline text-xl font-semibold text-on-surface">CO2 Reduced</h3>
            </div>
            <span className="font-headline text-2xl font-bold text-primary">12.5 kg</span>
          </div>
          <div>
            <div className="flex justify-between font-label text-sm text-on-surface-variant mb-2">
              <span>via Electric Delivery</span>
              <span className="font-semibold text-primary">+12% this mo</span>
            </div>
            <div className="w-full bg-surface-variant rounded-full h-3 overflow-hidden">
              <div className="bg-primary h-3 rounded-full transition-all duration-1000" style={{ width: '100%' }} />
            </div>
            <p className="font-body text-xs text-on-surface-variant mt-3">
              Thanks to our 100% electric delivery fleet in your zone.
            </p>
          </div>
        </div>

        {/* Local Farms Supported */}
        <div className="col-span-1 md:col-span-2 lg:col-span-1 bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-variant/40 flex flex-col justify-between">
          <div className="flex justify-between items-start mb-6">
            <div>
              <div className="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-primary mb-3">
                <span className="material-symbols-outlined">agriculture</span>
              </div>
              <h3 className="font-headline text-xl font-semibold text-on-surface">Local Farms Supported</h3>
            </div>
            <span className="font-headline text-2xl font-bold text-primary">8</span>
          </div>
          <div>
            <p className="font-body text-sm text-on-surface mb-2 font-medium">8 partner farms within 50 miles</p>
            <p className="font-body text-xs text-on-surface-variant">
              Every local purchase directly sustains local organic farming communities.
            </p>
          </div>
        </div>
      </div>
    </main>
  );
}
