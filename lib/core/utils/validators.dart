class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s.]+\.[^@\s]+$');

  static const int maxFieldLength = 256;
  static const int minPasswordLength = 8;

  static String? required(String? value, String fieldName) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter $fieldName';
    }
    if (trimmed.length > maxFieldLength) {
      return '$fieldName must be at most $maxFieldLength characters';
    }
    return null;
  }

  static String? email(String? value) {
    final error = required(value, 'Email');
    if (error != null) {
      return error;
    }
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final error = required(value, 'Password');
    if (error != null) {
      return error;
    }
    if (value!.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }
}
