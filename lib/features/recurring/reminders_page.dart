import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/custom_refresh_indicator.dart';
import 'package:expenseflow/core/util/widgets/dialogs.dart';
import 'package:expenseflow/core/util/widgets/tab_bar.dart';
import 'package:expenseflow/features/recurring/add_edit_reminder_page.dart';
import 'package:expenseflow/features/recurring/cubit/reminder_cubit.dart';
import 'package:expenseflow/features/recurring/cubit/reminder_state.dart';
import 'package:expenseflow/features/recurring/model/reminder_model.dart';
import 'package:expenseflow/features/recurring/widgets/reminder_card.dart';
import 'package:expenseflow/features/recurring/widgets/reminder_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  int _filter = 0;

  List<Reminder> _filteredReminders(List<Reminder> reminders) {
    switch (_filter) {
      case 0:
        return reminders;
      case 1:
        return reminders.where((r) => r.status.toUpperCase() == 'PENDING').toList();
      case 2:
        return reminders.where((r) => r.status.toUpperCase() == 'COMPLETED').toList();
      case 3:
        return reminders.where((r) => r.status.toUpperCase() == 'SKIPPED').toList();
      default:
        return reminders;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ReminderCubit>().getReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Reminders',
        actions: [
          IconButton(
            onPressed: _addReminder,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<ReminderCubit, ReminderState>(
        builder: (context, state) {
          if (state is ReminderInitial || state is ReminderLoading) {
            return const Center(child: PageLoadingSpinner());
          }

          if (state is ReminderError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }

          final reminders =
              (state as ReminderLoaded).reminders;
          final filtered = _filteredReminders(reminders);

          return CustomRefreshIndicator(
            onRefresh: () => context.read<ReminderCubit>().getReminders(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBarWidget(
                    selectedIndex: _filter,
                    onChanged: (s) => setState(() => _filter = s),
                    items: const [
                      Tab(text: 'All'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Skipped'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    ReminderEmptyState(onAddReminder: _addReminder)
                  else
                    ...filtered.map<Widget>(
                      (Reminder r) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReminderCard(
                          reminder: r,
                          onComplete: () => _markComplete(r),
                          onSkip: () => _markSkipped(r),
                          onEdit: () => _editReminder(r),
                          onDelete: () => _deleteReminder(r),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _addReminder() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AddEditReminderPage(),
      ),
    );
  }

  Future<void> _markComplete(Reminder r) async {
    showLoadingSpinner(context);
    final success =
        await context.read<ReminderCubit>().updateReminderStatus(r, 'COMPLETED');
    Navigator.of(context).pop();
    if (success) {
      showSuccessSnackbar('Reminder marked as complete');
    } else {
      showFailedSnackbar('Failed to update reminder');
    }
  }

  Future<void> _markSkipped(Reminder r) async {
    showLoadingSpinner(context);
    final success =
        await context.read<ReminderCubit>().updateReminderStatus(r, 'SKIPPED');
    Navigator.of(context).pop();
    if (success) {
      showSuccessSnackbar('Reminder skipped');
    } else {
      showFailedSnackbar('Failed to update reminder');
    }
  }

  void _editReminder(Reminder r) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddEditReminderPage(reminder: r),
      ),
    );
  }

  Future<void> _deleteReminder(Reminder r) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Reminder',
        message: 'Are you sure you want to delete "${r.title}"?',
      ),
    );

    if (confirmed != true) return;

    showLoadingSpinner(context);
    final success = await context.read<ReminderCubit>().deleteReminder(r.id);
    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Reminder deleted successfully');
    } else {
      showFailedSnackbar('Failed to delete reminder');
    }
  }
}
