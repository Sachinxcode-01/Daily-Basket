'use client';

import React, { useState } from 'react';

interface Review {
  id: string;
  customerName: string;
  rating: number;
  comment: string;
  date: string;
  status: 'APPROVED' | 'PENDING' | 'FLAGGED';
  verified: boolean;
}

const mockReviews: Review[] = [
  {
    id: 'rev_1',
    customerName: 'Sarah Jenkins',
    rating: 5,
    comment: 'Super fast delivery! The avocados were perfectly ripe and fresh. Love the 10-minute speed.',
    date: '2026-08-09',
    status: 'APPROVED',
    verified: true,
  },
  {
    id: 'rev_2',
    customerName: 'Amit Patel',
    rating: 4,
    comment: 'Great quality milk and organic eggs. Packaging was crisp and undamaged.',
    date: '2026-08-08',
    status: 'APPROVED',
    verified: true,
  },
  {
    id: 'rev_3',
    customerName: 'Rahul Verma',
    rating: 2,
    comment: 'Delivery took 18 minutes instead of 10 minutes. Item quality was okay.',
    date: '2026-08-07',
    status: 'PENDING',
    verified: true,
  },
];

export default function AdminCustomerReviewsPage() {
  const [reviews, setReviews] = useState<Review[]>(mockReviews);

  const updateStatus = (id: string, status: 'APPROVED' | 'PENDING' | 'FLAGGED') => {
    setReviews((prev) =>
      prev.map((r) => (r.id === id ? { ...r, status } : r))
    );
  };

  return (
    <div className="p-6 max-w-7xl mx-auto flex flex-col gap-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="font-headline text-2xl font-bold text-on-surface">Customer Reviews & Moderation</h1>
          <p className="font-body text-sm text-on-surface-variant">
            Moderate ratings, publish verified buyer feedback, and analyze customer satisfaction.
          </p>
        </div>
        <div className="flex gap-4">
          <div className="bg-surface-container-lowest px-4 py-2 rounded-xl border border-surface-variant/40 text-center">
            <span className="font-headline text-2xl font-bold text-primary">4.8</span>
            <span className="block text-xs text-on-surface-variant">Avg Rating</span>
          </div>
          <div className="bg-surface-container-lowest px-4 py-2 rounded-xl border border-surface-variant/40 text-center">
            <span className="font-headline text-2xl font-bold text-on-surface">2,451</span>
            <span className="block text-xs text-on-surface-variant">Total Reviews</span>
          </div>
        </div>
      </div>

      <div className="flex flex-col gap-4">
        {reviews.map((rev) => (
          <div
            key={rev.id}
            className="bg-surface-container-lowest p-5 rounded-2xl border border-surface-variant/40 shadow-sm flex flex-col md:flex-row justify-between gap-4"
          >
            <div className="flex flex-col gap-2 flex-grow">
              <div className="flex items-center gap-3">
                <h2 className="font-headline text-lg font-semibold text-on-surface">{rev.customerName}</h2>
                {rev.verified && (
                  <span className="bg-primary/10 text-primary font-label text-[10px] uppercase font-bold px-2 py-0.5 rounded-full">
                    Verified Buyer
                  </span>
                )}
                <span className="text-xs text-on-surface-variant ml-auto">{rev.date}</span>
              </div>
              <div className="flex text-amber-500">
                {Array.from({ length: 5 }).map((_, i) => (
                  <span key={i} className="material-symbols-outlined text-[18px]">
                    {i < rev.rating ? 'star' : 'star_outline'}
                  </span>
                ))}
              </div>
              <p className="font-body text-sm text-on-surface">{rev.comment}</p>
            </div>

            <div className="flex items-center gap-2 flex-shrink-0">
              <span
                className={`font-label text-xs font-semibold px-3 py-1 rounded-full ${
                  rev.status === 'APPROVED'
                    ? 'bg-primary-container/20 text-primary'
                    : rev.status === 'FLAGGED'
                    ? 'bg-error-container text-error'
                    : 'bg-surface-variant text-on-surface-variant'
                }`}
              >
                {rev.status}
              </span>
              <button
                onClick={() => updateStatus(rev.id, 'APPROVED')}
                className="px-3 py-1.5 bg-primary text-on-primary font-label text-xs rounded-lg hover:bg-primary-container transition-colors"
              >
                Approve
              </button>
              <button
                onClick={() => updateStatus(rev.id, 'FLAGGED')}
                className="px-3 py-1.5 bg-error-container text-error font-label text-xs rounded-lg hover:opacity-80 transition-opacity"
              >
                Flag
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
