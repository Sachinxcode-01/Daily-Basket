import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/search_history_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/data/products_catalog_data.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../catalog/presentation/screens/product_details_screen.dart';

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
  bool _initializedArgs = false;

  final List<Map<String, String>> _categories = [
    {
      'title': 'Fresh Vegetables (154)',
      'query': 'Vegetables',
      'imageUrl': 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    },
    {
      'title': 'Bread & Pav (248)',
      'query': 'Bread',
      'imageUrl': 'assets/products/bread-pav/00021c97-6a3f-4e0d-b873-455b88015ff7.png',
    },
    {
      'title': 'Dairy & Milk (41)',
      'query': 'Milk',
      'imageUrl': 'assets/products/milk/0a9446f2-8419-48fb-bce5-8ff5e9c0cae6.png',
    },
    {
      'title': 'Curd & Yogurt (78)',
      'query': 'Curd',
      'imageUrl': 'assets/products/curd-yogurt/0024f2b9-e1f2-4eb4-9ae8-936601b3f9ff.png',
    },
    {
      'title': 'Flakes & Cereals (53)',
      'query': 'Flakes',
      'imageUrl': 'assets/products/flakes-kids-cereals/004c316d-318e-4f15-8fa9-43c35b369db0.png',
    },
    {
      'title': 'Grains & Poha (17)',
      'query': 'Poha',
      'imageUrl': 'assets/products/poha-daliya-grains/08a3d56b-f53e-4361-bd80-d6360c7f763f.png',
    },
    {
      'title': 'Vermicelli (16)',
      'query': 'Vermicelli',
      'imageUrl': 'assets/products/vermicelli/0b0932bb-8e3b-4171-80a5-f946eef24f5a.png',
    },
    {
      'title': 'All Products (607)',
      'query': '',
      'imageUrl': 'assets/products/bread-pav/0091807d-304b-4eb9-a292-ba252b489a20.png',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedArgs) {
      _initializedArgs = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _searchController.text = args;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      Navigator.pushNamed(
        context,
        '/search-results',
        arguments: '',
      );
      return;
    }

    try {
      context.read<SearchHistoryProvider>().addQuery(trimmed);
    } catch (_) {}

    Navigator.pushNamed(
      context,
      '/search-results',
      arguments: trimmed,
    );
  }

  List<Map<String, dynamic>> _getLiveMatches(String query) {
    String norm(String s) => s
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll("'", "")
        .replaceAll('"', '')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'(\d+)(kg|g|l|ml|pc|pcs)'), r'$1 $2');

    final qClean = norm(query);
    final tokens = qClean.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    if (tokens.isEmpty) return [];

    final all = kAllCatalogProducts['all'] ?? [];
    return all.where((p) {
      final name = norm(p['name'] as String? ?? '');
      final brand = norm(p['brand'] as String? ?? '');
      final weight = norm(p['unit'] as String? ?? p['subtitle'] as String? ?? '');
      final cat = norm(p['category'] as String? ?? '');
      final sub = norm(p['sub'] as String? ?? '');
      final slug = norm(p['categorySlug'] as String? ?? p['folder'] as String? ?? '');
      final tag = norm(p['badge'] as String? ?? '');

      String synonyms = '';
      if (slug.contains('vegetables') || cat.contains('veg')) {
        synonyms += ' vegetable vegetables veggie veggies sabzi greens ';
      }
      if (slug.contains('bread') || cat.contains('bakery') || name.contains('bread') || name.contains('pav')) {
        synonyms += ' bread bakery pav bun toast rusk ';
      }
      if (slug.contains('milk') || cat.contains('milk')) {
        synonyms += ' milk dairy doodh ';
      }
      if (slug.contains('curd') || cat.contains('curd') || name.contains('dahi') || name.contains('yogurt')) {
        synonyms += ' curd yogurt dahi yoghurt probiotics ';
      }
      if (slug.contains('flakes') || cat.contains('cereal') || name.contains('corn') || name.contains('chocos')) {
        synonyms += ' flakes cereal cereals breakfast cornflakes chocos muesli granola ';
      }
      if (slug.contains('poha') || cat.contains('grain') || name.contains('dalia') || name.contains('poha')) {
        synonyms += ' poha daliya dalia grains staples atta dal pulses rice ';
      }
      if (slug.contains('vermicelli') || name.contains('seviyan') || name.contains('upma') || cat.contains('vermicelli')) {
        synonyms += ' vermicelli seviyan sevai semiya upma noodles pasta ';
      }

      final fullText = '$name $brand $weight $cat $sub $slug $tag $synonyms';
      return tokens.every((token) => fullText.contains(token));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<SearchHistoryProvider>();
    final recentSearches = historyProvider.history.isNotEmpty
        ? historyProvider.history
        : ['Amul Milk', 'Brown Bread', 'Tomatoes', 'Curd', 'Poha'];
    final queryText = _searchController.text.trim();
    final isSearching = queryText.isNotEmpty;
    final liveMatches = isSearching ? _getLiveMatches(queryText) : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
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
                            hintText: 'Search 607 groceries & essentials...',
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
                const SizedBox(height: 20),

                // ─── Live Search Results vs Default Category / History View ────
                if (isSearching) ...[
                  // Header with action to go to full results grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Found ${liveMatches.length} items',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      InkWell(
                        onTap: () => _submitSearch(queryText),
                        child: Row(
                          children: [
                            Text(
                              'View all in Search Results',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (liveMatches.isEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceVariant),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 48, color: AppColors.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text(
                            'No products found for "$queryText"',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching for milk, bread, tomatoes, curd, or vermicelli',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: ['Amul Milk', 'Brown Bread', 'Tomatoes', 'Curd', 'Poha', 'Vermicelli'].map((tag) {
                              return ActionChip(
                                label: Text(tag, style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary)),
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                                onPressed: () {
                                  _searchController.text = tag;
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: liveMatches.length > 25 ? 25 : liveMatches.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.surfaceVariant),
                      itemBuilder: (context, index) {
                        final p = liveMatches[index];
                        final name = p['name'] as String;
                        final brand = (p['brand'] ?? 'Daily Basket') as String;
                        final unit = (p['unit'] ?? p['subtitle'] ?? '1 Pack') as String;
                        final price = (p['price'] as num).toDouble().round();
                        final mrp = ((p['mrp'] as num?)?.toDouble() ?? (price * 1.25)).round();
                        final image = (p['image'] ?? '') as String;
                        final badge = (p['badge'] ?? '') as String;

                        return InkWell(
                          onTap: () {
                            try {
                              context.read<SearchHistoryProvider>().addQuery(name);
                            } catch (_) {}
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsScreen(
                                  productId: p['id'] as String,
                                  productName: name,
                                  brand: brand,
                                  price: '₹$price',
                                  mrp: '₹$mrp',
                                  unitDetails: unit,
                                  imageUrl: image,
                                  categoryTag: (p['category'] ?? 'GROCERIES').toString().toUpperCase(),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            child: Row(
                              children: [
                                // Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    color: AppColors.surfaceContainerHigh,
                                    child: AppNetworkImage(
                                      imageUrl: image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Name & Unit
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$brand • $unit',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '₹$price',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.onSurface,
                                            ),
                                          ),
                                          if (mrp > price) ...[
                                            const SizedBox(width: 6),
                                            Text(
                                              '₹$mrp',
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                color: AppColors.onSurfaceVariant,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                          if (badge.isNotEmpty) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                badge,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Consumer<CartProvider>(
                                  builder: (context, cart, _) {
                                    final pid = p['id'] as String;
                                    final qty = cart.getQuantity(pid);
                                    if (qty > 0) {
                                      return Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () => cart.updateQuantityById(
                                                id: pid,
                                                name: name,
                                                subtitle: unit,
                                                price: (p['price'] as num).toDouble(),
                                                image: image,
                                                delta: -1,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6),
                                                child: Icon(Icons.remove, size: 14, color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              '$qty',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => cart.updateQuantityById(
                                                id: pid,
                                                name: name,
                                                subtitle: unit,
                                                price: (p['price'] as num).toDouble(),
                                                image: image,
                                                delta: 1,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6),
                                                child: Icon(Icons.add, size: 14, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return OutlinedButton(
                                      onPressed: () {
                                        cart.updateQuantityById(
                                          id: pid,
                                          name: name,
                                          subtitle: unit,
                                          price: (p['price'] as num).toDouble(),
                                          image: image,
                                          delta: 1,
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        minimumSize: const Size(0, 32),
                                        side: const BorderSide(color: AppColors.primary, width: 1.2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text(
                                        'ADD',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (liveMatches.length > 25) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => _submitSearch(queryText),
                          icon: const Icon(Icons.grid_view_rounded, size: 16),
                          label: Text(
                            'See all ${liveMatches.length} matching products',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ],
                ] else ...[
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
                    'Explore All Categories (607 Items)',
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
                                  child: AppNetworkImage(
                                    imageUrl: cat['imageUrl']!,
                                    fit: BoxFit.cover,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
