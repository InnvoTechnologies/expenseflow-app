import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_service.dart';
import '../../../core/util/services/turnstile_service.dart';
import '../model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  static AuthState get _initialState => const AuthInitial('', true, null, null);

  AuthBloc() : super(_initialState) {
    /// Login
    on<Login>((event, emit) async {
      emit(
        LoggingIn(state.token, state.isFirstLaunch, state.userId, state.user),
      );
      String? token = await TurnstileService.token;
      log('Turnstile token: $token');
      if (token == null) {
        emit(
          LogInFailed(
            state.token,
            state.isFirstLaunch,
            state.userId,
            state.user,
            const Failure('Failed to obtain security token. Please try again.'),
          ),
        );
        return;
      }

      final result = await ApiService().login(
        {'email': event.email, 'password': event.password},
        headers: {'x-captcha-response': token},
      );

      if (result.isLeft()) {
        // Handle error case
        final failure = result.fold(
          (l) => l,
          (r) => throw Exception('Unexpected success'),
        );

        String message = 'Login failed';
        try {
          if (failure.message.isNotEmpty) {
            // Try to parse JSON response for better error message
            try {
              Map<String, dynamic> jsonResponse = jsonDecode(failure.message);
              message = jsonResponse['message'] ?? 'Login failed';
            } catch (_) {
              // If JSON parsing fails, use the raw message
              message = failure.message;
            }
          }
        } catch (e) {
          log('Error parsing failure message: $e');
          message = failure.message.isNotEmpty
              ? failure.message
              : 'Login failed. Please check your credentials.';
        }

        // Ensure message is not empty
        if (message.isEmpty) {
          message = 'Login failed. Please try again.';
        }

        emit(
          LogInFailed(
            state.token,
            state.isFirstLaunch,
            state.userId,
            state.user,
            Failure(message),
          ),
        );
      } else {
        // Handle success case
        final response = result.fold(
          (l) => throw Exception('Unexpected failure'),
          (r) => r,
        );
        log('AuthBloc: RIGHT');

        if (response.statusCode == 200) {
          final token = response.data['token'];
          final userId = response.data['user']['id'];
          final userModel = userModelFromJson(response.data['user']);

          // Set session cookie instead of storing token
          await ApiService().setSessionCookie(token);

          if (!emit.isDone) {
            emit(LoggedIn(token, false, userId, userModel));
          }
        } else {
          emit(
            LogInFailed(
              state.token,
              state.isFirstLaunch,
              state.userId,
              state.user,
              Failure(response.data['message'].toString()),
            ),
          );
        }
      }
    });

    on<UpdateUserEvent>((event, emit) {
      emit(
        LoggedIn(state.token, state.isFirstLaunch, state.userId, event.user),
      );
    });

    /// Logout
    on<Logout>((event, emit) async {
      emit(
        LoggingOut(state.token, state.isFirstLaunch, state.userId, state.user),
      );

      try {
        // Clear session cookies from network client
        await ApiService().clearSession();
        // Clear ALL persisted data from HydratedBloc storage
        // This removes:
        // - Auth token and user data
        // - Selected organization
        // - Lock/unlock status
        // - Theme preference (will reset to default light theme)
        await HydratedBloc.storage.clear();

        emit(const LoggedOut('', true, null, null));
      } catch (e) {
        log('Error during logout: $e');
        // Even if there's an error, still logout
        emit(const LoggedOut('', true, null, null));
      }
    });

    /// Forgot Password
    on<ForgotPassword>((event, emit) async {
      emit(
        LoggingIn(state.token, state.isFirstLaunch, state.userId, state.user),
      );

      final result = await ApiService().forgotPassword({'email': event.email});

      result.fold(
        (l) {
          log('Forgot Password API Error Response: ${l.message}');

          String errorMessage = 'Failed to send OTP';
          try {
            Map<String, dynamic> parsedJson = jsonDecode(l.message);
            errorMessage = parsedJson['message']?.toString() ?? errorMessage;
          } catch (e) {
            errorMessage = l.message.isNotEmpty ? l.message : errorMessage;
          }

          emit(
            ForgotFailure(
              state.token,
              state.isFirstLaunch,
              state.userId,
              state.user,
              Failure(errorMessage),
            ),
          );
        },
        (r) {
          log('Forgot Password API Success Response: ${r.data}');

          final responseData = r.data;
          final hasError = responseData['error'] == true;
          final statusCode = r.statusCode;
          final hasOtp = responseData.containsKey('otp');

          if (!hasError && (statusCode == 200 || statusCode == 201 || hasOtp)) {
            emit(ForgotSuccess(state.token, false, state.userId, state.user));
          } else {
            final errorMessage =
                responseData['message']?.toString() ?? 'Failed to send OTP';
            emit(
              ForgotFailure(
                state.token,
                state.isFirstLaunch,
                state.userId,
                state.user,
                Failure(errorMessage),
              ),
            );
          }
        },
      );
    });
    on<VerifyOtp>((event, emit) async {
      emit(
        LoggingIn(state.token, state.isFirstLaunch, state.userId, state.user),
      );

      final result = await ApiService().verifyOtp({
        'email': event.email,
        'type': 'forget-password',
        'otp': event.otp,
      });

      result.fold(
        (l) {
          log('Verify OTP API Error Response: ${l.message}');

          String errorMessage = 'OTP verification failed';
          try {
            Map<String, dynamic> parsedJson = jsonDecode(l.message);
            errorMessage = parsedJson['message']?.toString() ?? errorMessage;
          } catch (e) {
            errorMessage = l.message.isNotEmpty ? l.message : errorMessage;
          }

          emit(
            VerifyOtpFailure(
              state.token,
              state.isFirstLaunch,
              state.userId,
              state.user,
              Failure(errorMessage),
            ),
          );
        },
        (r) {
          log('Verify OTP API Success Response: ${r.data}');

          final responseData = r.data;
          final hasError = responseData['error'] == true;
          final statusCode = r.statusCode;

          if (!hasError && (statusCode == 200 || statusCode == 201)) {
            emit(
              VerifyOtpSuccess(state.token, false, state.userId, state.user),
            );
          } else {
            final errorMessage =
                responseData['message']?.toString() ??
                'OTP verification failed';
            emit(
              VerifyOtpFailure(
                state.token,
                state.isFirstLaunch,
                state.userId,
                state.user,
                Failure(errorMessage),
              ),
            );
          }
        },
      );
    });
    on<ResetForgotPassword>((event, emit) async {
      emit(
        LoggingIn(state.token, state.isFirstLaunch, state.userId, state.user),
      );

      final result = await ApiService().resetForgotPassword({
        'email': event.email,
        'otp': event.otp,
        'password': event.password,
      });

      result.fold(
        (l) {
          log('Reset Password API Error Response: ${l.message}');

          String errorMessage = 'Failed to reset password';
          try {
            Map<String, dynamic> parsedJson = jsonDecode(l.message);
            errorMessage = parsedJson['message']?.toString() ?? errorMessage;
          } catch (e) {
            errorMessage = l.message.isNotEmpty ? l.message : errorMessage;
          }

          emit(
            ResetForgotFailure(
              state.token,
              state.isFirstLaunch,
              state.userId,
              state.user,
              Failure(errorMessage),
            ),
          );
        },
        (r) async {
          log('Reset Password API Success Response: ${r.data}');

          final responseData = r.data;
          final hasError = responseData['error'] == true;
          final success = responseData['success'] == true;
          final statusCode = r.statusCode;

          if ((success || !hasError) &&
              (statusCode == 200 || statusCode == 201)) {
            log('Password reset successful, revoking all sessions...');

            final sessionResult = await ApiService().revokeAllSessions();

            sessionResult.fold(
              (failure) {
                log('Failed to revoke sessions: ${failure.message}');
              },
              (sessionResponse) {
                log('All sessions revoked successfully');
              },
            );

            emit(
              ResetForgotSuccess(state.token, false, state.userId, state.user),
            );
          } else {
            final errorMessage =
                responseData['message']?.toString() ??
                'Failed to reset password';
            emit(
              ResetForgotFailure(
                state.token,
                state.isFirstLaunch,
                state.userId,
                state.user,
                Failure(errorMessage),
              ),
            );
          }
        },
      );
    });
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['token'] != null && json['token'].toString().isNotEmpty) {
        final restoredState = LoggedIn(
          json['token'].toString(),
          json['isFirstLaunch'] != null ? json['isFirstLaunch'] as bool : true,
          json['userId'] as String?,
          UserModel.fromJson(json['user'] as Map<String, dynamic>),
        );

        return restoredState;
      }

      return LoggedOut(
        '',
        json['isFirstLaunch'] != null ? json['isFirstLaunch'] as bool : true,
        json['userId'] as String?,
        json['user'] != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, s) {
      log('Error restoring AuthState from JSON: $e', stackTrace: s);
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    // Only persist LoggedIn state, not LoggedOut or other states
    // This prevents re-saving data after logout clears storage
    if (state is! LoggedIn) {
      return null;
    }
    return {
      'token': state.token,
      'isFirstLaunch': state.isFirstLaunch,
      'userId': state.userId,
      'user': state.user?.toJson(),
    };
  }
}
