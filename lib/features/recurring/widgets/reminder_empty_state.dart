import 'package:flutter/material.dart';

class ReminderEmptyState extends StatelessWidget {
  final VoidCallback? onAddReminder;

  const ReminderEmptyState({
    super.key,
    this.onAddReminder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            size: 64,
            color: scheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 24),
          Text(
            'No reminders yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Set up reminders for bills, budgets, and other important dates',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAddReminder,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Add Reminder'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: scheme.surface,
              foregroundColor: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
