import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/profile_session_model.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit() : super(const SessionsInitial());

  Future<void> fetchSessions() async {
    emit(const SessionsLoading());

    final result = await ApiService().getUserSessions({});

    result.fold(
      (failure) => emit(SessionsError(failure.message)),
      (response) {
        final data = response.data['data'] as List<dynamic>;
        final sessions = data
            .map(
              (json) => ProfileSessionModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
        sessions.sort((a, b) {
          if (a.isCurrent && !b.isCurrent) return -1;
          if (!a.isCurrent && b.isCurrent) return 1;
          return b.lastActive.compareTo(a.lastActive);
        });
        emit(SessionsLoaded(sessions));
      },
    );
  }

  Future<void> revokeSession(String id) async {
    emit(const SessionsLoading());

    final result = await ApiService().revokeSession(id);

    result.fold(
      (failure) => emit(SessionsError(failure.message)),
      (_) => fetchSessions(),
    );
  }

  Future<void> revokeAll() async {
    emit(const SessionsLoading());

    final result = await ApiService().revokeAllSessions();

    result.fold(
      (failure) => emit(SessionsError(failure.message)),
      (_) => fetchSessions(),
    );
  }
}

