// Google Stitch Screen ID: d901728d3b374171a0c021497303fca7
// Title: Live Order Tracking - Daily Basket Elite
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useEffect, useState, useMemo } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import {
  ArrowLeft,
  Phone,
  CheckCircle2,
  Navigation,
  Loader2,
  ShieldCheck,
  Bike,
  MapPin,
  Clock,
  Sparkles,
  Receipt,
  Radio,
} from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { apiClient } from '@daily-basket/api-client';
import { getSocket, joinRoom, leaveRoom } from '../../../lib/socket';
import { useCurrentUserId } from '../../../store/useCart';

const STAGE: Record<string, number> = {
  CREATED: 0,
  CONFIRMED: 0,
  PACKING: 1,
  READY_FOR_PICKUP: 1,
  ASSIGNED: 1,
  OUT_FOR_DELIVERY: 2,
  PICKED_UP: 2,
  ARRIVED: 2,
  DELIVERED: 3,
};

const STEP_LABELS = ['Order Placed', 'Packed at Store', 'Out for Delivery', 'Delivered to Doorstep'];

export default function DeliveryTrackingPage() {
  const params = useParams();
  const rawId = (params?.id as string) || '';
  const orderId = decodeURIComponent(rawId);
  const userId = useCurrentUserId();

  // Local fallback order if backend is offline or mock order
  const [localFallbackOrder, setLocalFallbackOrder] = useState<any>(null);

  // Live real-time socket overrides
  const [liveStatus, setLiveStatus] = useState<string | null>(null);
  const [liveRiderCoords, setLiveRiderCoords] = useState<{ lat: number; lng: number } | null>(null);
  const [lastTelemetryUpdate, setLastTelemetryUpdate] = useState<string>('');
  const [deliveryProgressRatio, setDeliveryProgressRatio] = useState<number>(0.45);

  useEffect(() => {
    if (typeof window !== 'undefined') {
      try {
        const lastOrderRaw = localStorage.getItem('daily_basket_last_order');
        if (lastOrderRaw) {
          const parsed = JSON.parse(lastOrderRaw);
          if (!orderId || parsed.id === orderId || parsed.orderNumber === orderId) {
            setLocalFallbackOrder(parsed);
          }
        }
        const ordersRaw = localStorage.getItem('daily_basket_orders');
        if (ordersRaw) {
          const parsedList = JSON.parse(ordersRaw);
          const found = parsedList.find((o: any) => o.id === orderId || o.orderNumber === orderId);
          if (found) setLocalFallbackOrder(found);
        }
      } catch {
        // ignore parse error
      }
    }
  }, [orderId]);

  const { data, isLoading, refetch } = useQuery({
    queryKey: ['order-tracking', orderId],
    queryFn: () => apiClient.getOrderTracking(orderId),
    enabled: Boolean(orderId),
    refetchInterval: 30000,
  });

  // Live WebSocket updates
  useEffect(() => {
    if (!orderId) return;
    const socket = getSocket(userId);
    joinRoom(`order_${orderId}`);

    const onStatusUpdate = (payload: any) => {
      if (payload?.status) {
        setLiveStatus(payload.status);
      }
      refetch();
    };

    const onLocationUpdate = (payload: any) => {
      if (payload?.lat && payload?.lng) {
        setLiveRiderCoords({ lat: payload.lat, lng: payload.lng });
        setLastTelemetryUpdate(new Date().toLocaleTimeString());
        // Calculate smooth progress along route
        setDeliveryProgressRatio((prev) => Math.min(prev + 0.1, 0.95));
      }
    };

    const onDelivered = () => {
      setLiveStatus('DELIVERED');
      setDeliveryProgressRatio(1.0);
      refetch();
    };

    socket.on('order_status_update', onStatusUpdate);
    socket.on('order_packing', onStatusUpdate);
    socket.on('order_delivered', onDelivered);
    socket.on('rider_assigned', onStatusUpdate);
    socket.on('rider_location_update', onLocationUpdate);

    return () => {
      socket.off('order_status_update', onStatusUpdate);
      socket.off('order_packing', onStatusUpdate);
      socket.off('order_delivered', onDelivered);
      socket.off('rider_assigned', onStatusUpdate);
      socket.off('rider_location_update', onLocationUpdate);
      leaveRoom(`order_${orderId}`);
    };
  }, [orderId, userId, refetch]);

  // Combined order object: backend data -> local fallback -> default preview
  const order = (data as any)?.order || localFallbackOrder || {
    id: orderId || 'DB-892104',
    orderNumber: orderId || 'DB-892104',
    status: 'OUT_FOR_DELIVERY',
    estimatedArrivalMins: 7,
    totalAmount: 320,
    deliveryOtp: '4821',
    address: {
      streetAddress: '#42 100 Feet Rd, Koramangala 4th Block',
      city: 'Bengaluru',
      landmark: 'Near Sony World Signal',
    },
    items: [
      { id: '1', productName: 'Organic Cow Milk (1L)', quantity: 2, price: 68, totalPrice: 136 },
      { id: '2', productName: 'Fresh Farm Eggs (12 pcs)', quantity: 1, price: 95, totalPrice: 95 },
      { id: '3', productName: 'Alphonso Mangoes (1kg)', quantity: 1, price: 89, totalPrice: 89 },
    ],
  };

  const status: string =
    liveStatus ??
    (data as any)?.stepStatus ??
    order?.status ??
    'OUT_FOR_DELIVERY';

  const isDelivered = status === 'DELIVERED';
  const isCancelled = status === 'CANCELLED';
  const eta = isDelivered ? 0 : Math.max(1, Math.round((1 - deliveryProgressRatio) * 10));
  const currentStage = isCancelled ? -1 : isDelivered ? 3 : (STAGE[status] ?? 2);

  const rider = order?.deliveryPartner || {
    fullName: 'Ramesh Kumar',
    phoneNumber: '+91 98765 00112',
    vehicleNumber: 'KA 01 EB 4821',
    rating: 4.9,
    vehicleType: 'Electric Scooter (Zero Emission)',
  };

  const otpCode = order?.deliveryOtp || '4821';

  return (
    <div className="min-h-screen bg-slate-50 font-sans pb-28 text-slate-900">
      {/* Top Sticky Header */}
      <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200/80 px-4 sm:px-8 py-3.5">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link
              href="/"
              className="p-2 text-[#006b23] hover:bg-emerald-50 rounded-full transition"
            >
              <ArrowLeft className="w-5 h-5" />
            </Link>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-lg sm:text-xl font-extrabold text-slate-900 font-outfit">
                  Live Order Tracking
                </h1>
                <span className="bg-emerald-100 text-[#006b23] text-[10px] font-extrabold px-2 py-0.5 rounded-full flex items-center gap-1">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#006b23] animate-pulse" />
                  LIVE GPS
                </span>
              </div>
              <p className="text-xs text-slate-500 font-medium font-inter">
                Order #{order?.orderNumber ?? orderId}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => refetch()}
              className="p-2 text-slate-600 hover:bg-slate-100 rounded-xl transition text-xs font-bold hidden sm:flex items-center gap-1"
            >
              <span>Refresh</span>
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 sm:px-8 pt-6 space-y-6">
        {isLoading && !localFallbackOrder && (
          <div className="py-24 flex flex-col items-center gap-3 text-slate-500">
            <Loader2 className="w-8 h-8 animate-spin text-[#006b23]" />
            <p className="text-sm font-medium">Connecting to live dark-store dispatch…</p>
          </div>
        )}

        {/* 1. Live ETA & Status Hero Banner */}
        <div className="bg-gradient-to-br from-[#006b23] via-[#00571c] to-[#003d13] text-white rounded-3xl p-6 sm:p-8 shadow-xl relative overflow-hidden flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1.5 text-center sm:text-left z-10">
            <div className="flex items-center justify-center sm:justify-start gap-2">
              <span className="px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-extrabold uppercase tracking-wider">
                {isDelivered
                  ? 'Delivered to Doorstep'
                  : isCancelled
                  ? 'Order Cancelled'
                  : '10-Minute Express Quick Commerce'}
              </span>
            </div>
            <h2 className="text-3xl sm:text-4xl font-extrabold font-outfit">
              {isDelivered
                ? 'Order Delivered! 🎉'
                : isCancelled
                ? 'Order Cancelled'
                : `Arriving in ${eta} Mins`}
            </h2>
            <p className="text-emerald-100 text-sm font-inter max-w-lg">
              {isDelivered
                ? 'Your groceries have been safely delivered. Enjoy fresh ingredients!'
                : status === 'PACKING'
                ? 'Our dark store team in Koramangala is packing your items right now.'
                : `${rider.fullName} is riding on an ${rider.vehicleType || 'Electric Scooter'} towards your address.`}
            </p>
          </div>

          <div className="relative flex-shrink-0 z-10">
            <div className="w-20 h-20 rounded-3xl bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center shadow-inner">
              {isDelivered ? (
                <CheckCircle2 className="w-10 h-10 text-emerald-300 animate-bounce" />
              ) : (
                <Bike className="w-10 h-10 text-white animate-pulse" />
              )}
            </div>
          </div>

          {/* Decorative ambient background orb */}
          <div className="absolute -right-10 -bottom-10 w-48 h-48 bg-emerald-400/20 rounded-full blur-2xl pointer-events-none" />
        </div>

        {/* 2. Interactive Vector Map Route Simulation */}
        <div className="bg-white rounded-3xl p-5 border border-slate-200/80 shadow-sm overflow-hidden space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Navigation className="w-4 h-4 text-[#006b23]" />
              <h3 className="font-outfit font-bold text-sm text-slate-900">
                Live Delivery Route Telemetry
              </h3>
            </div>
            <div className="flex items-center gap-1.5 text-[11px] font-mono text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-full font-bold">
              <Radio className="w-3 h-3 text-[#006b23] animate-pulse" />
              <span>
                {liveRiderCoords
                  ? `${liveRiderCoords.lat.toFixed(4)}, ${liveRiderCoords.lng.toFixed(4)}`
                  : 'Koramangala 4th Block'}
              </span>
            </div>
          </div>

          {/* Map canvas simulation with moving rider marker */}
          <div className="relative h-48 sm:h-56 w-full rounded-2xl bg-[#E8F0E8] overflow-hidden border border-emerald-100 shadow-inner">
            {/* Street Grid SVG */}
            <svg className="absolute inset-0 w-full h-full stroke-white stroke-[8]" xmlns="http://www.w3.org/2000/svg">
              <line x1="0" y1="35%" x2="100%" y2="35%" />
              <line x1="0" y1="70%" x2="100%" y2="70%" />
              <line x1="30%" y1="0" x2="30%" y2="100%" />
              <line x1="75%" y1="0" x2="75%" y2="100%" />
            </svg>

            {/* Route Polyline (Dashed Green) */}
            <svg className="absolute inset-0 w-full h-full" xmlns="http://www.w3.org/2000/svg">
              <line
                x1="25%"
                y1="35%"
                x2="75%"
                y2="70%"
                stroke="#006b23"
                strokeWidth="4"
                strokeDasharray="6,4"
              />
            </svg>

            {/* Store Hub Marker (Start) */}
            <div className="absolute left-[20%] top-[25%] -translate-x-1/2 -translate-y-1/2 text-center">
              <div className="w-8 h-8 rounded-full bg-slate-900 text-white flex items-center justify-center text-xs font-bold shadow-md border-2 border-white mx-auto">
                🏪
              </div>
              <span className="text-[10px] font-bold text-slate-800 bg-white/90 px-1.5 py-0.5 rounded shadow mt-1 inline-block">
                Hub Store
              </span>
            </div>

            {/* Customer Doorstep Marker (End) */}
            <div className="absolute left-[78%] top-[68%] -translate-x-1/2 -translate-y-1/2 text-center">
              <div className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center text-xs font-bold shadow-lg border-2 border-white mx-auto animate-pulse">
                <MapPin className="w-4 h-4 text-white" />
              </div>
              <span className="text-[10px] font-bold text-slate-800 bg-white/90 px-1.5 py-0.5 rounded shadow mt-1 inline-block">
                Doorstep
              </span>
            </div>

            {/* Moving Rider Pin */}
            <div
              className="absolute -translate-x-1/2 -translate-y-1/2 transition-all duration-700 ease-out z-20 text-center"
              style={{
                left: `${25 + (75 - 25) * deliveryProgressRatio}%`,
                top: `${35 + (70 - 35) * deliveryProgressRatio}%`,
              }}
            >
              <div className="w-10 h-10 rounded-full bg-[#006b23] text-white flex items-center justify-center shadow-xl border-2 border-white mx-auto ring-4 ring-emerald-400/40 animate-bounce">
                <Bike className="w-5 h-5 text-white" />
              </div>
              <span className="text-[10px] font-extrabold text-[#006b23] bg-white px-2 py-0.5 rounded-full shadow-md mt-1 inline-block whitespace-nowrap">
                Ramesh (24 km/h)
              </span>
            </div>

            {/* Live Telemetry Info Overlay */}
            <div className="absolute bottom-2 left-2 bg-white/90 backdrop-blur-md px-2.5 py-1 rounded-xl text-[10px] text-slate-600 font-mono shadow border border-slate-200/60">
              {lastTelemetryUpdate ? `GPS Updated: ${lastTelemetryUpdate}` : 'Real-time GPS Tracking via Socket.IO'}
            </div>
          </div>
        </div>

        {/* 3. Delivery OTP Verification Box */}
        <div className="bg-gradient-to-r from-emerald-50 to-teal-50 border-2 border-dashed border-emerald-300 rounded-3xl p-5 flex flex-col sm:flex-row items-center justify-between gap-4 shadow-sm">
          <div className="flex items-center gap-3.5">
            <div className="w-12 h-12 rounded-2xl bg-[#006b23] text-white flex items-center justify-center flex-shrink-0 shadow-md">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <div>
              <p className="text-xs font-bold text-[#006b23] uppercase tracking-wider">
                Safe Delivery Verification
              </p>
              <h4 className="text-sm font-extrabold text-slate-900">
                Customer Delivery OTP
              </h4>
              <p className="text-xs text-slate-600 mt-0.5">
                Share this 4-digit code with Ramesh upon receiving your basket.
              </p>
            </div>
          </div>

          <div className="bg-white border-2 border-[#006b23] px-6 py-2 rounded-2xl shadow text-center">
            <span className="text-2xl sm:text-3xl font-mono font-black text-[#006b23] tracking-widest">
              {otpCode}
            </span>
          </div>
        </div>

        {/* 4. Delivery Partner Profile */}
        <div className="bg-white rounded-3xl p-5 border border-slate-200/80 shadow-sm flex items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-full bg-emerald-100 text-[#006b23] font-bold text-xl flex items-center justify-center border-2 border-emerald-300 flex-shrink-0">
              {(rider.fullName || 'RK').split(' ').map((n: string) => n[0]).join('').slice(0, 2)}
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h3 className="font-outfit font-extrabold text-base text-slate-900">
                  {rider.fullName}
                </h3>
                <span className="bg-amber-100 text-amber-800 text-[11px] font-bold px-2 py-0.5 rounded-full flex items-center gap-0.5">
                  ★ {rider.rating || 4.9}
                </span>
              </div>
              <p className="text-xs text-slate-500 font-inter mt-0.5">
                {rider.vehicleNumber} • {rider.vehicleType || 'Electric Scooter'}
              </p>
              <span className="text-[10px] text-emerald-700 font-semibold bg-emerald-50 px-2 py-0.5 rounded-md mt-1 inline-block">
                ✓ Vaccinated & Background Verified
              </span>
            </div>
          </div>

          {rider.phoneNumber && (
            <a
              href={`tel:${rider.phoneNumber}`}
              className="w-12 h-12 rounded-2xl bg-[#006b23] text-white flex items-center justify-center shadow-lg hover:bg-[#00531a] transition flex-shrink-0"
              title="Call delivery partner"
            >
              <Phone className="w-5 h-5" />
            </a>
          )}
        </div>

        {/* 5. Progress Stepper */}
        <div className="bg-white rounded-3xl p-6 border border-slate-200/80 shadow-sm space-y-6">
          <h3 className="text-base font-bold font-outfit text-slate-900">
            Fulfillment Milestones
          </h3>
          <div className="relative pl-6 border-l-2 border-slate-200 space-y-6 ml-3">
            {STEP_LABELS.map((label, idx) => {
              const completed = idx < currentStage || isDelivered;
              const current = idx === currentStage && !isDelivered;

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
                      <div
                        className={`w-2 h-2 rounded-full ${current ? 'bg-[#006b23]' : 'bg-slate-300'}`}
                      />
                    )}
                  </div>
                  <div>
                    <h4
                      className={`font-outfit text-sm font-bold ${
                        current ? 'text-[#006b23]' : completed ? 'text-slate-900' : 'text-slate-400'
                      }`}
                    >
                      {label}
                    </h4>
                    <p className="text-xs text-slate-500 mt-0.5">
                      {idx === 0
                        ? 'Order received & allocated to nearest Hub'
                        : idx === 1
                        ? 'Items packed in eco-friendly insulated crate'
                        : idx === 2
                        ? 'Delivery partner on the way to your door'
                        : 'Delivered with contact-free safety'}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* 6. Order Summary & Items Breakdown */}
        {Array.isArray(order.items) && order.items.length > 0 && (
          <div className="bg-white rounded-3xl p-6 border border-slate-200/80 shadow-sm space-y-3">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <div className="flex items-center gap-2">
                <Receipt className="w-4 h-4 text-[#006b23]" />
                <h3 className="text-base font-bold font-outfit text-slate-900">Order Items</h3>
              </div>
              <span className="text-xs font-bold text-slate-500">
                {order.items.length} items
              </span>
            </div>
            <div className="space-y-2.5 pt-1">
              {order.items.map((it: any) => (
                <div key={it.id || it.productName} className="flex justify-between text-sm py-1 border-b border-slate-50">
                  <div className="flex items-center gap-2">
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                    <span className="text-slate-700 font-medium">
                      {it.productName} × {it.quantity}
                    </span>
                  </div>
                  <span className="font-bold text-slate-900">
                    ₹{it.totalPrice ?? (it.price || 0) * (it.quantity || 1)}
                  </span>
                </div>
              ))}
            </div>

            <div className="flex justify-between items-center pt-3 text-sm font-bold border-t border-slate-100">
              <span className="text-slate-900">Total Paid (Inclusive of all taxes)</span>
              <span className="text-[#006b23] text-base">₹{order.totalAmount || 320}</span>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
