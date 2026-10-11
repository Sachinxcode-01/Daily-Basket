'use client';

import React from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-slate-900 text-slate-100 font-sans p-6 text-center">
      <h1 className="text-3xl font-extrabold text-[#078730] mb-2 font-outfit">
        500 - Server Error
      </h1>
      <p className="text-slate-400 text-sm mb-6 max-w-md font-inter">
        Something unexpected happened on our end. Please try refreshing the page.
      </p>
      <button
        onClick={() => reset()}
        className="px-6 py-3 bg-[#006823] hover:bg-[#00531a] text-white font-bold text-sm rounded-full transition cursor-pointer"
      >
        Try Again
      </button>
    </div>
  );
}
