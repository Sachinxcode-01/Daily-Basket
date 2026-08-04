import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/address_provider.dart';

/// Location Permission Dialog — Google Stitch Design System Exact Replica
class LocationPermissionDialog extends StatelessWidget {
  final Function(LocationPermissionState result) onPermissionResult;

  const LocationPermissionDialog({
    super.key,
    required this.onPermissionResult,
  });

  static Future<LocationPermissionState?> show(BuildContext context) {
    return showDialog<LocationPermissionState>(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialog(
        onPermissionResult: (result) {
          Navigator.of(context).pop(result);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Location Badge & Animated Pulse Ring
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF006B23).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF006B23).withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006B23),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dialog Header Title
            Text(
              'Allow "Daily Basket" to access your location?',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1C1E),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Dialog Subtitle Explanation
            Text(
              'Daily Basket uses your live GPS location to auto-detect your delivery address, check hyper-local 10-minute dark store coverage, and calculate accurate delivery estimates.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6E7A6C),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Option 1: While Using the App (Primary CTA)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => onPermissionResult(LocationPermissionState.granted),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006B23),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  'While Using the App',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Option 2: Only This Time (Outlined CTA)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => onPermissionResult(LocationPermissionState.granted),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF006B23),
                  side: const BorderSide(color: Color(0xFF006B23), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.timer_outlined, size: 20),
                label: Text(
                  'Only This Time',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Option 3: Don't Allow (Secondary Action)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () => onPermissionResult(LocationPermissionState.denied),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6E7A6C),
                ),
                child: Text(
                  "Don't Allow",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
