import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'About'),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('ExpenseFlow helps you manage finances easily.'),
      ),
    );
  }
}
