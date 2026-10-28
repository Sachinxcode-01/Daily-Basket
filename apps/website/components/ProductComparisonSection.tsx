/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState } from 'react';
import { Sparkles, Check, X, Plus, CheckCircle2, ShieldCheck, Scale } from 'lucide-react';
import { formatCurrency } from '@daily-basket/shared-utils';
import { ProductComparisonData, ProductComparisonItem } from '../lib/catalog';
import { useCart } from '../store/useCart';

interface ProductComparisonSectionProps {
  comparisonData: ProductComparisonData | null;
}

export function ProductComparisonSection({ comparisonData }: ProductComparisonSectionProps) {
  const { addItem } = useCart();
  const [addedItemIds, setAddedItemIds] = useState<Set<string>>(new Set());

  if (!comparisonData || comparisonData.competitors.length === 0) {
    return null;
  }

  const allItems: ProductComparisonItem[] = [
    comparisonData.currentProduct,
    ...comparisonData.competitors,
  ];

  const handleAddToCart = (item: ProductComparisonItem) => {
    addItem.mutate({
      variantId: item.variantId || `var_${item.id}`,
      productName: item.name,
      unitName: item.unitName,
      price: item.price,
      quantity: 1,
    });
    setAddedItemIds((prev) => new Set(prev).add(item.id));
    setTimeout(() => {
      setAddedItemIds((prev) => {
        const next = new Set(prev);
        next.delete(item.id);
        return next;
      });
    }, 2000);
  };

  return (
    <div className="border border-[#e2e2e5] rounded-2xl bg-white p-5 sm:p-6 shadow-xs">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-5">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-full bg-[#2d9d43]/10 text-[#2d9d43] flex items-center justify-center flex-shrink-0">
            <Scale className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-lg font-bold text-[#191c1e]" style={{ fontFamily: 'Outfit' }}>
              Compare with Similar Products
            </h3>
            <p className="text-xs text-[#64748b]">
              Side-by-side comparison in {comparisonData.categoryName} to help you make the best choice
            </p>
          </div>
        </div>

        <span className="self-start sm:self-auto text-[11px] font-bold text-[#15803d] bg-emerald-50 border border-emerald-200 px-3 py-1 rounded-full flex items-center gap-1.5">
          <Sparkles className="w-3.5 h-3.5 text-[#2d9d43]" /> Smart Comparison
        </span>
      </div>

      {/* Comparison Grid Table */}
      <div className="overflow-x-auto scrollbar-none pb-2">
        <table className="w-full text-left border-collapse min-w-[580px]">
          <thead>
            <tr>
              <th className="p-3 bg-[#f9f9fc] rounded-l-xl text-xs font-semibold text-[#64748b] w-1/4">
                Attributes
              </th>
              {allItems.map((item) => (
                <th
                  key={item.id}
                  className={`p-3 text-center align-top ${
                    item.isCurrent
                      ? 'bg-emerald-50/70 border-x-2 border-t-2 border-[#2d9d43] rounded-t-xl'
                      : 'bg-[#f9f9fc]'
                  }`}
                >
                  <div className="flex flex-col items-center">
                    {item.badge && (
                      <span
                        className={`text-[10px] font-extrabold uppercase px-2 py-0.5 rounded-full mb-2 ${
                          item.isCurrent
                            ? 'bg-[#2d9d43] text-white'
                            : 'bg-slate-200 text-slate-700'
                        }`}
                      >
                        {item.badge}
                      </span>
                    )}
                    <img
                      src={item.imageUrl}
                      alt={item.name}
                      className="w-16 h-16 object-contain rounded-xl bg-white border border-[#eceef0] p-1 mb-2"
                    />
                    <h4 className="text-xs font-bold text-[#191c1e] line-clamp-2 text-center h-8">
                      {item.name}
                    </h4>
                    <span className="text-[11px] text-[#64748b] mt-0.5">{item.brand}</span>
                  </div>
                </th>
              ))}
            </tr>
          </thead>

          <tbody className="divide-y divide-[#eceef0] text-xs">
            {/* Price Row */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Price & Savings</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center ${
                    item.isCurrent ? 'bg-emerald-50/70 border-x-2 border-[#2d9d43]' : ''
                  }`}
                >
                  <div className="flex items-center justify-center gap-1.5">
                    <span className="font-extrabold text-sm text-[#191c1e]">
                      {formatCurrency(item.price)}
                    </span>
                    {item.mrp > item.price && (
                      <span className="text-[11px] text-[#64748b] line-through">
                        {formatCurrency(item.mrp)}
                      </span>
                    )}
                  </div>
                  {item.discount > 0 && (
                    <span className="text-[10px] font-bold text-[#15803d]">
                      {item.discount}% OFF
                    </span>
                  )}
                </td>
              ))}
            </tr>

            {/* Pack Size Row */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Pack Size</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center text-[#191c1e] font-medium ${
                    item.isCurrent ? 'bg-emerald-50/70 border-x-2 border-[#2d9d43]' : ''
                  }`}
                >
                  {item.unitName}
                </td>
              ))}
            </tr>

            {/* Customer Rating Row */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Customer Rating</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center ${
                    item.isCurrent ? 'bg-emerald-50/70 border-x-2 border-[#2d9d43]' : ''
                  }`}
                >
                  <div className="flex items-center justify-center gap-1">
                    <span className="font-bold text-[#191c1e]">{item.rating}</span>
                    <span className="text-amber-400">★</span>
                    <span className="text-[10px] text-[#64748b]">({item.reviews})</span>
                  </div>
                </td>
              ))}
            </tr>

            {/* Organic / Dietary Row */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Dietary Category</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center ${
                    item.isCurrent ? 'bg-emerald-50/70 border-x-2 border-[#2d9d43]' : ''
                  }`}
                >
                  <div className="flex items-center justify-center gap-1">
                    {item.isOrganic ? (
                      <span className="text-[11px] font-bold text-[#15803d] flex items-center gap-1">
                        <Check className="w-3.5 h-3.5" /> Certified Organic
                      </span>
                    ) : (
                      <span className="text-[11px] text-[#64748b]">Farm Fresh Daily</span>
                    )}
                  </div>
                </td>
              ))}
            </tr>

            {/* Calories / Nutrition Row */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Energy / Calories</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center text-[#191c1e] ${
                    item.isCurrent ? 'bg-emerald-50/70 border-x-2 border-[#2d9d43]' : ''
                  }`}
                >
                  {item.calories}
                </td>
              ))}
            </tr>

            {/* Delivery Time */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Delivery Speed</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center font-bold text-[#2d9d43] ${
                    item.isCurrent ? 'bg-emerald-50/70 border-x-2 border-[#2d9d43]' : ''
                  }`}
                >
                  ⚡ {item.deliveryTime}
                </td>
              ))}
            </tr>

            {/* Action Row */}
            <tr>
              <td className="p-3 font-semibold text-[#3f4a3d]">Action</td>
              {allItems.map((item) => (
                <td
                  key={item.id}
                  className={`p-3 text-center ${
                    item.isCurrent
                      ? 'bg-emerald-50/70 border-x-2 border-b-2 border-[#2d9d43] rounded-b-xl'
                      : ''
                  }`}
                >
                  <button
                    onClick={() => handleAddToCart(item)}
                    className={`w-full py-2 px-3 text-xs font-bold rounded-xl transition flex items-center justify-center gap-1.5 active:scale-95 shadow-xs ${
                      addedItemIds.has(item.id)
                        ? 'bg-[#15803d] text-white'
                        : item.isCurrent
                        ? 'bg-[#2d9d43] hover:bg-[#078730] text-white'
                        : 'bg-white border border-[#2d9d43] text-[#2d9d43] hover:bg-emerald-50'
                    }`}
                  >
                    {addedItemIds.has(item.id) ? (
                      <>
                        <CheckCircle2 className="w-3.5 h-3.5 text-white" />
                        <span>✓ Added</span>
                      </>
                    ) : (
                      <>
                        <Plus className="w-3.5 h-3.5" />
                        <span>Add to Cart</span>
                      </>
                    )}
                  </button>
                </td>
              ))}
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
