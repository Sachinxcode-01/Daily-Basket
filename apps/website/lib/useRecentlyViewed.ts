'use client';

import { useState, useEffect, useCallback } from 'react';

const STORAGE_KEY = 'daily_basket_recently_viewed';
const MAX_RECENT = 12;

export function useRecentlyViewed() {
  const [viewedIds, setViewedIds] = useState<string[]>([]);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) {
        const parsed = JSON.parse(stored);
        if (Array.isArray(parsed)) {
          setViewedIds(parsed);
        }
      }
    } catch {
      // Ignore localStorage errors
    } finally {
      setIsLoaded(true);
    }
  }, []);

  const addViewedProduct = useCallback((id: string) => {
    if (!id) return;
    setViewedIds((prev) => {
      const filtered = prev.filter((item) => item !== id);
      const updated = [id, ...filtered].slice(0, MAX_RECENT);
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
      } catch {
        // Ignore
      }
      return updated;
    });
  }, []);

  const clearRecentlyViewed = useCallback(() => {
    setViewedIds([]);
    try {
      localStorage.removeItem(STORAGE_KEY);
    } catch {
      // Ignore
    }
  }, []);

  return {
    viewedIds,
    isLoaded,
    addViewedProduct,
    clearRecentlyViewed,
  };
}
