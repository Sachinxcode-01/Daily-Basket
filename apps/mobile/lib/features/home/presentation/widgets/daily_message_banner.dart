import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/daily_messages_service.dart';
import '../../../../core/theme/app_theme.dart';

/// Live Daily Grocery Marketing & Announcement Banner
/// Rendered on HomeScreen directly consuming GET /api/v1/messages/daily.
/// Follows design.md tokens: 16px rounded corners, Outfit & Inter typography,
/// emerald accent #2D9D43, live pulse indicator, and full dark theme compatibility.
class DailyMessageBanner extends StatefulWidget {
  final DailyMessagesService? messagesService;
  final VoidCallback? onTap;

  const DailyMessageBanner({
    super.key,
    this.messagesService,
    this.onTap,
  });

  @override
  State<DailyMessageBanner> createState() => _DailyMessageBannerState();
}

class _DailyMessageBannerState extends State<DailyMessageBanner>
    with SingleTickerProviderStateMixin {
  late final DailyMessagesService _service;
  Map<String, dynamic>? _messageData;
  bool _isLoading = true;
  bool _isDismissed = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _service = widget.messagesService ?? DailyMessagesService();
    final isTest = !kIsWeb &&
        (Platform.environment.containsKey('FLUTTER_TEST') ||
            WidgetsBinding.instance.runtimeType
                .toString()
                .toLowerCase()
                .contains('test'));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (!isTest) {
      _pulseController.repeat(reverse: true);
    }

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadDailyMessage();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadDailyMessage() async {
    final res = await _service.fetchTodaysMessage();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (res['success'] == true && res['data'] != null) {
        _messageData = Map<String, dynamic>.from(res['data'] as Map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed || _isLoading || _messageData == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title =
        _messageData!['title']?.toString() ?? 'Today\'s Daily Harvest 🌿';
    final body = _messageData!['body']?.toString() ??
        'Crisp organic greens and fresh essentials delivered in 10 minutes.';

    final cardBg = isDark ? const Color(0xFF1E2124) : const Color(0xFFF3FDF5);
    final borderColor = isDark
        ? AppColors.primary.withValues(alpha: 0.3)
        : const Color(0xFFB7E4C7);
    final textPrimary = isDark ? Colors.white : const Color(0xFF191C1E);
    final textSecondary =
        isDark ? const Color(0xFFD0D3D6) : const Color(0xFF3F4A3D);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap ?? () => Navigator.pushNamed(context, '/coupons'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live Pulse Icon Badge
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF134E26)
                                  : const Color(0xFFDCE5DD),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'LIVE ANNOUNCEMENT',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: isDark
                                    ? AppColors.primaryFixedDim
                                    : const Color(0xFF078730),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dismiss Button
                IconButton(
                  onPressed: () => setState(() => _isDismissed = true),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: textSecondary,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Dismiss',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
