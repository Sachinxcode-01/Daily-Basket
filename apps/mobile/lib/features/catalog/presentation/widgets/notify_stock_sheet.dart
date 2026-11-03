import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/stock_alerts_service.dart';

/// Notify When In Stock Bottom Sheet Modal
/// Conforms to design.md tokens:
/// - 24px top border radius
/// - Outfit headline typography + Inter body copy
/// - Primary brand color #2d9d43
/// - Full Dark Mode & Light Mode support
/// - Direct integration with StockAlertsService & POST /stock-alerts/subscribe
class NotifyStockSheet extends StatefulWidget {
  final String productId;
  final String productName;
  final String? brand;
  final String? imageUrl;
  final String? unit;
  final String? estimatedRestockTime;
  final StockAlertsService? alertsService;

  const NotifyStockSheet({
    super.key,
    required this.productId,
    required this.productName,
    this.brand,
    this.imageUrl,
    this.unit,
    this.estimatedRestockTime,
    this.alertsService,
  });

  /// Static helper to display the modal bottom sheet
  static Future<bool?> show(
    BuildContext context, {
    required String productId,
    required String productName,
    String? brand,
    String? imageUrl,
    String? unit,
    String? estimatedRestockTime,
    StockAlertsService? alertsService,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => NotifyStockSheet(
        productId: productId,
        productName: productName,
        brand: brand,
        imageUrl: imageUrl,
        unit: unit,
        estimatedRestockTime: estimatedRestockTime,
        alertsService: alertsService,
      ),
    );
  }

  @override
  State<NotifyStockSheet> createState() => _NotifyStockSheetState();
}

class _NotifyStockSheetState extends State<NotifyStockSheet> {
  late final StockAlertsService _service;
  bool _notifyPush = true;
  bool _notifyWhatsapp = false;
  bool _notifyEmail = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = widget.alertsService ?? StockAlertsService();
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _handleSubscribe() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final res = await _service.subscribe(
      productId: widget.productId,
      productName: widget.productName,
      email: _notifyEmail ? _contactController.text.trim() : null,
      phone: _notifyWhatsapp ? _contactController.text.trim() : null,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSubmitting = false;
        _errorMessage = res['error']?.toString() ??
            'Failed to register alert. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E2124) : Colors.white;
    final cardColor =
        isDark ? const Color(0xFF282B30) : const Color(0xFFF9F9FC);
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE2E2E5);
    final textPrimary = isDark ? Colors.white : const Color(0xFF191C1E);
    final textSecondary =
        isDark ? const Color(0xFFB0B3B8) : const Color(0xFF3F4A3D);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag pill
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : const Color(0xFFD0D3D6),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notify When in Stock',
                          style: GoogleFonts.outfit(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Instant alert as soon as stock returns',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: Icon(Icons.close_rounded, color: textSecondary),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Product Info Preview Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 56,
                            height: 56,
                            color: isDark ? Colors.white10 : Colors.black12,
                            child: const Icon(Icons.inventory_2_outlined,
                                size: 28),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, size: 28),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.brand != null && widget.brand!.isNotEmpty)
                            Text(
                              widget.brand!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          Text(
                            widget.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDAD6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Sold Out',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFBA1A1A),
                                  ),
                                ),
                              ),
                              if (widget.unit != null &&
                                  widget.unit!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  widget.unit!,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Restock Estimate Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.estimatedRestockTime ??
                            'Expected restock in 2–4 hours today',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.primaryFixedDim
                              : const Color(0xFF0F5B24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Channel Notification Options
              Text(
                'How should we alert you?',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Option 1: App Push Notification
              _buildChannelTile(
                icon: Icons.notifications_active_outlined,
                title: 'In-App & Push Notification',
                subtitle: 'Direct notification when fresh stock lands in store',
                value: _notifyPush,
                onChanged: (val) => setState(() => _notifyPush = val ?? true),
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              // Option 2: WhatsApp / SMS
              _buildChannelTile(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'WhatsApp or SMS Alert',
                subtitle: 'Quick message to your registered phone number',
                value: _notifyWhatsapp,
                onChanged: (val) =>
                    setState(() => _notifyWhatsapp = val ?? false),
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              // Option 3: Email Notification
              _buildChannelTile(
                icon: Icons.mail_outline_rounded,
                title: 'Email Alert',
                subtitle: 'Receive a restock notification in your inbox',
                value: _notifyEmail,
                onChanged: (val) => setState(() => _notifyEmail = val ?? false),
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              if (_notifyWhatsapp || _notifyEmail) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: _notifyEmail
                        ? 'Email address or Mobile number'
                        : 'Mobile number',
                    hintText: _notifyEmail
                        ? 'you@example.com / +91 98765 43210'
                        : '+91 98765 43210',
                    prefixIcon: Icon(
                      _notifyEmail
                          ? Icons.alternate_email_rounded
                          : Icons.phone_android_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: cardColor,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ],

              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFBA1A1A),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubscribe,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.notifications_active_rounded,
                          size: 20),
                  label: Text(
                    _isSubmitting
                        ? 'Registering Alert...'
                        : 'Notify Me When In Stock',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  Widget _buildChannelTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Icon(icon,
                  size: 20, color: value ? AppColors.primary : textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: value,
                activeColor: AppColors.primary,
                onChanged: onChanged,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
