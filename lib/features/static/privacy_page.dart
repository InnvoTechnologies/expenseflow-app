import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Privacy Policy'),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Your data is handled securely.'),
      ),
    );
  }
}
