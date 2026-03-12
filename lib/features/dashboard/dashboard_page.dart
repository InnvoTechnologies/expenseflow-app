import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/features/accounts/accounts_page.dart';
import 'package:expenseflow/features/categories/view/categories_page.dart';
import 'package:expenseflow/features/payees/payees_page.dart';
import 'package:expenseflow/features/recurring/subscriptions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/finance_account.dart';
import '../../domain/models/transaction.dart' as domain;
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'model/dashboard_model.dart';
import 'widgets/account_card.dart';
import 'widgets/category_empty_state.dart';
import 'widgets/month_selector.dart';
import 'widgets/top_payee_tile.dart';
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

    return Scaffold(
      appBar: AppBarWidget(title: 'Dashboard'),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial) {
            context.read<DashboardCubit>().loadForMonth(selectedDate);
            return const Center(child: PageLoadingSpinner());
          }
          if (state is DashboardLoading) {
            return const Center(child: PageLoadingSpinner());
          }
          if (state is DashboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          final data = state is DashboardLoaded ? state.data : null;
          final totalBalance = data?.totalBalance ?? 0.0;
          final income = data?.monthlyIncome ?? 0.0;
          final expense = data?.monthlyExpense ?? 0.0;

          return SingleChildScrollView(
            padding: kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                DashboardMonthSelector(
                  selectedDate: selectedDate,
                  onChanged: (newDate) {
                    setState(() => selectedDate = newDate);
                    context.read<DashboardCubit>().loadForMonth(newDate);
                  },
                ),
                const SizedBox(height: 16),

                // Header Section
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context: context,
                          label: 'Total Balance',
                          value: _formatCurrency(totalBalance),
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
                          value: _formatCurrency(income),
                          subtext:
                              '${getMonthName(selectedDate.month)} ${selectedDate.year}',
                          icon: Icons.trending_up,
                          color: scheme.primary,
                        ),
                      ),
                      Expanded(
                        child: _buildStatCard(
                          context: context,
                          label: 'Expense',
                          value: _formatCurrency(expense),
                          subtext:
                              '${getMonthName(selectedDate.month)} ${selectedDate.year}',
                          icon: Icons.trending_down,
                          color: scheme.error,
                          // isFullWidth: true,
                        ),
                      ),
                    ],
                  ),
                ),
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
                          MaterialPageRoute(
                            builder: (context) => AccountsPage(),
                          ),
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
                    itemCount: (data?.accounts.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      final accounts = data?.accounts ?? [];
                      if (index == accounts.length) {
                        return _buildAddAccountCard(context);
                      }
                      final account = accounts[index];
                      return SizedBox(
                        width: 200,
                        child: AccountCard(
                          account: FinanceAccount(
                            id: account.id,
                            name: account.name,
                            type: FinanceAccountType.bank,
                            currency: 'USD',
                            currentBalance: account.currentBalance,
                            userId: '',
                          ),
                          onTap: () {
                            // Navigate to account details
                          },
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Income by Category',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryCard(
                      context: context,
                      entries: data?.incomeByCategory ?? const [],
                      valueColor: scheme.primary,
                      action: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CategoriesPage(),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Expenses by Category',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryCard(
                      context: context,
                      entries: data?.expensesByCategory ?? const [],
                      valueColor: scheme.error,
                      action: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CategoriesPage(),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ),
                  ],
                ),

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

                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: scheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: Column(
                      children: (data?.recentTransactions.isEmpty ?? true)
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            : data!.recentTransactions.map((t) {
                                final date = t.date ?? DateTime.now();
                                final type = t.type == 'INCOME'
                                    ? domain.TransactionType.income
                                    : t.type == 'EXPENSE'
                                        ? domain.TransactionType.expense
                                        : domain.TransactionType.transfer;

                                final transaction = domain.Transaction(
                                  id: t.id,
                                  amount: t.amount,
                                  type: type,
                                  date: date,
                                  description: t.description.isEmpty
                                      ? 'Transaction'
                                      : t.description,
                                  accountId: '',
                                  toAccountId: null,
                                  categoryId: null,
                                  payeeId: null,
                                  status: '',
                                );

                                return TransactionItem(
                                  transaction: transaction,
                                  payee: null,
                                  onTap: () {
                                    // Navigate to transaction details
                                  },
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                ),
                if ((data?.topTags.isNotEmpty ?? false))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Tags',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                if ((data?.topTags.isNotEmpty ?? false))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: scheme.outlineVariant, width: 1),
                    ),
                    child: Column(
                      children: data!.topTags.map((entry) {
                        final color = entry.color != null
                            ? convertColorStringToFlutterColor(entry.color!)
                            : scheme.primaryContainer;
                        return _BreakdownTile(
                          label: entry.name,
                          amount: entry.amount,
                          color: color,
                          valueColor: scheme.error,
                        );
                      }).toList(),
                    ),
                  ),

                // Top Payees Section
                if ((data?.topPayees.isNotEmpty ?? false))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Payees',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PayeesPage(),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),

                if ((data?.topPayees.isNotEmpty ?? false))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: scheme.outlineVariant, width: 1),
                    ),
                    child: Column(
                      children: data!.topPayees.take(3).map((entry) {
                        return TopPayeeTile(
                          name: entry.name,
                          amount: entry.amount,
                          accentColor: scheme.primary,
                          onTap: () {
                            // Navigate to payee details
                          },
                        );
                      }).toList(),
                    ),
                  ),
                if ((data?.topSubscriptions.isNotEmpty ?? false))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Subscriptions',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SubscriptionsPage(),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                if ((data?.topSubscriptions.isNotEmpty ?? false))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: scheme.outlineVariant, width: 1),
                    ),
                    child: Column(
                      children: data!.topSubscriptions.take(5).map((s) {
                        return _BreakdownTile(
                          label: s.name,
                          amount: s.amount,
                          color: scheme.primaryContainer,
                          valueColor: scheme.error,
                        );
                      }).toList(),
                    ),
                  ),

                // Bottom padding
                SizedBox(height: 24),
              ],
            ),
          );
        },
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => AccountsPage()));
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

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _formatCurrency(double amount) {
    return 'AUD\n${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required List<DashboardNamedAmount> entries,
    required Color valueColor,
    Widget? action,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final total = entries.fold<double>(0, (p, e) => p + e.amount);
    final isEmpty = entries.isEmpty || total == 0;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (action != null)
              Align(alignment: Alignment.topRight, child: action),
            if (isEmpty)
              DashboardCategoryEmptyState(
                message: valueColor == scheme.primary
                    ? 'No income data available'
                    : 'No expense data available',
              )
            else
              ...entries.take(5).map((e) {
                final color = e.color != null
                    ? convertColorStringToFlutterColor(e.color!)
                    : scheme.primaryContainer;
                final pct = total == 0 ? 0.0 : e.amount / total;
                return _BreakdownTile(
                  label: e.name,
                  amount: e.amount,
                  color: color,
                  valueColor: valueColor,
                  percent: pct,
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final Color valueColor;
  final double? percent;
  const _BreakdownTile({
    required this.label,
    required this.amount,
    required this.color,
    required this.valueColor,
    this.percent,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(backgroundColor: color, radius: 14),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (percent != null) ...[
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: percent!,
              minHeight: 6,
              color: valueColor,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ],
        ],
      ),
      trailing: Text(
        'AUD ${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\\d)(?=(\\d{3})+(?!\\d))'), (match) => '${match[1]},')}',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: valueColor,
        ),
      ),
    );
  }
}
