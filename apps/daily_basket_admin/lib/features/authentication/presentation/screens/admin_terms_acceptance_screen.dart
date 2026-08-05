import 'package:flutter/material.dart';

class AdminTermsAcceptanceScreen extends StatefulWidget {
  const AdminTermsAcceptanceScreen({super.key});

  @override
  State<AdminTermsAcceptanceScreen> createState() => _AdminTermsAcceptanceScreenState();
}

class _AdminTermsAcceptanceScreenState extends State<AdminTermsAcceptanceScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.policy_rounded, size: 48, color: Color(0xFF2DD4BF)),
              const SizedBox(height: 16),
              const Text('Admin Terms & Security Policy', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
                  child: const SingleChildScrollView(
                    child: Text(
                      'Daily Basket Enterprise Administrator Policy (v2.0)\n\n'
                      '1. Data Confidentiality: As an authorized system administrator, you agree to maintain absolute confidentiality of customer PII, financial ledgers, and inventory data.\n'
                      '2. Audit Logging: All actions (order cancels, refunds, stock adjustments, role grants) are recorded in tamper-evident security audit logs.\n'
                      '3. Session Security: Do not share TOTP secrets, hardware keys, or credentials.\n',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.6),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _accepted,
                    activeColor: const Color(0xFF2DD4BF),
                    onChanged: (val) => setState(() => _accepted = val ?? false),
                  ),
                  const Expanded(
                    child: Text('I agree to the Admin Security Policy', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _accepted ? () => Navigator.pushNamed(context, '/admin/dashboard') : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Accept & Launch Portal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
