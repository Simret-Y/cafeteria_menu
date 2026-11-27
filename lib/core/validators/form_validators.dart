/// Reusable form field validators for customer authentication and checkout.
abstract final class FormValidators {
  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');

  static String? fullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your full name';
    }
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your email address';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final raw = value ?? '';
    if (raw.isEmpty) {
      return 'Please enter your password';
    }
    if (raw.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    final raw = value ?? '';
    if (raw.isEmpty) {
      return 'Please confirm your password';
    }
    if (raw != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? phone(String? value) {
    final normalized = (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (normalized.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!_phoneRegex.hasMatch(normalized)) {
      return 'Enter a valid phone number (9–15 digits)';
    }
    return null;
  }
}
