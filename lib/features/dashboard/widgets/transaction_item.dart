import 'package:flutter/material.dart';

import '../../../domain/models/transaction.dart';
import '../../payees/model/payee_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
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
    switch (transaction.type) {
      case TransactionType.income:
        return Icons.arrow_downward;
      case TransactionType.expense:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }

  Color _getIconColor(ColorScheme scheme) {
    switch (transaction.type) {
      case TransactionType.income:
        return scheme.primary.withValues(alpha: 0.1);
      case TransactionType.expense:
        return scheme.error.withValues(alpha: 0.1);
      case TransactionType.transfer:
        return scheme.secondary.withValues(alpha: 0.1);
    }
  }

  Color _getIconForegroundColor(ColorScheme scheme) {
    switch (transaction.type) {
      case TransactionType.income:
        return scheme.primary;
      case TransactionType.expense:
        return scheme.error;
      case TransactionType.transfer:
        return scheme.secondary;
    }
  }

  Color _getAmountColor(ColorScheme scheme) {
    switch (transaction.type) {
      case TransactionType.income:
        return scheme.primary;
      case TransactionType.expense:
        return scheme.error;
      case TransactionType.transfer:
        return scheme.onSurface;
    }
  }

  String _getSubtitle() {
    final parts = <String>[];

    // Format date
    final date = transaction.date;
    final formattedDate = '${_getMonthName(date.month)} ${date.day}';
    parts.add(formattedDate);

    // Add category or payee info
    // if (category != null) {
    //   parts.add(category!.name);
    // } else if (payee != null) {
    //   parts.add(payee!.name);
    // }

    return parts.join(' • ');
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatAmount() {
    final prefix = transaction.type == TransactionType.income
        ? ''
        : transaction.type == TransactionType.expense
        ? '-'
        : '';

    return '$prefix\$${transaction.amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }
}
