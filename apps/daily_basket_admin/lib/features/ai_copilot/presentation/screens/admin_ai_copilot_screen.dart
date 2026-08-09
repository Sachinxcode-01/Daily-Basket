import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: AI Business Copilot - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 08e0fa2289074af1a38a365ced2fb035
class AdminAiCopilotScreen extends StatefulWidget {
  const AdminAiCopilotScreen({super.key});

  @override
  State<AdminAiCopilotScreen> createState() => _AdminAiCopilotScreenState();
}

class _AdminAiCopilotScreenState extends State<AdminAiCopilotScreen> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello Admin! I am your Daily Basket AI Copilot powered by Gemini. How can I assist you with inventory forecasting or sales optimization today?',
    },
  ];

  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);

  void _sendMessage(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': query});
      _chatController.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'ai',
            'text': '🤖 Analyzing Daily Basket telemetry for "$query"... Forecast predicts a 15% surge in Avocado orders this weekend. Recommend restocking 40 units in WH-South.',
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: _primaryGreen, size: 20),
            SizedBox(width: 8),
            Text('AI Business Copilot', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Suggestion Chips
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: SizedBox(
                height: 34,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    'Forecast Avocado demand',
                    'Identify top revenue leaks',
                    'Optimize Zone B rider routes',
                  ].map((sug) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _sendMessage(sug),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4EA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFA7F3D0)),
                          ),
                          child: Text(sug, style: const TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 11.5)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Messages Stream
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isAi = msg['sender'] == 'ai';

                  return Align(
                    alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                      decoration: BoxDecoration(
                        color: isAi ? Colors.white : _primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                        border: isAi ? Border.all(color: const Color(0xFFE2E8F0)) : null,
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(color: isAi ? _textDark : Colors.white, fontSize: 13, height: 1.4),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Chat Input Bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: const TextStyle(color: _textDark, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Ask Copilot anything about inventory, sales...',
                        hintStyle: TextStyle(color: _textMuted, fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none_rounded, color: _textMuted),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: _primaryGreen),
                    onPressed: () => _sendMessage(_chatController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
