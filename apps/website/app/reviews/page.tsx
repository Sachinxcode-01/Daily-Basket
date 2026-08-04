import React from 'react';
import Link from 'next/link';
import { Star, CheckCircle, ThumbsUp, Filter, MessageSquarePlus, ShoppingBag, Search } from 'lucide-react';

export const metadata = {
  title: 'Customer Reviews & Testimonials | Daily Basket',
  description: 'Read real verified customer reviews and ratings for Daily Basket quick-commerce grocery delivery.',
};

export default function CustomerReviewsPage() {
  const reviews = [
    {
      id: 'r1',
      author: 'Priya Sharma',
      avatar: 'PS',
      verified: true,
      rating: 5,
      date: '2 hours ago',
      itemPurchased: 'Organic Hass Avocados & Fresh Milk',
      text: 'Delivered in literally 8 minutes! Avocados were at perfect ripeness. Daily Basket has completely replaced my weekly supermarket trips.',
      likes: 24,
    },
    {
      id: 'r2',
      author: 'Rohan Mehta',
      avatar: 'RM',
      verified: true,
      rating: 5,
      date: 'Yesterday',
      itemPurchased: 'Farm Fresh Tomatoes & Coriander',
      text: 'The 100% freshness guarantee is real. One item had a slight bruise and customer support refunded it within 1 minute without any questions asked.',
      likes: 18,
    },
    {
      id: 'r3',
      author: 'Ananya Verma',
      avatar: 'AV',
      verified: true,
      rating: 5,
      date: '3 days ago',
      itemPurchased: 'A2 Cow Milk & Whole Wheat Bread',
      text: 'Super convenient morning delivery before 7 AM. Everything arrives chilled in insulated bags. Couldn’t ask for better service.',
      likes: 42,
    },
    {
      id: 'r4',
      author: 'Vikram Singh',
      avatar: 'VS',
      verified: true,
      rating: 4,
      date: '4 days ago',
      itemPurchased: 'Exotic Fruit Basket & Dragon Fruit',
      text: 'Great quality and lightning fast delivery. Only giving 4 stars because one rare item was out of stock, but refund was immediate.',
      likes: 9,
    },
  ];

  return (
    <div className="min-h-screen bg-[#f9f9fc] text-[#1a1c1e] font-sans pt-20 pb-16">
      {/* Header Bar */}
      <header className="fixed top-0 inset-x-0 z-50 bg-[#f9f9fc]/80 backdrop-blur-xl border-b border-[#e2e2e5]">
        <div className="max-w-7xl mx-auto px-4 md:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center gap-6">
            <Link href="/" className="flex items-center gap-2 text-[#006b23] font-bold text-xl tracking-tight">
              <span className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center font-black text-sm">DB</span>
              Daily Basket
            </Link>
            <div className="hidden md:flex items-center relative w-64">
              <Search className="w-4 h-4 text-[#3f4a3d] absolute left-3" />
              <input
                type="text"
                placeholder="Search reviews..."
                className="w-full pl-9 pr-4 py-1.5 bg-[#dce5dd]/50 border-none rounded-full text-sm focus:ring-2 focus:ring-[#006b23] focus:bg-white transition"
              />
            </div>
          </div>
          <nav className="hidden md:flex items-center gap-6 font-medium text-sm text-[#3f4a3d]">
            <Link href="/" className="hover:text-[#006b23] transition">Home</Link>
            <Link href="/categories" className="hover:text-[#006b23] transition">Categories</Link>
            <Link href="/about" className="hover:text-[#006b23] transition">About</Link>
            <Link href="/careers" className="hover:text-[#006b23] transition">Careers</Link>
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
        {/* Rating Hero Section */}
        <div className="bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-[#e2e2e5] mb-10">
          <div className="grid grid-cols-1 md:grid-cols-12 gap-8 items-center">
            {/* Score Breakdown */}
            <div className="md:col-span-5 text-center md:text-left space-y-3">
              <span className="px-3 py-1 bg-[#dce5dd] text-[#006b23] text-xs font-bold rounded-full uppercase tracking-wider">
                Community Trust Score
              </span>
              <div className="flex items-baseline justify-center md:justify-start gap-3">
                <span className="text-5xl md:text-6xl font-black text-[#1a1c1e]">4.9</span>
                <span className="text-lg text-[#3f4a3d] font-bold">/ 5.0</span>
              </div>
              <div className="flex justify-center md:justify-start gap-1 text-amber-400">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-6 h-6 fill-amber-400" />
                ))}
              </div>
              <p className="text-sm text-[#3f4a3d]">Based on 148,290+ verified delivered orders</p>
            </div>

            {/* Rating Bars */}
            <div className="md:col-span-7 space-y-2 border-t md:border-t-0 md:border-l border-[#e2e2e5] pt-6 md:pt-0 md:pl-8">
              {[
                { stars: '5 Stars', pct: '92%' },
                { stars: '4 Stars', pct: '6%' },
                { stars: '3 Stars', pct: '1%' },
                { stars: '2 Stars', pct: '<1%' },
                { stars: '1 Star', pct: '<1%' },
              ].map((bar, i) => (
                <div key={i} className="flex items-center gap-4 text-xs font-medium text-[#3f4a3d]">
                  <span className="w-14 shrink-0 text-right">{bar.stars}</span>
                  <div className="flex-1 h-2.5 bg-[#f3f3f6] rounded-full overflow-hidden">
                    <div
                      className="h-full bg-[#006b23] rounded-full"
                      style={{ width: bar.pct }}
                    />
                  </div>
                  <span className="w-10 shrink-0 font-bold text-[#1a1c1e]">{bar.pct}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Filter Chips */}
        <div className="flex items-center gap-3 overflow-x-auto pb-4 mb-6">
          <button className="px-4 py-2 bg-[#006b23] text-white text-xs font-bold rounded-full shrink-0 shadow-sm">
            All Reviews (148k)
          </button>
          <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] hover:bg-[#becab9] text-xs font-bold rounded-full shrink-0 transition">
            5 Stars Only
          </button>
          <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] hover:bg-[#becab9] text-xs font-bold rounded-full shrink-0 transition">
            Verified Buyers
          </button>
          <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] hover:bg-[#becab9] text-xs font-bold rounded-full shrink-0 transition">
            Delivery Speed
          </button>
          <button className="px-4 py-2 bg-[#dce5dd] text-[#1a1c1e] hover:bg-[#becab9] text-xs font-bold rounded-full shrink-0 transition">
            Produce Freshness
          </button>
        </div>

        {/* Reviews Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
          {reviews.map((rev) => (
            <div
              key={rev.id}
              className="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-[#e2e2e5] flex flex-col justify-between space-y-4"
            >
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-[#006b23] text-white flex items-center justify-center font-bold text-sm">
                      {rev.avatar}
                    </div>
                    <div>
                      <h4 className="text-sm font-bold text-[#1a1c1e] flex items-center gap-1.5">
                        {rev.author}
                        {rev.verified && (
                          <CheckCircle className="w-4 h-4 text-emerald-600 fill-emerald-100" />
                        )}
                      </h4>
                      <p className="text-xs text-[#3f4a3d]">{rev.date}</p>
                    </div>
                  </div>
                  <div className="flex gap-0.5 text-amber-400">
                    {[...Array(rev.rating)].map((_, i) => (
                      <Star key={i} className="w-4 h-4 fill-amber-400" />
                    ))}
                  </div>
                </div>

                <div className="inline-block px-3 py-1 bg-[#f3f3f6] rounded-lg text-xs font-medium text-[#3f4a3d]">
                  Item: <span className="font-semibold text-[#1a1c1e]">{rev.itemPurchased}</span>
                </div>

                <p className="text-sm text-[#1a1c1e] leading-relaxed">{rev.text}</p>
              </div>

              <div className="flex items-center justify-between pt-4 border-t border-[#e2e2e5] text-xs text-[#3f4a3d]">
                <button className="flex items-center gap-1.5 hover:text-[#006b23] transition">
                  <ThumbsUp className="w-3.5 h-3.5" />
                  <span>Helpful ({rev.likes})</span>
                </button>
                <span className="text-[#006b23] font-semibold">Verified Purchase</span>
              </div>
            </div>
          ))}
        </div>

        {/* Submit Review Banner */}
        <div className="bg-gradient-to-r from-[#006b23] to-[#078730] text-white rounded-3xl p-8 text-center space-y-4 shadow-md">
          <h3 className="text-2xl font-bold">Have you ordered from Daily Basket?</h3>
          <p className="text-sm text-emerald-100 max-w-xl mx-auto">
            Share your experience to help us continuously improve our 10-minute quick commerce service.
          </p>
          <button className="inline-flex items-center gap-2 px-6 py-3 bg-white text-[#006b23] rounded-xl font-bold text-sm hover:bg-emerald-50 transition active:scale-95">
            <MessageSquarePlus className="w-4 h-4" />
            <span>Submit Your Feedback</span>
          </button>
        </div>
      </main>
    </div>
  );
}
