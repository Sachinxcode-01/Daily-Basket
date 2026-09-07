// Google Stitch Screen ID: d901728d3b374171a0c021497303fca7
// Title: Live Order Tracking - Daily Basket Elite
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useEffect } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { ArrowLeft, Phone, CheckCircle2, Navigation, Loader2 } from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { apiClient } from '@daily-basket/api-client';
import { getSocket, joinRoom, leaveRoom } from '../../../lib/socket';
import { useCurrentUserId } from '../../../store/useCart';

const STAGE: Record<string, number> = {
  CREATED: 0,
  CONFIRMED: 0,
  PACKING: 1,
  READY_FOR_PICKUP: 1,
  OUT_FOR_DELIVERY: 2,
  DELIVERED: 3,
};

const STEP_LABELS = ['Order Placed', 'Packed at Store', 'Out for Delivery', 'Delivered to Doorstep'];

export default function DeliveryTrackingPage() {
  const params = useParams();
  const orderId = (params?.id as string) || '';
  const userId = useCurrentUserId();

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ['order-tracking', orderId],
    queryFn: () => apiClient.getOrderTracking(orderId),
    enabled: Boolean(orderId),
    refetchInterval: 30000,
  });

  // Live updates: join this order's room and refetch on status / location events.
  useEffect(() => {
    if (!orderId) return;
    const socket = getSocket(userId);
    joinRoom(`order_${orderId}`);
    const onUpdate = () => refetch();
    socket.on('order_status_update', onUpdate);
    socket.on('order_packing', onUpdate);
    socket.on('order_delivered', onUpdate);
    socket.on('rider_assigned', onUpdate);
    socket.on('rider_location_update', onUpdate);
    return () => {
      socket.off('order_status_update', onUpdate);
      socket.off('order_packing', onUpdate);
      socket.off('order_delivered', onUpdate);
      socket.off('rider_assigned', onUpdate);
      socket.off('rider_location_update', onUpdate);
      leaveRoom(`order_${orderId}`);
    };
  }, [orderId, userId, refetch]);

  const order = (data as any)?.order;
  const status: string = (data as any)?.stepStatus ?? order?.status ?? 'CONFIRMED';
  const eta = (data as any)?.estimatedEtaMins ?? order?.estimatedArrivalMins ?? 10;
  const currentStage = status === 'CANCELLED' ? -1 : (STAGE[status] ?? 0);
  const rider = order?.deliveryPartner;

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-24 text-slate-900">
      {/* Header */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/" className="p-2 text-[#006b23] hover:bg-slate-100 rounded-full transition">
              <ArrowLeft className="w-6 h-6" />
            </Link>
            <div>
              <h1 className="text-lg sm:text-xl font-extrabold text-slate-900 font-outfit">Live Order Tracking</h1>
              <p className="text-xs text-slate-500 font-medium font-inter">
                Order #{order?.orderNumber ?? orderId}
              </p>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-6">
        {isLoading && (
          <div className="py-24 flex flex-col items-center gap-3 text-slate-500">
            <Loader2 className="w-8 h-8 animate-spin text-[#006b23]" />
            <p className="text-sm">Loading order status…</p>
          </div>
        )}

        {!isLoading && isError && (
          <div className="py-20 text-center space-y-4">
            <p className="font-bold text-slate-900">Couldn&rsquo;t load this order</p>
            <button onClick={() => refetch()} className="px-5 py-2.5 bg-[#006b23] text-white text-sm font-bold rounded-xl">Retry</button>
          </div>
        )}

        {!isLoading && !isError && order && (
          <>
            {/* ETA Hero */}
            <div className="bg-[#006b23] text-white rounded-3xl p-6 sm:p-8 shadow-lg relative overflow-hidden flex flex-col sm:flex-row items-center justify-between gap-6">
              <div className="space-y-1 text-center sm:text-left">
                <span className="inline-block px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider">
                  {status === 'DELIVERED' ? 'Delivered' : status === 'CANCELLED' ? 'Cancelled' : 'Express Delivery'}
                </span>
                <h2 className="text-3xl sm:text-4xl font-extrabold font-outfit">
                  {status === 'DELIVERED' ? 'Order Delivered' : status === 'CANCELLED' ? 'Order Cancelled' : `Arriving in ${eta} Mins`}
                </h2>
                <p className="text-white/90 text-sm font-inter">
                  {status === 'DELIVERED'
                    ? 'Thanks for shopping with Daily Basket!'
                    : rider
                    ? `Your partner ${rider.fullName} is on the way with your fresh basket!`
                    : 'Your order is confirmed and being prepared.'}
                </p>
              </div>
              <div className="w-20 h-20 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center flex-shrink-0 animate-pulse">
                <Navigation className="w-10 h-10 text-white" />
              </div>
            </div>

            {/* Rider Profile (only when assigned) */}
            {rider && (
              <div className="bg-white rounded-2xl p-5 border border-slate-100 shadow-sm flex items-center justify-between gap-4">
                <div className="flex items-center gap-4">
                  <div className="w-14 h-14 rounded-full bg-emerald-100 text-[#006b23] font-bold text-xl flex items-center justify-center border-2 border-emerald-200">
                    {(rider.fullName || 'DP').split(' ').map((n: string) => n[0]).join('').slice(0, 2)}
                  </div>
                  <div>
                    <h3 className="font-outfit font-bold text-base text-slate-900">{rider.fullName}</h3>
                    <p className="text-xs text-slate-500 font-inter mt-0.5">Your delivery partner</p>
                  </div>
                </div>
                {rider.phoneNumber && (
                  <a href={`tel:${rider.phoneNumber}`} className="w-11 h-11 rounded-full bg-[#006b23] text-white flex items-center justify-center shadow-md hover:bg-[#00531a] transition">
                    <Phone className="w-5 h-5" />
                  </a>
                )}
              </div>
            )}

            {/* Progress Stepper */}
            <div className="bg-white rounded-2xl p-6 border border-slate-100 shadow-sm space-y-6">
              <h3 className="text-base font-bold font-outfit text-slate-900">Delivery Status</h3>
              <div className="relative pl-6 border-l-2 border-slate-200 space-y-6 ml-3">
                {STEP_LABELS.map((label, idx) => {
                  const completed = idx < currentStage || status === 'DELIVERED';
                  const current = idx === currentStage && status !== 'DELIVERED';
                  return (
                    <div key={label} className="relative flex items-start justify-between">
                      <div
                        className={`absolute -left-[31px] top-0 w-6 h-6 rounded-full border-2 flex items-center justify-center ${
                          completed
                            ? 'bg-[#006b23] border-[#006b23] text-white'
                            : current
                            ? 'bg-white border-[#006b23] text-[#006b23]'
                            : 'bg-white border-slate-300 text-slate-300'
                        }`}
                      >
                        {completed ? (
                          <CheckCircle2 className="w-4 h-4 stroke-[3]" />
                        ) : (
                          <div className={`w-2 h-2 rounded-full ${current ? 'bg-[#006b23]' : 'bg-slate-300'}`} />
                        )}
                      </div>
                      <div>
                        <h4 className={`font-outfit text-sm font-semibold ${current ? 'text-[#006b23]' : 'text-slate-900'}`}>
                          {label}
                        </h4>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Order items summary */}
            {Array.isArray(order.items) && order.items.length > 0 && (
              <div className="bg-white rounded-2xl p-6 border border-slate-100 shadow-sm">
                <h3 className="text-base font-bold font-outfit text-slate-900 mb-3">Order Items</h3>
                <div className="space-y-2">
                  {order.items.map((it: any) => (
                    <div key={it.id} className="flex justify-between text-sm">
                      <span className="text-slate-700">{it.productName} × {it.quantity}</span>
                      <span className="font-semibold text-slate-900">₹{it.totalPrice ?? it.price * it.quantity}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        )}
      </main>
    </div>
  );
}
