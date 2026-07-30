import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/base/app_activity_notifier.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/di/service_locator.dart';
import '../data/repository/auth_repository.dart';

class AuthViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  final AppActivityNotifier _activityNotifier;

  AuthViewModel({
    AuthRepository? authRepository,
    AppActivityNotifier? activityNotifier,
  })  : _authRepository = authRepository ?? locator<AuthRepository>(),
        _activityNotifier = activityNotifier ?? locator<AppActivityNotifier>();

  // Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Obscure state
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  // Remember me checkbox
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  // Rate Limiting lockout states
  int _failedAttempts = 0;
  int get failedAttempts => _failedAttempts;

  int _lockoutSecondsRemaining = 0;
  int get lockoutSecondsRemaining => _lockoutSecondsRemaining;
  bool get isLockedOut => _lockoutSecondsRemaining > 0;

  Timer? _lockoutTimer;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// Attempts login using controllers input.
  /// If consecutive failed attempts reach 5, locks out login requests.
  Future<bool> login() async {
    if (isLockedOut) {
      setError('Too many failed attempts. Try again in $_lockoutSecondsRemaining seconds.');
      return false;
    }

    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setError('Username and password fields cannot be empty.');
      return false;
    }

    setState(ViewState.loading);
    clearError();

    final result = await _authRepository.login(username, password);

    return result.fold(
      (user) {
        // Success
        _failedAttempts = 0;
        setState(ViewState.success);
        
        // Broadcast authenticated event to cross-feature event bus
        _activityNotifier.notifyActivity(
          const AppActivityEvent(
            type: AppActivityType.authenticated,
            payload: {'userId': 'usr_001', 'username': 'user123'},
          ),
        );
        return true;
      },
      (message, exception) {
        // Failure
        _failedAttempts++;
        if (_failedAttempts >= 5) {
          _startLockout();
        } else {
          setError(message);
        }
        return false;
      },
    );
  }

  void _startLockout() {
    _lockoutSecondsRemaining = 30;
    setError('Too many failed attempts. Login locked for 30 seconds.');
    setState(ViewState.error);

    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lockoutSecondsRemaining > 1) {
        _lockoutSecondsRemaining--;
        // Update error message with current countdown seconds remaining
        setError('Too many failed attempts. Login locked for $_lockoutSecondsRemaining seconds.');
      } else {
        // Lockout expired
        _lockoutSecondsRemaining = 0;
        _failedAttempts = 0;
        clearError();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }
}
