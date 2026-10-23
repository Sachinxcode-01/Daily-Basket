'use client';

import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  X,
  Bike,
  Package,
  MapPin,
  Clock,
  CheckCircle2,
  Phone,
  Printer,
  ShieldAlert,
  ArrowRight,
  ExternalLink,
} from 'lucide-react';
import Button from '../ui/Button';
import Badge from '../ui/Badge';
import { LiveOrder } from './LiveOrderRadar';

interface OrderDetailsModalProps {
  order: LiveOrder | null;
  onClose: () => void;
}

export default function OrderDetailsModal({
  order,
  onClose,
}: OrderDetailsModalProps) {
  if (!order) return null;

  const minutes = Math.floor(order.elapsedSeconds / 60);
  const seconds = order.elapsedSeconds % 60;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 overflow-hidden flex justify-end">
        {/* Backdrop */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
          className="fixed inset-0 bg-black/40 backdrop-blur-xs transition-opacity"
        />

        {/* Slide-over Drawer */}
        <motion.div
          initial={{ x: '100%' }}
          animate={{ x: 0 }}
          exit={{ x: '100%' }}
          transition={{ type: 'spring', damping: 28, stiffness: 280 }}
          className="relative w-full max-w-lg bg-white shadow-2xl flex flex-col h-full z-10 border-l border-zinc-200"
        >
          {/* Top Bar */}
          <div className="p-5 border-b border-zinc-200/80 flex items-center justify-between bg-zinc-50/60">
            <div>
              <div className="flex items-center gap-2">
                <h3 className="font-bold text-lg font-headline text-zinc-950">
                  {order.orderNumber}
                </h3>
                <Badge variant="brand" pulse>
                  {order.stage}
                </Badge>
              </div>
              <p className="text-xs text-zinc-500 mt-0.5">
                Target SLA: Under 10 minutes from store shelf
              </p>
            </div>

            <button
              onClick={onClose}
              className="p-2 rounded-xl text-zinc-400 hover:text-zinc-700 hover:bg-zinc-200/70 transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Drawer Body Content */}
          <div className="flex-1 overflow-y-auto p-6 space-y-6">
            {/* SLA Timer Alert Box */}
            <div className="p-4 rounded-xl bg-emerald-50 border border-emerald-200/80 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-[#2d9d43] text-white flex items-center justify-center font-bold">
                  <Clock className="w-5 h-5" />
                </div>
                <div>
                  <div className="text-xs font-semibold text-zinc-600">
                    SLA Elapsed Time
                  </div>
                  <div className="text-xl font-bold font-mono text-zinc-950">
                    {minutes}m {seconds.toString().padStart(2, '0')}s / 10m 00s
                  </div>
                </div>
              </div>
              <span className="text-xs font-bold text-emerald-800 bg-white px-2.5 py-1 rounded-full border border-emerald-200 shadow-2xs">
                98.8% On-Time Target
              </span>
            </div>

            {/* Customer Details */}
            <div className="space-y-3">
              <h4 className="text-xs font-bold uppercase tracking-wider text-zinc-400 font-mono">
                Customer & Destination
              </h4>
              <div className="p-4 rounded-xl bg-zinc-50 border border-zinc-200/70 space-y-2">
                <div className="flex items-center justify-between">
                  <span className="font-bold text-sm text-zinc-950">
                    {order.customerName}
                  </span>
                  <span className="text-xs text-zinc-500 font-mono">+91 98450 12890</span>
                </div>
                <div className="flex items-start gap-2 text-xs text-zinc-600">
                  <MapPin className="w-4 h-4 text-zinc-400 shrink-0 mt-0.5" />
                  <span>
                    Flat 402, Green Glen Heights, 14th Main, HSR Layout Sector 4, Bengaluru - 560102
                  </span>
                </div>
              </div>
            </div>

            {/* Assigned Rider & Fleet Telemetry */}
            <div className="space-y-3">
              <h4 className="text-xs font-bold uppercase tracking-wider text-zinc-400 font-mono">
                Fulfillment & Fleet
              </h4>
              <div className="p-4 rounded-xl bg-zinc-50 border border-zinc-200/70 space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Bike className="w-4 h-4 text-[#2d9d43]" />
                    <span className="font-bold text-xs text-zinc-950">
                      {order.riderName || 'Automatic dispatching closest electric rider...'}
                    </span>
                  </div>
                  <span className="text-[10px] font-bold bg-emerald-100 text-emerald-800 px-2 py-0.5 rounded font-mono">
                    Ather EV Fleet
                  </span>
                </div>
                <div className="text-xs text-zinc-500">
                  Origin Hub: <span className="font-bold text-zinc-800">{order.hub}</span>
                </div>
              </div>
            </div>

            {/* Items in Basket */}
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <h4 className="text-xs font-bold uppercase tracking-wider text-zinc-400 font-mono">
                  Basket Items ({order.itemsCount})
                </h4>
                <span className="text-xs font-bold text-zinc-950">
                  Total: ₹{order.totalAmount}
                </span>
              </div>
              <div className="p-4 rounded-xl bg-zinc-50 border border-zinc-200/70 space-y-2 text-xs">
                <div className="text-zinc-700 leading-relaxed font-body">
                  {order.itemsPreview}
                </div>
              </div>
            </div>
          </div>

          {/* Drawer Actions Footer */}
          <div className="p-4 border-t border-zinc-200/80 bg-zinc-50/80 flex items-center gap-2.5">
            <Button
              variant="outline"
              size="sm"
              className="flex-1"
              leftIcon={<Printer className="w-4 h-4" />}
            >
              Print Ticket
            </Button>
            <Button
              variant="brand"
              size="sm"
              className="flex-1"
              onClick={onClose}
              leftIcon={<CheckCircle2 className="w-4 h-4 text-white" />}
            >
              Done
            </Button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
