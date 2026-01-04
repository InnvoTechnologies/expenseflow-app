import 'package:flutter/material.dart';
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});
  @override
  State<SecurityPage> createState() => _SecurityPageState();
}
class _SecurityPageState extends State<SecurityPage> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: currentController, decoration: const InputDecoration(labelText: 'Current Password'), obscureText: true),
          const SizedBox(height: 8),
          TextField(controller: newController, decoration: const InputDecoration(labelText: 'New Password'), obscureText: true),
          const SizedBox(height: 8),
          TextField(controller: confirmController, decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: const Text('Change Password')),
        ],
      ),
    );
  }
}
