import 'package:flutter/foundation.dart';

/// Represents distinct system/domain events that can be broadcasted
/// globally across various features (e.g. updating dashboard lists, etc.).
enum AppActivityType {
  transactionCompleted,
  profileUpdated,
  sessionExpired,
  authenticated,
}

/// A structured event carrying event type and payload data.
class AppActivityEvent {
  final AppActivityType type;
  final Map<String, dynamic>? payload;

  const AppActivityEvent({
    required this.type,
    this.payload,
  });
}

/// AppActivityNotifier acts as a lightweight cross-feature event bus.
///
/// ### Architecture Pattern:
/// Feature ViewModels should inject this notifier via GetIt (or depend on it via Provider)
/// to publish or subscribe to global banking events. This prevents direct coupling between
/// modules (such as TransactionDetails causing Home/Dashboard updates directly).
///
/// ### How to Hook In:
/// 1. **Publishing an Event**:
///    ```dart
///    // From inside TransactionViewModel when transfer succeeds:
///    locator<AppActivityNotifier>().notifyActivity(
///      AppActivityEvent(
///        type: AppActivityType.transactionCompleted,
///        payload: {'transactionId': '123', 'amount': 5000.0},
///      ),
///    );
///    ```
///
/// 2. **Subscribing / Reacting**:
///    ```dart
///    // From inside HomeViewModel or NotificationsViewModel initialization:
///    final eventNotifier = locator<AppActivityNotifier>();
///    eventNotifier.addListener(_onGlobalActivityReceived);
///
///    // Dispose listener correctly:
///    @override
///    void dispose() {
///      eventNotifier.removeListener(_onGlobalActivityReceived);
///      super.dispose();
///    }
///
///    void _onGlobalActivityReceived() {
///      final event = eventNotifier.lastEvent;
///      if (event?.type == AppActivityType.transactionCompleted) {
///         // Refresh home balances or trigger push layout
///         refreshData();
///      }
///    }
///    ```
class AppActivityNotifier extends ChangeNotifier {
  AppActivityEvent? _lastEvent;

  /// Retrieves the latest published event.
  AppActivityEvent? get lastEvent => _lastEvent;

  /// Emits a new event to all active listeners.
  void notifyActivity(AppActivityEvent event) {
    _lastEvent = event;
    notifyListeners();
  }

  /// Clears the last active event to avoid repeated processing of stale notifications.
  void clearLastEvent() {
    _lastEvent = null;
  }
}
