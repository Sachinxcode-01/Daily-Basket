'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import {
  ArrowLeft,
  Plus,
  Image as ImageIcon,
  Edit2,
  Trash2,
  Eye,
  EyeOff,
  MoveUp,
  MoveDown,
  ExternalLink,
  CheckCircle2,
  Tag,
  Sparkles,
} from 'lucide-react';

interface BannerItem {
  id: string;
  title: string;
  subtitle?: string;
  imageUrl: string;
  linkUrl: string;
  position: number;
  isActive: boolean;
  startDate?: string;
  endDate?: string;
}

const INITIAL_BANNERS: BannerItem[] = [
  {
    id: 'ban_001',
    title: 'Morning Fresh Milk & Dairy Rush',
    subtitle: 'Daily farm fresh milk delivered before 7:00 AM',
    imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=1200&q=80',
    linkUrl: '/categories/milk',
    position: 0,
    isActive: true,
  },
  {
    id: 'ban_002',
    title: 'Farm Direct Crunchy Organic Vegetables',
    subtitle: 'Harvested at dawn, in your kitchen in 10 minutes',
    imageUrl: 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=1200&q=80',
    linkUrl: '/categories/fresh-vegetables',
    position: 1,
    isActive: true,
  },
  {
    id: 'ban_003',
    title: 'Super Weekend Kirana Pantry Saver',
    subtitle: 'Up to 35% OFF on Atta, Dal, Oils & Grains',
    imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200&q=80',
    linkUrl: '/offers',
    position: 2,
    isActive: true,
  },
];

export default function BannerManagementPage() {
  const [banners, setBanners] = useState<BannerItem[]>(INITIAL_BANNERS);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingBanner, setEditingBanner] = useState<BannerItem | null>(null);

  // Form states
  const [title, setTitle] = useState('');
  const [subtitle, setSubtitle] = useState('');
  const [imageUrl, setImageUrl] = useState('');
  const [linkUrl, setLinkUrl] = useState('/');
  const [isActive, setIsActive] = useState(true);

  const openCreateModal = () => {
    setEditingBanner(null);
    setTitle('');
    setSubtitle('');
    setImageUrl('https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200&q=80');
    setLinkUrl('/offers');
    setIsActive(true);
    setIsModalOpen(true);
  };

  const openEditModal = (b: BannerItem) => {
    setEditingBanner(b);
    setTitle(b.title);
    setSubtitle(b.subtitle || '');
    setImageUrl(b.imageUrl);
    setLinkUrl(b.linkUrl);
    setIsActive(b.isActive);
    setIsModalOpen(true);
  };

  const handleSaveBanner = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !imageUrl.trim()) return;

    if (editingBanner) {
      setBanners((prev) =>
        prev.map((b) =>
          b.id === editingBanner.id
            ? { ...b, title, subtitle, imageUrl, linkUrl, isActive }
            : b,
        ),
      );
    } else {
      const newBanner: BannerItem = {
        id: `ban_${Date.now()}`,
        title,
        subtitle,
        imageUrl,
        linkUrl,
        position: banners.length,
        isActive,
      };
      setBanners((prev) => [...prev, newBanner]);
    }
    setIsModalOpen(false);
  };

  const toggleBannerStatus = (id: string) => {
    setBanners((prev) =>
      prev.map((b) => (b.id === id ? { ...b, isActive: !b.isActive } : b)),
    );
  };

  const deleteBanner = (id: string) => {
    if (confirm('Are you sure you want to delete this promotional banner?')) {
      setBanners((prev) => prev.filter((b) => b.id !== id));
    }
  };

  const movePosition = (index: number, direction: 'UP' | 'DOWN') => {
    const targetIndex = direction === 'UP' ? index - 1 : index + 1;
    if (targetIndex < 0 || targetIndex >= banners.length) return;

    setBanners((prev) => {
      const copy = [...prev];
      const temp = copy[index];
      copy[index] = copy[targetIndex];
      copy[targetIndex] = temp;
      return copy.map((item, idx) => ({ ...item, position: idx }));
    });
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans p-4 sm:p-6 pb-24">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e2e5] shadow-xs">
        <div className="flex items-center gap-3">
          <Link
            href="/marketing"
            className="p-2 rounded-xl hover:bg-slate-100 transition text-[#006b23]"
          >
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <div>
            <h1 className="text-xl sm:text-2xl font-extrabold text-[#191c1e] tracking-tight">
              Promotional Banner Carousel Management
            </h1>
            <p className="text-xs text-[#64748b] mt-0.5">
              Control hero banner carousels, offer linking, and sort positions for customer website & mobile apps.
            </p>
          </div>
        </div>

        <button
          onClick={openCreateModal}
          className="inline-flex items-center gap-2 px-4 py-2.5 bg-[#006b23] hover:bg-[#078730] text-white text-xs font-bold rounded-xl transition shadow-xs active:scale-95"
        >
          <Plus className="w-4 h-4" />
          <span>Add New Banner</span>
        </button>
      </div>

      {/* Banner Cards List */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {banners.map((b, index) => (
          <div
            key={b.id}
            className={`bg-white rounded-3xl overflow-hidden border transition shadow-xs flex flex-col justify-between ${
              b.isActive ? 'border-[#e2e2e5] hover:border-[#006b23]' : 'border-slate-200 opacity-60 bg-slate-50'
            }`}
          >
            <div>
              {/* Banner Image Preview */}
              <div className="relative aspect-[16/9] w-full bg-slate-100 overflow-hidden">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={b.imageUrl}
                  alt={b.title}
                  className="w-full h-full object-cover"
                />
                <span
                  className={`absolute top-3 left-3 text-[10px] font-extrabold px-2.5 py-1 rounded-full shadow-xs ${
                    b.isActive
                      ? 'bg-emerald-600 text-white'
                      : 'bg-slate-700 text-white'
                  }`}
                >
                  {b.isActive ? 'ACTIVE • ON DISPLAY' : 'DISABLED'}
                </span>

                <span className="absolute top-3 right-3 bg-black/60 backdrop-blur-xs text-white text-[10px] font-bold px-2 py-0.5 rounded-md">
                  Position #{index + 1}
                </span>
              </div>

              {/* Details */}
              <div className="p-4 space-y-2">
                <h3 className="text-sm font-extrabold text-[#191c1e] line-clamp-1">{b.title}</h3>
                {b.subtitle && (
                  <p className="text-xs text-[#64748b] line-clamp-2 leading-relaxed">{b.subtitle}</p>
                )}
                <div className="flex items-center gap-1.5 text-xs text-[#006b23] font-bold pt-1">
                  <ExternalLink className="w-3.5 h-3.5" />
                  <span className="truncate">Links to: {b.linkUrl}</span>
                </div>
              </div>
            </div>

            {/* Actions Toolbar */}
            <div className="p-3 bg-slate-50 border-t border-[#f1f1f3] flex items-center justify-between text-xs">
              {/* Position Ordering */}
              <div className="flex items-center gap-1">
                <button
                  onClick={() => movePosition(index, 'UP')}
                  disabled={index === 0}
                  className="p-1.5 rounded-lg border border-slate-200 hover:bg-white text-slate-600 disabled:opacity-30"
                  title="Move banner earlier"
                >
                  <MoveUp className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => movePosition(index, 'DOWN')}
                  disabled={index === banners.length - 1}
                  className="p-1.5 rounded-lg border border-slate-200 hover:bg-white text-slate-600 disabled:opacity-30"
                  title="Move banner later"
                >
                  <MoveDown className="w-3.5 h-3.5" />
                </button>
              </div>

              {/* Status Toggle & Edit/Delete */}
              <div className="flex items-center gap-2">
                <button
                  onClick={() => toggleBannerStatus(b.id)}
                  className={`p-1.5 rounded-lg border transition ${
                    b.isActive
                      ? 'border-emerald-200 bg-emerald-50 text-emerald-700 hover:bg-emerald-100'
                      : 'border-slate-300 bg-slate-200 text-slate-600'
                  }`}
                  title={b.isActive ? 'Disable Banner' : 'Activate Banner'}
                >
                  {b.isActive ? <Eye className="w-3.5 h-3.5" /> : <EyeOff className="w-3.5 h-3.5" />}
                </button>

                <button
                  onClick={() => openEditModal(b)}
                  className="p-1.5 rounded-lg border border-slate-200 hover:bg-white text-slate-700 transition"
                  title="Edit Banner"
                >
                  <Edit2 className="w-3.5 h-3.5" />
                </button>

                <button
                  onClick={() => deleteBanner(b.id)}
                  className="p-1.5 rounded-lg border border-rose-200 hover:bg-rose-50 text-rose-600 transition"
                  title="Delete Banner"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Create / Edit Modal */}
      {isModalOpen && (
        <div
          role="dialog"
          aria-modal="true"
          className="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 animate-[fadeIn_0.15s_ease-out]"
          onClick={() => setIsModalOpen(false)}
        >
          <div
            className="bg-white rounded-3xl p-6 max-w-lg w-full shadow-2xl space-y-4"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <h3 className="text-base font-extrabold text-[#191c1e]">
                {editingBanner ? 'Edit Promotional Banner' : 'Create Promotional Banner'}
              </h3>
              <button
                onClick={() => setIsModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 text-sm font-bold"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleSaveBanner} className="space-y-4">
              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wider">
                  Banner Headline *
                </label>
                <input
                  type="text"
                  required
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  placeholder="e.g. 50% OFF Fresh Alphonso Mangoes"
                  className="w-full bg-[#f9f9fc] border border-slate-200 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none focus:border-[#006b23]"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wider">
                  Subtext / Offer Details
                </label>
                <input
                  type="text"
                  value={subtitle}
                  onChange={(e) => setSubtitle(e.target.value)}
                  placeholder="e.g. Valid until stocks last. Free Express delivery."
                  className="w-full bg-[#f9f9fc] border border-slate-200 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none focus:border-[#006b23]"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wider">
                  Banner Image URL *
                </label>
                <input
                  type="url"
                  required
                  value={imageUrl}
                  onChange={(e) => setImageUrl(e.target.value)}
                  placeholder="https://images.unsplash.com/..."
                  className="w-full bg-[#f9f9fc] border border-slate-200 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none focus:border-[#006b23]"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wider">
                  Target Route / Offer Link
                </label>
                <input
                  type="text"
                  required
                  value={linkUrl}
                  onChange={(e) => setLinkUrl(e.target.value)}
                  placeholder="/categories/fresh-vegetables or /offers"
                  className="w-full bg-[#f9f9fc] border border-slate-200 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none focus:border-[#006b23]"
                />
              </div>

              <div className="flex items-center gap-2 pt-1">
                <input
                  type="checkbox"
                  id="isActiveToggle"
                  checked={isActive}
                  onChange={(e) => setIsActive(e.target.checked)}
                  className="w-4 h-4 text-[#006b23] rounded accent-[#006b23]"
                />
                <label htmlFor="isActiveToggle" className="text-xs font-bold text-slate-700 cursor-pointer">
                  Activate and display immediately in customer app carousel
                </label>
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-[#006b23] hover:bg-[#078730] text-white text-xs font-bold rounded-xl shadow-xs transition"
                >
                  {editingBanner ? 'Save Changes' : 'Create Banner'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
