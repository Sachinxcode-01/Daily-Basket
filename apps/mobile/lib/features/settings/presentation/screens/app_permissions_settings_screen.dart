import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/permissions/app_permission_service.dart';
import '../../../../core/providers/permissions_provider.dart';

class AppPermissionsSettingsScreen extends StatelessWidget {
  const AppPermissionsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionsProvider = context.watch<PermissionsProvider>();

    final items = [
      _PermissionTileData(
        type: PermissionType.location,
        title: 'Location Services',
        subtitle: 'Required for local store catalog, delivery ETA, & address detection',
        icon: Icons.location_on_rounded,
        iconColor: const Color(0xFF38BDF8),
      ),
      _PermissionTileData(
        type: PermissionType.notifications,
        title: 'Push Notifications',
        subtitle: 'Live order tracking, price drops, cashback & coupon alerts',
        icon: Icons.notifications_active_rounded,
        iconColor: const Color(0xFFF43F5E),
      ),
      _PermissionTileData(
        type: PermissionType.camera,
        title: 'Camera Access',
        subtitle: 'Used for AI camera search, barcode scan, & support photos',
        icon: Icons.camera_alt_rounded,
        iconColor: const Color(0xFF10B981),
      ),
      _PermissionTileData(
        type: PermissionType.microphone,
        title: 'Microphone Access',
        subtitle: 'Used for voice search & AI voice assistant',
        icon: Icons.mic_rounded,
        iconColor: const Color(0xFFA855F7),
      ),
      _PermissionTileData(
        type: PermissionType.gallery,
        title: 'Photo Gallery / Media',
        subtitle: 'Used for uploading profile picture & attachment photos',
        icon: Icons.photo_library_rounded,
        iconColor: const Color(0xFFF59E0B),
      ),
      _PermissionTileData(
        type: PermissionType.biometric,
        title: 'Fingerprint / Face ID',
        subtitle: 'Faster login & secure account authentication',
        icon: Icons.fingerprint_rounded,
        iconColor: const Color(0xFF6366F1),
      ),
      _PermissionTileData(
        type: PermissionType.contacts,
        title: 'Contacts Access',
        subtitle: 'Used for inviting friends & sharing coupons with contacts',
        icon: Icons.contacts_rounded,
        iconColor: const Color(0xFFEC4899),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'App Permissions Center',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFF2DD4BF), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Privacy & Permission Control',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Daily Basket only asks for permissions when necessary. You can adjust permissions anytime.',
                          style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Permission Tiles List
            Text(
              'Active Application Permissions',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final item = items[i];
                final status = permissionsProvider.getStatus(item.type);
                final isGranted = status == AppPermissionStatus.granted;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: item.iconColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: item.iconColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _statusBadge(status),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isGranted,
                        activeThumbColor: const Color(0xFF2DD4BF),
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          if (val) {
                            permissionsProvider.updatePermissionStatus(
                              item.type,
                              AppPermissionStatus.granted,
                            );
                          } else {
                            permissionsProvider.updatePermissionStatus(
                              item.type,
                              AppPermissionStatus.denied,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // System Device Settings Redirect Card
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  AppPermissionService.showOpenSettingsModal(
                    context: context,
                    title: 'System Settings',
                    description: 'Open device settings to manage OS-level location, camera, or notification permissions.',
                  );
                },
                icon: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF2DD4BF)),
                label: Text(
                  'Open System Device Settings',
                  style: GoogleFonts.outfit(color: const Color(0xFF2DD4BF), fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2DD4BF)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(AppPermissionStatus status) {
    String label;
    Color bg;
    Color text;

    switch (status) {
      case AppPermissionStatus.granted:
        label = 'ALLOWED';
        bg = const Color(0xFF006B23);
        text = Colors.white;
        break;
      case AppPermissionStatus.denied:
        label = 'DENIED';
        bg = const Color(0xFFB45309);
        text = Colors.white;
        break;
      case AppPermissionStatus.permanentlyDenied:
        label = 'SETTINGS';
        bg = const Color(0xFFBE123C);
        text = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 8, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _PermissionTileData {
  final PermissionType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  _PermissionTileData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}
