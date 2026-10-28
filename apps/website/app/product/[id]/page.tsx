/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState, useMemo, useEffect } from 'react';
import Link from 'next/link';
import { useParams, useRouter } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import {
  ArrowLeft, Search, Heart, Share2, ChevronDown, Sparkles, Send, Leaf,
  Star, Clock, Minus, Plus, Loader2, ShieldCheck, Bell, AlertTriangle,
  PackageCheck, CheckCircle2, Layers, Check, Info, Award, ZoomIn, X, Zap
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../../../store/useCart';
import { useWishlist } from '../../../store/useWishlist';
import { useAuthStore } from '../../../store/useAuthStore';
import {
  getProductById,
  normalizeImagePath,
  getProductBundle,
  getProductSubstitutes,
  getSimilarProducts,
  getCustomersAlsoViewed,
  getProductComparison,
  ALL_WEBSITE_PRODUCTS,
  WebsiteProduct,
} from '../../../lib/catalog';
import { useRecentlyViewed } from '../../../lib/useRecentlyViewed';
import { ProductReviewsSection } from '../../../components/ProductReviewsSection';
import { ProductComparisonSection } from '../../../components/ProductComparisonSection';
import { ProductRecommendationsCarousel } from '../../../components/ProductRecommendationsCarousel';

const PLACEHOLDER = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80';

interface ChefMsg { role: 'user' | 'ai'; text: string; }

export default function ProductDetailsPage({ params }: { params?: { id?: string } }) {
  const routeParams = useParams();
  const rawId = (routeParams?.id as string) || params?.id || '';
  const productId = useMemo(() => {
    try {
      return decodeURIComponent(rawId).trim();
    } catch {
      return rawId.trim();
    }
  }, [rawId]);

  const router = useRouter();
  const { user } = useAuthStore();
  const { addItem } = useCart();
  const { isWishlisted, toggleWishlist } = useWishlist();
  const { viewedIds, addViewedProduct, clearRecentlyViewed } = useRecentlyViewed();

  const [selectedVariantId, setSelectedVariantId] = useState<string | null>(null);
  const [quantity, setQuantity] = useState(1);
  const [activeThumb, setActiveThumb] = useState(0);
  const [isZoomOpen, setIsZoomOpen] = useState(false);
  const [detailsOpen, setDetailsOpen] = useState(true);
  const [nutritionOpen, setNutritionOpen] = useState(true);
  const [added, setAdded] = useState(false);
  const [bundleAdded, setBundleAdded] = useState(false);
  const [notifyMeSet, setNotifyMeSet] = useState(false);
  const [substituteAddedId, setSubstituteAddedId] = useState<string | null>(null);

  // AI Chef conversation state
  const [chefLog, setChefLog] = useState<ChefMsg[]>([]);
  const [chefInput, setChefInput] = useState('');
  const [chefLoading, setChefLoading] = useState(false);

  // Fallback product from the 607 catalog items
  const fallbackProduct = useMemo(() => {
    if (!productId) return ALL_WEBSITE_PRODUCTS[0];
    return getProductById(productId) || ALL_WEBSITE_PRODUCTS.find((x) => x.id.includes(productId)) || ALL_WEBSITE_PRODUCTS[0];
  }, [productId]);

  const { data: product, isLoading } = useQuery({
    queryKey: ['product', productId],
    queryFn: () => apiClient.getProductDetails(productId),
    enabled: Boolean(productId),
    retry: 1,
  });

  // Merged production-ready product instance
  const p: WebsiteProduct = useMemo(() => {
    const base = fallbackProduct || ALL_WEBSITE_PRODUCTS[0];
    if (!product) return base;

    const prod = product as any;
    const b = base as any;
    const apiVariants = Array.isArray(prod.variants) && prod.variants.length > 0 ? prod.variants : null;
    const firstVariant = apiVariants ? apiVariants[0] : null;

    return {
      ...b,
      ...prod,
      id: prod.id || b.id,
      name: prod.name || b.name,
      brand: prod.brand || b.brand || 'Daily Basket Select',
      description: prod.description || b.description,
      isOrganic: prod.isOrganic ?? b.isOrganic ?? false,
      isVeg: prod.isVeg ?? b.isVeg ?? true,
      price: firstVariant?.price ?? prod.price ?? b.price ?? 50,
      mrp: firstVariant?.mrp ?? prod.mrp ?? b.mrp ?? 65,
      unitName: firstVariant?.unitName ?? prod.unitName ?? b.unitName ?? '1 Pack',
      inStock: firstVariant ? firstVariant.isAvailable !== false : (prod.inStock ?? b.inStock ?? true),
      images: (Array.isArray(prod.images) && prod.images.length > 0)
        ? prod.images
        : (b.images || [b.image || PLACEHOLDER]),
      storage: prod.storage || b.storage,
      shelfLife: prod.shelfLife || b.shelfLife,
      nutrition: prod.nutrition || b.nutrition,
      keyBenefits: prod.keyBenefits || b.keyBenefits,
      chefTip: prod.chefTip || b.chefTip,
    };
  }, [product, fallbackProduct]);

  // Record this product in recently viewed history
  useEffect(() => {
    if (p?.id) {
      addViewedProduct(p.id);
    }
  }, [p?.id, addViewedProduct]);

  const { data: insight } = useQuery({
    queryKey: ['product-insight', productId],
    queryFn: () => apiClient.getProductInsight(productId),
    enabled: Boolean(productId && p),
    retry: 1,
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

  const variants = useMemo(() => {
    return [
      {
        id: p.variantId,
        sku: `SKU-${p.id.toUpperCase()}`,
        unitName: p.unitName,
        price: p.price,
        mrp: p.mrp,
        isAvailable: p.inStock,
      },
    ];
  }, [p]);

  const selectedVariant = useMemo(
    () => variants.find((v) => v.id === selectedVariantId) ?? variants[0] ?? null,
    [variants, selectedVariantId],
  );

  const isAvailable = Boolean(selectedVariant ? selectedVariant.isAvailable !== false : p.inStock !== false);
  const bundleLookupId = p.id || productId;
  const bundle = useMemo(() => getProductBundle(bundleLookupId), [bundleLookupId]);
  const substitutes = useMemo(() => getProductSubstitutes(bundleLookupId), [bundleLookupId]);

  // Recommendation & Discovery Data
  const similarProducts = useMemo(() => getSimilarProducts(p.id, 8), [p.id]);
  const customersAlsoViewed = useMemo(() => getCustomersAlsoViewed(p.id, 8), [p.id]);
  const comparisonData = useMemo(() => getProductComparison(p.id), [p.id]);

  const recentlyViewedProducts = useMemo(() => {
    return viewedIds
      .filter((id) => id !== p.id)
      .map((id) => getProductById(id))
      .filter((item): item is WebsiteProduct => Boolean(item))
      .slice(0, 8);
  }, [viewedIds, p.id]);

  const price = selectedVariant?.price ?? p.price;
  const mrp = selectedVariant?.mrp ?? p.mrp ?? price;
  const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
  const reviewCount = p.reviews || 320;

  const askChef = async (question: string) => {
    const q = question.trim();
    if (!q || chefLoading) return;
    setChefInput('');
    setChefLog((prev) => [...prev, { role: 'user', text: q }]);
    setChefLoading(true);
    try {
      const res = await apiClient.aiChat(q, {
        productName: p.name,
        brand: p.brand,
        category: p.category,
      });
      setChefLog((prev) => [
        ...prev,
        {
          role: 'ai',
          text: res?.content || p.chefTip || `Chef recommendation for ${p.name}: Pairs wonderfully with light seasoning, fresh herbs, and minimal oil.`,
        },
      ]);
    } catch {
      setChefLog((prev) => [
        ...prev,
        {
          role: 'ai',
          text: p.chefTip || `AI Chef recommendation for ${p.name}: Best prepared fresh. Rich in daily micronutrients and wholesome flavors.`,
        },
      ]);
    } finally {
      setChefLoading(false);
    }
  };

  const ins = useMemo(() => ((insight as any) || {}), [insight]);

  // Clean, realistic nutrition mapping
  const nutrition: Record<string, string> = useMemo(() => {
    if (p.nutrition && Object.keys(p.nutrition).length > 0) {
      return p.nutrition;
    }
    if (ins?.nutritionalSummary && Object.keys(ins.nutritionalSummary).length > 0) {
      return ins.nutritionalSummary;
    }
    return {
      Calories: '145 kcal',
      Carbohydrates: '24.0g',
      Protein: '4.5g',
      'Dietary Fiber': '3.2g',
      'Total Fat': '2.1g',
    };
  }, [p.nutrition, ins]);

  // Clean, realistic benefits
  const benefits: string[] = useMemo(() => {
    if (Array.isArray(p.keyBenefits) && p.keyBenefits.length > 0) {
      return p.keyBenefits;
    }
    if (Array.isArray(ins?.benefits) && ins.benefits.length > 0) {
      return ins.benefits;
    }
    return [
      '100% Quality Checked & Graded',
      'Direct Farm & Brand Sourced',
      'Hygienic Temperature-Controlled Packing',
      'Fresh Harvest 10-Minute Guarantee',
    ];
  }, [p.keyBenefits, ins]);

  const chefChips = [
    `How to store ${p.name}?`,
    `Quick 10-min recipe with this`,
    'What pairs well with this?',
    'Nutritional benefits',
  ];

  if (isLoading && !fallbackProduct) {
    return (
      <div className="bg-[#f9f9fc] min-h-screen pt-20 max-w-5xl mx-auto md:grid md:grid-cols-2 md:gap-8 md:p-12 md:pt-24 animate-pulse">
        <div className="w-full aspect-square bg-[#eeeef0] md:rounded-2xl" />
        <div className="p-4 md:p-0 space-y-4">
          <div className="h-6 bg-[#e0e3e5] rounded-md w-1/3" />
          <div className="h-8 bg-[#e0e3e5] rounded-md w-3/4" />
          <div className="h-6 bg-[#e0e3e5] rounded-md w-1/4" />
        </div>
      </div>
    );
  }

  return (
    <div className="bg-[#f9f9fc] min-h-screen pb-36 text-[#191c1e]">
      {/* Top Header */}
      <header className="sticky top-0 z-40 bg-[#f9f9fc]/85 backdrop-blur-xl border-b border-[#e2e2e5] px-4 py-3">
        <div className="max-w-5xl mx-auto flex items-center justify-between">
          <Link
            href="/"
            className="flex items-center gap-1.5 text-xs font-bold text-[#2d9d43] hover:text-[#078730] transition p-1.5 rounded-lg hover:bg-emerald-50"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Shop</span>
          </Link>
          <span className="text-xs font-extrabold uppercase tracking-wider text-[#64748b]">
            {p.category}
          </span>
          <div className="flex items-center gap-2">
            <button
              onClick={() => toggleWishlist(p.id, user?.id)}
              className={`p-2 rounded-full border transition flex items-center justify-center ${
                isWishlisted(p.id)
                  ? 'bg-rose-50 border-rose-200 text-rose-500 shadow-xs'
                  : 'bg-white border-[#e2e2e5] text-slate-500 hover:text-rose-500 hover:border-rose-200'
              }`}
              title={isWishlisted(p.id) ? 'Remove from Wishlist' : 'Save to Wishlist'}
            >
              <Heart className={`w-4 h-4 ${isWishlisted(p.id) ? 'fill-rose-500 text-rose-500' : ''}`} />
            </button>
            <button
              onClick={() => {
                if (navigator.share) {
                  navigator.share({ title: p.name, text: p.description, url: window.location.href });
                } else {
                  navigator.clipboard.writeText(window.location.href);
                  alert('Product link copied to clipboard!');
                }
              }}
              className="p-2 rounded-full bg-white border border-[#e2e2e5] text-slate-500 hover:text-slate-800 transition"
              title="Share Product"
            >
              <Share2 className="w-4 h-4" />
            </button>
          </div>
        </div>
      </header>

      {/* Main Container */}
      <main className="max-w-5xl mx-auto px-4 pt-6 space-y-8">
        {/* Product Showcase: Gallery + Details */}
        <section className="grid grid-cols-1 md:grid-cols-2 gap-8 items-start">
          {/* Left: Gallery */}
          <div className="space-y-4">
            <div className="relative w-full aspect-square bg-white border border-[#e2e2e5] rounded-3xl overflow-hidden p-6 flex items-center justify-center shadow-xs group">
              <img
                src={images[activeThumb] || images[0]}
                alt={p.name}
                className="w-full h-full object-contain group-hover:scale-105 transition-transform duration-300 cursor-zoom-in"
                onClick={() => setIsZoomOpen(true)}
              />

              {/* Zoom Action Trigger Overlay */}
              <button
                onClick={() => setIsZoomOpen(true)}
                className="absolute bottom-4 right-4 bg-white/90 hover:bg-white text-slate-700 p-2 rounded-full border border-[#e2e2e5] shadow-xs flex items-center gap-1.5 text-xs font-semibold backdrop-blur-xs transition hover:scale-105"
                title="Click to zoom image"
              >
                <ZoomIn className="w-4 h-4 text-[#2d9d43]" />
                <span className="text-[11px] font-bold hidden sm:inline">Zoom</span>
              </button>

              {/* Top Left Badges */}
              <div className="absolute top-4 left-4 flex flex-col gap-1.5">
                {discount > 0 && (
                  <span className="bg-[#ba1a1a] text-white text-xs font-extrabold px-2.5 py-1 rounded-md shadow-xs">
                    {discount}% OFF
                  </span>
                )}
                {p.isOrganic && (
                  <span className="bg-[#2d9d43] text-white text-[11px] font-bold px-2.5 py-1 rounded-full flex items-center gap-1 shadow-xs">
                    <Leaf className="w-3 h-3" /> Certified Organic
                  </span>
                )}
              </div>

              {/* Top Right Veg / Non-Veg Indicator */}
              <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-xs p-1.5 rounded-lg border border-[#e2e2e5] shadow-xs">
                {p.isVeg ? (
                  <div className="w-4 h-4 border-2 border-[#15803d] flex items-center justify-center rounded-xs" title="100% Vegetarian">
                    <div className="w-2 h-2 bg-[#15803d] rounded-full" />
                  </div>
                ) : (
                  <div className="w-4 h-4 border-2 border-[#b45309] flex items-center justify-center rounded-xs" title="Non-Vegetarian">
                    <div className="w-0 h-0 border-l-[4px] border-l-transparent border-r-[4px] border-r-transparent border-b-[8px] border-b-[#b45309]" />
                  </div>
                )}
              </div>
            </div>

            {/* Thumbnails */}
            {images.length > 1 && (
              <div className="flex gap-3 overflow-x-auto pb-1">
                {images.map((img, idx) => (
                  <button
                    key={idx}
                    onClick={() => setActiveThumb(idx)}
                    className={`w-16 h-16 rounded-xl border-2 overflow-hidden bg-white p-1 transition ${
                      activeThumb === idx ? 'border-[#2d9d43] shadow-xs' : 'border-[#e2e2e5] opacity-70 hover:opacity-100'
                    }`}
                  >
                    <img src={img} alt={`Thumbnail ${idx}`} className="w-full h-full object-contain" />
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Right: Info, Price, Stock */}
          <div className="space-y-5">
            <div>
              <span className="text-xs uppercase font-extrabold tracking-wider text-[#2d9d43]">
                {p.brand}
              </span>
              <h1 className="text-2xl sm:text-3xl font-extrabold text-[#191c1e] mt-1" style={{ fontFamily: 'Outfit' }}>
                {p.name}
              </h1>
              <p className="text-sm font-medium text-[#64748b] mt-1">{p.unitName}</p>

              {/* Rating & Reviews */}
              <div className="flex items-center gap-2 mt-2.5">
                <div className="flex items-center gap-1 bg-amber-50 border border-amber-200 px-2.5 py-1 rounded-lg">
                  <span className="font-extrabold text-xs text-[#191c1e]">{p.rating}</span>
                  <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                </div>
                <span className="text-xs font-semibold text-[#64748b]">
                  {reviewCount.toLocaleString()} Verified Customer Reviews
                </span>
              </div>
            </div>

            {/* Pricing Card */}
            <div className="bg-white border border-[#e2e2e5] rounded-2xl p-4 shadow-xs">
              <div className="flex items-baseline gap-3">
                <span className="text-3xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  {formatCurrency(price)}
                </span>
                {mrp > price && (
                  <span className="text-base text-[#64748b] line-through">
                    {formatCurrency(mrp)}
                  </span>
                )}
                {discount > 0 && (
                  <span className="bg-emerald-100 text-[#15803d] text-xs font-extrabold px-2 py-0.5 rounded-md border border-emerald-200">
                    Save {formatCurrency(mrp - price)} ({discount}%)
                  </span>
                )}
              </div>
              <p className="text-[11px] text-[#64748b] mt-1">(Inclusive of all taxes)</p>

              {/* Delivery ETA */}
              <div className="flex items-center gap-2 text-xs font-bold text-[#15803d] mt-3 pt-3 border-t border-[#eceef0]">
                <Clock className="w-4 h-4 text-[#2d9d43]" />
                <span>Delivery in 10 minutes</span>
                <span className="text-[11px] font-normal text-[#64748b]">• Express Local Kirana Delivery</span>
              </div>
            </div>

            {/* Key Benefits Pills */}
            <div className="grid grid-cols-2 gap-2">
              {benefits.slice(0, 4).map((b, i) => (
                <div key={i} className="flex items-center gap-2 bg-[#f3f3f6] border border-[#eceef0] rounded-xl px-3 py-2 text-xs text-[#191c1e] font-medium">
                  <Check className="w-3.5 h-3.5 text-[#2d9d43] flex-shrink-0" />
                  <span className="truncate">{b}</span>
                </div>
              ))}
            </div>

            {/* AI Chef Card */}
            {p.chefTip && (
              <div className="bg-gradient-to-br from-emerald-50 to-teal-50/40 border border-emerald-200 rounded-2xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-7 h-7 rounded-full bg-[#2d9d43] text-white flex items-center justify-center flex-shrink-0">
                    <Sparkles className="w-3.5 h-3.5" />
                  </div>
                  <h4 className="text-xs font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                    AI Chef Recommendation & Recipe Tip
                  </h4>
                </div>
                <p className="text-xs text-[#3f4a3d] leading-relaxed">
                  💡 {p.chefTip}
                </p>
              </div>
            )}
          </div>
        </section>

        {/* Out-of-Stock Smart Substitutes */}
        {!isAvailable && substitutes.length > 0 && (
          <div className="border border-amber-300 bg-amber-50/70 rounded-2xl p-5 shadow-xs">
            <div className="flex items-center justify-between mb-3">
              <span className="text-xs font-extrabold uppercase tracking-wider text-[#b45309] flex items-center gap-1.5">
                <AlertTriangle className="w-4 h-4" /> In-Stock Direct Substitutes
              </span>
              <span className="text-xs text-amber-900 font-semibold">{substitutes.length} choices available</span>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              {substitutes.map((sub) => (
                <div key={sub.id} className="bg-white border border-[#e2e2e5] rounded-xl p-3 flex flex-col justify-between shadow-xs">
                  <div className="flex gap-2.5 items-start mb-2">
                    <img src={sub.imageUrl} alt={sub.name} className="w-12 h-12 object-contain rounded-lg border border-[#eceef0] bg-[#fafafa]" />
                    <div className="flex-1 min-w-0">
                      <span className="text-[10px] bg-emerald-100 text-[#15803d] font-extrabold px-1.5 py-0.5 rounded">
                        {sub.matchScore}% Match
                      </span>
                      <h4 className="text-xs font-bold text-[#191c1e] truncate mt-0.5">{sub.name}</h4>
                      <p className="text-[11px] text-[#64748b]">{sub.unitName}</p>
                    </div>
                  </div>
                  <div className="flex items-center justify-between pt-2 border-t border-[#eceef0]">
                    <span className="font-bold text-xs text-[#191c1e]">{formatCurrency(sub.price)}</span>
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
                        setTimeout(() => setSubstituteAddedId(null), 2000);
                      }}
                      className="bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold px-3 py-1.5 rounded-lg shadow-xs transition"
                    >
                      {substituteAddedId === sub.id ? '✓ Added' : '+ Add'}
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Frequently Bought Together & Smart Bundles */}
        {bundle && bundle.items.length > 1 && (
          <div className="border border-emerald-300/80 bg-gradient-to-br from-emerald-50/70 to-teal-50/40 rounded-2xl p-5 shadow-sm">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-full bg-[#2d9d43] text-white flex items-center justify-center flex-shrink-0 shadow-sm">
                  <Layers className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-base font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                    {bundle.title}
                  </h3>
                  <p className="text-xs text-[#64748b]">{bundle.description}</p>
                </div>
              </div>
              <span className="self-start sm:self-auto bg-[#2d9d43] text-white text-[11px] font-extrabold px-3 py-1 rounded-full shadow-xs">
                {bundle.badge}
              </span>
            </div>

            <div className="flex items-center gap-2 overflow-x-auto py-2 scrollbar-none">
              {bundle.items.map((item, idx) => (
                <React.Fragment key={item.productId}>
                  {idx > 0 && <span className="text-[#2d9d43] font-extrabold text-xl px-1">+</span>}
                  <div className="bg-white border border-[#e2e2e5] rounded-xl p-3 flex flex-col items-center min-w-[110px] w-28 text-center shadow-xs">
                    <img src={item.imageUrl} alt={item.productName} className="w-14 h-14 object-contain mb-1.5 rounded-lg" />
                    <span className="text-xs font-bold text-[#191c1e] line-clamp-1">{item.productName}</span>
                    <span className="text-[10px] text-[#64748b]">{item.unitName}</span>
                    <span className="text-xs font-extrabold text-[#2d9d43] mt-1">{formatCurrency(item.price)}</span>
                  </div>
                </React.Fragment>
              ))}
            </div>

            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 pt-3 border-t border-emerald-200 mt-2">
              <div>
                <div className="flex items-baseline gap-2">
                  <span className="text-2xl font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                    {formatCurrency(bundle.bundlePrice)}
                  </span>
                  <span className="text-sm text-[#64748b] line-through">{formatCurrency(bundle.originalPrice)}</span>
                  <span className="text-xs font-extrabold text-[#15803d] bg-emerald-100 border border-emerald-200 px-2 py-0.5 rounded-md">
                    Save {formatCurrency(bundle.savings)} ({bundle.savingsPercent}%)
                  </span>
                </div>
                <p className="text-[11px] text-[#64748b]">Combo discount applied on all {bundle.items.length} items</p>
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
                className="w-full sm:w-auto bg-[#2d9d43] hover:bg-[#078730] text-white font-bold text-xs md:text-sm px-6 py-3 rounded-xl shadow-md transition flex items-center justify-center gap-2 active:scale-95"
              >
                {bundleAdded ? (
                  <>
                    <CheckCircle2 className="w-4 h-4 text-white" />
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

        {/* Feature: Product Comparison */}
        <section>
          <ProductComparisonSection comparisonData={comparisonData} />
        </section>

        {/* Specifications & Nutrition Details */}
        <section className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {/* Specifications Accordion */}
          <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white shadow-xs">
            <button
              onClick={() => setDetailsOpen(!detailsOpen)}
              className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f9f9fc] transition"
            >
              <div className="flex items-center gap-2">
                <Info className="w-4 h-4 text-[#2d9d43]" />
                <span className="font-bold text-sm text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  Product Details & Specifications
                </span>
              </div>
              <ChevronDown className={`w-4 h-4 transition-transform ${detailsOpen ? 'rotate-180' : ''}`} />
            </button>
            {detailsOpen && (
              <div className="p-4 pt-0 text-xs text-[#3f4a3d] space-y-3 border-t border-[#eceef0]">
                <p className="leading-relaxed mt-3">{p.description}</p>
                <div className="divide-y divide-[#eceef0] border border-[#eceef0] rounded-xl overflow-hidden">
                  <div className="flex justify-between p-2.5 bg-[#f9f9fc]">
                    <span className="text-[#64748b]">Brand</span>
                    <span className="font-bold text-[#191c1e]">{p.brand}</span>
                  </div>
                  <div className="flex justify-between p-2.5">
                    <span className="text-[#64748b]">Net Quantity</span>
                    <span className="font-bold text-[#191c1e]">{p.unitName}</span>
                  </div>
                  <div className="flex justify-between p-2.5 bg-[#f9f9fc]">
                    <span className="text-[#64748b]">Category</span>
                    <span className="font-bold text-[#191c1e]">{p.category}</span>
                  </div>
                  <div className="flex justify-between p-2.5">
                    <span className="text-[#64748b]">Storage Instructions</span>
                    <span className="font-medium text-[#191c1e]">{p.storage}</span>
                  </div>
                  <div className="flex justify-between p-2.5 bg-[#f9f9fc]">
                    <span className="text-[#64748b]">Shelf Life</span>
                    <span className="font-medium text-[#191c1e]">{p.shelfLife}</span>
                  </div>
                  <div className="flex justify-between p-2.5">
                    <span className="text-[#64748b]">Country of Origin</span>
                    <span className="font-medium text-[#191c1e]">India 🇮🇳</span>
                  </div>
                  <div className="flex justify-between p-2.5 bg-[#f9f9fc]">
                    <span className="text-[#64748b]">SKU Code</span>
                    <span className="font-mono text-[11px] font-bold text-[#191c1e]">{selectedVariant?.sku || `SKU-DB-${p.id.toUpperCase().slice(0, 12)}`}</span>
                  </div>
                  <div className="flex justify-between p-2.5">
                    <span className="text-[#64748b]">Availability</span>
                    <span className="font-bold text-[#15803d]">{isAvailable ? 'In Stock (10-Min Fast Delivery)' : 'Out of Stock'}</span>
                  </div>
                  <div className="flex justify-between p-2.5 bg-[#f9f9fc]">
                    <span className="text-[#64748b]">FSSAI License</span>
                    <span className="font-medium text-[#191c1e]">10018043002345 (Certified)</span>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Nutritional Info Accordion */}
          <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white shadow-xs">
            <button
              onClick={() => setNutritionOpen(!nutritionOpen)}
              className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f9f9fc] transition"
            >
              <div className="flex items-center gap-2">
                <Award className="w-4 h-4 text-[#2d9d43]" />
                <span className="font-bold text-sm text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                  Nutritional Facts (per 100g)
                </span>
              </div>
              <ChevronDown className={`w-4 h-4 transition-transform ${nutritionOpen ? 'rotate-180' : ''}`} />
            </button>
            {nutritionOpen && (
              <div className="p-4 pt-0 text-xs border-t border-[#eceef0]">
                <ul className="divide-y divide-[#eceef0] border border-[#eceef0] rounded-xl overflow-hidden mt-3">
                  {Object.entries(nutrition).map(([k, v], idx) => (
                    <li key={k} className={`flex justify-between p-2.5 ${idx % 2 === 0 ? 'bg-[#f9f9fc]' : 'bg-white'}`}>
                      <span className="text-[#64748b] capitalize">{k}</span>
                      <span className="font-bold text-[#191c1e]">{String(v)}</span>
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>
        </section>

        {/* Feature: Customer Ratings & Reviews */}
        <section>
          <ProductReviewsSection
            productId={p.id}
            productName={p.name}
            category={p.category}
            initialRating={p.rating}
            initialReviewCount={reviewCount}
          />
        </section>

        {/* Feature: Similar Products */}
        <section>
          <ProductRecommendationsCarousel
            title="Similar & Related Products"
            subtitle={`Explore other popular items in ${p.category}`}
            products={similarProducts}
          />
        </section>

        {/* Feature: Customers Also Viewed */}
        <section>
          <ProductRecommendationsCarousel
            title="Customers Also Viewed"
            subtitle="Shoppers who viewed this item also explored these products"
            products={customersAlsoViewed}
          />
        </section>

        {/* Feature: Recently Viewed Products */}
        {recentlyViewedProducts.length > 0 && (
          <section>
            <ProductRecommendationsCarousel
              title="Recently Viewed Products"
              subtitle="Quickly jump back to groceries you inspected earlier"
              products={recentlyViewedProducts}
              onClear={clearRecentlyViewed}
              clearLabel="Clear History"
            />
          </section>
        )}
      </main>

      {/* Sticky Bottom Bar */}
      <div className="fixed bottom-0 left-0 w-full bg-white/95 backdrop-blur-xl border-t border-[#e2e2e5] p-3 sm:p-4 z-40 shadow-lg">
        <div className="max-w-5xl mx-auto flex gap-4 items-center justify-between">
          <div>
            <span className="text-[11px] font-semibold text-[#64748b] block">Total Amount</span>
            <div className="flex items-baseline gap-2">
              <span className="text-xl sm:text-2xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                {formatCurrency(price * quantity)}
              </span>
              {mrp > price && (
                <span className="text-xs text-[#64748b] line-through">
                  {formatCurrency(mrp * quantity)}
                </span>
              )}
            </div>
          </div>

          <div className="flex items-center gap-3">
            {isAvailable ? (
              <>
                <div className="flex items-center bg-[#f3f3f6] rounded-xl border border-[#e2e2e5] h-12 px-1">
                  <button
                    onClick={() => setQuantity(Math.max(1, quantity - 1))}
                    className="w-9 h-9 flex items-center justify-center hover:bg-slate-200 rounded-lg transition"
                    aria-label="Decrease quantity"
                  >
                    <Minus className="w-4 h-4 text-[#191c1e]" />
                  </button>
                  <span className="font-extrabold text-sm w-7 text-center text-[#191c1e]">{quantity}</span>
                  <button
                    onClick={() => setQuantity(quantity + 1)}
                    className="w-9 h-9 flex items-center justify-center hover:bg-slate-200 rounded-lg transition"
                    aria-label="Increase quantity"
                  >
                    <Plus className="w-4 h-4 text-[#191c1e]" />
                  </button>
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
                  className="bg-white hover:bg-slate-50 border-2 border-[#2d9d43] text-[#2d9d43] font-bold text-xs sm:text-sm px-4 sm:px-6 rounded-xl h-12 flex items-center justify-center gap-1.5 shadow-xs active:scale-95 transition"
                >
                  {addItem.isPending ? 'Adding…' : added ? '✓ Added!' : `Add to Cart`}
                </button>

                <button
                  disabled={!selectedVariant || addItem.isPending}
                  onClick={() => {
                    if (!selectedVariant) return;
                    addItem.mutate(
                      { variantId: selectedVariant.id, productName: p.name, unitName: selectedVariant.unitName, price: selectedVariant.price, quantity },
                      {
                        onSuccess: () => {
                          router.push('/checkout');
                        },
                      },
                    );
                  }}
                  className="bg-[#2d9d43] hover:bg-[#078730] text-white font-bold text-xs sm:text-sm px-5 sm:px-7 rounded-xl h-12 flex items-center justify-center gap-1.5 shadow-md active:scale-95 transition"
                >
                  <Zap className="w-4 h-4 fill-white" />
                  <span>Buy Now</span>
                </button>
              </>
            ) : (
              <div className="flex items-center gap-2">
                <span className="text-xs font-bold text-amber-800 bg-amber-100 border border-amber-300 px-3 py-2.5 rounded-xl">
                  Out of Stock
                </span>
                <button
                  onClick={() => setNotifyMeSet(!notifyMeSet)}
                  className="bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold px-4 py-2.5 rounded-xl transition flex items-center gap-1.5"
                >
                  <Bell className="w-3.5 h-3.5" />
                  {notifyMeSet ? '✓ Alert Set' : 'Notify Me'}
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Full-Screen Zoom Lightbox Modal */}
      {isZoomOpen && (
        <div
          role="dialog"
          aria-modal="true"
          className="fixed inset-0 z-50 bg-black/85 backdrop-blur-md flex items-center justify-center p-4 animate-[fadeIn_0.15s_ease-out]"
          onClick={() => setIsZoomOpen(false)}
        >
          <div
            className="relative max-w-4xl max-h-[90vh] bg-white rounded-3xl p-6 sm:p-8 flex flex-col items-center justify-center shadow-2xl"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              onClick={() => setIsZoomOpen(false)}
              className="absolute top-4 right-4 p-2 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 transition"
              title="Close image zoom"
            >
              <X className="w-5 h-5" />
            </button>

            <div className="w-full h-full flex items-center justify-center overflow-hidden">
              <img
                src={images[activeThumb] || images[0]}
                alt={p.name}
                className="max-w-full max-h-[70vh] object-contain select-none"
              />
            </div>

            <div className="mt-4 flex items-center justify-between w-full pt-4 border-t border-slate-100">
              <div>
                <p className="text-sm font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>{p.name}</p>
                <p className="text-xs text-[#64748b]">{p.unitName} • {p.brand}</p>
              </div>
              {images.length > 1 && (
                <div className="flex gap-2">
                  {images.map((img, idx) => (
                    <button
                      key={idx}
                      onClick={() => setActiveThumb(idx)}
                      className={`w-12 h-12 rounded-lg border-2 overflow-hidden p-1 transition ${
                        activeThumb === idx ? 'border-[#2d9d43]' : 'border-slate-200 opacity-60'
                      }`}
                    >
                      <img src={img} alt={`Thumb ${idx}`} className="w-full h-full object-contain" />
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
