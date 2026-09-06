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
 * Shared Socket.IO client connected to the NestJS `/ws` namespace.
 * Reused across the app so we hold a single connection.
 */
export function getSocket(userId = 'usr_default'): Socket {
  if (socket) return socket;
  socket = io(`${apiBase()}/ws`, {
    query: { userId },
    transports: ['websocket', 'polling'],
    reconnection: true,
    reconnectionAttempts: 10,
    reconnectionDelay: 1000,
  });
  return socket;
}

export function joinRoom(room: string) {
  getSocket().emit('join_room', room);
}

export function leaveRoom(room: string) {
  socket?.emit('leave_room', room);
}
