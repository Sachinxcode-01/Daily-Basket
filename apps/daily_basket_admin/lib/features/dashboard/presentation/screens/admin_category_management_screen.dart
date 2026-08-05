import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminCategoryManagementScreen extends StatefulWidget {
  const AdminCategoryManagementScreen({super.key});

  @override
  State<AdminCategoryManagementScreen> createState() => _AdminCategoryManagementScreenState();
}

class _AdminCategoryManagementScreenState extends State<AdminCategoryManagementScreen> {
  final List<Map<String, dynamic>> _adminCategories = [
    {
      'id': 'cat-1',
      'name': 'Fresh Fruits & Vegetables',
      'slug': 'fresh-fruits-vegetables',
      'subCount': 6,
      'order': 1,
      'isFeatured': true,
      'isActive': true,
      'icon': Icons.eco_rounded,
    },
    {
      'id': 'cat-2',
      'name': 'Dairy, Bread & Eggs',
      'slug': 'dairy-bread-eggs',
      'subCount': 7,
      'order': 2,
      'isFeatured': true,
      'isActive': true,
      'icon': Icons.egg_alt_rounded,
    },
    {
      'id': 'cat-3',
      'name': 'Snacks & Packaged Foods',
      'slug': 'snacks-packaged-foods',
      'subCount': 7,
      'order': 3,
      'isFeatured': true,
      'isActive': true,
      'icon': Icons.fastfood_rounded,
    },
    {
      'id': 'cat-4',
      'name': 'Grocery',
      'slug': 'grocery',
      'subCount': 7,
      'order': 4,
      'isFeatured': true,
      'isActive': true,
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'id': 'cat-5',
      'name': 'Cooking Essentials',
      'slug': 'cooking-essentials',
      'subCount': 9,
      'order': 5,
      'isFeatured': true,
      'isActive': true,
      'icon': Icons.opacity_rounded,
    },
    {
      'id': 'cat-6',
      'name': 'Pooja Needs',
      'slug': 'pooja-needs',
      'subCount': 10,
      'order': 6,
      'isFeatured': false,
      'isActive': true,
      'icon': Icons.temple_hindu_rounded,
    },
    {
      'id': 'cat-7',
      'name': 'Cleaning Essentials',
      'slug': 'cleaning-essentials',
      'subCount': 9,
      'order': 7,
      'isFeatured': false,
      'isActive': true,
      'icon': Icons.cleaning_services_rounded,
    },
    {
      'id': 'cat-8',
      'name': 'Household & Lifestyle',
      'slug': 'household-lifestyle',
      'subCount': 9,
      'order': 8,
      'isFeatured': false,
      'isActive': true,
      'icon': Icons.home_work_rounded,
    },
  ];

  void _showAddCategoryModal([Map<String, dynamic>? category]) {
    final nameCtrl = TextEditingController(text: category?['name'] ?? '');
    final slugCtrl = TextEditingController(text: category?['slug'] ?? '');
    bool isFeatured = category?['isFeatured'] ?? false;
    bool isActive = category?['isActive'] ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category == null ? 'Add Category' : 'Edit Category',
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: slugCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Slug (URL path)',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Featured Category', style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isFeatured,
                        activeColor: const Color(0xFF2DD4BF),
                        onChanged: (val) => setModalState(() => isFeatured = val),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Active Status', style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isActive,
                        activeColor: const Color(0xFF2DD4BF),
                        onChanged: (val) => setModalState(() => isActive = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (category == null) {
                            _adminCategories.add({
                              'id': 'cat-${_adminCategories.length + 1}',
                              'name': nameCtrl.text.isEmpty ? 'New Category' : nameCtrl.text,
                              'slug': slugCtrl.text.isEmpty ? 'new-category' : slugCtrl.text,
                              'subCount': 0,
                              'order': _adminCategories.length + 1,
                              'isFeatured': isFeatured,
                              'isActive': isActive,
                              'icon': Icons.category_rounded,
                            });
                          } else {
                            category['name'] = nameCtrl.text;
                            category['slug'] = slugCtrl.text;
                            category['isFeatured'] = isFeatured;
                            category['isActive'] = isActive;
                          }
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(category == null ? 'Category created' : 'Category updated'),
                            backgroundColor: const Color(0xFF0F766E),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        category == null ? 'Save Category' : 'Update Category',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Category Taxonomy Manager', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF2DD4BF)),
            onPressed: () => _showAddCategoryModal(),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _adminCategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final cat = _adminCategories[index];

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(cat['icon'] as IconData, color: const Color(0xFF2DD4BF), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            cat['name'] as String,
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          if (cat['isFeatured'] as bool)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEC4899),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/${cat['slug']} • ${cat['subCount']} subcategories',
                        style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Color(0xFF60A5FA), size: 20),
                  onPressed: () => _showAddCategoryModal(cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFF87171), size: 20),
                  onPressed: () {
                    setState(() => _adminCategories.removeAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category deleted')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryModal(),
        backgroundColor: const Color(0xFF0F766E),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
