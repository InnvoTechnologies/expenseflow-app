import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../domain/models/transaction.dart';
class TransferFormPage extends StatefulWidget {
  const TransferFormPage({super.key});
  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}
class _TransferFormPageState extends State<TransferFormPage> {
  final formKey = GlobalKey<FormState>();
  String fromAccountId = DummyData.accounts.first.id;
  String toAccountId = DummyData.accounts[1].id;
  double amount = 0.0;
  DateTime date = DateTime.now();
  String description = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: fromAccountId,
              items: DummyData.accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
              onChanged: (v) => setState(() => fromAccountId = v!),
              decoration: const InputDecoration(labelText: 'From Account'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: toAccountId,
              items: DummyData.accounts.where((a) => a.id != fromAccountId).map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
              onChanged: (v) => setState(() => toAccountId = v!),
              decoration: const InputDecoration(labelText: 'To Account'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: amount == 0.0 ? '' : amount.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              onChanged: (v) => amount = double.tryParse(v) ?? 0.0,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (v) => description = v,
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2030));
                if (picked != null) setState(() => date = picked);
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final t = Transaction(id: 'tx${DateTime.now().millisecondsSinceEpoch}', amount: amount, type: TransactionType.transfer, date: date, description: description.isEmpty ? 'Transfer' : description, accountId: fromAccountId, toAccountId: toAccountId, categoryId: null, payeeId: null, status: 'POSTED');
                Navigator.of(context).pop(t);
              },
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
