import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/utils/validators.dart';
import '../data/repository/auth_repository.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  ForgotPasswordViewModel({AuthRepository? authRepository})
    : _authRepository = authRepository ?? locator<AuthRepository>();

  final emailController = TextEditingController();

  bool _isResetLinkSent = false;
  bool get isResetLinkSent => _isResetLinkSent;

  /// Verifies email format and triggers recovery request.
  /// Sets [isResetLinkSent] to true on successful reset trigger.
  Future<bool> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setError('Please enter your email address');
      return false;
    }

    if (!Validators.isValidEmail(email)) {
      setError('Please enter a valid email address');
      return false;
    }

    setState(ViewState.loading);
    clearError();

    final result = await _authRepository.requestPasswordReset(email);

    return result.fold(
      (_) {
        _isResetLinkSent = true;
        setState(ViewState.success);
        return true;
      },
      (message, exception) {
        setError(message);
        return false;
      },
    );
  }

  /// Resets recovery states to allow sending links again.
  void resetState() {
    emailController.clear();
    _isResetLinkSent = false;
    clearError();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
