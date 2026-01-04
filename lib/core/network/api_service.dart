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

  ResultFuture<Response> login(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(ApiEndpoints.login, params);
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

  ResultFuture<Response> getMembership(String organizationId) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.organizationMembership(organizationId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getMembership: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getOrganizationSettings(String organizationId) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.organizationSettings(organizationId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getOrganizationSettings: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateOrganizationSettings(
    String organizationId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.organizationSettings(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateOrganizationSettings: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> fetchEmployees(
    Map<String, Object> params,
    String organizationId,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.organizationEmployees(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.fetchEmployees: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getSingleEmployee(
    String id,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.employeeById(id),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getSingleEmployee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  // create-location
  ResultFuture<Response> createLocation(
    dynamic params,
    String organizationId,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.organizationLocations(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createLocation: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateLocation(
    Map<String, dynamic> params,
    String organizationId,
    String locationId,
  ) async {
    try {
      final response = await _networkClient.put(
        ApiEndpoints.locationById(organizationId, locationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateLocation: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  // delete-location/1
  ResultVoid deleteLocation(
    dynamic params,
    String organizationId,
    String locationId,
  ) async {
    try {
      await _networkClient.delete(
        ApiEndpoints.locationById(organizationId, locationId),
        params,
      );
      return const Right(null);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteLocation: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createEmployee(
    String organizationId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.createEmployee(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createEmployee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateEmployee(
    String organizationId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.put(
        ApiEndpoints.updateEmployee(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateEmployee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteEmployeeFromOrganization(
    String organizationId,
    String employeeId,
  ) async {
    try {
      final response = await _networkClient.delete(
        ApiEndpoints.deleteEmployee(organizationId, employeeId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteEmployeeFromOrganization: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateEmployeeUserType(
    String organizationId,
    String employeeId,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _networkClient.put(
        ApiEndpoints.updateEmployeeUserType(organizationId, employeeId),
        body,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateEmployeeUserType: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultVoid deleteEmployee(Map<String, Object> params, String id) async {
    try {
      await _networkClient.delete(ApiEndpoints.employeeById(id), params);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteEmployee: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getStats(Map<String, Object> params) async {
    try {
      final response = await _networkClient.get(ApiEndpoints.dashboard, params);
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getStats: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getTimeSheetsCount({
    required String organizationId,
    required Map<String, Object> params,
  }) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.timesheetsCount(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getTimeSheetsCount: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getLocations(
    Map<String, Object> params,
    String organizationId,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.organizationLocations(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getLocations: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getRoles(
    Map<String, Object> params,
    String organizationId,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.organizationRoles(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getRoles: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> addRole(dynamic params, String organizationId) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.organizationRoles(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.addRole: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateRole(
    Map<String, dynamic> params,
    String organizationId,
    String roleId,
  ) async {
    try {
      final response = await _networkClient.put(
        ApiEndpoints.roleById(organizationId, roleId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateRole: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultVoid deleteRole(
    dynamic params,
    String organizationId,
    String roleId,
  ) async {
    try {
      await _networkClient.delete(
        ApiEndpoints.roleById(organizationId, roleId),
        params,
      );
      return const Right(null);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteRole: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getTimeSheets(
    String organizationId,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.timesheets(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getTimeSheets: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> addTimesheet(
    String organizationId,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.createTimesheet(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.addTimesheet: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> timeSheetStatus(
    String organizationId,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        ApiEndpoints.timesheetStatus(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.timeSheetStatus: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateTimesheetById({
    required String organizationId,
    required String attendanceId,
    required Map<String, dynamic> params,
  }) async {
    try {
      final endpoint = ApiEndpoints.updateTimesheetById(
        organizationId,
        attendanceId,
      );
      log('ApiService.updateTimesheetById: Calling PATCH $endpoint');
      log('ApiService.updateTimesheetById: Params = $params');

      final response = await _networkClient.patch(endpoint, params);

      log(
        'ApiService.updateTimesheetById: Response statusCode = ${response.statusCode}',
      );
      log('ApiService.updateTimesheetById: Response data = ${response.data}');

      return Right(response);
    } on AppException catch (e) {
      log('ApiService.updateTimesheetById: AppException - ${e.message}');
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateTimesheetById: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteTimesheet(
    String organizationId,
    String attendanceId,
    dynamic params,
  ) async {
    try {
      final response = await _networkClient.delete(
        ApiEndpoints.deleteTimesheet(organizationId, attendanceId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteTimesheet: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getCurrentPayPeriod(String organizationId) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.currentPayPeriod(organizationId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getCurrentPayPeriod: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ResultFuture<Response> updateTimeSheet(Map<String, Object> params) async {
  //   try {
  //     final response = await _networkClient.post(
  //       ApiEndpoints.updateTimesheet,
  //       params,
  //     );
  //     return Right(response);
  //   } on AppException catch (e) {
  //     return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
  //   } catch (e) {
  //     log('ApiService.updateTimeSheet: Unexpected error - $e');
  //     return Left(UnknownFailure(e.toString()));
  //   }
  // }

  ResultFuture<Response> updateBreak(Map<String, Object> data) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.updateBreak,
        data,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateBreak: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> addbreak(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.createBreak,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.addbreak: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> verifyEmployeePin(
    String organizationId,
    String employeeId,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.verifyEmployee(organizationId, employeeId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.verifyEmployeePin: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  
  ResultFuture<Response> employeeShifts(
    String organizationId,
    String userId,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.employeeShifts(organizationId, userId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.employeeShifts: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getRosterShifts(
    String organizationId,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.rosterShifts(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getRosterShifts: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createRosterShift(
    String organizationId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.rosterShifts(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createRosterShift: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateRosterShift(
    String organizationId,
    String shiftId,
    Map<String, dynamic> params,
  ) async {
    try {
      final endpoint = ApiEndpoints.editShifts(organizationId, shiftId);
      final response = await _networkClient.put(endpoint, params);
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateRosterShift: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteRosterShift(
    String organizationId,
    String shiftId,
  ) async {
    try {
      final endpoint = ApiEndpoints.deleteShifts(organizationId, shiftId);
      final response = await _networkClient.delete(endpoint, {});
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteRosterShift: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createEmployeeSalary(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.createEmployeeSalary,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createEmployeeSalary: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getEmployeeSalary(
    Map<String, dynamic> params,
    int id,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.employeeSalary(id),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getEmployeeSalary: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> clockIn({
    required String organizationId,
    required String employeeId,
    required dynamic params,
  }) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.clockIn(organizationId, employeeId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.clockIn: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> clockOut({
    required String organizationId,
    required String employeeId,
    required dynamic params,
  }) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.clockOut(organizationId, employeeId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.clockOut: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> breakIn({
    required String employeeId,
    required String organizationId,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.breakIn(organizationId, employeeId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.breakIn: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> breakOut({
    required String employeeId,
    required String organizationId,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.breakOut(organizationId, employeeId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.breakOut: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> resetPin({
    required String organizationId,
    required String userId,
    required Map<String, Object> params,
  }) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.resetPin(organizationId, userId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.resetPin: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> resetPassword(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.resetPassword,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.resetPassword: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> changePassword(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.changePassword,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.changePassword: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  // in ApiService class
  ResultFuture<Response> updatePayPeriod(Map<String, dynamic> params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.updatePayPeriod,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updatePayPeriod: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Fetch external URL - returns nullable Response for backward compatibility
  /// Note: This doesn't use the standard error handling as it's for external URLs
  Future<Response?> fetchUrl(String uri, {Map<String, String>? headers}) async {
    try {
      Dio dio = Dio();
      final response = await dio.get(uri, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      log('ApiService.fetchUrl: Error - $e');
    }
    return null;
  }

  ResultFuture<Response> sendContactQuery(Map<String, Object> params) async {
    try {
      final response = await _networkClient.post(ApiEndpoints.contact, params);
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.sendContactQuery: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getTasks(
    String organizationId,
    Map<String, Object> params,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.tasks(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getTasks: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createTask(
    String organizationId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.tasks(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createTask: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getTaskById(
    String organizationId,
    String taskId,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.taskById(organizationId, taskId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getTaskById: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateTask(
    String organizationId,
    String taskId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        ApiEndpoints.taskById(organizationId, taskId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateTask: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteTask(
    String organizationId,
    String taskId,
  ) async {
    try {
      final response = await _networkClient.delete(
        ApiEndpoints.taskById(organizationId, taskId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateTask: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateUserProfile(FormData params) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.updateProfile,
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateUserProfile: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getUserSessions() async {
    try {
      final response = await _networkClient.get(ApiEndpoints.userSessions, {});
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getUserSessions: Unexpected error - $e');
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

  ResultFuture<Response> getSession() async {
    try {
      final response = await _networkClient.get(ApiEndpoints.getSession, {});
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getSession: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getLeaveRequests(
    String organizationId, {
    String? status,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _networkClient.get(
        ApiEndpoints.leaves(organizationId),
        queryParams,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getLeaveRequests: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> createLeaveRequest(
    String organizationId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.post(
        ApiEndpoints.leaves(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.createLeaveRequest: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getLeaveById(
    String organizationId,
    String leaveId,
  ) async {
    try {
      final response = await _networkClient.get(
        ApiEndpoints.leaveById(organizationId, leaveId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getLeaveById: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> updateLeaveRequest(
    String organizationId,
    String leaveId,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _networkClient.patch(
        ApiEndpoints.updateLeaveStatus(organizationId),
        params,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.updateLeaveRequest: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> deleteLeaveRequest(
    String organizationId,
    String leaveId,
  ) async {
    try {
      final response = await _networkClient.delete(
        ApiEndpoints.leaveById(organizationId, leaveId),
        {},
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.deleteLeaveRequest: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  ResultFuture<Response> getAppVersions() async {
    try {
      final response = await _networkClient.get(ApiEndpoints.appVersions, {});
      return Right(response);
    } on AppException catch (e) {
      return Left(ExceptionToFailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      log('ApiService.getAppVersions: Unexpected error - $e');
      return Left(UnknownFailure(e.toString()));
    }
  }
}
