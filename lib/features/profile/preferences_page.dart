import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});
  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String currency = 'USD';
  ThemeMode mode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Preferences'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: currency,
            items: const [
              DropdownMenuItem(value: 'USD', child: Text('USD')),
              DropdownMenuItem(value: 'EUR', child: Text('EUR')),
              DropdownMenuItem(value: 'AUD', child: Text('AUD')),
            ],
            onChanged: (v) => setState(() => currency = v!),
            decoration: const InputDecoration(labelText: 'Base Currency'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ThemeMode>(
            initialValue: mode,
            items: const [
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            ],
            onChanged: (v) => setState(() => mode = v!),
            decoration: const InputDecoration(labelText: 'Theme'),
          ),
        ],
      ),
    );
  }
}
