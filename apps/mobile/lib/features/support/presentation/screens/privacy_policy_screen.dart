import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Privacy Policy Screen — Exact Google Stitch Specification
/// Screen ID: 8684268b6157495ab31ab5ed4b61ecb2
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF006B23),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Basket',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  'Privacy Policy',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last Updated: October 26, 2023',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF3F4A3D),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE2E2E5), height: 1),
                const SizedBox(height: 24),

                // Section 1
                _buildSectionTitle('1. Introduction'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'Welcome to Daily Basket. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you as to how we look after your personal data when you visit our application (regardless of where you visit it from) and tell you about your privacy rights and how the law protects you.',
                ),
                const SizedBox(height: 24),

                // Section 2
                _buildSectionTitle('2. Data Collection'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'We collect various types of information in connection with the services we provide, including:',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint('Personal Information', 'Name, email address, phone number, and delivery address.'),
                _buildBulletPoint('Usage Data', 'Information on how you interact with our application, including search queries, viewed items, and purchasing history.'),
                _buildBulletPoint('Cookies & Tracking', 'We use cookies and similar tracking technologies to track the activity on our Service and hold certain information to improve your experience.'),
                const SizedBox(height: 24),

                // Section 3
                _buildSectionTitle('3. How We Use Data'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'The personal information we collect is used for various purposes, such as:',
                ),
                const SizedBox(height: 8),
                _buildBulletItem('To provide and maintain our Service, including fulfilling your grocery orders.'),
                _buildBulletItem('To notify you about changes to our Service or your order status.'),
                _buildBulletItem('To provide customer support and respond to your inquiries.'),
                _buildBulletItem('To gather analysis or valuable information so that we can improve our application.'),
                const SizedBox(height: 24),

                // Section 4
                _buildSectionTitle('4. Data Sharing'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'We may share your personal data with trusted third parties to facilitate our Service, provide the Service on our behalf, perform Service-related services, or assist us in analyzing how our Service is used. These third parties (such as delivery partners and payment processors) have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.',
                ),
                const SizedBox(height: 24),

                // Section 5
                _buildSectionTitle('5. Security'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security. We employ industry-standard encryption and security protocols to safeguard your information.',
                ),
                const SizedBox(height: 24),

                // Section 6
                _buildSectionTitle('6. Your Rights'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'Depending on your location, you may have the following rights regarding your personal data:',
                ),
                const SizedBox(height: 8),
                _buildBulletItem('The right to access, update or to delete the information we have on you.'),
                _buildBulletItem('The right of rectification if your information is inaccurate or incomplete.'),
                _buildBulletItem('The right to object to our processing of your Personal Data.'),
                _buildBulletItem('The right to request that we restrict the processing of your personal information.'),
                const SizedBox(height: 12),
                _buildParagraph('If you wish to exercise any of these rights, please contact us.'),
                const SizedBox(height: 32),

                // Contact Support Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E2E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Questions?',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'If you have any questions about this Privacy Policy, please contact our support team.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF3F4A3D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/help');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDCE5DD),
                          foregroundColor: const Color(0xFF5E6660),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Contact Support',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF006B23),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: const Color(0xFF1A1C1E),
      ),
    );
  }

  Widget _buildBulletPoint(String boldTitle, String detail) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, color: Color(0xFF3F4A3D))),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: const Color(0xFF3F4A3D)),
                children: [
                  TextSpan(text: '$boldTitle: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: detail),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, color: Color(0xFF3F4A3D))),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: const Color(0xFF3F4A3D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
