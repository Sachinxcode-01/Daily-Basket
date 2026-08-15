/* eslint-disable @next/next/no-img-element */
'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function ProductDetailsPage({ params }: { params: { id?: string } }) {
  const [selectedWeight, setSelectedWeight] = useState<'500g' | '1kg'>('500g');
  const [quantity, setQuantity] = useState(1);
  const [activeThumb, setActiveThumb] = useState(0);
  const [isFavorited, setIsFavorited] = useState(false);
  const [detailsOpen, setDetailsOpen] = useState(true);
  const [nutritionOpen, setNutritionOpen] = useState(false);

  const images = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAUZTLTSv5m1XvtD0eVooGUshRAE_TEf1VJ6rDo2p2NK8V-OtAgWRr9FnG7_wymxfNYoJbO-z3fuiHP_nel0NrAMmwbjTaJpS2Qn6gtKhCoGN6ltUY0Ye1kqsw-Lgi3oSwN5RBZcGCyK2PH3mZqTsqvfYztVjk3FZnajEMLUCbI6q8oB1hqEySrz4h9bFTXR1c7DcEprHGwUvQVM7TEPLq83eHICr5VanKASkHt7mYjWh7jE8sEGGd1',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBbsg5VxbvT11uRXXDRayoEzYGroBN6JL_q3OdBRxTV_NhUsAgXOLVnLt2AP4FjQ1VeLJ9Nu66ZOkgTwSPghddjYzSFJFH-nX61SZBAAjCBTQkjHnkshnkB9KTRoZj4KrKjCVLIhIkvkcNqEk4h79BfvPd-dbBBLoCQ-CEHU411SdMlg7TerXu1-n2q_kyKG2QiY7Cx6HvI4O9yNH2j5DTrGLp3HLDv5C71JMkQhsDUBUD-USNQ7Z-F',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBxT-WRocvozm2WhECnL8JMwxCqiEnuJ7cKtNoLv-llUuIz1dEY2oBp5MdWHKwKfTDfhmhcZUDYamNJeXMOiQDXQErt0WRFRSJzAY4cxjLnMqG5f-EZz7kvpru8TOviGd0RTYku3CEMtUC_JLe6zQqHimHXCBkpnyde4yFl2cThVNJlqY4w66MTA4r1xi322PjWVu4NCiQxhPP4RjdOUhB39s8SgVQHbIIYzVhJX5H3YENCU6jqp-7U',
  ];

  const price = selectedWeight === '500g' ? 5.99 : 10.99;
  const mrp = selectedWeight === '500g' ? 7.50 : 13.50;

  return (
    <div className="bg-[#f9f9fc] text-[#1a1c1e] font-sans antialiased pb-24 md:pb-0 min-h-screen">
      {/* TopAppBar */}
      <header className="fixed top-0 w-full z-50 bg-[#f9f9fc]/80 backdrop-blur-xl shadow-sm flex items-center justify-between px-4 h-16">
        <Link href="/" className="text-[#006b23] p-2 -ml-2 rounded-full hover:opacity-80 transition-opacity">
          <span className="material-symbols-outlined">arrow_back</span>
        </Link>
        <div className="font-headline text-xl font-bold text-[#006b23]">Daily Basket</div>
        <button className="text-[#006b23] p-2 -mr-2 rounded-full hover:opacity-80 transition-opacity">
          <span className="material-symbols-outlined">search</span>
        </button>
      </header>

      {/* Main Container */}
      <main className="pt-16 max-w-7xl mx-auto md:grid md:grid-cols-2 md:gap-8 md:p-12 md:pt-24">
        {/* Image Gallery Section */}
        <section className="relative md:sticky md:top-24 h-fit">
          <div className="relative w-full aspect-square md:rounded-2xl overflow-hidden bg-[#f3f3f6]">
            <img
              src={images[activeThumb]}
              alt="Organic Hass Avocados"
              className="w-full h-full object-cover"
            />

            {/* Top Right Overlays */}
            <div className="absolute top-4 right-4 flex flex-col gap-3">
              <button
                onClick={() => setIsFavorited(!isFavorited)}
                className="w-10 h-10 rounded-full bg-white/80 backdrop-blur-md flex items-center justify-center text-[#1a1c1e] hover:bg-white transition-colors shadow-sm"
              >
                <span className={`material-symbols-outlined ${isFavorited ? 'fill text-rose-600' : ''}`}>
                  favorite
                </span>
              </button>
              <button className="w-10 h-10 rounded-full bg-white/80 backdrop-blur-md flex items-center justify-center text-[#1a1c1e] hover:bg-white transition-colors shadow-sm">
                <span className="material-symbols-outlined">share</span>
              </button>
            </div>

            {/* Organic Chip */}
            <div className="absolute top-4 left-4 bg-[#078730] text-[#f7fff2] px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1 shadow-sm">
              <span className="material-symbols-outlined text-[16px]">eco</span>
              Certified Organic
            </div>
          </div>

          {/* Thumbnails */}
          <div className="flex gap-4 p-4 md:p-0 md:mt-4 overflow-x-auto">
            {images.map((img, index) => (
              <div
                key={index}
                onClick={() => setActiveThumb(index)}
                className={`w-20 h-20 rounded-xl overflow-hidden border-2 cursor-pointer flex-shrink-0 transition-all ${
                  activeThumb === index ? 'border-[#006b23]' : 'border-transparent opacity-70 hover:opacity-100'
                }`}
              >
                <img src={img} alt={`Thumbnail ${index + 1}`} className="w-full h-full object-cover" />
              </div>
            ))}
          </div>
        </section>

        {/* Product Details Section */}
        <section className="px-4 md:px-0 flex flex-col gap-6">
          {/* Header Info */}
          <div>
            <p className="text-[#006b23] text-sm font-semibold mb-1">Fresh Farm Co.</p>
            <h1 className="font-headline text-3xl md:text-4xl font-bold text-[#1a1c1e] mb-2">
              Organic Hass Avocados
            </h1>
            <div className="flex items-center gap-2 mb-4">
              <div className="flex items-center text-[#F59E0B]">
                <span className="material-symbols-outlined fill text-[18px]">star</span>
                <span className="material-symbols-outlined fill text-[18px]">star</span>
                <span className="material-symbols-outlined fill text-[18px]">star</span>
                <span className="material-symbols-outlined fill text-[18px]">star</span>
                <span className="material-symbols-outlined text-[18px]">star_half</span>
              </div>
              <span className="text-[#3f4a3d] text-sm">(128 Reviews)</span>
            </div>

            <div className="flex items-end gap-3 mb-2">
              <span className="font-headline text-3xl font-bold text-[#1a1c1e]">
                ${(price * quantity).toFixed(2)}
              </span>
              <span className="text-[#3f4a3d] line-through text-lg mb-1">
                ${(mrp * quantity).toFixed(2)}
              </span>
              <span className="bg-[#ffdad6] text-[#93000a] px-2 py-0.5 rounded-md text-xs font-bold mb-1.5">
                -20%
              </span>
            </div>
            <p className="text-[#3f4a3d] text-sm">
              Delivery in <span className="font-semibold text-[#006b23]">15-30 mins</span>
            </p>
          </div>

          {/* Weight Selection */}
          <div className="border-t border-[#e2e2e5] pt-6">
            <h3 className="font-headline text-lg font-semibold mb-3 text-[#1a1c1e]">Select Weight</h3>
            <div className="flex gap-3">
              <button
                onClick={() => setSelectedWeight('500g')}
                className={`flex-1 py-3 px-4 rounded-xl border-2 font-semibold flex flex-col items-center justify-center transition-all ${
                  selectedWeight === '500g'
                    ? 'border-[#006b23] bg-[#006b23]/5 text-[#006b23]'
                    : 'border-[#e2e2e5] text-[#3f4a3d] hover:bg-[#eeeef0]'
                }`}
              >
                <span className="text-lg">500g</span>
                <span className="text-xs opacity-80">~3-4 pieces</span>
              </button>

              <button
                onClick={() => setSelectedWeight('1kg')}
                className={`flex-1 py-3 px-4 rounded-xl border-2 font-semibold flex flex-col items-center justify-center transition-all ${
                  selectedWeight === '1kg'
                    ? 'border-[#006b23] bg-[#006b23]/5 text-[#006b23]'
                    : 'border-[#e2e2e5] text-[#3f4a3d] hover:bg-[#eeeef0]'
                }`}
              >
                <span className="text-lg">1kg</span>
                <span className="text-xs opacity-80">~6-8 pieces</span>
              </button>
            </div>
          </div>

          {/* Ask AI Chef Bento Box */}
          <div className="bg-[#dce5dd]/30 border border-[#dce5dd] rounded-2xl p-5 relative overflow-hidden group cursor-pointer hover:bg-[#dce5dd]/50 transition-colors">
            <div className="flex items-start gap-4 relative z-10">
              <div className="w-10 h-10 rounded-full bg-[#006b23] text-white flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined">auto_awesome</span>
              </div>
              <div>
                <h3 className="font-headline text-lg font-semibold text-[#1a1c1e] mb-1">Ask AI Chef</h3>
                <p className="text-[#3f4a3d] text-sm mb-3">
                  Get instant recipe ideas, pairing suggestions, or nutritional breakdowns for these avocados.
                </p>
                <div className="flex gap-2">
                  <span className="bg-white px-3 py-1 rounded-full text-xs text-[#1a1c1e] border border-[#e2e2e5] shadow-sm hover:border-[#006b23] transition-colors">
                    Guacamole recipe
                  </span>
                  <span className="bg-white px-3 py-1 rounded-full text-xs text-[#1a1c1e] border border-[#e2e2e5] shadow-sm hover:border-[#006b23] transition-colors">
                    Ripening tips
                  </span>
                </div>
              </div>
            </div>
          </div>

          {/* Accordion Details */}
          <div className="mt-4 flex flex-col gap-4">
            {/* Description */}
            <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white">
              <button
                onClick={() => setDetailsOpen(!detailsOpen)}
                className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f3f3f6] transition-colors"
              >
                <span className="font-headline font-semibold text-[#1a1c1e]">Product Details</span>
                <span className={`material-symbols-outlined transition-transform duration-300 ${detailsOpen ? 'rotate-180' : ''}`}>
                  expand_more
                </span>
              </button>
              {detailsOpen && (
                <div className="p-4 pt-0 text-sm text-[#3f4a3d] leading-relaxed border-t border-[#e2e2e5]">
                  Our premium Hass avocados are organically grown, hand-picked, and delivered at the perfect stage of ripeness. Known for their creamy texture and rich, nutty flavor, they are perfect for salads, toast, or your favorite guacamole recipe.
                </div>
              )}
            </div>

            {/* Nutrition */}
            <div className="border border-[#e2e2e5] rounded-2xl overflow-hidden bg-white">
              <button
                onClick={() => setNutritionOpen(!nutritionOpen)}
                className="w-full flex items-center justify-between p-4 text-left hover:bg-[#f3f3f6] transition-colors"
              >
                <span className="font-headline font-semibold text-[#1a1c1e]">Nutritional Info (per 100g)</span>
                <span className={`material-symbols-outlined transition-transform duration-300 ${nutritionOpen ? 'rotate-180' : ''}`}>
                  expand_more
                </span>
              </button>
              {nutritionOpen && (
                <div className="p-4 pt-0 border-t border-[#e2e2e5]">
                  <ul className="flex flex-col gap-2 mt-3 text-sm">
                    <li className="flex justify-between border-b border-[#e2e2e5]/50 pb-1">
                      <span className="text-[#3f4a3d]">Calories</span>
                      <span className="font-medium text-[#1a1c1e]">160 kcal</span>
                    </li>
                    <li className="flex justify-between border-b border-[#e2e2e5]/50 pb-1">
                      <span className="text-[#3f4a3d]">Fat</span>
                      <span className="font-medium text-[#1a1c1e]">15g</span>
                    </li>
                    <li className="flex justify-between border-b border-[#e2e2e5]/50 pb-1">
                      <span className="text-[#3f4a3d]">Carbs</span>
                      <span className="font-medium text-[#1a1c1e]">9g</span>
                    </li>
                    <li className="flex justify-between border-b border-[#e2e2e5]/50 pb-1">
                      <span className="text-[#3f4a3d]">Protein</span>
                      <span className="font-medium text-[#1a1c1e]">2g</span>
                    </li>
                  </ul>
                </div>
              )}
            </div>
          </div>
        </section>
      </main>

      {/* Bottom Action Bar */}
      <div className="fixed bottom-0 left-0 w-full bg-white border-t border-[#e2e2e5] p-4 z-40 md:relative md:border-none md:p-0 md:mt-8 md:bg-transparent">
        <div className="max-w-7xl mx-auto flex gap-4 md:justify-end">
          <div className="flex items-center justify-between bg-[#eeeef0] rounded-xl px-2 h-14 md:w-32 border border-[#e2e2e5]">
            <button
              onClick={() => setQuantity(Math.max(1, quantity - 1))}
              className="w-10 h-10 flex items-center justify-center text-[#1a1c1e] hover:bg-[#e2e2e5] rounded-lg transition-colors"
            >
              <span className="material-symbols-outlined">remove</span>
            </button>
            <span className="font-headline font-semibold text-lg w-8 text-center">{quantity}</span>
            <button
              onClick={() => setQuantity(quantity + 1)}
              className="w-10 h-10 flex items-center justify-center text-[#1a1c1e] hover:bg-[#e2e2e5] rounded-lg transition-colors"
            >
              <span className="material-symbols-outlined">add</span>
            </button>
          </div>

          <button className="flex-1 md:flex-none md:w-64 bg-[#006b23] hover:bg-[#078730] text-white font-headline font-semibold text-lg rounded-xl h-14 flex items-center justify-center shadow-md active:scale-95 transition-all">
            Add to Cart - ${(price * quantity).toFixed(2)}
          </button>
        </div>
      </div>
    </div>
  );
}
