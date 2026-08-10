// Google Stitch Screen ID: f7c78b705cb6471dae1b49027ca746b3
// Title: Premium Product Catalog & Search
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/staggered_animation_wrappers.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/providers/search_history_provider.dart';

/// Search Results Screen — Exact Google Stitch Specification
class SearchResultsScreen extends StatefulWidget {
  static const String stitchId = 'f7c78b705cb6471dae1b49027ca746b3';

  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _initializedFromArgs = false;

  String _selectedFilter = 'All';
  String _selectedSort = 'Relevance';
  final Map<String, int> _cartQuantities = {};

  static const List<String> _trendingSearches = [
    'Tomatoes',
    'Amul Milk',
    'Atta 5kg',
    'Farm Eggs',
    'Paneer',
    'Brown Bread',
    'Dark Chocolate',
    'Organic Honey',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedFromArgs) {
      _initializedFromArgs = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _searchCtrl.text = args;
        try {
          context.read<SearchHistoryProvider>().addQuery(args);
        } catch (_) {}
      }
    }
  }

  final List<String> _filters = [
    'All',
    'Organic',
    '10-Min Fast',
    'Best Discount',
    'Under ₹50',
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 's1',
      'name': 'Organic Farm Fresh Tomatoes',
      'weight': '500g',
      'price': 24,
      'priceStr': '₹24',
      'mrpStr': '₹40',
      'tag': '40% OFF',
      'isOrganic': true,
      'isFast': true,
      'discountPercent': 40,
      'image':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
    },
    {
      'id': 's2',
      'name': 'Fresh Cherry Tomatoes Pack',
      'weight': '250g',
      'price': 45,
      'priceStr': '₹45',
      'mrpStr': '₹60',
      'tag': 'Organic',
      'isOrganic': true,
      'isFast': true,
      'discountPercent': 25,
      'image':
          'https://images.unsplash.com/photo-1546470427-227c7369a649?w=400&q=80',
    },
    {
      'id': 's3',
      'name': 'Tomato Puree Tetra Pack',
      'weight': '200g',
      'price': 30,
      'priceStr': '₹30',
      'mrpStr': '₹35',
      'isOrganic': false,
      'isFast': false,
      'discountPercent': 14,
      'image':
          'https://images.unsplash.com/photo-1590779033100-9f60a05a013d?w=400&q=80',
    },
    {
      'id': 's4',
      'name': 'Italian Sun-Dried Tomatoes',
      'weight': '150g',
      'price': 120,
      'priceStr': '₹120',
      'mrpStr': '₹150',
      'tag': 'Imported',
      'isOrganic': false,
      'isFast': false,
      'discountPercent': 20,
      'image':
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Calculates filtered and sorted products list in real-time
  List<Map<String, dynamic>> _getFilteredProducts({
    String? filterTag,
    String? sortOption,
    String? queryText,
  }) {
    final activeFilter = filterTag ?? _selectedFilter;
    final activeSort = sortOption ?? _selectedSort;
    final query = (queryText ?? _searchCtrl.text).trim().toLowerCase();

    // 1. Text Search Filter
    List<Map<String, dynamic>> results = _allProducts.where((p) {
      if (query.isEmpty) return true;
      final name = (p['name'] as String).toLowerCase();
      return name.contains(query);
    }).toList();

    // 2. Tag & Attribute Filter
    if (activeFilter != 'All') {
      results = results.where((p) {
        switch (activeFilter) {
          case 'Organic':
            return (p['isOrganic'] == true) ||
                (p['tag'] == 'Organic') ||
                (p['name'] as String).toLowerCase().contains('organic');
          case '10-Min Fast':
            return p['isFast'] == true;
          case 'Best Discount':
          case 'On Sale':
            return (p['discountPercent'] as int? ?? 0) >= 25 ||
                p['tag'] == '40% OFF';
          case 'Under ₹50':
            return (p['price'] as int) <= 50;
          case 'Imported':
            return p['tag'] == 'Imported';
          default:
            return true;
        }
      }).toList();
    }

    // 3. Sorting
    switch (activeSort) {
      case 'Price: Low to High':
        results.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
        break;
      case 'Price: High to Low':
        results.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
        break;
      case 'Best Discount':
        results.sort((a, b) =>
            (b['discountPercent'] as int).compareTo(a['discountPercent'] as int));
        break;
      case 'Relevance':
      default:
        break;
    }

    return results;
  }

  void _openVoiceSearchSheet() {
    String currentLang = 'English';
    bool isListening = true;
    String recognizedText = 'Listening... Speak now';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future.delayed(const Duration(milliseconds: 1600), () {
              if (context.mounted && isListening) {
                setModalState(() {
                  isListening = false;
                  if (currentLang == 'Hindi') {
                    recognizedText = 'ताज़ा दूध (Fresh Milk)';
                    _searchCtrl.text = 'Milk';
                  } else if (currentLang == 'Kannada') {
                    recognizedText = 'ತಾಜಾ ಹಾಲು (Fresh Milk)';
                    _searchCtrl.text = 'Milk';
                  } else {
                    recognizedText = 'Farm Fresh Tomatoes';
                    _searchCtrl.text = 'Tomatoes';
                  }
                });
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (ctx.mounted) Navigator.pop(ctx);
                });
              }
            });

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBECAB9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Voice Product Search',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Say product names in your preferred language',
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6E7A6C)),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLangChip('English', currentLang, (l) => setModalState(() => currentLang = l)),
                      const SizedBox(width: 8),
                      _buildLangChip('Hindi', currentLang, (l) => setModalState(() => currentLang = l)),
                      const SizedBox(width: 8),
                      _buildLangChip('Kannada', currentLang, (l) => setModalState(() => currentLang = l)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: isListening ? 80 : 68,
                    height: isListening ? 80 : 68,
                    decoration: BoxDecoration(
                      color: isListening ? const Color(0xFF006B23) : const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                      boxShadow: isListening
                          ? [
                              BoxShadow(
                                color: const Color(0xFF006B23).withValues(alpha: 0.3),
                                blurRadius: 18,
                                spreadRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      isListening ? Icons.mic_rounded : Icons.check_circle_rounded,
                      color: isListening ? Colors.white : const Color(0xFF006B23),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    recognizedText,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isListening ? const Color(0xFF006B23) : const Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLangChip(String lang, String current, Function(String) onSelect) {
    final isSelected = lang == current;
    return ChoiceChip(
      label: Text(lang),
      selected: isSelected,
      selectedColor: const Color(0xFF006B23),
      backgroundColor: const Color(0xFFF3F3F6),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
      ),
      onSelected: (_) => onSelect(lang),
    );
  }

  void _openFilterBottomSheet() {
    String tempFilter = _selectedFilter;
    String tempSort = _selectedSort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final previewResults = _getFilteredProducts(
              filterTag: tempFilter,
              sortOption: tempSort,
            );
            final resultCount = previewResults.length;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Drag Handle ──────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E2E5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // ── Header Row ────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Filter Results',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$resultCount items',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempFilter = 'All';
                            tempSort = 'Relevance';
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Clear All',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Quick Filter Tags ─────────────────────────────────────
                  Text(
                    'Category & Tags',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filters.map((filter) {
                      final isSelected = tempFilter == filter;
                      return ChoiceChip(
                        selected: isSelected,
                        showCheckmark: true,
                        checkmarkColor: Colors.white,
                        avatar: isSelected
                            ? null
                            : (filter == '10-Min Fast'
                                ? const Icon(Icons.bolt_rounded,
                                    size: 16, color: AppColors.primary)
                                : null),
                        label: Text(filter),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.onSurface,
                        ),
                        backgroundColor: const Color(0xFFF3F3F6),
                        selectedColor: AppColors.primary,
                        shape: StadiumBorder(
                          side: isSelected
                              ? BorderSide.none
                              : const BorderSide(color: Color(0xFFE2E2E5)),
                        ),
                        onSelected: (bool selected) {
                          setModalState(() {
                            tempFilter = selected ? filter : 'All';
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 16),

                  // ── Organic Only Switch ─────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Organic Only',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: tempFilter == 'Organic',
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            setModalState(() {
                              tempFilter = val ? 'Organic' : 'All';
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Price Range Filter ────────────────────────────────────
                  Text(
                    'Price Range (\$2.00 - \$15.00)',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RangeSlider(
                    values: const RangeValues(2.0, 15.0),
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    activeColor: AppColors.primary,
                    labels: const RangeLabels('\$2.00', '\$15.00'),
                    onChanged: (values) {},
                  ),

                  const SizedBox(height: 12),

                  // ── PROMINENT CALL TO ACTION (CTA) BUTTON ─────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = tempFilter;
                          _selectedSort = tempSort;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withValues(alpha: 0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.tune_rounded, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              resultCount > 0
                                  ? 'Apply Filters • $resultCount ${resultCount == 1 ? 'Product' : 'Products'}'
                                  : 'No Products Match (Reset Filters)',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Search groceries...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: Color(0xFF6E7A6C),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchCtrl.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.mic_rounded, size: 20, color: AppColors.primary),
                    onPressed: _openVoiceSearchSheet,
                  ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                ),
                onPressed: _openFilterBottomSheet,
              ),
              if (_selectedFilter != 'All' || _selectedSort != 'Relevance')
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Filter Chips Bar ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      showCheckmark: isSelected,
                      checkmarkColor: Colors.white,
                      label: Text(filter),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.onSurfaceVariant,
                      ),
                      backgroundColor: const Color(0xFFF3F3F6),
                      selectedColor: AppColors.primary,
                      shape: const StadiumBorder(),
                      side: BorderSide.none,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilter = selected ? filter : 'All';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ─── Results Header & Product Grid ─────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchCtrl.text.isEmpty) ...[
                    Text(
                      '🔥 Trending Searches',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _trendingSearches.map((term) {
                        return ActionChip(
                          label: Text(term),
                          labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          backgroundColor: const Color(0xFFE8F5E9),
                          shape: const StadiumBorder(side: BorderSide(color: AppColors.primary, width: 0.5)),
                          onPressed: () {
                            setState(() {
                              _searchCtrl.text = term;
                            });
                            try {
                              context.read<SearchHistoryProvider>().addQuery(term);
                            } catch (_) {}
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Showing ${filteredProducts.length} results for "${_searchCtrl.text}"',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (_selectedFilter != 'All' || _selectedSort != 'Relevance')
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'All';
                              _selectedSort = 'Relevance';
                            });
                          },
                          child: Text(
                            'Reset Filters',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  filteredProducts.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: AppColors.outline,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No matching products found',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Try selecting a different filter or search term',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _selectedFilter = 'All';
                                      _selectedSort = 'Relevance';
                                    });
                                  },
                                  icon: const Icon(Icons.refresh_rounded, size: 18),
                                  label: const Text('Reset All Filters'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: AnimationLimiter(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.72,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final item = filteredProducts[index];
                                final qty = _cartQuantities[item['id']] ?? 0;

                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: 2,
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: AppColors.outlineVariant
                                        .withValues(alpha: 0.20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image + Tag
                                    Stack(
                                      children: [
                                         AppNetworkImage(
                                           imageUrl: item['image'] as String,
                                           width: double.infinity,
                                           height: 110,
                                           borderRadius:
                                               BorderRadius.circular(12),
                                           fallbackIcon:
                                               Icons.shopping_basket_rounded,
                                           fallbackBgColor:
                                               const Color(0xFFF3F3F6),
                                           fallbackIconColor:
                                               AppColors.primary,
                                         ),
                                        if (item.containsKey('tag'))
                                          Positioned(
                                            top: 6,
                                            left: 6,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item['tag'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      item['weight'],
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      item['name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                        height: 1.2,
                                      ),
                                    ),

                                    const Spacer(),

                                    // Price + Add Button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item['priceStr'],
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.onSurface,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            if (item.containsKey('mrpStr'))
                                              Text(
                                                item['mrpStr'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: AppColors
                                                      .onSurfaceVariant,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _cartQuantities[item['id']] =
                                                  qty + 1;
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color: qty > 0
                                                  ? AppColors.primary
                                                  : const Color(0xFFF3F3F6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: qty > 0
                                                  ? Text(
                                                      '$qty',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : const Icon(
                                                      Icons.add_rounded,
                                                      size: 20,
                                                      color: AppColors.primary,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
