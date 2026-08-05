'use client';

import React, { useState } from 'react';

interface FavoriteButtonProps {
  productId: string;
  productName?: string;
  initialIsFavorite?: boolean;
  className?: string;
  size?: number;
}

export const FavoriteButton: React.FC<FavoriteButtonProps> = ({
  productId,
  productName = 'Product',
  initialIsFavorite = false,
  className = '',
  size = 20,
}) => {
  const [isFavorite, setIsFavorite] = useState(initialIsFavorite);

  const toggleFavorite = (e: React.MouseEvent) => {
    e.stopPropagation();
    e.preventDefault();
    const newStatus = !isFavorite;
    setIsFavorite(newStatus);

    // Call NestJS API asynchronously
    fetch(`http://localhost:3000/api/favorites/${productId}`, {
      method: newStatus ? 'POST' : 'DELETE',
    }).catch(() => {});
  };

  return (
    <button
      onClick={toggleFavorite}
      className={`p-2 rounded-full transition-all duration-200 hover:scale-110 focus:outline-none ${
        isFavorite ? 'bg-red-50 text-red-500' : 'bg-gray-100 text-gray-400 hover:text-red-400'
      } ${className}`}
      title={isFavorite ? 'Remove from favorites' : 'Add to favorites'}
      aria-label={isFavorite ? 'Remove from favorites' : 'Add to favorites'}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill={isFavorite ? 'currentColor' : 'none'}
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        style={{ width: size, height: size }}
      >
        <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z" />
      </svg>
    </button>
  );
};
