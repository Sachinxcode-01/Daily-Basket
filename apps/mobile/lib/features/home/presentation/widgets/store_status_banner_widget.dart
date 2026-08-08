import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreStatusBannerWidget extends StatelessWidget {
  final bool isOpen;
  final String closingTime;
  final String? maintenanceMessage;

  const StoreStatusBannerWidget({
    super.key,
    this.isOpen = true,
    this.closingTime = '9:30 PM',
    this.maintenanceMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFFEF4444),
        child: Row(
          children: [
            const Icon(Icons.storefront_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                maintenanceMessage ?? 'Store is currently closed. Pre-orders open for tomorrow morning!',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFECFDF5),
        border: Border(bottom: BorderSide(color: Color(0xFFA7F3D0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Store Open • 10-Min Superfast Delivery',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF065F46),
                ),
              ),
            ],
          ),
          Text(
            'Order till $closingTime',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF047857),
            ),
          ),
        ],
      ),
    );
  }
}
