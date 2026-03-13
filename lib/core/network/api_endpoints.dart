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
  // static String resetPin(String organizationId, String userId) =>
  //     '/organization/$organizationId/users/$userId/reset-pin';
  static const String resetPassword = '/reset-password';
  // static const String changePassword = '/auth/change-password';

  // ==================== Categories ====================
  static const String categories = '/categories';

  // ==================== Tags ====================
  static const String tags = '/tags';

  // ==================== Accounts ====================
  static const String accounts = '/accounts';

  // ==================== Subscriptions ====================
  static const String subscriptions = '/subscriptions';

  // ==================== Payees ====================
  static const String payees = '/payees';

  // ==================== Dashboard ====================
  static const String dashboard = '/dashboard';

  // ==================== User Profile ====================
  static const String updateProfile = '/user/update-profile';
  static const String userSessions = '/user/sessions';
  static const String revokeAllSessions = '/user/sessions';
  static const String getSession = '/auth/get-session';
}
