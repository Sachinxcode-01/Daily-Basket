import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PermissionType {
  location,
  notifications,
  camera,
  microphone,
  gallery,
  biometric,
  contacts,
  storage,
}

enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
}

class AppPermissionService {
  /// Displays a Google Stitch styled pre-permission rationale modal
  static Future<bool> showRationaleModal({
    required BuildContext context,
    required String title,
    required String icon,
    required String description,
    required List<String> benefits,
    required String confirmText,
    required String cancelText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006B23).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            if (benefits.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...benefits.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF00FF57), fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          b,
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF94A3B8),
                    ),
                    child: Text(cancelText, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }

  /// Displays a modal prompting user to open Device Settings if permission was permanently denied
  static void showOpenSettingsModal({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          description,
          style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not Now', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening device settings...'),
                  backgroundColor: Color(0xFF006B23),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006B23),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Open Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
