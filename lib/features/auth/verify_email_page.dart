import 'package:flutter/material.dart';
class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Icon(Icons.mark_email_unread, size: 48),
            SizedBox(height: 12),
            Text('Check your inbox and click the verification link.'),
          ],
        ),
      ),
    );
  }
}
