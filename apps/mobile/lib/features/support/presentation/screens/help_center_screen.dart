import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Help Center Screen — Exact Google Stitch Specification
/// Matches:
/// - Top App Bar: "Help Center & Support"
/// - Search Header Hero with query input
/// - Quick Topic Cards (Orders, Refunds, Payments, Account)
/// - Expandable FAQ Accordions
/// - Live Chat & Support CTA card
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int? _openFaqIndex = 0;

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How fast is Daily Basket delivery?',
      'answer':
          'Daily Basket delivers fresh groceries within 10 to 15 minutes in selected service areas through our hyper-local micro-fulfillment dark stores.',
    },
    {
      'question': 'What is the return & refund policy for fresh produce?',
      'answer':
          'We offer a 100% no-questions-asked instant refund or replacement at your doorstep if you are unsatisfied with the freshness or quality of any delivered item.',
    },
    {
      'question': 'What payment methods are supported?',
      'answer':
          'We accept UPI (Google Pay, PhonePe, Paytm), Credit/Debit cards, Net Banking, and Cash/UPI on delivery.',
    },
    {
      'question': 'How do I cancel or modify my active order?',
      'answer':
          'Because orders are packed within 2 minutes of placement, you can cancel directly from the order tracking screen within 60 seconds of placing it.',
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
          'Help Center & Support',
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
              // ─── Search Hero Header Card ─────────────────────────────────
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
                child: Column(
                  children: [
                    Text(
                      'How can we help you today?',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Search our knowledge base or pick a topic below',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search help articles, refunds...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Popular Topics ───────────────────────────────────────────
              Text(
                'Popular Topics',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildTopicCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Orders & Delivery',
                    color: const Color(0xFFE8F5E9),
                    iconColor: AppColors.primary,
                  ),
                  _buildTopicCard(
                    icon: Icons.autorenew_rounded,
                    title: 'Refunds & Returns',
                    color: const Color(0xFFE3F2FD),
                    iconColor: Colors.blue,
                  ),
                  _buildTopicCard(
                    icon: Icons.credit_card_rounded,
                    title: 'Payments & Offers',
                    color: const Color(0xFFFFF8E1),
                    iconColor: Colors.amber.shade800,
                  ),
                  _buildTopicCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Account Settings',
                    color: const Color(0xFFF3E5F5),
                    iconColor: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─── FAQ Accordions ───────────────────────────────────────────
              Text(
                'Frequently Asked Questions',
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
                itemCount: _faqs.length,
                itemBuilder: (context, index) {
                  final isOpen = _openFaqIndex == index;
                  final faq = _faqs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.20),
                      ),
                    ),
                    child: ExpansionTile(
                      key: Key('faq_$index'),
                      initiallyExpanded: isOpen,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _openFaqIndex = expanded ? index : null;
                        });
                      },
                      shape: const Border(),
                      title: Text(
                        faq['question']!,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            faq['answer']!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 19 / 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ─── Live Support Card ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Still need assistance?',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Our 24/7 customer support team is available live to assist you.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_bubble_outline_rounded,
                                  size: 18),
                              label: const Text('Live Chat'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.phone_outlined, size: 18),
                              label: const Text('Call Us'),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF334155),
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTopicCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
