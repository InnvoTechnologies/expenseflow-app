import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}
class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts'), actions: [
        IconButton(onPressed: () => _openAccountForm(), icon: const Icon(Icons.add)),
      ]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.accounts.length,
        itemBuilder: (context, i) {
          final a = DummyData.accounts[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(a.name),
              subtitle: Text('${a.type.name.toUpperCase()} • ${a.currency}'),
              trailing: Text('\$${a.currentBalance.toStringAsFixed(2)}'),
              onTap: () => _openAccountForm(existingIndex: i),
            ),
          );
        },
      ),
    );
  }
  Future<void> _openAccountForm({int? existingIndex}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final controller = TextEditingController(text: existingIndex == null ? '' : DummyData.accounts[existingIndex].name);
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Account Name'), controller: controller),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    setState(() {});
  }
}
