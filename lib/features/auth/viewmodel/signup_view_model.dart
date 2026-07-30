import 'package:flutter/material.dart';
import '../../../core/base/app_activity_notifier.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/utils/validators.dart';
import '../data/repository/auth_repository.dart';

class SignupViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  final AppActivityNotifier _activityNotifier;

  SignupViewModel({
    AuthRepository? authRepository,
    AppActivityNotifier? activityNotifier,
  })  : _authRepository = authRepository ?? locator<AuthRepository>(),
        _activityNotifier = activityNotifier ?? locator<AppActivityNotifier>() {
    // Attach listeners to trigger reactive form state updates and enable/disable button
    firstNameController.addListener(_onFirstNameChanged);
    lastNameController.addListener(_onLastNameChanged);
    emailController.addListener(_onEmailChanged);
    usernameController.addListener(_onUsernameChanged);
    passwordController.addListener(_onPasswordChanged);
    confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Obscure password toggles
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // Interacted/touched flags for clean validation UX
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _emailTouched = false;
  bool _usernameTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Live listeners to mark fields as dirty
  void _onFirstNameChanged() {
    if (firstNameController.text.isNotEmpty) _firstNameTouched = true;
    notifyListeners();
  }

  void _onLastNameChanged() {
    if (lastNameController.text.isNotEmpty) _lastNameTouched = true;
    notifyListeners();
  }

  void _onEmailChanged() {
    if (emailController.text.isNotEmpty) _emailTouched = true;
    notifyListeners();
  }

  void _onUsernameChanged() {
    if (usernameController.text.isNotEmpty) _usernameTouched = true;
    notifyListeners();
  }

  void _onPasswordChanged() {
    if (passwordController.text.isNotEmpty) _passwordTouched = true;
    notifyListeners();
  }

  void _onConfirmPasswordChanged() {
    if (confirmPasswordController.text.isNotEmpty) _confirmPasswordTouched = true;
    notifyListeners();
  }

  // Computed field error getters
  String? get firstNameError {
    if (!_firstNameTouched) return null;
    if (firstNameController.text.trim().isEmpty) return 'First name is required';
    return null;
  }

  String? get lastNameError {
    if (!_lastNameTouched) return null;
    if (lastNameController.text.trim().isEmpty) return 'Last name is required';
    return null;
  }

  String? get emailError {
    if (!_emailTouched) return null;
    final email = emailController.text.trim();
    if (email.isEmpty) return 'Email address is required';
    if (!Validators.isValidEmail(email)) return 'Invalid email format';
    return null;
  }

  String? get usernameError {
    if (!_usernameTouched) return null;
    if (usernameController.text.trim().isEmpty) return 'Username is required';
    return null;
  }

  String? get passwordError {
    if (!_passwordTouched) return null;
    final password = passwordController.text;
    if (password.isEmpty) return 'Password is required';
    if (!Validators.isValidPassword(password)) {
      return 'Min 6 characters, at least 1 uppercase, 1 lowercase, and a number';
    }
    return null;
  }

  String? get confirmPasswordError {
    if (!_confirmPasswordTouched) return null;
    final confirm = confirmPasswordController.text;
    if (confirm.isEmpty) return 'Confirm password is required';
    if (confirm != passwordController.text) return 'Passwords do not match';
    return null;
  }

  /// Exposes whether all validation rules are met.
  /// Standard validation for button enable state.
  bool get isFormValid {
    final fn = firstNameController.text.trim();
    final ln = lastNameController.text.trim();
    final em = emailController.text.trim();
    final un = usernameController.text.trim();
    final pw = passwordController.text;
    final cpw = confirmPasswordController.text;

    return fn.isNotEmpty &&
        ln.isNotEmpty &&
        un.isNotEmpty &&
        Validators.isValidEmail(em) &&
        Validators.isValidPassword(pw) &&
        cpw == pw;
  }

  /// Triggers user signup request to repository.
  Future<bool> signup() async {
    if (!isFormValid) return false;

    setState(ViewState.loading);
    clearError();

    final result = await _authRepository.signup(
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      emailController.text.trim(),
      usernameController.text.trim(),
      passwordController.text,
    );

    return result.fold(
      (user) {
        setState(ViewState.success);
        
        // Notify global app activity notifier bus
        _activityNotifier.notifyActivity(
          AppActivityEvent(
            type: AppActivityType.authenticated,
            payload: user.toJson(),
          ),
        );
        return true;
      },
      (message, exception) {
        setError(message);
        return false;
      },
    );
  }

  @override
  void dispose() {
    firstNameController.removeListener(_onFirstNameChanged);
    lastNameController.removeListener(_onLastNameChanged);
    emailController.removeListener(_onEmailChanged);
    usernameController.removeListener(_onUsernameChanged);
    passwordController.removeListener(_onPasswordChanged);
    confirmPasswordController.removeListener(_onConfirmPasswordChanged);

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
