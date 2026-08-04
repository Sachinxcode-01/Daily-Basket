import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Saved Addresses Screen — Google Stitch Design System Exact Replica
class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': 'a1',
      'label': 'Home',
      'icon': Icons.home_outlined,
      'isDefault': true,
      'addressText': 'Flat 402, Green Glen Layout, Bellandur\nBengaluru, Karnataka 560103',
      'phone': '+91 98765 43210',
      'instruction': null,
    },
    {
      'id': 'a2',
      'label': 'Work',
      'icon': Icons.work_outline_rounded,
      'isDefault': false,
      'addressText': 'Building 12, Manyata Tech Park, Nagavara\nBengaluru, Karnataka 560045',
      'phone': '+91 98765 43210',
      'instruction': 'Leave at reception desk',
    },
    {
      'id': 'a3',
      'label': 'Parents',
      'icon': Icons.favorite_border_rounded,
      'isDefault': false,
      'addressText': '45 Lake View Road, Indiranagar Stage 2\nBengaluru, Karnataka 560038',
      'phone': '+91 98765 11223',
      'instruction': null,
    },
  ];

  void _deleteAddress(int index) {
    final deleted = _addresses[index]['label'];
    setState(() {
      _addresses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deleted address deleted'),
        backgroundColor: const Color(0xFFBA1A1A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Saved Addresses',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Screen Title Header
                Text(
                  'Your Delivery Locations',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 16),

                // Address Cards List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _addresses[index];
                    final isDefault = item['isDefault'] as bool;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isDefault
                            ? const Border(
                                left: BorderSide(color: Color(0xFF006B23), width: 4),
                                top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                              )
                            : Border.all(
                                color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon Avatar
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDefault ? const Color(0xFFE8F5E9) : const Color(0xFFF3F3F6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: isDefault ? const Color(0xFF006B23) : const Color(0xFF1A1C1E),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Address Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item['label'] as String,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1C1E),
                                      ),
                                    ),
                                    if (isDefault) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF006B23),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'DEFAULT',
                                          style: GoogleFonts.inter(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['addressText'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    height: 18 / 13,
                                    color: const Color(0xFF6E7A6C),
                                  ),
                                ),
                                if (item['phone'] != null) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF6E7A6C)),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['phone'] as String,
                                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6E7A6C)),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          PopupMenuButton<String>(
                            onSelected: (val) {
                              if (val == 'default') {
                                setState(() {
                                  for (var a in _addresses) {
                                    a['isDefault'] = false;
                                  }
                                  item['isDefault'] = true;
                                });
                              } else if (val == 'delete') {
                                _deleteAddress(index);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'default',
                                child: Text('Set as Default'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Address', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),

          // Bottom Action Bar: Add New Address
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('/add-address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white, size: 20),
                    label: Text(
                      'Add New Address',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
