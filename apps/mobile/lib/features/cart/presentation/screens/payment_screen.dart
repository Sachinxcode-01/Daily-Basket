import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../orders/presentation/screens/order_success_screen.dart';

/// Payment Method Screen — Google Stitch Design System Exact Replica
class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final int itemQuantity;

  const PaymentScreen({
    super.key,
    this.totalAmount = 32.50,
    this.itemQuantity = 4,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';

  final List<Map<String, dynamic>> _methods = [
    {
      'id': 'UPI',
      'title': 'UPI',
      'badge': 'FASTEST',
      'subtitle': 'Google Pay, PhonePe',
      'icon': Icons.bolt_rounded,
    },
    {
      'id': 'CARD',
      'title': 'Credit/Debit Cards',
      'badge': null,
      'subtitle': 'Visa, Mastercard, AMEX',
      'icon': Icons.credit_card_rounded,
    },
    {
      'id': 'NETBANKING',
      'title': 'Net Banking',
      'badge': null,
      'subtitle': 'All major banks supported',
      'icon': Icons.account_balance_rounded,
    },
    {
      'id': 'COD',
      'title': 'Cash on Delivery',
      'badge': null,
      'subtitle': 'Pay at your doorstep',
      'icon': Icons.payments_rounded,
    },
  ];

  void _processPayment() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Payment',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ─── Body Content ──────────────────────────────────────────────────
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Cart Items Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
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
                          color: const Color(0xFF006B23),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shopping_basket_outlined, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cart Items',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.itemQuantity} Fresh Groceries',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'SUBTOTAL',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: const Color(0xFF6E7A6C),
                            ),
                          ),
                          Text(
                            '\$${widget.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Section Header
                Text(
                  'Select Payment Method',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),

                const SizedBox(height: 12),

                // 3. Payment Option Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _methods.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final method = _methods[index];
                    final isSelected = _selectedMethod == method['id'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMethod = method['id']),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF3FBF4) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF006B23) : const Color(0xFFBECAB9).withValues(alpha: 0.3),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFF3F3F6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                method['icon'] as IconData,
                                color: const Color(0xFF006B23),
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
                                      Text(
                                        method['title'] as String,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                      if (method['badge'] != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF006B23),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            method['badge'] as String,
                                            style: GoogleFonts.inter(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
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
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                              color: isSelected ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // 4. Security Note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield_outlined, color: Color(0xFF6E7A6C), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '100% Secure SSL encrypted payments',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6E7A6C),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),

          // ─── 5. Fixed Bottom Action Bar (Pay Now) ─────────────────────────
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL PAYABLE',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: const Color(0xFF6E7A6C),
                          ),
                        ),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B23),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Pay Now',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
