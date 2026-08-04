'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { ArrowLeft, Clock, MapPin, Phone, ShieldCheck, CheckCircle2, Navigation, ShoppingBag } from 'lucide-react';

export default function DeliveryTrackingPage() {
  const params = useParams();
  const orderId = params?.id || 'ORD-9824';

  const [etaMinutes, setEtaMinutes] = useState(8);

  useEffect(() => {
    const timer = setInterval(() => {
      setEtaMinutes((prev) => (prev > 1 ? prev - 1 : 1));
    }, 60000);
    return () => clearInterval(timer);
  }, []);

  const steps = [
    { title: 'Order Placed', time: '10:42 AM', completed: true },
    { title: 'Packed at Dark Store', time: '10:44 AM', completed: true },
    { title: 'Out for Delivery', time: '10:46 AM', completed: true, current: true },
    { title: 'Delivered to Doorstep', time: 'Est. 10:50 AM', completed: false },
  ];

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <div>
              <h1 className="text-lg sm:text-xl font-extrabold text-slate-900 font-outfit">
                Live Order Tracking
              </h1>
              <p className="text-xs text-slate-500 font-medium font-inter">
                Order #{orderId}
              </p>
            </div>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-6">
        
        {/* ETA Hero Card */}
        <div className="bg-[#006b23] text-white rounded-3xl p-6 sm:p-8 shadow-lg relative overflow-hidden flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <span className="inline-block px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider">
              Express Delivery
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold font-outfit">
              Arriving in {etaMinutes} Mins
            </h2>
            <p className="text-white/90 text-sm font-inter">
              Your partner Ramesh is on the way with your fresh basket!
            </p>
          </div>

          <div className="w-20 h-20 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center flex-shrink-0 animate-pulse">
            <Navigation className="w-10 h-10 text-white" />
          </div>
        </div>

        {/* Rider Profile Card */}
        <div className="bg-white rounded-2xl p-5 border border-slate-100 shadow-sm flex items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-full bg-emerald-100 text-[#006b23] font-bold text-xl flex items-center justify-center border-2 border-emerald-200">
              RK
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h3 className="font-outfit font-bold text-base text-slate-900">Ramesh Kumar</h3>
                <span className="text-xs bg-amber-100 text-amber-800 font-bold px-2 py-0.5 rounded-full">
                  ★ 4.9
                </span>
              </div>
              <p className="text-xs text-slate-500 font-inter mt-0.5">
                Vaccinated • 1,200+ Express Deliveries
              </p>
            </div>
          </div>

          <a
            href="tel:+919876543210"
            className="w-11 h-11 rounded-full bg-[#006b23] text-white flex items-center justify-center shadow-md shadow-[#006b23]/20 hover:bg-[#00531a] transition"
          >
            <Phone className="w-5 h-5" />
          </a>
        </div>

        {/* Progress Stepper */}
        <div className="bg-white rounded-2xl p-6 border border-slate-100 shadow-sm space-y-6">
          <h3 className="text-base font-bold font-outfit text-slate-900">Delivery Status</h3>

          <div className="relative pl-6 border-l-2 border-slate-200 space-y-6 ml-3">
            {steps.map((step, idx) => (
              <div key={step.title} className="relative flex items-start justify-between group">
                <div
                  className={`absolute -left-[31px] top-0 w-6 h-6 rounded-full border-2 flex items-center justify-center ${
                    step.completed
                      ? 'bg-[#006b23] border-[#006b23] text-white'
                      : step.current
                      ? 'bg-white border-[#006b23] text-[#006b23]'
                      : 'bg-white border-slate-300 text-slate-300'
                  }`}
                >
                  {step.completed ? (
                    <CheckCircle2 className="w-4 h-4 stroke-[3]" />
                  ) : (
                    <div className={`w-2 h-2 rounded-full ${step.current ? 'bg-[#006b23]' : 'bg-slate-300'}`} />
                  )}
                </div>

                <div>
                  <h4 className={`font-outfit text-sm font-semibold ${step.current ? 'text-[#006b23]' : 'text-slate-900'}`}>
                    {step.title}
                  </h4>
                  <p className="text-xs text-slate-400 font-inter mt-0.5">{step.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

      </main>
    </div>
  );
}
