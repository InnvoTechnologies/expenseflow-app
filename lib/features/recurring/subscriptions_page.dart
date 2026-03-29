import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/custom_refresh_indicator.dart';
import 'package:expenseflow/core/util/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_edit_subscription_page.dart';
import 'cubit/subscription_cubit.dart';
import 'cubit/subscription_state.dart';
import 'model/subscription_model.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});
  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Subscriptions',
        actions: [
          IconButton(onPressed: () => _openForm(), icon: const Icon(Icons.add)),
        ],
      ),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionInitial || state is SubscriptionLoading) {
            context.read<SubscriptionCubit>().getSubscriptions();
            return const Center(child: PageLoadingSpinner());
          }

          if (state is SubscriptionError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state.subscriptions.isEmpty) {
            return const Center(child: Text('No subscriptions found.'));
          }

          final subs = state.subscriptions;

          return CustomRefreshIndicator(
            onRefresh: () =>
                context.read<SubscriptionCubit>().getSubscriptions(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kDefaultPadding,
              itemCount: subs.length,
              itemBuilder: (context, i) {
                final s = subs[i];
                final nextDate =
                    calculateNextBillingDate(s.startDate, s.billingCycle);
                final scheme = Theme.of(context).colorScheme;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: scheme.outlineVariant, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                s.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () =>
                                      _openForm(subscription: s),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                  ),
                                  onPressed: () => _confirmDelete(s),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '${s.currency} ${s.amount.toStringAsFixed(2)} / ${billingCycleLabel(s.billingCycle)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        if (nextDate != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Next: ${formatShortDate(nextDate)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        if (s.reminderEnabled) ...[
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Reminders On',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: scheme.primary),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openForm({Subscription? subscription}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddEditSubscriptionPage(subscription: subscription),
      ),
    );
  }

  Future<void> _confirmDelete(Subscription subscription) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Subscription',
        message: 'Are you sure you want to delete "${subscription.title}"?',
      ),
    );

    if (confirmed != true) return;

    showLoadingSpinner(context);
    final success = await context.read<SubscriptionCubit>().deleteSubscription(
      subscription.id,
    );
    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Subscription deleted successfully');
    } else {
      showFailedSnackbar('Failed to delete subscription');
    }
  }

}
