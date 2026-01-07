part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final String token;
  final String? userId;
  final bool isFirstLaunch;
  final UserModel? user;

  const AuthState(this.token, this.isFirstLaunch, this.userId, this.user);

  @override
  List<Object?> get props => [token, isFirstLaunch, userId, user];
}

abstract class AuthLoading extends AuthState {
  const AuthLoading(super.token, super.isFirstLaunch, super.userId, super.user);
}

class AuthFailure extends AuthState {
  final Failure failure;

  const AuthFailure(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
    this.failure,
  );

  @override
  List<Object?> get props => [token, isFirstLaunch, userId, user, failure];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.token, super.isFirstLaunch, super.userId, super.user);

  @override
  List<Object?> get props => [token, isFirstLaunch, userId, user];
}

class LoggingIn extends AuthLoading {
  const LoggingIn(super.token, super.isFirstLaunch, super.userId, super.user);
}

class LoggedIn extends AuthState {
  const LoggedIn(super.token, super.isFirstLaunch, super.userId, super.user);

  @override
  List<Object?> get props => [token, isFirstLaunch, userId, user];
}

class LogInFailed extends AuthState {
  final Failure failure;

  const LogInFailed(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
    this.failure,
  );

  @override
  List<Object?> get props => [token, isFirstLaunch, userId, user, failure];
}

class LoggingOut extends AuthState {
  const LoggingOut(super.token, super.isFirstLaunch, super.userId, super.user);
}

class LoggedOut extends AuthLoading {
  const LoggedOut(super.token, super.isFirstLaunch, super.userId, super.user);
}

class ForgotFailure extends AuthState {
  final Failure failure;

  const ForgotFailure(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
    this.failure,
  );

  @override
  List<Object?> get props => [...super.props, failure];
}

class ForgotSuccess extends AuthState {
  const ForgotSuccess(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
  );
}

class VerifyOtpSuccess extends AuthState {
  const VerifyOtpSuccess(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
  );
}

class VerifyOtpFailure extends AuthState {
  final Failure failure;

  const VerifyOtpFailure(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
    this.failure,
  );

  @override
  List<Object?> get props => [...super.props, failure];
}

class ResetForgotSuccess extends AuthState {
  const ResetForgotSuccess(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
  );
}

class ResetForgotFailure extends AuthState {
  final Failure failure;

  const ResetForgotFailure(
    super.token,
    super.isFirstLaunch,
    super.userId,
    super.user,
    this.failure,
  );

  @override
  List<Object?> get props => [token, isFirstLaunch, userId, user, failure];
}
