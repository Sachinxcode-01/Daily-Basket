/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState, useMemo } from 'react';
import Link from 'next/link';
import { useQuery } from '@tanstack/react-query';
import {
  ArrowLeft, Search, Heart, Share2, ChevronDown, Sparkles, Send, Leaf,
  Star, Clock, Minus, Plus, Loader2, ShieldCheck, Bell, AlertTriangle,
  PackageCheck, CheckCircle2, Layers,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../../../store/useCart';
import {
  getProductById,
  normalizeImagePath,
  getProductBundle,
  getProductSubstitutes,
} from '../../../lib/catalog';

const PLACEHOLDER = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80';

interface ChefMsg { role: 'user' | 'ai'; text: string; }

export default function ProductDetailsPage({ params }: { params: { id?: string } }) {
  const productId = params.id ?? '';
  const { addItem } = useCart();

  const [selectedVariantId, setSelectedVariantId] = useState<string | null>(null);
  const [quantity, setQuantity] = useState(1);
  const [activeThumb, setActiveThumb] = useState(0);
  const [isFavorited, setIsFavorited] = useState(false);
  const [detailsOpen, setDetailsOpen] = useState(true);
  const [nutritionOpen, setNutritionOpen] = useState(false);
  const [added, setAdded] = useState(false);
  const [bundleAdded, setBundleAdded] = useState(false);
  const [notifyMeSet, setNotifyMeSet] = useState(false);
  const [substituteAddedId, setSubstituteAddedId] = useState<string | null>(null);

  // AI Chef conversation state
  const [chefLog, setChefLog] = useState<ChefMsg[]>([]);
  const [chefInput, setChefInput] = useState('');
  const [chefLoading, setChefLoading] = useState(false);

  const fallbackProduct = useMemo(() => getProductById(productId), [productId]);

  const { data: product, isLoading, isError, refetch } = useQuery({
    queryKey: ['product', productId],
    queryFn: () => apiClient.getProductDetails(productId),
    enabled: Boolean(productId),
  });

  const p: any = product || fallbackProduct;

  const { data: insight } = useQuery({
    queryKey: ['product-insight', productId],
    queryFn: () => apiClient.getProductInsight(productId),
    enabled: Boolean(productId && p),
  });

  const images: string[] = useMemo(() => {
    if (Array.isArray(p?.images) && p.images.length > 0) {
      return p.images.map((img: string) => normalizeImagePath(img));
    }
    if (p?.image) {
      return [normalizeImagePath(p.image)];
    }
    return [PLACEHOLDER];
  }, [p]);

  const variants: any[] = useMemo(() => {
    if (Array.isArray(p?.variants) && p.variants.length > 0) {
      return p.variants;
    }
    if (fallbackProduct) {
      return [
        {
          id: fallbackProduct.variantId,
          sku: `SKU-${fallbackProduct.id.toUpperCase()}`,
          unitName: fallbackProduct.unitName,
          price: fallbackProduct.price,
          mrp: fallbackProduct.mrp,
          isAvailable: fallbackProduct.inStock,
        },
      ];
    }
    return [];
  }, [p, fallbackProduct]);
  const selectedVariant = useMemo(
    () => variants.find((v) => v.id === selectedVariantId) ?? variants.find((v) => v.isAvailable) ?? variants[0] ?? null,
    [variants, selectedVariantId],
  );
  const isAvailable = Boolean(selectedVariant ? selectedVariant.isAvailable !== false : p?.inStock !== false);
  const bundle = useMemo(() => getProductBundle(productId), [productId]);
  const substitutes = useMemo(() => getProductSubstitutes(productId), [productId]);
  const price = selectedVariant?.price ?? 0;
  const mrp = selectedVariant?.mrp ?? price;
  const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
  const reviewCount = Array.isArray(p?.reviews) ? p.reviews.length : 0;

  const askChef = async (question: string) => {
    const q = question.trim();
    if (!q || chefLoading) return;
    setChefInput('');
    setChefLog((prev) => [...prev, { role: 'user', text: q }]);
    setChefLoading(true);
    try {
      const res = await apiClient.aiChat(q, {
        productName: p?.name,
        brand: p?.brand,
        category: p?.category?.name,
      });
      setChefLog((prev) => [...prev, { role: 'ai', text: res?.content || 'Sorry, I could not generate a suggestion right now.' }]);
    } catch {
      setChefLog((prev) => [...prev, { role: 'ai', text: 'The AI Chef is unavailable right now. Please try again shortly.' }]);
    } finally {
      setChefLoading(false);
    }
  };

  if (isLoading && !fallbackProduct) {
    return (
      <div className="bg-[#f9f9fc] min-h-screen pt-20 max-w-5xl mx-auto md:grid md:grid-cols-2 md:gap-8 md:p-12 md:pt-24 animate-pulse">
        <div className="w-full aspect-square bg-[#eeeef0] md:rounded-2xl" />
        <div className="p-4 md:p-0 space-y-4">
          <div className="h-4 bg-[#eeeef0] rounded w-1/3" />
          <div className="h-8 bg-[#eeeef0] rounded w-2/3" />
          <div className="h-6 bg-[#eeeef0] rounded w-1/4" />
          <div className="h-24 bg-[#eeeef0] rounded" />
        </div>
      </div>
    );
  }

  if ((isError || !product) && !fallbackProduct) {
    return (
      <div className="bg-[#f9f9fc] min-h-screen flex flex-col items-center justify-center gap-4 text-center px-4">
        <div className="text-5xl">🛒</div>
        <h1 className="text-xl font-bold text-[#1a1c1e]">Product not found</h1>
        <p className="text-sm text-[#3f4a3d]">This product may be unavailable or the link is invalid.</p>
        <div className="flex gap-3">
          <button onClick={() => refetch()} className="bg-[#006b23] text-white text-sm font-bold px-5 py-2.5 rounded-xl hover:bg-[#078730]">Retry</button>
          <Link href="/" className="bg-[#eeeef0] text-[#1a1c1e] text-sm font-bold px-5 py-2.5 rounded-xl hover:bg-[#e2e2e5]">Back to Home</Link>
        </div>
      </div>
    );
  }

  const ins: any = (insight as any) || {};
  const nutrition: Record<string, string> = ins?.nutritionalSummary || {};
  const benefits: string[] = Array.isArray(ins?.benefits) ? ins.benefits : [];
  const bestFor: string[] = Array.isArray(ins?.bestFor) ? ins.bestFor : [];
  const chefChips = ['Recipe ideas', 'How should I store this?', 'What pairs well with this?', 'Is this a healthy choice?'];

  return (
    <div className="bg-[#f9f9fc] text-[#1a1c1e] font-sans antialiased min-h-screen pb-28 md:pb-16">
      {/* TopAppBar */}
      <header className="sticky top-0 w-full z-50 bg-[#f9f9fc]/90 backdrop-blur-xl shadow-sm flex items-center justify-between px-4 h-16">
        <Link href="/" className="text-[#006b23] p-2 -ml-2 rounded-full hover:bg-[#006b23]/10 transition-colors" aria-label="Back">
          <ArrowLeft className="w-6 h-6" />
        </Link>
        <div className="font-bold text-xl text-[#006b23]" style={{ fontFamily: 'Outfit' }}>Daily Basket</div>
        <Link href="/search" className="text-[#006b23] p-2 -mr-2 rounded-full hover:bg-[#006b23]/10 transition-colors" aria-label="Search">
          <Search className="w-6 h-6" />
        </Link>
      </header>

      <main className="max-w-5xl mx-auto px-4 pt-4 md:pt-8 md:grid md:grid-cols-2 md:gap-10 md:items-start">
        {/* Image Gallery */}
        <section className="md:sticky md:top-24">
          <div className="relative w-full aspect-square rounded-2xl overflow-hidden bg-[#f3f3f6] border border-[#e2e2e5]">
            <img
              src={images[activeThumb] ?? images[0]}
              alt={p.name}
              className="w-full h-full object-cover"
              onError={(e) => { (e.currentTarget as HTMLImageElement).src = PLACEHOLDER; }}
            />
            <div className="absolute top-3 right-3 flex flex-col gap-2">
              <button onClick={() => setIsFavorited(!isFavorited)} className="w-10 h-10 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow-sm hover:bg-white transition">
                <Heart className={`w-5 h-5 ${isFavorited ? 'fill-rose-500 text-rose-500' : 'text-[#1a1c1e]'}`} />
              </button>
              <button className="w-10 h-10 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow-sm hover:bg-white transition">
                <Share2 className="w-5 h-5 text-[#1a1c1e]" />
              </button>
            </div>
            {p.isOrganic && (
              <div className="absolute top-3 left-3 bg-[#078730] text-white px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1 shadow-sm">
                <Leaf className="w-3.5 h-3.5" /> Certified Organic
              </div>
            )}
          </div>

          {images.length > 1 && (
            <div className="flex gap-3 mt-3 overflow-x-auto pb-1">
              {images.map((img, index) => (
                <button
                  key={index}
                  onClick={() => setActiveThumb(index)}
                  className={`w-16 h-16 rounded-xl overflow-hidden border-2 flex-shrink-0 transition ${activeThumb === index ? 'border-[#006b23]' : 'border-transparent opacity-70 hover:opacity-100'}`}
                >
                  <img src={img} alt={`Thumbnail ${index + 1}`} className="w-full h-full object-cover" onError={(e) => { (e.currentTarget as HTMLImageElement).src = PLACEHOLDER; }} />
                </button>
              ))}
            </div>
          )}
        </section>

        {/* Details */}
        <section className="mt-6 md:mt-0 flex flex-col gap-6">
          <div>
            {p.brand && <p className="text-[#006b23] text-sm font-semibold mb-1">{p.brand}</p>}
            <h1 className="text-2xl md:text-3xl font-bold text-[#1a1c1e] mb-2" style={{ fontFamily: 'Outfit' }}>{p.name}</h1>
            <div className="flex items-center gap-3 mb-3">
              {(reviewCount > 0 || typeof ins?.healthScore === 'number') && (
                <div className="flex items-center gap-1 text-sm">
                  <Star className="w-4 h-4 fill-amber-400 text-amber-400" />
                  <span className="font-bold text-[#1a1c1e]">{typeof ins?.healthScore === 'number' ? ins.healthScore.toFixed(1) : '—'}</span>
                  {reviewCount > 0 && <span className="text-[#3f4a3d]">({reviewCount} reviews)</span>}
                </div>
              )}
              {selectedVariant && <span className="text-xs text-[#3f4a3d]">{selectedVariant.unitName}</span>}
            </div>

            <div className="flex items-end gap-3 mb-2">
              <span className="text-3xl font-bold text-[#1a1c1e]" style={{ fontFamily: 'Outfit' }}>{formatCurrency(price * quantity)}</span>
              {mrp > price && (
                <>
                  <span className="text-[#3f4a3d] line-through text-lg mb-1">{formatCurrency(mrp * quantity)}</span>
                  <span className="bg-[#ffdad6] text-[#93000a] px-2 py-0.5 rounded-md text-xs font-bold mb-1.5">-{discount}%</span>
                </>
              )}
            </div>
            <p className="text-[#3f4a3d] text-sm flex items-center gap-1"><Clock className="w-4 h-4 text-[#006b23]" /> Delivery in <span className="font-semibold text-[#006b23]">10 mins</span></p>
          </div>

          {/* Variant Selection */}
          {variants.length > 0 && (
            <div className="border-t border-[#e2e2e5] pt-5">
              <h3 className="text-base font-semibold mb-3" style={{ fontFamily: 'Outfit' }}>Select Pack</h3>
              <div className="flex gap-3 flex-wrap">
                {variants.map((v) => {
                  const isSelected = selectedVariant?.id === v.id;
                  return (
                    <button
                      key={v.id}
                      disabled={!v.isAvailable}
                      onClick={() => setSelectedVariantId(v.id)}
                      className={`py-2.5 px-4 rounded-xl border-2 font-semibold flex flex-col items-center min-w-[92px] transition ${isSelected ? 'border-[#006b23] bg-[#006b23]/5 text-[#006b23]' : 'border-[#e2e2e5] text-[#3f4a3d] hover:bg-[#eeeef0]'} ${!v.isAvailable ? 'opacity-40 cursor-not-allowed' : ''}`}
                    >
                      <span className="text-base">{v.unitName}</span>
                      <span className="text-xs opacity-80">{formatCurrency(v.price)}</span>
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          {/* Highlights */}
          {(benefits.length > 0 || bestFor.length > 0) && (
            <div className="border-t border-[#e2e2e5] pt-5">
              <h3 className="text-base font-semibold mb-3 flex items-center gap-1.5" style={{ fontFamily: 'Outfit' }}>
                <ShieldCheck className="w-4 h-4 text-[#006b23]" /> Highlights
              </h3>
              <div className="flex flex-wrap gap-2">
                {benefits.map((b, i) => (
                  <span key={`b${i}`} className="text-xs font-medium bg-emerald-50 text-[#006b23] border border-emerald-100 px-3 py-1.5 rounded-full">{b}</span>
                ))}
                {bestFor.map((b, i) => (
                  <span key={`f${i}`} className="text-xs font-medium bg-slate-50 text-slate-600 border border-slate-100 px-3 py-1.5 rounded-full">{b}</span>
                ))}
              </div>
            </div>
          )}

          {/* Out of Stock Alert & Smart Substitutes Section (Feature 4) */}
          {!isAvailable && (
            <div className="border-2 border-amber-300 bg-amber-50/80 rounded-2xl p-5 shadow-sm">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-3">
                <div className="flex items-center gap-2.5 text-amber-900">
                  <div className="w-8 h-8 rounded-full bg-amber-200 text-amber-900 flex items-center justify-center flex-shrink-0">
                    <AlertTriangle className="w-4 h-4" />
                  </div>
                  <div>
                    <h3 className="font-bold text-sm" style={{ fontFamily: 'Outfit' }}>Currently Sold Out in your Dark Store</h3>
                    <p className="text-xs text-amber-700">Fresh morning restock scheduled. Set an alert or pick a substitute below.</p>
                  </div>
                </div>
                <button
                  onClick={() => setNotifyMeSet(!notifyMeSet)}
                  className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 border transition shadow-xs ${
                    notifyMeSet
                      ? 'bg-emerald-600 text-white border-emerald-600 shadow-emerald-600/20'
                      : 'bg-white text-amber-900 border-amber-300 hover:bg-amber-100'
                  }`}
                >
                  <Bell className="w-3.5 h-3.5" />
                  {notifyMeSet ? '✓ Alert Set' : 'Notify When Back'}
                </button>
              </div>

              {/* Recommended Substitutes */}
              {substitutes.length > 0 && (
                <div className="mt-4 pt-4 border-t border-amber-200/80">
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-xs font-extrabold uppercase tracking-wider text-[#006b23] flex items-center gap-1.5">
                      <Sparkles className="w-3.5 h-3.5" /> Direct Substitutes (In-Stock for 10-Min Delivery)
                    </span>
                    <span className="text-[11px] text-amber-800 font-semibold">{substitutes.length} choices available</span>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                    {substitutes.map((sub) => (
                      <div
                        key={sub.id}
                        className="bg-white border border-[#e2e2e5] hover:border-[#006b23] rounded-xl p-3 flex flex-col justify-between shadow-xs transition"
                      >
                        <div className="flex gap-2.5 items-start mb-2">
                          <img
                            src={sub.imageUrl}
                            alt={sub.name}
                            className="w-12 h-12 object-contain rounded-lg border border-[#eeeef0] bg-[#fafafa]"
                          />
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-1">
                              <span className="text-[10px] bg-emerald-100 text-[#006b23] font-extrabold px-1.5 py-0.5 rounded">
                                {sub.matchScore}% Match
                              </span>
                            </div>
                            <h4 className="text-xs font-bold text-[#1a1c1e] truncate mt-0.5" title={sub.name}>
                              {sub.name}
                            </h4>
                            <p className="text-[11px] text-[#3f4a3d]">{sub.unitName}</p>
                          </div>
                        </div>

                        <p className="text-[10px] text-[#3f4a3d] bg-slate-50 border border-slate-100 rounded-md p-1.5 line-clamp-1 mb-2">
                          💡 {sub.similarityReason}
                        </p>

                        <div className="flex items-center justify-between pt-2 border-t border-[#eeeef0]">
                          <div>
                            <span className="font-bold text-xs text-[#1a1c1e]">{formatCurrency(sub.price)}</span>
                            {sub.mrp > sub.price && (
                              <span className="text-[10px] text-[#3f4a3d] line-through ml-1">{formatCurrency(sub.mrp)}</span>
                            )}
                          </div>
                          <button
                            onClick={() => {
                              addItem.mutate({
                                variantId: sub.variantId || `var_${sub.id}`,
                                productName: sub.name,
                                unitName: sub.unitName,
                                price: sub.price,
                                quantity: 1,
                              });
                              setSubstituteAddedId(sub.id);
                              setTimeout(() => setSubstituteAddedId(null), 2500);
                            }}
                            className="bg-[#006b23] hover:bg-[#078730] text-white text-xs font-bold px-3 py-1.5 rounded-lg shadow-xs transition"
                          >
                            {substituteAddedId === sub.id ? '✓ Added' : '+ Add Substitute'}
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Frequently Bought Together & Smart Bundles (Feature 2) */}
          {bundle && bundle.items.length > 1 && (
            <div className="border border-emerald-300/80 bg-gradient-to-br from-emerald-50/70 to-teal-50/40 rounded-2xl p-5 shadow-sm">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3">
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded-full bg-[#006b23] text-white flex items-center justify-center flex-shrink-0 shadow-sm">
                    <Layers className="w-4 h-4" />
                  </div>
                  <div>
                    <h3 className="text-base font-bold text-[#1a1c1e]" style={{ fontFamily: 'Outfit' }}>
                      {bundle.title}
                    </h3>
                    <p className="text-xs text-[#3f4a3d]">{bundle.description}</p>
                  </div>
                </div>
                <span className="self-start sm:self-auto bg-[#006b23] text-white text-[11px] font-extrabold px-3 py-1 rounded-full shadow-xs">
                  {bundle.badge}
                </span>
              </div>

              {/* Products Row with + and = */}
              <div className="flex items-center gap-2 overflow-x-auto py-2 scrollbar-none">
                {bundle.items.map((item, idx) => (
                  <React.Fragment key={item.productId}>
                    {idx > 0 && <span className="text-[#006b23] font-extrabold text-xl px-1">+</span>}
                    <div className="bg-white border border-[#e2e2e5] rounded-xl p-3 flex flex-col items-center min-w-[110px] w-28 text-center shadow-xs">
                      <img
                        src={item.imageUrl}
                        alt={item.productName}
                        className="w-14 h-14 object-contain mb-1.5 rounded-lg"
                      />
                      <span className="text-xs font-bold text-[#1a1c1e] line-clamp-1" title={item.productName}>
                        {item.productName}
                      </span>
                      <span className="text-[10px] text-[#3f4a3d]">{item.unitName}</span>
                      <span className="text-xs font-extrabold text-[#006b23] mt-1">{formatCurrency(item.price)}</span>
                    </div>
                  </React.Fragment>
                ))}
              </div>

              {/* Price & Action */}
              <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 pt-3 border-t border-emerald-200/80 mt-2">
                <div>
                  <div className="flex items-baseline gap-2">
                    <span className="text-2xl font-bold text-[#1a1c1e]" style={{ fontFamily: 'Outfit' }}>
                      {formatCurrency(bundle.bundlePrice)}
                    </span>
                    <span className="text-sm text-[#3f4a3d] line-through">{formatCurrency(bundle.originalPrice)}</span>
                    <span className="text-xs font-extrabold text-[#006b23] bg-emerald-100 border border-emerald-200 px-2 py-0.5 rounded-md">
                      Save {formatCurrency(bundle.savings)} ({bundle.savingsPercent}%)
                    </span>
                  </div>
                  <p className="text-[11px] text-[#3f4a3d]">Combo discount applied on all {bundle.items.length} items</p>
                </div>

                <button
                  onClick={() => {
                    bundle.items.forEach((item) => {
                      addItem.mutate({
                        variantId: item.variantId || `var_${item.productId}`,
                        productName: item.productName,
                        unitName: item.unitName,
                        price: item.price,
                        quantity: 1,
                      });
                    });
                    setBundleAdded(true);
                    setTimeout(() => setBundleAdded(false), 2500);
                  }}
                  className="w-full sm:w-auto bg-[#006b23] hover:bg-[#078730] text-white font-bold text-xs md:text-sm px-6 py-3 rounded-xl shadow-md transition flex items-center justify-center gap-2 active:scale-95"
                >
                  {bundleAdded ? (
                    <>
                      <CheckCircle2 className="w-4 h-4 text-emerald-200" />
                      <span>✓ Bundle Added to Cart!</span>
                    </>
                  ) : (
                    <>
                      <PackageCheck className="w-4 h-4" />
                      <span>Add Combo ({bundle.items.length} items)</span>
                    </>
                  )}
                </button>
              </div>
            </div>
          )}

          {/* AI Chef (working) */}
          <div className="border-t border-[#e2e2e5] pt-5">
            <div className="bg-gradient-to-br from-[#dce5dd]/40 to-emerald-50 border border-[#dce5dd] rounded-2xl p-4">
              <div className="flex items-center gap-2 mb-2">
                <div className="w-9 h-9 rounded-full bg-[#006b23] text-white flex items-center justify-center flex-shrink-0">
                  <Sparkles className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-semibold text-[#1a1c1e]" style={{ fontFamily: 'Outfit' }}>Ask AI Chef</h3>
                  <p className="text-[11px] text-[#3f4a3d]">Recipes, pairings, storage & nutrition tips for {p.name}.</p>
                </div>
              </div>

              {/* Conversation */}
              {chefLog.length > 0 && (
                <div className="space-y-2 my-3 max-h-72 overflow-y-auto pr-1">
                  {chefLog.map((m, i) => (
                    <div key={i} className={`text-sm rounded-2xl px-3.5 py-2 whitespace-pre-wrap ${m.role === 'user' ? 'bg-[#006b23] text-white ml-8' : 'bg-white text-[#1a1c1e] border border-[#e2e2e5] mr-4'}`}>
                      {m.text}
                    </div>
                  ))}
                  {chefLoading && (
                    <div className="text-sm bg-white text-[#3f4a3d] border border-[#e2e2e5] rounded-2xl px-3.5 py-2 mr-4 flex items-center gap-2">
                      <Loader2 className="w-4 h-4 animate-spin text-[#006b23]" /> AI Chef is thinking…
                    </div>
                  )}
                </div>
              )}

              {/* Suggestion chips */}
              <div className="flex flex-wrap gap-2 mb-3">
                {chefChips.map((c) => (
                  <button key={c} onClick={() => askChef(`${c} for ${p.name}`)} disabled={chefLoading} className="text-xs bg-white px-3 py-1.5 rounded-full border border-[#e2e2e5] hover:border-[#006b23] disabled:opacity-50 transition">
                    {c}
                  </button>
                ))}
              </div>

              {/* Input */}
              <form onSubmit={(e) => { e.preventDefault(); askChef(chefInput); }} className="flex gap-2">
                <input
                  value={chefInput}
                  onChange={(e) => setChefInput(e.target.value)}
                  placeholder="Ask anything about this product…"
                  className="flex-1 text-sm bg-white border border-[#e2e2e5] rounded-full px-4 py-2.5 focus:outline-none focus:border-[#006b23]"
                />
                <button type="submit" disabled={chefLoading || !chefInput.trim()} className="w-11 h-11 rounded-full bg-[#006b23] text-white flex items-center justify-center disabled:opacity-50 hover:bg-[#078730] transition">
                  <Send className="w-5 h-5" />
                </button>
              </form>
            </div>
          </div>

          {/* Accordions */}
          <div className="flex flex-col gap-3">
            <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white">
              <button onClick={() => setDetailsOpen(!detailsOpen)} className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f3f3f6] transition">
                <span className="font-semibold" style={{ fontFamily: 'Outfit' }}>Product Details</span>
                <ChevronDown className={`w-5 h-5 transition-transform ${detailsOpen ? 'rotate-180' : ''}`} />
              </button>
              {detailsOpen && (
                <div className="p-4 pt-0 text-sm text-[#3f4a3d] leading-relaxed border-t border-[#e2e2e5] space-y-2">
                  <p>{p.description || 'No description available for this product.'}</p>
                  {ins?.usage && <p><span className="font-semibold text-[#1a1c1e]">Usage: </span>{ins.usage}</p>}
                  {ins?.storage && <p><span className="font-semibold text-[#1a1c1e]">Storage: </span>{ins.storage}</p>}
                  {ins?.servingSuggestions && <p><span className="font-semibold text-[#1a1c1e]">Serving: </span>{ins.servingSuggestions}</p>}
                </div>
              )}
            </div>

            {Object.keys(nutrition).length > 0 && (
              <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white">
                <button onClick={() => setNutritionOpen(!nutritionOpen)} className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f3f3f6] transition">
                  <span className="font-semibold" style={{ fontFamily: 'Outfit' }}>Nutritional Info</span>
                  <ChevronDown className={`w-5 h-5 transition-transform ${nutritionOpen ? 'rotate-180' : ''}`} />
                </button>
                {nutritionOpen && (
                  <ul className="p-4 pt-0 border-t border-[#e2e2e5] text-sm">
                    {Object.entries(nutrition).map(([k, v]) => (
                      <li key={k} className="flex justify-between border-b border-[#e2e2e5]/50 py-1.5 last:border-0">
                        <span className="text-[#3f4a3d] capitalize">{k}</span>
                        <span className="font-medium text-[#1a1c1e]">{String(v)}</span>
                      </li>
                    ))}
                  </ul>
                )}
              </div>
            )}
          </div>
        </section>
      </main>

      {/* Bottom Action Bar */}
      <div className="fixed bottom-0 left-0 w-full bg-white border-t border-[#e2e2e5] p-4 z-40">
        <div className="max-w-5xl mx-auto flex gap-4 items-center">
          {isAvailable ? (
            <>
              <div className="flex items-center justify-between bg-[#eeeef0] rounded-xl px-1 h-14 w-32 border border-[#e2e2e5]">
                <button onClick={() => setQuantity(Math.max(1, quantity - 1))} className="w-10 h-10 flex items-center justify-center hover:bg-[#e2e2e5] rounded-lg transition"><Minus className="w-5 h-5" /></button>
                <span className="font-semibold text-lg w-8 text-center">{quantity}</span>
                <button onClick={() => setQuantity(quantity + 1)} className="w-10 h-10 flex items-center justify-center hover:bg-[#e2e2e5] rounded-lg transition"><Plus className="w-5 h-5" /></button>
              </div>
              <button
                disabled={!selectedVariant || addItem.isPending}
                onClick={() => {
                  if (!selectedVariant) return;
                  addItem.mutate(
                    { variantId: selectedVariant.id, productName: p.name, unitName: selectedVariant.unitName, price: selectedVariant.price, quantity },
                    { onSuccess: () => { setAdded(true); setTimeout(() => setAdded(false), 2000); } },
                  );
                }}
                className="flex-1 bg-[#006b23] hover:bg-[#078730] disabled:opacity-50 text-white font-semibold text-base md:text-lg rounded-xl h-14 flex items-center justify-center shadow-md active:scale-95 transition"
              >
                {addItem.isPending ? 'Adding…' : added ? '✓ Added to Cart' : `Add to Cart · ${formatCurrency(price * quantity)}`}
              </button>
            </>
          ) : (
            <div className="flex-1 flex gap-3 items-center">
              <div className="flex-1 bg-amber-100 text-amber-900 border border-amber-300 rounded-xl h-14 flex items-center justify-center font-bold text-sm px-4">
                Currently Out of Stock
              </div>
              <button
                onClick={() => setNotifyMeSet(!notifyMeSet)}
                className="bg-[#006b23] hover:bg-[#078730] text-white font-bold text-sm rounded-xl h-14 px-6 flex items-center justify-center gap-2 shadow-md transition"
              >
                <Bell className="w-4 h-4" />
                {notifyMeSet ? '✓ Alert Registered' : 'Notify When Back'}
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
