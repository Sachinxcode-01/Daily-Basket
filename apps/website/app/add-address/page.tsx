'use client';

import { useState, useEffect, useCallback, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { apiClient } from '@daily-basket/api-client';
import { useCurrentUserId } from '../../store/useCart';

/**
 * Add / Edit Delivery Address Page
 * Source of Truth: Google Stitch Screen ID: 2743ef4c5bb54d7294444b23f082597e
 * Design: design.md (Single Source of Truth)
 */

function getSafeReturnTo(raw: string | null | undefined): string {
  if (!raw || typeof raw !== 'string') {
    return '/profile';
  }
  if (!raw.startsWith('/') || raw.startsWith('//') || raw.includes('\\')) {
    return '/profile';
  }
  try {
    const url = new URL(raw, 'http://localhost');
    if (url.origin !== 'http://localhost') {
      return '/profile';
    }
    return `${url.pathname}${url.search}${url.hash}`;
  } catch {
    return '/profile';
  }
}

function AddDeliveryAddressInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const returnTo = getSafeReturnTo(searchParams?.get('returnTo'));
  const userId = useCurrentUserId();

  // Contact details
  const [fullName, setFullName] = useState('Rahul Sharma');
  const [mobile, setMobile] = useState('9876543210');

  // Postal & Address Fields
  const [pincode, setPincode] = useState('560038');
  const [country, setCountry] = useState('India');
  const [state, setState] = useState('Karnataka');
  const [district, setDistrict] = useState('Bengaluru');
  const [city, setCity] = useState('Bengaluru');
  const [area, setArea] = useState('Indiranagar');
  const [house, setHouse] = useState('B-14, Ground Floor');
  const [street, setStreet] = useState('100ft Road');
  const [landmark, setLandmark] = useState('');
  const [addressType, setAddressType] = useState<'home' | 'work' | 'other'>('home');
  const [isDefault, setIsDefault] = useState(true);

  // Serviceability & Lookup State
  const [isLookingUpPin, setIsLookingUpPin] = useState(false);
  const [lookupError, setLookupError] = useState<string | null>(null);
  const [postOffices, setPostOffices] = useState<any[]>([]);
  const [selectedPostOffice, setSelectedPostOffice] = useState<string>('');
  const [isServiceable, setIsServiceable] = useState<boolean | null>(true);
  const [serviceabilityStatus, setServiceabilityStatus] = useState<string>('AVAILABLE');

  // GPS / Geolocation state
  const [coordinates, setCoordinates] = useState<{ latitude: number; longitude: number } | null>(null);
  const [isLocating, setIsLocating] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [saveError, setSaveError] = useState<string | null>(null);

  // Automatic PIN Code Lookup handler
  const performPincodeLookup = useCallback(async (pin: string) => {
    const cleanPin = pin.trim();
    if (!/^[1-9][0-9]{5}$/.test(cleanPin)) {
      setLookupError('Please enter a valid 6-digit Indian PIN code');
      setIsLookingUpPin(false);
      return;
    }

    setIsLookingUpPin(true);
    setLookupError(null);

    try {
      const res: any = await apiClient.lookupPincode(cleanPin);

      if (res && (res.isValid || res.success)) {
        setCountry(res.country || 'India');
        setState(res.state || '');
        setDistrict(res.district || '');
        setCity(res.city || res.district || '');

        const pos: any[] = res.postOffices || [];
        setPostOffices(pos);

        if (pos.length > 0) {
          const firstOffice = pos[0].name || pos[0].Name || (typeof pos[0] === 'string' ? pos[0] : '');
          setSelectedPostOffice(firstOffice);
          // If area is empty or was set from previous lookup, auto-populate
          setArea(firstOffice);
        }

        setIsServiceable(res.isServiceable);
        setServiceabilityStatus(res.serviceabilityBadge || (res.isServiceable ? 'AVAILABLE' : 'OUT_OF_RANGE'));
      } else {
        setLookupError(res?.error || res?.serviceabilityMessage || `No postal records found for PIN ${cleanPin}`);
        setPostOffices([]);
        setIsServiceable(false);
        setServiceabilityStatus('INVALID_PIN');
      }
    } catch (err: any) {
      setLookupError(err?.message || 'Unable to fetch postal details. You can enter them manually.');
    } finally {
      setIsLookingUpPin(false);
    }
  }, []);

  // Handle PIN code change
  const handlePincodeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/\D/g, '').slice(0, 6);
    setPincode(value);
    setCoordinates(null);

    if (value.length === 6) {
      performPincodeLookup(value);
    } else {
      setLookupError(null);
      setPostOffices([]);
      if (value.length === 0) {
        setIsServiceable(null);
      }
    }
  };

  // Run initial lookup on mount for default PIN
  useEffect(() => {
    if (pincode && pincode.length === 6) {
      performPincodeLookup(pincode);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Handle locality/post office selection
  const handleSelectLocality = (poName: string) => {
    setSelectedPostOffice(poName);
    setArea(poName);
  };

  const handleUseCurrentLocation = () => {
    setIsLocating(true);
    if (typeof navigator !== 'undefined' && 'geolocation' in navigator) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setCoordinates({
            latitude: position.coords.latitude,
            longitude: position.coords.longitude,
          });
          setIsLocating(false);
          // Auto fill Bangalore indiranagar cluster for GPS demo
          setPincode('560038');
          performPincodeLookup('560038');
        },
        () => {
          setIsLocating(false);
          setPincode('560038');
          performPincodeLookup('560038');
        },
        { enableHighAccuracy: true, timeout: 5000 },
      );
    } else {
      setTimeout(() => {
        setIsLocating(false);
        setPincode('560038');
        performPincodeLookup('560038');
      }, 600);
    }
  };

  const handleSave = async (e?: React.FormEvent | React.MouseEvent) => {
    if (e) e.preventDefault();

    if (!pincode || pincode.length !== 6) {
      setSaveError('Please enter a valid 6-digit PIN code.');
      return;
    }
    if (!house.trim()) {
      setSaveError('Please enter house / flat / building number.');
      return;
    }
    if (!street.trim()) {
      setSaveError('Please enter street or road name.');
      return;
    }

    setIsSaving(true);
    setSaveError(null);

    try {
      await apiClient.createAddress(
        {
          label: addressType.toUpperCase() as 'HOME' | 'WORK' | 'OTHER',
          fullName,
          phone: mobile,
          houseNo: house,
          street,
          area: area || selectedPostOffice || undefined,
          city: city || district,
          district: district || undefined,
          state: state || undefined,
          country: country || 'India',
          pincode,
          landmark: landmark || undefined,
          isDefault,
          isServiceable: isServiceable ?? false,
          ...(coordinates ? { latitude: coordinates.latitude, longitude: coordinates.longitude } : {}),
        },
        userId,
      );
      router.push(returnTo);
    } catch (err: any) {
      setSaveError(err?.message || 'Failed to save address. Please try again.');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="bg-[#f9f9fc] font-['Inter'] text-[#1a1c1e] antialiased min-h-screen flex flex-col">
      {/* Top App Bar */}
      <header className="fixed top-0 w-full z-50 backdrop-blur-xl bg-[#f9f9fc]/90 flex items-center px-4 h-16 shadow-sm border-b border-[#e2e2e5]">
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
      <main className="pt-20 pb-36 px-4 max-w-md mx-auto w-full flex-1">
        {/* Map Preview Section */}
        <section className="mb-5 rounded-2xl overflow-hidden bg-white shadow-sm border border-[#e2e2e5] relative h-36">
          <div className="w-full h-full bg-[#f1f8f4] flex flex-col items-center justify-center relative">
            <div className="w-8 h-8 rounded-full bg-[#006b23] flex items-center justify-center text-white shadow-md">
              <span className="material-symbols-outlined text-[20px]">location_on</span>
            </div>
            <span className="font-['Outfit'] text-[12px] font-semibold text-[#1a1c1e] mt-1">
              {city ? `${area ? `${area}, ` : ''}${city}` : 'Select Delivery Location'}
            </span>
          </div>
          <div className="absolute bottom-2.5 left-1/2 -translate-x-1/2 w-11/12 max-w-sm">
            <button
              onClick={handleUseCurrentLocation}
              disabled={isLocating}
              type="button"
              className="w-full bg-white/95 backdrop-blur-md text-[#1a1c1e] font-['Inter'] text-xs font-semibold py-2 px-3 rounded-xl flex items-center justify-center gap-2 shadow-sm border border-[#e2e2e5] active:scale-95 transition-transform"
            >
              <span className="material-symbols-outlined text-[#006b23] text-sm">my_location</span>
              {isLocating ? 'Detecting GPS...' : 'Use Current Location'}
            </button>
          </div>
        </section>

        {/* Dynamic Delivery Serviceability Banner */}
        {isServiceable === true && (
          <div className="bg-[#e8f5e9] border border-[#a5d6a7] rounded-xl p-3.5 flex items-start gap-3 mb-5 shadow-sm">
            <span className="material-symbols-outlined text-[#006b23] mt-0.5 text-xl">check_circle</span>
            <div>
              <p className="text-sm font-semibold text-[#1b5e20]">10-Min Kirana Delivery Available</p>
              <p className="text-xs text-[#2e7d32] mt-0.5">
                Great news! PIN {pincode} is served by Daily Basket dark stores with 10-minute instant delivery.
              </p>
            </div>
          </div>
        )}

        {isServiceable === false && !lookupError && pincode.length === 6 && (
          <div className="bg-[#fff8e1] border border-[#ffe082] rounded-xl p-3.5 flex items-start gap-3 mb-5 shadow-sm">
            <span className="material-symbols-outlined text-[#f57f17] mt-0.5 text-xl">info</span>
            <div>
              <p className="text-sm font-semibold text-[#e65100]">Outside Current 10-Min Delivery Zone</p>
              <p className="text-xs text-[#bf360c] mt-0.5">
                Postal location verified ({city || district}, {state}), but Daily Basket rapid delivery is not yet active here. You can still save this address for future rollout.
              </p>
            </div>
          </div>
        )}

        {lookupError && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-3.5 flex items-start gap-3 mb-5 text-red-700 shadow-sm">
            <span className="material-symbols-outlined text-red-600 mt-0.5 text-xl">error</span>
            <div>
              <p className="text-sm font-semibold">Postal Lookup Notice</p>
              <p className="text-xs text-red-600/90 mt-0.5">{lookupError}</p>
            </div>
          </div>
        )}

        {saveError && (
          <div className="mb-5 bg-red-50 border border-red-200 rounded-xl p-3.5 flex items-start gap-3 text-red-700 shadow-sm">
            <span className="material-symbols-outlined text-red-600 mt-0.5 text-xl">error</span>
            <div>
              <p className="text-sm font-semibold">Error Saving Address</p>
              <p className="text-xs text-red-600/90 mt-0.5">{saveError}</p>
            </div>
          </div>
        )}

        {/* Address Form */}
        <form onSubmit={handleSave} className="space-y-4">
          {/* Contact Details */}
          <div>
            <h2 className="font-['Outfit'] text-base font-semibold text-[#1a1c1e] mb-2.5">
              Contact Details
            </h2>
            <div className="space-y-2.5">
              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23] focus-within:ring-1 focus-within:ring-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Full Name *
                </label>
                <input
                  type="text"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder="Rahul Sharma"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                  required
                />
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23] focus-within:ring-1 focus-within:ring-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Mobile Number *
                </label>
                <div className="flex items-center">
                  <span className="text-[#3f4a3d] text-sm font-semibold mr-2">+91</span>
                  <input
                    type="tel"
                    value={mobile}
                    onChange={(e) => setMobile(e.target.value.replace(/\D/g, '').slice(0, 10))}
                    placeholder="98765 43210"
                    maxLength={10}
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                    required
                  />
                </div>
              </div>
            </div>
          </div>

          {/* Postal & Location Details */}
          <div>
            <h2 className="font-['Outfit'] text-base font-semibold text-[#1a1c1e] mb-2.5 mt-5">
              Postal & Geographic Location
            </h2>
            <div className="space-y-2.5">
              {/* PIN Code with Auto-fetch Status Indicator */}
              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 relative focus-within:border-[#006b23] focus-within:ring-1 focus-within:ring-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider flex justify-between">
                  <span>PIN Code *</span>
                  <span className="text-[#006b23] font-bold text-[9px]">AUTO-FETCHES POSTAL DATA</span>
                </label>
                <div className="flex items-center justify-between">
                  <input
                    type="text"
                    value={pincode}
                    onChange={handlePincodeChange}
                    maxLength={6}
                    placeholder="Enter 6-digit PIN (e.g. 582103, 560038)"
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-bold tracking-wide"
                    required
                  />
                  {isLookingUpPin ? (
                    <div className="w-4 h-4 border-2 border-[#006b23] border-t-transparent rounded-full animate-spin shrink-0" />
                  ) : pincode.length === 6 && !lookupError ? (
                    <span className="material-symbols-outlined text-[#006b23] text-lg shrink-0">check_circle</span>
                  ) : null}
                </div>
              </div>

              {/* Locality Selector for PIN codes with multiple post offices */}
              {postOffices.length > 1 && (
                <div className="bg-white rounded-xl border border-[#e2e2e5] p-3">
                  <label className="text-[10px] font-semibold text-[#006b23] uppercase tracking-wider block mb-2">
                    Multiple Localities Found ({postOffices.length}). Select Yours:
                  </label>
                  <div className="flex flex-wrap gap-1.5 max-h-32 overflow-y-auto pr-1">
                    {postOffices.map((po: any, idx: number) => {
                      const poName = po.name || po.Name || (typeof po === 'string' ? po : `Locality ${idx + 1}`);
                      const isSelected = selectedPostOffice === poName;
                      return (
                        <button
                          key={`${poName}-${idx}`}
                          type="button"
                          onClick={() => handleSelectLocality(poName)}
                          className={`text-xs px-2.5 py-1 rounded-lg border transition-all text-left ${
                            isSelected
                              ? 'bg-[#006b23] text-white border-[#006b23] font-semibold shadow-xs'
                              : 'bg-[#f9f9fc] text-[#3f4a3d] border-[#e2e2e5] hover:bg-[#e8f5e9]'
                          }`}
                        >
                          {poName}
                        </button>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* Country, State, District, City Grid */}
              <div className="grid grid-cols-2 gap-2.5">
                <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                  <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                    Country
                  </label>
                  <input
                    type="text"
                    value={country}
                    onChange={(e) => setCountry(e.target.value)}
                    placeholder="India"
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none"
                    required
                  />
                </div>

                <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                  <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                    State
                  </label>
                  <input
                    type="text"
                    value={state}
                    onChange={(e) => setState(e.target.value)}
                    placeholder="Karnataka"
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                    required
                  />
                </div>

                <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                  <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                    District
                  </label>
                  <input
                    type="text"
                    value={district}
                    onChange={(e) => setDistrict(e.target.value)}
                    placeholder="District (e.g. Gadag)"
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                    required
                  />
                </div>

                <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                  <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                    City / Town / Village
                  </label>
                  <input
                    type="text"
                    value={city}
                    onChange={(e) => setCity(e.target.value)}
                    placeholder="City"
                    className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                    required
                  />
                </div>
              </div>

              {/* Area / Locality */}
              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Area / Locality *
                </label>
                <input
                  type="text"
                  value={area}
                  onChange={(e) => setArea(e.target.value)}
                  placeholder="e.g. Indiranagar, Betageri, etc."
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                  required
                />
              </div>
            </div>
          </div>

          {/* House / Street / Landmark */}
          <div>
            <h2 className="font-['Outfit'] text-base font-semibold text-[#1a1c1e] mb-2.5 mt-5">
              House & Street Details
            </h2>
            <div className="space-y-2.5">
              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  House / Flat / Building Number *
                </label>
                <input
                  type="text"
                  value={house}
                  onChange={(e) => setHouse(e.target.value)}
                  placeholder="e.g. Flat 302, Green Glen Apartments"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                  required
                />
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider block">
                  Street / Road Name *
                </label>
                <input
                  type="text"
                  value={street}
                  onChange={(e) => setStreet(e.target.value)}
                  placeholder="e.g. 100ft Road, Main Bazaar Road"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                  required
                />
              </div>

              <div className="bg-white rounded-xl border border-[#e2e2e5] px-3.5 pt-2 pb-1.5 focus-within:border-[#006b23]">
                <label className="text-[10px] font-semibold text-[#3f4a3d] uppercase tracking-wider flex justify-between">
                  <span>Landmark</span>
                  <span className="normal-case opacity-60 text-[9px]">(Optional)</span>
                </label>
                <input
                  type="text"
                  value={landmark}
                  onChange={(e) => setLandmark(e.target.value)}
                  placeholder="e.g. Opposite State Bank, Near Clock Tower"
                  className="w-full bg-transparent border-none text-[#1a1c1e] text-sm p-0 focus:ring-0 focus:outline-none font-medium"
                />
              </div>
            </div>
          </div>

          {/* Address Type Selection */}
          <div>
            <h2 className="font-['Outfit'] text-base font-semibold text-[#1a1c1e] mb-2.5 mt-5">
              Address Type
            </h2>
            <div className="flex gap-2.5">
              {[
                { id: 'home' as const, label: 'Home', icon: 'home' },
                { id: 'work' as const, label: 'Work', icon: 'work' },
                { id: 'other' as const, label: 'Other', icon: 'location_on' },
              ].map((item) => {
                const isSelected = addressType === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => setAddressType(item.id)}
                    className={`flex-1 py-2 rounded-xl border flex items-center justify-center gap-1.5 transition-all shadow-xs ${
                      isSelected
                        ? 'bg-[#e8f5e9] border-[#006b23] text-[#006b23] font-semibold'
                        : 'bg-white border-[#e2e2e5] text-[#3f4a3d] hover:bg-slate-50'
                    }`}
                  >
                    <span className="material-symbols-outlined text-base">{item.icon}</span>
                    <span className="text-xs font-semibold">{item.label}</span>
                  </button>
                );
              })}
            </div>
          </div>

          {/* Set as Default Address */}
          <div className="bg-white rounded-xl border border-[#e2e2e5] p-3.5 flex items-center justify-between mt-4">
            <div>
              <p className="text-sm font-semibold text-[#1a1c1e]">Set as Default Delivery Address</p>
              <p className="text-xs text-[#3f4a3d] mt-0.5">Use this address for all future quick orders</p>
            </div>
            <button
              type="button"
              role="switch"
              aria-checked={isDefault}
              onClick={() => setIsDefault(!isDefault)}
              className={`w-11 h-6 rounded-full transition-colors relative focus:outline-none ${
                isDefault ? 'bg-[#006b23]' : 'bg-[#e2e2e5]'
              }`}
            >
              <span
                className={`w-5 h-5 bg-white rounded-full absolute top-0.5 transition-transform shadow-xs ${
                  isDefault ? 'left-[22px]' : 'left-0.5'
                }`}
              />
            </button>
          </div>
        </form>
      </main>

      {/* Fixed Bottom Action */}
      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full bg-[#f9f9fc]/95 backdrop-blur-md border-t border-[#e2e2e5] p-4 z-40 max-w-md">
        <button
          onClick={handleSave}
          disabled={isSaving || isLookingUpPin}
          type="button"
          className="w-full bg-[#006b23] hover:bg-[#078730] text-white font-['Outfit'] font-semibold text-base py-3.5 rounded-xl shadow-md active:scale-[0.98] transition-all flex items-center justify-center gap-2 disabled:opacity-60"
        >
          {isSaving ? (
            <>
              <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
              <span>Saving Address...</span>
            </>
          ) : (
            <span>Save & Use Address</span>
          )}
        </button>
      </div>
    </div>
  );
}

export default function AddDeliveryAddressPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-[#f9f9fc]" />}>
      <AddDeliveryAddressInner />
    </Suspense>
  );
}
