import 'package:intl/intl.dart';

/// DateTimeFormatter handles formatting dates, times, relative timestamps, and greetings.
abstract class DateTimeFormatter {
  /// Returns a localized greeting based on the hour of the day.
  static String timeOfDayGreeting([DateTime? dateTime]) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  /// Formats a DateTime into a relative time representation (e.g. "2h ago", "10m ago", "Just now").
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  /// Formats a DateTime into a full readable date format (e.g. "30 July 2026").
  static String fullDate(DateTime dateTime) {
    return DateFormat('d MMMM yyyy').format(dateTime);
  }
}
