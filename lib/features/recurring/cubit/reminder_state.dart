import '../model/reminder_model.dart';

abstract class ReminderState {
  final List<Reminder> reminders;

  const ReminderState({this.reminders = const []});
}

class ReminderInitial extends ReminderState {
  const ReminderInitial() : super(reminders: const []);
}

class ReminderLoading extends ReminderState {
  const ReminderLoading() : super();
}

class ReminderLoaded extends ReminderState {
  const ReminderLoaded(List<Reminder> reminders) : super(reminders: reminders);
}

class ReminderError extends ReminderState {
  final String message;

  const ReminderError(this.message);
}
