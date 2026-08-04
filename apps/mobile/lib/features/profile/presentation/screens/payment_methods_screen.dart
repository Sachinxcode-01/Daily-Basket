import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Saved Payment Methods Management Screen — Google Stitch Design System Exact Replica
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _primaryMethodId = 'upi_gpay';

  final List<Map<String, dynamic>> _savedMethods = [
    {
      'id': 'upi_gpay',
      'type': 'UPI',
      'title': 'Google Pay UPI',
      'subtitle': 'aarav.sharma@okaxis',
      'icon': Icons.bolt_rounded,
      'badge': 'PRIMARY',
      'color': Color(0xFF006B23),
    },
    {
      'id': 'upi_phonepe',
      'type': 'UPI',
      'title': 'PhonePe UPI',
      'subtitle': '9876543210@ybl',
      'icon': Icons.account_balance_wallet_rounded,
      'badge': null,
      'color': Color(0xFF5E35B1),
    },
    {
      'id': 'card_hdfc',
      'type': 'CARD',
      'title': 'HDFC Bank Credit Card',
      'subtitle': '•••• •••• •••• 4242 (Exp 08/28)',
      'icon': Icons.credit_card_rounded,
      'badge': null,
      'color': Color(0xFF1976D2),
    },
    {
      'id': 'net_icici',
      'type': 'NETBANKING',
      'title': 'ICICI Net Banking',
      'subtitle': 'Aarav Sharma - Linked Account',
      'icon': Icons.account_balance_rounded,
      'badge': null,
      'color': Color(0xFFE65100),
    },
    {
      'id': 'cod',
      'type': 'COD',
      'title': 'Cash on Delivery',
      'subtitle': 'Pay cash or UPI at delivery doorstep',
      'icon': Icons.payments_rounded,
      'badge': null,
      'color': Color(0xFF2E7D32),
    },
  ];

  void _showAddUpiDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add New UPI ID',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g. username@upi or mobile@paytm',
            hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF3F3F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _savedMethods.insert(0, {
                    'id': 'upi_${DateTime.now().millisecondsSinceEpoch}',
                    'type': 'UPI',
                    'title': 'UPI ($text)',
                    'subtitle': text,
                    'icon': Icons.bolt_rounded,
                    'badge': null,
                    'color': const Color(0xFF006B23),
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('UPI ID $text saved successfully!'),
                    backgroundColor: const Color(0xFF006B23),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006B23),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Save UPI', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _deleteMethod(int index) {
    final item = _savedMethods[index];
    setState(() {
      _savedMethods.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['title']} removed.'),
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
          'Payment Methods',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Text(
              'SAVED PAYMENT OPTIONS',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: const Color(0xFF006B23),
              ),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedMethods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = _savedMethods[index];
                final isPrimary = _primaryMethodId == method['id'];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isPrimary
                          ? const Color(0xFF006B23)
                          : const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      width: isPrimary ? 1.8 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (method['color'] as Color).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          method['icon'] as IconData,
                          color: method['color'] as Color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    method['title'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                ),
                                if (isPrimary) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF006B23),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'DEFAULT',
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              method['subtitle'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (val) {
                          if (val == 'primary') {
                            setState(() => _primaryMethodId = method['id']);
                          } else if (val == 'delete') {
                            _deleteMethod(index);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'primary',
                            child: Text('Set as Default'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Remove Method',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Action Button: Add Payment Method
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _showAddUpiDialog,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF006B23), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, color: Color(0xFF006B23)),
                label: Text(
                  'Add New UPI / Payment Method',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF006B23),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
