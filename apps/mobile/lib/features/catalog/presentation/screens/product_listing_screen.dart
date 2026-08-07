import 'package:flutter/material.dart';
import '../../../categories/presentation/screens/category_products_screen.dart';

/// ProductListingScreen — Proxy to CategoryProductsScreen for unified design system compliance
class ProductListingScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProductListingScreen({
    super.key,
    this.categoryId = 'fresh-fruits-vegetables',
    this.categoryName = 'Fruits & Vegetables',
  });

  @override
  Widget build(BuildContext context) {
    return CategoryProductsScreen(categorySlug: categoryId);
  }
}
