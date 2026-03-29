import 'package:expenseflow/core/util/const/constants.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';
import '../../core/util/widgets/app_bar.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Savings',
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
        padding: kDefaultPadding,
        itemCount: DummyData.savings.length,
        itemBuilder: (context, i) {
          final g = DummyData.savings[i];
          final progress = g.savedAmount / g.targetAmount;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${g.savedAmount.toStringAsFixed(0)}'),
                      Text('\$${g.targetAmount.toStringAsFixed(0)}'),
                    ],
                  ),
                  if (g.targetDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Target: ${g.targetDate!.year}-${g.targetDate!.month.toString().padLeft(2, '0')}-${g.targetDate!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
