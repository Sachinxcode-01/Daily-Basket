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
import { Logger } from '@nestjs/common';

@WebSocketGateway({
  cors: { origin: '*' },
  namespace: '/ws',
})
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(EventsGateway.name);

  handleConnection(client: Socket) {
    this.logger.log(`Client connected to WebSockets: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('join_room')
  handleJoinRoom(@ConnectedSocket() client: Socket, @MessageBody() room: string) {
    client.join(room);
    this.logger.log(`Client ${client.id} joined room: ${room}`);
    return { status: 'joined', room };
  }

  @SubscribeMessage('leave_room')
  handleLeaveRoom(@ConnectedSocket() client: Socket, @MessageBody() room: string) {
    client.leave(room);
    this.logger.log(`Client ${client.id} left room: ${room}`);
    return { status: 'left', room };
  }

  @SubscribeMessage('rider_gps_tick')
  handleRiderGpsTick(
    @MessageBody() payload: { orderId: string; riderId: string; lat: number; lng: number },
  ) {
    this.broadcastLiveLocation(payload.orderId, payload.riderId, payload.lat, payload.lng);
    return { status: 'acknowledged' };
  }

  @SubscribeMessage('chat_message')
  handleChatMessage(
    @MessageBody() payload: { ticketId: string; sender: string; message: string; timestamp: string },
  ) {
    this.broadcastSupportMessage(payload.ticketId, payload);
    return { status: 'sent' };
  }

  // --- Real-time Event Broadcasters ---

  broadcastOrderCreated(order: any) {
    this.server.to('admin').emit('order_created', order);
    if (order.storeId) {
      this.server.to(`store_${order.storeId}`).emit('order_created', order);
    }
    this.server.emit('dashboard_metrics_tick', { action: 'ORDER_CREATED', orderId: order.id });
  }

  broadcastOrderPacking(order: any) {
    this.server.to('admin').emit('order_packing', order);
    this.server.to(`order_${order.id}`).emit('order_packing', order);
    this.server.to(`customer_${order.userId}`).emit('order_status_update', {
      orderId: order.id,
      status: 'PACKING',
      message: 'Your items are being packed in the dark store!',
    });
  }

  broadcastRiderAssigned(orderId: string, userId: string, riderId: string, riderDetails: any) {
    this.server.to(`rider_${riderId}`).emit('new_order_assigned', { orderId, details: riderDetails });
    this.server.to(`customer_${userId}`).emit('rider_assigned', { orderId, rider: riderDetails });
    this.server.to(`order_${orderId}`).emit('order_status_update', { orderId, status: 'ASSIGNED', rider: riderDetails });
    this.server.to('admin').emit('order_assigned', { orderId, riderId });
  }

  broadcastLiveLocation(orderId: string, riderId: string, lat: number, lng: number) {
    const payload = { orderId, riderId, lat, lng, timestamp: new Date().toISOString() };
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
    this.server.to(`order_${orderId}`).emit('order_delivered', payload);
    this.server.to(`customer_${userId}`).emit('order_status_update', payload);
    this.server.to('admin').emit('order_delivered', payload);
  }

  broadcastInventoryUpdate(productId: string, newStock: number, isAvailable: boolean) {
    this.server.emit('stock_updated', { productId, newStock, isAvailable, timestamp: new Date().toISOString() });
  }

  broadcastProductStatus(productId: string, isAvailable: boolean) {
    this.server.emit('product_status_changed', { productId, isAvailable, timestamp: new Date().toISOString() });
  }

  broadcastCouponCreated(coupon: any) {
    this.server.emit('coupon_created', coupon);
  }

  broadcastSupportMessage(ticketId: string, messagePayload: any) {
    this.server.to(`ticket_${ticketId}`).emit('support_chat_message', messagePayload);
  }

  broadcastFavoriteUpdated(userId: string, productId: string, isFavorite: boolean) {
    const payload = { userId, productId, isFavorite, timestamp: new Date().toISOString() };
    this.server.to(`user_${userId}`).emit('favorite_updated', payload);
    this.server.emit('favorite_analytics_tick', payload);
  }

  broadcastDashboardTick(metrics: any) {
    this.server.to('admin').emit('dashboard_metrics_tick', metrics);
  }
}
