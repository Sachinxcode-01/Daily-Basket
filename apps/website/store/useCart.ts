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

export function computeCartSummary(items: CartItem[]): CartSummary {
  const itemTotal = items.reduce((sum, i) => sum + i.price * i.quantity, 0);
  const mrpTotal = Math.round(items.reduce((sum, i) => sum + (i.price * 1.15) * i.quantity, 0));
  const quantityTotal = items.reduce((sum, i) => sum + i.quantity, 0);
  const productDiscounts = Math.max(0, mrpTotal - itemTotal);
  const platformFee = itemTotal > 0 ? 3 : 0;
  const packagingCharges = itemTotal > 0 ? 5 : 0;
  const deliveryFee = itemTotal >= 199 || itemTotal === 0 ? 0 : 25;
  const taxGst = Math.round(itemTotal * 0.05);
  const grandTotal = itemTotal + platformFee + packagingCharges + deliveryFee + taxGst;
  const totalSavings = productDiscounts + (itemTotal >= 199 ? 25 : 0);

  return {
    itemTotal,
    mrpTotal,
    quantityTotal,
    productDiscounts,
    platformFee,
    packagingCharges,
    deliveryFee,
    taxGst,
    grandTotal,
    totalSavings,
  };
}

const LOCAL_CART_KEY = 'daily_basket_local_cart_v1';

function getLocalCart(userId: string): CartPayload {
  if (typeof window === 'undefined') {
    return { id: `cart_${userId}`, userId, activeItems: [], savedItems: [], summary: computeCartSummary([]) };
  }
  try {
    const raw = localStorage.getItem(LOCAL_CART_KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed.activeItems)) {
        return {
          id: parsed.id || `cart_${userId}`,
          userId,
          activeItems: parsed.activeItems,
          savedItems: parsed.savedItems || [],
          summary: computeCartSummary(parsed.activeItems),
        };
      }
    }
  } catch {}
  return { id: `cart_${userId}`, userId, activeItems: [], savedItems: [], summary: computeCartSummary([]) };
}

function saveLocalCart(cart: CartPayload) {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(LOCAL_CART_KEY, JSON.stringify(cart));
  } catch {}
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
    queryFn: async () => {
      try {
        const remote = await apiClient.getCart(userId);
        if (remote && Array.isArray(remote.activeItems)) {
          saveLocalCart(remote);
          return remote;
        }
      } catch {}
      return getLocalCart(userId);
    },
    initialData: () => getLocalCart(userId),
  });

  const writeCache = (data: CartPayload) => {
    saveLocalCart(data);
    qc.setQueryData(key, data);
  };

  const addItem = useMutation({
    mutationFn: async (item: AddToCartInput) => {
      try {
        const remote = await apiClient.addToCart(item, userId);
        if (remote && Array.isArray(remote.activeItems)) {
          return remote;
        }
      } catch {}

      // Fallback local mutation
      const current = getLocalCart(userId);
      const existingIdx = current.activeItems.findIndex((i) => i.variantId === item.variantId);
      const qtyToAdd = item.quantity || 1;
      let newItems = [...current.activeItems];

      if (existingIdx !== -1) {
        newItems[existingIdx] = {
          ...newItems[existingIdx],
          quantity: newItems[existingIdx].quantity + qtyToAdd,
        };
      } else {
        newItems.push({
          id: `item_${Date.now()}_${item.variantId}`,
          variantId: item.variantId,
          productName: item.productName,
          unitName: item.unitName,
          price: item.price,
          quantity: qtyToAdd,
        });
      }

      return {
        ...current,
        activeItems: newItems,
        summary: computeCartSummary(newItems),
      };
    },
    onSuccess: writeCache,
  });

  const updateItem = useMutation({
    mutationFn: async ({ itemId, quantity }: { itemId: string; quantity: number }) => {
      try {
        const remote = await apiClient.updateCartItem(itemId, quantity, userId);
        if (remote && Array.isArray(remote.activeItems)) {
          return remote;
        }
      } catch {}

      // Fallback local mutation
      const current = getLocalCart(userId);
      let newItems = current.activeItems
        .map((i) => (i.id === itemId || i.variantId === itemId ? { ...i, quantity } : i))
        .filter((i) => i.quantity > 0);

      return {
        ...current,
        activeItems: newItems,
        summary: computeCartSummary(newItems),
      };
    },
    onSuccess: writeCache,
  });

  const removeItem = useMutation({
    mutationFn: async (itemId: string) => {
      try {
        const remote = await apiClient.removeCartItem(itemId, userId);
        if (remote && Array.isArray(remote.activeItems)) {
          return remote;
        }
      } catch {}

      // Fallback local mutation
      const current = getLocalCart(userId);
      const newItems = current.activeItems.filter((i) => i.id !== itemId && i.variantId !== itemId);

      return {
        ...current,
        activeItems: newItems,
        summary: computeCartSummary(newItems),
      };
    },
    onSuccess: writeCache,
  });

  const clear = useMutation({
    mutationFn: async () => {
      try {
        await apiClient.clearCart(userId);
      } catch {}
      const empty: CartPayload = {
        id: `cart_${userId}`,
        userId,
        activeItems: [],
        savedItems: [],
        summary: computeCartSummary([]),
      };
      return empty;
    },
    onSuccess: writeCache,
  });

  const cart = query.data ?? getLocalCart(userId);
  const activeItems: CartItem[] = cart?.activeItems ?? [];
  const itemCount = activeItems.reduce((n, i) => n + i.quantity, 0);

  return {
    userId,
    cart,
    activeItems,
    summary: cart?.summary ?? computeCartSummary(activeItems),
    itemCount,
    isLoading: query.isLoading,
    isError: false,
    refetch: query.refetch,
    addItem,
    updateItem,
    removeItem,
    clear,
  };
}
