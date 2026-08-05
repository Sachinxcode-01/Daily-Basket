import 'package:flutter/material.dart';

class AdminLoadingScreen extends StatelessWidget {
  const AdminLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(color: Color(0xFF2DD4BF), strokeWidth: 4),
            ),
            SizedBox(height: 24),
            Text('Synchronizing Operations & Dark Store Telemetry...', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
