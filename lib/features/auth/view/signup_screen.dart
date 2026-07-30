import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodel/signup_view_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final SignupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<SignupViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSignup(BuildContext context) async {
    final success = await _viewModel.signup();
    if (success && context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<SignupViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer<SignupViewModel>(
            builder: (context, vm, child) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Join Apex Banking',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Provide your details to open a modern digital banking account.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),

                    // Generic inline error banner
                    if (vm.isError && vm.errorMessage != null) ...[
                      _buildErrorBanner(context, vm.errorMessage!),
                      const SizedBox(height: 20.0),
                    ],

                    // First Name
                    AppTextField(
                      labelText: 'First Name',
                      hintText: 'e.g. John',
                      controller: vm.firstNameController,
                      errorText: vm.firstNameError,
                      enabled: !vm.isLoading,
                    ),
                    const SizedBox(height: 16.0),

                    // Last Name
                    AppTextField(
                      labelText: 'Last Name',
                      hintText: 'e.g. Doe',
                      controller: vm.lastNameController,
                      errorText: vm.lastNameError,
                      enabled: !vm.isLoading,
                    ),
                    const SizedBox(height: 16.0),

                    // Email Address
                    AppTextField(
                      labelText: 'Email Address',
                      hintText: 'e.g. john@example.com',
                      controller: vm.emailController,
                      errorText: vm.emailError,
                      enabled: !vm.isLoading,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),

                    // Username
                    AppTextField(
                      labelText: 'Username',
                      hintText: 'Choose a username',
                      controller: vm.usernameController,
                      errorText: vm.usernameError,
                      enabled: !vm.isLoading,
                    ),
                    const SizedBox(height: 16.0),

                    // Password
                    AppTextField(
                      labelText: 'Password',
                      hintText: 'Choose password',
                      controller: vm.passwordController,
                      obscureText: true,
                      errorText: vm.passwordError,
                      enabled: !vm.isLoading,
                    ),
                    const SizedBox(height: 16.0),

                    // Confirm Password
                    AppTextField(
                      labelText: 'Confirm Password',
                      hintText: 'Retype password',
                      controller: vm.confirmPasswordController,
                      obscureText: true,
                      errorText: vm.confirmPasswordError,
                      enabled: !vm.isLoading,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 32.0),

                    // Submit registration
                    PrimaryButton(
                      text: 'Create Account',
                      isLoading: vm.isLoading,
                      // The button only enables once every validation rule passes
                      onPressed: vm.isFormValid ? () => _handleSignup(context) : null,
                      tooltip: vm.isFormValid
                          ? 'Press to register new account'
                          : 'Please fill in all fields correctly to enable signup',
                    ),
                    const SizedBox(height: 24.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            'Sign In',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.error.withValues(alpha: 0.15)
            : theme.colorScheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.error,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
