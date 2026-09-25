'use client';

import { io, Socket } from 'socket.io-client';

let socket: Socket | null = null;
const joinedRooms = new Set<string>();

function apiBase(): string {
  const env =
    typeof process !== 'undefined' && process.env
      ? process.env.NEXT_PUBLIC_API_URL || process.env.API_BASE_URL
      : undefined;
  return (env || 'http://localhost:4000').replace(/\/$/, '');
}

/**
 * Shared Socket.IO client connected to the NestJS `/ws` namespace for Admin Dashboard.
 */
export function getAdminSocket(adminId = 'admin_01'): Socket {
  if (socket) return socket;
  socket = io(`${apiBase()}/ws`, {
    query: { adminId, role: 'admin', userId: `admin_${adminId}` },
    transports: ['polling', 'websocket'],
    tryAllTransports: true,
    reconnection: true,
    reconnectionAttempts: Infinity,
    reconnectionDelay: 1000,
  });

  // Re-join tracked rooms whenever the socket reconnects
  socket.on('connect', () => {
    joinedRooms.forEach((room) => {
      socket?.emit('join_room', room);
    });
  });

  return socket;
}

export function joinAdminRoom(room = 'admin') {
  joinedRooms.add(room);
  const s = getAdminSocket();
  s.emit('join_room', room);
}

export function leaveAdminRoom(room = 'admin') {
  joinedRooms.delete(room);
  socket?.emit('leave_room', room);
}

export function emitAdminStatusUpdate(orderId: string, status: string, riderId?: string) {
  const s = getAdminSocket();
  s.emit('update_delivery_status', { orderId, status, riderId });
}
