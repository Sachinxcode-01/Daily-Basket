'use client';

import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Search,
  LayoutDashboard,
  ShoppingCart,
  Zap,
  Package,
  Bike,
  TrendingUp,
  Store,
  Users,
  Settings,
  Bot,
  Plus,
  RefreshCw,
  X,
  ArrowRight,
  ShieldAlert,
} from 'lucide-react';

interface CommandItem {
  id: string;
  category: 'Navigation' | 'Actions' | 'Hubs' | 'Quick Tools';
  title: string;
  subtitle?: string;
  icon: any;
  action: () => void;
  badge?: string;
}

export default function CommandPalette({
  isOpen,
  onClose,
}: {
  isOpen: boolean;
  onClose: () => void;
}) {
  const router = useRouter();
  const [query, setQuery] = useState('');
  const [selectedIndex, setSelectedIndex] = useState(0);

  const commandItems: CommandItem[] = [
    // Navigation
    {
      id: 'nav-overview',
      category: 'Navigation',
      title: 'Dark Store Overview',
      subtitle: 'Real-time 10-minute SLA metrics, GMV, and live orders',
      icon: LayoutDashboard,
      action: () => {
        router.push('/');
        onClose();
      },
      badge: 'Main',
    },
    {
      id: 'nav-orders',
      category: 'Navigation',
      title: 'Order Dispatch Pipeline',
      subtitle: 'Kanban view of active picks, packing, and EV transit',
      icon: ShoppingCart,
      action: () => {
        router.push('/orders');
        onClose();
      },
      badge: 'Live',
    },
    {
      id: 'nav-pricing',
      category: 'Navigation',
      title: '60s Mandi Price Editor',
      subtitle: 'Sync farm-gate vegetable and fruit rates',
      icon: Zap,
      action: () => {
        router.push('/products/daily-pricing');
        onClose();
      },
      badge: 'Fast',
    },
    {
      id: 'nav-inventory',
      category: 'Navigation',
      title: 'Inventory & Batch Expiries',
      subtitle: 'Manage SKUs, reorders, and perishables freshness',
      icon: Package,
      action: () => {
        router.push('/inventory');
        onClose();
      },
    },
    {
      id: 'nav-riders',
      category: 'Navigation',
      title: 'Rider Fleet & EV Telemetry',
      subtitle: 'Live GPS dispatch map, battery levels, and leaderboards',
      icon: Bike,
      action: () => {
        router.push('/riders');
        onClose();
      },
    },
    {
      id: 'nav-copilot',
      category: 'Navigation',
      title: 'AI Business Copilot',
      subtitle: 'Ask Gemini for demand forecasts and margin leaks',
      icon: Bot,
      action: () => {
        router.push('/copilot');
        onClose();
      },
      badge: 'AI',
    },
    {
      id: 'nav-users',
      category: 'Navigation',
      title: 'Staff & Team Access Management',
      subtitle: 'Manage RBAC permissions, store manager assignments, and 2FA',
      icon: Users,
      action: () => {
        router.push('/users');
        onClose();
      },
      badge: 'Team',
    },
    {
      id: 'nav-customers',
      category: 'Navigation',
      title: 'Customer Directory & 360° CRM',
      subtitle: 'View lifetime value, loyalty scores, and customer order history',
      icon: Users,
      action: () => {
        router.push('/customers');
        onClose();
      },
      badge: 'CRM',
    },
    {
      id: 'nav-executive',
      category: 'Navigation',
      title: 'Executive Analytics Deck',
      subtitle: 'High-level financial GMV, unit economics, and margins',
      icon: TrendingUp,
      action: () => {
        router.push('/executive-analytics');
        onClose();
      },
    },

    // Actions
    {
      id: 'act-new-product',
      category: 'Actions',
      title: 'Add New Catalog Product',
      subtitle: 'Create a new farm or grocery SKU with image & pricing',
      icon: Plus,
      action: () => {
        router.push('/products/editor');
        onClose();
      },
    },
    {
      id: 'act-sync-mandi',
      category: 'Actions',
      title: 'Trigger 60s Mandi Rate Re-fetch',
      subtitle: 'Pull latest wholesale arrivals from APMC Bangalore',
      icon: RefreshCw,
      action: () => {
        router.push('/products/daily-pricing');
        onClose();
      },
    },

    // Hubs
    {
      id: 'hub-krm',
      category: 'Hubs',
      title: 'Koramangala Mega Dark Store #01',
      subtitle: 'Switch control deck to BLR-KRM-01 (44 active riders)',
      icon: Store,
      action: () => {
        onClose();
      },
      badge: 'Active',
    },
    {
      id: 'hub-ind',
      category: 'Hubs',
      title: 'Indiranagar Urban Hub #04',
      subtitle: 'Switch control deck to BLR-IND-04 (32 active riders)',
      icon: Store,
      action: () => {
        onClose();
      },
    },
  ];

  const filteredItems = commandItems.filter((item) => {
    const q = query.toLowerCase();
    return (
      item.title.toLowerCase().includes(q) ||
      (item.subtitle && item.subtitle.toLowerCase().includes(q)) ||
      item.category.toLowerCase().includes(q)
    );
  });

  // Keyboard navigation
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        if (isOpen) onClose();
        else onClose(); // parent handles toggling
      } else if (e.key === 'Escape') {
        onClose();
      } else if (e.key === 'ArrowDown') {
        e.preventDefault();
        setSelectedIndex((prev) => (prev + 1) % (filteredItems.length || 1));
      } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        setSelectedIndex((prev) =>
          prev === 0 ? (filteredItems.length - 1 < 0 ? 0 : filteredItems.length - 1) : prev - 1
        );
      } else if (e.key === 'Enter') {
        e.preventDefault();
        if (filteredItems[selectedIndex]) {
          filteredItems[selectedIndex].action();
        }
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose, filteredItems, selectedIndex]);

  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 overflow-y-auto p-4 sm:p-6 md:p-20 flex justify-center items-start">
        {/* Backdrop */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
          className="fixed inset-0 bg-black/50 backdrop-blur-sm transition-opacity"
        />

        {/* Modal Window */}
        <motion.div
          initial={{ opacity: 0, scale: 0.96, y: -15 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.96, y: -15 }}
          transition={{ duration: 0.2, ease: [0.16, 1, 0.3, 1] }}
          className="relative w-full max-w-2xl bg-white rounded-2xl shadow-2xl border border-zinc-200 overflow-hidden z-10"
        >
          {/* Search Input Bar */}
          <div className="flex items-center px-4 border-b border-zinc-200/80 bg-zinc-50/50">
            <Search className="w-5 h-5 text-zinc-400 shrink-0 mr-3" />
            <input
              type="text"
              autoFocus
              value={query}
              onChange={(e) => {
                setQuery(e.target.value);
                setSelectedIndex(0);
              }}
              placeholder="Type a command, page, dark store, or SKU... (Esc to exit)"
              className="w-full py-4 bg-transparent text-sm font-medium text-zinc-900 placeholder-zinc-400 focus:outline-none"
            />
            <button
              onClick={onClose}
              className="p-1.5 text-zinc-400 hover:text-zinc-600 rounded-lg hover:bg-zinc-200/60"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Results List */}
          <div className="max-h-[380px] overflow-y-auto p-2 space-y-1">
            {filteredItems.length === 0 ? (
              <div className="p-8 text-center text-xs text-zinc-400">
                No matching operational command found for &quot;{query}&quot;
              </div>
            ) : (
              filteredItems.map((item, index) => {
                const isSelected = index === selectedIndex;
                const Icon = item.icon;
                return (
                  <div
                    key={item.id}
                    onClick={item.action}
                    onMouseEnter={() => setSelectedIndex(index)}
                    className={`flex items-center justify-between p-3 rounded-xl cursor-pointer transition-all ${
                      isSelected
                        ? 'bg-[#2d9d43] text-white shadow-sm'
                        : 'text-zinc-700 hover:bg-zinc-100/80'
                    }`}
                  >
                    <div className="flex items-center gap-3 min-w-0">
                      <div
                        className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 ${
                          isSelected
                            ? 'bg-white/20 text-white'
                            : 'bg-zinc-100 text-zinc-700'
                        }`}
                      >
                        <Icon className="w-4 h-4" />
                      </div>
                      <div className="min-w-0">
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-xs truncate">
                            {item.title}
                          </span>
                          {item.badge && (
                            <span
                              className={`text-[9px] font-bold font-mono px-1.5 py-0.5 rounded ${
                                isSelected
                                  ? 'bg-white/25 text-white'
                                  : 'bg-emerald-100 text-[#078730]'
                              }`}
                            >
                              {item.badge}
                            </span>
                          )}
                        </div>
                        {item.subtitle && (
                          <p
                            className={`text-[11px] truncate ${
                              isSelected ? 'text-emerald-100' : 'text-zinc-400'
                            }`}
                          >
                            {item.subtitle}
                          </p>
                        )}
                      </div>
                    </div>

                    <ArrowRight
                      className={`w-3.5 h-3.5 shrink-0 transition-transform ${
                        isSelected ? 'translate-x-0.5 text-white' : 'text-zinc-300'
                      }`}
                    />
                  </div>
                );
              })
            )}
          </div>

          {/* Footer Shortcuts */}
          <div className="p-3 bg-zinc-50 border-t border-zinc-200/80 flex items-center justify-between text-[11px] text-zinc-400 font-mono">
            <div className="flex items-center gap-3">
              <span>
                <kbd className="px-1.5 py-0.5 rounded bg-white border border-zinc-300 shadow-2xs">
                  ↑
                </kbd>{' '}
                <kbd className="px-1.5 py-0.5 rounded bg-white border border-zinc-300 shadow-2xs">
                  ↓
                </kbd>{' '}
                to navigate
              </span>
              <span>
                <kbd className="px-1.5 py-0.5 rounded bg-white border border-zinc-300 shadow-2xs">
                  ↵
                </kbd>{' '}
                to select
              </span>
            </div>
            <span>Daily Basket Quick-Commerce OS</span>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
