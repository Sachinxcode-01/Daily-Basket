'use client';

import React, { useEffect } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { getSocket } from '../lib/socket';
import { useCurrentUserId } from '../store/useCart';

/**
 * Keeps the storefront in sync with backend changes in real time.
 * When Admin/store updates products, stock, or coupons (or an order status
 * changes), the API broadcasts over Socket.IO and we invalidate the relevant
 * react-query caches so connected clients refresh without a manual reload.
 */
export function RealtimeProvider({ children }: { children: React.ReactNode }) {
  const qc = useQueryClient();
  const userId = useCurrentUserId();

  useEffect(() => {
    const socket = getSocket(userId);

    const invalidateCatalog = () => {
      qc.invalidateQueries({ queryKey: ['products'] });
      qc.invalidateQueries({ queryKey: ['product'] });
      qc.invalidateQueries({ queryKey: ['search'] });
      qc.invalidateQueries({ queryKey: ['categories'] });
    };
    const invalidateCoupons = () => qc.invalidateQueries({ queryKey: ['coupons'] });
    const invalidateOrders = () => {
      qc.invalidateQueries({ queryKey: ['order'] });
      qc.invalidateQueries({ queryKey: ['orders'] });
    };

    // Catalog / inventory (admin -> website)
    socket.on('product_updated', invalidateCatalog);
    socket.on('product.updated', invalidateCatalog);
    socket.on('product_created', invalidateCatalog);
    socket.on('product.created', invalidateCatalog);
    socket.on('product_deleted', invalidateCatalog);
    socket.on('product_status_changed', invalidateCatalog);
    socket.on('stock_updated', invalidateCatalog);
    socket.on('inventory.updated', invalidateCatalog);
    socket.on('catalog_reset', invalidateCatalog);
    socket.on('catalog_migrated', invalidateCatalog);

    // Coupons
    socket.on('coupon_created', invalidateCoupons);
    socket.on('coupon.created', invalidateCoupons);
    socket.on('coupon_updated', invalidateCoupons);
    socket.on('coupon.updated', invalidateCoupons);

    // Orders (customer room)
    socket.on('order_status_update', invalidateOrders);
    socket.on('cart_updated', () => qc.invalidateQueries({ queryKey: ['cart'] }));

    return () => {
      socket.off('product_updated', invalidateCatalog);
      socket.off('product.updated', invalidateCatalog);
      socket.off('product_created', invalidateCatalog);
      socket.off('product.created', invalidateCatalog);
      socket.off('product_deleted', invalidateCatalog);
      socket.off('product_status_changed', invalidateCatalog);
      socket.off('stock_updated', invalidateCatalog);
      socket.off('inventory.updated', invalidateCatalog);
      socket.off('catalog_reset', invalidateCatalog);
      socket.off('catalog_migrated', invalidateCatalog);
      socket.off('coupon_created', invalidateCoupons);
      socket.off('coupon.created', invalidateCoupons);
      socket.off('coupon_updated', invalidateCoupons);
      socket.off('coupon.updated', invalidateCoupons);
      socket.off('order_status_update', invalidateOrders);
    };
  }, [qc, userId]);

  return <>{children}</>;
}
