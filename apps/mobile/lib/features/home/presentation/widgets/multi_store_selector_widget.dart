import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiStoreSelectorWidget extends StatefulWidget {
  const MultiStoreSelectorWidget({super.key});

  @override
  State<MultiStoreSelectorWidget> createState() => _MultiStoreSelectorWidgetState();
}

class _MultiStoreSelectorWidgetState extends State<MultiStoreSelectorWidget> {
  String _selectedStore = 'Indiranagar Main Kirana (0.8 km)';

  final List<Map<String, String>> _stores = [
    {'id': 'store_01', 'name': 'Indiranagar Main Kirana (0.8 km)', 'type': 'OWNED'},
    {'id': 'store_02', 'name': 'Koramangala Express (2.4 km)', 'type': 'FRANCHISE'},
    {'id': 'store_03', 'name': 'HSR Layout Superstore (4.1 km)', 'type': 'OWNED'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.storefront, size: 14, color: Color(0xFF059669)),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStore,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF0F172A)),
              items: _stores.map((store) {
                return DropdownMenuItem<String>(
                  value: store['name']!,
                  child: Text(
                    store['name']!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedStore = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Switched store location to $val')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
