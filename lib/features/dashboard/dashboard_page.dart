import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../domain/models/transaction.dart';
import '../../core/widgets/common.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month, 1);
  @override
  Widget build(BuildContext context) {
    final totals = DummyData.monthlyTotals(month);
    return Scaffold(
      appBar: AppBarWidget(title:  'Dashboard'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [Expanded(child: Text(greeting(), style: Theme.of(context).textTheme.titleLarge)), monthSelector()]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: StatCard(label: 'Total Balance', value: currency(totals['balance']!), icon: Icons.account_balance_wallet)), Expanded(child: StatCard(label: 'Income', value: currency(totals['income']!), icon: Icons.arrow_downward, color: Colors.green.shade200))]),
          Row(children: [Expanded(child: StatCard(label: 'Expenses', value: currency(totals['expense']!), icon: Icons.arrow_upward, color: Colors.red.shade200))]),
          const SectionTitle('Recent Transactions'),
          ...DummyData.transactions.take(8).map((t) => ListTile(
                leading: CircleAvatar(child: Icon(t.type == TransactionType.income ? Icons.add : t.type == TransactionType.expense ? Icons.remove : Icons.swap_horiz)),
                title: Text(t.description),
                subtitle: Text('${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}'),
                trailing: Text(currency(t.amount), style: TextStyle(color: t.type == TransactionType.income ? Colors.green : t.type == TransactionType.expense ? Colors.red : null)),
              )),
        ],
      ),
    );
  }
  String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning, ${DummyData.user.name}';
    if (h < 18) return 'Good afternoon, ${DummyData.user.name}';
    return 'Good evening, ${DummyData.user.name}';
  }
  Widget monthSelector() {
    return DropdownButton<DateTime>(
      value: month,
      items: List.generate(12, (i) {
        final m = DateTime(DateTime.now().year, DateTime.now().month - i, 1);
        return DropdownMenuItem(value: m, child: Text('${m.year}-${m.month.toString().padLeft(2, '0')}'));
      }),
      onChanged: (v) {
        if (v != null) setState(() => month = v);
      },
    );
  }
  String currency(double v) {
    return '\$${v.toStringAsFixed(2)}';
  }
}
