'use client';

import React from 'react';
import { X, SlidersHorizontal, Check, RotateCcw, Sparkles } from 'lucide-react';
import { AdvancedFilterState, INITIAL_FILTER_STATE } from '../lib/catalog';

interface AdvancedFilterModalProps {
  isOpen: boolean;
  onClose: () => void;
  filters: AdvancedFilterState;
  onFilterChange: (filters: AdvancedFilterState) => void;
  availableBrands?: string[];
  totalMatches?: number;
}

export const AdvancedFilterModal: React.FC<AdvancedFilterModalProps> = ({
  isOpen,
  onClose,
  filters,
  onFilterChange,
  availableBrands = ['Amul', 'Daily Basket Select', 'Mother Dairy', 'Nandini', 'Kelloggs'],
  totalMatches,
}) => {
  if (!isOpen) return null;

  const dietaryOptions: { id: AdvancedFilterState['dietary']; label: string; badge: string }[] = [
    { id: 'all', label: 'All Diets', badge: '🌾' },
    { id: 'organic', label: 'Certified Organic', badge: '🌿' },
    { id: 'vegan', label: '100% Vegan', badge: '🌱' },
    { id: 'gluten_free', label: 'Gluten-Free', badge: '🚫🌾' },
    { id: 'sugar_free', label: 'Zero Added Sugar', badge: '🍬' },
    { id: 'high_protein', label: 'High Protein', badge: '💪' },
  ];

  const priceOptions: { id: AdvancedFilterState['priceBracket']; label: string }[] = [
    { id: 'all', label: 'Any Price' },
    { id: 'under_50', label: 'Under ₹50' },
    { id: '50_150', label: '₹50 – ₹150' },
    { id: '150_300', label: '₹150 – ₹300' },
    { id: 'above_300', label: 'Above ₹300' },
  ];

  const sortOptions: { id: AdvancedFilterState['sortBy']; label: string; icon?: string }[] = [
    { id: 'featured', label: 'Featured & Popular' },
    { id: 'price_asc', label: 'Price: Low to High' },
    { id: 'price_desc', label: 'Price: High to Low' },
    { id: 'rating', label: 'Customer Rating (4★+)' },
    { id: 'discount', label: 'Biggest Discount %' },
  ];

  const activeCount =
    (filters.dietary !== 'all' ? 1 : 0) +
    (filters.priceBracket !== 'all' ? 1 : 0) +
    (filters.sortBy !== 'featured' ? 1 : 0) +
    (filters.inStockOnly ? 1 : 0) +
    (filters.brand && filters.brand !== 'All' ? 1 : 0);

  const resetAll = () => {
    onFilterChange(INITIAL_FILTER_STATE);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-sm animate-fadeIn">
      <div className="bg-slate-900 border border-slate-700/80 rounded-3xl max-w-lg w-full max-h-[90vh] flex flex-col shadow-2xl overflow-hidden text-white">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-800/40">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-teal-500/20 text-teal-400 flex items-center justify-center">
              <SlidersHorizontal className="w-4 h-4" />
            </div>
            <div>
              <h2 className="text-lg font-bold">Filter & Sort</h2>
              <p className="text-xs text-slate-400">
                {activeCount > 0 ? `${activeCount} active filter${activeCount > 1 ? 's' : ''}` : 'Refine catalog products'}
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-9 h-9 rounded-full bg-slate-800 hover:bg-slate-700 flex items-center justify-center text-slate-400 hover:text-white transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Scrollable Content */}
        <div className="flex-1 overflow-y-auto px-6 py-5 space-y-6 scrollbar-thin scrollbar-thumb-slate-700">
          {/* 1. Sort By */}
          <div>
            <h3 className="text-xs uppercase tracking-wider font-bold text-teal-400 mb-3">Sort By</h3>
            <div className="grid grid-cols-2 gap-2">
              {sortOptions.map((opt) => {
                const isSelected = filters.sortBy === opt.id;
                return (
                  <button
                    key={opt.id}
                    onClick={() => onFilterChange({ ...filters, sortBy: opt.id })}
                    className={`flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-semibold border transition ${
                      isSelected
                        ? 'border-teal-500 bg-teal-500/10 text-teal-300 shadow-sm'
                        : 'border-slate-800 bg-slate-800/50 text-slate-300 hover:border-slate-700'
                    }`}
                  >
                    <span>{opt.label}</span>
                    {isSelected && <Check className="w-3.5 h-3.5 text-teal-400" />}
                  </button>
                );
              })}
            </div>
          </div>

          {/* 2. Dietary Preferences */}
          <div>
            <h3 className="text-xs uppercase tracking-wider font-bold text-teal-400 mb-3">Dietary & Lifestyle</h3>
            <div className="flex flex-wrap gap-2">
              {dietaryOptions.map((opt) => {
                const isSelected = filters.dietary === opt.id;
                return (
                  <button
                    key={opt.id}
                    onClick={() => onFilterChange({ ...filters, dietary: opt.id })}
                    className={`flex items-center gap-1.5 px-3.5 py-2 rounded-xl text-xs font-semibold border transition ${
                      isSelected
                        ? 'border-teal-500 bg-teal-500 text-slate-950 font-bold shadow-md shadow-teal-500/20'
                        : 'border-slate-800 bg-slate-800/50 text-slate-300 hover:border-slate-700 hover:bg-slate-800'
                    }`}
                  >
                    <span>{opt.badge}</span>
                    <span>{opt.label}</span>
                  </button>
                );
              })}
            </div>
          </div>

          {/* 3. Price Bracket */}
          <div>
            <h3 className="text-xs uppercase tracking-wider font-bold text-teal-400 mb-3">Price Range</h3>
            <div className="flex flex-wrap gap-2">
              {priceOptions.map((opt) => {
                const isSelected = filters.priceBracket === opt.id;
                return (
                  <button
                    key={opt.id}
                    onClick={() => onFilterChange({ ...filters, priceBracket: opt.id })}
                    className={`px-3.5 py-2 rounded-xl text-xs font-semibold border transition ${
                      isSelected
                        ? 'border-teal-500 bg-teal-500 text-slate-950 font-bold'
                        : 'border-slate-800 bg-slate-800/50 text-slate-300 hover:border-slate-700'
                    }`}
                  >
                    {opt.label}
                  </button>
                );
              })}
            </div>
          </div>

          {/* 4. In-Stock Only Toggle */}
          <div className="flex items-center justify-between p-4 rounded-2xl border border-slate-800 bg-slate-800/30">
            <div>
              <div className="font-semibold text-sm">In-Stock Items Only</div>
              <div className="text-xs text-slate-400">Exclude products currently sold out in dark store</div>
            </div>
            <button
              onClick={() => onFilterChange({ ...filters, inStockOnly: !filters.inStockOnly })}
              className={`w-12 h-6 rounded-full p-1 transition flex items-center ${
                filters.inStockOnly ? 'bg-teal-500 justify-end' : 'bg-slate-700 justify-start'
              }`}
            >
              <div className="w-4 h-4 rounded-full bg-white shadow-md" />
            </button>
          </div>

          {/* 5. Brand Selector */}
          {availableBrands.length > 0 && (
            <div>
              <h3 className="text-xs uppercase tracking-wider font-bold text-teal-400 mb-3">Brand</h3>
              <div className="flex flex-wrap gap-2">
                <button
                  onClick={() => onFilterChange({ ...filters, brand: undefined })}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition ${
                    !filters.brand
                      ? 'border-teal-500 bg-teal-500/10 text-teal-300 font-bold'
                      : 'border-slate-800 text-slate-400 hover:text-white'
                  }`}
                >
                  All Brands
                </button>
                {availableBrands.map((b) => {
                  const isSelected = filters.brand === b;
                  return (
                    <button
                      key={b}
                      onClick={() => onFilterChange({ ...filters, brand: isSelected ? undefined : b })}
                      className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition ${
                        isSelected
                          ? 'border-teal-500 bg-teal-500/10 text-teal-300 font-bold'
                          : 'border-slate-800 text-slate-400 hover:text-white'
                      }`}
                    >
                      {b}
                    </button>
                  );
                })}
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="p-4 px-6 border-t border-slate-800 bg-slate-800/40 flex items-center justify-between gap-3">
          <button
            onClick={resetAll}
            disabled={activeCount === 0}
            className="flex items-center gap-1.5 text-xs text-slate-400 hover:text-white disabled:opacity-30 disabled:hover:text-slate-400 transition"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            Reset
          </button>

          <button
            onClick={onClose}
            className="bg-teal-500 hover:bg-teal-400 text-slate-950 font-bold px-6 py-2.5 rounded-xl text-xs flex items-center gap-2 shadow-lg shadow-teal-500/20 transition"
          >
            <span>Apply Filters</span>
            {typeof totalMatches === 'number' && (
              <span className="bg-slate-950/20 px-2 py-0.5 rounded-md font-extrabold">{totalMatches} items</span>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
