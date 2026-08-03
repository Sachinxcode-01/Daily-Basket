import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Personal Information Screen — Google Stitch Design System Exact Replica
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController(text: 'Alex Johnson');
  final _emailController = TextEditingController(text: 'alex.j@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personal information updated successfully!'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
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
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF006B23)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Personal Information',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ─── 1. Profile Avatar Section ─────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFC0E8C7), width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFE8F5E9),
                                  child: const Icon(Icons.person, size: 50, color: Color(0xFF006B23)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF006B23),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'TAP TO EDIT PHOTO',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: const Color(0xFF6E7A6C),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ─── 2. Secure Form Fields ─────────────────────────────────
                // Field 1: FULL NAME
                _buildFieldHeader('FULL NAME', isVerified: false),
                const SizedBox(height: 6),
                _buildInputField(controller: _nameController),

                const SizedBox(height: 18),

                // Field 2: EMAIL ADDRESS
                _buildFieldHeader('EMAIL ADDRESS', isVerified: true),
                const SizedBox(height: 6),
                _buildInputField(controller: _emailController),

                const SizedBox(height: 18),

                // Field 3: PHONE NUMBER
                _buildFieldHeader('PHONE NUMBER', isVerified: true),
                const SizedBox(height: 6),
                _buildInputField(controller: _phoneController),

                const SizedBox(height: 24),

                // ─── 3. Informative Guidance Box ───────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F6),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFF1A1C1E), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your email and phone number are verified. Changing them will require a new verification code.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 18 / 13,
                            color: const Color(0xFF3F4A3D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),

          // ─── 4. Fixed Bottom Primary CTA (Save Changes) ──────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldHeader(String label, {required bool isVerified}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        if (isVerified)
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: Color(0xFF006B23), size: 14),
              const SizedBox(width: 4),
              Text(
                'VERIFIED',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: const Color(0xFF006B23),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildInputField({required TextEditingController controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1C1E),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
