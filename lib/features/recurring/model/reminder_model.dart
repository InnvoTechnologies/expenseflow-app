import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String title,
    String? description,
    required DateTime dueDate,
    required String status,
    required String userId,
    String? organizationId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  factory Reminder.fromApiJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      title: (json['title'] ?? '').toString(),
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: (json['status'] ?? 'PENDING').toString(),
      userId: (json['userId'] ?? '').toString(),
      organizationId: json['organizationId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

extension ReminderX on Reminder {
  bool get isOverdue =>
      status.toUpperCase() == 'PENDING' && dueDate.isBefore(DateTime.now());
}
