import 'package:flutter/material.dart';
import '../../../domain/models/payee.dart';

class PayeeItem extends StatelessWidget {
  final Payee payee;
  final double totalAmount;
  final VoidCallback? onTap;

  const PayeeItem({
    super.key,
    required this.payee,
    required this.totalAmount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Text(
          _getInitials(payee.name),
          style: TextStyle(
            color: scheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(
        payee.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: payee.description != null
          ? Text(
              payee.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Text(
        _formatAmount(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.error,
            ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }

  String _formatAmount() {
    return 'PKR ${totalAmount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        )}';
  }
}
