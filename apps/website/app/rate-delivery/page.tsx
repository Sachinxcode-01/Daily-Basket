'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ArrowLeft, Star, Heart, ThumbsUp, Sparkles, CheckCircle2 } from 'lucide-react';

export default function RateDeliveryPage() {
  const router = useRouter();
  const [rating, setRating] = useState(5);
  const [hoverRating, setHoverRating] = useState(0);
  const [selectedTips, setSelectedTips] = useState<number | null>(30);
  const [compliments, setCompliments] = useState<string[]>(['Fast Delivery', 'Fresh Packing']);
  const [feedbackText, setFeedbackText] = useState('');
  const [isSubmitted, setIsSubmitted] = useState(false);

  const availableCompliments = [
    'Fast Delivery',
    'Polite Rider',
    'Fresh Packing',
    'Good Communication',
    'Followed Instructions',
  ];

  const tipOptions = [20, 30, 50, 100];

  const toggleCompliment = (comp: string) => {
    setCompliments((prev) =>
      prev.includes(comp) ? prev.filter((c) => c !== comp) : [...prev, comp]
    );
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitted(true);
    setTimeout(() => {
      router.push('/');
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      
      {/* ─── Header ────────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <h1 className="text-xl font-extrabold text-slate-900 font-outfit">
              Rate Your Delivery
            </h1>
          </div>
        </div>
      </header>

      {/* ─── Main Content Canvas ────────────────────────────────────────── */}
      <main className="max-w-xl mx-auto px-4 sm:px-8 pt-6">
        
        {isSubmitted ? (
          <div className="bg-white rounded-3xl p-8 border border-slate-100 shadow-xl text-center space-y-4 animate-[fadeInUp_0.5s_ease-out]">
            <div className="w-20 h-20 bg-[#006b23] text-white rounded-full flex items-center justify-center mx-auto shadow-lg shadow-[#006b23]/30">
              <CheckCircle2 className="w-12 h-12 stroke-[2.5]" />
            </div>
            <h2 className="text-2xl font-extrabold font-outfit text-slate-900">
              Thank You for Your Feedback!
            </h2>
            <p className="text-slate-600 text-sm font-inter">
              Your rating helps us maintain top delivery quality for Daily Basket.
            </p>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="bg-white rounded-3xl p-6 sm:p-8 border border-slate-100 shadow-sm space-y-6">
            
            {/* Rider Card */}
            <div className="flex items-center gap-4 p-4 bg-slate-50 rounded-2xl border border-slate-100">
              <div className="w-16 h-16 rounded-full bg-emerald-100 text-[#006b23] font-bold text-2xl flex items-center justify-center border-2 border-emerald-200">
                RK
              </div>
              <div>
                <h2 className="font-outfit font-bold text-lg text-slate-900">
                  Ramesh Kumar
                </h2>
                <p className="text-xs text-slate-500 font-inter mt-0.5">
                  Delivered Order #ORD-9824 in 8 Mins
                </p>
              </div>
            </div>

            {/* Interactive 5 Star Rating */}
            <div className="text-center space-y-2">
              <p className="text-sm font-bold text-slate-700 font-outfit uppercase tracking-wider">
                How was your experience?
              </p>

              <div className="flex items-center justify-center gap-2 py-2">
                {[1, 2, 3, 4, 5].map((star) => (
                  <button
                    key={star}
                    type="button"
                    onClick={() => setRating(star)}
                    onMouseEnter={() => setHoverRating(star)}
                    onMouseLeave={() => setHoverRating(0)}
                    className="p-1 text-amber-400 hover:scale-125 transition-transform"
                  >
                    <Star
                      className={`w-9 h-9 ${
                        (hoverRating || rating) >= star
                          ? 'fill-amber-400 text-amber-400'
                          : 'text-slate-200'
                      }`}
                    />
                  </button>
                ))}
              </div>
            </div>

            {/* Compliments */}
            <div className="space-y-3">
              <p className="text-xs font-bold text-slate-500 font-outfit uppercase tracking-wider">
                Add a Compliment
              </p>
              <div className="flex flex-wrap gap-2">
                {availableCompliments.map((comp) => {
                  const isSelected = compliments.includes(comp);
                  return (
                    <button
                      key={comp}
                      type="button"
                      onClick={() => toggleCompliment(comp)}
                      className={`px-3.5 py-1.5 rounded-full text-xs font-semibold transition ${
                        isSelected
                          ? 'bg-[#006b23] text-white shadow-sm'
                          : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                      }`}
                    >
                      {comp}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Tip Option */}
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <p className="text-xs font-bold text-slate-500 font-outfit uppercase tracking-wider">
                  Tip your delivery partner
                </p>
                <span className="text-xs text-emerald-600 font-bold font-inter">100% goes to rider</span>
              </div>
              <div className="flex items-center gap-3">
                {tipOptions.map((tip) => (
                  <button
                    key={tip}
                    type="button"
                    onClick={() => setSelectedTips(selectedTips === tip ? null : tip)}
                    className={`flex-1 py-2.5 rounded-xl font-outfit font-bold text-sm border transition ${
                      selectedTips === tip
                        ? 'bg-emerald-50 border-[#006b23] text-[#006b23]'
                        : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50'
                    }`}
                  >
                    ₹{tip}
                  </button>
                ))}
              </div>
            </div>

            {/* Textarea Feedback */}
            <div className="space-y-2">
              <p className="text-xs font-bold text-slate-500 font-outfit uppercase tracking-wider">
                Write a note (Optional)
              </p>
              <textarea
                value={feedbackText}
                onChange={(e) => setFeedbackText(e.target.value)}
                placeholder="Share any additional details about your order delivery..."
                rows={3}
                className="w-full p-3.5 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:ring-2 focus:ring-[#006b23] focus:outline-none"
              />
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              className="w-full py-4 bg-[#006b23] hover:bg-[#00531a] active:scale-[0.98] text-white rounded-full font-bold text-base font-outfit shadow-md shadow-[#006b23]/20 transition"
            >
              Submit Feedback
            </button>

          </form>
        )}

      </main>
    </div>
  );
}
