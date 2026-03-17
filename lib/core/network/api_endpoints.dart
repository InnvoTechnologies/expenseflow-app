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
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/auth/change-password';

  // ==================== Categories ====================
  static const String categories = '/categories';

  // ==================== Tags ====================
  static const String tags = '/tags';

  // ==================== Accounts ====================
  static const String accounts = '/accounts';

  // ==================== Subscriptions ====================
  static const String subscriptions = '/subscriptions';

  // ==================== Reminders ====================
  static const String reminders = '/reminders';

  // ==================== Transactions ====================
  static const String transactions = '/transactions';

  // ==================== Payees ====================
  static const String payees = '/payees';

  // ==================== Dashboard ====================
  static const String dashboard = '/dashboard';

  // ==================== Organizations ====================
  static const String organizations = '/organization';

  // ==================== User Profile ====================
  static const String updateProfile = '/user/update-profile';
  static const String profile = '/profile';
  static const String userSessions = '/profile/sessions';
  static const String revokeAllSessions = '/profile/sessions/revoke-all';
  static const String getSession = '/auth/get-session';
}
