import 'package:dio/dio.dart';

/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const AppException({required this.message, this.statusCode, this.errorData});

  @override
  String toString() => message;
}

/// Exception for server errors (5xx status codes)
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for client errors (4xx status codes)
class ClientException extends AppException {
  const ClientException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for network connectivity issues
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for request cancellation
class CancellationException extends AppException {
  const CancellationException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for request timeout
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for authentication errors (401, 403)
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for validation errors (400)
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for resource not found (404)
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Exception for unknown/unhandled errors
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Legacy exception - kept for backward compatibility
/// Represent exceptions from Server/Remote data source.
class RemoteException implements Exception {
  DioException dioError;

  RemoteException({required this.dioError});
}

/// Exception for local/cache storage issues
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
    super.errorData,
  });
}

/// Legacy exception - kept for backward compatibility
/// Represent exceptions from Cache.
class LocalException implements Exception {
  String error;

  LocalException(this.error);
}

/// Exception for routing issues
class RouteException implements Exception {
  final String message;
  RouteException(this.message);
}
