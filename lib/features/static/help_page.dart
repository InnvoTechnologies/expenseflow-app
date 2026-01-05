import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Help'),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('For support, contact support@example.com.'),
      ),
    );
  }
}
