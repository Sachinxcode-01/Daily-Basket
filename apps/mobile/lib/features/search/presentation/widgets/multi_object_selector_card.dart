import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiObjectSelectorCard extends StatefulWidget {
  final List<dynamic> detectedItems;
  final Function(List<dynamic>) onAddSelectedToCart;

  const MultiObjectSelectorCard({
    super.key,
    required this.detectedItems,
    required this.onAddSelectedToCart,
  });

  @override
  State<MultiObjectSelectorCard> createState() => _MultiObjectSelectorCardState();
}

class _MultiObjectSelectorCardState extends State<MultiObjectSelectorCard> {
  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    // Select all items by default
    for (int i = 0; i < widget.detectedItems.length; i++) {
      _selectedIndices.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.detectedItems.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.grid_view_rounded, color: Color(0xFF2563EB), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Multi-Product Photo Detected (${widget.detectedItems.length} items)',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items list with checkboxes
          ...List.generate(widget.detectedItems.length, (index) {
            final item = widget.detectedItems[index];
            final isSelected = _selectedIndices.contains(index);

            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedIndices.remove(index);
                  } else {
                    _selectedIndices.add(index);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      activeColor: const Color(0xFF059669),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedIndices.add(index);
                          } else {
                            _selectedIndices.remove(index);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['detectedName'] ?? 'Grocery Product',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            '${item['brand'] ?? 'Daily Basket'} • ${item['category'] ?? 'Item'}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${item['estimatedPrice'] ?? 60}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),

          // Action Button: Add Selected to Cart
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _selectedIndices.isNotEmpty
                  ? () {
                      final selected = _selectedIndices.map((i) => widget.detectedItems[i]).toList();
                      widget.onAddSelectedToCart(selected);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.shopping_basket_outlined, size: 18),
              label: Text(
                'Add ${_selectedIndices.length} Selected to Basket',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
