import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Search Results Screen — Exact Google Stitch Specification
/// Matches:
/// - Sticky Search bar with clear button & filter sliders icon
/// - Filter Chips horizontal scroll bar (All, Organic, On Sale, Under ₹50)
/// - 2-Column Product Card Grid with tags, high-res images, prices, and + buttons
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchCtrl =
      TextEditingController(text: 'Tomatoes');
  String _selectedFilter = 'All';
  final Map<String, int> _cartQuantities = {};

  final List<String> _filters = ['All', 'Organic', 'On Sale', 'Under ₹50'];

  final List<Map<String, dynamic>> _searchResults = [
    {
      'id': 's1',
      'name': 'Organic Farm Fresh Tomatoes',
      'weight': '500g',
      'price': '₹24',
      'mrp': '₹40',
      'tag': '40% OFF',
      'image':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
    },
    {
      'id': 's2',
      'name': 'Fresh Cherry Tomatoes Pack',
      'weight': '250g',
      'price': '₹45',
      'mrp': '₹60',
      'tag': 'Organic',
      'image':
          'https://images.unsplash.com/photo-1546470427-227c7369a649?w=400&q=80',
    },
    {
      'id': 's3',
      'name': 'Tomato Puree Tetra Pack',
      'weight': '200g',
      'price': '₹30',
      'mrp': '₹35',
      'image':
          'https://images.unsplash.com/photo-1590779033100-9f60a05a013d?w=400&q=80',
    },
    {
      'id': 's4',
      'name': 'Italian Sun-Dried Tomatoes',
      'weight': '150g',
      'price': '₹120',
      'mrp': '₹150',
      'tag': 'Imported',
      'image':
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&q=80',
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            decoration: const InputDecoration(
              hintText: 'Search groceries...',
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: Color(0xFF6E7A6C),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter Results', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(label: const Text('All'), selected: true, onSelected: (_) {}),
                          ChoiceChip(label: const Text('Organic'), selected: false, onSelected: (_) {}),
                          ChoiceChip(label: const Text('10-Min Fast'), selected: false, onSelected: (_) {}),
                          ChoiceChip(label: const Text('Best Discount'), selected: false, onSelected: (_) {}),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
                        setState(() => _selectedFilter = filter);
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
                  Text(
                    'Showing ${_searchResults.length} results for "${_searchCtrl.text}"',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        final qty = _cartQuantities[item['id']] ?? 0;

                        return Container(
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
                                  Container(
                                    width: double.infinity,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9FC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (item.containsKey('tag'))
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
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
                                        item['price'],
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      if (item.containsKey('mrp'))
                                        Text(
                                          item['mrp'],
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors.onSurfaceVariant,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _cartQuantities[item['id']] = qty + 1;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(18),
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
                                                  fontWeight: FontWeight.w700,
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
                        );
                      },
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
