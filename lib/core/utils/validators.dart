/// Validators provides validation logic for user input forms (emails, passwords, etc.).
abstract class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Requirements: min 6 chars, 1 uppercase, 1 lowercase, alphanumeric
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$',
  );

  /// Validates if a string is a properly formatted email.
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegExp.hasMatch(email);
  }

  /// Validates password rules:
  /// - Minimum 6 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit (alphanumeric rule)
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return _passwordRegExp.hasMatch(password);
  }
}
