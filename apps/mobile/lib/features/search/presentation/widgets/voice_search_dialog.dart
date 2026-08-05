import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoiceSearchDialog extends StatefulWidget {
  final Function(String query) onSpeechResult;

  const VoiceSearchDialog({super.key, required this.onSpeechResult});

  static void show(BuildContext context, {required Function(String query) onSpeechResult}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => VoiceSearchDialog(onSpeechResult: onSpeechResult),
    );
  }

  @override
  State<VoiceSearchDialog> createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends State<VoiceSearchDialog> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  String _recognizedText = 'Listening for "Fresh Milk", "Atta", "Amul Butter"...';
  bool _isListening = true;

  final List<String> _sampleQueries = [
    'Organic Hass Avocados',
    'Amul Taaza Toned Milk',
    'Aashirvaad Chakki Atta',
    'Fortune Sunlite Sunflower Oil',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate voice recognition result after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _recognizedText = 'Organic Hass Avocados';
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            widget.onSpeechResult('Organic Hass Avocados');
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFBECAB9),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Pulsing Microphone Icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isListening ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _isListening
                        ? const Color(0xFF006B23).withValues(alpha: 0.12)
                        : const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF006B23),
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _isListening ? Icons.mic_rounded : Icons.check_circle_rounded,
                      color: const Color(0xFF006B23),
                      size: 42,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Status & Query Text
          Text(
            _isListening ? 'Listening...' : 'Searching for:',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6E7A6C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _recognizedText,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 24),

          // Sample Voice Queries Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _sampleQueries.map((query) {
              return ActionChip(
                label: Text(query),
                labelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF006B23),
                ),
                backgroundColor: const Color(0xFFE8F5E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                onPressed: () {
                  widget.onSpeechResult(query);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
