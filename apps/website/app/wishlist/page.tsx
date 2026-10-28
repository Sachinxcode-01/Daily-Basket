'use client';

import React, { useState, useMemo } from 'react';
import Link from 'next/link';
import {
  Heart,
  ShoppingBag,
  Trash2,
  ArrowRight,
  Sparkles,
  Search,
  CheckCircle2,
  Clock,
  ArrowLeft,
} from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { useCart } from '../../store/useCart';
import { useWishlist } from '../../store/useWishlist';
import { useAuthStore } from '../../store/useAuthStore';
import {
  getProductById,
  ALL_WEBSITE_PRODUCTS,
  getWishlistRecommendations,
  normalizeImagePath,
  WebsiteProduct,
} from '../../lib/catalog';
import { ProductRecommendationsCarousel } from '../../components/ProductRecommendationsCarousel';

export default function WishlistPage() {
  const { productIds, removeFromWishlist, clearWishlist } = useWishlist();
  const { user } = useAuthStore();
  const { addItem } = useCart();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('ALL');
  const [sortBy, setSortBy] = useState('RECENTLY_ADDED');
  const [addedItemIds, setAddedItemIds] = useState<Record<string, boolean>>({});
  const [allAdded, setAllAdded] = useState(false);

  // Map product IDs from store to full catalog product objects
  const products: WebsiteProduct[] = useMemo(() => {
    return productIds
      .map((id) => getProductById(id) || ALL_WEBSITE_PRODUCTS.find((p) => p.id === id))
      .filter((p): p is WebsiteProduct => Boolean(p));
  }, [productIds]);

  // Extract unique categories available in current wishlist
  const availableCategories = useMemo(() => {
    const cats = new Set(products.map((p) => p.category));
    return Array.from(cats);
  }, [products]);

  // Filter and sort products
  const filteredProducts = useMemo(() => {
    return products
      .filter((item) => {
        const matchesCategory = selectedCategory === 'ALL' || item.category === selectedCategory;
        const matchesSearch =
          item.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
          item.brand.toLowerCase().includes(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      })
      .sort((a, b) => {
        if (sortBy === 'PRICE_LOW_HIGH') return a.price - b.price;
        if (sortBy === 'PRICE_HIGH_LOW') return b.price - a.price;
        if (sortBy === 'ALPHABETICAL') return a.name.localeCompare(b.name);
        return 0;
      });
  }, [products, selectedCategory, searchQuery, sortBy]);

  // Handle single item "Move to Cart"
  const handleMoveToCart = (product: WebsiteProduct) => {
    addItem.mutate(
      {
        variantId: product.variantId || `var_${product.id}`,
        productName: product.name,
        unitName: product.unitName,
        price: product.price,
        quantity: 1,
      },
      {
        onSuccess: () => {
          setAddedItemIds((prev) => ({ ...prev, [product.id]: true }));
          setTimeout(() => {
            removeFromWishlist(product.id, user?.id);
            setAddedItemIds((prev) => {
              const copy = { ...prev };
              delete copy[product.id];
              return copy;
            });
          }, 800);
        },
      },
    );
  };

  // Handle "Add All to Cart"
  const handleAddAllToCart = () => {
    filteredProducts.forEach((product) => {
      if (product.inStock) {
        addItem.mutate({
          variantId: product.variantId || `var_${product.id}`,
          productName: product.name,
          unitName: product.unitName,
          price: product.price,
          quantity: 1,
        });
      }
    });
    setAllAdded(true);
    setTimeout(() => setAllAdded(false), 2500);
  };

  const handleClearAll = () => {
    if (confirm('Are you sure you want to clear your saved wishlist?')) {
      clearWishlist(user?.id);
    }
  };

  // Recommendations based on user's active wishlist items
  const recommendations = useMemo(() => {
    return getWishlistRecommendations(productIds, 8);
  }, [productIds]);

  return (
    <div className="min-h-screen bg-[#f9f9fc] text-[#191c1e] py-8 px-4 sm:px-6 lg:px-8 pb-32">
      <div className="max-w-6xl mx-auto space-y-8">
        {/* Navigation Breadcrumb */}
        <div className="flex items-center justify-between">
          <Link
            href="/"
            className="flex items-center gap-1.5 text-xs font-bold text-[#2d9d43] hover:text-[#078730] transition p-1.5 rounded-lg hover:bg-emerald-50"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Continue Shopping</span>
          </Link>
          <div className="flex items-center gap-2">
            <span className="text-xs font-semibold text-[#64748b]">
              Delivery in 10 mins
            </span>
            <span className="w-2 h-2 rounded-full bg-[#2d9d43] animate-pulse" />
          </div>
        </div>

        {/* Header Title Section */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between border-b border-[#e2e2e5] pb-6 gap-4">
          <div>
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-full bg-rose-50 border border-rose-200 flex items-center justify-center text-rose-500">
                <Heart className="w-5 h-5 fill-rose-500" />
              </div>
              <h1 className="text-2xl sm:text-3xl font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                My Wishlist
              </h1>
            </div>
            <p className="text-xs sm:text-sm font-medium text-[#64748b] mt-1.5">
              {productIds.length} saved item{productIds.length !== 1 ? 's' : ''} available for quick daily basket restocking
            </p>
          </div>

          {products.length > 0 && (
            <div className="flex items-center gap-3">
              <button
                onClick={handleAddAllToCart}
                className="px-4 py-2.5 bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold rounded-xl transition flex items-center gap-2 shadow-xs active:scale-95"
              >
                {allAdded ? (
                  <>
                    <CheckCircle2 className="w-4 h-4" />
                    <span>Added to Cart!</span>
                  </>
                ) : (
                  <>
                    <ShoppingBag className="w-4 h-4" />
                    <span>Add All to Cart</span>
                  </>
                )}
              </button>
              <button
                onClick={handleClearAll}
                className="px-3.5 py-2.5 bg-white hover:bg-rose-50 text-slate-500 hover:text-rose-600 border border-[#e2e2e5] hover:border-rose-200 rounded-xl text-xs font-semibold transition flex items-center gap-1.5"
                title="Clear all saved products"
              >
                <Trash2 className="w-3.5 h-3.5" />
                <span className="hidden sm:inline">Clear All</span>
              </button>
            </div>
          )}
        </div>

        {/* Search, Filter & Sort Bar */}
        {products.length > 0 && (
          <div className="flex flex-col sm:flex-row gap-3">
            <div className="flex-1 relative">
              <input
                type="text"
                placeholder="Search within saved items (e.g., Amul, Tomato, Bread)..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full bg-white border border-[#e2e2e5] rounded-xl py-2.5 px-4 pl-10 text-xs sm:text-sm text-[#191c1e] placeholder-[#94a3b8] focus:outline-none focus:border-[#2d9d43] shadow-xs transition"
              />
              <Search className="w-4 h-4 text-[#94a3b8] absolute left-3.5 top-3" />
            </div>

            <div className="flex items-center gap-2">
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="bg-white border border-[#e2e2e5] rounded-xl py-2.5 px-3 text-xs font-semibold text-[#191c1e] focus:outline-none focus:border-[#2d9d43] shadow-xs"
              >
                <option value="ALL">All Categories ({products.length})</option>
                {availableCategories.map((c) => (
                  <option key={c} value={c}>
                    {c}
                  </option>
                ))}
              </select>

              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="bg-white border border-[#e2e2e5] rounded-xl py-2.5 px-3 text-xs font-semibold text-[#191c1e] focus:outline-none focus:border-[#2d9d43] shadow-xs"
              >
                <option value="RECENTLY_ADDED">Recently Saved</option>
                <option value="PRICE_LOW_HIGH">Price: Low to High</option>
                <option value="PRICE_HIGH_LOW">Price: High to Low</option>
                <option value="ALPHABETICAL">Product Name (A-Z)</option>
              </select>
            </div>
          </div>
        )}

        {/* Products Grid or Empty State */}
        {filteredProducts.length === 0 ? (
          <div className="bg-white border border-[#e2e2e5] rounded-3xl p-12 text-center shadow-xs space-y-4 max-w-lg mx-auto">
            <div className="w-16 h-16 rounded-full bg-rose-50 border border-rose-100 flex items-center justify-center mx-auto text-rose-500">
              <Heart className="w-8 h-8 text-rose-400" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                {products.length === 0 ? 'Your Wishlist is Empty' : 'No Matching Saved Items'}
              </h3>
              <p className="text-xs text-[#64748b] mt-1 max-w-sm mx-auto">
                {products.length === 0
                  ? 'Tap the heart icon on any grocery, milk, or fresh produce item to save it for 1-click reordering.'
                  : 'Try clearing your search query or switching categories to find saved groceries.'}
              </p>
            </div>
            <Link
              href="/"
              className="inline-flex items-center gap-2 px-6 py-2.5 bg-[#2d9d43] hover:bg-[#078730] text-white text-xs font-bold rounded-xl shadow-xs transition"
            >
              <span>Explore Kirana Catalog</span>
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            {filteredProducts.map((product) => {
              const discount =
                product.mrp > product.price
                  ? Math.round(((product.mrp - product.price) / product.mrp) * 100)
                  : 0;
              const isMoving = Boolean(addedItemIds[product.id]);

              return (
                <div
                  key={product.id}
                  className="bg-white border border-[#e2e2e5] hover:border-[#2d9d43] rounded-2xl overflow-hidden flex flex-col justify-between shadow-xs hover:shadow-md transition-all group"
                >
                  {/* Top Image Box */}
                  <div className="relative aspect-square p-4 bg-[#fafafa] flex items-center justify-center border-b border-[#f1f1f3]">
                    <Link href={`/product/${product.id}`} className="w-full h-full flex items-center justify-center">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img
                        src={normalizeImagePath(product.image || product.images?.[0])}
                        alt={product.name}
                        className="max-h-full max-w-full object-contain group-hover:scale-105 transition-transform duration-300"
                      />
                    </Link>

                    {/* Discount Badge */}
                    {discount > 0 && (
                      <span className="absolute top-2.5 left-2.5 bg-[#ba1a1a] text-white text-[10px] font-extrabold px-1.5 py-0.5 rounded shadow-xs">
                        {discount}% OFF
                      </span>
                    )}

                    {/* Remove Button */}
                    <button
                      onClick={() => removeFromWishlist(product.id, user?.id)}
                      className="absolute top-2.5 right-2.5 p-1.5 bg-white/90 hover:bg-rose-50 text-rose-500 rounded-full border border-[#e2e2e5] hover:border-rose-300 shadow-xs transition"
                      title="Remove from wishlist"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </div>

                  {/* Info & Move to Cart Button */}
                  <div className="p-3.5 flex-1 flex flex-col justify-between">
                    <div>
                      <span className="text-[10px] uppercase font-bold tracking-wider text-[#2d9d43]">
                        {product.brand}
                      </span>
                      <Link href={`/product/${product.id}`}>
                        <h4 className="text-xs sm:text-sm font-bold text-[#191c1e] line-clamp-2 mt-0.5 hover:text-[#2d9d43] transition">
                          {product.name}
                        </h4>
                      </Link>
                      <p className="text-[11px] font-medium text-[#64748b] mt-0.5">{product.unitName}</p>
                    </div>

                    <div className="mt-3 pt-2.5 border-t border-[#f1f1f3] space-y-2">
                      <div className="flex items-baseline justify-between">
                        <div className="flex items-baseline gap-1.5">
                          <span className="text-sm sm:text-base font-extrabold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
                            {formatCurrency(product.price)}
                          </span>
                          {product.mrp > product.price && (
                            <span className="text-[11px] text-[#94a3b8] line-through">
                              {formatCurrency(product.mrp)}
                            </span>
                          )}
                        </div>

                        <span
                          className={`text-[9px] font-extrabold px-1.5 py-0.5 rounded ${
                            product.inStock
                              ? 'bg-emerald-50 text-[#15803d] border border-emerald-200'
                              : 'bg-amber-50 text-[#b45309] border border-amber-200'
                          }`}
                        >
                          {product.inStock ? 'IN STOCK' : 'OUT OF STOCK'}
                        </span>
                      </div>

                      <button
                        disabled={!product.inStock || isMoving}
                        onClick={() => handleMoveToCart(product)}
                        className="w-full py-2 bg-[#2d9d43] hover:bg-[#078730] disabled:bg-slate-200 disabled:text-slate-500 text-white text-xs font-bold rounded-xl transition flex items-center justify-center gap-1.5 shadow-xs active:scale-95"
                      >
                        {isMoving ? (
                          <>
                            <CheckCircle2 className="w-3.5 h-3.5 text-white" />
                            <span>Moving to Cart…</span>
                          </>
                        ) : product.inStock ? (
                          <>
                            <ShoppingBag className="w-3.5 h-3.5" />
                            <span>Move to Cart</span>
                          </>
                        ) : (
                          <span>Out of Stock</span>
                        )}
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Personalized Recommendations based on Wishlist profile */}
        {recommendations.length > 0 && (
          <div className="pt-8 border-t border-[#e2e2e5]">
            <ProductRecommendationsCarousel
              title="Recommended For You Based on Your Wishlist"
              subtitle="Curated daily essentials matching your saved favorites"
              products={recommendations}
              badge="Smart Picks"
            />
          </div>
        )}
      </div>
    </div>
  );
}
