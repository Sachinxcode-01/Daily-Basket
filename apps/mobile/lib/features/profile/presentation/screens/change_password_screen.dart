import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Change Password Screen — Google Stitch Design System Exact Replica
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  bool _showSuccessAlert = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final _currentController = TextEditingController();
  final _newController = TextEditingController(text: 'Password123!');
  final _confirmController = TextEditingController(text: 'Password123!');

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Snappier 200ms entrance
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    setState(() {
      _showSuccessAlert = true;
    });
    _animController.reset();
    _animController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully!'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
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
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF006B23)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Change Password',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // ─── 1. Success Alert Banner Box (200ms Snappy Entrance) ───────
                if (_showSuccessAlert) ...[
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFC0E8C7)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                color: Color(0xFF006B23), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Password updated successfully!',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF00531A),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Color(0xFF3F4A3D), size: 18),
                              onPressed: () => setState(() => _showSuccessAlert = false),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ─── 2. Guidance Subtitle ───────────────────────────────────
                Text(
                  'Update your password to keep your Daily Basket account secure.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 20 / 14,
                    color: const Color(0xFF3F4A3D),
                  ),
                ),

                const SizedBox(height: 20),

                // ─── 3. Current Password Field ─────────────────────────────
                _buildFieldLabel('Current Password'),
                const SizedBox(height: 6),
                _buildPasswordField(
                  controller: _currentController,
                  hintText: 'Enter current password',
                  obscureText: _obscureCurrent,
                  onToggleObscure: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF006B23),
                      ),
                    ),
                  ),
                ),

                // ─── 4. New Password Field ──────────────────────────────────
                _buildFieldLabel('New Password'),
                const SizedBox(height: 6),
                _buildPasswordField(
                  controller: _newController,
                  hintText: 'Enter new password',
                  obscureText: _obscureNew,
                  onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
                ),

                const SizedBox(height: 12),

                // Password Strength Meter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Password Strength',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    Text(
                      'Strong',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF006B23),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 4 Strength Segment Bars
                Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF006B23),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // ─── 5. Password Requirements Card ─────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildRequirementItem(
                        isMet: true,
                        text: 'At least 8 characters',
                      ),
                      const SizedBox(height: 8),
                      _buildRequirementItem(
                        isMet: false,
                        text: 'Include a number',
                      ),
                      const SizedBox(height: 8),
                      _buildRequirementItem(
                        isMet: false,
                        text: 'Include a special character',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ─── 6. Confirm New Password Field ─────────────────────────
                _buildFieldLabel('Confirm New Password'),
                const SizedBox(height: 6),
                _buildPasswordField(
                  controller: _confirmController,
                  hintText: 'Confirm new password',
                  obscureText: _obscureConfirm,
                  onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: Color(0xFF006B23), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Passwords match',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF006B23),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),

          // ─── 7. Fixed Bottom Primary CTA (Update Password) ────────────────
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
                  child: ElevatedButton.icon(
                    onPressed: _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.published_with_changes_rounded,
                        color: Colors.white, size: 20),
                    label: Text(
                      'Update Password',
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1C1E),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleObscure,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1C1E)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF1A1C1E),
              size: 20,
            ),
            onPressed: onToggleObscure,
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem({required bool isMet, required String text}) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle_outline_rounded : Icons.radio_button_unchecked_rounded,
          color: isMet ? const Color(0xFF006B23) : const Color(0xFFBECAB9),
          size: 18,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isMet ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
            fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
