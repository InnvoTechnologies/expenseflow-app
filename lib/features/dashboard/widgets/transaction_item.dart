import 'package:flutter/material.dart';

import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/features/transactions/model/transaction_model.dart';
import '../../payees/model/payee_model.dart';
import '../model/dashboard_model.dart';

class TransactionItem extends StatelessWidget {
  final DashboardTransaction transaction;
  // final Category? category;
  final Payee? payee;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    // this.category,
    this.payee,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getIconColor(scheme),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getTransactionIcon(),
          color: _getIconForegroundColor(scheme),
          size: 20,
        ),
      ),
      title: Text(
        transaction.description,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _getSubtitle(),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      trailing: Text(
        _formatAmount(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: _getAmountColor(scheme),
        ),
      ),
    );
  }

  IconData _getTransactionIcon() {
    switch (ApiTransactionTypeX.fromApi(transaction.type)) {
      case ApiTransactionType.income:
        return Icons.arrow_downward;
      case ApiTransactionType.expense:
        return Icons.arrow_upward;
      case ApiTransactionType.transfer:
        return Icons.swap_horiz;
      case ApiTransactionType.unknown:
        return Icons.receipt_long_outlined;
    }
  }

  Color _getIconColor(ColorScheme scheme) {
    switch (ApiTransactionTypeX.fromApi(transaction.type)) {
      case ApiTransactionType.income:
        return scheme.primary.withValues(alpha: 0.1);
      case ApiTransactionType.expense:
        return scheme.error.withValues(alpha: 0.1);
      case ApiTransactionType.transfer:
        return scheme.secondary.withValues(alpha: 0.1);
      case ApiTransactionType.unknown:
        return scheme.surfaceContainerHighest;
    }
  }

  Color _getIconForegroundColor(ColorScheme scheme) {
    switch (ApiTransactionTypeX.fromApi(transaction.type)) {
      case ApiTransactionType.income:
        return scheme.primary;
      case ApiTransactionType.expense:
        return scheme.error;
      case ApiTransactionType.transfer:
        return scheme.secondary;
      case ApiTransactionType.unknown:
        return scheme.onSurfaceVariant;
    }
  }

  Color _getAmountColor(ColorScheme scheme) {
    switch (ApiTransactionTypeX.fromApi(transaction.type)) {
      case ApiTransactionType.income:
        return scheme.primary;
      case ApiTransactionType.expense:
        return scheme.error;
      case ApiTransactionType.transfer:
        return scheme.onSurface;
      case ApiTransactionType.unknown:
        return scheme.onSurface;
    }
  }

  String _getSubtitle() {
    final parts = <String>[];

    // Format date
    final date = transaction.date;
    if (date != null) {
      final formattedDate = formatMonthDay(date);
      parts.add(formattedDate);
    }

    // Add category or payee info
    // if (category != null) {
    //   parts.add(category!.name);
    // } else if (payee != null) {
    //   parts.add(payee!.name);
    // }

    return parts.join(' • ');
  }

  String _formatAmount() {
    final prefix =
        ApiTransactionTypeX.fromApi(transaction.type) ==
            ApiTransactionType.expense
        ? '-'
        : '';

    return formatSignedCurrency(
      transaction.amount,
      isNegative: prefix == '-',
      currency: 'USD',
    );
  }
}
