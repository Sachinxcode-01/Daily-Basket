'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { apiClient } from '@daily-basket/api-client';
import { useAuthStore } from './useAuthStore';

export interface CartItem {
  id: string;
  variantId: string;
  productName: string;
  unitName: string;
  price: number;
  quantity: number;
  isSavedForLater?: boolean;
}

export interface CartSummary {
  itemTotal: number;
  mrpTotal: number;
  quantityTotal: number;
  productDiscounts: number;
  platformFee: number;
  packagingCharges: number;
  deliveryFee: number;
  taxGst: number;
  grandTotal: number;
  totalSavings: number;
}

export interface CartPayload {
  id: string;
  userId: string;
  activeItems: CartItem[];
  savedItems: CartItem[];
  summary: CartSummary;
}

export interface AddToCartInput {
  variantId: string;
  productName: string;
  unitName: string;
  price: number;
  quantity?: number;
}

/** Current user id for cart ownership — falls back to the shared guest cart. */
export function useCurrentUserId(): string {
  const user = useAuthStore((s) => s.user) as any;
  return user?.id || 'usr_default';
}

export function useCart() {
  const userId = useCurrentUserId();
  const qc = useQueryClient();
  const key = ['cart', userId];

  const query = useQuery<CartPayload>({
    queryKey: key,
    queryFn: () => apiClient.getCart(userId),
  });

  const writeCache = (data: CartPayload) => qc.setQueryData(key, data);

  const addItem = useMutation({
    mutationFn: (item: AddToCartInput) => apiClient.addToCart(item, userId),
    onSuccess: writeCache,
  });

  const updateItem = useMutation({
    mutationFn: ({ itemId, quantity }: { itemId: string; quantity: number }) =>
      apiClient.updateCartItem(itemId, quantity, userId),
    onSuccess: writeCache,
  });

  const removeItem = useMutation({
    mutationFn: (itemId: string) => apiClient.removeCartItem(itemId, userId),
    onSuccess: writeCache,
  });

  const clear = useMutation({
    mutationFn: () => apiClient.clearCart(userId),
    onSuccess: writeCache,
  });

  const cart = query.data;
  const activeItems: CartItem[] = cart?.activeItems ?? [];
  const itemCount = activeItems.reduce((n, i) => n + i.quantity, 0);

  return {
    userId,
    cart,
    activeItems,
    summary: cart?.summary ?? null,
    itemCount,
    isLoading: query.isLoading,
    isError: query.isError,
    refetch: query.refetch,
    addItem,
    updateItem,
    removeItem,
    clear,
  };
}
