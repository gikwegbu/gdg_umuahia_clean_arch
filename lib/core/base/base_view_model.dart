import 'package:flutter/material.dart';

/// ViewState represents the distinct lifecycle states of a View/ViewModel.
enum ViewState { idle, loading, success, error }

/// BaseViewModel is the base class for all ViewModels in the application.
/// It integrates standard ChangeNotifier patterns and manages view states.
abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isIdle => _state == ViewState.idle;
  bool get isLoading => _state == ViewState.loading;
  bool get isSuccess => _state == ViewState.success;
  bool get isError => _state == ViewState.error;

  /// Updates the current state and triggers UI rebuild.
  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  /// Sets an error state with an optional localized message.
  void setError(String? message) {
    _errorMessage = message;
    setState(ViewState.error);
  }

  /// Clears any registered errors and returns to idle.
  void clearError() {
    _errorMessage = null;
    setState(ViewState.idle);
  }
}
