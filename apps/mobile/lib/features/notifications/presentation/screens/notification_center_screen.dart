import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Notification Center Screen — Exact Google Stitch Specification
/// Matches:
/// - Top App Bar with "Mark All Read" action
/// - Filter Tab Chips (All, Orders, Offers, System)
/// - List of notification items with unread indicators, icons, and timestamps
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'n1',
      'title': 'Order Delivered! 🚚',
      'message':
          'Your order #ORD-9824 has been delivered fresh to your doorstep.',
      'time': '2 mins ago',
      'category': 'Orders',
      'unread': true,
    },
    {
      'id': 'n2',
      'title': '50% OFF Flash Sale Live! ⚡',
      'message':
          'Get 50% OFF on all organic fruits & fresh veggies for the next 2 hours.',
      'time': '1 hour ago',
      'category': 'Offers',
      'unread': true,
    },
    {
      'id': 'n3',
      'title': 'Wallet Cashback Credited 💰',
      'message': '₹50 cashback has been added to your Daily Basket wallet.',
      'time': 'Yesterday',
      'category': 'System',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'All'
        ? _notifications
        : _notifications
            .where((n) => n['category'] == _selectedFilter)
            .toList();

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
          'Notification Center',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            tooltip: 'Notification Preferences',
            onPressed: () => Navigator.of(context).pushNamed('/notification-preferences'),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['unread'] = false;
                }
              });
            },
            icon: const Icon(Icons.done_all_rounded,
                size: 16, color: AppColors.primary),
            label: Text(
              'Read all',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: ['All', 'Orders', 'Offers', 'System'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.onSurfaceVariant,
                    ),
                    backgroundColor: const Color(0xFFF3F3F6),
                    selectedColor: AppColors.primary,
                    shape: const StadiumBorder(),
                    side: BorderSide.none,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final isUnread = item['unread'] as bool;
                final category = item['category'] as String;

                IconData icon;
                Color iconColor;
                Color bgColor;

                if (category == 'Orders') {
                  icon = Icons.shopping_bag_outlined;
                  iconColor = AppColors.primary;
                  bgColor = const Color(0xFFE8F5E9);
                } else if (category == 'Offers') {
                  icon = Icons.local_offer_outlined;
                  iconColor = Colors.amber.shade800;
                  bgColor = const Color(0xFFFFF8E1);
                } else {
                  icon = Icons.notifications_none_rounded;
                  iconColor = Colors.blue;
                  bgColor = const Color(0xFFE3F2FD);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUnread ? Colors.white : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isUnread
                          ? AppColors.primary.withValues(alpha: 0.30)
                          : AppColors.outlineVariant.withValues(alpha: 0.15),
                    ),
                    boxShadow: isUnread
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  item['time'],
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['message'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 16 / 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
