import 'package:expenseflow/core/network/api_service.dart';
import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart'
    show showLoadingSpinner;
import 'package:expenseflow/core/util/widgets/dialogs.dart';
import 'package:expenseflow/core/util/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/util/widgets/app_bar.dart';
import 'add_edit_transaction_page.dart';
import 'cubit/transactions_cubit.dart';
import 'cubit/transactions_state.dart';
import 'model/transaction_model.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int filter = 0;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Transactions',
        actions: [
          IconButton(
            onPressed: () async {
              final changed = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => const AddEditTransactionPage(),
                ),
              );
              if (changed == true && mounted) {
                context.read<TransactionsCubit>().fetchTransactions();
              }
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              final changed = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => const AddEditTransactionPage(),
                ),
              );
              if (changed == true && mounted) {
                context.read<TransactionsCubit>().fetchTransactions();
              }
            },
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state is TransactionsInitial) {
            context.read<TransactionsCubit>().fetchTransactions();
            return const Center(child: PageLoadingSpinner());
          }
          if (state is TransactionsLoading) {
            return const Center(child: PageLoadingSpinner());
          }
          if (state is TransactionsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is! TransactionsLoaded) {
            return const SizedBox.shrink();
          }

          final items = state.transactions.where((t) {
            if (filter == 0) return true;
            if (filter == 1) return t.type == 'INCOME';
            if (filter == 2) return t.type == 'EXPENSE';
            return t.type == 'TRANSFER';
          }).toList();

          final isEmpty = items.isEmpty;

          return ListView(
            padding: kDefaultPadding,
            children: [
              TabBarWidget(
                onChanged: (i) => setState(() => filter = i),
                items: const [
                  Tab(text: 'All'),
                  Tab(text: 'Income'),
                  Tab(text: 'Expense'),
                  Tab(text: 'Transfer'),
                ],
              ),
              const SizedBox(height: 8),
              if (isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...items.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TransactionCard(transaction: t),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isIncome = transaction.type == 'INCOME';
    final isExpense = transaction.type == 'EXPENSE';

    final amountPrefix = isIncome
        ? '+'
        : isExpense
        ? '-'
        : '';
    final amountColor = isIncome
        ? scheme.primary
        : isExpense
        ? scheme.error
        : scheme.onSurface;

    final title = (transaction.description.isNotEmpty)
        ? transaction.description
        : 'No description';

    final categoryName = transaction.category?.name;
    final accountName = transaction.account?.name;
    final payeeName = transaction.payee?.name;

    final metaParts = <String>[];
    if (categoryName != null && categoryName.isNotEmpty) {
      metaParts.add(categoryName);
    }
    if (accountName != null && accountName.isNotEmpty) {
      metaParts.add(accountName);
    }
    if (payeeName != null && payeeName.isNotEmpty) {
      metaParts.add(payeeName);
    }

    final dateLabel = formatShortDate(transaction.date);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isIncome
                        ? scheme.primary.withValues(alpha: 0.1)
                        : isExpense
                        ? scheme.error.withValues(alpha: 0.1)
                        : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isIncome
                        ? Icons.arrow_upward
                        : isExpense
                        ? Icons.arrow_downward
                        : Icons.swap_horiz,
                    size: 18,
                    color: amountColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${amountPrefix}USD ${transaction.amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\\d)(?=(\\d{3})+(?!\\d))'), (m) => '${m[1]},')}',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: amountColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        metaParts.join(' • '),
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              transaction.status.toUpperCase(),
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (transaction.subscription != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Sub',
                                style: textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const Spacer(),
                          Text(
                            dateLabel,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (transaction.tags.isNotEmpty)
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: transaction.tags.map((tag) {
                        final color = tag.color != null
                            ? convertColorStringToFlutterColor(tag.color!)
                            : scheme.primaryContainer;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            tag.name,
                            style: textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (transaction.tags.isEmpty) const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  onPressed: () {
                    Navigator.of(context)
                        .push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AddEditTransactionPage(
                              transaction: transaction,
                            ),
                          ),
                        )
                        .then((changed) {
                          if (changed == true && context.mounted) {
                            context
                                .read<TransactionsCubit>()
                                .fetchTransactions();
                          }
                        });
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDeleteDialog(
                        title: 'Delete Transaction',
                        message:
                            'Are you sure you want to delete this transaction?',
                      ),
                    );

                    if (confirmed != true) return;

                    showLoadingSpinner(context);
                    final result = await ApiService().deleteTransaction(
                      transaction.id,
                    );
                    Navigator.of(context).pop();
                    result.fold(
                      (failure) => showFailedSnackbar(failure.message),
                      (_) {
                        showSuccessSnackbar('Transaction deleted successfully');
                        if (context.mounted) {
                          context.read<TransactionsCubit>().fetchTransactions();
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_outline),
                  color: scheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
