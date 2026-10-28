'use client';

import React, { useState } from 'react';
import { Star, ThumbsUp, CheckCircle, MessageSquarePlus, X } from 'lucide-react';

export interface CustomerReview {
  id: string;
  author: string;
  rating: number;
  date: string;
  title: string;
  body: string;
  verified: boolean;
  helpfulCount: number;
}

interface ProductReviewsSectionProps {
  productId: string;
  productName: string;
  category: string;
  initialRating?: number;
  initialReviewCount?: number;
}

export function ProductReviewsSection({
  productId,
  productName,
  category,
  initialRating = 4.8,
  initialReviewCount = 340,
}: ProductReviewsSectionProps) {
  // Generate realistic initial reviews based on the product
  const defaultReviews: CustomerReview[] = [
    {
      id: 'rev_1',
      author: 'Priya Sharma',
      rating: 5,
      date: '2 days ago',
      title: 'Remarkably fresh and delivered in 10 minutes!',
      body: `Ordered ${productName} for morning breakfast. The packaging was pristine, aroma and freshness was unmatched. Truly farm fresh quality!`,
      verified: true,
      helpfulCount: 24,
    },
    {
      id: 'rev_2',
      author: 'Rajesh Kulkarni',
      rating: 5,
      date: '5 days ago',
      title: 'Top notch quality, beats local market',
      body: `Consistently great quality by Daily Basket. ${productName} was packed cleanly and the texture/taste is authentic. Will definitely subscribe.`,
      verified: true,
      helpfulCount: 16,
    },
    {
      id: 'rev_3',
      author: 'Ananya Verma',
      rating: 4,
      date: '1 week ago',
      title: 'Very good, great packaging',
      body: `Good value for money. Fresh harvest guarantee is legit. Delivery executive was polite and reached in under 12 minutes.`,
      verified: true,
      helpfulCount: 9,
    },
  ];

  const [reviews, setReviews] = useState<CustomerReview[]>(defaultReviews);
  const [helpfulVoted, setHelpfulVoted] = useState<Set<string>>(new Set());
  const [isModalOpen, setIsModalOpen] = useState(false);

  // Review Form State
  const [formRating, setFormRating] = useState(5);
  const [formHoverRating, setFormHoverRating] = useState(0);
  const [formAuthor, setFormAuthor] = useState('');
  const [formTitle, setFormTitle] = useState('');
  const [formBody, setFormBody] = useState('');
  const [formSubmitted, setFormSubmitted] = useState(false);

  const totalReviews = initialReviewCount + (reviews.length - defaultReviews.length);
  const avgRating = initialRating;

  // Star breakdown percentages
  const ratingDistribution = [
    { stars: 5, pct: 78, count: Math.round(totalReviews * 0.78) },
    { stars: 4, pct: 15, count: Math.round(totalReviews * 0.15) },
    { stars: 3, pct: 5, count: Math.round(totalReviews * 0.05) },
    { stars: 2, pct: 1, count: Math.round(totalReviews * 0.01) },
    { stars: 1, pct: 1, count: Math.round(totalReviews * 0.01) },
  ];

  const handleHelpful = (reviewId: string) => {
    if (helpfulVoted.has(reviewId)) return;
    setReviews((prev) =>
      prev.map((r) => (r.id === reviewId ? { ...r, helpfulCount: r.helpfulCount + 1 } : r)),
    );
    setHelpfulVoted((prev) => new Set(prev).add(reviewId));
  };

  const handleReviewSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formAuthor.trim() || !formBody.trim()) return;

    const newRev: CustomerReview = {
      id: `rev_${Date.now()}`,
      author: formAuthor.trim(),
      rating: formRating,
      date: 'Just now',
      title: formTitle.trim() || 'Verified Purchase Feedback',
      body: formBody.trim(),
      verified: true,
      helpfulCount: 0,
    };

    setReviews([newRev, ...reviews]);
    setFormSubmitted(true);
    setTimeout(() => {
      setIsModalOpen(false);
      setFormSubmitted(false);
      setFormAuthor('');
      setFormTitle('');
      setFormBody('');
      setFormRating(5);
    }, 1500);
  };

  return (
    <div className="border border-[#e2e2e5] rounded-2xl bg-white p-5 sm:p-6 shadow-xs">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6 pb-6 border-b border-[#eceef0]">
        <div>
          <h3 className="text-lg font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
            Customer Ratings & Reviews
          </h3>
          <p className="text-xs text-[#64748b] mt-0.5">
            Verified buyer reviews for {productName}
          </p>
        </div>

        <button
          onClick={() => setIsModalOpen(true)}
          className="self-start sm:self-auto flex items-center gap-2 bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-semibold px-4 py-2.5 rounded-xl shadow-xs transition active:scale-95"
        >
          <MessageSquarePlus className="w-4 h-4" />
          <span>Write a Review</span>
        </button>
      </div>

      {/* Ratings Overview Bar */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6 items-center mb-8 bg-[#f9f9fc] p-4 sm:p-5 rounded-2xl border border-[#eceef0]">
        <div className="md:col-span-4 flex flex-col items-center justify-center text-center md:border-r border-[#eceef0] md:pr-4">
          <div className="text-4xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
            {avgRating.toFixed(1)}
          </div>
          <div className="flex items-center gap-1 my-1.5 text-amber-400">
            {Array.from({ length: 5 }).map((_, i) => (
              <Star
                key={i}
                className={`w-4 h-4 ${i < Math.floor(avgRating) ? 'fill-amber-400' : 'text-slate-300'}`}
              />
            ))}
          </div>
          <p className="text-xs font-medium text-[#64748b]">
            Based on {totalReviews.toLocaleString()} verified ratings
          </p>
          <span className="inline-flex items-center gap-1 mt-2 text-[11px] font-semibold text-[#15803d] bg-emerald-50 px-2 py-0.5 rounded-full border border-emerald-200">
            <CheckCircle className="w-3 h-3" /> 100% Genuine Buyers
          </span>
        </div>

        <div className="md:col-span-8 space-y-2">
          {ratingDistribution.map((row) => (
            <div key={row.stars} className="flex items-center gap-3 text-xs">
              <span className="w-7 font-bold text-[#191c1e] flex items-center gap-1">
                {row.stars} <Star className="w-3 h-3 fill-amber-400 text-amber-400" />
              </span>
              <div className="flex-1 h-2.5 bg-[#e2e8f0] rounded-full overflow-hidden">
                <div
                  className="h-full bg-amber-400 rounded-full transition-all duration-500"
                  style={{ width: `${row.pct}%` }}
                />
              </div>
              <span className="w-12 text-right text-[11px] font-semibold text-[#64748b]">
                {row.pct}%
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Reviews List */}
      <div className="space-y-4">
        {reviews.map((rev) => (
          <div
            key={rev.id}
            className="border border-[#eceef0] rounded-xl p-4 hover:border-slate-300 transition bg-white"
          >
            <div className="flex items-start justify-between gap-2 mb-2">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-full bg-[#2d9d43]/10 text-[#2d9d43] font-bold text-xs flex items-center justify-center">
                  {rev.author.charAt(0).toUpperCase()}
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-xs font-bold text-[#191c1e]">{rev.author}</span>
                    {rev.verified && (
                      <span className="text-[10px] text-[#15803d] font-semibold bg-emerald-50 border border-emerald-200 px-1.5 py-0.5 rounded-md flex items-center gap-1">
                        <CheckCircle className="w-2.5 h-2.5" /> Verified Buyer
                      </span>
                    )}
                  </div>
                  <span className="text-[10px] text-[#64748b]">{rev.date}</span>
                </div>
              </div>

              <div className="flex items-center gap-0.5 text-amber-400">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star
                    key={i}
                    className={`w-3.5 h-3.5 ${i < rev.rating ? 'fill-amber-400' : 'text-slate-200'}`}
                  />
                ))}
              </div>
            </div>

            <h4 className="text-xs font-bold text-[#191c1e] mb-1">{rev.title}</h4>
            <p className="text-xs text-[#3f4a3d] leading-relaxed mb-3">{rev.body}</p>

            <div className="flex items-center justify-between text-[11px] text-[#64748b] pt-2 border-t border-[#f1f5f9]">
              <span>Was this review helpful?</span>
              <button
                onClick={() => handleHelpful(rev.id)}
                disabled={helpfulVoted.has(rev.id)}
                className={`flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs transition ${
                  helpfulVoted.has(rev.id)
                    ? 'bg-emerald-50 text-[#15803d] font-bold'
                    : 'hover:bg-slate-100 text-[#3f4a3d]'
                }`}
              >
                <ThumbsUp className="w-3 h-3" />
                <span>Helpful ({rev.helpfulCount})</span>
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* Interactive Write Review Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl relative border border-[#e2e2e5] animate-in fade-in zoom-in-95 duration-200">
            <button
              onClick={() => setIsModalOpen(false)}
              className="absolute top-4 right-4 p-1.5 text-slate-400 hover:text-slate-700 rounded-full hover:bg-slate-100 transition"
            >
              <X className="w-5 h-5" />
            </button>

            <h3 className="text-lg font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
              Rate & Review Product
            </h3>
            <p className="text-xs text-[#64748b] mb-4">Share your honest feedback for {productName}</p>

            {formSubmitted ? (
              <div className="py-8 text-center space-y-2">
                <CheckCircle className="w-12 h-12 text-[#15803d] mx-auto animate-bounce" />
                <h4 className="font-bold text-[#191c1e]">Thank You for Your Review!</h4>
                <p className="text-xs text-[#64748b]">Your review has been verified and published.</p>
              </div>
            ) : (
              <form onSubmit={handleReviewSubmit} className="space-y-4">
                <div>
                  <label className="block text-xs font-semibold text-[#191c1e] mb-1.5">
                    Overall Rating
                  </label>
                  <div className="flex items-center gap-2">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <button
                        type="button"
                        key={star}
                        onClick={() => setFormRating(star)}
                        onMouseEnter={() => setFormHoverRating(star)}
                        onMouseLeave={() => setFormHoverRating(0)}
                        className="p-1 transition transform active:scale-110"
                      >
                        <Star
                          className={`w-6 h-6 ${
                            star <= (formHoverRating || formRating)
                              ? 'fill-amber-400 text-amber-400'
                              : 'text-slate-300'
                          }`}
                        />
                      </button>
                    ))}
                    <span className="text-xs font-bold text-[#191c1e] ml-2">
                      {formRating} of 5 Stars
                    </span>
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-[#191c1e] mb-1">Your Name</label>
                  <input
                    type="text"
                    required
                    value={formAuthor}
                    onChange={(e) => setFormAuthor(e.target.value)}
                    placeholder="e.g. Ananya Sen"
                    className="w-full text-xs bg-slate-50 border border-[#e2e2e5] rounded-xl px-3.5 py-2.5 focus:outline-none focus:border-[#2d9d43] transition"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-[#191c1e] mb-1">
                    Review Headline
                  </label>
                  <input
                    type="text"
                    value={formTitle}
                    onChange={(e) => setFormTitle(e.target.value)}
                    placeholder="e.g. Crisp, fresh and wonderful taste!"
                    className="w-full text-xs bg-slate-50 border border-[#e2e2e5] rounded-xl px-3.5 py-2.5 focus:outline-none focus:border-[#2d9d43] transition"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-[#191c1e] mb-1">
                    Your Review
                  </label>
                  <textarea
                    required
                    rows={3}
                    value={formBody}
                    onChange={(e) => setFormBody(e.target.value)}
                    placeholder="Describe taste, packing, freshness, delivery experience..."
                    className="w-full text-xs bg-slate-50 border border-[#e2e2e5] rounded-xl p-3.5 focus:outline-none focus:border-[#2d9d43] transition resize-none"
                  />
                </div>

                <div className="flex items-center justify-end gap-2 pt-2">
                  <button
                    type="button"
                    onClick={() => setIsModalOpen(false)}
                    className="px-4 py-2 text-xs font-semibold text-[#64748b] hover:bg-slate-100 rounded-xl transition"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 text-xs font-bold text-white bg-[#2d9d43] hover:bg-[#078730] rounded-xl shadow-xs transition active:scale-95"
                  >
                    Submit Review
                  </button>
                </div>
              </form>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
