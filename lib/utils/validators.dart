import '../constants/app_constants.dart';

/// Form validation functions for all input types
/// Provides consistent validation across the entire application
class Validators {
  Validators._();

  // Regex patterns from AppConstants
  static final RegExp _emailRegex = RegExp(AppConstants.emailRegex);
  static final RegExp _phoneRegex = RegExp(AppConstants.phoneRegex);
  static final RegExp _passwordRegex = RegExp(AppConstants.passwordRegex);

  // Additional regex patterns
  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  static final RegExp _numericRegex = RegExp(r'^[0-9]+$');
  static final RegExp _alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp _urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  /// Required field validation
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    if (!_passwordRegex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
    }

    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Phone number validation
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and dashes for validation
    final cleanedValue = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!_phoneRegex.hasMatch(cleanedValue)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Name validation (first name, last name)
  static String? name(String? value, [String fieldName = 'Name']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    if (value.trim().length > AppConstants.maxNameLength) {
      return '$fieldName must be less than ${AppConstants.maxNameLength} characters';
    }

    if (!_nameRegex.hasMatch(value.trim())) {
      return '$fieldName can only contain letters and spaces';
    }

    return null;
  }

  /// Username validation
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.length < AppConstants.minUsernameLength) {
      return 'Username must be at least ${AppConstants.minUsernameLength} characters';
    }

    if (value.length > AppConstants.maxUsernameLength) {
      return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
    }

    if (!_usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Age validation
  static String? age(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 13) {
      return 'You must be at least 13 years old';
    }

    if (age > 120) {
      return 'Please enter a valid age';
    }

    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }

    if (!_urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Numeric validation
  static String? numeric(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (!_numericRegex.hasMatch(value.trim())) {
      return '$fieldName must contain only numbers';
    }

    return null;
  }

  /// Alphanumeric validation
  static String? alphanumeric(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (!_alphanumericRegex.hasMatch(value.trim())) {
      return '$fieldName must contain only letters and numbers';
    }

    return null;
  }

  /// Length validation
  static String? length(String? value, int minLength, int maxLength, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  /// Min length validation
  static String? minLength(String? value, int minLength, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  /// Max length validation
  static String? maxLength(String? value, int maxLength, [String fieldName = 'Field']) {
    if (value == null) return null;

    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  /// PIN validation
  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }

    if (value.length != AppConstants.pinLength) {
      return 'PIN must be ${AppConstants.pinLength} digits';
    }

    if (!_numericRegex.hasMatch(value)) {
      return 'PIN must contain only numbers';
    }

    return null;
  }

  /// OTP validation
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }

    if (!_numericRegex.hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }

  /// Credit card number validation (basic)
  static String? creditCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number is required';
    }

    // Remove spaces and dashes
    final cleanedValue = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!_numericRegex.hasMatch(cleanedValue)) {
      return 'Card number must contain only numbers';
    }

    if (cleanedValue.length < 13 || cleanedValue.length > 19) {
      return 'Please enter a valid card number';
    }

    // Luhn algorithm validation
    if (!_luhnValidation(cleanedValue)) {
      return 'Please enter a valid card number';
    }

    return null;
  }

  /// CVV validation
  static String? cvv(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV is required';
    }

    if (!_numericRegex.hasMatch(value)) {
      return 'CVV must contain only numbers';
    }

    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  /// Expiry date validation (MM/YY format)
  static String? expiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required';
    }

    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Please enter expiry date in MM/YY format';
    }

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return 'Please enter a valid expiry date';
    }

    if (month < 1 || month > 12) {
      return 'Please enter a valid month (01-12)';
    }

    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }

    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Custom validator function type
  static String? custom(String? value, bool Function(String?) isValid, String errorMessage) {
    if (value == null || !isValid(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Luhn algorithm for credit card validation
  static bool _luhnValidation(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}

/// Validation utilities
class ValidationUtils {
  ValidationUtils._();

  /// Check if string is empty or null
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Check if string contains only whitespace
  static bool isWhitespace(String? value) {
    return value?.trim().isEmpty ?? true;
  }

  /// Check if string is a valid email format
  static bool isValidEmail(String? value) {
    if (value == null) return false;
    return RegExp(AppConstants.emailRegex).hasMatch(value);
  }

  /// Check if string is a valid phone format
  static bool isValidPhone(String? value) {
    if (value == null) return false;
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(AppConstants.phoneRegex).hasMatch(cleaned);
  }

  /// Check if string is a valid URL format
  static bool isValidUrl(String? value) {
    if (value == null) return false;
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    ).hasMatch(value);
  }

  /// Check if string contains only numbers
  static bool isNumeric(String? value) {
    if (value == null) return false;
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  /// Check if string contains only letters
  static bool isAlpha(String? value) {
    if (value == null) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  /// Check if string contains only letters and numbers
  static bool isAlphanumeric(String? value) {
    if (value == null) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  /// Check if password is strong enough
  static bool isStrongPassword(String? value) {
    if (value == null) return false;
    return value.length >= AppConstants.minPasswordLength &&
        RegExp(AppConstants.passwordRegex).hasMatch(value);
  }

  /// Get password strength (0-4)
  static int getPasswordStrength(String? value) {
    if (value == null || value.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (value.length >= 8) strength++;

    // Contains lowercase
    if (RegExp(r'[a-z]').hasMatch(value)) strength++;

    // Contains uppercase
    if (RegExp(r'[A-Z]').hasMatch(value)) strength++;

    // Contains numbers
    if (RegExp(r'[0-9]').hasMatch(value)) strength++;

    // Contains special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength++;

    return strength;
  }

  /// Get password strength description
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }
}