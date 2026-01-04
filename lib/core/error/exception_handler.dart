import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'exceptions.dart';

/// Handles DioException and converts it to appropriate custom exceptions
class ExceptionHandler {
  /// Converts DioException to custom AppException
  static AppException handleDioException(DioException dioException) {
    log(
      'ExceptionHandler: Handling DioException - Type: ${dioException.type}, Message: ${dioException.message}',
    );

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: _getTimeoutMessage(dioException.type),
          statusCode: null,
          errorData: dioException.response?.data,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(dioException);

      case DioExceptionType.cancel:
        return const CancellationException(
          message: 'Request was cancelled',
          statusCode: null,
        );

      case DioExceptionType.connectionError:
        return _handleConnectionError(dioException);

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message:
              'Security certificate verification failed. Please check your connection.',
          statusCode: null,
        );

      case DioExceptionType.unknown:
        return _handleUnknownError(dioException);
    }
  }

  /// Handles bad response (status code errors)
  static AppException _handleBadResponse(DioException dioException) {
    final statusCode = dioException.response?.statusCode;
    final errorMessage = _extractErrorMessage(dioException.response?.data);

    log(
      'ExceptionHandler: Bad Response - Status Code: $statusCode, Error: $errorMessage',
    );

    // Handle specific status codes
    if (statusCode != null) {
      // Authentication errors
      if (statusCode == 401) {
        return AuthenticationException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Your session has expired. Please login again.',
          statusCode: statusCode,
          errorData: dioException.response?.data,
        );
      }

      // Authorization errors
      if (statusCode == 403) {
        return AuthenticationException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'You don\'t have permission to access this resource.',
          statusCode: statusCode,
          errorData: dioException.response?.data,
        );
      }

      // Not found errors
      if (statusCode == 404) {
        return NotFoundException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'The requested resource was not found.',
          statusCode: statusCode,
          errorData: dioException.response?.data,
        );
      }

      // Validation errors
      if (statusCode == 400 || statusCode == 422) {
        return ValidationException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Invalid data provided. Please check your input.',
          statusCode: statusCode,
          errorData: dioException.response?.data,
        );
      }

      // Client errors (4xx)
      if (statusCode >= 400 && statusCode < 500) {
        return ClientException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'There was a problem with your request. Please try again.',
          statusCode: statusCode,
          errorData: dioException.response?.data,
        );
      }

      // Server errors (5xx)
      if (statusCode >= 500) {
        return ServerException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Server is experiencing issues. Please try again later.',
          statusCode: statusCode,
          errorData: dioException.response?.data,
        );
      }
    }

    // Default client error
    return ClientException(
      message: errorMessage.isNotEmpty
          ? errorMessage
          : 'An error occurred while processing your request.',
      statusCode: statusCode,
      errorData: dioException.response?.data,
    );
  }

  /// Handles connection errors
  static AppException _handleConnectionError(DioException dioException) {
    // Check if it's a socket exception (no internet)
    if (dioException.error is SocketException) {
      return const NetworkException(
        message: 'No internet connection. Please check your network settings.',
        statusCode: null,
      );
    }

    return const NetworkException(
      message:
          'Failed to connect to the server. Please check your internet connection.',
      statusCode: null,
    );
  }

  /// Handles unknown errors
  static AppException _handleUnknownError(DioException dioException) {
    // Check if it's a socket exception
    if (dioException.error is SocketException) {
      return const NetworkException(
        message: 'No internet connection. Please check your network settings.',
        statusCode: null,
      );
    }

    // Check if it's a format exception (parsing error)
    if (dioException.error is FormatException) {
      return const UnknownException(
        message: 'Received invalid data from server. Please try again.',
        statusCode: null,
      );
    }

    return UnknownException(
      message:
          dioException.message ??
          'An unexpected error occurred. Please try again.',
      statusCode: null,
      errorData: dioException.error,
    );
  }

  /// Extracts error message from response data
  static String _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return '';

    try {
      // If response is a Map
      if (responseData is Map<String, dynamic>) {
        // Check for 'error' field
        if (responseData.containsKey('error')) {
          final error = responseData['error'];

          // Handle nested error object
          if (error is Map<String, dynamic>) {
            if (error.containsKey('message')) {
              return _sanitizeErrorMessage(error['message'].toString());
            }
            return _sanitizeErrorMessage(error.toString());
          }

          // Handle string error
          return _sanitizeErrorMessage(error.toString());
        }

        // Check for 'message' field
        if (responseData.containsKey('message')) {
          return _sanitizeErrorMessage(responseData['message'].toString());
        }

        // Check for 'errors' field (array of errors)
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            return _sanitizeErrorMessage(errors.first.toString());
          }
          if (errors is Map) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return _sanitizeErrorMessage(firstError.first.toString());
            }
            return _sanitizeErrorMessage(firstError.toString());
          }
        }

        // Check for 'detail' field
        if (responseData.containsKey('detail')) {
          return _sanitizeErrorMessage(responseData['detail'].toString());
        }
      }

      // If response is a string
      if (responseData is String && responseData.isNotEmpty) {
        return _sanitizeErrorMessage(responseData);
      }
    } catch (e) {
      log('ExceptionHandler: Error extracting message - $e');
    }

    return '';
  }

  /// Sanitizes and makes error messages user-friendly
  static String _sanitizeErrorMessage(String message) {
    if (message.isEmpty) return '';

    // Handle UUID validation errors
    if (message.contains('invalid input syntax for type uuid')) {
      return 'Invalid ID format provided. Please try again.';
    }

    // Handle foreign key constraint errors
    if (message.contains('violates foreign key constraint')) {
      return 'This item is being used elsewhere and cannot be modified.';
    }

    // Handle unique constraint errors
    if (message.contains('duplicate key value') ||
        message.contains('already exists')) {
      return 'This record already exists. Please use a different value.';
    }

    // Handle null constraint errors
    if (message.contains('null value in column') ||
        message.contains('violates not-null constraint')) {
      return 'Required information is missing. Please fill in all required fields.';
    }

    // Handle data too long errors
    if (message.contains('value too long')) {
      return 'Input is too long. Please shorten your entry.';
    }

    // Handle invalid date/time errors
    if (message.contains('invalid input syntax for type timestamp') ||
        message.contains('invalid input syntax for type date')) {
      return 'Invalid date or time format. Please check your input.';
    }

    // Handle numeric errors
    if (message.contains('invalid input syntax for type integer') ||
        message.contains('invalid input syntax for type numeric')) {
      return 'Invalid number format. Please enter a valid number.';
    }

    // Handle JSON errors
    if (message.contains('invalid input syntax for type json')) {
      return 'Invalid data format. Please try again.';
    }

    // Handle connection refused
    if (message.contains('Connection refused')) {
      return 'Unable to connect to the server. Please try again later.';
    }

    // Handle timeout errors
    if (message.contains('timeout') || message.contains('timed out')) {
      return 'Request took too long. Please try again.';
    }

    // If message is too technical or too long, provide a generic one
    if (message.length > 150 ||
        message.contains('SQL') ||
        message.contains('Exception') ||
        message.contains('Error:')) {
      return 'An error occurred. Please try again or contact support.';
    }

    // Return sanitized message (capitalize first letter)
    final sanitized = message.trim();
    if (sanitized.isEmpty) return '';

    return sanitized[0].toUpperCase() + sanitized.substring(1);
  }

  /// Gets timeout message based on timeout type
  static String _getTimeoutMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond. Please try again.';
      default:
        return 'Request timeout. Please try again.';
    }
  }
}
