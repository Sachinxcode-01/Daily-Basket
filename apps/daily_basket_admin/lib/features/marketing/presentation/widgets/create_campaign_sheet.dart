import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_marketing_provider.dart';

/// Modal Bottom Sheet to compose and publish a new Daily Message campaign
class CreateCampaignSheet extends StatefulWidget {
  const CreateCampaignSheet({super.key});

  @override
  State<CreateCampaignSheet> createState() => _CreateCampaignSheetState();
}

class _CreateCampaignSheetState extends State<CreateCampaignSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController =
      TextEditingController(text: 'Morning Organic Harvest 🌿');
  final _bodyController = TextEditingController(
      text:
          'Crisp greens, farm-fresh milk & seasonal berries delivered to your door in 10 minutes.');
  String _selectedAudience = 'CUSTOMER';
  bool _setActiveImmediately = true;
  bool _isSubmitting = false;

  static const Color _primaryGreen = Color(0xFF2D9D43);
  static const Color _cardBg = Color(0xFF1E293B);
  static const Color _inputBg = Color(0xFF0F172A);

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final provider = context.read<AdminMarketingProvider>();

    final success = await provider.createCampaign(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      audienceRole: _selectedAudience,
      enabled: _setActiveImmediately,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Daily Message campaign published successfully! 🚀'),
            ],
          ),
          backgroundColor: _primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to publish campaign'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag bar
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sheet Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign_rounded,
                        color: _primaryGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Compose Daily Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Title Field
              const Text(
                'Campaign Title',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _inputBg,
                  hintText: 'e.g. Fresh Morning Harvest 🌿',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),

              // Body Field
              const Text(
                'Announcement Message',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _bodyController,
                onChanged: (_) => setState(() {}),
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _inputBg,
                  hintText:
                      'Enter promo copy, product mentions, or delivery guarantees...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter a message body'
                    : null,
              ),
              const SizedBox(height: 16),

              // Target Audience Chips
              const Text(
                'Target Audience',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildAudienceChip('CUSTOMER', 'All Customers'),
                  _buildAudienceChip('VIP', 'VIP Club Members'),
                  _buildAudienceChip('DELIVERY_PARTNER', 'Delivery Fleet'),
                ],
              ),
              const SizedBox(height: 16),

              // Active Immediately Toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: _primaryGreen,
                title: const Text(
                  'Set as Active Morning Banner',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Immediately reflects on customer app home screen',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: _setActiveImmediately,
                onChanged: (val) => setState(() => _setActiveImmediately = val),
              ),
              const SizedBox(height: 16),

              // Live Customer Preview Banner
              const Text(
                'Live Customer App Preview',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2D9D43).withOpacity(0.18),
                      const Color(0xFF0F766E).withOpacity(0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryGreen.withOpacity(0.4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryGreen.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF70DD7A), size: 18),
                    ),
                    const SizedBox(width: 12),
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
                                  color: _primaryGreen,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'DAILY SPECIAL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _titleController.text.isEmpty
                                      ? 'Morning Announcement'
                                      : _titleController.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _bodyController.text.isEmpty
                                ? 'Your promotional message preview will appear here...'
                                : _bodyController.text,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Publish Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.publish_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Publish Daily Message',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudienceChip(String role, String label) {
    final isSelected = _selectedAudience == role;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: _primaryGreen,
      backgroundColor: _inputBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (val) {
        if (val) setState(() => _selectedAudience = role);
      },
    );
  }
}
