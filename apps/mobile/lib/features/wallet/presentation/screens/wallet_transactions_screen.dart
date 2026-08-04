import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Wallet Transactions Screen — Exact Google Stitch Specification
/// Matches:
/// - Top App Bar: "Daily Basket Wallet"
/// - Balance Hero Card ("₹450.00") with "+ Add Money" button
/// - Transaction History list with Credit/Debit icons, status, and amounts
class WalletTransactionsScreen extends StatelessWidget {
  const WalletTransactionsScreen({super.key});

  final List<Map<String, dynamic>> _transactions = const [
    {
      'id': 't1',
      'title': 'Order #ORD-9824 Paid',
      'date': 'Today, 10:42 AM',
      'amount': '₹249',
      'type': 'debit',
      'status': 'Completed',
    },
    {
      'id': 't2',
      'title': 'Cashback Added',
      'date': 'Yesterday, 4:15 PM',
      'amount': '₹50',
      'type': 'credit',
      'status': 'Credited',
    },
    {
      'id': 't3',
      'title': 'Wallet Top-up via UPI',
      'date': '02 Aug 2026, 6:30 PM',
      'amount': '₹500',
      'type': 'credit',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Basket Wallet',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Hero Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
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
                            const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available Balance',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      '₹450.00',
                      style: GoogleFonts.outfit(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Use instantly at checkout for 1-click order placement',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: Text(
                          'Add Money',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Transaction History',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  final isCredit = tx['type'] == 'credit';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCredit
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCredit
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            color: isCredit
                                ? AppColors.primary
                                : const Color(0xFF334155),

                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx['title'],
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              Text(
                                tx['date'],
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${isCredit ? '+' : '-'}${tx['amount']}',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isCredit
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              ),
                            ),
                            Text(
                              tx['status'],
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
