/// AppStrings contains global string constants used across the application.
abstract class AppStrings {
  static const String appName = 'Apex Banking';
  
  // Navigation / Headers
  static const String home = 'Home';
  static const String transactions = 'Transactions';
  static const String notifications = 'Notifications';
  static const String profile = 'Profile';
  static const String seeAll = 'See all';
  
  // Common UI Actions / States
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String emptyStateTitle = 'Nothing to see here';
  static const String emptyStateMessage = 'We couldn\'t find any records right now.';
  
  // Validation Messages
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword = 'Password must be at least 6 characters, with 1 uppercase, 1 lowercase, and alphanumeric characters.';
  
  // Network / Error messages
  static const String defaultErrorTitle = 'Oops! Something went wrong';
  static const String defaultErrorMessage = 'An unexpected error occurred. Please check your internet connection and try again.';
}
