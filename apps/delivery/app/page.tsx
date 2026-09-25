'use client';

import React, { useState, useEffect, useRef } from 'react';
import {
  Bike,
  Navigation,
  Phone,
  CheckCircle2,
  DollarSign,
  MapPin,
  Clock,
  ShieldCheck,
  Power,
  ChevronRight,
  AlertCircle,
  Wifi,
  WifiOff,
  RefreshCw,
  Radio,
  Send,
  Zap,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { OfflineSyncEngine, QueuedOfflineAction } from './lib/offlineStore';
import {
  getDeliverySocket,
  joinOrderRoom,
  leaveOrderRoom,
  emitRiderGps,
  emitDeliveryStatus,
} from './lib/socket';

// Simulated delivery waypoint path: Koramangala Hub Store #01 to 100 Feet Rd Customer Doorstep
const GPS_WAYPOINTS = [
  { lat: 12.9352, lng: 77.6245, speed: 28, heading: 'NW', street: 'Koramangala 4th Block' },
  { lat: 12.9360, lng: 77.6235, speed: 32, heading: 'NW', street: 'Inner Ring Rd Cross' },
  { lat: 12.9368, lng: 77.6225, speed: 26, heading: 'W', street: 'Sony World Junction' },
  { lat: 12.9376, lng: 77.6212, speed: 24, heading: 'W', street: '100 Feet Rd Corner' },
  { lat: 12.9385, lng: 77.6198, speed: 18, heading: 'SW', street: '100 Feet Rd 4th Block' },
  { lat: 12.9390, lng: 77.6180, speed: 0, heading: 'S', street: 'Customer Doorstep (#42)' },
];

export default function DeliveryRiderDashboardPage() {
  const [isOnline, setIsOnline] = useState(true);
  const [isNetworkOnline, setIsNetworkOnline] = useState(true);
  const [socketConnected, setSocketConnected] = useState(false);
  const [pendingQueueCount, setPendingQueueCount] = useState(0);
  const [isSyncing, setIsSyncing] = useState(false);
  const [orderStep, setOrderStep] = useState<'ASSIGNED' | 'PICKED_UP' | 'ARRIVED' | 'DELIVERED'>('ASSIGNED');
  const [otpInput, setOtpInput] = useState('');
  const [otpError, setOtpError] = useState(false);
  const [showOtpModal, setShowOtpModal] = useState(false);

  // Active order state (allows rider to track preset or customer-entered order ID)
  const [orderId, setOrderId] = useState('DB-892104');
  const [isCustomOrderInput, setIsCustomOrderInput] = useState(false);
  const [customOrderId, setCustomOrderId] = useState('');

  // GPS Telemetry State
  const [waypointIdx, setWaypointIdx] = useState(0);
  const [lastGpsPingTime, setLastGpsPingTime] = useState<string>('Ready');
  const [totalTicksEmitted, setTotalTicksEmitted] = useState(0);
  const gpsTimerRef = useRef<NodeJS.Timeout | null>(null);

  const activeOrder = {
    id: orderId,
    pickup: 'Hub Store #01 Koramangala',
    dropoff: '#42 100 Feet Rd, Koramangala 4th Block',
    customer: 'Ananya Sharma',
    phone: '+91 98765 12345',
    items: '3 Items (Organic Milk, Eggs, Mangoes)',
    earnings: 45,
    distance: '1.8 km',
    validOtp: '4821',
  };

  const currentGps = GPS_WAYPOINTS[waypointIdx] || GPS_WAYPOINTS[0];

  // 1. Manage WebSocket Connection & Room Subscription
  useEffect(() => {
    const socket = getDeliverySocket('rider_01');

    const onConnect = () => {
      setSocketConnected(true);
      joinOrderRoom(orderId);
    };

    const onDisconnect = () => {
      setSocketConnected(false);
    };

    if (socket.connected) {
      setSocketConnected(true);
      joinOrderRoom(orderId);
    }

    socket.on('connect', onConnect);
    socket.on('disconnect', onDisconnect);

    return () => {
      socket.off('connect', onConnect);
      socket.off('disconnect', onDisconnect);
      leaveOrderRoom(orderId);
    };
  }, [orderId]);

  // 2. Offline Queue & Network Detection
  useEffect(() => {
    setPendingQueueCount(OfflineSyncEngine.getQueue().length);
    setIsNetworkOnline(typeof navigator !== 'undefined' ? navigator.onLine : true);

    const handleOnline = async () => {
      setIsNetworkOnline(true);
      await triggerQueueSync();
    };

    const handleOffline = () => {
      setIsNetworkOnline(false);
    };

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  // 3. Automated GPS Stream Loop while OUT_FOR_DELIVERY / PICKED_UP
  useEffect(() => {
    if (orderStep === 'PICKED_UP' && isOnline) {
      // Emit immediate tick
      sendGpsTick();

      gpsTimerRef.current = setInterval(() => {
        setWaypointIdx((prev) => {
          const next = (prev + 1) % GPS_WAYPOINTS.length;
          const pt = GPS_WAYPOINTS[next];
          emitRiderGps(orderId, 'rider_01', pt.lat, pt.lng);
          setLastGpsPingTime(new Date().toLocaleTimeString());
          setTotalTicksEmitted((t) => t + 1);
          return next;
        });
      }, 3500);
    } else {
      if (gpsTimerRef.current) {
        clearInterval(gpsTimerRef.current);
        gpsTimerRef.current = null;
      }
    }

    return () => {
      if (gpsTimerRef.current) {
        clearInterval(gpsTimerRef.current);
        gpsTimerRef.current = null;
      }
    };
  }, [orderStep, isOnline, orderId]);

  const sendGpsTick = () => {
    const pt = GPS_WAYPOINTS[waypointIdx];
    emitRiderGps(orderId, 'rider_01', pt.lat, pt.lng);
    setLastGpsPingTime(new Date().toLocaleTimeString());
    setTotalTicksEmitted((t) => t + 1);
  };

  const triggerQueueSync = async () => {
    setIsSyncing(true);
    const result = await OfflineSyncEngine.flushQueue();
    setPendingQueueCount(OfflineSyncEngine.getQueue().length);
    setIsSyncing(false);
  };

  const handleStepTransition = async (
    nextStep: 'PICKED_UP' | 'ARRIVED' | 'DELIVERED',
    payload?: Record<string, any>,
  ) => {
    setOrderStep(nextStep);

    // Map UI step to backend order status
    const statusMap: Record<string, string> = {
      PICKED_UP: 'OUT_FOR_DELIVERY',
      ARRIVED: 'OUT_FOR_DELIVERY',
      DELIVERED: 'DELIVERED',
    };
    const apiStatus = statusMap[nextStep] || nextStep;

    // Realtime Socket broadcast to customer & admin
    emitDeliveryStatus(orderId, apiStatus, 'rider_01', currentGps.lat, currentGps.lng);

    // REST API update (if online)
    if (isNetworkOnline) {
      try {
        if (nextStep === 'DELIVERED') {
          await apiClient.completeDelivery(orderId, payload?.otp || activeOrder.validOtp);
        } else {
          await apiClient.updateDeliveryStatus(orderId, apiStatus);
        }
      } catch (err) {
        console.warn('Backend REST update failed, socket was dispatched:', err);
      }
    } else {
      // Queue offline
      OfflineSyncEngine.enqueueAction('STATUS_UPDATE', orderId, {
        step: nextStep,
        apiStatus,
        ...payload,
      });
      setPendingQueueCount(OfflineSyncEngine.getQueue().length);
    }
  };

  const handleVerifyOtp = () => {
    if (otpInput === activeOrder.validOtp || otpInput === '4821') {
      handleStepTransition('DELIVERED', { otpVerified: true, otp: otpInput });
      setShowOtpModal(false);
      setOtpError(false);
      setOtpInput('');
    } else {
      setOtpError(true);
    }
  };

  const handleApplyCustomOrder = (e: React.FormEvent) => {
    e.preventDefault();
    if (customOrderId.trim()) {
      leaveOrderRoom(orderId);
      setOrderId(customOrderId.trim());
      joinOrderRoom(customOrderId.trim());
      setIsCustomOrderInput(false);
      setOrderStep('ASSIGNED');
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 p-4 pb-24 max-w-md mx-auto font-sans">
      {/* Network Connectivity Status Banner */}
      {!isNetworkOnline && (
        <div className="bg-amber-500/20 border border-amber-500/40 text-amber-300 p-3 rounded-2xl mb-4 text-xs flex items-center justify-between shadow-lg animate-pulse">
          <div className="flex items-center gap-2 font-bold">
            <WifiOff className="w-4 h-4 text-amber-400" />
            <span>Offline Mode — Actions queued locally</span>
          </div>
          {pendingQueueCount > 0 && (
            <span className="bg-amber-500/30 px-2 py-0.5 rounded-full text-[10px] font-extrabold">
              {pendingQueueCount} Queued
            </span>
          )}
        </div>
      )}

      {isNetworkOnline && pendingQueueCount > 0 && (
        <div className="bg-emerald-500/20 border border-emerald-500/40 text-emerald-300 p-3 rounded-2xl mb-4 text-xs flex items-center justify-between shadow-lg">
          <div className="flex items-center gap-2 font-bold">
            <Wifi className="w-4 h-4 text-emerald-400" />
            <span>Connection Restored ({pendingQueueCount} Pending)</span>
          </div>
          <button
            onClick={triggerQueueSync}
            disabled={isSyncing}
            className="bg-emerald-600 hover:bg-emerald-500 text-white px-3 py-1 rounded-xl text-[11px] font-bold flex items-center gap-1 transition"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${isSyncing ? 'animate-spin' : ''}`} />
            <span>{isSyncing ? 'Syncing...' : 'Sync Now'}</span>
          </button>
        </div>
      )}

      {/* Top Header & Duty Toggle */}
      <div className="flex items-center justify-between py-3 border-b border-slate-800 mb-4">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-emerald-600 flex items-center justify-center text-white font-bold shadow-lg">
            <Bike className="w-5 h-5" />
          </div>
          <div>
            <h1 className="text-base font-extrabold text-white">Ramesh Kumar</h1>
            <div className="flex items-center gap-2 text-xs text-slate-400">
              <span>KA 01 EB 4821</span>
              <span>•</span>
              <span className="text-amber-400 font-bold">⭐ 4.9</span>
            </div>
          </div>
        </div>

        <button
          onClick={() => setIsOnline(!isOnline)}
          className={`px-3.5 py-1.5 rounded-full font-bold text-xs flex items-center gap-1.5 border transition ${
            isOnline
              ? 'bg-emerald-500/10 border-emerald-500 text-emerald-400'
              : 'bg-rose-500/10 border-rose-500 text-rose-400'
          }`}
        >
          <Power className="w-3.5 h-3.5" />
          <span>{isOnline ? 'ON DUTY' : 'OFFLINE'}</span>
        </button>
      </div>

      {/* Live Socket.IO Status Badge */}
      <div className="flex items-center justify-between bg-slate-900 border border-slate-800 px-3.5 py-2 rounded-2xl mb-4 text-xs">
        <div className="flex items-center gap-2">
          <span className={`w-2.5 h-2.5 rounded-full ${socketConnected ? 'bg-emerald-400 animate-pulse' : 'bg-rose-400'}`} />
          <span className="font-semibold text-slate-300">
            {socketConnected ? 'Socket.IO Gateway Connected' : 'Connecting to Gateway...'}
          </span>
        </div>
        <span className="text-[10px] text-slate-500 font-mono">room: order_{orderId}</span>
      </div>

      {/* Today's Wallet Earnings summary */}
      <div className="bg-gradient-to-r from-emerald-950/80 via-emerald-900/50 to-teal-950/80 border border-emerald-500/30 p-4 rounded-3xl mb-5 shadow-xl flex items-center justify-between">
        <div>
          <p className="text-[11px] text-emerald-300 font-bold uppercase tracking-wider">Today&apos;s Earnings</p>
          <h2 className="text-2xl font-black text-white mt-0.5">₹850</h2>
          <p className="text-[11px] text-emerald-200/90 mt-0.5">18 Orders Completed • ₹150 Incentive</p>
        </div>
        <div className="w-11 h-11 rounded-2xl bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center text-emerald-400">
          <DollarSign className="w-5 h-5" />
        </div>
      </div>

      {/* Order Selector Helper (for testing any order in system) */}
      <div className="bg-slate-900/90 border border-slate-800/80 p-3 rounded-2xl mb-4 flex items-center justify-between text-xs">
        <div className="flex items-center gap-2">
          <span className="text-slate-400">Order Target:</span>
          <span className="font-mono font-bold text-emerald-400">{orderId}</span>
        </div>
        <button
          onClick={() => setIsCustomOrderInput(!isCustomOrderInput)}
          className="text-[11px] text-sky-400 hover:text-sky-300 font-semibold underline"
        >
          {isCustomOrderInput ? 'Cancel' : 'Change Order ID'}
        </button>
      </div>

      {isCustomOrderInput && (
        <form onSubmit={handleApplyCustomOrder} className="bg-slate-900 border border-sky-500/30 p-3 rounded-2xl mb-4 space-y-2">
          <p className="text-[11px] text-slate-300">Enter Order ID from checkout or admin dashboard:</p>
          <div className="flex gap-2">
            <input
              type="text"
              value={customOrderId}
              onChange={(e) => setCustomOrderId(e.target.value)}
              placeholder="e.g. DB-892104 or DB-123456"
              className="flex-1 bg-slate-950 border border-slate-700 rounded-xl px-3 py-1.5 text-xs text-white outline-none focus:border-sky-500 font-mono"
            />
            <button
              type="submit"
              className="bg-sky-600 hover:bg-sky-500 text-white font-bold text-xs px-3 py-1.5 rounded-xl transition"
            >
              Switch
            </button>
          </div>
        </form>
      )}

      {/* Active Order Delivery Card */}
      {!isOnline ? (
        <div className="bg-slate-900/80 border border-slate-800 p-8 rounded-3xl text-center space-y-3">
          <Power className="w-12 h-12 text-slate-600 mx-auto" />
          <h3 className="text-lg font-bold text-white">You are Offline</h3>
          <p className="text-xs text-slate-400">Switch status to ON DUTY above to start receiving and fulfilling 10-minute orders.</p>
        </div>
      ) : orderStep === 'DELIVERED' ? (
        <div className="bg-slate-900/90 border border-emerald-500/60 p-8 rounded-3xl text-center space-y-4 shadow-2xl">
          <CheckCircle2 className="w-16 h-16 text-emerald-400 mx-auto animate-bounce" />
          <h3 className="text-xl font-black text-white">Order Delivered!</h3>
          <p className="text-sm font-bold text-emerald-400">+₹45 Added to Wallet</p>
          <div className="bg-slate-950/80 border border-slate-800 p-3 rounded-2xl text-xs text-slate-400">
            Customer verified OTP • Socket.IO broadcast dispatched to tracking screen
          </div>
          <button
            onClick={() => {
              setOrderStep('ASSIGNED');
              setWaypointIdx(0);
              setTotalTicksEmitted(0);
            }}
            className="w-full py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm transition"
          >
            Ready for Next Order
          </button>
        </div>
      ) : (
        <div className="bg-slate-900/90 border border-slate-800 p-5 rounded-3xl space-y-4 shadow-xl">
          <div className="flex items-center justify-between border-b border-slate-800 pb-3">
            <div>
              <span className="text-xs font-bold text-emerald-400">Active Order #{activeOrder.id}</span>
              <p className="text-[11px] text-slate-400">{activeOrder.distance} • Est. Earnings: ₹{activeOrder.earnings}</p>
            </div>
            <span className="bg-amber-500/20 text-amber-400 border border-amber-500/30 px-2.5 py-1 rounded-full text-[10px] font-bold">
              {orderStep}
            </span>
          </div>

          {/* Pickup Store */}
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center text-slate-300 font-bold text-xs flex-shrink-0">
              1
            </div>
            <div>
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">PICKUP FROM STORE</p>
              <h4 className="text-xs font-bold text-white">{activeOrder.pickup}</h4>
            </div>
          </div>

          {/* Dropoff Customer */}
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-emerald-600 flex items-center justify-center text-white font-bold text-xs flex-shrink-0">
              2
            </div>
            <div>
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">DELIVER TO CUSTOMER</p>
              <h4 className="text-xs font-bold text-white">{activeOrder.customer}</h4>
              <p className="text-xs text-slate-300 mt-0.5">{activeOrder.dropoff}</p>
            </div>
          </div>

          {/* Live GPS Telemetry Stream Box */}
          <div className="bg-slate-950 border border-slate-800 rounded-2xl p-3.5 space-y-2">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Radio className={`w-4 h-4 ${orderStep === 'PICKED_UP' ? 'text-emerald-400 animate-pulse' : 'text-slate-500'}`} />
                <span className="text-xs font-bold text-slate-200">
                  {orderStep === 'PICKED_UP' ? 'Live GPS Stream Active' : 'GPS Stream Standby'}
                </span>
              </div>
              <span className="text-[10px] bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded-full font-mono font-bold">
                {totalTicksEmitted} pings
              </span>
            </div>

            <div className="grid grid-cols-2 gap-2 text-[11px] pt-1 border-t border-slate-800/80">
              <div>
                <span className="text-slate-500 block">Coordinates:</span>
                <span className="font-mono text-slate-300">
                  {currentGps.lat.toFixed(4)}, {currentGps.lng.toFixed(4)}
                </span>
              </div>
              <div>
                <span className="text-slate-500 block">Current Street:</span>
                <span className="text-slate-300 truncate block">{currentGps.street}</span>
              </div>
            </div>

            <div className="flex items-center justify-between text-[10px] text-slate-400 pt-1">
              <span>Last Sent: {lastGpsPingTime}</span>
              {orderStep === 'PICKED_UP' && (
                <button
                  onClick={sendGpsTick}
                  className="text-sky-400 hover:text-sky-300 flex items-center gap-1 font-bold"
                >
                  <Send className="w-3 h-3" />
                  <span>Send Ping Now</span>
                </button>
              )}
            </div>
          </div>

          {/* Action CTAs */}
          <div className="grid grid-cols-2 gap-2.5 pt-1">
            <a
              href={`tel:${activeOrder.phone}`}
              className="py-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition"
            >
              <Phone className="w-3.5 h-3.5 text-emerald-400" />
              <span>Call Customer</span>
            </a>
            <button
              onClick={() => {
                const url = `https://www.google.com/maps/dir/?api=1&destination=${currentGps.lat},${currentGps.lng}`;
                window.open(url, '_blank');
              }}
              className="py-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition"
            >
              <Navigation className="w-3.5 h-3.5 text-sky-400" />
              <span>Open Maps</span>
            </button>
          </div>

          {/* Main Delivery Step Action Button */}
          {orderStep === 'ASSIGNED' && (
            <button
              onClick={() => handleStepTransition('PICKED_UP')}
              className="w-full py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm shadow-lg shadow-emerald-950 transition flex items-center justify-center gap-2"
            >
              <Zap className="w-4 h-4" />
              <span>Confirm Order Picked Up (Start GPS)</span>
            </button>
          )}

          {orderStep === 'PICKED_UP' && (
            <button
              onClick={() => handleStepTransition('ARRIVED')}
              className="w-full py-3.5 bg-amber-500 hover:bg-amber-400 text-slate-950 font-extrabold rounded-xl text-sm shadow-lg transition flex items-center justify-center gap-2"
            >
              <MapPin className="w-4 h-4" />
              <span>Arrived at Customer Doorstep</span>
            </button>
          )}

          {orderStep === 'ARRIVED' && (
            <button
              onClick={() => setShowOtpModal(true)}
              className="w-full py-3.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm shadow-lg transition flex items-center justify-center gap-2"
            >
              <ShieldCheck className="w-5 h-5" />
              <span>Enter Customer Delivery OTP</span>
            </button>
          )}
        </div>
      )}

      {/* OTP Delivery Verification Modal */}
      {showOtpModal && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 p-6 rounded-3xl w-full max-w-xs text-center space-y-4 shadow-2xl">
            <ShieldCheck className="w-12 h-12 text-emerald-400 mx-auto" />
            <h3 className="text-lg font-bold text-white">Delivery OTP Verification</h3>
            <p className="text-xs text-slate-400">
              Ask customer for the 4-digit code displayed on their live tracking screen.
            </p>

            <input
              type="text"
              maxLength={4}
              value={otpInput}
              onChange={(e) => setOtpInput(e.target.value)}
              placeholder="4821"
              autoFocus
              className="w-full text-center text-2xl font-mono tracking-widest py-3 bg-slate-950 border border-slate-700 rounded-xl text-white focus:border-emerald-500 outline-none"
            />

            {otpError && (
              <p className="text-xs text-rose-400 font-bold flex items-center justify-center gap-1">
                <AlertCircle className="w-4 h-4" />
                Invalid OTP. Customer default is 4821
              </p>
            )}

            <div className="flex gap-2">
              <button
                onClick={() => {
                  setShowOtpModal(false);
                  setOtpError(false);
                }}
                className="flex-1 py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-300 font-bold text-xs rounded-xl"
              >
                Cancel
              </button>
              <button
                onClick={handleVerifyOtp}
                className="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-lg transition"
              >
                Verify & Complete
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
