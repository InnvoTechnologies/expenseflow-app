import '../model/profile_session_model.dart';

abstract class SessionsState {
  const SessionsState();
}

class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

class SessionsLoading extends SessionsState {
  const SessionsLoading();
}

class SessionsLoaded extends SessionsState {
  final List<ProfileSessionModel> sessions;

  const SessionsLoaded(this.sessions);
}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);
}

