'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';

/**
 * Add / Edit Delivery Address Page
 * Google Stitch Screen ID: 2743ef4c5bb54d7294444b23f082597e
 * Source of Truth: Daily Basket Quick-Commerce Suite
 */
export default function AddDeliveryAddressPage() {
  const router = useRouter();

  const [fullName, setFullName] = useState('Rahul Sharma');
  const [mobile, setMobile] = useState('9876543210');
  const [pincode, setPincode] = useState('560038');
  const [city] = useState('Bengaluru');
  const [house, setHouse] = useState('B-14, Ground Floor');
  const [area, setArea] = useState('100ft Road, Indiranagar');
  const [landmark, setLandmark] = useState('');
  const [addressType, setAddressType] = useState('home');
  const [isLocating, setIsLocating] = useState(false);
  const [isSaving, setIsSaving] = useState(false);

  const handleUseCurrentLocation = () => {
    setIsLocating(true);
    setTimeout(() => {
      setIsLocating(false);
      setPincode('560038');
      setArea('100ft Road, Indiranagar');
    }, 600);
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSaving(true);
    setTimeout(() => {
      setIsSaving(false);
      router.push('/saved-addresses');
    }, 500);
  };

  return (
    <div className="bg-[#f9f9fc] font-['Inter'] text-[#1a1c1e] antialiased min-h-screen flex flex-col">
      {/* Top App Bar */}
      <header className="fixed top-0 w-full z-50 backdrop-blur-xl bg-[#f9f9fc]/80 flex items-center px-4 h-16 shadow-sm border-b border-[#e2e2e5]">
        <button
          onClick={() => router.back()}
          aria-label="Go back"
          className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-[#e8e8ea] transition-colors active:scale-95 duration-200"
        >
          <span className="material-symbols-outlined text-[#006b23]">arrow_back</span>
        </button>
        <h1 className="ml-4 font-['Outfit'] text-[20px] font-semibold text-[#1a1c1e]">
          Add Delivery Address
        </h1>
      </header>

      {/* Main Content */}
      <main className="pt-20 pb-32 px-4 max-w-md mx-auto w-full flex-1">
        {/* Map Preview Section */}
        <section className="mb-6 rounded-2xl overflow-hidden bg-white shadow-sm border border-[#e2e2e5] relative h-40">
          <div className="w-full h-full bg-[#f1f8f4] flex flex-col items-center justify-center relative">
            <div className="w-8 h-8 rounded-full bg-[#006b23] flex items-center justify-center text-white shadow-md">
              <span className="material-symbols-outlined text-[20px]">location_on</span>
            </div>
            <span className="font-['Outfit'] text-[12px] font-semibold text-[#1a1c1e] mt-1">
              Indiranagar, Bengaluru
            </span>
          </div>
          <div className="absolute bottom-3 left-1/2 -translate-x-1/2 w-11/12 max-w-sm">
            <button
              onClick={handleUseCurrentLocation}
              disabled={isLocating}
              className="w-full bg-white/90 backdrop-blur-md text-[#1a1c1e] font-['Inter'] text-sm font-semibold py-2.5 px-4 rounded-xl flex items-center justify-center gap-2 shadow-sm border border-[#e2e2e5] active:scale-95 transition-transform"
            >
              <span className="material-symbols-outlined text-[#006b23]">my_location</span>
              {isLocating ? 'Detecting GPS...' : 'Use Current Location'}
            </button>
          </div>
        </section>

        {/* Serviceability Status */}
        <div className="bg-[#dce5dd]/30 border border-[#dce5dd] rounded-xl p-3.5 flex items-start gap-3 mb-6">
          <span className="material-symbols-outlined text-[#006b23] mt-0.5">check_circle</span>
          <div>
            <p className="text-sm font-semibold text-[#1a1c1e]">Within Delivery Range</p>
            <p className="text-xs text-[#3f4a3d] mt-0.5">
              This location is served by your local Daily Basket store.
            </p>
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleSave} className="space-y-5">
          {/* Contact Details */}
          <div>
            <h2 className="font-['Outfit'] text-lg font-semibold text-[#1a1c1e] mb-3">
              Contact Details
            </h2>
            <div className="space-y-3">
              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Full Name
                </label>
                <input
                  type="text"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder="Rahul Sharma"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0"
                  required
                />
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Mobile Number
                </label>
                <div className="flex items-center">
                  <span className="text-[#3f4a3d] text-sm font-medium mr-2">+91</span>
                  <input
                    type="tel"
                    value={mobile}
                    onChange={(e) => setMobile(e.target.value)}
                    placeholder="98765 43210"
                    maxLength={10}
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0"
                    required
                  />
                </div>
              </div>
            </div>
          </div>

          {/* Address Details */}
          <div>
            <h2 className="font-['Outfit'] text-lg font-semibold text-[#1a1c1e] mb-3 mt-6">
              Address
            </h2>
            <div className="space-y-3">
              <div className="grid grid-cols-2 gap-3">
                <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 relative focus-within:border-[#006b23]">
                  <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                    Pincode
                  </label>
                  <input
                    type="text"
                    value={pincode}
                    onChange={(e) => setPincode(e.target.value)}
                    maxLength={6}
                    placeholder="560038"
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 pr-6"
                    required
                  />
                  {pincode.length === 6 && (
                    <span className="material-symbols-outlined text-[#006b23] absolute right-2.5 top-1/2 -translate-y-1/2 text-base">
                      check
                    </span>
                  )}
                </div>

                <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 opacity-80">
                  <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                    City
                  </label>
                  <input
                    type="text"
                    value={city}
                    readOnly
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 cursor-default"
                  />
                </div>
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  House / Flat / Block No.
                </label>
                <input
                  type="text"
                  value={house}
                  onChange={(e) => setHouse(e.target.value)}
                  placeholder="e.g. B-14, Ground Floor"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0"
                  required
                />
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Apartment / Road / Area
                </label>
                <input
                  type="text"
                  value={area}
                  onChange={(e) => setArea(e.target.value)}
                  placeholder="e.g. 100ft Road, Indiranagar"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0"
                  required
                />
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider flex justify-between">
                  <span>Landmark</span>
                  <span className="normal-case opacity-60">(Optional)</span>
                </label>
                <input
                  type="text"
                  value={landmark}
                  onChange={(e) => setLandmark(e.target.value)}
                  placeholder="e.g. Near Mother Dairy"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0"
                />
              </div>
            </div>
          </div>

          {/* Save As */}
          <div>
            <h2 className="font-['Outfit'] text-lg font-semibold text-[#1a1c1e] mb-3 mt-6">
              Save As
            </h2>
            <div className="flex gap-3 pb-2">
              {[
                { id: 'home', label: 'Home', icon: 'home' },
                { id: 'work', label: 'Work', icon: 'work' },
                { id: 'other', label: 'Other', icon: 'location_on' },
              ].map((item) => {
                const isSelected = addressType === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => setAddressType(item.id)}
                    className={`px-5 py-2.5 rounded-full border flex items-center gap-2 transition-all shadow-sm ${
                      isSelected
                        ? 'bg-[#dce5dd] border-[#006b23] text-[#006b23] font-semibold'
                        : 'bg-white border-[#e2e2e5] text-[#3f4a3d]'
                    }`}
                  >
                    <span className="material-symbols-outlined text-lg">{item.icon}</span>
                    <span className="text-sm">{item.label}</span>
                  </button>
                );
              })}
            </div>
          </div>
        </form>
      </main>

      {/* Fixed Bottom Action */}
      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full bg-[#f9f9fc]/90 backdrop-blur-md border-t border-[#e2e2e5] p-4 z-40 max-w-md">
        <button
          onClick={handleSave}
          disabled={isSaving}
          className="w-full bg-[#006b23] hover:bg-[#078730] text-white font-['Outfit'] font-semibold text-lg py-3.5 rounded-xl shadow-md active:scale-[0.98] transition-all flex items-center justify-center gap-2"
        >
          {isSaving ? 'Saving Address...' : 'Save Address'}
        </button>
      </div>
    </div>
  );
}
