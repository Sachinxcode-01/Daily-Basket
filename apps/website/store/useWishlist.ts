'use client';

import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { apiClient } from '@daily-basket/api-client';
import { ALL_WEBSITE_PRODUCTS, getProductById, WebsiteProduct } from '../lib/catalog';

interface WishlistStore {
  productIds: string[];
  isLoading: boolean;
  isWishlisted: (productId: string) => boolean;
  addToWishlist: (productId: string, userId?: string) => Promise<void>;
  removeFromWishlist: (productId: string, userId?: string) => Promise<void>;
  toggleWishlist: (productId: string, userId?: string) => Promise<boolean>;
  clearWishlist: (userId?: string) => Promise<void>;
  syncWithBackend: (userId: string) => Promise<void>;
  getProducts: () => WebsiteProduct[];
}

export const useWishlist = create<WishlistStore>()(
  persist(
    (set, get) => ({
      productIds: ['prod_veg_001', 'prod_milk_001', 'prod_bread_001', 'prod_flakes_001'],
      isLoading: false,

      isWishlisted: (productId: string) => {
        if (!productId) return false;
        const clean = productId.toLowerCase();
        return get().productIds.some((id) => id.toLowerCase() === clean);
      },

      addToWishlist: async (productId: string, userId?: string) => {
        if (!productId) return;
        const current = get().productIds;
        const clean = productId.toLowerCase();
        if (current.some((id) => id.toLowerCase() === clean)) return;

        const next = [productId, ...current];
        set({ productIds: next });

        if (userId) {
          try {
            await apiClient.addFavorite(productId, userId);
          } catch {
            // Local state preserved
          }
        }
      },

      removeFromWishlist: async (productId: string, userId?: string) => {
        if (!productId) return;
        const clean = productId.toLowerCase();
        const next = get().productIds.filter((id) => id.toLowerCase() !== clean);
        set({ productIds: next });

        if (userId) {
          try {
            await apiClient.removeFavorite(productId, userId);
          } catch {
            // Local state preserved
          }
        }
      },

      toggleWishlist: async (productId: string, userId?: string) => {
        const isFav = get().isWishlisted(productId);
        if (isFav) {
          await get().removeFromWishlist(productId, userId);
          return false;
        } else {
          await get().addToWishlist(productId, userId);
          return true;
        }
      },

      clearWishlist: async (userId?: string) => {
        set({ productIds: [] });
        if (userId) {
          try {
            // Backend clear
          } catch {
            // Local state cleared
          }
        }
      },

      syncWithBackend: async (userId: string) => {
        if (!userId) return;
        set({ isLoading: true });
        try {
          const currentIds = get().productIds;
          if (currentIds.length > 0) {
            await apiClient.syncWishlist(currentIds, userId);
          }
          const serverFavorites = await apiClient.getFavorites(userId);
          if (Array.isArray(serverFavorites)) {
            const serverIds = serverFavorites.map((f: any) => f.productId || f.id).filter(Boolean);
            const merged = Array.from(new Set([...currentIds, ...serverIds]));
            set({ productIds: merged });
          }
        } catch {
          // Keep local
        } finally {
          set({ isLoading: false });
        }
      },

      getProducts: () => {
        const ids = get().productIds;
        return ids
          .map((id) => getProductById(id))
          .filter((p): p is WebsiteProduct => Boolean(p));
      },
    }),
    {
      name: 'daily_basket_wishlist_storage',
    },
  ),
);
