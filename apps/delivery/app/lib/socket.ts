'use client';

import { io, Socket } from 'socket.io-client';

let socket: Socket | null = null;

function apiBase(): string {
  const env =
    typeof process !== 'undefined' && process.env
      ? process.env.NEXT_PUBLIC_API_URL || process.env.API_BASE_URL
      : undefined;
  return (env || 'http://localhost:4000').replace(/\/$/, '');
}

/**
 * Shared Socket.IO client connected to the NestJS `/ws` namespace for delivery riders.
 */
export function getDeliverySocket(riderId = 'rider_01'): Socket {
  if (socket) return socket;
  socket = io(`${apiBase()}/ws`, {
    query: { riderId, role: 'rider', userId: `rider_${riderId}` },
    transports: ['websocket', 'polling'],
    reconnection: true,
    reconnectionAttempts: 10,
    reconnectionDelay: 1000,
  });
  return socket;
}

export function joinOrderRoom(orderId: string) {
  const s = getDeliverySocket();
  s.emit('join_room', `order_${orderId}`);
}

export function leaveOrderRoom(orderId: string) {
  socket?.emit('leave_room', `order_${orderId}`);
}

export function emitRiderGps(orderId: string, riderId: string, lat: number, lng: number) {
  const s = getDeliverySocket();
  s.emit('rider_gps_tick', { orderId, riderId, lat, lng });
}

export function emitDeliveryStatus(orderId: string, status: string, riderId = 'rider_01', lat?: number, lng?: number) {
  const s = getDeliverySocket();
  s.emit('update_delivery_status', { orderId, status, riderId, lat, lng });
}
