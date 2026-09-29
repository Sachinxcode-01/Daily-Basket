// Google Stitch Screen ID: dc03d5c76b814f639becc038ad8805bb
// Title: Daily Basket - Premium Home Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/staggered_animation_wrappers.dart';
import '../../../../core/widgets/app_motion.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../categories/presentation/screens/browse_categories_screen.dart';
import '../../../search/presentation/screens/search_results_screen.dart';
import '../../../search/presentation/widgets/voice_search_dialog.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/order_history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../catalog/presentation/screens/product_listing_screen.dart';
import '../widgets/quick_services_section.dart';
import '../widgets/recently_viewed_section.dart';
import '../widgets/buy_again_section.dart';

class _Product {
  final String id, name, brand, unit, price, mrp, imageUrl, category;
  final double rating;
  final int reviews;
  final String discountPercentage;

  const _Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.unit,
    required this.price,
    required this.mrp,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.category,
    this.discountPercentage = '',
  });

  String get computedDiscount {
    if (discountPercentage.isNotEmpty) return discountPercentage;
    final p = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final m = double.tryParse(mrp.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    if (m > p && m > 0) {
      final pct = (((m - p) / m) * 100).round();
      if (pct > 0) return '$pct% OFF';
    }
    return '';
  }
}

// ─── 1. Daily Selling Products (Essential Morning Staples) ────────────────────
const _dailySelling = <_Product>[
  _Product(
    id: 'ds_ban1',
    name: 'Fresh Robusta Bananas (Kela)',
    brand: 'Farm Fresh',
    unit: '500 g (3-4 pcs)',
    price: r'₹38',
    mrp: r'₹45',
    rating: 4.8,
    reviews: 1420,
    imageUrl: 'assets/products/fresh-vegetables/2483b1e4-6b95-4777-82ba-9ea62a37f40d.png',
    category: 'Vegetables',
    discountPercentage: '16% OFF',
  ),
  _Product(
    id: 'ds_mlk1',
    name: 'Amul Taaza Homogenised Toned Milk',
    brand: 'Amul',
    unit: '1 L Pouch',
    price: r'₹54',
    mrp: r'₹58',
    rating: 4.9,
    reviews: 8420,
    imageUrl: 'assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
    category: 'Milk',
    discountPercentage: '7% OFF',
  ),
  _Product(
    id: 'ds_veg1',
    name: 'Fresh Hybrid Tomatoes (Tamatar)',
    brand: 'Farm Fresh',
    unit: '500 g',
    price: r'₹24',
    mrp: r'₹28',
    rating: 4.8,
    reviews: 9850,
    imageUrl: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    category: 'Vegetables',
    discountPercentage: '14% OFF',
  ),
  _Product(
    id: 'ds_brd1',
    name: 'Harvest Gold 100% Whole Wheat Bread',
    brand: 'Harvest Gold',
    unit: '400 g Pack',
    price: r'₹45',
    mrp: r'₹50',
    rating: 4.7,
    reviews: 6300,
    imageUrl: 'assets/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
    category: 'Bread & Bakery',
    discountPercentage: '10% OFF',
  ),
  _Product(
    id: 'ds_crd1',
    name: 'Amul Masti Dahi Set Curd',
    brand: 'Amul',
    unit: '400 g Cup',
    price: r'₹35',
    mrp: r'₹40',
    rating: 4.8,
    reviews: 5400,
    imageUrl: 'assets/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
    category: 'Curd & Yogurt',
    discountPercentage: '12% OFF',
  ),
  _Product(
    id: 'ds_poh1',
    name: 'Tata Sampann Thick Poha (Flattened Rice)',
    brand: 'Tata Sampann',
    unit: '500 g Pack',
    price: r'₹48',
    mrp: r'₹58',
    rating: 4.7,
    reviews: 4200,
    imageUrl: 'assets/products/poha-daliya-grains/1092_1643384330629.png',
    category: 'Poha & Grains',
    discountPercentage: '17% OFF',
  ),
  _Product(
    id: 'ds_vrm1',
    name: 'MTR Roasted Vermicelli (Seviyan)',
    brand: 'MTR',
    unit: '400 g Pack',
    price: r'₹42',
    mrp: r'₹50',
    rating: 4.6,
    reviews: 3200,
    imageUrl: 'assets/products/vermicelli/3da21b8f-16e5-4727-9899-c5ef3e1db668.png',
    category: 'Vermicelli',
    discountPercentage: '16% OFF',
  ),
  _Product(
    id: 'ds_cer1',
    name: 'Kellogg\'s Crunchy Corn Flakes',
    brand: 'Kellogg\'s',
    unit: '475 g Box',
    price: r'₹165',
    mrp: r'₹195',
    rating: 4.8,
    reviews: 5100,
    imageUrl: 'assets/products/flakes-kids-cereals/01e92a08-b40b-4d6f-aca7-8537cd382447.png',
    category: 'Cereals',
    discountPercentage: '15% OFF',
  ),
];

// ─── 2. High Selling Products (Top Volume Bestsellers) ────────────────────────
const _highSelling = <_Product>[
  _Product(
    id: 'hs_oni1',
    name: 'Fresh Nashik Red Onions (Pyaz)',
    brand: 'Farm Fresh',
    unit: '1 kg',
    price: r'₹38',
    mrp: r'₹48',
    rating: 4.8,
    reviews: 18900,
    imageUrl: 'assets/products/fresh-vegetables/02df8262-1ccc-4078-a215-991a85ded7b0.png',
    category: 'Vegetables',
    discountPercentage: '21% OFF',
  ),
  _Product(
    id: 'hs_mlk1',
    name: 'Nandini Pure Cow Milk',
    brand: 'Nandini',
    unit: '500 ml Pouch',
    price: r'₹26',
    mrp: r'₹28',
    rating: 4.7,
    reviews: 6100,
    imageUrl: 'assets/products/milk/20c80cb9-33fb-4d4f-bdde-91ffa4490e57.png',
    category: 'Milk',
    discountPercentage: '7% OFF',
  ),
  _Product(
    id: 'hs_pot1',
    name: 'Jyoti Premium Potatoes (Aloo)',
    brand: 'Farm Fresh',
    unit: '1 kg',
    price: r'₹32',
    mrp: r'₹40',
    rating: 4.7,
    reviews: 14200,
    imageUrl: 'assets/products/fresh-vegetables/00f0d26a-7b61-4e84-8903-abed0e2c4f69.png',
    category: 'Vegetables',
    discountPercentage: '20% OFF',
  ),
  _Product(
    id: 'hs_pav1',
    name: 'Fresh Soft Ladi Pav (Bakery Made)',
    brand: 'Bakery Fresh',
    unit: '6 pcs Pack',
    price: r'₹22',
    mrp: r'₹25',
    rating: 4.8,
    reviews: 8900,
    imageUrl: 'assets/products/bread-pav/036bad6d-4fbc-4c42-a18a-4bf33a3dfb6b.png',
    category: 'Bread & Bakery',
    discountPercentage: '12% OFF',
  ),
  _Product(
    id: 'hs_yog1',
    name: 'Epigamia Greek Yogurt Natural',
    brand: 'Epigamia',
    unit: '100 g Cup',
    price: r'₹50',
    mrp: r'₹60',
    rating: 4.7,
    reviews: 4300,
    imageUrl: 'assets/products/curd-yogurt/04dbb266-d965-4447-ba2c-655f725b47f5.png',
    category: 'Curd & Yogurt',
    discountPercentage: '17% OFF',
  ),
  _Product(
    id: 'hs_dal1',
    name: 'Fortune Roasted Wheat Dalia',
    brand: 'Fortune',
    unit: '500 g Pack',
    price: r'₹38',
    mrp: r'₹45',
    rating: 4.6,
    reviews: 3800,
    imageUrl: 'assets/products/poha-daliya-grains/1140_1643384951835.png',
    category: 'Poha & Grains',
    discountPercentage: '15% OFF',
  ),
  _Product(
    id: 'hs_vrm1',
    name: 'Bambino Roasted Seviyan Vermicelli',
    brand: 'Bambino',
    unit: '400 g Pack',
    price: r'₹39',
    mrp: r'₹48',
    rating: 4.6,
    reviews: 4900,
    imageUrl: 'assets/products/vermicelli/4bf7f974-20b4-48b8-9367-f60997e8b940.png',
    category: 'Vermicelli',
    discountPercentage: '19% OFF',
  ),
  _Product(
    id: 'hs_chc1',
    name: 'Kellogg\'s Choco Fills Cereal',
    brand: 'Kellogg\'s',
    unit: '250 g Box',
    price: r'₹125',
    mrp: r'₹145',
    rating: 4.8,
    reviews: 7200,
    imageUrl: 'assets/products/flakes-kids-cereals/09a1e487-9781-4ade-ab0e-73327c96691e.png',
    category: 'Cereals',
    discountPercentage: '14% OFF',
  ),
];

// ─── 3. Recommended For You (Smart Personalization) ───────────────────────────
const _recommended = <_Product>[
  _Product(
    id: 'rc_ban1',
    name: 'Fresh Yelakki Sweet Bananas',
    brand: 'Farm Fresh',
    unit: '500 g',
    price: r'₹44',
    mrp: r'₹55',
    rating: 4.9,
    reviews: 3100,
    imageUrl: 'assets/products/fresh-vegetables/2483b1e4-6b95-4777-82ba-9ea62a37f40d.png',
    category: 'Vegetables',
    discountPercentage: '20% OFF',
  ),
  _Product(
    id: 'rc_mlk1',
    name: 'Akshayakalpa Organic Cow Milk',
    brand: 'Akshayakalpa',
    unit: '500 ml Bottle',
    price: r'₹46',
    mrp: r'₹52',
    rating: 4.8,
    reviews: 3890,
    imageUrl: 'assets/products/milk/22a31d80-a56a-4241-82ef-8de00a46c9c4.png',
    category: 'Milk',
    discountPercentage: '12% OFF',
  ),
  _Product(
    id: 'rc_spn1',
    name: 'Fresh Hydroponic Baby Spinach (Palak)',
    brand: 'Farm Fresh',
    unit: '250 g Bunch',
    price: r'₹22',
    mrp: r'₹30',
    rating: 4.8,
    reviews: 5120,
    imageUrl: 'assets/products/fresh-vegetables/083c2cf1-36a0-4328-98a1-fbe6e0ec1d0a.png',
    category: 'Vegetables',
    discountPercentage: '26% OFF',
  ),
  _Product(
    id: 'rc_brd1',
    name: 'English Oven 100% Brown Bread',
    brand: 'English Oven',
    unit: '400 g Pack',
    price: r'₹48',
    mrp: r'₹55',
    rating: 4.7,
    reviews: 5200,
    imageUrl: 'assets/products/bread-pav/076a5684-8206-48cc-b730-e1c7fe05e5df.png',
    category: 'Bread & Bakery',
    discountPercentage: '13% OFF',
  ),
  _Product(
    id: 'rc_crd1',
    name: 'Mother Dairy Classic Dahi Tub',
    brand: 'Mother Dairy',
    unit: '400 g Tub',
    price: r'₹38',
    mrp: r'₹42',
    rating: 4.6,
    reviews: 4100,
    imageUrl: 'assets/products/curd-yogurt/057e0c66-77e1-4d90-ab5f-f2afe3aa69d9.png',
    category: 'Curd & Yogurt',
    discountPercentage: '10% OFF',
  ),
  _Product(
    id: 'rc_sab1',
    name: 'Pro Nature Organic Sabudana (Tapioca)',
    brand: 'Pro Nature',
    unit: '500 g Pack',
    price: r'₹72',
    mrp: r'₹85',
    rating: 4.7,
    reviews: 2800,
    imageUrl: 'assets/products/poha-daliya-grains/1184_1661407202472.png',
    category: 'Poha & Grains',
    discountPercentage: '15% OFF',
  ),
  _Product(
    id: 'rc_vrm1',
    name: 'Two Brothers Khapli Wheat Vermicelli',
    brand: 'Two Brothers',
    unit: '500 g Pack',
    price: r'₹160',
    mrp: r'₹190',
    rating: 4.7,
    reviews: 1900,
    imageUrl: 'assets/products/vermicelli/536f1cfb8d75475ba5ff33db6d8c975f.png',
    category: 'Vermicelli',
    discountPercentage: '16% OFF',
  ),
  _Product(
    id: 'rc_cer1',
    name: 'Nestle Koko Krunch Choco Cereal',
    brand: 'Nestle',
    unit: '350 g Box',
    price: r'₹170',
    mrp: r'₹199',
    rating: 4.7,
    reviews: 4300,
    imageUrl: 'assets/products/flakes-kids-cereals/0c447ba4-a230-4b31-92e7-03007bebf0bc.png',
    category: 'Cereals',
    discountPercentage: '15% OFF',
  ),
];

// ─── 4. Top Buying Products (High Customer Repeat Carts) ─────────────────────
const _topBuying = <_Product>[
  _Product(
    id: 'tb_tom1',
    name: 'Country Fresh Hybrid Tomatoes',
    brand: 'Farm Fresh',
    unit: '1 kg Pack',
    price: r'₹45',
    mrp: r'₹55',
    rating: 4.8,
    reviews: 11400,
    imageUrl: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    category: 'Vegetables',
    discountPercentage: '18% OFF',
  ),
  _Product(
    id: 'tb_mlk1',
    name: 'Amul Gold Full Cream Milk',
    brand: 'Amul',
    unit: '1 L Pouch',
    price: r'₹66',
    mrp: r'₹70',
    rating: 4.9,
    reviews: 15400,
    imageUrl: 'assets/products/milk/2cf3020b-eae8-4909-b3b0-fe96c7e4e177.png',
    category: 'Milk',
    discountPercentage: '6% OFF',
  ),
  _Product(
    id: 'tb_cap1',
    name: 'Fresh Green Capsicum (Shimla Mirch)',
    brand: 'Farm Fresh',
    unit: '250 g',
    price: r'₹34',
    mrp: r'₹42',
    rating: 4.7,
    reviews: 6400,
    imageUrl: 'assets/products/fresh-vegetables/079cdbf5-0e6e-4de4-ad0a-447e56ae8016.png',
    category: 'Vegetables',
    discountPercentage: '19% OFF',
  ),
  _Product(
    id: 'tb_brd1',
    name: 'Modern Multigrain Sandwich Bread',
    brand: 'Modern',
    unit: '400 g Pack',
    price: r'₹52',
    mrp: r'₹60',
    rating: 4.6,
    reviews: 4700,
    imageUrl: 'assets/products/bread-pav/0780817d-4d79-4e2f-abe4-5a5725df31b0.png',
    category: 'Bread & Bakery',
    discountPercentage: '13% OFF',
  ),
  _Product(
    id: 'tb_crd1',
    name: 'Milky Mist Farm Curd Pouch',
    brand: 'Milky Mist',
    unit: '450 g Pouch',
    price: r'₹36',
    mrp: r'₹40',
    rating: 4.7,
    reviews: 3900,
    imageUrl: 'assets/products/curd-yogurt/0bcb96d2-7515-41eb-b1d1-7dd218a5a26d.png',
    category: 'Curd & Yogurt',
    discountPercentage: '10% OFF',
  ),
  _Product(
    id: 'tb_poh1',
    name: 'Daily Basket High Fiber Diet Poha',
    brand: 'Daily Basket',
    unit: '500 g Pack',
    price: r'₹52',
    mrp: r'₹65',
    rating: 4.6,
    reviews: 3100,
    imageUrl: 'assets/products/poha-daliya-grains/1295_1643445863467.png',
    category: 'Poha & Grains',
    discountPercentage: '20% OFF',
  ),
  _Product(
    id: 'tb_vrm1',
    name: 'Tata Sampann Roasted Seviyan Vermicelli',
    brand: 'Tata Sampann',
    unit: '400 g Pack',
    price: r'₹45',
    mrp: r'₹55',
    rating: 4.6,
    reviews: 2600,
    imageUrl: 'assets/products/vermicelli/64ca266c-db61-4087-b9f5-2019f2704a3e.png',
    category: 'Vermicelli',
    discountPercentage: '18% OFF',
  ),
  _Product(
    id: 'tb_cer1',
    name: 'Quaker Rolled 100% Whole Oats',
    brand: 'Quaker',
    unit: '400 g Pouch',
    price: r'₹98',
    mrp: r'₹115',
    rating: 4.7,
    reviews: 6200,
    imageUrl: 'assets/products/flakes-kids-cereals/141e68a9-f36a-422f-8746-a9a49359401b.png',
    category: 'Cereals',
    discountPercentage: '15% OFF',
  ),
];

// ─── 5. Full Kirana Essentials Catalog (Grid Feed) ───────────────────────────
const _catalog = <_Product>[
  // Vegetables & Fruits
  _Product(
    id: 'cat_ban1',
    name: 'Fresh Robusta Bananas',
    brand: 'Farm Fresh',
    unit: '500 g (3-4 pcs)',
    price: r'₹38',
    mrp: r'₹45',
    rating: 4.8,
    reviews: 1420,
    imageUrl: 'assets/products/fresh-vegetables/2483b1e4-6b95-4777-82ba-9ea62a37f40d.png',
    category: 'Vegetables',
    discountPercentage: '16% OFF',
  ),
  _Product(
    id: 'cat_tom1',
    name: 'Fresh Hybrid Tomatoes',
    brand: 'Farm Fresh',
    unit: '500 g',
    price: r'₹24',
    mrp: r'₹28',
    rating: 4.8,
    reviews: 9850,
    imageUrl: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    category: 'Vegetables',
    discountPercentage: '14% OFF',
  ),
  _Product(
    id: 'cat_pot1',
    name: 'New Crop Potatoes (Aloo)',
    brand: 'Farm Fresh',
    unit: '1 kg',
    price: r'₹32',
    mrp: r'₹35',
    rating: 4.7,
    reviews: 14200,
    imageUrl: 'assets/products/fresh-vegetables/00f0d26a-7b61-4e84-8903-abed0e2c4f69.png',
    category: 'Vegetables',
    discountPercentage: '9% OFF',
  ),
  _Product(
    id: 'cat_oni1',
    name: 'Fresh Nashik Red Onions',
    brand: 'Farm Fresh',
    unit: '1 kg',
    price: r'₹38',
    mrp: r'₹48',
    rating: 4.8,
    reviews: 18900,
    imageUrl: 'assets/products/fresh-vegetables/02df8262-1ccc-4078-a215-991a85ded7b0.png',
    category: 'Vegetables',
    discountPercentage: '21% OFF',
  ),
  _Product(
    id: 'cat_cap1',
    name: 'Green Capsicum (Shimla Mirch)',
    brand: 'Farm Fresh',
    unit: '250 g',
    price: r'₹36',
    mrp: r'₹40',
    rating: 4.6,
    reviews: 6400,
    imageUrl: 'assets/products/fresh-vegetables/079cdbf5-0e6e-4de4-ad0a-447e56ae8016.png',
    category: 'Vegetables',
    discountPercentage: '10% OFF',
  ),
  _Product(
    id: 'cat_spn1',
    name: 'Hydroponic Baby Spinach (Palak)',
    brand: 'Farm Fresh',
    unit: '250 g',
    price: r'₹22',
    mrp: r'₹30',
    rating: 4.9,
    reviews: 5120,
    imageUrl: 'assets/products/fresh-vegetables/083c2cf1-36a0-4328-98a1-fbe6e0ec1d0a.png',
    category: 'Vegetables',
    discountPercentage: '26% OFF',
  ),

  // Fresh Milk
  _Product(
    id: 'cat_mlk1',
    name: 'Amul Gold Full Cream Milk',
    brand: 'Amul',
    unit: '1 L Pouch',
    price: r'₹66',
    mrp: r'₹70',
    rating: 4.9,
    reviews: 15400,
    imageUrl: 'assets/products/milk/2cf3020b-eae8-4909-b3b0-fe96c7e4e177.png',
    category: 'Milk',
    discountPercentage: '6% OFF',
  ),
  _Product(
    id: 'cat_mlk2',
    name: 'Amul Taaza Toned Milk',
    brand: 'Amul',
    unit: '1 L Pouch',
    price: r'₹54',
    mrp: r'₹58',
    rating: 4.7,
    reviews: 8420,
    imageUrl: 'assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
    category: 'Milk',
    discountPercentage: '7% OFF',
  ),
  _Product(
    id: 'cat_mlk3',
    name: 'Nandini Pure Cow Milk',
    brand: 'Nandini',
    unit: '500 ml Pouch',
    price: r'₹26',
    mrp: r'₹28',
    rating: 4.6,
    reviews: 6100,
    imageUrl: 'assets/products/milk/20c80cb9-33fb-4d4f-bdde-91ffa4490e57.png',
    category: 'Milk',
    discountPercentage: '7% OFF',
  ),
  _Product(
    id: 'cat_mlk4',
    name: 'Akshayakalpa Organic Cow Milk',
    brand: 'Akshayakalpa',
    unit: '500 ml Bottle',
    price: r'₹46',
    mrp: r'₹52',
    rating: 4.8,
    reviews: 3890,
    imageUrl: 'assets/products/milk/22a31d80-a56a-4241-82ef-8de00a46c9c4.png',
    category: 'Milk',
    discountPercentage: '12% OFF',
  ),

  // Bread & Bakery
  _Product(
    id: 'cat_brd1',
    name: 'Harvest Gold 100% Whole Wheat Bread',
    brand: 'Harvest Gold',
    unit: '400 g Pack',
    price: r'₹45',
    mrp: r'₹50',
    rating: 4.7,
    reviews: 6300,
    imageUrl: 'assets/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
    category: 'Bread & Bakery',
    discountPercentage: '10% OFF',
  ),
  _Product(
    id: 'cat_brd2',
    name: 'Fresh Soft Ladi Pav',
    brand: 'Bakery Fresh',
    unit: '6 pcs Pack',
    price: r'₹22',
    mrp: r'₹25',
    rating: 4.8,
    reviews: 8900,
    imageUrl: 'assets/products/bread-pav/036bad6d-4fbc-4c42-a18a-4bf33a3dfb6b.png',
    category: 'Bread & Bakery',
    discountPercentage: '12% OFF',
  ),
  _Product(
    id: 'cat_brd3',
    name: 'English Oven Brown Bread',
    brand: 'English Oven',
    unit: '400 g Pack',
    price: r'₹48',
    mrp: r'₹55',
    rating: 4.7,
    reviews: 5200,
    imageUrl: 'assets/products/bread-pav/076a5684-8206-48cc-b730-e1c7fe05e5df.png',
    category: 'Bread & Bakery',
    discountPercentage: '13% OFF',
  ),
  _Product(
    id: 'cat_brd4',
    name: 'Modern Multigrain Bread',
    brand: 'Modern',
    unit: '400 g Pack',
    price: r'₹52',
    mrp: r'₹60',
    rating: 4.6,
    reviews: 4700,
    imageUrl: 'assets/products/bread-pav/0780817d-4d79-4e2f-abe4-5a5725df31b0.png',
    category: 'Bread & Bakery',
    discountPercentage: '13% OFF',
  ),

  // Curd & Yogurt
  _Product(
    id: 'cat_crd1',
    name: 'Amul Masti Dahi Set Curd',
    brand: 'Amul',
    unit: '400 g Cup',
    price: r'₹35',
    mrp: r'₹40',
    rating: 4.8,
    reviews: 5400,
    imageUrl: 'assets/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
    category: 'Curd & Yogurt',
    discountPercentage: '12% OFF',
  ),
  _Product(
    id: 'cat_crd2',
    name: 'Epigamia Greek Yogurt Natural',
    brand: 'Epigamia',
    unit: '100 g Cup',
    price: r'₹50',
    mrp: r'₹60',
    rating: 4.7,
    reviews: 4300,
    imageUrl: 'assets/products/curd-yogurt/04dbb266-d965-4447-ba2c-655f725b47f5.png',
    category: 'Curd & Yogurt',
    discountPercentage: '17% OFF',
  ),
  _Product(
    id: 'cat_crd3',
    name: 'Mother Dairy Classic Dahi Tub',
    brand: 'Mother Dairy',
    unit: '400 g Tub',
    price: r'₹38',
    mrp: r'₹42',
    rating: 4.6,
    reviews: 4100,
    imageUrl: 'assets/products/curd-yogurt/057e0c66-77e1-4d90-ab5f-f2afe3aa69d9.png',
    category: 'Curd & Yogurt',
    discountPercentage: '10% OFF',
  ),
  _Product(
    id: 'cat_crd4',
    name: 'Milky Mist Farm Curd Pouch',
    brand: 'Milky Mist',
    unit: '450 g Pouch',
    price: r'₹36',
    mrp: r'₹40',
    rating: 4.7,
    reviews: 3900,
    imageUrl: 'assets/products/curd-yogurt/0bcb96d2-7515-41eb-b1d1-7dd218a5a26d.png',
    category: 'Curd & Yogurt',
    discountPercentage: '10% OFF',
  ),

  // Flakes & Cereals
  _Product(
    id: 'cat_cer1',
    name: 'Kellogg\'s Crunchy Corn Flakes',
    brand: 'Kellogg\'s',
    unit: '475 g Box',
    price: r'₹165',
    mrp: r'₹195',
    rating: 4.8,
    reviews: 5100,
    imageUrl: 'assets/products/flakes-kids-cereals/01e92a08-b40b-4d6f-aca7-8537cd382447.png',
    category: 'Cereals',
    discountPercentage: '15% OFF',
  ),
  _Product(
    id: 'cat_cer2',
    name: 'Kellogg\'s Choco Fills Cereal',
    brand: 'Kellogg\'s',
    unit: '250 g Box',
    price: r'₹125',
    mrp: r'₹145',
    rating: 4.8,
    reviews: 7200,
    imageUrl: 'assets/products/flakes-kids-cereals/09a1e487-9781-4ade-ab0e-73327c96691e.png',
    category: 'Cereals',
    discountPercentage: '14% OFF',
  ),
  _Product(
    id: 'cat_cer3',
    name: 'Nestle Koko Krunch Choco Cereal',
    brand: 'Nestle',
    unit: '350 g Box',
    price: r'₹170',
    mrp: r'₹199',
    rating: 4.7,
    reviews: 4300,
    imageUrl: 'assets/products/flakes-kids-cereals/0c447ba4-a230-4b31-92e7-03007bebf0bc.png',
    category: 'Cereals',
    discountPercentage: '15% OFF',
  ),
  _Product(
    id: 'cat_cer4',
    name: 'Quaker Rolled 100% Whole Oats',
    brand: 'Quaker',
    unit: '400 g Pouch',
    price: r'₹98',
    mrp: r'₹115',
    rating: 4.7,
    reviews: 6200,
    imageUrl: 'assets/products/flakes-kids-cereals/141e68a9-f36a-422f-8746-a9a49359401b.png',
    category: 'Cereals',
    discountPercentage: '15% OFF',
  ),

  // Poha & Grains
  _Product(
    id: 'cat_poh1',
    name: 'Tata Sampann Thick Poha',
    brand: 'Tata Sampann',
    unit: '500 g Pack',
    price: r'₹48',
    mrp: r'₹58',
    rating: 4.7,
    reviews: 4200,
    imageUrl: 'assets/products/poha-daliya-grains/1092_1643384330629.png',
    category: 'Poha & Grains',
    discountPercentage: '17% OFF',
  ),
  _Product(
    id: 'cat_poh2',
    name: 'Fortune Roasted Wheat Dalia',
    brand: 'Fortune',
    unit: '500 g Pack',
    price: r'₹38',
    mrp: r'₹45',
    rating: 4.6,
    reviews: 3800,
    imageUrl: 'assets/products/poha-daliya-grains/1140_1643384951835.png',
    category: 'Poha & Grains',
    discountPercentage: '15% OFF',
  ),
  _Product(
    id: 'cat_poh3',
    name: 'Pro Nature Organic Sabudana',
    brand: 'Pro Nature',
    unit: '500 g Pack',
    price: r'₹72',
    mrp: r'₹85',
    rating: 4.7,
    reviews: 2800,
    imageUrl: 'assets/products/poha-daliya-grains/1184_1661407202472.png',
    category: 'Poha & Grains',
    discountPercentage: '15% OFF',
  ),
  _Product(
    id: 'cat_poh4',
    name: 'Daily Basket High Fiber Diet Poha',
    brand: 'Daily Basket',
    unit: '500 g Pack',
    price: r'₹52',
    mrp: r'₹65',
    rating: 4.6,
    reviews: 3100,
    imageUrl: 'assets/products/poha-daliya-grains/1295_1643445863467.png',
    category: 'Poha & Grains',
    discountPercentage: '20% OFF',
  ),

  // Vermicelli
  _Product(
    id: 'cat_vrm1',
    name: 'MTR Roasted Vermicelli (Seviyan)',
    brand: 'MTR',
    unit: '400 g Pack',
    price: r'₹42',
    mrp: r'₹50',
    rating: 4.6,
    reviews: 3200,
    imageUrl: 'assets/products/vermicelli/3da21b8f-16e5-4727-9899-c5ef3e1db668.png',
    category: 'Vermicelli',
    discountPercentage: '16% OFF',
  ),
  _Product(
    id: 'cat_vrm2',
    name: 'Bambino Roasted Seviyan Vermicelli',
    brand: 'Bambino',
    unit: '400 g Pack',
    price: r'₹39',
    mrp: r'₹48',
    rating: 4.6,
    reviews: 4900,
    imageUrl: 'assets/products/vermicelli/4bf7f974-20b4-48b8-9367-f60997e8b940.png',
    category: 'Vermicelli',
    discountPercentage: '19% OFF',
  ),
  _Product(
    id: 'cat_vrm3',
    name: 'Two Brothers Khapli Wheat Vermicelli',
    brand: 'Two Brothers',
    unit: '500 g Pack',
    price: r'₹160',
    mrp: r'₹190',
    rating: 4.7,
    reviews: 1900,
    imageUrl: 'assets/products/vermicelli/536f1cfb8d75475ba5ff33db6d8c975f.png',
    category: 'Vermicelli',
    discountPercentage: '16% OFF',
  ),
  _Product(
    id: 'cat_vrm4',
    name: 'Tata Sampann Roasted Seviyan',
    brand: 'Tata Sampann',
    unit: '400 g Pack',
    price: r'₹45',
    mrp: r'₹55',
    rating: 4.6,
    reviews: 2600,
    imageUrl: 'assets/products/vermicelli/64ca266c-db61-4087-b9f5-2019f2704a3e.png',
    category: 'Vermicelli',
    discountPercentage: '18% OFF',
  ),
];

const _kCats = ['All', 'Vegetables', 'Milk', 'Bread & Bakery', 'Curd & Yogurt', 'Cereals', 'Poha & Grains', 'Vermicelli'];

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});
  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _navIndex = 0;
  String _selectedCat = 'All';
  final Map<String, int> _cart = {};

  void _updateQty(String id, int delta) => setState(() {
        final n = (_cart[id] ?? 0) + delta;
        n <= 0 ? _cart.remove(id) : (_cart[id] = n);
      });

  void _updateProductQty(_Product p, int delta, CartProvider? cartProvider) {
    if (cartProvider != null) {
      final priceVal = double.tryParse(p.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 50.0;
      cartProvider.updateQuantityById(
        id: p.id,
        name: p.name,
        subtitle: p.unit,
        price: priceVal,
        image: p.imageUrl,
        delta: delta,
      );
    } else {
      _updateQty(p.id, delta);
    }
  }

  int _getItemQty(String id, CartProvider? cartProvider) {
    if (cartProvider != null) {
      return cartProvider.getQuantity(id);
    }
    return _cart[id] ?? 0;
  }

  int get _cartCount => _cart.values.fold(0, (s, v) => s + v);
  List<_Product> get _filtered =>
      _selectedCat == 'All' ? _catalog : _catalog.where((p) => p.category == _selectedCat).toList();

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    LanguageProvider? languageProvider;

    try { cartProvider = context.watch<CartProvider>(); } catch (_) {}
    try { languageProvider = context.watch<LanguageProvider>(); } catch (_) {}

    final cartCount = cartProvider?.totalCount ?? _cartCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _navIndex,
          children: [
            _buildFeed(cartProvider),
            const BrowseCategoriesScreen(),
            const SearchResultsScreen(),
            const CartScreen(),
            const OrderHistoryScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(cartCount, languageProvider),
    );
  }

  Widget _buildBottomNav(int cartCount, LanguageProvider? languageProvider) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFBECAB9).withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, languageProvider?.translate('shop', 'Home') ?? 'Home'),
                _navItem(1, Icons.grid_view_rounded, languageProvider?.translate('categories', 'Categories') ?? 'Categories'),
                _navItem(2, Icons.search_rounded, languageProvider?.translate('search', 'Search') ?? 'Search'),
                _navItem(3, Icons.shopping_basket_outlined, languageProvider?.translate('cart', 'Cart') ?? 'Cart', badge: cartCount),
                _navItem(4, Icons.receipt_long_rounded, languageProvider?.translate('orders', 'Orders') ?? 'Orders'),
                _navItem(5, Icons.person_outline_rounded, languageProvider?.translate('account', 'Profile') ?? 'Profile'),
              ],
            ),
          ),
        ),
      );

  Widget _buildHorizontalProductSection(
    String title,
    List<_Product> products,
    CartProvider? cartProvider, {
    VoidCallback? onSeeAll,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _sectionHeader(title, onAll: onSeeAll),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 310,
            child: AnimationLimiter(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (_, i) => AnimationConfiguration.staggeredList(
                  position: i,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: SizedBox(
                        width: 170,
                        child: _buildCard(products[i], cartProvider),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildFeed(CartProvider? cartProvider) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildHeader(), const SizedBox(height: 12),
                _buildGreetingHeader(),
                _buildDeliveryEtaWidget(),
                _buildAddressBar(), const SizedBox(height: 12),
                _buildSearchBar(), const SizedBox(height: 16),
              ]),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildBanner()),
            const SizedBox(height: 20),
            // ─── Premium Quick Services Section ──────────────────────────────────
            const QuickServicesSection(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionHeader('Categories', onAll: () => setState(() => _navIndex = 1)),
                const SizedBox(height: 12),
                _buildCategoryChips(),
              ]),
            ),
            const SizedBox(height: 24),

            // ─── 1. Daily Selling Section ──────────────────────────────────────
            _buildHorizontalProductSection(
              'Daily Selling',
              _dailySelling,
              cartProvider,
              onSeeAll: () => Navigator.pushNamed(context, '/categories'),
            ),
            const SizedBox(height: 28),

            // ─── 2. High Selling Section ───────────────────────────────────────
            _buildHorizontalProductSection(
              'High Selling',
              _highSelling,
              cartProvider,
              onSeeAll: () => Navigator.pushNamed(context, '/categories'),
            ),
            const SizedBox(height: 28),

            // ─── 3. Recommended Section ────────────────────────────────────────
            _buildHorizontalProductSection(
              'Recommended For You',
              _recommended,
              cartProvider,
              onSeeAll: () => Navigator.pushNamed(context, '/categories'),
            ),
            const SizedBox(height: 28),

            // ─── 4. Top Buying Section ─────────────────────────────────────────
            _buildHorizontalProductSection(
              'Top Buying',
              _topBuying,
              cartProvider,
              onSeeAll: () => Navigator.pushNamed(context, '/categories'),
            ),
            const SizedBox(height: 28),

            // ─── 5. Kirana Essentials (Grid) ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionHeader('Kirana Essentials'),
                const SizedBox(height: 12),
                _buildCategoryFilter(),
                const SizedBox(height: 16),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.53,
                    crossAxisSpacing: 14, mainAxisSpacing: 14,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => AnimationConfiguration.staggeredGrid(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 2,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildCard(_filtered[i], cartProvider),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ─── Buy Again ──────────────────────────────────────────────
            const SizedBox(height: 28),
            const BuyAgainSection(),
            // ─── Recently Viewed ───────────────────────────────────────
            const SizedBox(height: 28),
            const RecentlyViewedSection(),
            const SizedBox(height: 32),
          ],
        ),
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => AppNavigationDrawer.show(context), icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 28, height: 28, padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12)),
              child: Image.asset('assets/images/daily_basket_logo.png', fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag_rounded, size: 18, color: Color(0xFF006B23))),
            ),
            const SizedBox(width: 8),
            Text('Daily Basket', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF006B23))),
          ]),
          Stack(clipBehavior: Clip.none, children: [
            IconButton(onPressed: () => Navigator.pushNamed(context, '/cart'), icon: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF006B23), size: 26)),
            if (_cartCount > 0) Positioned(top: 6, right: 6, child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFF006B23), shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$_cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            )),
          ]),
        ],
      );

  Widget _buildGreetingHeader() {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    IconData timeIcon = Icons.wb_sunny_rounded;
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
      timeIcon = Icons.wb_sunny_outlined;
    } else if (hour >= 17) {
      greeting = 'Good Evening';
      timeIcon = Icons.nights_stay_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(timeIcon, color: const Color(0xFFEAB308), size: 20),
              const SizedBox(width: 8),
              Text(
                '$greeting, Sachinxcode! 👋',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: const Color(0xFF006B23).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006B23),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'STORE OPEN',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF006B23),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryEtaWidget() => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF006B23), Color(0xFF078730)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF006B23).withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Color(0xFF006B23), size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚡ 10 MINS DELIVERY GUARANTEE',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Delivering to 123 Main St, New York',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
          ],
        ),
      );

  Widget _buildAddressBar() => GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/saved-addresses'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFFF3F3F6), borderRadius: BorderRadius.circular(9999)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF006B23), size: 20),
            const SizedBox(width: 8),
            Text('123 Main St, New York', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF1A1C1E))),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6E7A6C), size: 20),
          ]),
        ),
      );

  Widget _buildSearchBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFF3F3F6), borderRadius: BorderRadius.circular(9999)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Row(children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF6E7A6C), size: 22),
                  const SizedBox(width: 10),
                  Text('Search products...', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C))),
                ]),
              ),
            ),
            GestureDetector(
              onTap: () {
                VoiceSearchDialog.show(
                  context,
                  onSpeechResult: (query) {
                    Navigator.pushNamed(context, '/search', arguments: query);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Color(0xFF006B23),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/camera-search');
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF006B23),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildBanner() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: double.infinity,
          height: 180,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/illustrations/fresharrivalbg.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFF006B23))),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft, end: Alignment.centerRight,
                  colors: [const Color(0xFF006B23).withValues(alpha: 0.92), const Color(0xFF006B23).withValues(alpha: 0.50), Colors.transparent],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Fresh Arrivals', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 190),
                  child: Text('Up to 20% off organic vegetables this weekend.', style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.95), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/categories'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9999)),
                    child: Text('Shop Now', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF006B23))),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      );

  Widget _sectionHeader(String title, {VoidCallback? onAll}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1E))),
          if (onAll != null) TextButton(onPressed: onAll, child: Text('See All', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF006B23)))),
        ],
      );




  Widget _buildCategoryChips() {
    const chips = [
      ('Vegetables', 'fresh-vegetables', '🥦'),
      ('Milk', 'milk', '🥛'),
      ('Bread & Pav', 'bread-pav', '🍞'),
      ('Curd & Yogurt', 'curd-yogurt', '🥣'),
      ('Cereals', 'flakes-kids-cereals', '🥣'),
      ('Poha & Grains', 'poha-daliya-grains', '🌾'),
      ('Vermicelli', 'vermicelli', '🍜'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.map((c) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListingScreen(
                  categoryId: c.$2,
                  categoryName: c.$1,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF3F3F6), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [Text(c.$3, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8), Text(c.$1, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)))]),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCategoryFilter() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(children: _kCats.map((cat) {
          final sel = _selectedCat == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFF006B23) : Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: sel ? const Color(0xFF006B23) : const Color(0xFFBECAB9)),
              ),
              child: Text(cat, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: sel ? Colors.white : const Color(0xFF3F4A3D))),
            ),
          );
        }).toList()),
      );

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Milk':
        return Icons.local_drink_rounded;
      case 'Vegetables':
      case 'Fruits':
        return Icons.eco_rounded;
      case 'Bread & Bakery':
        return Icons.bakery_dining_rounded;
      case 'Curd & Yogurt':
        return Icons.egg_alt_rounded;
      case 'Cereals':
        return Icons.breakfast_dining_rounded;
      case 'Poha & Grains':
        return Icons.grain_rounded;
      case 'Vermicelli':
        return Icons.ramen_dining_rounded;
      default:
        return Icons.shopping_basket_rounded;
    }
  }

  Widget _buildCard(_Product p, [CartProvider? cartProvider]) {
    final qty = _getItemQty(p.id, cartProvider);
    final disc = p.computedDiscount;
    return AppPressable(
      scaleFactor: 0.98,
      onTap: () {
        try {
          context.read<RecentlyViewedProvider>().addRecentlyViewed({
            'id': p.id,
            'name': p.name,
            'brand': p.brand,
            'unit': p.unit,
            'price': p.price,
            'mrp': p.mrp,
            'imageUrl': p.imageUrl,
          });
        } catch (_) {}
        Navigator.pushNamed(
          context,
          '/product-details',
          arguments: {
            'productId': p.id,
            'categoryTag': p.category.toUpperCase(),
            'brand': p.brand,
            'productName': p.name,
            'price': p.price,
            'mrp': p.mrp,
            'discountPercentage': disc.isNotEmpty ? disc : '15% OFF',
            'unitDetails': p.unit,
            'deliveryTime': '10 mins',
            'imageUrl': p.imageUrl,
            'description': 'Farm fresh and premium quality ${p.name}. Delivered in 10 minutes directly to your doorstep with guaranteed freshness.',
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Container(
                    color: const Color(0xFFF9F9FC),
                    padding: const EdgeInsets.all(8),
                    child: AppNetworkImage(
                      imageUrl: p.imageUrl,
                      fit: BoxFit.contain,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      fallbackIcon: _getCategoryIcon(p.category),
                      fallbackBgColor: const Color(0xFFF3F3F6),
                      fallbackIconColor: const Color(0xFF006B23),
                    ),
                  ),
                ),
              ),
              if (disc.isNotEmpty)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBA1A1A),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      disc,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: FavoriteButton(
                  productId: p.id,
                  productDetails: {
                    'id': p.id,
                    'name': p.name,
                    'brand': p.brand,
                    'weight': p.unit,
                    'price': double.tryParse(p.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 50.0,
                    'mrp': double.tryParse(p.mrp.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 60.0,
                    'category': p.category,
                    'imageUrl': p.imageUrl,
                  },
                  size: 20,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.brand, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF006B23)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(p.name, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 1),
                Text(p.unit, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6E7A6C))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 2),
                  Text(p.rating.toStringAsFixed(1), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E))),
                  const SizedBox(width: 3),
                  Flexible(child: Text('(${_fmt(p.reviews)})', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6E7A6C)), overflow: TextOverflow.ellipsis)),
                ]),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(p.price, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF006B23))),
                    const SizedBox(width: 5),
                    Text(p.mrp, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6E7A6C), decoration: TextDecoration.lineThrough)),
                    if (disc.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          disc,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBA1A1A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                qty == 0
                    ? AppPressable(
                        child: SizedBox(
                          width: double.infinity, height: 32,
                          child: ElevatedButton(
                            onPressed: () => _updateProductQty(p, 1, cartProvider),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006B23), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.zero),
                            child: Text('Add', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      )
                    : Container(
                        height: 32,
                        decoration: BoxDecoration(color: const Color(0xFF006B23), borderRadius: BorderRadius.circular(8)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          AppPressable(
                            onTap: () => _updateProductQty(p, -1, cartProvider),
                            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.remove, color: Colors.white, size: 16)),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                            child: Text(
                              '$qty',
                              key: ValueKey<int>(qty),
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                          AppPressable(
                            onTap: () => _updateProductQty(p, 1, cartProvider),
                            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.add, color: Colors.white, size: 16)),
                          ),
                        ]),
                      ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  Widget _navItem(int index, IconData icon, String label, {int badge = 0}) {
    final active = _navIndex == index;
    return AppPressable(
      onTap: () => setState(() => _navIndex = index),
      scaleFactor: 0.94,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: active ? const Color(0xFF006B23) : Colors.transparent, borderRadius: BorderRadius.circular(9999)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(icon, color: active ? Colors.white : const Color(0xFF6E7A6C), size: 22),
            if (badge > 0 && !active) Positioned(top: -4, right: -6, child: AnimatedScale(
              duration: const Duration(milliseconds: 250),
              curve: Curves.elasticOut,
              scale: 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: const BoxDecoration(color: Color(0xFFBA1A1A), shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            )),
          ]),
          if (active) ...[const SizedBox(width: 6), Text(label, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))],
        ]),
      ),
    );
  }
}
