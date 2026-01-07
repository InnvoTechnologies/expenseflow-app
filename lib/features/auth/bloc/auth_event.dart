part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {
  final String email;
  final String password;

  const Login(this.email, this.password);
}

class Logout extends AuthEvent {
  const Logout();
}

class ResetError extends AuthEvent {
  const ResetError();
}

class ForgotPassword extends AuthEvent {
  final String email;

  const ForgotPassword(this.email);
}

class VerifyOtp extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtp(this.email, this.otp);
}

class UpdateUserEvent extends AuthEvent {
  final UserModel user;
  const UpdateUserEvent(this.user);
}

class ResetForgotPassword extends AuthEvent {
  final String email;
  final String otp;
  final String password;
  final String confirmPassword;

  const ResetForgotPassword(
    this.email,
    this.otp,
    this.password,
    this.confirmPassword,
  );
}
