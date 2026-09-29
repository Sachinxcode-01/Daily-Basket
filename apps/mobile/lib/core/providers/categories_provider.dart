import 'package:flutter/material.dart';
import '../data/products_catalog_data.dart';

class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String iconName;
  final String imageUrl;
  final String bannerImage;
  final int sortOrder;
  final bool isFeatured;
  final List<String> subcategories;

  CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.iconName,
    required this.imageUrl,
    required this.bannerImage,
    required this.sortOrder,
    required this.isFeatured,
    required this.subcategories,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    List<String> subs = [];
    if (json['children'] != null && json['children'] is List) {
      subs = (json['children'] as List).map((c) => c['name'] as String).toList();
    } else if (json['subcategories'] != null && json['subcategories'] is List) {
      subs = List<String>.from(json['subcategories']);
    }

    return CategoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? 'shopping_basket',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
      bannerImage: json['bannerImage'] ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200&q=80',
      sortOrder: json['sortOrder'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      subcategories: subs,
    );
  }
}

class CategoriesProvider extends ChangeNotifier {
  List<CategoryItem> _categories = [];
  final bool _isLoading = false;
  String? _error;
  String _selectedSubcategory = 'All';
  String _searchQuery = '';
  String _sortOption = 'popular';
  String _dietaryFilter = 'All';
  String _priceFilter = 'All';
  bool _inStockOnly = false;

  List<CategoryItem> get categories => _categories.isEmpty ? _defaultCategories : _categories;
  List<CategoryItem> get featuredCategories => categories.where((c) => c.isFeatured).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedSubcategory => _selectedSubcategory;
  String get searchQuery => _searchQuery;
  String get sortOption => _sortOption;
  String get dietaryFilter => _dietaryFilter;
  String get priceFilter => _priceFilter;
  bool get inStockOnly => _inStockOnly;

  int get activeFilterCount =>
      (_dietaryFilter != 'All' ? 1 : 0) +
      (_priceFilter != 'All' ? 1 : 0) +
      (_sortOption != 'popular' ? 1 : 0) +
      (_inStockOnly ? 1 : 0);

  CategoriesProvider() {
    _categories = _defaultCategories;
  }

  void selectSubcategory(String sub) {
    _selectedSubcategory = sub;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setSortOption(String sort) {
    _sortOption = sort;
    notifyListeners();
  }

  void setDietaryFilter(String diet) {
    _dietaryFilter = diet;
    notifyListeners();
  }

  void setPriceFilter(String price) {
    _priceFilter = price;
    notifyListeners();
  }

  void setInStockOnly(bool only) {
    _inStockOnly = only;
    notifyListeners();
  }

  void resetFilters() {
    _dietaryFilter = 'All';
    _priceFilter = 'All';
    _sortOption = 'popular';
    _inStockOnly = false;
    notifyListeners();
  }

  CategoryItem findBySlugOrId(String identifier) {
    return categories.firstWhere(
      (c) => c.id == identifier || c.slug == identifier,
      orElse: () => categories.first,
    );
  }

  List<Map<String, dynamic>> getAllCatalogProductsList() {
    return _allMockProducts['all'] ?? [];
  }

  Map<String, dynamic>? getProductById(String id) {
    final all = _allMockProducts['all'] ?? [];
    for (final p in all) {
      if (p['id'] == id) return p;
    }
    return null;
  }

  List<Map<String, dynamic>> searchAllProducts(
    String query, {
    String filterTag = 'All',
    String sortOption = 'Relevance',
  }) {
    final all = _allMockProducts['all'] ?? [];
    final q = query.trim().toLowerCase();

    List<Map<String, dynamic>> results = all.where((p) {
      if (q.isEmpty) return true;
      final name = (p['name'] ?? '').toString().toLowerCase();
      final brand = (p['brand'] ?? '').toString().toLowerCase();
      final sub = (p['sub'] ?? '').toString().toLowerCase();
      final cat = (p['category'] ?? '').toString().toLowerCase();
      final unit = (p['unit'] ?? p['subtitle'] ?? '').toString().toLowerCase();
      return name.contains(q) || brand.contains(q) || sub.contains(q) || cat.contains(q) || unit.contains(q);
    }).toList();

    if (filterTag != 'All') {
      results = results.where((p) {
        switch (filterTag) {
          case 'Organic':
            final b = (p['badge'] ?? '').toString().toLowerCase();
            final c = (p['category'] ?? '').toString().toLowerCase();
            final n = (p['name'] ?? '').toString().toLowerCase();
            return b.contains('organic') || c.contains('organic') || n.contains('organic');
          case 'Under ₹50':
            final price = (p['price'] as num?)?.toDouble() ?? 0.0;
            return price <= 50.0;
          case 'Best Discount':
            final price = (p['price'] as num?)?.toDouble() ?? 0.0;
            final mrp = (p['mrp'] as num?)?.toDouble() ?? price;
            return mrp > price && ((mrp - price) / mrp) >= 0.15;
          case '10-Min Fast':
            return p['inStock'] == true;
          default:
            return true;
        }
      }).toList();
    }

    switch (sortOption) {
      case 'Price: Low to High':
        results.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case 'Price: High to Low':
        results.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case 'Best Discount':
        results.sort((a, b) {
          final pA = (a['price'] as num).toDouble();
          final mrpA = (a['mrp'] as num?)?.toDouble() ?? pA;
          final discA = mrpA > pA ? (mrpA - pA) / mrpA : 0.0;

          final pB = (b['price'] as num).toDouble();
          final mrpB = (b['mrp'] as num?)?.toDouble() ?? pB;
          final discB = mrpB > pB ? (mrpB - pB) / mrpB : 0.0;
          return discB.compareTo(discA);
        });
        break;
      default:
        break;
    }

    return results;
  }

  List<Map<String, dynamic>> getProductsForCategory(String categorySlug) {
    List<Map<String, dynamic>> products = _allMockProducts[categorySlug] ?? [];
    if (products.isEmpty) {
      final cat = findBySlugOrId(categorySlug);
      products = _allMockProducts[cat.slug] ?? _allMockProducts['all'] ?? _allMockProducts['fresh-fruits-vegetables']!;
    }

    if (_selectedSubcategory != 'All') {
      products = products.where((p) => p['sub'] == _selectedSubcategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      products = products.where((p) => p['name'].toString().toLowerCase().contains(q)).toList();
    }

    if (_inStockOnly) {
      products = products.where((p) => p['inStock'] == true).toList();
    }

    if (_dietaryFilter != 'All') {
      products = products.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        final badge = (p['badge'] ?? '').toString().toLowerCase();
        final cat = (p['category'] ?? '').toString().toLowerCase();
        switch (_dietaryFilter) {
          case 'Organic':
            return badge.contains('organic') || cat.contains('organic') || name.contains('organic');
          case 'Vegan':
            return !cat.contains('dairy') && !cat.contains('milk') && !name.contains('curd') && !name.contains('butter');
          case 'Gluten-Free':
            return !name.contains('bread') && !name.contains('wheat') && !name.contains('vermicelli');
          case 'High-Protein':
            return cat.contains('milk') || cat.contains('curd') || name.contains('egg') || name.contains('oats');
          default:
            return true;
        }
      }).toList();
    }

    if (_priceFilter != 'All') {
      products = products.where((p) {
        final pr = (p['price'] as num?)?.toDouble() ?? 0.0;
        switch (_priceFilter) {
          case 'under_50':
            return pr < 50.0;
          case '50_150':
            return pr >= 50.0 && pr <= 150.0;
          case 'above_150':
            return pr > 150.0;
          default:
            return true;
        }
      }).toList();
    }

    if (_sortOption == 'price_low_high') {
      products.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
    } else if (_sortOption == 'price_high_low') {
      products.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
    } else if (_sortOption == 'rating') {
      products.sort((a, b) => ((b['rating'] ?? 4.5) as num).compareTo((a['rating'] ?? 4.5) as num));
    }

    return products;
  }

  List<Map<String, dynamic>> getProduceProducts({
    String filter = 'Seasonal',
    String sort = 'Relevance',
  }) {
    List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(
      _allMockProducts['fresh-fruits-vegetables'] ?? [],
    );

    if (filter == 'Seasonal') {
      products = products.where((p) => p['category'] == 'Seasonal' || p['inStock'] == true).toList();
    } else if (filter == 'Organic') {
      products = products.where((p) => p['category'] == 'Organic' || (p['subtitle'] ?? '').toString().contains('Organic')).toList();
    } else if (filter != 'All' && filter != 'Sort' && filter != 'Price') {
      products = products.where((p) => p['sub'] == filter || p['category'] == filter).toList();
    }

    if (sort == 'Price Low to High' || filter == 'Price') {
      products.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
    } else if (sort == 'Price High to Low') {
      products.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
    } else if (sort == 'Rating') {
      products.sort((a, b) => ((b['rating'] ?? 0.0) as num).compareTo((a['rating'] ?? 0.0) as num));
    }

    return products;
  }

  static final List<CategoryItem> _defaultCategories = [
    CategoryItem(
      id: 'cat-all-products',
      name: 'All Products',
      slug: 'all',
      description: 'Explore our full grocery catalog of 600+ farm fresh items delivered in 10 minutes',
      iconName: 'storefront',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200&q=80',
      sortOrder: 0,
      isFeatured: true,
      subcategories: ['All', 'Bread & Pav', 'Fresh Vegetables', 'Curd & Yogurt', 'Milk', 'Flakes & Cereals', 'Poha & Grains', 'Vermicelli'],
    ),
    CategoryItem(
      id: 'cat-bread-pav',
      name: 'Bread, Pav & Bakery',
      slug: 'bread-pav',
      description: 'Sandwich breads, artisan sourdough, pav, burger buns & morning bakery essentials',
      iconName: 'bakery_dining',
      imageUrl: 'assets/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
      bannerImage: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=1200&q=80',
      sortOrder: 1,
      isFeatured: true,
      subcategories: ['All', 'Brown Bread', 'White Bread', 'Multigrain', 'Pav & Buns', 'Rusk & Toast'],
    ),
    CategoryItem(
      id: 'cat-fresh-vegetables',
      name: 'Fresh Vegetables',
      slug: 'fresh-vegetables',
      description: 'Farm-fresh vegetables, crisp leafy greens, exotic herbs & root veggies',
      iconName: 'eco',
      imageUrl: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
      bannerImage: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=1200&q=80',
      sortOrder: 2,
      isFeatured: true,
      subcategories: ['All', 'Fresh Vegetables', 'Exotics & Premium', 'Organic Produce', 'Leafy Greens'],
    ),
    CategoryItem(
      id: 'cat-curd-yogurt',
      name: 'Curd & Yogurt',
      slug: 'curd-yogurt',
      description: 'Fresh set dahi, probiotic curd cups, Greek yogurts and flavored desserts',
      iconName: 'icecream',
      imageUrl: 'assets/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
      bannerImage: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=1200&q=80',
      sortOrder: 3,
      isFeatured: true,
      subcategories: ['All', 'Plain Curd', 'Greek Yogurt', 'Flavoured Yogurt', 'Probiotic'],
    ),
    CategoryItem(
      id: 'cat-milk',
      name: 'Fresh Milk',
      slug: 'milk',
      description: 'Pasteurized cow milk, A2 buffalo milk, toned, full cream and probiotic dairy drinks',
      iconName: 'local_drink',
      imageUrl: 'assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
      bannerImage: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=1200&q=80',
      sortOrder: 4,
      isFeatured: true,
      subcategories: ['All', 'Cow Milk', 'Buffalo Milk', 'Toned Milk', 'Full Cream', 'Probiotic Drinks'],
    ),
    CategoryItem(
      id: 'cat-flakes-kids-cereals',
      name: 'Flakes & Cereals',
      slug: 'flakes-kids-cereals',
      description: 'Crunchy corn flakes, choco fills, oats, granola and kids morning breakfast bowls',
      iconName: 'breakfast_dining',
      imageUrl: 'assets/products/flakes-kids-cereals/01e92a08-b40b-4d6f-aca7-8537cd382447.png',
      bannerImage: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=1200&q=80',
      sortOrder: 5,
      isFeatured: true,
      subcategories: ['All', 'Corn Flakes', 'Choco Fills', 'Muesli', 'Oats', 'Kids Cereals'],
    ),
    CategoryItem(
      id: 'cat-poha-daliya-grains',
      name: 'Poha, Daliya & Grains',
      slug: 'poha-daliya-grains',
      description: 'Thick poha, roasted wheat dalia, sabudana, millets and healthy whole grains',
      iconName: 'grain',
      imageUrl: 'assets/products/poha-daliya-grains/1092_1643384330629.png',
      bannerImage: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=1200&q=80',
      sortOrder: 6,
      isFeatured: true,
      subcategories: ['All', 'Poha', 'Dalia', 'Sabudana', 'Breakfast Grains'],
    ),
    CategoryItem(
      id: 'cat-vermicelli',
      name: 'Vermicelli & Sevai',
      slug: 'vermicelli',
      description: 'Roasted wheat seviyan, traditional rice sevai, upma mixes & dessert vermicelli',
      iconName: 'ramen_dining',
      imageUrl: 'assets/products/vermicelli/3da21b8f-16e5-4727-9899-c5ef3e1db668.png',
      bannerImage: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=1200&q=80',
      sortOrder: 7,
      isFeatured: true,
      subcategories: ['All', 'Roasted Vermicelli', 'Plain Vermicelli', 'Sevai', 'Wheat Vermicelli'],
    ),
    CategoryItem(
      id: 'cat-fresh-fruits-veg',
      name: 'Fresh Fruits & Vegetables',
      slug: 'fresh-fruits-vegetables',
      description: 'Farm fresh organic vegetables, fresh fruits, leafy greens & exotic herbs',
      iconName: 'eco',
      imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=1200&q=80',
      sortOrder: 1,
      isFeatured: true,
      subcategories: ['All', 'Fresh Vegetables', 'Fresh Fruits', 'Exotics & Premium', 'Organic Produce', 'Leafy Greens'],
    ),
    CategoryItem(
      id: 'cat-dairy-bread-eggs',
      name: 'Dairy, Bread & Eggs',
      slug: 'dairy-bread-eggs',
      description: 'Fresh milk, butter, paneer, curd, fresh bread, and farm eggs delivered in 10 mins',
      iconName: 'egg_alt',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=1200&q=80',
      sortOrder: 2,
      isFeatured: true,
      subcategories: ['All', 'Milk', 'Butter & Spread', 'Paneer & Tofu', 'Curd & Yogurt', 'Bread & Pav', 'Eggs'],
    ),
    CategoryItem(
      id: 'cat-snacks-packaged',
      name: 'Snacks & Packaged Foods',
      slug: 'snacks-packaged-foods',
      description: 'Crunchy chips, namkeen, instant noodles, pasta, cereals and popcorn',
      iconName: 'fastfood',
      imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=1200&q=80',
      sortOrder: 3,
      isFeatured: true,
      subcategories: ['All', 'Chips & Wafers', 'Namkeen & Bhujia', 'Instant Noodles', 'Pasta', 'Ready To Eat', 'Popcorn'],
    ),
    CategoryItem(
      id: 'cat-grocery',
      name: 'Grocery',
      slug: 'grocery',
      description: 'Basmati rice, premium atta, pulses, dals, salt, sugar and dry fruits',
      iconName: 'shopping_bag',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=1200&q=80',
      sortOrder: 4,
      isFeatured: true,
      subcategories: ['All', 'Rice', 'Atta', 'Flour', 'Dal', 'Pulses', 'Sugar', 'Salt', 'Dry Fruits', 'Poha', 'Sooji'],
    ),
    CategoryItem(
      id: 'cat-cooking-essentials',
      name: 'Cooking Essentials',
      slug: 'cooking-essentials',
      description: 'Pure mustard & sunflower oil, desi ghee, masalas, sauces, and pickles',
      iconName: 'opacity',
      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=1200&q=80',
      sortOrder: 5,
      isFeatured: true,
      subcategories: ['All', 'Cooking Oil', 'Ghee', 'Butter', 'Sauces', 'Ketchup', 'Mayonnaise', 'Pickles', 'Masala'],
    ),
    CategoryItem(
      id: 'cat-pooja-needs',
      name: 'Pooja Needs',
      slug: 'pooja-needs',
      description: 'Agarbatti, dhoop, pure camphor, cotton wicks, kumkum and pooja oil',
      iconName: 'temple_hindu',
      imageUrl: 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=1200&q=80',
      sortOrder: 6,
      isFeatured: false,
      subcategories: ['All', 'Agarbatti', 'Dhoop', 'Camphor', 'Cotton Wicks', 'Kumkum', 'Turmeric', 'Coconut', 'Flowers', 'Pooja Oil'],
    ),
    CategoryItem(
      id: 'cat-cleaning-essentials',
      name: 'Cleaning Essentials',
      slug: 'cleaning-essentials',
      description: 'Disinfectant floor cleaners, dishwash liquids, detergent powders and garbage bags',
      iconName: 'cleaning_services',
      imageUrl: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=1200&q=80',
      sortOrder: 7,
      isFeatured: false,
      subcategories: ['All', 'Floor Cleaner', 'Toilet Cleaner', 'Dishwash', 'Detergent Powder', 'Liquid Detergent', 'Cleaning Brushes', 'Mops', 'Garbage Bags'],
    ),
    CategoryItem(
      id: 'cat-household-lifestyle',
      name: 'Household & Lifestyle',
      slug: 'household-lifestyle',
      description: 'Storage containers, kitchenware, aluminium foil, tissues, batteries and repellents',
      iconName: 'home_work',
      imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=1200&q=80',
      sortOrder: 8,
      isFeatured: false,
      subcategories: ['All', 'Buckets', 'Mugs', 'Storage Containers', 'Kitchen Tools', 'Aluminium Foil', 'Tissues', 'Paper Towels', 'Mosquito Repellent', 'Batteries'],
    ),
    CategoryItem(
      id: 'cat-personal-care',
      name: 'Personal Care',
      slug: 'personal-care',
      description: 'Bathing soaps, shampoos, toothpastes, skincare lotions, and hygiene products',
      iconName: 'face',
      imageUrl: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=1200&q=80',
      sortOrder: 9,
      isFeatured: false,
      subcategories: ['All', 'Soaps', 'Shampoo', 'Toothpaste', 'Skin Care', 'Hair Oil', 'Sanitary Hygiene'],
    ),
    CategoryItem(
      id: 'cat-baby-care',
      name: 'Baby Care',
      slug: 'baby-care',
      description: 'Diapers, baby wipes, infant food, baby shampoos, and gentle skincare',
      iconName: 'child_care',
      imageUrl: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=1200&q=80',
      sortOrder: 10,
      isFeatured: false,
      subcategories: ['All', 'Diapers', 'Baby Wipes', 'Baby Food', 'Baby Bath', 'Baby Skincare'],
    ),
    CategoryItem(
      id: 'cat-pet-care',
      name: 'Pet Care',
      slug: 'pet-care',
      description: 'Nutritious dog food, cat treats, litter sand, grooming shampoos and pet toys',
      iconName: 'pets',
      imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=1200&q=80',
      sortOrder: 11,
      isFeatured: false,
      subcategories: ['All', 'Dog Food', 'Cat Food', 'Pet Treats', 'Cat Litter', 'Pet Accessories'],
    ),
    CategoryItem(
      id: 'cat-cold-drinks-juices',
      name: 'Cold Drinks & Juices',
      slug: 'cold-drinks-juices',
      description: 'Chilled soft drinks, fruit juices, coconut water, energy drinks, and soda',
      iconName: 'local_drink',
      imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=1200&q=80',
      sortOrder: 12,
      isFeatured: true,
      subcategories: ['All', 'Soft Drinks', 'Fruit Juices', 'Coconut Water', 'Energy Drinks', 'Soda & Mixer'],
    ),
    CategoryItem(
      id: 'cat-tea-coffee-bev',
      name: 'Tea, Coffee & Beverages',
      slug: 'tea-coffee-beverages',
      description: 'Premium Assam tea leaves, instant coffee powder, green tea, health drinks and syrups',
      iconName: 'coffee',
      imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=1200&q=80',
      sortOrder: 13,
      isFeatured: false,
      subcategories: ['All', 'Tea Powder', 'Green Tea', 'Instant Coffee', 'Filter Coffee', 'Health Drinks'],
    ),
    CategoryItem(
      id: 'cat-biscuits-bakery',
      name: 'Biscuits & Bakery',
      slug: 'biscuits-bakery',
      description: 'Butter cookies, cream biscuits, rusks, cakes, fresh muffins, and artisan breads',
      iconName: 'bakery_dining',
      imageUrl: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=1200&q=80',
      sortOrder: 14,
      isFeatured: false,
      subcategories: ['All', 'Cookies', 'Cream Biscuits', 'Rusks', 'Cakes', 'Artisan Bread'],
    ),
    CategoryItem(
      id: 'cat-chocolates-icecream',
      name: 'Chocolates & Ice Cream',
      slug: 'chocolates-ice-cream',
      description: 'Milk chocolates, dark chocolates, ice cream tubs, cones, and dessert toppings',
      iconName: 'icecream',
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=1200&q=80',
      sortOrder: 15,
      isFeatured: true,
      subcategories: ['All', 'Milk Chocolates', 'Dark Chocolates', 'Ice Cream Tubs', 'Ice Cream Cones'],
    ),
    CategoryItem(
      id: 'cat-organic-healthy',
      name: 'Organic & Healthy Foods',
      slug: 'organic-healthy-foods',
      description: '100% certified organic pulses, cold-pressed oils, millets, quinoa, and sugar-free snacks',
      iconName: 'spa',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=1200&q=80',
      sortOrder: 16,
      isFeatured: false,
      subcategories: ['All', 'Organic Staples', 'Organic Oils', 'Millets', 'Quinoa', 'Sugar Free'],
    ),
    CategoryItem(
      id: 'cat-frozen-foods',
      name: 'Frozen Foods',
      slug: 'frozen-foods',
      description: 'Frozen french fries, veg momos, frozen parathas, green peas, and chicken nuggets',
      iconName: 'ac_unit',
      imageUrl: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=1200&q=80',
      sortOrder: 17,
      isFeatured: false,
      subcategories: ['All', 'French Fries', 'Veg Momos', 'Parathas', 'Green Peas'],
    ),
    CategoryItem(
      id: 'cat-meat-fish-eggs',
      name: 'Meat, Fish & Eggs',
      slug: 'meat-fish-eggs',
      description: 'Fresh chicken curry cut, mutton, fresh sea fish, prawns, and brown eggs',
      iconName: 'restaurant',
      imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=600&q=80',
      bannerImage: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=1200&q=80',
      sortOrder: 18,
      isFeatured: false,
      subcategories: ['All', 'Fresh Chicken', 'Fresh Mutton', 'Sea Fish', 'Prawns', 'Brown Eggs'],
    ),
  ];

  static final Map<String, List<Map<String, dynamic>>> _allMockProducts = {
    ...kAllCatalogProducts,
    'pooja-needs': [
      {
        'id': 'p7',
        'name': 'Cycle Pure Agarbatti',
        'subtitle': '250g Fragrance Pack',
        'price': 85.0,
        'mrp': 110.0,
        'image': 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=400&q=80',
        'sub': 'Agarbatti',
        'rating': 4.9,
        'inStock': true,
      },
      {
        'id': 'p8',
        'name': 'Bhimseni Pure Camphor',
        'subtitle': '100g Jar',
        'price': 140.0,
        'mrp': 175.0,
        'image': 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=400&q=80',
        'sub': 'Camphor',
        'rating': 4.9,
        'inStock': true,
      },
    ],
  };
}
