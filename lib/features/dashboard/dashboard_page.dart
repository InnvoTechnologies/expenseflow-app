import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/features/accounts/accounts_page.dart';
import 'package:expenseflow/features/payees/payees_page.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';
import '../../domain/models/transaction.dart';
import 'widgets/account_card.dart';
import 'widgets/payee_item.dart';
import 'widgets/transaction_item.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final totals = DummyData.monthlyTotals(selectedDate);
    final recentTransactions = DummyData.transactions
        .where(
          (t) =>
              t.date.year == selectedDate.year &&
              t.date.month == selectedDate.month,
        )
        .take(5)
        .toList();

    // Calculate top payees
    final payeeAmounts = <String, double>{};
    for (final transaction in DummyData.transactions.where(
      (t) =>
          t.type == TransactionType.expense &&
          t.payeeId != null &&
          t.date.year == selectedDate.year &&
          t.date.month == selectedDate.month,
    )) {
      payeeAmounts[transaction.payeeId!] =
          (payeeAmounts[transaction.payeeId!] ?? 0) + transaction.amount;
    }
    final topPayees = payeeAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Dashboard',
        // actions: [_buildMonthSelector()],
      ),
      body: SingleChildScrollView(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),

            // Financial Overview Cards
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      label: 'Total Balance',
                      value: _formatCurrency(totals['balance']!),
                      subtext: 'Across all accounts',
                      icon: Icons.account_balance_wallet_outlined,
                      color: scheme.primary,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      label: 'Income',
                      value: _formatCurrency(totals['income']!),
                      subtext:
                          '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                      icon: Icons.trending_up,
                      color: scheme.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      label: 'Expense',
                      value: _formatCurrency(totals['expense']!),
                      subtext:
                          '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                      icon: Icons.trending_down,
                      color: scheme.error,
                      // isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
            // Accounts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Accounts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AccountsPage()),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),

            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                itemCount: DummyData.accounts.length + 1,
                itemBuilder: (context, index) {
                  if (index == DummyData.accounts.length) {
                    return _buildAddAccountCard(context);
                  }
                  return SizedBox(
                    width: 200,
                    child: AccountCard(
                      account: DummyData.accounts[index],
                      onTap: () {
                        // Navigate to account details
                      },
                    ),
                  );
                },
              ),
            ),

            // Recent Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to add transaction
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add Transaction',
                ),
              ],
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: scheme.outlineVariant, width: 1),
              ),
              child: Column(
                children: recentTransactions.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions this month',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : recentTransactions.map((transaction) {
                        // final category = DummyData.categories.firstWhere(
                        //   (c) => c.id == transaction.categoryId,
                        //   orElse: () => DummyData.categories.first,
                        // );
                        final payee = transaction.payeeId != null
                            ? DummyData.payees.firstWhere(
                                (p) => p.id == transaction.payeeId,
                                orElse: () => DummyData.payees.first,
                              )
                            : null;

                        return TransactionItem(
                          transaction: transaction,
                          // category: category,
                          payee: payee,
                          onTap: () {
                            // Navigate to transaction details
                          },
                        );
                      }).toList(),
              ),
            ),

            // Top Payees Section
            if (topPayees.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Payees',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PayeesPage()),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),

            if (topPayees.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: scheme.outlineVariant, width: 1),
                ),
                child: Column(
                  children: topPayees.take(3).map((entry) {
                    final payee = DummyData.payees.firstWhere(
                      (p) => p.id == entry.key,
                      orElse: () => DummyData.payees.first,
                    );

                    return PayeeItem(
                      payee: payee,
                      totalAmount: entry.value,
                      onTap: () {
                        // Navigate to payee details
                      },
                    );
                  }).toList(),
                ),
              ),

            // Bottom padding
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month - 1,
                  1,
                );
              });
            },
            iconSize: 20,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          Text(
            _getMonthYearString(selectedDate),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month + 1,
                  1,
                );
              });
            },
            iconSize: 20,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(icon, size: 20, color: scheme.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.arrow_downward, size: 12, color: scheme.primary),
                const SizedBox(width: 4),
                Text(
                  subtext,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAccountCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 200,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to add account
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 32, color: scheme.primary),
              const SizedBox(height: 8),
              Text(
                'Add Account',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final name = DummyData.user.name;

    if (hour < 12) {
      return 'Good Morning, \n$name';
    } else if (hour < 17) {
      return 'Good Afternoon, $name';
    } else {
      return 'Good Evening, $name';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getMonthYearString(DateTime date) {
    return '${_getMonthName(date.month)} ${date.year}';
  }

  String _formatCurrency(double amount) {
    return 'AUD\n${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }
}
