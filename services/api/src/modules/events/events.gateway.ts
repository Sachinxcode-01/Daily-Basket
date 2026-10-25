import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger, Optional } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

export interface AuthenticatedUser {
  id: string;
  role?: string;
  email?: string;
}

@WebSocketGateway({
  cors: {
    origin: (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) => {
      // Allow non-browser requests or local development origins
      if (!origin || process.env.NODE_ENV !== 'production') {
        return callback(null, true);
      }
      const allowedOrigins = [
        process.env.FRONTEND_URL,
        process.env.ADMIN_URL,
        process.env.WEBSITE_URL,
        process.env.DELIVERY_URL,
      ].filter(Boolean);
      if (allowedOrigins.length === 0 || allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      return callback(null, true);
    },
    credentials: true,
  },
  namespace: '/ws',
  transports: ['websocket', 'polling'],
  pingInterval: 25000,
  pingTimeout: 10000,
})
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(EventsGateway.name);

  // In-memory presence tracking store
  private readonly activeSockets = new Map<string, { userId?: string; role?: string; connectedAt: number }>();
  // Recent event deduplication cache (eventHash -> timestamp)
  private readonly eventDeduplicationMap = new Map<string, number>();

  constructor(@Optional() private readonly jwtService?: JwtService) {}

  handleConnection(client: Socket) {
    const authUser = this.authenticateClient(client);

    this.activeSockets.set(client.id, {
      userId: authUser?.id,
      role: authUser?.role,
      connectedAt: Date.now(),
    });

    if (authUser) {
      client.data = client.data || {};
      client.data.user = authUser;
      client.join(`user_${authUser.id}`);
      client.join(`customer_${authUser.id}`);

      // Auto-join privileged administrative rooms
      if (['ADMIN', 'SUPER_ADMIN', 'STORE_MANAGER'].includes(authUser.role || '')) {
        client.join('admin');
      }

      // Auto-join rider room for delivery partners
      if (authUser.role === 'DELIVERY_PARTNER') {
        client.join(`rider_${authUser.id}`);
      }

      this.logger.log(
        `⚡ Authenticated client connected to WebSockets: ${client.id} (User: ${authUser.id}, Role: ${authUser.role || 'CUSTOMER'})`,
      );
    } else {
      client.data = client.data || {};
      client.data.user = null;
      this.logger.log(`⚡ Anonymous client connected to WebSockets: ${client.id}`);
    }
  }

  private authenticateClient(client: Socket): AuthenticatedUser | null {
    const rawToken =
      client.handshake.auth?.token ||
      (client.handshake.headers?.authorization?.startsWith('Bearer ')
        ? client.handshake.headers.authorization.slice(7)
        : undefined) ||
      (client.handshake.query?.token as string) ||
      undefined;

    if (rawToken && this.jwtService) {
      try {
        const payload = this.jwtService.verify(rawToken);
        const userId = payload.sub || payload.userId || payload.id;
        if (userId) {
          return {
            id: userId,
            role: payload.role || 'CUSTOMER',
            email: payload.email,
          };
        }
      } catch (err: any) {
        this.logger.warn(`Failed to verify socket token on ${client.id}: ${err.message}`);
      }
    }

    // In non-production testing, allow query.userId fallback if explicit token was not passed
    if (process.env.NODE_ENV !== 'production' && !rawToken) {
      const queryUserId = (client.handshake.query?.userId as string) || undefined;
      if (queryUserId) {
        return {
          id: queryUserId,
          role: (client.handshake.query?.role as string) || 'CUSTOMER',
        };
      }
    }

    return null;
  }

  handleDisconnect(client: Socket) {
    this.activeSockets.delete(client.id);
    this.logger.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('join_room')
  handleJoinRoom(@ConnectedSocket() client: Socket, @MessageBody() room: string) {
    if (!room || typeof room !== 'string') {
      return { status: 'error', message: 'Invalid room name' };
    }

    const user: AuthenticatedUser | undefined = client.data?.user;
    const isAuthorized = this.authorizeRoomAccess(user, room);

    if (!isAuthorized) {
      this.logger.warn(
        `Unauthorized room join attempt: Socket ${client.id} (User: ${user?.id || 'anonymous'}) -> ${room}`,
      );
      return { status: 'error', code: 'UNAUTHORIZED', message: `Access denied to room ${room}` };
    }

    client.join(room);
    this.logger.debug(`Client ${client.id} joined room: ${room}`);
    return { status: 'joined', room };
  }

  @SubscribeMessage('leave_room')
  handleLeaveRoom(@ConnectedSocket() client: Socket, @MessageBody() room: string) {
    client.leave(room);
    this.logger.debug(`Client ${client.id} left room: ${room}`);
    return { status: 'left', room };
  }

  private authorizeRoomAccess(user: AuthenticatedUser | undefined, room: string): boolean {
    // 1. Public catalog/inventory update rooms open to all
    const publicRooms = ['public', 'catalog', 'inventory', 'store_updates', 'deals'];
    if (publicRooms.includes(room) || (room.startsWith('store_') && room.endsWith('_public'))) {
      return true;
    }

    // All protected rooms require authentication
    if (!user) {
      return false;
    }

    const isAdmin = ['ADMIN', 'SUPER_ADMIN', 'STORE_MANAGER'].includes(user.role || '');

    // 2. Admin rooms
    if (room === 'admin' || room.startsWith('admin_')) {
      return isAdmin;
    }

    // 3. Customer personal rooms (user_${id}, customer_${id})
    if (room.startsWith('user_') || room.startsWith('customer_')) {
      const targetUserId = room.replace(/^(user_|customer_)/, '');
      return user.id === targetUserId || isAdmin;
    }

    // 4. Rider rooms (rider_${id}, fleet)
    if (room.startsWith('rider_')) {
      const targetRiderId = room.replace(/^rider_/, '');
      return user.id === targetRiderId || isAdmin;
    }
    if (room === 'fleet' || room.startsWith('fleet_')) {
      return user.role === 'DELIVERY_PARTNER' || isAdmin;
    }

    // 5. Order rooms (order_${id}) & ticket rooms (ticket_${id})
    if (room.startsWith('order_') || room.startsWith('ticket_')) {
      return true;
    }

    return true;
  }

  @SubscribeMessage('typing_indicator')
  handleTypingIndicator(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { ticketId: string; isTyping: boolean },
  ) {
    client.to(`ticket_${payload.ticketId}`).emit('user_typing', {
      clientId: client.id,
      isTyping: payload.isTyping,
    });
    return { status: 'ok' };
  }

  @SubscribeMessage('rider_gps_tick')
  handleRiderGpsTick(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { orderId: string; riderId: string; lat: number; lng: number },
  ) {
    const user: AuthenticatedUser | undefined = client.data?.user;
    if (user && user.role !== 'DELIVERY_PARTNER' && !['ADMIN', 'SUPER_ADMIN'].includes(user.role || '')) {
      this.logger.warn(`Non-rider socket ${client.id} attempted to emit rider_gps_tick`);
      return { status: 'rejected', error: 'Forbidden' };
    }
    this.broadcastLiveLocation(payload.orderId, payload.riderId, payload.lat, payload.lng);
    return { status: 'acknowledged' };
  }

  @SubscribeMessage('update_delivery_status')
  handleUpdateDeliveryStatus(
    @MessageBody() payload: { orderId: string; status: string; riderId?: string; lat?: number; lng?: number },
  ) {
    this.server.to(`order_${payload.orderId}`).emit('order_status_update', payload);
    if (payload.status === 'DELIVERED') {
      this.server.to(`order_${payload.orderId}`).emit('order_delivered', {
        orderId: payload.orderId,
        status: 'DELIVERED',
        deliveredAt: new Date().toISOString(),
      });
    }
    return { status: 'acknowledged' };
  }

  @SubscribeMessage('chat_message')
  handleChatMessage(
    @MessageBody() payload: { ticketId: string; sender: string; message: string; timestamp: string },
  ) {
    this.broadcastSupportMessage(payload.ticketId, payload);
    return { status: 'sent' };
  }

  // --- Real-Time Deduplicated Event Broadcasters (<100ms latency) ---

  private isDuplicateEvent(eventKey: string, ttlMs = 500): boolean {
    const now = Date.now();
    const lastEmitted = this.eventDeduplicationMap.get(eventKey);
    if (lastEmitted && now - lastEmitted < ttlMs) {
      return true;
    }
    this.eventDeduplicationMap.set(eventKey, now);

    // Evict old hash entries periodically
    if (this.eventDeduplicationMap.size > 2000) {
      for (const [key, ts] of this.eventDeduplicationMap.entries()) {
        if (now - ts > ttlMs * 2) this.eventDeduplicationMap.delete(key);
      }
    }
    return false;
  }

  broadcastProductCreated(product: any) {
    this.server.emit('product.created', product);
    this.server.emit('product_created', product);
  }

  broadcastProductUpdated(product: any) {
    this.server.emit('product.updated', product);
    this.server.emit('product_updated', product);
  }

  broadcastProductDeleted(productId: string) {
    this.server.emit('product.deleted', { productId });
    this.server.emit('product_deleted', { productId });
  }

  broadcastOrderCreated(order: any) {
    if (this.isDuplicateEvent(`order_created_${order.id}`)) return;

    this.server.emit('order.created', order);
    this.server.to('admin').emit('order_created', order);
    if (order.storeId) {
      this.server.to(`store_${order.storeId}`).emit('order_created', order);
    }
    this.server.emit('dashboard_metrics_tick', { action: 'ORDER_CREATED', orderId: order.id });
  }

  broadcastOrderUpdated(order: any) {
    this.server.emit('order.updated', order);
    this.server.to('admin').emit('order_updated', order);
    this.server.to(`order_${order.id}`).emit('order_updated', order);
    this.server.to(`customer_${order.userId}`).emit('order_status_update', order);
  }

  broadcastOrderPacking(order: any) {
    this.server.emit('order.updated', { ...order, status: 'PACKING' });
    this.server.to('admin').emit('order_packing', order);
    this.server.to(`order_${order.id}`).emit('order_packing', order);
    this.server.to(`customer_${order.userId}`).emit('order_status_update', {
      orderId: order.id,
      status: 'PACKING',
      message: 'Your items are being packed in the dark store!',
    });
  }

  broadcastRiderAssigned(orderId: string, userId: string, riderId: string, riderDetails: any) {
    const payload = { orderId, riderId, rider: riderDetails };
    this.server.emit('delivery.assigned', payload);
    this.server.to(`rider_${riderId}`).emit('new_order_assigned', { orderId, details: riderDetails });
    this.server.to(`customer_${userId}`).emit('rider_assigned', { orderId, rider: riderDetails });
    this.server.to(`order_${orderId}`).emit('order_status_update', { orderId, status: 'ASSIGNED', rider: riderDetails });
    this.server.to('admin').emit('order_assigned', { orderId, riderId });
  }

  broadcastLiveLocation(orderId: string, riderId: string, lat: number, lng: number) {
    // Deduplicate rapid GPS jitter updates within 200ms
    if (this.isDuplicateEvent(`gps_${orderId}_${riderId}`, 200)) return;

    const payload = { orderId, riderId, lat, lng, timestamp: new Date().toISOString() };
    this.server.emit('delivery.location', payload);
    this.server.to(`order_${orderId}`).emit('rider_location_update', payload);
    this.server.to('admin').emit('fleet_location_tick', payload);
  }

  broadcastOrderDelivered(orderId: string, userId: string, invoice: any) {
    const payload = {
      orderId,
      status: 'DELIVERED',
      deliveredAt: new Date().toISOString(),
      invoice,
    };
    this.server.emit('order.updated', payload);
    this.server.to(`order_${orderId}`).emit('order_delivered', payload);
    this.server.to(`customer_${userId}`).emit('order_status_update', payload);
    this.server.to('admin').emit('order_delivered', payload);
  }

  broadcastOrderCancelled(orderId: string, userId: string, reason = 'Order cancelled') {
    const payload = {
      orderId,
      status: 'CANCELLED',
      reason,
      cancelledAt: new Date().toISOString(),
    };
    this.server.emit('order.updated', payload);
    this.server.to(`order_${orderId}`).emit('order_cancelled', payload);
    this.server.to(`customer_${userId}`).emit('order_status_update', payload);
    this.server.to('admin').emit('order_cancelled', payload);
  }

  broadcastItemMissing(orderId: string, userId: string, orderItem: any, substitutes: any[]) {
    const payload = {
      orderId,
      missingItem: orderItem,
      substitutes,
      timestamp: new Date().toISOString(),
    };
    this.server.to(`order_${orderId}`).emit('item_missing_substitution_offered', payload);
    this.server.to(`customer_${userId}`).emit('item_missing_substitution_offered', payload);
    this.server.to('admin').emit('item_missing_alert', payload);
  }

  broadcastSubstituteAccepted(orderId: string, userId: string, orderItem: any, delta: number) {
    const payload = {
      orderId,
      updatedItem: orderItem,
      priceDelta: delta,
      timestamp: new Date().toISOString(),
    };
    this.server.to(`order_${orderId}`).emit('substitute_accepted', payload);
    this.server.to(`customer_${userId}`).emit('substitute_accepted', payload);
    this.server.to('admin').emit('substitute_accepted', payload);
  }

  broadcastItemRemovedAndRefunded(orderId: string, userId: string, itemId: string, refundAmount: number) {
    const payload = {
      orderId,
      removedItemId: itemId,
      refundAmount,
      timestamp: new Date().toISOString(),
    };
    this.server.to(`order_${orderId}`).emit('item_removed_refund_issued', payload);
    this.server.to(`customer_${userId}`).emit('item_removed_refund_issued', payload);
    this.server.to('admin').emit('item_removed_refund_issued', payload);
  }

  broadcastInventoryUpdate(productId: string, newStock: number, isAvailable: boolean) {
    const payload = { productId, newStock, isAvailable, timestamp: new Date().toISOString() };
    this.server.emit('inventory.updated', payload);
    this.server.emit('stock_updated', payload);
  }

  broadcastProductStatus(productId: string, isAvailable: boolean) {
    this.server.emit('product.updated', { productId, isAvailable });
    this.server.emit('product_status_changed', { productId, isAvailable, timestamp: new Date().toISOString() });
  }

  broadcastCouponCreated(coupon: any) {
    this.server.emit('coupon.created', coupon);
    this.server.emit('coupon_created', coupon);
  }

  broadcastCouponUpdated(coupon: any) {
    this.server.emit('coupon.updated', coupon);
    this.server.emit('coupon_updated', coupon);
  }

  broadcastWalletUpdated(userId: string, balance: number, transaction: any) {
    const payload = { userId, balance, transaction, timestamp: new Date().toISOString() };
    this.server.emit('wallet.updated', payload);
    this.server.to(`customer_${userId}`).emit('wallet_updated', payload);
  }

  broadcastNotificationSent(userId: string, notification: any) {
    const payload = { userId, notification, timestamp: new Date().toISOString() };
    this.server.emit('notification.sent', payload);
    this.server.to(`customer_${userId}`).emit('notification_received', payload);
  }

  broadcastSupportCreated(ticket: any) {
    this.server.emit('support.created', ticket);
    this.server.to('admin').emit('support_ticket_created', ticket);
  }

  broadcastSupportMessage(ticketId: string, messagePayload: any) {
    this.server.to(`ticket_${ticketId}`).emit('support_chat_message', messagePayload);
  }

  broadcastFavoriteUpdated(userId: string, productId: string, isFavorite: boolean) {
    const payload = { userId, productId, isFavorite, timestamp: new Date().toISOString() };
    this.server.to(`user_${userId}`).emit('favorite_updated', payload);
    this.server.emit('favorite_analytics_tick', payload);
  }

  broadcastAnalyticsUpdated(metrics: any) {
    this.server.emit('analytics.updated', metrics);
    this.server.to('admin').emit('dashboard_metrics_tick', metrics);
  }

  broadcastDashboardTick(metrics: any) {
    this.server.emit('analytics.updated', metrics);
    this.server.to('admin').emit('dashboard_metrics_tick', metrics);
  }

  public getActiveConnectionCount(): number {
    return this.activeSockets.size;
  }
}
