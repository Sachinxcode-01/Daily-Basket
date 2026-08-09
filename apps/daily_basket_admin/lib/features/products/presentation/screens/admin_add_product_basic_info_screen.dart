import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Add New Product - Basic Info
/// Project ID: 6885817708675501691
/// Screen ID: 161ecffe647347dcb3399a8bf75f8be0
class AdminAddProductBasicInfoScreen extends StatefulWidget {
  const AdminAddProductBasicInfoScreen({super.key});

  @override
  State<AdminAddProductBasicInfoScreen> createState() => _AdminAddProductBasicInfoScreenState();
}

class _AdminAddProductBasicInfoScreenState extends State<AdminAddProductBasicInfoScreen> {
  int _currentStep = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  String? _selectedCategory;

  // Stitch Design Palette
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _borderLight = Color(0xFFCBD5E1);
  static const Color _periwinkleBg = Color(0xFFDCE6FE);

  final List<String> _categories = [
    'Produce',
    'Dairy & Eggs',
    'Bakery',
    'Snacks',
    'Beverages',
    'Frozen',
    'Pantry',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _generateAiDescription() {
    setState(() {
      _descriptionController.text =
          'Farm-fresh organic produce, carefully selected and packed for peak ripeness and optimal nutritional value.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Description generated!'),
        backgroundColor: _primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // 5-Step Stepper Header
            _buildStepperHeader(),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primary Image Upload Dropzone
                    _buildImageUploadBox(),
                    const SizedBox(height: 20),

                    // Product Name Field
                    _buildFieldLabel('Product Name'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: _buildInputDecoration('e.g., Organic Avocados'),
                    ),
                    const SizedBox(height: 18),

                    // Brand & Category 2-Column Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Brand'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _brandController,
                                style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: _buildInputDecoration('Brand Name'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Category Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Category'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _textDark),
                                style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: _buildInputDecoration('Select...'),
                                items: _categories
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (val) => setState(() => _selectedCategory = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // AI Assistant Suggestion Banner
                    _buildAiAssistantBanner(),
                    const SizedBox(height: 18),

                    // Description Field
                    _buildFieldLabel('Description'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: _buildInputDecoration('Enter product description...'),
                    ),
                    const SizedBox(height: 18),

                    // Barcode / SKU Field
                    _buildFieldLabel('Barcode / SKU'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _barcodeController,
                      style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: _buildInputDecoration('Scan or type barcode SKU...'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'Add New Product',
        style: TextStyle(
          color: _textDark,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Draft saved successfully!')),
            );
          },
          child: const Text(
            'Save Draft',
            style: TextStyle(
              color: _primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStepperHeader() {
    final steps = [
      {'num': '1', 'label': 'Basic Info'},
      {'num': '2', 'label': 'Pricing'},
      {'num': '3', 'label': 'Inventory'},
      {'num': '4', 'label': 'Images'},
      {'num': '5', 'label': 'Review'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: steps.map((step) {
          final int stepNum = int.parse(step['num']!);
          final bool isActive = stepNum == _currentStep;
          final bool isCompleted = stepNum < _currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? _primaryGreen
                      : isCompleted
                          ? _primaryGreen.withOpacity(0.2)
                          : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    step['num']!,
                    style: TextStyle(
                      color: isActive ? Colors.white : (isCompleted ? _primaryGreen : const Color(0xFF64748B)),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step['label']!,
                style: TextStyle(
                  color: isActive ? _primaryGreen : const Color(0xFF64748B),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageUploadBox() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF2563EB), size: 28),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap to upload primary image',
                style: TextStyle(
                  color: _textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _textDark,
        fontWeight: FontWeight.bold,
        fontSize: 13.5,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
      ),
    );
  }

  Widget _buildAiAssistantBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF475569),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Color(0xFF334155), fontSize: 12, height: 1.3),
                    children: [
                      TextSpan(text: 'Based on your recent uploads, suggesting category: '),
                      TextSpan(
                        text: 'Produce',
                        style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '. Want me to generate a description?'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _generateAiDescription,
                  child: const Text(
                    'Generate Description',
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

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  side: const BorderSide(color: _textDark, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < 5) {
                    setState(() => _currentStep++);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Proceeding to Step $_currentStep')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next Step',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.shopping_bag_outlined, 'Orders'),
              _buildNavItem(2, Icons.local_offer_rounded, 'Products', isSelected: true),
              _buildNavItem(3, Icons.inventory_2_outlined, 'Inventory'),
              _buildNavItem(4, Icons.bar_chart_rounded, 'Analytics'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isSelected = false}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _periwinkleBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? _primaryGreen : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _textDark : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
