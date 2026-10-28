// Google Stitch Screen ID: f7c78b705cb6471dae1b49027ca746b3
// Title: Premium Product Catalog & Search
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useState, useEffect, useMemo, useRef } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Search, Camera, SlidersHorizontal, Plus, Check, ArrowLeft, Mic, Clock, Sparkles, X, ChevronRight } from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { formatCurrency } from '@daily-basket/shared-utils';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../../store/useCart';
import { BarcodeScanner } from '../../components/BarcodeScanner';
import {
  searchProducts,
  normalizeImagePath,
  WebsiteProduct,
  AdvancedFilterState,
  INITIAL_FILTER_STATE,
  filterAndSortWebsiteProducts,
  getSmartSearchSuggestions,
  TRENDING_SEARCH_KEYWORDS,
  STATIC_CATEGORIES,
} from '../../lib/catalog';
import { AdvancedFilterModal } from '../../components/AdvancedFilterModal';
import { VoiceSearchModal } from '../../components/VoiceSearchModal';

interface SearchItem {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  weight: string;
  price: number;
  mrp: number;
  discount: number;
  rating?: number;
  isOrganic: boolean;
  categorySlug: string;
  inStock: boolean;
  image: string;
}

const RECENT_SEARCHES_KEY = 'daily_basket_recent_searches';

function mapItem(p: any): SearchItem {
  const variant =
    (Array.isArray(p?.variants) && (p.variants.find((v: any) => v?.isAvailable) ?? p.variants[0])) || null;
  const rawImage = (Array.isArray(p?.images) && p.images[0]) || p.image || null;
  const price = variant?.price ?? p?.price ?? 0;
  const mrp = variant?.mrp ?? p?.mrp ?? price;
  const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;

  return {
    id: p?.id,
    variantId: variant?.id ?? p?.variantId ?? '',
    name: p?.name ?? '',
    brand: p?.brand ?? 'Daily Basket Select',
    weight: variant?.unitName ?? p?.unitName ?? '',
    price,
    mrp,
    discount,
    rating: p?.rating ?? 4.5,
    isOrganic: Boolean(p?.isOrganic),
    categorySlug: p?.categorySlug ?? '',
    inStock: p?.inStock ?? true,
    image: normalizeImagePath(rawImage),
  };
}

export default function SearchPage() {
  const router = useRouter();
  const searchInputRef = useRef<HTMLInputElement>(null);
  const [query, setQuery] = useState('');
  const [debouncedQuery, setDebouncedQuery] = useState('');
  const [activeQuickChip, setActiveQuickChip] = useState('All');
  const [isCameraModalOpen, setIsCameraModalOpen] = useState(false);
  const [isVoiceModalOpen, setIsVoiceModalOpen] = useState(false);
  const [isFilterModalOpen, setIsFilterModalOpen] = useState(false);
  const [advancedFilters, setAdvancedFilters] = useState<AdvancedFilterState>(INITIAL_FILTER_STATE);
  const [scanNotice, setScanNotice] = useState<string | null>(null);
  const [isSearchFocused, setIsSearchFocused] = useState(false);
  const [recentSearches, setRecentSearches] = useState<string[]>([]);

  const { activeItems, addItem, updateItem } = useCart();

  // Load recent searches from localStorage
  useEffect(() => {
    try {
      const stored = localStorage.getItem(RECENT_SEARCHES_KEY);
      if (stored) {
        const parsed = JSON.parse(stored);
        if (Array.isArray(parsed)) setRecentSearches(parsed.slice(0, 6));
      }
    } catch {
      // Ignore
    }
  }, []);

  const saveRecentSearch = (term: string) => {
    const trimmed = term.trim();
    if (!trimmed) return;
    setRecentSearches((prev) => {
      const updated = [trimmed, ...prev.filter((t) => t.toLowerCase() !== trimmed.toLowerCase())].slice(0, 6);
      try {
        localStorage.setItem(RECENT_SEARCHES_KEY, JSON.stringify(updated));
      } catch {
        // Ignore
      }
      return updated;
    });
  };

  const removeRecentSearch = (term: string, e: React.MouseEvent) => {
    e.stopPropagation();
    setRecentSearches((prev) => {
      const updated = prev.filter((t) => t !== term);
      try {
        localStorage.setItem(RECENT_SEARCHES_KEY, JSON.stringify(updated));
      } catch {
        // Ignore
      }
      return updated;
    });
  };

  const clearAllRecentSearches = () => {
    setRecentSearches([]);
    try {
      localStorage.removeItem(RECENT_SEARCHES_KEY);
    } catch {
      // Ignore
    }
  };

  // Barcode scan
  const handleScan = async (code: string) => {
    setIsCameraModalOpen(false);
    const c = code.trim();
    if (!c) return;
    try {
      const res: any = await apiClient.searchByBarcode(c);
      const products = Array.isArray(res?.products) ? res.products : Array.isArray(res) ? res : [];
      if (products.length > 0 && products[0]?.id) {
        router.push(`/product/${products[0].id}`);
        return;
      }
    } catch {
      /* fall through to text search */
    }
    setScanNotice(`No product matched barcode "${c}". Showing search results instead.`);
    setQuery(c);
    saveRecentSearch(c);
  };

  const quickChips = [
    { label: 'All', dietary: 'all' as const },
    { label: 'Organic 🌿', dietary: 'organic' as const },
    { label: 'Vegan 🌱', dietary: 'vegan' as const },
    { label: 'Under ₹50', priceBracket: 'under_50' as const },
    { label: 'In-Stock ⚡', inStockOnly: true },
  ];

  // Debounce the query
  useEffect(() => {
    const t = setTimeout(() => {
      const trimmed = query.trim();
      setDebouncedQuery(trimmed);
      if (trimmed) saveRecentSearch(trimmed);
    }, 350);
    return () => clearTimeout(t);
  }, [query]);

  const {
    data: apiProducts,
    isLoading,
    isFetching,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['search', debouncedQuery],
    queryFn: async () => {
      try {
        return await apiClient.getProducts(undefined, debouncedQuery || undefined);
      } catch {
        return [];
      }
    },
    retry: 1,
  });

  const baseResults: WebsiteProduct[] = useMemo(() => {
    if (Array.isArray(apiProducts) && apiProducts.length > 0) {
      return apiProducts.map((p) => {
        const item = mapItem(p);
        return {
          id: item.id,
          variantId: item.variantId,
          name: item.name,
          brand: item.brand,
          unitName: item.weight,
          price: item.price,
          mrp: item.mrp,
          discount: item.discount,
          rating: item.rating,
          category: (p as any).category?.name || 'Groceries',
          categorySlug: (p as any).category?.slug || (p as any).categoryId || 'groceries',
          image: item.image,
          images: [item.image],
          isOrganic: item.isOrganic,
          isVeg: (p as any).isVeg ?? true,
          description: p.description || '',
          inStock: item.inStock,
        };
      });
    }
    return searchProducts(debouncedQuery);
  }, [apiProducts, debouncedQuery]);

  const results: SearchItem[] = useMemo(() => {
    const filtered = filterAndSortWebsiteProducts(baseResults, advancedFilters);
    return filtered.map(mapItem);
  }, [baseResults, advancedFilters]);

  // Smart Search Typeahead Suggestions
  const searchSuggestions = useMemo(() => {
    return getSmartSearchSuggestions(query);
  }, [query]);

  const availableBrands = useMemo(() => {
    const brands = new Set<string>();
    baseResults.forEach((p) => {
      if (p.brand) brands.add(p.brand);
    });
    return Array.from(brands).slice(0, 8);
  }, [baseResults]);

  const activeFilterCount =
    (advancedFilters.dietary !== 'all' ? 1 : 0) +
    (advancedFilters.priceBracket !== 'all' ? 1 : 0) +
    (advancedFilters.sortBy !== 'featured' ? 1 : 0) +
    (advancedFilters.inStockOnly ? 1 : 0) +
    (advancedFilters.brand && advancedFilters.brand !== 'All' ? 1 : 0);

  const addToCart = (item: SearchItem) => {
    if (!item.variantId) return;
    const existing = activeItems.find((i) => i.variantId === item.variantId);
    if (existing) {
      updateItem.mutate({ itemId: existing.id, quantity: existing.quantity + 1 });
    } else {
      addItem.mutate({ variantId: item.variantId, productName: item.name, unitName: item.weight, price: item.price, quantity: 1 });
    }
  };

  const qtyFor = (variantId: string) => activeItems.find((i) => i.variantId === variantId)?.quantity ?? 0;
  const loading = isLoading || isFetching;

  const handleSelectSearchTerm = (term: string) => {
    setQuery(term);
    saveRecentSearch(term);
    setIsSearchFocused(false);
  };

  return (
    <div className="min-h-screen bg-slate-900 font-sans pb-24 text-white">
      {/* Voice Search Modal */}
      <VoiceSearchModal
        isOpen={isVoiceModalOpen}
        onClose={() => setIsVoiceModalOpen(false)}
        onProductSelect={(productId) => {
          router.push(`/product/${productId}`);
        }}
      />

      {/* Advanced Filter Modal */}
      <AdvancedFilterModal
        isOpen={isFilterModalOpen}
        onClose={() => setIsFilterModalOpen(false)}
        filters={advancedFilters}
        onFilterChange={(newFilters) => {
          setAdvancedFilters(newFilters);
          if (newFilters.dietary === 'all' && newFilters.priceBracket === 'all' && !newFilters.inStockOnly) {
            setActiveQuickChip('All');
          } else {
            setActiveQuickChip('');
          }
        }}
        availableBrands={availableBrands}
        totalMatches={results.length}
      />

      {/* Sticky Search Header */}
      <header className="sticky top-0 z-40 bg-slate-800/95 backdrop-blur-md border-b border-slate-700/80 px-4 sm:px-8 py-3">
        <div className="max-w-7xl mx-auto flex items-center gap-3">
          <Link href="/" className="p-2 text-teal-400 hover:bg-slate-700 rounded-full transition">
            <ArrowLeft className="w-6 h-6" />
          </Link>

          <div className="relative flex-1">
            <Search className="w-5 h-5 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              ref={searchInputRef}
              type="text"
              value={query}
              onFocus={() => setIsSearchFocused(true)}
              onChange={(e) => {
                setQuery(e.target.value);
                if (scanNotice) setScanNotice(null);
              }}
              placeholder="Search for groceries, brand, category or speak..."
              className="w-full h-11 bg-slate-900 border border-slate-700 rounded-xl pl-11 pr-24 text-sm font-medium text-white placeholder:text-slate-400 focus:outline-none focus:border-teal-500 transition"
            />
            <div className="absolute right-2 top-1/2 -translate-y-1/2 flex items-center gap-1.5">
              {query && (
                <button
                  onClick={() => {
                    setQuery('');
                    searchInputRef.current?.focus();
                  }}
                  className="p-1 text-slate-400 hover:text-white rounded transition"
                  title="Clear search"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
              <button
                onClick={() => setIsVoiceModalOpen(true)}
                title="Search with Voice"
                className="p-2 bg-[#2d9d43] hover:bg-[#258538] text-white rounded-lg transition flex items-center justify-center shadow-xs"
              >
                <Mic className="w-4 h-4" />
              </button>
              <button
                onClick={() => setIsCameraModalOpen(true)}
                title="Search by Camera"
                className="p-2 bg-teal-500 text-slate-950 rounded-lg hover:bg-teal-400 transition flex items-center justify-center"
              >
                <Camera className="w-4 h-4" />
              </button>
            </div>

            {/* Smart Search Typeahead Dropdown */}
            {isSearchFocused && (
              <div
                className="absolute left-0 right-0 top-13 bg-slate-800 border border-slate-700 rounded-2xl p-4 shadow-2xl z-50 animate-in fade-in zoom-in-95 duration-150"
                onMouseDown={(e) => e.preventDefault()} // Prevents blur before click
              >
                {/* 1. When query has characters: show matching suggestions & quick product cards */}
                {query.trim().length > 0 ? (
                  <div className="space-y-4">
                    {/* Suggested Keywords */}
                    {searchSuggestions.suggestedPhrases.length > 0 && (
                      <div>
                        <span className="text-[11px] font-bold uppercase tracking-wider text-teal-400 flex items-center gap-1.5 mb-2">
                          <Sparkles className="w-3.5 h-3.5" /> Matching Suggestions
                        </span>
                        <div className="flex flex-wrap gap-2">
                          {searchSuggestions.suggestedPhrases.map((phrase) => (
                            <button
                              key={phrase}
                              onClick={() => handleSelectSearchTerm(phrase)}
                              className="text-xs bg-slate-900 hover:bg-slate-700 text-slate-200 px-3 py-1.5 rounded-lg border border-slate-700 transition flex items-center gap-1.5"
                            >
                              <Search className="w-3 h-3 text-slate-400" />
                              <span>{phrase}</span>
                            </button>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Matching Categories */}
                    {searchSuggestions.matchingCategories.length > 0 && (
                      <div className="pt-2 border-t border-slate-700/60">
                        <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2 block">
                          Categories
                        </span>
                        <div className="flex flex-wrap gap-2">
                          {searchSuggestions.matchingCategories.map((cat) => (
                            <Link
                              key={cat.slug}
                              href={`/categories?slug=${cat.slug}`}
                              onClick={() => setIsSearchFocused(false)}
                              className="text-xs bg-teal-950/40 text-teal-300 border border-teal-800/60 hover:bg-teal-900/40 px-3 py-1.5 rounded-lg transition flex items-center gap-1.5"
                            >
                              <span>{cat.name}</span>
                              <span className="text-[10px] text-teal-500 font-bold">({cat.count})</span>
                            </Link>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Quick Product Hits */}
                    {searchSuggestions.matchedProducts.length > 0 && (
                      <div className="pt-2 border-t border-slate-700/60">
                        <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2 block">
                          Products
                        </span>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                          {searchSuggestions.matchedProducts.map((p) => (
                            <Link
                              key={p.id}
                              href={`/product/${p.id}`}
                              onClick={() => {
                                saveRecentSearch(p.name);
                                setIsSearchFocused(false);
                              }}
                              className="flex items-center gap-3 p-2 rounded-xl bg-slate-900/60 hover:bg-slate-700/70 border border-slate-700/50 transition group"
                            >
                              <img src={p.image} alt={p.name} className="w-10 h-10 object-contain rounded-lg bg-white p-0.5" />
                              <div className="flex-1 min-w-0">
                                <h4 className="text-xs font-bold text-white group-hover:text-teal-400 truncate">
                                  {p.name}
                                </h4>
                                <div className="flex items-center gap-2 text-[11px] text-slate-400">
                                  <span>{p.unitName}</span>
                                  <span className="text-teal-400 font-bold">{formatCurrency(p.price)}</span>
                                </div>
                              </div>
                              <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-teal-400" />
                            </Link>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                ) : (
                  /* 2. When query is empty: show Recent Searches & Trending Searches */
                  <div className="space-y-4">
                    {/* Recent Searches */}
                    {recentSearches.length > 0 && (
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 flex items-center gap-1.5">
                            <Clock className="w-3.5 h-3.5" /> Recent Searches
                          </span>
                          <button
                            onClick={clearAllRecentSearches}
                            className="text-[11px] text-slate-400 hover:text-rose-400 font-semibold"
                          >
                            Clear All
                          </button>
                        </div>
                        <div className="flex flex-wrap gap-2">
                          {recentSearches.map((term) => (
                            <div
                              key={term}
                              onClick={() => handleSelectSearchTerm(term)}
                              className="cursor-pointer text-xs bg-slate-900 hover:bg-slate-700 text-slate-200 pl-3 pr-2 py-1.5 rounded-lg border border-slate-700 transition flex items-center gap-2"
                            >
                              <span>{term}</span>
                              <button
                                onClick={(e) => removeRecentSearch(term, e)}
                                className="text-slate-400 hover:text-white p-0.5 rounded"
                              >
                                <X className="w-3 h-3" />
                              </button>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Trending Searches */}
                    <div className={recentSearches.length > 0 ? 'pt-3 border-t border-slate-700/60' : ''}>
                      <span className="text-[11px] font-bold uppercase tracking-wider text-teal-400 flex items-center gap-1.5 mb-2">
                        <Sparkles className="w-3.5 h-3.5" /> Trending in Quick Commerce
                      </span>
                      <div className="flex flex-wrap gap-2">
                        {TRENDING_SEARCH_KEYWORDS.map((kw) => (
                          <button
                            key={kw}
                            onClick={() => handleSelectSearchTerm(kw)}
                            className="text-xs bg-slate-900 hover:bg-teal-950/60 hover:border-teal-700 text-slate-200 px-3 py-1.5 rounded-lg border border-slate-700 transition flex items-center gap-1.5"
                          >
                            <span className="text-teal-400">🔥</span>
                            <span>{kw}</span>
                          </button>
                        ))}
                      </div>
                    </div>

                    {/* Quick Category Jump */}
                    <div className="pt-3 border-t border-slate-700/60">
                      <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2 block">
                        Browse Departments
                      </span>
                      <div className="flex flex-wrap gap-2">
                        {STATIC_CATEGORIES.map((cat) => (
                          <Link
                            key={cat.slug}
                            href={`/categories?slug=${cat.slug}`}
                            onClick={() => setIsSearchFocused(false)}
                            className="text-xs bg-slate-900 hover:bg-slate-700 text-slate-300 px-3 py-1.5 rounded-lg border border-slate-700 transition"
                          >
                            {cat.name}
                          </Link>
                        ))}
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}
          </div>

          <button
            onClick={() => setIsFilterModalOpen(true)}
            className={`relative p-2.5 rounded-xl border transition flex items-center justify-center ${
              activeFilterCount > 0
                ? 'bg-teal-500/20 border-teal-500 text-teal-300 shadow-sm shadow-teal-500/30'
                : 'bg-slate-700 border-transparent text-slate-200 hover:bg-slate-600'
            }`}
            title="Filter & Sort"
          >
            <SlidersHorizontal className="w-5 h-5" />
            {activeFilterCount > 0 && (
              <span className="absolute -top-1 -right-1 w-5 h-5 bg-teal-500 text-slate-950 rounded-full text-[10px] font-extrabold flex items-center justify-center shadow">
                {activeFilterCount}
              </span>
            )}
          </button>
        </div>

        {/* Filter Chips Bar */}
        <div className="max-w-7xl mx-auto flex items-center gap-2 mt-3 overflow-x-auto scrollbar-none pb-1">
          {quickChips.map((chip) => {
            const isSelected =
              activeQuickChip === chip.label ||
              (chip.dietary && advancedFilters.dietary === chip.dietary) ||
              (chip.priceBracket && advancedFilters.priceBracket === chip.priceBracket) ||
              (chip.inStockOnly && advancedFilters.inStockOnly);

            return (
              <button
                key={chip.label}
                onClick={() => {
                  setActiveQuickChip(chip.label);
                  if (chip.label === 'All') {
                    setAdvancedFilters(INITIAL_FILTER_STATE);
                  } else if (chip.dietary) {
                    setAdvancedFilters((prev) => ({ ...prev, dietary: chip.dietary! }));
                  } else if (chip.priceBracket) {
                    setAdvancedFilters((prev) => ({ ...prev, priceBracket: chip.priceBracket! }));
                  } else if (chip.inStockOnly) {
                    setAdvancedFilters((prev) => ({ ...prev, inStockOnly: !prev.inStockOnly }));
                  }
                }}
                className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                  isSelected
                    ? 'bg-teal-500 text-slate-950 font-bold shadow-md shadow-teal-500/20'
                    : 'bg-slate-700 text-slate-300 hover:bg-slate-600'
                }`}
              >
                {chip.label}
              </button>
            );
          })}
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-8 pt-6">
        {scanNotice && (
          <div className="mb-4 p-3 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-300 text-xs">
            {scanNotice}
          </div>
        )}

        <div className="flex items-center justify-between mb-4">
          <p className="text-sm font-medium text-slate-400 font-inter">
            {debouncedQuery
              ? <>Showing <span className="font-bold text-white">{results.length} results</span> for &ldquo;{debouncedQuery}&rdquo;</>
              : <>Showing <span className="font-bold text-white">{results.length}</span> products</>}
          </p>
        </div>

        {/* Loading */}
        {loading && (
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="bg-slate-800 border border-slate-700/70 rounded-2xl p-4 animate-pulse">
                <div className="aspect-square rounded-xl mb-3 bg-slate-700/50" />
                <div className="h-3 bg-slate-700/50 rounded w-3/4 mb-2" />
                <div className="h-3 bg-slate-700/50 rounded w-1/2 mb-3" />
                <div className="h-9 bg-slate-700/50 rounded-xl" />
              </div>
            ))}
          </div>
        )}

        {/* Error */}
        {!loading && isError && baseResults.length === 0 && (
          <div className="text-center py-16 space-y-3">
            <div className="text-4xl">⚠️</div>
            <p className="font-bold text-white">Search failed</p>
            <button
              onClick={() => refetch()}
              className="mt-1 bg-teal-500 text-slate-950 text-xs font-bold px-5 py-2.5 rounded-xl hover:bg-teal-400"
            >
              Retry
            </button>
          </div>
        )}

        {/* Empty */}
        {!loading && (baseResults.length === 0 ? !isError : true) && results.length === 0 && (
          <div className="text-center py-16 space-y-3">
            <div className="text-4xl">🔍</div>
            <p className="font-bold text-white">No products found</p>
            <p className="text-xs text-slate-400">
              {debouncedQuery ? 'Try checking your spelling or trying a broader term.' : 'Start typing to search the catalog.'}
            </p>
            <div className="pt-4 flex flex-wrap justify-center gap-2 max-w-md mx-auto">
              {TRENDING_SEARCH_KEYWORDS.slice(0, 4).map((kw) => (
                <button
                  key={kw}
                  onClick={() => handleSelectSearchTerm(kw)}
                  className="text-xs bg-slate-800 text-teal-300 border border-slate-700 px-3 py-1.5 rounded-lg"
                >
                  Search &ldquo;{kw}&rdquo;
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Results Grid */}
        {!loading && results.length > 0 && (
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
            {results.map((item) => {
              const count = qtyFor(item.variantId);
              const discount = item.mrp > item.price ? Math.round(((item.mrp - item.price) / item.mrp) * 100) : 0;
              return (
                <div
                  key={item.id}
                  className="bg-slate-800 border border-slate-700/70 hover:border-teal-500/50 rounded-2xl p-4 flex flex-col justify-between transition-all duration-300 hover:shadow-xl hover:shadow-teal-500/5"
                >
                  <div>
                    <Link href={`/product/${item.id}`} className="relative block aspect-square rounded-xl overflow-hidden mb-3 bg-slate-900">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={item.image} alt={item.name} className="w-full h-full object-contain p-2" />
                      {item.isOrganic && (
                        <span className="absolute top-2 left-2 bg-emerald-500 text-white text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
                          Organic
                        </span>
                      )}
                      {!item.isOrganic && discount > 0 && (
                        <span className="absolute top-2 left-2 bg-red-500 text-white text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
                          {discount}% OFF
                        </span>
                      )}
                    </Link>

                    <Link href={`/product/${item.id}`}>
                      <h3 className="font-bold text-sm text-white font-outfit line-clamp-2 mb-1 hover:text-teal-400 transition">
                        {item.name}
                      </h3>
                    </Link>
                    <p className="text-xs text-slate-400 font-inter mb-3">{item.weight}</p>
                  </div>

                  <div>
                    <div className="flex items-baseline gap-1.5 mb-3">
                      <span className="text-base font-extrabold text-teal-400 font-outfit">
                        {formatCurrency(item.price)}
                      </span>
                      {item.mrp > item.price && (
                        <span className="text-xs text-slate-500 line-through font-inter">
                          {formatCurrency(item.mrp)}
                        </span>
                      )}
                    </div>

                    <button
                      onClick={() => addToCart(item)}
                      disabled={addItem.isPending || !item.variantId}
                      className={`w-full h-9 rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 transition disabled:opacity-50 ${
                        count > 0 ? 'bg-teal-600 text-white' : 'bg-teal-500 text-slate-950 hover:bg-teal-400'
                      }`}
                    >
                      {count > 0 ? (
                        <>
                          <Check className="w-4 h-4" /> Added ({count})
                        </>
                      ) : (
                        <>
                          <Plus className="w-4 h-4" /> ADD
                        </>
                      )}
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </main>

      {/* Live camera barcode scanner */}
      {isCameraModalOpen && (
        <BarcodeScanner onDetected={handleScan} onClose={() => setIsCameraModalOpen(false)} />
      )}
    </div>
  );
}
