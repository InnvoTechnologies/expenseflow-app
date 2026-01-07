import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';
import '../../domain/models/transaction.dart';

class TransactionFormPage extends StatefulWidget {
  final Transaction? existing;
  const TransactionFormPage({super.key, this.existing});
  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final formKey = GlobalKey<FormState>();
  late TransactionType type;
  late String accountId;
  String? categoryId;
  String? payeeId;
  late DateTime date;
  late String description;
  late double amount;
  @override
  void initState() {
    super.initState();
    type = widget.existing?.type ?? TransactionType.expense;
    accountId = widget.existing?.accountId ?? DummyData.accounts.first.id;
    // categoryId =
    //     widget.existing?.categoryId ??
    //     DummyData.categories
    //         .firstWhere(
    //           (c) => c.type == CategoryType.expense && c.parentId != null,
    //         )
    //         .id;
    payeeId = widget.existing?.payeeId ?? DummyData.payees.first.id;
    date = widget.existing?.date ?? DateTime.now();
    description = widget.existing?.description ?? '';
    amount = widget.existing?.amount ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.existing == null ? 'New Transaction' : 'Edit Transaction',
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<TransactionType>(
              initialValue: type,
              items: TransactionType.values
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => type = v!),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: amount == 0.0 ? '' : amount.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              onChanged: (v) => amount = double.tryParse(v) ?? 0.0,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: accountId,
              items: DummyData.accounts
                  .map(
                    (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => accountId = v!),
            ),
            const SizedBox(height: 8),
            // DropdownButtonFormField<String>(
            //   initialValue: categoryId,
            //   items: DummyData.categories
            //       .where(
            //         (c) => type == TransactionType.income
            //             ? c.type == CategoryType.income
            //             : c.type == CategoryType.expense && c.parentId != null,
            //       )
            //       .map(
            //         (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
            //       )
            //       .toList(),
            //   onChanged: (v) => setState(() => categoryId = v),
            // ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: payeeId,
              items: DummyData.payees
                  .map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => payeeId = v),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (v) => description = v,
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => date = picked);
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final t = Transaction(
                  id:
                      widget.existing?.id ??
                      'tx${DateTime.now().millisecondsSinceEpoch}',
                  amount: amount,
                  type: type,
                  date: date,
                  description: description.isEmpty
                      ? (type == TransactionType.income ? 'Income' : 'Expense')
                      : description,
                  accountId: accountId,
                  toAccountId: null,
                  categoryId: categoryId,
                  payeeId: payeeId,
                  status: 'POSTED',
                );
                Navigator.of(context).pop(t);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
