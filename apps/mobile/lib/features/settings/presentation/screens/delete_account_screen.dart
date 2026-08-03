import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Delete Account Screen — Google Stitch Design System Exact Replica
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  int? _selectedReasonIndex;
  final _commentsController = TextEditingController();

  final List<String> _reasons = [
    'I found a better alternative',
    'Too many notifications',
    'The app is too slow',
    'I want to clear my data',
    'Other',
  ];

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void _continueToDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirm Account Deletion',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: const Color(0xFFBA1A1A)),
        ),
        content: Text(
          'Are you sure you want to permanently delete your Daily Basket account? This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF3F4A3D)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted.'),
                  backgroundColor: Color(0xFFBA1A1A),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Delete', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Delete Account',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Headline
            Text(
              "We're sorry to see you go",
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              'Please tell us why you are leaving so we can improve Daily Basket.',
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 20 / 14,
                color: const Color(0xFF6E7A6C),
              ),
            ),

            const SizedBox(height: 20),

            // Reason Selection Radio Cards
            ...List.generate(_reasons.length, (index) {
              final isSelected = _selectedReasonIndex == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  onTap: () => setState(() => _selectedReasonIndex = index),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF3F3F6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF006B23) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
                              width: isSelected ? 6 : 1.5,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            _reasons[index],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Additional Comments Section
            Text(
              'ADDITIONAL COMMENTS (OPTIONAL)',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: const Color(0xFF6E7A6C),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _commentsController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1C1E)),
                decoration: InputDecoration(
                  hintText: 'Tell us more...',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C)),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Action Buttons
            // 1. Continue to Delete (Red Stadium Button)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _continueToDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Continue to Delete',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 2. Cancel (Soft Green Stadium Button)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDCE8DC),
                  foregroundColor: const Color(0xFF006B23),
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
