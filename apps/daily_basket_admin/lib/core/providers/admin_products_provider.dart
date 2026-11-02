import 'package:flutter/material.dart';

/// Product Model for Daily Basket Enterprise Admin
class AdminProduct {
  final String id;
  String name;
  String brand;
  String sku;
  String barcode;
  String category;
  double price;
  double originalPrice;
  int stockAvailable;
  int reserved;
  String unit;
  String image;
  String description;
  String status; // 'Published', 'Draft', 'Out of Stock'
  bool isFeatured;
  double taxRate;
  DateTime createdAt;

  AdminProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.sku,
    this.barcode = '',
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.stockAvailable,
    this.reserved = 0,
    required this.unit,
    required this.image,
    required this.description,
    this.status = 'Published',
    this.isFeatured = false,
    this.taxRate = 5.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get discountPercent {
    if (originalPrice <= price || originalPrice <= 0) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  bool get isLowStock => stockAvailable > 0 && stockAvailable <= 20;
  bool get isOutOfStock => stockAvailable <= 0;

  String get stockBadge {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  String get formattedPrice {
    return '₹${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';
  }

  String get formattedOriginalPrice {
    return '₹${originalPrice.toStringAsFixed(originalPrice.truncateToDouble() == originalPrice ? 0 : 2)}';
  }

  String get marginPercentage {
    // Estimated retail margin formula: (Price - EstCost) / Price
    final estimatedCost = originalPrice * 0.65;
    if (price <= 0) return '0%';
    final margin = ((price - estimatedCost) / price * 100).clamp(5, 75).round();
    return '$margin%';
  }

  AdminProduct copyWith({
    String? id,
    String? name,
    String? brand,
    String? sku,
    String? barcode,
    String? category,
    double? price,
    double? originalPrice,
    int? stockAvailable,
    int? reserved,
    String? unit,
    String? image,
    String? description,
    String? status,
    bool? isFeatured,
    double? taxRate,
    DateTime? createdAt,
  }) {
    return AdminProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stockAvailable: stockAvailable ?? this.stockAvailable,
      reserved: reserved ?? this.reserved,
      unit: unit ?? this.unit,
      image: image ?? this.image,
      description: description ?? this.description,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      taxRate: taxRate ?? this.taxRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Admin Products Provider / Controller
/// Powers all product management features across the admin app
class AdminProductsProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedStatusFilter = 'All Products';
  String _selectedCategoryFilter = 'All';
  String _selectedSort = 'Default';

  final List<AdminProduct> _products = [
    AdminProduct(
      id: 'FR-BAN-001',
      brand: 'FRESH FARMS',
      name: 'Organic Bananas (Robusta)',
      sku: 'SKU: FR-BAN-001',
      barcode: '8901234567890',
      category: 'Produce',
      price: 49.0,
      originalPrice: 65.0,
      stockAvailable: 345,
      reserved: 12,
      unit: '1 kg',
      status: 'Published',
      isFeatured: true,
      image: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300',
      description: 'Hand-picked organic Robusta bananas directly sourced from local Karnataka farmers. Rich in potassium and natural energy.',
    ),
    AdminProduct(
      id: 'DY-MLK-042',
      brand: 'VALLEY DAIRY',
      name: 'Fresh Cow Milk (1L Glass Bottle)',
      sku: 'SKU: DY-MLK-042',
      barcode: '8901234567891',
      category: 'Dairy & Eggs',
      price: 56.0,
      originalPrice: 60.0,
      stockAvailable: 14, // Low stock!
      reserved: 4,
      unit: '1 L',
      status: 'Published',
      isFeatured: true,
      image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300',
      description: 'Pasteurized, unhomogenized farm-fresh cow milk delivered in sustainable glass bottles.',
    ),
    AdminProduct(
      id: 'DY-BUT-018',
      brand: 'AMUL',
      name: 'Amul Salted Butter 500g',
      sku: 'SKU: DY-BUT-018',
      barcode: '8901234567892',
      category: 'Dairy & Eggs',
      price: 275.0,
      originalPrice: 285.0,
      stockAvailable: 85,
      reserved: 6,
      unit: '500 g',
      status: 'Published',
      isFeatured: false,
      image: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300',
      description: 'Classic pasteurized salted butter, delicious on warm toast, dosas, and baking.',
    ),
    AdminProduct(
      id: 'PR-TOM-005',
      brand: 'LOCAL HARVEST',
      name: 'Farm Fresh Tomatoes (Hybrid)',
      sku: 'SKU: PR-TOM-005',
      barcode: '8901234567893',
      category: 'Produce',
      price: 38.0,
      originalPrice: 45.0,
      stockAvailable: 210,
      reserved: 18,
      unit: '1 kg',
      status: 'Published',
      isFeatured: false,
      image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300',
      description: 'Plump, ripe hybrid tomatoes ideal for curries, salads, and fresh purées.',
    ),
    AdminProduct(
      id: 'BD-SD-003',
      brand: 'ARTISAN BAKERY',
      name: 'Sourdough Country Loaf',
      sku: 'SKU: BD-SD-003',
      barcode: '8901234567894',
      category: 'Bakery',
      price: 110.0,
      originalPrice: 130.0,
      stockAvailable: 28,
      reserved: 5,
      unit: '400 g',
      status: 'Published',
      isFeatured: true,
      image: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300',
      description: 'Naturally fermented 36-hour sourdough baked in stone hearth ovens.',
    ),
    AdminProduct(
      id: 'BEV-JUC-012',
      brand: 'RAW PRESSERY',
      name: 'Valencia Orange Juice (Cold-Pressed)',
      sku: 'SKU: BEV-JUC-012',
      barcode: '8901234567895',
      category: 'Beverages',
      price: 180.0,
      originalPrice: 220.0,
      stockAvailable: 6, // Low Stock!
      reserved: 2,
      unit: '1 L',
      status: 'Published',
      isFeatured: false,
      image: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300',
      description: '100% pure cold-pressed Valencia oranges without added sugar, preservatives, or concentrates.',
    ),
    AdminProduct(
      id: 'SNK-CHIP-088',
      brand: 'KETTLE STUDIO',
      name: 'Rock Salt Gourmet Potato Crisps',
      sku: 'SKU: SNK-CHIP-088',
      barcode: '8901234567896',
      category: 'Snacks',
      price: 85.0,
      originalPrice: 99.0,
      stockAvailable: 0, // Out of Stock!
      reserved: 0,
      unit: '113 g',
      status: 'Out of Stock',
      isFeatured: false,
      image: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=300',
      description: 'Slow-cooked batch kettle crisps with Himalayan pink rock salt.',
    ),
    AdminProduct(
      id: 'PAN-ATT-001',
      brand: 'AASHIRVAAD',
      name: 'Aashirvaad Superior MP Atta',
      sku: 'SKU: PAN-ATT-001',
      barcode: '8901234567897',
      category: 'Pantry',
      price: 260.0,
      originalPrice: 295.0,
      stockAvailable: 95,
      reserved: 8,
      unit: '5 kg',
      status: 'Published',
      isFeatured: true,
      image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
      description: '100% whole wheat chakki atta from finest Madhya Pradesh golden wheat grains.',
    ),
    AdminProduct(
      id: 'DY-EGG-006',
      brand: 'HAPPY HENS',
      name: 'Free-Range Brown Eggs (Pack of 6)',
      sku: 'SKU: DY-EGG-006',
      barcode: '8901234567898',
      category: 'Dairy & Eggs',
      price: 65.0,
      originalPrice: 75.0,
      stockAvailable: 52,
      reserved: 3,
      unit: '6 pcs',
      status: 'Published',
      isFeatured: false,
      image: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=300',
      description: 'Cruelty-free pasture raised brown eggs packed with Omega-3 and natural vitamin D.',
    ),
    AdminProduct(
      id: 'PR-AVO-002',
      brand: 'DAILY BASKET SELECT',
      name: 'Hass Avocados (Pack of 2)',
      sku: 'SKU: PR-AVO-002',
      barcode: '8901234567899',
      category: 'Produce',
      price: 199.0,
      originalPrice: 240.0,
      stockAvailable: 18, // Low Stock!
      reserved: 3,
      unit: '2 pcs',
      status: 'Published',
      isFeatured: true,
      image: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300',
      description: 'Creamy Hass avocados ripened to buttery perfection. Essential for guacamole and toasts.',
    ),
  ];

  // Getters
  List<AdminProduct> get allProducts => List.unmodifiable(_products);
  String get searchQuery => _searchQuery;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get selectedSort => _selectedSort;

  List<String> get categories => [
        'All',
        'Produce',
        'Dairy & Eggs',
        'Bakery',
        'Beverages',
        'Snacks',
        'Pantry',
      ];

  List<AdminProduct> get filteredProducts {
    return _products.where((p) {
      // 1. Status Filter
      final matchesStatus = switch (_selectedStatusFilter) {
        'Low Stock' => p.isLowStock,
        'Out of Stock' => p.isOutOfStock,
        'Published' => p.status == 'Published' && !p.isOutOfStock,
        'Draft' => p.status == 'Draft',
        _ => true,
      };

      // 2. Category Filter
      final matchesCategory = _selectedCategoryFilter == 'All' ||
          p.category.toLowerCase() == _selectedCategoryFilter.toLowerCase();

      // 3. Search Query
      if (_searchQuery.trim().isEmpty) {
        return matchesStatus && matchesCategory;
      }
      final q = _searchQuery.toLowerCase().trim();
      final matchesQuery = p.name.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.barcode.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);

      return matchesStatus && matchesCategory && matchesQuery;
    }).toList()
      ..sort((a, b) {
        return switch (_selectedSort) {
          'Price: Low to High' => a.price.compareTo(b.price),
          'Price: High to Low' => b.price.compareTo(a.price),
          'Stock: Low to High' => a.stockAvailable.compareTo(b.stockAvailable),
          'Name: A-Z' => a.name.compareTo(b.name),
          _ => b.createdAt.compareTo(a.createdAt),
        };
      });
  }

  // Dashboard & Metrics
  int get totalProductsCount => _products.length;
  int get lowStockCount => _products.where((p) => p.isLowStock).length;
  int get outOfStockCount => _products.where((p) => p.isOutOfStock).length;
  int get activePublishedCount => _products.where((p) => p.status == 'Published').length;
  double get totalInventoryValue =>
      _products.fold(0.0, (sum, p) => sum + (p.price * p.stockAvailable));

  // Search & Filter Controllers
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setSort(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedStatusFilter = 'All Products';
    _selectedCategoryFilter = 'All';
    _selectedSort = 'Default';
    notifyListeners();
  }

  // CRUD Product Actions
  void addProduct(AdminProduct product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(AdminProduct updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void quickUpdateStock(String id, int newStock) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _products[index];
      p.stockAvailable = newStock.clamp(0, 99999);
      if (p.stockAvailable <= 0) {
        p.status = 'Out of Stock';
      } else if (p.status == 'Out of Stock') {
        p.status = 'Published';
      }
      notifyListeners();
    }
  }

  void adjustStock(String id, int delta) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _products[index];
      p.stockAvailable = (p.stockAvailable + delta).clamp(0, 99999);
      if (p.stockAvailable <= 0) {
        p.status = 'Out of Stock';
      } else if (p.status == 'Out of Stock') {
        p.status = 'Published';
      }
      notifyListeners();
    }
  }

  void quickUpdatePrice(String id, double newPrice, [double? newOriginalPrice]) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _products[index];
      p.price = newPrice;
      if (newOriginalPrice != null && newOriginalPrice >= newPrice) {
        p.originalPrice = newOriginalPrice;
      }
      notifyListeners();
    }
  }

  void toggleProductStatus(String id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _products[index];
      if (p.status == 'Published') {
        p.status = 'Draft';
      } else if (p.status == 'Draft') {
        p.status = p.stockAvailable > 0 ? 'Published' : 'Out of Stock';
      } else if (p.status == 'Out of Stock') {
        p.status = 'Published';
        if (p.stockAvailable <= 0) p.stockAvailable = 10;
      }
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void duplicateProduct(String id) {
    final original = _products.firstWhere((p) => p.id == id);
    final clone = original.copyWith(
      id: 'PRD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: '${original.name} (Copy)',
      sku: '${original.sku}-COPY',
      createdAt: DateTime.now(),
      status: 'Draft',
    );
    _products.insert(0, clone);
    notifyListeners();
  }

  AdminProduct? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
