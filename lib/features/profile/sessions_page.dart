import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Sessions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.sessions.length,
        itemBuilder: (context, i) {
          final s = DummyData.sessions[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.devices),
              title: Text(s.userAgent),
              subtitle: Text('${s.ipAddress} • Expires ${s.expiresAt.year}-${s.expiresAt.month.toString().padLeft(2, '0')}-${s.expiresAt.day.toString().padLeft(2, '0')}'),
              trailing: TextButton(onPressed: () {}, child: const Text('Revoke')),
            ),
          );
        },
      ),
    );
  }
}
