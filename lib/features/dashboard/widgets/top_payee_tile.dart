import 'package:expenseflow/core/util/extensions.dart';
import 'package:flutter/material.dart';

class TopPayeeTile extends StatelessWidget {
  final String name;
  final double amount;
  final Color accentColor;
  final VoidCallback? onTap;

  const TopPayeeTile({
    super.key,
    required this.name,
    required this.amount,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: accentColor.withValues(alpha: 0.1),
        child: Icon(
          Icons.person_outline,
          size: 18,
          color: accentColor,
        ),
      ),
      title: Text(name),
      trailing: Text(
        formatAudAmount(amount),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
      ),
      onTap: onTap,
    );
  }
}

