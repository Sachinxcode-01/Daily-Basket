import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_products_provider.dart';

/// Add New Product Screen — Daily Basket Admin
/// Allows admin to input basic info, pricing, inventory stock, barcode, and publish immediately.
class AdminAddProductBasicInfoScreen extends StatefulWidget {
  const AdminAddProductBasicInfoScreen({super.key});

  @override
  State<AdminAddProductBasicInfoScreen> createState() =>
      _AdminAddProductBasicInfoScreenState();
}

class _AdminAddProductBasicInfoScreenState
    extends State<AdminAddProductBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _stockController =
      TextEditingController(text: '50');
  final TextEditingController _unitController =
      TextEditingController(text: '1 kg');
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
  );

  String _selectedCategory = 'Produce';

  // Design tokens from design.md
  static const Color _primaryGreen = Color(0xFF2D9D43);
  static const Color _primaryDark = Color(0xFF006837);
  static const Color _textDark = Color(0xFF191C1E);
  static const Color _borderColor = Color(0xFFCBD5E1);

  final List<String> _categories = [
    'Produce',
    'Dairy & Eggs',
    'Bakery',
    'Snacks',
    'Beverages',
    'Pantry',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _generateAiDescription() {
    final name = _nameController.text.trim();
    final brand = _brandController.text.trim();
    final cat = _selectedCategory;

    setState(() {
      _descriptionController.text =
          'Farm-fresh premium quality $cat product ${name.isNotEmpty ? "($name)" : ""} by ${brand.isNotEmpty ? brand : "Daily Basket Select"}. Sourced sustainably under highest food hygiene standards for peak freshness.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Description generated!'),
        backgroundColor: _primaryDark,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveProduct({bool asDraft = false}) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Product Name')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text) ?? 50.0;
    final mrp = double.tryParse(_mrpController.text) ?? (price * 1.2);
    final stock = int.tryParse(_stockController.text) ?? 25;
    final skuSuffix =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    final sku = _barcodeController.text.trim().isNotEmpty
        ? 'SKU: ${_barcodeController.text.trim()}'
        : 'SKU: DB-${_selectedCategory.substring(0, 2).toUpperCase()}-$skuSuffix';

    final newProduct = AdminProduct(
      id: 'PRD-$skuSuffix',
      name: _nameController.text.trim(),
      brand: _brandController.text.trim().isNotEmpty
          ? _brandController.text.trim().toUpperCase()
          : 'DAILY BASKET SELECT',
      sku: sku,
      barcode: _barcodeController.text.trim(),
      category: _selectedCategory,
      price: price,
      originalPrice: mrp >= price ? mrp : price,
      stockAvailable: stock,
      unit: _unitController.text.trim().isNotEmpty
          ? _unitController.text.trim()
          : '1 unit',
      image: _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'Fresh quick-commerce grocery item.',
      status: asDraft ? 'Draft' : (stock > 0 ? 'Published' : 'Out of Stock'),
    );

    context.read<AdminProductsProvider>().addProduct(newProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(asDraft
            ? 'Saved "${newProduct.name}" as Draft'
            : 'Added "${newProduct.name}" to Store Catalog!'),
        backgroundColor: _primaryDark,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Product',
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveProduct(asDraft: true),
            child: const Text(
              'Save Draft',
              style: TextStyle(
                color: _primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Preview & URL input
                      _buildImagePreviewBox(),
                      const SizedBox(height: 18),

                      // Product Name
                      _buildFieldLabel('Product Name *'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: _buildInputDecoration(
                            'e.g., Organic Robusta Bananas 1kg'),
                      ),
                      const SizedBox(height: 16),

                      // Brand & Category
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Brand'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _brandController,
                                  style: const TextStyle(
                                      color: _textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  decoration: _buildInputDecoration(
                                      'e.g., Fresh Farms'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Category *'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  decoration: _buildInputDecoration('Category'),
                                  items: _categories
                                      .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c,
                                              style: const TextStyle(
                                                  fontSize: 13.5))))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedCategory = val);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pricing & MRP
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Selling Price (₹) *'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      color: _textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: _buildInputDecoration('e.g., 49'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('MRP (₹)'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _mrpController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      color: _textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  decoration: _buildInputDecoration('e.g., 65'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Stock Units & Packaging Unit
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Initial Stock Units *'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _stockController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      color: _textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration:
                                      _buildInputDecoration('e.g., 100'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Packaging Unit'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _unitController,
                                  style: const TextStyle(
                                      color: _textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  decoration: _buildInputDecoration(
                                      'e.g., 1 kg / 500 g'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Barcode / SKU
                      _buildFieldLabel('Barcode / SKU Identifier'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _barcodeController,
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: _buildInputDecoration(
                            'Scan barcode or type SKU (e.g. 8901234567890)'),
                      ),
                      const SizedBox(height: 16),

                      // AI Assistant Banner
                      _buildAiAssistantBanner(),
                      const SizedBox(height: 16),

                      // Description
                      _buildFieldLabel('Product Description'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: _buildInputDecoration(
                            'Enter product details, nutrition, or farm source...'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Bar (Cancel / Publish Product)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textDark,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _saveProduct(asDraft: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.check_circle_rounded, size: 20),
                        label: const Text('Publish Product',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviewBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _imageUrlController.text,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 54,
                    height: 54,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Product Photography\n(Unsplash / CDN image URL)',
                  style: TextStyle(
                      color: _textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _imageUrlController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 12, color: _textDark),
            decoration: _buildInputDecoration('Paste image URL...'),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _textDark,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
      ),
    );
  }

  Widget _buildAiAssistantBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Basket AI Copilot',
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Need an instant description formatted for grocery shoppers?',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 11.5),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _generateAiDescription,
                  child: const Text(
                    'Generate Description with AI',
                    style: TextStyle(
                      color: _primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
