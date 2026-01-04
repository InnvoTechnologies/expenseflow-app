import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';
import '../../domain/models/reminder.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});
  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  int filter = 0;
  @override
  Widget build(BuildContext context) {
    final items = DummyData.reminders.where((r) {
      if (filter == 0) return true;
      if (filter == 1) return r.status == ReminderStatus.pending;
      if (filter == 2) return r.status == ReminderStatus.completed;
      return r.status == ReminderStatus.skipped;
    }).toList();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Reminders',
        actions: [
          IconButton(onPressed: _addReminder, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TabBarWidget(
            onChanged: (s) => setState(() => filter = s),
            items: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
              Tab(text: 'Skipped'),
            ],
          ),

          const SizedBox(height: 8),
          ...items.map(
            (r) => Card(
              child: ListTile(
                leading: const Icon(Icons.alarm),
                title: Text(r.title),
                subtitle: Text(
                  '${r.status.name.toUpperCase()} • ${r.dueDate.year}-${r.dueDate.month.toString().padLeft(2, '0')}-${r.dueDate.day.toString().padLeft(2, '0')}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) => setState(() {
                    final idx = DummyData.reminders.indexWhere(
                      (x) => x.id == r.id,
                    );
                    if (v == 'complete')
                      DummyData.reminders[idx] = Reminder(
                        id: r.id,
                        title: r.title,
                        description: r.description,
                        dueDate: r.dueDate,
                        status: ReminderStatus.completed,
                        userId: r.userId,
                      );
                    if (v == 'skip')
                      DummyData.reminders[idx] = Reminder(
                        id: r.id,
                        title: r.title,
                        description: r.description,
                        dueDate: r.dueDate,
                        status: ReminderStatus.skipped,
                        userId: r.userId,
                      );
                  }),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'complete',
                      child: Text('Mark Completed'),
                    ),
                    PopupMenuItem(value: 'skip', child: Text('Mark Skipped')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addReminder() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Reminder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    setState(() {});
  }
}
