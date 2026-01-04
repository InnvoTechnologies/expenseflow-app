import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});
  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Subscriptions',
        actions: [
          IconButton(onPressed: _newSubscription, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        padding: kDefaultPadding,
        itemCount: DummyData.subscriptions.length,
        itemBuilder: (context, i) {
          final s = DummyData.subscriptions[i];
          final days = s.nextBillingDate.difference(DateTime.now()).inDays;
          return Card(
            child: ListTile(
              leading: const Icon(Icons.repeat),
              title: Text(s.title),
              subtitle: Text(
                '${s.billingCycle.name.toUpperCase()} • \$${s.amount.toStringAsFixed(2)} • ${days >= 0 ? '$days days remaining' : 'Past due'}',
              ),
              trailing: Text(s.status),
              onTap: () => _editSubscription(i),
            ),
          );
        },
      ),
    );
  }

  void _newSubscription() {
    _editSubscription(null);
  }

  void _editSubscription(int? index) async {
    final titleController = TextEditingController(
      text: index == null ? '' : DummyData.subscriptions[index].title,
    );
    final amountController = TextEditingController(
      text: index == null
          ? ''
          : DummyData.subscriptions[index].amount.toString(),
    );
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'New Subscription' : 'Edit Subscription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    setState(() {});
  }
}
