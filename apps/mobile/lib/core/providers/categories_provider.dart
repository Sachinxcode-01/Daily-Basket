import 'package:flutter/material.dart';

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

  List<CategoryItem> get categories => _categories.isEmpty ? _defaultCategories : _categories;
  List<CategoryItem> get featuredCategories => categories.where((c) => c.isFeatured).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedSubcategory => _selectedSubcategory;
  String get searchQuery => _searchQuery;
  String get sortOption => _sortOption;

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

  CategoryItem findBySlugOrId(String identifier) {
    return categories.firstWhere(
      (c) => c.id == identifier || c.slug == identifier,
      orElse: () => categories.first,
    );
  }

  List<Map<String, dynamic>> getProductsForCategory(String categorySlug) {
    final cat = findBySlugOrId(categorySlug);
    List<Map<String, dynamic>> products = _allMockProducts[cat.slug] ?? _allMockProducts['fresh-fruits-vegetables']!;

    if (_selectedSubcategory != 'All') {
      products = products.where((p) => p['sub'] == _selectedSubcategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      products = products.where((p) => p['name'].toString().toLowerCase().contains(q)).toList();
    }

    if (_sortOption == 'price_low_high') {
      products.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
    } else if (_sortOption == 'price_high_low') {
      products.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
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
    'fresh-fruits-vegetables': [
      {
        'id': 'prod_veg_tomato',
        'name': 'Fresh Country Tomatoes (Tamatar)',
        'subtitle': 'Local Farm Fresh',
        'unit': '500g',
        'price': 24.0,
        'mrp': 35.0,
        'badge': '31% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.9,
        'image': 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
      },
      {
        'id': 'prod_veg_onion',
        'name': 'Fresh Red Onions (Pyaaz)',
        'subtitle': 'Premium Quality',
        'unit': '1 kg',
        'price': 35.0,
        'mrp': 50.0,
        'badge': '30% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.8,
        'image': 'assets/products/fresh-vegetables/00f0d26a-7b61-4e84-8903-abed0e2c4f69.png',
      },
      {
        'id': 'prod_veg_potato',
        'name': 'Premium Jyoti Potatoes (Aloo)',
        'subtitle': 'Everyday Staple',
        'unit': '1 kg',
        'price': 28.0,
        'mrp': 40.0,
        'badge': 'Hot Deal',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.7,
        'image': 'assets/products/fresh-vegetables/02df8262-1ccc-4078-a215-991a85ded7b0.png',
      },
      {
        'id': 'prod_veg_spinach',
        'name': 'Farm Fresh Palak (Spinach)',
        'subtitle': 'Handpicked Green',
        'unit': '250g',
        'price': 20.0,
        'mrp': 30.0,
        'badge': 'Organic',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Organic',
        'sub': 'Leafy Greens',
        'rating': 4.9,
        'image': 'assets/products/fresh-vegetables/079cdbf5-0e6e-4de4-ad0a-447e56ae8016.png',
      },
      {
        'id': 'prod_veg_chilli',
        'name': 'Fresh Green Chillies (Hari Mirch)',
        'subtitle': 'Spicy & Crisp',
        'unit': '100g',
        'price': 14.0,
        'mrp': 20.0,
        'badge': 'Mandi Fresh',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.8,
        'image': 'assets/products/fresh-vegetables/083c2cf1-36a0-4328-98a1-fbe6e0ec1d0a.png',
      },
      {
        'id': 'prod_veg_lemon',
        'name': 'Juicy Yellow Lemons (Nimbu)',
        'subtitle': 'High Vitamin C',
        'unit': '4 pcs',
        'price': 18.0,
        'mrp': 25.0,
        'badge': 'Seasonal',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.9,
        'image': 'assets/products/fresh-vegetables/0908a205-26bf-4135-969a-9002b302069c.png',
      },
      {
        'id': 'prod_gala_apple',
        'name': 'Royal Gala Apple',
        'subtitle': 'Daily Basket Select',
        'unit': '500g',
        'price': 140.0,
        'mrp': 160.0,
        'badge': '10% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Fruits',
        'rating': 4.9,
        'image':
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600&auto=format&fit=crop&q=80',
      },
      {
        'id': 'prod_banana_cavendish',
        'name': 'Premium Cavendish Banana',
        'subtitle': 'Organic',
        'unit': '1 kg',
        'price': 65.0,
        'mrp': 75.0,
        'badge': 'Out of Stock',
        'inStock': false,
        'category': 'Organic',
        'sub': 'Fresh Fruits',
        'rating': 4.8,
        'image':
            'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=600&auto=format&fit=crop&q=80',
      },
      {
        'id': 'prod_baby_spinach',
        'name': 'Organic Baby Spinach',
        'subtitle': 'Local Farm',
        'unit': '200g',
        'price': 45.0,
        'mrp': 55.0,
        'badge': 'Daily Basket Select',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Organic',
        'sub': 'Leafy Greens',
        'rating': 4.9,
        'image':
            'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=600&auto=format&fit=crop&q=80',
      },
      {
        'id': 'prod_dutch_carrots',
        'name': 'Dutch Carrots with Tops',
        'subtitle': 'Daily Basket Select',
        'unit': '1 Bunch (500g)',
        'price': 55.0,
        'mrp': 65.0,
        'badge': 'New',
        'badgeColor': const Color(0xFFDCE5DD),
        'badgeTextColor': const Color(0xFF404943),
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.7,
        'image':
            'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600&auto=format&fit=crop&q=80',
      },
      {
        'id': 'prod_hass_avocado',
        'name': 'Organic Hass Avocado',
        'subtitle': 'Daily Basket Select',
        'unit': '2 pcs (400g)',
        'price': 120.0,
        'mrp': 150.0,
        'badge': '20% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Organic',
        'sub': 'Exotics & Premium',
        'rating': 4.8,
        'image':
            'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=600&auto=format&fit=crop&q=80',
      },
      {
        'id': 'prod_red_capsicum',
        'name': 'Fresh Red Bell Pepper',
        'subtitle': 'Hydroponic Farm',
        'unit': '250g',
        'price': 70.0,
        'mrp': 85.0,
        'badge': 'Hydroponic',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.6,
        'image':
            'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=600&auto=format&fit=crop&q=80',
      },
      {
        'id': 'prod_farm_tomatoes',
        'name': 'Organic Farm Tomatoes',
        'subtitle': 'Farm Fresh',
        'unit': '500g',
        'price': 32.0,
        'mrp': 45.0,
        'badge': 'Farm Fresh',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'category': 'Seasonal',
        'sub': 'Fresh Vegetables',
        'rating': 4.8,
        'image':
            'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
      },
    ],
    'dairy-bread-eggs': [
      {
        'id': 'prod_milk_taaza',
        'name': 'Amul Taaza Toned Milk',
        'subtitle': '500 ml Pouch',
        'brand': 'Amul',
        'price': 28.0,
        'mrp': 28.0,
        'badge': 'Daily Essential',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Milk',
        'rating': 4.9,
        'reviews': '3.4k',
        'image': 'assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
      },
      {
        'id': 'prod_milk_cow',
        'name': 'Fresh Cow Milk Pouch',
        'subtitle': '1 L Pouch',
        'brand': 'Nandini',
        'price': 56.0,
        'mrp': 58.0,
        'badge': 'Fresh',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Milk',
        'rating': 4.8,
        'reviews': '1.8k',
        'image': 'assets/products/milk/20c80cb9-33fb-4d4f-bdde-91ffa4490e57.png',
      },
      {
        'id': 'prod_curd_masti',
        'name': 'Amul Masti Dahi / Set Curd Cup',
        'subtitle': '400 g Cup',
        'brand': 'Amul',
        'price': 44.0,
        'mrp': 45.0,
        'badge': 'Popular',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Curd & Yogurt',
        'rating': 4.9,
        'reviews': '2.1k',
        'image': 'assets/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
      },
      {
        'id': 'prod_bread_sandwich',
        'name': 'Fresh Sandwich White Bread',
        'subtitle': '400 g Pack',
        'brand': 'Britannia',
        'price': 40.0,
        'mrp': 45.0,
        'badge': 'Bakery Fresh',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Bread & Pav',
        'rating': 4.8,
        'reviews': '940',
        'image': 'assets/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
      },
      {
        'id': 'prod_ladi_pav',
        'name': 'Soft Ladi Pav Pack',
        'subtitle': '6 pcs Pack',
        'brand': 'Local Bakery',
        'price': 25.0,
        'mrp': 30.0,
        'badge': 'Oven Fresh',
        'badgeColor': const Color(0xFF006B23),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Bread & Pav',
        'rating': 4.7,
        'reviews': '520',
        'image': 'assets/products/bread-pav/036bad6d-4fbc-4c42-a18a-4bf33a3dfb6b.png',
      },
    ],
    'snacks-packaged-foods': [
      {
        'id': 'prod_cereal_chocos',
        'name': 'Choco Crunch Flakes & Kids Cereal',
        'subtitle': '375 g Box',
        'brand': "Kellogg's",
        'price': 175.0,
        'mrp': 210.0,
        'badge': '16% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Ready To Eat',
        'rating': 4.9,
        'reviews': '1.5k',
        'image': 'assets/products/flakes-kids-cereals/01e92a08-b40b-4d6f-aca7-8537cd382447.png',
      },
    ],
    'grocery': [
      {
        'id': 'prod_grain_poha',
        'name': 'Thick Poha (Flattened Rice)',
        'subtitle': '500 g Pack',
        'brand': 'Daily Basket Select',
        'price': 34.0,
        'mrp': 42.0,
        'badge': '19% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Poha',
        'rating': 4.8,
        'reviews': '680',
        'image': 'assets/products/poha-daliya-grains/1092_1643384330629.png',
      },
      {
        'id': 'prod_vermicelli_roasted',
        'name': 'Roasted Wheat Vermicelli (Sevai)',
        'subtitle': '400 g Pack',
        'brand': 'Bambino',
        'price': 42.0,
        'mrp': 50.0,
        'badge': '16% OFF',
        'badgeColor': const Color(0xFFBA1A1A),
        'badgeTextColor': Colors.white,
        'inStock': true,
        'sub': 'Sooji',
        'rating': 4.7,
        'reviews': '410',
        'image': 'assets/products/vermicelli/3da21b8f-16e5-4727-9899-c5ef3e1db668.png',
      },
      {
        'id': 'p4',
        'name': 'Fortune Basmati Rice',
        'subtitle': '5 kg Pack',
        'price': 499.0,
        'mrp': 650.0,
        'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80',
        'sub': 'Rice',
        'rating': 4.9,
        'inStock': true,
      },
      {
        'id': 'p5',
        'name': 'Aashirvaad Shuddh Chakki Atta',
        'subtitle': '10 kg Pack',
        'price': 420.0,
        'mrp': 510.0,
        'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
        'sub': 'Atta',
        'rating': 4.8,
        'inStock': true,
      },
      {
        'id': 'p6',
        'name': 'Tata Sampann Toor Dal',
        'subtitle': '1 kg Pack',
        'price': 165.0,
        'mrp': 195.0,
        'image': 'https://images.unsplash.com/photo-1515543237350-b3eea1ec8082?w=400&q=80',
        'sub': 'Dal',
        'rating': 4.7,
        'inStock': true,
      },
    ],
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
