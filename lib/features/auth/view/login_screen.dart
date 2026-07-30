import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodel/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<AuthViewModel>();
  }

  Future<void> _handleLogin(BuildContext context) async {
    final success = await _viewModel.login();
    if (success && context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<AuthViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (context, vm, child) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24.0),
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Enter your credentials to access your secure dashboard.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32.0),

                    // Inline Error Banner Region
                    if (vm.isError && vm.errorMessage != null) ...[
                      _buildErrorBanner(context, vm.errorMessage!),
                      const SizedBox(height: 20.0),
                    ],

                    // Username Input
                    AppTextField(
                      labelText: 'Username or Email',
                      hintText: 'e.g. user123 or user@example.com',
                      controller: vm.usernameController,
                      enabled: !vm.isLockedOut,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),

                    // Password Input
                    AppTextField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      controller: vm.passwordController,
                      obscureText: true,
                      enabled: !vm.isLockedOut,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12.0),

                    // Remember Me Option
                    Row(
                      children: [
                        SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Checkbox(
                            value: vm.rememberMe,
                            activeColor: theme.colorScheme.primary,
                            onChanged: vm.isLockedOut
                                ? null
                                : (value) {
                                    if (value != null) {
                                      vm.setRememberMe(value);
                                    }
                                  },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: vm.isLockedOut
                              ? null
                              : () => vm.setRememberMe(!vm.rememberMe),
                          child: Text(
                            'Remember me',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // Submit Trigger
                    PrimaryButton(
                      text: 'Sign In',
                      isLoading: vm.isLoading,
                      onPressed: vm.isLockedOut ? null : () => _handleLogin(context),
                      tooltip: vm.isLockedOut
                          ? 'Login locked out'
                          : 'Press to authenticate credentials',
                    ),
                    const SizedBox(height: 16.0),

                    // Navigation routes
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: vm.isLockedOut ? null : () => context.push('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: vm.isLockedOut ? null : () => context.push('/signup'),
                          child: Text(
                            'Sign Up',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
