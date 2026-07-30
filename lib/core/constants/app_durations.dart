/// AppDurations manages standard duration constants for animations, delays, timeouts, etc.
abstract class AppDurations {
  /// The simulated network latency delay referenced throughout mock repositories.
  static const Duration mockNetworkDelay = Duration(milliseconds: 300);

  // Animation Durations
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration standardAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Storage / Session Timeouts
  static const Duration networkTimeout = Duration(seconds: 15);
}
