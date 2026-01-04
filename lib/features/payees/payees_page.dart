import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';

class PayeesPage extends StatefulWidget {
  const PayeesPage({super.key});
  @override
  State<PayeesPage> createState() => _PayeesPageState();
}

class _PayeesPageState extends State<PayeesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Payees',
        actions: [
          IconButton(onPressed: () => _openForm(), icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        padding: kDefaultPadding,
        itemCount: DummyData.payees.length,
        itemBuilder: (context, i) {
          final p = DummyData.payees[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(p.name),
              subtitle: Text(p.description ?? ''),
              trailing: IconButton(
                onPressed: () => _openForm(index: i),
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openForm({int? index}) async {
    final nameController = TextEditingController(
      text: index == null ? '' : DummyData.payees[index].name,
    );
    final descController = TextEditingController(
      text: index == null ? '' : DummyData.payees[index].description ?? '',
    );
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'New Payee' : 'Edit Payee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
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
