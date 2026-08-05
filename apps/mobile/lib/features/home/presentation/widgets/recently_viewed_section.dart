import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Recently Viewed Products — horizontal scrollable section.
/// Reads from [RecentlyViewedProvider]. Hidden when list is empty.
class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({super.key});

  @override
  Widget build(BuildContext context) {
    RecentlyViewedProvider? rvProvider;
    CartProvider? cartProvider;

    try { rvProvider = context.watch<RecentlyViewedProvider>(); } catch (_) {}
    try { cartProvider = context.watch<CartProvider>(); } catch (_) {}

    final items = rvProvider?.items ?? [];
    if (items.isEmpty) { return const SizedBox.shrink(); }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Viewed',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              GestureDetector(
                onTap: () => rvProvider?.clearRecentlyViewed(),
                child: Text(
                  'Clear',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6E7A6C),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return _RecentlyViewedCard(
                item: item,
                cartProvider: cartProvider,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentlyViewedCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final CartProvider? cartProvider;

  const _RecentlyViewedCard({
    required this.item,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    final qty = cartProvider?.getQuantity(item['id'] ?? '') ?? 0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(
          context,
          '/product-details',
          arguments: {
            'productId': item['id'],
            'productName': item['name'],
            'price': item['price'],
            'mrp': item['mrp'],
            'imageUrl': item['imageUrl'],
            'unitDetails': item['unit'] ?? '',
          },
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AppNetworkImage(
                imageUrl: item['imageUrl'] ?? '',
                width: 140,
                height: 110,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1C1E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['price'] ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF006B23),
                      ),
                    ),
                    const Spacer(),
                    // Add/Qty button
                    qty == 0
                        ? SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                cartProvider?.updateQuantityById(
                                  id: item['id'] ?? '',
                                  name: item['name'] ?? '',
                                  subtitle: item['unit'] ?? '',
                                  price: double.tryParse(
                                        (item['price'] ?? '0').replaceAll('₹', ''),
                                      ) ??
                                      0.0,
                                  image: item['imageUrl'] ?? '',
                                  delta: 1,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006B23),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Add',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF006B23),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () => cartProvider?.updateQuantityById(
                                    id: item['id'] ?? '',
                                    name: item['name'] ?? '',
                                    subtitle: item['unit'] ?? '',
                                    price: double.tryParse(
                                          (item['price'] ?? '0').replaceAll('₹', ''),
                                        ) ??
                                        0.0,
                                    image: item['imageUrl'] ?? '',
                                    delta: -1,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.remove, color: Colors.white, size: 14),
                                  ),
                                ),
                                Text(
                                  '$qty',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => cartProvider?.updateQuantityById(
                                    id: item['id'] ?? '',
                                    name: item['name'] ?? '',
                                    subtitle: item['unit'] ?? '',
                                    price: double.tryParse(
                                          (item['price'] ?? '0').replaceAll('₹', ''),
                                        ) ??
                                        0.0,
                                    image: item['imageUrl'] ?? '',
                                    delta: 1,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.add, color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
