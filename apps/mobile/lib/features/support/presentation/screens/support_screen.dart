import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider? userProvider;
    try {
      userProvider = context.watch<UserProvider>();
    } catch (_) {}
    final profileImageUrl = userProvider?.profileImageUrl ??
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      drawer: const AppNavigationDrawer(isDrawer: true),
      bottomNavigationBar: const AppBottomNav(currentIndex: -1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: Colors.white, size: 26),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  AppNavigationDrawer.show(context);
                },
              ),
        title: const Text(
          'Customer Support & Help',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            tooltip: 'Navigation Hub',
            onPressed: () {
              HapticFeedback.lightImpact();
              AppNavigationDrawer.show(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0, left: 4.0),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pushNamed('/profile');
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.6),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const CircleAvatar(
                      backgroundColor: Color(0xFF10B981),
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x33059669),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.headset_mic,
                      color: Color(0xFF10B981), size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24x7 Instant Support',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Average response time: <2 mins',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildFaqItem('How does 10-minute delivery work?',
              'We operate hyper-local dark stores within 2km of your location with dedicated rider dispatch.'),
          _buildFaqItem('What if an item is missing or damaged?',
              'Initiate a 1-tap instant refund from the Order History screen.'),
          _buildFaqItem('How do I apply coupon codes?',
              'Enter promotional code DAILY100 on the shopping cart screen prior to checkout.'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        iconColor: const Color(0xFF10B981),
        collapsedIconColor: Colors.white54,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
