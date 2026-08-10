import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';

/// Stitch Screen: Admin Profile Completion Screen
/// Handles onboarding verification if profile is incomplete.
class AdminProfileCompletionScreen extends StatefulWidget {
  const AdminProfileCompletionScreen({super.key});

  @override
  State<AdminProfileCompletionScreen> createState() => _AdminProfileCompletionScreenState();
}

class _AdminProfileCompletionScreenState extends State<AdminProfileCompletionScreen> {
  final _nameController = TextEditingController(text: 'Ananya Rao');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  String _selectedRole = 'SUPER_ADMIN';
  String _selectedStore = 'ds_bengaluru_01';
  bool _isSaving = false;

  void _handleSaveProfile() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      context.read<AdminAuthProvider>().completeProfile(
        name: _nameController.text,
        phone: _phoneController.text,
        role: _selectedRole,
      );
      Navigator.pushReplacementNamed(context, '/admin/dashboard');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text('Complete Admin Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2F3133),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_box_rounded, size: 56, color: Color(0xFF8CFA93)),
            const SizedBox(height: 16),
            const Text('Onboarding Profile Verification', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Verify your official admin credentials & dark store assignment before accessing operations dashboard.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFBECAB9), fontSize: 13)),
            const SizedBox(height: 28),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: const TextStyle(color: Color(0xFFBECAB9)),
                prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF8CFA93)),
                filled: true,
                fillColor: const Color(0xFF2F3133),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Direct Mobile Phone',
                labelStyle: const TextStyle(color: Color(0xFFBECAB9)),
                prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF8CFA93)),
                filled: true,
                fillColor: const Color(0xFF2F3133),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              dropdownColor: const Color(0xFF2F3133),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Assigned Security Role',
                labelStyle: const TextStyle(color: Color(0xFFBECAB9)),
                prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF8CFA93)),
                filled: true,
                fillColor: const Color(0xFF2F3133),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              items: const [
                DropdownMenuItem(value: 'SUPER_ADMIN', child: Text('Super Admin (Full Platform Control)')),
                DropdownMenuItem(value: 'DARK_STORE_MANAGER', child: Text('Dark Store Operations Manager')),
                DropdownMenuItem(value: 'INVENTORY_LEAD', child: Text('Inventory & Stock Controller')),
                DropdownMenuItem(value: 'AUDITOR', child: Text('Financial & GST Compliance Auditor')),
              ],
              onChanged: (val) => setState(() => _selectedRole = val ?? _selectedRole),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStore,
              dropdownColor: const Color(0xFF2F3133),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Primary Dark Store Hub',
                labelStyle: const TextStyle(color: Color(0xFFBECAB9)),
                prefixIcon: const Icon(Icons.storefront_rounded, color: Color(0xFF8CFA93)),
                filled: true,
                fillColor: const Color(0xFF2F3133),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              items: const [
                DropdownMenuItem(value: 'ds_bengaluru_01', child: Text('Hub #01 — Indiranagar, Bengaluru')),
                DropdownMenuItem(value: 'ds_bengaluru_02', child: Text('Hub #02 — Koramangala, Bengaluru')),
                DropdownMenuItem(value: 'ds_mumbai_01', child: Text('Hub #03 — Bandra, Mumbai')),
                DropdownMenuItem(value: 'ds_delhi_01', child: Text('Hub #04 — Connaught Place, New Delhi')),
              ],
              onChanged: (val) => setState(() => _selectedStore = val ?? _selectedStore),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSaving ? null : _handleSaveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006B23),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSaving
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('Saving Profile & Initializing Session…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : const Text('Save Profile & Launch Operations Dashboard', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
