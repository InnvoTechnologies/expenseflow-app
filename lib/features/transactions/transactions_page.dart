import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';
import '../../core/util/widgets/app_bar.dart';
import '../../domain/models/transaction.dart';
import 'transaction_form_page.dart';
import 'transfer_form_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int filter = 0;
  List<Transaction> items = List.from(DummyData.transactions);
  @override
  Widget build(BuildContext context) {
    final filtered = items.where((t) {
      if (filter == 0) return true;
      if (filter == 1) return t.type == TransactionType.income;
      if (filter == 2) return t.type == TransactionType.expense;
      return t.type == TransactionType.transfer;
    }).toList();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Transactions',
        actions: [
          IconButton(
            onPressed: () async {
              final created = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TransactionFormPage()),
              );
              if (created is Transaction)
                setState(() => items.insert(0, created));
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              final created = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TransferFormPage()),
              );
              if (created is Transaction)
                setState(() => items.insert(0, created));
            },
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: ListView(
        padding: kDefaultPadding,
        children: [
          TabBarWidget(
            onChanged: (i) => setState(() => filter = i),
            items: [
              Tab(text: 'All'),
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
              Tab(text: 'Transfer'),
            ],
          ),
          const SizedBox(height: 8),
          ...filtered.map(
            (t) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    t.type == TransactionType.income
                        ? Icons.arrow_downward
                        : t.type == TransactionType.expense
                        ? Icons.arrow_upward
                        : Icons.swap_horiz,
                  ),
                ),
                title: Text(t.description),
                subtitle: Text(
                  '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')} • ${t.status}',
                ),
                trailing: Text(
                  currency(t.amount),
                  style: TextStyle(
                    color: t.type == TransactionType.income
                        ? Colors.green
                        : t.type == TransactionType.expense
                        ? Colors.red
                        : null,
                  ),
                ),
                onTap: () async {
                  final updated = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TransactionFormPage(existing: t),
                    ),
                  );
                  if (updated is Transaction) {
                    final idx = items.indexWhere((x) => x.id == t.id);
                    setState(() => items[idx] = updated);
                  }
                },
                onLongPress: () {
                  setState(() => items.removeWhere((x) => x.id == t.id));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String currency(double v) {
    return '\$${v.toStringAsFixed(2)}';
  }
}
