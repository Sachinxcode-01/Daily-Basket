import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Real-time Delivery Tracking Screen — Exact Google Stitch Specification
/// Matches:
/// - Header: "Live Order Tracking #ORD-9824"
/// - ETA Banner: "Arriving in 8 Mins" with express icon
/// - Rider Profile Card (Ramesh Kumar, rating, call button)
/// - Delivery Status Stepper (Placed, Packed, Out for Delivery, Delivered)
class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({super.key});

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
        title: Column(
          children: [
            Text(
              'Live Order Tracking',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              'Order #ORD-9824',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.marginMobile),
          child: Column(
            children: [
              // ─── ETA Banner Card ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'EXPRESS DELIVERY',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Arriving in 8 Mins',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your partner Ramesh is on the way!',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.90),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.near_me_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── Rider Profile Card ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          'RK',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
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
                                'Ramesh Kumar',
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
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '★ 4.9',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Vaccinated • 1,200+ Express Deliveries',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.phone_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── Status Stepper Card ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Progress',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildStepItem(
                      title: 'Order Placed',
                      time: '10:42 AM',
                      isCompleted: true,
                    ),
                    _buildStepItem(
                      title: 'Packed at Dark Store',
                      time: '10:44 AM',
                      isCompleted: true,
                    ),
                    _buildStepItem(
                      title: 'Out for Delivery',
                      time: '10:46 AM',
                      isCompleted: true,
                      isCurrent: true,
                    ),
                    _buildStepItem(
                      title: 'Delivered to Doorstep',
                      time: 'Est. 10:50 AM',
                      isCompleted: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required String title,
    required String time,
    required bool isCompleted,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.primary
                      : isCurrent
                          ? AppColors.primary
                          : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : isCurrent
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? AppColors.primary : Colors.grey.shade200,
              ),
          ],
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
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  color: isCurrent ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
