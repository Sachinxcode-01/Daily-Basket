import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import '../../../../core/services/ai_copilot_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../catalog/presentation/screens/product_details_screen.dart';

/// AI Copilot Real-Time Product Recommendation Rail
/// Dynamically feeds recently viewed product IDs from mobile state
/// into AICopilotService (POST /personalization/recommendations).
/// Conforms to design.md tokens:
/// - 16px card border radius
/// - Outfit font for titles, Inter font for labels
/// - Emerald accent #2D9D43
/// - Seamless Dark Mode & Light Mode support
class AICopilotOverlay extends StatefulWidget {
  final AICopilotService? copilotService;

  const AICopilotOverlay({super.key, this.copilotService});

  @override
  State<AICopilotOverlay> createState() => _AICopilotOverlayState();
}

class _AICopilotOverlayState extends State<AICopilotOverlay> {
  late final AICopilotService _service;
  List<ProductSuggestion> _suggestions = [];
  String _reason = 'Personalized for your kitchen';
  bool _isLoading = true;
  List<String> _lastIds = [];

  @override
  void initState() {
    super.initState();
    _service = widget.copilotService ?? AICopilotService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.watch<RecentlyViewedProvider>();
    final currentIds = provider.items
        .map((i) => i['id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    // Re-fetch only when viewing history changes
    if (_lastIds.join(',') != currentIds.join(',')) {
      _lastIds = currentIds;
      _loadSuggestions(currentIds);
    }
  }

  Future<void> _loadSuggestions(List<String> ids) async {
    setState(() => _isLoading = true);
    final res = await _service.buildProductSuggestions(recentlyViewedIds: ids);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (res['success'] == true && res['items'] is List) {
        _suggestions = List<ProductSuggestion>.from(res['items']);
        _reason = res['reason']?.toString() ?? 'Picked for your daily basket';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2124) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF191C1E);
    final textSecondary =
        isDark ? const Color(0xFFB0B3B8) : const Color(0xFF3F4A3D);
    final borderDefault = isDark ? Colors.white12 : const Color(0xFFE2E2E5);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181B1E) : const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.25)
              : const Color(0xFFD5E8D8),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'AI Copilot Suggestions',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'LIVE',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.primaryFixedDim
                            : const Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Product Cards Rail
          SizedBox(
            height: 198,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (ctx, index) {
                final item = _suggestions[index];
                return Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderDefault),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(
                            productId: item.id,
                            productName: item.name,
                            brand: item.brand,
                            price: item.price,
                            mrp: item.mrp,
                            unitDetails: item.unit,
                            imageUrl: item.imageUrl,
                            categoryTag: item.category,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Thumbnail with Badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14)),
                              child: Image.network(
                                item.imageUrl,
                                height: 95,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 95,
                                  color: isDark ? Colors.white10 : Colors.black12,
                                  child: const Icon(Icons.shopping_bag_outlined),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.badgeType,
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Title & Price
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                item.unit,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.price,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final cart = context.read<CartProvider?>();
                                      if (cart != null) {
                                        final numPrice = double.tryParse(
                                                item.price.replaceAll('₹', '')) ??
                                            50.0;
                                        cart.updateQuantityById(
                                          id: item.id,
                                          name: item.name,
                                          subtitle: item.unit,
                                          price: numPrice,
                                          image: item.imageUrl,
                                          delta: 1,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Added ${item.name} to cart'),
                                            backgroundColor: AppColors.primary,
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.add_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
