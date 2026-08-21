import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/search_history_provider.dart';
import '../../../../core/providers/cart_provider.dart';

/// Search Screen — Google Stitch Exact Screen
/// Screen ID: 57d6d934e00f42a7be2f9c6f89e3e5cd
/// Project: Daily Basket Quick-Commerce Suite
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, String>> _categories = [
    {
      'title': 'Organic Vegetables',
      'query': 'Vegetables',
      'imageUrl':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Dairy & Eggs',
      'query': 'Dairy',
      'imageUrl':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Snacks',
      'query': 'Snacks',
      'imageUrl':
          'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Bakery',
      'query': 'Bakery',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    try {
      context.read<SearchHistoryProvider>().addQuery(trimmed);
    } catch (_) {}

    Navigator.pushNamed(
      context,
      '/search-results',
      arguments: trimmed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<SearchHistoryProvider>();
    final recentSearches = historyProvider.history.isNotEmpty
        ? historyProvider.history
        : ['Fresh Milk', 'Avocados', 'Sourdough'];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Daily Basket',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, _) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_basket_outlined, color: AppColors.onSurfaceVariant),
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                        if (cart.totalCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                '${cart.totalCount}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Search Input Bar ─────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 14, right: 10),
                        child: Icon(Icons.search, color: AppColors.primary, size: 22),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          onSubmitted: _submitSearch,
                          style: GoogleFonts.inter(fontSize: 15, color: AppColors.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Search groceries...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AppColors.onSurfaceVariant),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.mic_outlined, size: 20, color: AppColors.onSurfaceVariant),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Listening for voice search... Speak now'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ─── Recent Searches ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        historyProvider.clearAll();
                      },
                      child: Text(
                        'CLEAR ALL',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentSearches.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.surfaceVariant),
                  itemBuilder: (context, index) {
                    final item = recentSearches[index];
                    return InkWell(
                      onTap: () => _submitSearch(item),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 18,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.north_west,
                              size: 16,
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // ─── Popular Categories ───────────────────────────────────────
                Text(
                  'Popular Categories',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 14),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return InkWell(
                      onTap: () => _submitSearch(cat['query']!),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceVariant),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Background Image
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.75,
                                child: Image.network(
                                  cat['imageUrl']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
                                ),
                              ),
                            ),
                            // Gradient Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Title
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Text(
                                cat['title']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
