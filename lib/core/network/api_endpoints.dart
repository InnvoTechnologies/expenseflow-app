/// Centralized API endpoints configuration
/// This class provides a single source of truth for all API endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // ==================== Authentication ====================
  static const String register = '/register';
  static const String login = '/auth/sign-in/email';
  static const String logout = '/logout';
  static const String forgotPassword = '/auth/forget-password/email-otp';
  static const String verifyOtp = '/auth/email-otp/check-verification-otp';
  static const String resetForgotPassword = '/auth/email-otp/reset-password';
  static String resetPin(String organizationId, String userId) =>
      '/organization/$organizationId/users/$userId/reset-pin';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/auth/change-password';

  // ==================== Organizations ====================
  static const String organizations = '/organizations';

  static String organizationMembership(String organizationId) =>
      '/organization/$organizationId/membership';

  static String organizationEmployees(String organizationId) =>
      '/organization/$organizationId/employees/all';

  static String organizationSettings(String organizationId) =>
      '/organization/$organizationId/settings';

  // ==================== Locations ====================
  static String organizationLocations(String organizationId) =>
      '/organization/$organizationId/locations/all';

  static String locationById(String organizationId, String locationId) =>
      '/organization/$organizationId/locations/$locationId';

  // ==================== Roles ====================
  static String organizationRoles(String organizationId) =>
      '/organization/$organizationId/roles/all';

  static String roleById(String organizationId, String roleId) =>
      '/organization/$organizationId/roles/$roleId';

  // ==================== Employees ====================
  static String createEmployee(String organizationId) =>
      '/organization/$organizationId/employees';

  static String updateEmployee(String organizationId) =>
      '/organization/$organizationId/employees';

  static String updateEmployeeUserType(
    String organizationId,
    String employeeId,
  ) => '/organization/$organizationId/employees/$employeeId/user-type';

  static String deleteEmployee(String organizationId, String employeeId) =>
      '/organization/$organizationId/employees/$employeeId';

  static String employeeById(String id) => '/employee/$id';

  static String verifyEmployee(String organizationId, String employeeId) =>
      '/organization/$organizationId/users/$employeeId/verify-pin';

  static String employeeStatus(String organizationId, String userId) =>
      '/organization/$organizationId/users/$userId/attendance/status';

  static String employeeShifts(String organizationId, String userId) =>
      '/organization/$organizationId/users/$userId/shifts';

  // ==================== Roster Shifts ====================

  static String rosterShifts(String organizationId) =>
      '/organization/$organizationId/roster-maker';

  static String editShifts(String organizationId, String shiftId) =>
      '/organization/$organizationId/roster-maker/$shiftId';

  static String deleteShifts(String organizationId, String shiftId) =>
      '/organization/$organizationId/roster-maker/$shiftId';

  // ==================== Employee Salary ====================
  static const String createEmployeeSalary = '/create_employee-salary';

  static String employeeSalary(int employeeId) =>
      '/employee-salary?employee_id=$employeeId';

  static const String updatePayPeriod = '/employee/update-pay-period';

  // ==================== Dashboard & Stats ====================
  static const String dashboard = '/dashboard';

  static const String stats = '/dashboard';

  // ==================== Timesheets ====================
  static String timesheets(String organizationId) =>
      '/organization/$organizationId/timesheet';

  static String timesheetsCount(String organizationId) =>
      '/organization/$organizationId/timesheet/stats';

  static String currentPayPeriod(String organizationId) =>
      '/organization/$organizationId/payperiod/current';

  static String createTimesheet(String organizationId) =>
      '/organization/$organizationId/timesheet';

  // static const String updateTimesheet = '/timesheet-update/v2';

  static String timesheetStatus(String organizationId) =>
      '/organization/$organizationId/timesheet/update-status';

  static String timesheetById(String id) => '/timesheet/$id';

  static String updateTimesheetById(
    String organizationId,
    String attendanceId,
  ) => '/organization/$organizationId/timesheet/$attendanceId';

  static String deleteTimesheet(String organizationId, String attendanceId) =>
      '/organization/$organizationId/timesheet/$attendanceId';

  // ==================== Breaks ====================
  static const String createBreak = '/createBreak';

  static const String updateBreak = '/update-Break';

  static String breakIn(String organizationId, String employeeId) =>
      '/organization/$organizationId/users/$employeeId/attendance/break';

  static String breakOut(String organizationId, String employeeId) =>
      '/organization/$organizationId/users/$employeeId/attendance/break';

  // ==================== Attendance/Clock ====================
  static String clockIn(String organizationId, String employeeId) =>
      '/organization/$organizationId/users/$employeeId/attendance/clock-in';

  static String clockOut(String organizationId, String employeeId) =>
      '/organization/$organizationId/users/$employeeId/attendance/clock-out';

  // ==================== Support ====================
  static const String contact = '/contact';

  // ==================== Tasks ====================
  static String tasks(String organizationId) =>
      '/organization/$organizationId/tasks';

  static String taskById(String organizationId, String taskId) =>
      '/organization/$organizationId/tasks/$taskId';

  // ==================== Leave ====================
  static String leaves(String organizationId) =>
      '/organization/$organizationId/leaves';

  static String leaveById(String organizationId, String leaveId) =>
      '/organization/$organizationId/leaves/$leaveId';

  static String updateLeaveStatus(String organizationId) =>
      '/organization/$organizationId/leaves/update-status';

  // ==================== User Profile ====================
  static const String updateProfile = '/user/update-profile';
  static const String userSessions = '/user/sessions';
  static const String revokeAllSessions = '/user/sessions';
  static const String getSession = '/auth/get-session';

  // ==================== App Version ====================
  static const String appVersions = '/app-versions';

  // ==================== Helper Methods ====================

  /// Build a path with query parameters
  static String withQueryParams(String path, Map<String, dynamic> params) {
    if (params.isEmpty) return path;

    final queryString = params.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return queryString.isEmpty ? path : '$path?$queryString';
  }

  /// Validate endpoint format
  static bool isValidEndpoint(String endpoint) {
    return endpoint.isNotEmpty && endpoint.startsWith('/');
  }
}
