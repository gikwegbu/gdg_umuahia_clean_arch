import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodel/forgot_password_view_model.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final ForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<ForgotPasswordViewModel>();
  }

  @override
  void dispose() {
    // Avoid double disposing VM if handled by Provider factory,
    // but since we register as factory in locator and fetch manually,
    // we should dispose it if we manage it here.
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    await _viewModel.sendResetLink();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer<ForgotPasswordViewModel>(
            builder: (context, vm, child) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: vm.isResetLinkSent
                      ? _buildSuccessState(context, vm)
                      : _buildFormState(context, vm),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context, ForgotPasswordViewModel vm) {
    final theme = Theme.of(context);

    return Column(
      key: const ValueKey('form_state'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16.0),
        Text(
          'Recover Password',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12.0),
        Text(
          'Enter your email address and we will search for an account to send a reset link.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32.0),

        // Inline Error Banner
        if (vm.isError && vm.errorMessage != null) ...[
          _buildErrorBanner(context, vm.errorMessage!),
          const SizedBox(height: 20.0),
        ],

        AppTextField(
          labelText: 'Email Address',
          hintText: 'e.g. john@example.com',
          controller: vm.emailController,
          enabled: !vm.isLoading,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 32.0),

        PrimaryButton(
          text: 'Send reset link',
          isLoading: vm.isLoading,
          onPressed: _handleSubmit,
          tooltip: 'Press to send password recovery email link',
        ),
        const SizedBox(height: 24.0),

        Center(
          child: TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              'Back to login',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, ForgotPasswordViewModel vm) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final successColor = isDark ? AppColors.successDark : AppColors.successLight;

    return Column(
      key: const ValueKey('success_state'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40.0),
        Semantics(
          label: 'Success confirmation checkmark',
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 64.0,
                color: successColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32.0),
        Text(
          'Email Sent Successfully',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        Text(
          'If an account exists for this email, a reset link has been sent.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48.0),
        PrimaryButton(
          text: 'Back to login',
          onPressed: () {
            context.pop();
          },
          tooltip: 'Return to login screen',
        ),
        const SizedBox(height: 16.0),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                vm.resetState();
              });
            },
            child: Text(
              'Resend reset link',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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
