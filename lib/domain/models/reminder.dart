enum ReminderStatus { pending, completed, skipped }
class Reminder {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final ReminderStatus status;
  final String userId;
  final String? organizationId;
  const Reminder({required this.id, required this.title, this.description, required this.dueDate, required this.status, required this.userId, this.organizationId});
}
