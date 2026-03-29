class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmed)) {
      return 'Phone must contain only numbers';
    }
    return null;
  }

  static String? positiveAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount must be greater than 0';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  static String? currentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a new password';
    }
    if (value.trim().length < 8) {
      return 'Password should be at least 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String newPasswordValue) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your new password';
    }
    if (value.trim() != newPasswordValue.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }
}
