import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/reminder_model.dart';
import 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(const ReminderInitial());

  Future<void> getReminders() async {
    emit(const ReminderLoading());

    final result = await ApiService().getReminders({});

    result.fold(
      (l) => emit(ReminderError(l.message)),
      (r) {
        try {
          final raw = r.data as List<dynamic>;
          final reminders = raw
              .map(
                (json) => Reminder.fromApiJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
          emit(ReminderLoaded(reminders));
        } catch (e) {
          emit(ReminderError('Data parsing error: $e'));
        }
      },
    );
  }

  Future<bool> createReminder({
    required String title,
    String? description,
    required DateTime dueDate,
  }) async {
    final params = <String, Object>{
      'title': title,
      'description': description ?? '',
      'dueDate': dueDate.toUtc().toIso8601String(),
      'status': 'PENDING',
    };

    final result = await ApiService().createReminder(params);

    return result.fold(
      (l) {
        emit(ReminderError(l.message));
        return false;
      },
      (r) {
        try {
          final reminder =
              Reminder.fromApiJson(r.data as Map<String, dynamic>);
          final current = state is ReminderLoaded ? state.reminders : <Reminder>[];
          emit(ReminderLoaded([reminder, ...current]));
          return true;
        } catch (_) {
          getReminders();
          return true;
        }
      },
    );
  }

  Future<bool> updateReminder({
    required Reminder reminder,
    required String title,
    String? description,
    required DateTime dueDate,
    required String status,
  }) async {
    final params = <String, Object>{
      'title': title,
      'description': description ?? '',
      'dueDate': dueDate.toUtc().toIso8601String(),
      'status': status,
    };

    final result = await ApiService().updateReminder(reminder.id, params);

    return result.fold(
      (l) {
        emit(ReminderError(l.message));
        return false;
      },
      (r) {
        try {
          final updated =
              Reminder.fromApiJson(r.data as Map<String, dynamic>);
          final current = state is ReminderLoaded ? state.reminders : <Reminder>[];
          final list = current
              .map((x) => x.id == updated.id ? updated : x)
              .toList();
          emit(ReminderLoaded(list));
          return true;
        } catch (_) {
          getReminders();
          return true;
        }
      },
    );
  }

  Future<bool> updateReminderStatus(Reminder reminder, String status) async {
    return updateReminder(
      reminder: reminder,
      title: reminder.title,
      description: reminder.description,
      dueDate: reminder.dueDate,
      status: status,
    );
  }

  Future<bool> deleteReminder(String id) async {
    final result = await ApiService().deleteReminder(id);

    return result.fold(
      (l) {
        emit(ReminderError(l.message));
        return false;
      },
      (r) {
        final current = state is ReminderLoaded ? state.reminders : <Reminder>[];
        final list = current.where((x) => x.id != id).toList();
        emit(ReminderLoaded(list));
        return true;
      },
    );
  }
}
