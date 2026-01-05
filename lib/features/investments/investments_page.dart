import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';

class InvestmentsPage extends StatelessWidget {
  const InvestmentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Investments'),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.trending_up, size: 48),
            SizedBox(height: 12),
            Text('Portfolio tracking coming soon'),
          ],
        ),
      ),
    );
  }
}
