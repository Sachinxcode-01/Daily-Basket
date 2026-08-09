import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Notifications Center - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 3f473a8ee82f41de86019498bed97103
class AdminNotificationsCenterScreen extends StatefulWidget {
  const AdminNotificationsCenterScreen({super.key});

  @override
  State<AdminNotificationsCenterScreen> createState() => _AdminNotificationsCenterScreenState();
}

class _AdminNotificationsCenterScreenState extends State<AdminNotificationsCenterScreen> {
  String _selectedFilter = 'All';

  // Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'n-1',
      'title': 'Low Stock Alert',
      'body': 'Premium Avocados inventory dropped below 15 units in WH-South.',
      'time': '10m ago',
      'type': 'Inventory',
      'isUnread': true,
      'icon': Icons.warning_amber_rounded,
      'iconBg': const Color(0xFFFEE2E2),
      'iconColor': const Color(0xFFDC2626),
    },
    {
      'id': 'n-2',
      'title': 'High Value Order Placed',
      'body': 'Order #4429 for ₹4,850 placed by VIP Customer Anita Sharma.',
      'time': '30m ago',
      'type': 'Orders',
      'isUnread': true,
      'icon': Icons.shopping_bag_outlined,
      'iconBg': const Color(0xFFDCFCE7),
      'iconColor': const Color(0xFF15803D),
    },
    {
      'id': 'n-3',
      'title': 'Security Alert: Failed Login',
      'body': 'Multiple failed login attempts detected from IP 192.168.1.42.',
      'time': '2h ago',
      'type': 'Security',
      'isUnread': false,
      'icon': Icons.security_outlined,
      'iconBg': const Color(0xFFFFEDD5),
      'iconColor': const Color(0xFFC2410C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications Center',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (var n in _notifications) {
                n['isUnread'] = false;
              }
            }),
            child: const Text('Mark Read', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Filter Chips Row
            SizedBox(
              height: 38,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: ['All', 'Unread', 'Orders', 'Inventory', 'Security'].map((f) {
                  final bool isSelected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? _primaryGreen : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isSelected ? _primaryGreen : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isSelected ? Colors.white : _textMuted,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Notifications List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  final bool isUnread = notif['isUnread'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUnread ? const Color(0xFFF0FDF4) : _cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isUnread ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: notif['iconBg'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(notif['icon'] as IconData, color: notif['iconColor'] as Color, size: 18),
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
                                    notif['title'] as String,
                                    style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13.5),
                                  ),
                                  Text(
                                    notif['time'] as String,
                                    style: const TextStyle(color: _textMuted, fontSize: 10.5),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif['body'] as String,
                                style: const TextStyle(color: _textMuted, fontSize: 12, height: 1.3),
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
      ),
    );
  }
}
