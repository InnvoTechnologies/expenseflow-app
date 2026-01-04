import 'exceptions.dart';
import 'failures.dart';

/// Maps exceptions to failures with user-friendly messages
class ExceptionToFailureMapper {
  /// Converts any exception to a Failure
  static Failure mapExceptionToFailure(Exception exception) {
    // Handle custom app exceptions
    if (exception is AppException) {
      return _mapAppExceptionToFailure(exception);
    }

    // Handle legacy RemoteException
    if (exception is RemoteException) {
      // This should not happen anymore with the new system,
      // but kept for backward compatibility
      return RemoteFailure(
        errorCode: exception.dioError.response?.statusCode,
        message: exception.dioError.message ?? 'An error occurred',
        errorType: exception.dioError.type,
      );
    }

    // Handle legacy LocalException
    if (exception is LocalException) {
      return LocalFailure(message: exception.error, error: 0);
    }

    // Handle other exceptions
    return UnknownFailure(exception.toString(), statusCode: null);
  }

  /// Maps AppException to specific Failure types
  static Failure _mapAppExceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is ClientException) {
      return ClientFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is NetworkException) {
      return NetworkFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is CancellationException) {
      return CancellationFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is TimeoutException) {
      return TimeoutFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is AuthenticationException) {
      return AuthenticationFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is NotFoundException) {
      return NotFoundFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is CacheException) {
      return CacheFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    if (exception is UnknownException) {
      return UnknownFailure(
        exception.message,
        statusCode: exception.statusCode,
        errorData: exception.errorData,
      );
    }

    // Fallback for any other AppException
    return UnknownFailure(
      exception.message,
      statusCode: exception.statusCode,
      errorData: exception.errorData,
    );
  }
}
