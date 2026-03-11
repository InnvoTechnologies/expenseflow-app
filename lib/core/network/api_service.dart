import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/exception_to_failure_mapper.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import '../util/const/constants.dart';
import '../util/typedefs.dart';
import 'api_endpoints.dart';
import 'network_client.dart';

class ApiService {
  static final ApiService _service = ApiService._internal();

  factory ApiService() {
    return _service;
  }

  ApiService._internal();

  late NetworkClient _networkClient;

  void initApiService() {
    _networkClient = NetworkClient(kBaseUrl);
  }

  Future<void> setSessionCookie(String sessionToken) async {
    await _networkClient.setCookie('better-auth.session_token', sessionToken);
  }

  // Method to clear all cookies on logout
  Future<void> clearSession() async {
    await _networkClient.clearCookies();
  }

  ResultFuture<Response> signup(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(ApiEndpoints.register, params);
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.signup: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> login(
    Map<String, Object> params, {
    Map<String, Object>? headers,
  }) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.login,
        params,
        headers: headers,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.login: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> forgotPassword(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.forgotPassword,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.forgotPassword: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> verifyOtp(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.verifyOtp,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.verifyOtp: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> resetForgotPassword(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.resetForgotPassword,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.resetForgotPassword: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> logout(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(ApiEndpoints.logout, params);
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.logout: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getCategories(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.categories,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getOrganizations: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getTags(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.tags,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getTags: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createTag(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.tags,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createTag: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateTag(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.tags}/$id',
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateTag: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteTag(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.tags}/$id',
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteTag: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createCategory(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.categories,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createCategory: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateCategory(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.categories}/$id',
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateCategory: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteCategory(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.categories}/$id',
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteCategory: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getPayees(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.payees,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getPayees: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createPayee(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.payees,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createPayee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updatePayee(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.payees}/$id',
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updatePayee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deletePayee(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.payees}/$id',
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deletePayee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> revokeAllSessions() async {
    try {
      final response = await _networkClient.delete(
        ApiEndpoints.revokeAllSessions,
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.revokeAllSessions: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }
}
