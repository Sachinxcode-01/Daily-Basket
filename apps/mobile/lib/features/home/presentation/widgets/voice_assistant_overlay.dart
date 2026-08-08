import 'package:flutter/material.dart';

class VoiceAssistantOverlay extends StatefulWidget {
  final bool isListening;
  final String transcription;
  final String currentLanguage;
  final VoidCallback onMicTap;
  final VoidCallback? onMuteTap;
  final Function(String)? onLanguageChanged;

  const VoiceAssistantOverlay({
    super.key,
    required this.isListening,
    required this.transcription,
    this.currentLanguage = 'en_IN',
    required this.onMicTap,
    this.onMuteTap,
    this.onLanguageChanged,
  });

  @override
  State<VoiceAssistantOverlay> createState() => _VoiceAssistantOverlayState();
}

class _VoiceAssistantOverlayState extends State<VoiceAssistantOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isListening;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: active ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: active ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: active
                ? const Color(0xFF10B981).withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Waveform Mic Button
          GestureDetector(
            onTap: widget.onMicTap,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = active ? 1.0 + (_pulseController.value * 0.15) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: active
                          ? const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                            ),
                    ),
                    child: Icon(
                      active ? Icons.mic : Icons.mic_none_rounded,
                      color: active ? Colors.white : const Color(0xFF059669),
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Transcription / Status Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  active ? 'Listening...' : 'Tap to speak',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: active ? const Color(0xFF34D399) : const Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.transcription.isNotEmpty
                      ? widget.transcription
                      : (active
                          ? 'Say "Open Cart" or "Find Amul Milk"...'
                          : 'Voice AI Ready — Speak in English, Hindi, Kannada...'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),

          // Language Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.currentLanguage.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: active ? const Color(0xFFA7F3D0) : const Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
