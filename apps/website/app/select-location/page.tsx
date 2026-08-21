'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';

/**
 * Location & Delivery Address Selection Page
 * Google Stitch Screen ID: bd155992620f4ad598d33db7ecffa41b
 * Source of Truth: Daily Basket Quick-Commerce Suite
 */
export default function SelectLocationPage() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedAddressId, setSelectedAddressId] = useState<string | null>(null);
  const [isDetectingGps, setIsDetectingGps] = useState(false);

  const savedAddresses = [
    {
      id: 'addr_home',
      label: 'Home',
      icon: 'home',
      address: '123 Green Valley Lane, Apt 4B\nBengaluru, Karnataka 560038',
      inRange: true,
    },
    {
      id: 'addr_work',
      label: 'Work',
      icon: 'work',
      address: 'Tech Hub Tower, Floor 12, Outer Ring Road\nBengaluru, Karnataka 560103',
      inRange: true,
    },
  ];

  const handleAllowLocationAccess = () => {
    setIsDetectingGps(true);
    setTimeout(() => {
      setIsDetectingGps(false);
      setSelectedAddressId('addr_gps');
    }, 700);
  };

  const handleConfirmAndContinue = () => {
    if (!selectedAddressId) return;
    router.push('/');
  };

  const filteredAddresses = savedAddresses.filter((addr) => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    return addr.label.toLowerCase().includes(q) || addr.address.toLowerCase().includes(q);
  });

  return (
    <div className="bg-[#f9f9fc] text-[#1a1c1e] font-['Inter'] antialiased min-h-screen flex flex-col selection:bg-[#006b23]/20 selection:text-[#006b23]">
      {/* TopAppBar */}
      <header className="sticky top-0 z-40 backdrop-blur-xl bg-[#f9f9fc]/80 shadow-sm border-b border-[#e2e2e5]">
        <div className="flex justify-between items-center w-full px-4 h-16 max-w-screen-md mx-auto">
          <button
            onClick={() => router.back()}
            aria-label="Go back"
            className="w-12 h-12 flex items-center justify-center rounded-full hover:bg-[#e8e8ea] transition-colors text-[#3f4a3d] active:scale-95 duration-150"
          >
            <span className="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 className="font-['Outfit'] font-semibold text-[20px] text-[#1a1c1e] flex-1 text-center pr-12">
            Select Location
          </h1>
        </div>
      </header>

      {/* Main Content Canvas */}
      <main className="flex-1 w-full max-w-screen-md mx-auto px-4 md:px-12 py-6 pb-32 flex flex-col gap-8">
        {/* Hero & Permission Section */}
        <section className="flex flex-col items-center text-center gap-6 animate-fade-in-up">
          <div className="w-56 h-56 rounded-2xl overflow-hidden relative shadow-[0px_2px_8px_rgba(0,0,0,0.04)] bg-white">
            <Image
              src="/images/location_pin_3d.png"
              alt="3D location pin"
              width={224}
              height={224}
              className="w-full h-full object-cover"
              priority
            />
          </div>
          <div className="flex flex-col gap-2 max-w-sm">
            <h2 className="font-['Outfit'] font-semibold text-[24px] text-[#1a1c1e]">
              Enable Location Access
            </h2>
            <p className="font-['Inter'] text-[15px] text-[#3f4a3d] leading-relaxed">
              Allow us to access your location to quickly verify delivery availability from our nearest local store.
            </p>
          </div>
          <button
            onClick={handleAllowLocationAccess}
            disabled={isDetectingGps}
            className="w-full md:w-auto min-w-[200px] h-12 rounded-xl bg-[#006b23] hover:bg-[#078730] text-white font-['Inter'] font-semibold text-[14px] transition-all active:scale-95 shadow-sm flex items-center justify-center gap-2 px-6"
          >
            <span className="material-symbols-outlined text-[20px]">my_location</span>
            {isDetectingGps ? 'Detecting GPS...' : 'Allow Location Access'}
          </button>
        </section>

        {/* Divider */}
        <div className="flex items-center gap-4 py-2">
          <div className="h-px bg-[#e2e2e5] flex-1"></div>
          <span className="font-['Inter'] text-[11px] font-semibold text-[#3f4a3d] uppercase tracking-widest">
            Or enter manually
          </span>
          <div className="h-px bg-[#e2e2e5] flex-1"></div>
        </div>

        {/* Search Section */}
        <section className="flex flex-col gap-4">
          <div className="relative w-full">
            <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
              <span className="material-symbols-outlined text-[#6e7a6c]">search</span>
            </div>
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search for your area or street"
              className="w-full h-14 pl-12 pr-4 bg-[#f3f3f6] rounded-xl border-none text-[#1a1c1e] font-['Inter'] text-[15px] placeholder:text-[#becab9] focus:ring-2 focus:ring-[#006b23] transition-shadow shadow-inner"
            />
          </div>

          <button
            onClick={() => setSelectedAddressId('addr_gps')}
            className={`flex items-center gap-3 p-4 rounded-xl border transition-colors shadow-sm active:scale-[0.98] ${
              selectedAddressId === 'addr_gps'
                ? 'bg-[#dce5dd]/30 border-[#006b23]'
                : 'bg-white border-[#e2e2e5] hover:bg-[#f3f3f6]'
            }`}
          >
            <div className="w-10 h-10 rounded-full bg-[#dce5dd] flex items-center justify-center text-[#006b23]">
              <span className="material-symbols-outlined">my_location</span>
            </div>
            <div className="flex flex-col text-left flex-1">
              <span className="font-['Outfit'] font-semibold text-[16px] text-[#006b23]">
                Use Current Location
              </span>
              <span className="font-['Inter'] text-[13px] text-[#3f4a3d]">Using GPS</span>
            </div>
            <span className="material-symbols-outlined text-[#becab9]">chevron_right</span>
          </button>
        </section>

        {/* Saved Addresses */}
        <section className="flex flex-col gap-3">
          <h3 className="font-['Outfit'] font-semibold text-[18px] text-[#1a1c1e]">
            Saved Addresses
          </h3>
          <div className="flex flex-col gap-3">
            {filteredAddresses.map((addr) => {
              const isSelected = selectedAddressId === addr.id;
              return (
                <div
                  key={addr.id}
                  onClick={() => setSelectedAddressId(addr.id)}
                  className={`bg-white/80 backdrop-blur-xl border rounded-2xl p-4 flex gap-4 items-start cursor-pointer transition-all group relative overflow-hidden ${
                    isSelected ? 'border-[#006b23] bg-[#dce5dd]/20' : 'border-[#e2e2e5] hover:border-[#006b23]/30'
                  }`}
                >
                  <div
                    className={`w-11 h-11 rounded-full flex items-center justify-center transition-colors ${
                      isSelected ? 'bg-[#dce5dd] text-[#006b23]' : 'bg-[#f3f3f6] text-[#3f4a3d]'
                    }`}
                  >
                    <span className="material-symbols-outlined">{addr.icon}</span>
                  </div>
                  <div className="flex flex-col flex-1 gap-1">
                    <div className="flex justify-between items-start">
                      <h4 className="font-['Outfit'] font-semibold text-[16px] text-[#1a1c1e]">
                        {addr.label}
                      </h4>
                      <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-[#dce5dd] text-[#006b23] font-['Inter'] font-semibold text-[10px] uppercase tracking-wider">
                        <div className="w-1.5 h-1.5 rounded-full bg-[#006b23] animate-pulse"></div>
                        In Range
                      </span>
                    </div>
                    <p className="font-['Inter'] text-[13px] text-[#3f4a3d] leading-relaxed whitespace-pre-line">
                      {addr.address}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </section>
      </main>

      {/* Bottom Action Area */}
      <div className="fixed bottom-0 left-0 w-full bg-[#f9f9fc]/90 backdrop-blur-xl border-t border-[#e2e2e5] p-4 z-50 shadow-[0_-4px_20px_rgba(0,0,0,0.05)]">
        <div className="max-w-screen-md mx-auto">
          <button
            onClick={handleConfirmAndContinue}
            disabled={!selectedAddressId}
            className={`w-full h-14 rounded-xl font-['Outfit'] font-semibold text-[16px] transition-all active:scale-[0.98] ${
              selectedAddressId
                ? 'bg-[#006b23] hover:bg-[#078730] text-white shadow-md'
                : 'bg-[#e2e2e5] text-[#3f4a3d] opacity-50 cursor-not-allowed'
            }`}
          >
            Confirm &amp; Continue
          </button>
        </div>
      </div>
    </div>
  );
}
