import 'package:flutter/material.dart';
import '../../../domain/models/finance_account.dart';

class AccountCard extends StatelessWidget {
  final FinanceAccount account;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? scheme.outlineVariant.withValues(alpha: 0.3)
              : scheme.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      account.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getAccountTypeLabel(account.type),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                _formatCurrency(account.currentBalance, account.currency),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: account.currentBalance < 0
                          ? scheme.error
                          : scheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAccountTypeLabel(FinanceAccountType type) {
    switch (type) {
      case FinanceAccountType.bank:
        return 'Bank';
      case FinanceAccountType.cash:
        return 'Cash';
      case FinanceAccountType.card:
        return 'Card';
      case FinanceAccountType.wallet:
        return 'Wallet';
    }
  }

  String _formatCurrency(double amount, String currency) {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol ${amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        )}';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'PKR':
        return 'PKR';
      case 'INR':
        return '₹';
      default:
        return currency;
    }
  }
}
