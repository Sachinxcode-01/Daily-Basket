import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Fresh Produce', 'icon': Icons.eco, 'items': '45 Items'},
      {'name': 'Dairy, Bread & Eggs', 'icon': Icons.egg, 'items': '28 Items'},
      {'name': 'Cold Drinks & Juices', 'icon': Icons.local_drink, 'items': '32 Items'},
      {'name': 'Munchies & Snacks', 'icon': Icons.cookie, 'items': '50 Items'},
      {'name': 'Fresh Bakery & Cakes', 'icon': Icons.cake, 'items': '20 Items'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('All Categories'),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'] as IconData, size: 36, color: const Color(0xFF10B981)),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  cat['items'] as String,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
