import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {
    'prod-001',
    'prod-003',
    'prod-005',
    'prod-007',
  };

  final List<Map<String, dynamic>> _allFavorites = [
    {
      'id': 'prod-001',
      'name': 'Organic Farm Fresh Tomatoes',
      'brand': 'Organic India',
      'weight': '500g',
      'mrp': 55.0,
      'price': 45.0,
      'discountPercent': 18,
      'category': 'Fresh Vegetables',
      'categoryId': 'cat-veg',
      'stockStatus': 'IN_STOCK',
      'stockQuantity': 42,
      'deliveryTime': '10 mins',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
      'addedAt': DateTime.now().subtract(const Duration(hours: 2)),
      'salesCount': 1420,
    },
    {
      'id': 'prod-003',
      'name': 'Amul Taaza Toned Fresh Milk',
      'brand': 'Amul',
      'weight': '1 L',
      'mrp': 75.0,
      'price': 68.0,
      'discountPercent': 9,
      'category': 'Dairy & Eggs',
      'categoryId': 'cat-dairy',
      'stockStatus': 'IN_STOCK',
      'stockQuantity': 18,
      'deliveryTime': '8 mins',
      'rating': 4.9,
      'imageUrl': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
      'addedAt': DateTime.now().subtract(const Duration(days: 1)),
      'salesCount': 3890,
    },
    {
      'id': 'prod-005',
      'name': 'Aashirvaad Shuddh Chakki Atta',
      'brand': 'Aashirvaad',
      'weight': '5 kg',
      'mrp': 310.0,
      'price': 265.0,
      'discountPercent': 15,
      'category': 'Atta, Rice & Dal',
      'categoryId': 'cat-staples',
      'stockStatus': 'IN_STOCK',
      'stockQuantity': 55,
      'deliveryTime': '12 mins',
      'rating': 4.7,
      'imageUrl': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
      'addedAt': DateTime.now().subtract(const Duration(days: 3)),
      'salesCount': 2450,
    },
    {
      'id': 'prod-007',
      'name': 'Cold-Pressed Almond Oil',
      'brand': 'Banyan Botanicals',
      'weight': '500 ml',
      'mrp': 699.0,
      'price': 599.0,
      'discountPercent': 14,
      'category': 'Oils & Ghee',
      'categoryId': 'cat-oils',
      'stockStatus': 'LOW_STOCK',
      'stockQuantity': 3,
      'deliveryTime': '15 mins',
      'rating': 4.6,
      'imageUrl': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
      'addedAt': DateTime.now().subtract(const Duration(days: 5)),
      'salesCount': 890,
    },
  ];

  bool _isLoading = false;
  String _selectedCategory = 'ALL';
  String _searchQuery = '';
  String _sortBy = 'RECENTLY_ADDED'; // RECENTLY_ADDED, PRICE_LOW_HIGH, PRICE_HIGH_LOW, ALPHABETICAL, BEST_SELLING
  bool _isGridView = true;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isGridView => _isGridView;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  List<Map<String, dynamic>> get items {
    var result = _allFavorites.where((item) => _favoriteIds.contains(item['id'])).toList();

    if (_selectedCategory != 'ALL') {
      result = result.where((item) => item['categoryId'] == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((item) =>
        (item['name'] as String).toLowerCase().contains(q) ||
        (item['brand'] as String).toLowerCase().contains(q)
      ).toList();
    }

    switch (_sortBy) {
      case 'PRICE_LOW_HIGH':
        result.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
        break;
      case 'PRICE_HIGH_LOW':
        result.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
        break;
      case 'ALPHABETICAL':
        result.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'BEST_SELLING':
        result.sort((a, b) => (b['salesCount'] as int).compareTo(a['salesCount'] as int));
        break;
      case 'RECENTLY_ADDED':
      default:
        result.sort((a, b) => (b['addedAt'] as DateTime).compareTo(a['addedAt'] as DateTime));
        break;
    }

    return result;
  }

  int get count => _favoriteIds.length;

  void toggleFavorite(String productId, [Map<String, dynamic>? productDetails]) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
      if (productDetails != null && !_allFavorites.any((e) => e['id'] == productId)) {
        _allFavorites.add({
          'id': productId,
          'name': productDetails['name'] ?? 'Product $productId',
          'brand': productDetails['brand'] ?? 'Daily Basket',
          'weight': productDetails['weight'] ?? '1 unit',
          'mrp': (productDetails['mrp'] ?? 100.0) as double,
          'price': (productDetails['price'] ?? 80.0) as double,
          'discountPercent': productDetails['discountPercent'] ?? 20,
          'category': productDetails['category'] ?? 'Groceries',
          'categoryId': productDetails['categoryId'] ?? 'cat-gen',
          'stockStatus': 'IN_STOCK',
          'stockQuantity': 25,
          'deliveryTime': '10 mins',
          'rating': 4.8,
          'imageUrl': productDetails['imageUrl'] ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
          'addedAt': DateTime.now(),
          'salesCount': 500,
        });
      }
    }
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favoriteIds.remove(productId);
    notifyListeners();
  }

  void clearAll() {
    _favoriteIds.clear();
    notifyListeners();
  }

  void setCategory(String catId) {
    _selectedCategory = catId;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  void refresh() {
    _isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 400), () {
      _isLoading = false;
      notifyListeners();
    });
  }
}
