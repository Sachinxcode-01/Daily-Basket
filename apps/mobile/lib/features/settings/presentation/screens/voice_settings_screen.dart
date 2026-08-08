import 'package:flutter/material.dart';

class VoiceSettingsScreen extends StatefulWidget {
  const VoiceSettingsScreen({super.key});

  @override
  State<VoiceSettingsScreen> createState() => _VoiceSettingsScreenState();
}

class _VoiceSettingsScreenState extends State<VoiceSettingsScreen> {
  bool _voiceEnabled = true;
  String _preferredLanguage = 'en_IN';
  String _preferredVoiceGender = 'FEMALE';
  double _speechSpeed = 1.0;
  bool _autoSpeak = true;
  bool _privacyMode = false;

  final List<Map<String, String>> _languages = [
    {'code': 'en_IN', 'name': 'English (India)'},
    {'code': 'hi_IN', 'name': 'हिंदी (Hindi)'},
    {'code': 'kn_IN', 'name': 'ಕನ್ನಡ (Kannada)'},
    {'code': 'ta_IN', 'name': 'தமிழ் (Tamil)'},
    {'code': 'te_IN', 'name': 'తెలుగు (Telugu)'},
    {'code': 'ml_IN', 'name': 'മലയാളം (Malayalam)'},
    {'code': 'mr_IN', 'name': 'मराठी (Marathi)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Voice AI Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Enable Voice Switch
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.record_voice_over, color: Color(0xFF059669), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Enable Voice Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Search, shop, and navigate via speech', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Switch(
                  value: _voiceEnabled,
                  activeColor: const Color(0xFF059669),
                  onChanged: (val) => setState(() => _voiceEnabled = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Preferences Section
          const Text('VOICE PREFERENCES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Preferred Language
                ListTile(
                  title: const Text('Spoken Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(_languages.firstWhere((l) => l['code'] == _preferredLanguage)['name']!, style: const TextStyle(fontSize: 12, color: Color(0xFF059669))),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: _showLanguagePicker,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // Voice Gender
                ListTile(
                  title: const Text('Assistant Voice', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(_preferredVoiceGender == 'FEMALE' ? 'Sarah J. (Natural Female)' : 'Supermarket Agent (Male)', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'FEMALE', label: Text('Female')),
                      ButtonSegment(value: 'MALE', label: Text('Male')),
                    ],
                    selected: {_preferredVoiceGender},
                    onSelectionChanged: (set) => setState(() => _preferredVoiceGender = set.first),
                    style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // Speech Speed Slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Speech Playback Speed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text('${_speechSpeed.toStringAsFixed(2)}x', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                        ],
                      ),
                      Slider(
                        value: _speechSpeed,
                        min: 0.75,
                        max: 1.5,
                        divisions: 3,
                        activeColor: const Color(0xFF059669),
                        onChanged: (val) => setState(() => _speechSpeed = val),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // Auto Speak Toggle
                SwitchListTile(
                  title: const Text('Auto-Speak Spoken Responses', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Read AI responses out loud automatically', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  value: _autoSpeak,
                  activeColor: const Color(0xFF059669),
                  onChanged: (val) => setState(() => _autoSpeak = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Privacy & History Section
          const Text('PRIVACY & HISTORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Privacy Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Do not store voice audio command logs', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  value: _privacyMode,
                  activeColor: const Color(0xFF059669),
                  onChanged: (val) => setState(() => _privacyMode = val),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                  title: const Text('Clear Voice Command History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice command history cleared successfully!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Spoken Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ..._languages.map((l) => ListTile(
                title: Text(l['name']!),
                trailing: _preferredLanguage == l['code'] ? const Icon(Icons.check, color: Color(0xFF059669)) : null,
                onTap: () {
                  setState(() => _preferredLanguage = l['code']!);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }
}
