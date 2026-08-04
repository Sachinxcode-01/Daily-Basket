import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Daily Basket Plus Screen — Exact Google Stitch Specification
/// Matches:
/// - Golden VIP Membership Hero Card ("Zero Delivery Fee on All Orders")
/// - Plus Perks breakdown (Free Delivery, VIP Priority Support, 5% Cashback)
/// - Subscription plan selector (Annual ₹499 vs Monthly ₹99)
/// - Primary CTA button: "Join Daily Basket Plus Now"
class DailyBasketPlusScreen extends StatefulWidget {
  const DailyBasketPlusScreen({super.key});

  @override
  State<DailyBasketPlusScreen> createState() => _DailyBasketPlusScreenState();
}

class _DailyBasketPlusScreenState extends State<DailyBasketPlusScreen> {
  String _selectedPlan = 'annual';

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
          'Daily Basket Plus',
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
              // Golden VIP Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF59E0B),
                      Color(0xFFD97706),
                      Color(0xFFB45309),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade700.withValues(alpha: 0.30),
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
                              Icons.workspace_premium_rounded,
                              color: Colors.amberAccent,
                              size: 26,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Daily Basket VIP',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
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
                            'PLUS MEMBERSHIP',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Zero Delivery Fee on All Orders',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Enjoy unlimited free 10-minute deliveries, VIP customer support, and exclusive 5% wallet cashback.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.90),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Plus Membership Perks',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              _buildPerkRow(
                icon: Icons.flash_on_rounded,
                title: 'Free 10-Min Delivery',
                desc: 'Zero delivery fee on all orders above ₹99',
              ),
              const SizedBox(height: 10),
              _buildPerkRow(
                icon: Icons.card_giftcard_rounded,
                title: '5% Extra Cashback',
                desc: 'Earn cashback on every order automatically',
              ),
              const SizedBox(height: 10),
              _buildPerkRow(
                icon: Icons.verified_user_outlined,
                title: 'VIP Priority Support',
                desc: 'Priority live chat resolution with zero wait time',
              ),

              const SizedBox(height: 24),

              Text(
                'Choose Your Plan',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              // Annual Plan Card
              InkWell(
                onTap: () => setState(() => _selectedPlan = 'annual'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedPlan == 'annual'
                        ? const Color(0xFFE8F5E9)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedPlan == 'annual'
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Annual Pass',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'SAVE 60%',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Billed ₹499 every 12 months (~₹41/mo)',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹499/yr',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Monthly Plan Card
              InkWell(
                onTap: () => setState(() => _selectedPlan = 'monthly'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedPlan == 'monthly'
                        ? const Color(0xFFE8F5E9)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedPlan == 'monthly'
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Pass',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            'Billed ₹99 every month',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹99/mo',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Welcome to Daily Basket Plus!',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.white),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                  label: Text(
                    'Join Daily Basket Plus Now',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerkRow({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8E1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.amber.shade800, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
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
