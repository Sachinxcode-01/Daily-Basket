import 'package:flutter/material.dart';
import '../../../categories/presentation/screens/browse_categories_screen.dart';

/// CategoriesScreen — Proxy to BrowseCategoriesScreen for unified category taxonomy
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrowseCategoriesScreen();
  }
}
