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
  String? _organizationId;

  void initApiService() {
    _networkClient = NetworkClient(kBaseUrl);
  }

  void setOrganizationId(String? organizationId) {
    _organizationId = organizationId;
  }

  Map<String, String>? _buildOrganizationHeaders() {
    if (_organizationId == null) return null;
    return {
      'x-organization-id': _organizationId!,
    };
  }

  Future<void> setSessionCookie(String sessionToken) async {
    await _networkClient.setCookie('better-auth.session_token', sessionToken);
    log('Session cookie set: better-auth.session_token=$sessionToken');
    try {
      final cookies = await _networkClient.getCookies();
      log('Current cookies: $cookies');
    } catch (e) {
      log('Failed to read cookies for logging: $e');
    }
  }

  // Method to clear all cookies on logout
  Future<void> clearSession() async {
    await _networkClient.clearCookies();
  }

  ResultFuture<Response> signup(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.register,
        params,
        headers: _buildOrganizationHeaders(),
      );
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
      final response = await _networkClient.get(
        ApiEndpoints.logout,
        params,
        headers: _buildOrganizationHeaders(),
      );
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteTag: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getAccounts(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.accounts,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getAccounts: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createAccount(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.accounts,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createAccount: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateAccount(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.accounts}/$id',
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateAccount: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteAccount(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.accounts}/$id',
        {},
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteAccount: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getSubscriptions(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.subscriptions,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getSubscriptions: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createSubscription(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.subscriptions,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createSubscription: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateSubscription(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.subscriptions}/$id',
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateSubscription: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteSubscription(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.subscriptions}/$id',
        {},
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteSubscription: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getReminders(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.reminders,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getReminders: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getTransactions(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.transactions,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getTransactions: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createTransaction(Map<String, dynamic> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.transactions,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createTransaction: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateTransaction(
    String id,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.transactions}/$id',
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateTransaction: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteTransaction(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.transactions}/$id',
        {},
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteTransaction: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createReminder(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.reminders,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createReminder: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateReminder(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        '${ApiEndpoints.reminders}/$id',
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateReminder: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteReminder(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.reminders}/$id',
        {},
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteReminder: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createCategory(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.categories,
        params,
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
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
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deletePayee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getDashboard(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.dashboard,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getDashboard: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getUserSessions(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.userSessions,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getUserSessions: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> revokeSession(String id) async {
    try {
      final response = await _networkClient.delete(
        '${ApiEndpoints.userSessions}/$id',
        {},
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.revokeSession: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> revokeAllSessions() async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.revokeAllSessions,
        {},
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.revokeAllSessions: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> changePassword(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.changePassword,
        params,
        headers: _buildOrganizationHeaders(),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.changePassword: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getOrganizations(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.organizations,
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

  ResultFuture<Response> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _networkClient.patch(ApiEndpoints.profile, {
        'firstName': firstName,
        'lastName': lastName,
      }, headers: _buildOrganizationHeaders());
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateProfile: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }
}
