import React from 'react';
import Link from 'next/link';
import {
  Briefcase,
  MapPin,
  Clock,
  Sparkles,
  Zap,
  ShieldCheck,
  Heart,
  ArrowRight,
  Search,
  ShoppingBag,
} from 'lucide-react';

export const metadata = {
  title: 'Careers | Daily Basket',
  description: 'Join the team building ultra-fast 10-minute quick commerce at Daily Basket.',
};

export default function CareersPage() {
  const jobs = [
    {
      id: 'j1',
      title: 'Senior Backend Engineer (Golang/Node.js)',
      department: 'Engineering',
      location: 'Bengaluru, India (Hybrid)',
      type: 'Full-Time',
      experience: '4-7 yrs',
      description: 'Build real-time dispatch routing engines for under 10-minute order fulfillment across 500+ dark stores.',
    },
    {
      id: 'j2',
      title: 'Dark Store Operations Manager',
      department: 'Operations',
      location: 'Mumbai, India',
      type: 'Full-Time',
      experience: '3-5 yrs',
      description: 'Oversee inventory throughput, picker speed optimization, and daily dispatch SLA fulfillment.',
    },
    {
      id: 'j3',
      title: 'Lead Product Manager - Rider Ecosystem',
      department: 'Product',
      location: 'Bengaluru, India',
      type: 'Full-Time',
      experience: '5+ yrs',
      description: 'Design intuitive mobile apps and automated safety algorithms for our 20,000+ delivery fleet.',
    },
    {
      id: 'j4',
      title: 'Growth Marketing Lead',
      department: 'Marketing',
      location: 'Delhi NCR, India',
      type: 'Full-Time',
      experience: '4-6 yrs',
      description: 'Drive hyper-local customer acquisition campaigns and push notification retention strategies.',
    },
  ];

  return (
    <div className="min-h-screen bg-[#f9f9fc] text-[#1a1c1e] font-sans pt-20 pb-16">
      {/* Navbar Header */}
      <header className="fixed top-0 inset-x-0 z-50 bg-[#f9f9fc]/80 backdrop-blur-xl border-b border-[#e2e2e5]">
        <div className="max-w-7xl mx-auto px-4 md:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center gap-6">
            <Link href="/" className="flex items-center gap-2 text-[#006b23] font-bold text-xl tracking-tight">
              <span className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center font-black text-sm">DB</span>
              Daily Basket
            </Link>
          </div>
          <nav className="hidden md:flex items-center gap-6 font-medium text-sm text-[#3f4a3d]">
            <Link href="/" className="hover:text-[#006b23] transition">Home</Link>
            <Link href="/categories" className="hover:text-[#006b23] transition">Categories</Link>
            <Link href="/about" className="hover:text-[#006b23] transition">About</Link>
            <Link href="/contact" className="hover:text-[#006b23] transition">Contact</Link>
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
        {/* Careers Hero */}
        <div className="bg-gradient-to-br from-[#006b23] via-[#078730] to-[#002106] text-white rounded-3xl p-8 md:p-16 shadow-lg mb-12 text-center md:text-left relative overflow-hidden">
          <div className="max-w-2xl space-y-4 relative z-10">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/20 text-white text-xs font-semibold backdrop-blur-md">
              <Sparkles className="w-3.5 h-3.5" /> We are Hiring Innovators
            </span>
            <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight">
              Build the future of ultra-fast commerce.
            </h1>
            <p className="text-emerald-100 text-base md:text-lg">
              We are reinventing retail with 10-minute grocery deliveries. Join a high-velocity team operating at scale.
            </p>
            <div className="pt-2">
              <a
                href="#open-positions"
                className="inline-flex items-center gap-2 px-6 py-3 bg-white text-[#006b23] rounded-xl font-bold text-sm hover:bg-emerald-50 transition"
              >
                <span>View Open Roles</span>
                <ArrowRight className="w-4 h-4" />
              </a>
            </div>
          </div>
        </div>

        {/* Culture Bento Grid */}
        <div className="mb-14 space-y-6">
          <h2 className="text-2xl font-bold text-[#1a1c1e] text-center md:text-left">Why Work With Us?</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white rounded-3xl p-8 shadow-sm border border-[#e2e2e5] space-y-3">
              <div className="w-12 h-12 rounded-2xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
                <Zap className="w-6 h-6" />
              </div>
              <h3 className="text-lg font-bold text-[#1a1c1e]">High-Velocity Impact</h3>
              <p className="text-sm text-[#3f4a3d] leading-relaxed">
                Your code and operational decisions directly affect 500,000+ daily orders and 20,000+ riders.
              </p>
            </div>

            <div className="bg-white rounded-3xl p-8 shadow-sm border border-[#e2e2e5] space-y-3">
              <div className="w-12 h-12 rounded-2xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
                <Heart className="w-6 h-6" />
              </div>
              <h3 className="text-lg font-bold text-[#1a1c1e]">Comprehensive Care</h3>
              <p className="text-sm text-[#3f4a3d] leading-relaxed">
                Full health insurance for family & dependents, wellness stipends, mental health support, and flexible PTO.
              </p>
            </div>

            <div className="bg-white rounded-3xl p-8 shadow-sm border border-[#e2e2e5] space-y-3">
              <div className="w-12 h-12 rounded-2xl bg-[#dce5dd] text-[#006b23] flex items-center justify-center font-bold">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <h3 className="text-lg font-bold text-[#1a1c1e]">Competitive Equity & Pay</h3>
              <p className="text-sm text-[#3f4a3d] leading-relaxed">
                Top-of-market compensation packages with ESOP grants designed for long-term wealth creation.
              </p>
            </div>
          </div>
        </div>

        {/* Open Positions List */}
        <div id="open-positions" className="space-y-6">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl font-bold text-[#1a1c1e]">Open Positions</h2>
              <p className="text-sm text-[#3f4a3d]">Explore current opportunities across engineering, product, and operations.</p>
            </div>
            <div className="flex gap-2 overflow-x-auto">
              <button className="px-4 py-2 bg-[#006b23] text-white text-xs font-bold rounded-full">All Teams</button>
              <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] text-xs font-bold rounded-full">Engineering</button>
              <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] text-xs font-bold rounded-full">Operations</button>
              <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] text-xs font-bold rounded-full">Product</button>
            </div>
          </div>

          <div className="space-y-4">
            {jobs.map((job) => (
              <div
                key={job.id}
                className="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] flex flex-col md:flex-row md:items-center justify-between gap-6 hover:border-[#006b23] transition"
              >
                <div className="space-y-2 max-w-2xl">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="px-3 py-1 bg-[#dce5dd] text-[#006b23] text-xs font-bold rounded-full">
                      {job.department}
                    </span>
                    <span className="px-3 py-1 bg-[#f3f3f6] text-[#3f4a3d] text-xs font-medium rounded-full flex items-center gap-1">
                      <MapPin className="w-3 h-3" /> {job.location}
                    </span>
                    <span className="px-3 py-1 bg-[#f3f3f6] text-[#3f4a3d] text-xs font-medium rounded-full flex items-center gap-1">
                      <Clock className="w-3 h-3" /> {job.type}
                    </span>
                  </div>
                  <h3 className="text-xl font-bold text-[#1a1c1e]">{job.title}</h3>
                  <p className="text-sm text-[#3f4a3d]">{job.description}</p>
                </div>

                <div className="shrink-0">
                  <button className="w-full md:w-auto inline-flex items-center justify-center gap-2 px-6 py-3 bg-[#006b23] text-white text-sm font-bold rounded-xl hover:bg-[#078730] transition active:scale-95">
                    <span>Apply Now</span>
                    <ArrowRight className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </main>
    </div>
  );
}
