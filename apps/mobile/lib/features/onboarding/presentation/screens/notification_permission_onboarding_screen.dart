import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/permissions/app_permission_service.dart';
import '../../../../core/providers/permissions_provider.dart';

class NotificationPermissionOnboardingScreen extends StatelessWidget {
  const NotificationPermissionOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionsProvider = context.watch<PermissionsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Hero Illustration & Badge
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2DD4BF), width: 2),
                ),
                child: const Center(
                  child: Text('🔔', style: TextStyle(fontSize: 52)),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Stay Updated',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Get real-time delivery alerts, exclusive coupons & order updates.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 36),

              // Benefits List
              Expanded(
                child: Column(
                  children: [
                    _benefitRow('Live order status & rider tracking', Icons.delivery_dining_rounded),
                    _benefitRow('Flash sales & price drop alerts', Icons.local_offer_outlined),
                    _benefitRow('Exclusive coupon codes & discounts', Icons.card_giftcard_rounded),
                    _benefitRow('Cashback & wallet balance updates', Icons.account_balance_wallet_outlined),
                    _benefitRow('Restock alerts for favorite items', Icons.notifications_active_outlined),
                  ],
                ),
              ),

              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        permissionsProvider.updatePermissionStatus(
                          PermissionType.notifications,
                          AppPermissionStatus.granted,
                        );
                        Navigator.pushReplacementNamed(context, '/customer/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Allow Notifications',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushReplacementNamed(context, '/customer/home');
                    },
                    child: Text(
                      'Maybe Later',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2DD4BF), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
