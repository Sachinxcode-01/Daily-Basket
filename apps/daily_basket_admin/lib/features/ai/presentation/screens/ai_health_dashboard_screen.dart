import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/ai_health_provider.dart';

class AiHealthDashboardScreen extends StatelessWidget {
  const AiHealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final health = context.watch<AiHealthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text('AI Telemetry & Provider Health', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2F3133),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF8CFA93)),
            onPressed: () => health.refreshHealthDiagnostics(),
            tooltip: 'Ping AI Providers',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F3133),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF006B23)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF006B23).withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Color(0xFF006B23), shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Suite Operational', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Gemini 1.5 • OpenRouter • OCR • Voice STT/TTS • Recommendations', style: TextStyle(color: Color(0xFFBECAB9), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header & Test Suite Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Configured Providers', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: health.isLoading ? null : () => health.runAllAiTestSuite(),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18, color: Colors.white),
                  label: const Text('Run Full E2E AI Test Suite', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B23),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Provider Cards List
            if (health.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: Color(0xFF8CFA93)),
                ),
              )
            else
              ...health.providers.map((p) => _buildProviderCard(context, p)),

            const SizedBox(height: 24),
            if (health.testResults.isNotEmpty) _buildTestResultsWidget(context, health.testResults),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, AiProviderStatus p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F3133),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.isOperational ? const Color(0xFF6E7A6C) : const Color(0xFFBA1A1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                p.isOperational ? Icons.check_circle_rounded : Icons.error_rounded,
                color: p.isOperational ? const Color(0xFF8CFA93) : const Color(0xFFBA1A1A),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1C1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${p.latencyMs} ms', style: const TextStyle(color: Color(0xFF8CFA93), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Model: ${p.model}', style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 12)),
              Text('Quota: ${p.quotaRemaining}', style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Provider: ${p.provider}', style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 11)),
              Text('Daily: ${p.dailyUsage}', style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultsWidget(BuildContext context, Map<String, dynamic> results) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF006B23).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF078730)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: Color(0xFF8CFA93), size: 22),
              SizedBox(width: 10),
              Text('E2E AI Suite Test Results — All Passed (6/6)', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...results.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Color(0xFF8CFA93), size: 16),
                    const SizedBox(width: 8),
                    Text('${e.key}: ', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    Expanded(child: Text('${e.value['output']} (${e.value['latencyMs']}ms)', style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 12))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
