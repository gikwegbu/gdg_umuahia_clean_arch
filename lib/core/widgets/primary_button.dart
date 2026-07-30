import 'package:flutter/material.dart';

/// PrimaryButton is a standard custom button featuring:
/// - Loading states with a CircularProgressIndicator
/// - Disabled states (styling + disabled clicks)
/// - Flexible height through padding (to avoid clipping under large system font scaling)
/// - Minimum 48px tap targets matching accessibility guidelines.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? tooltip;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isButtonEnabled = onPressed != null && !isLoading;

    final childWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isButtonEnabled
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
    );

    // Elevated button with custom style
    final button = ElevatedButton(
      onPressed: isButtonEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        disabledBackgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
        elevation: isButtonEnabled ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        // Use padding instead of fixed height constraints to allow text-scaling expansion
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
      ),
      child: childWidget,
    );

    // Apply semantics and tooltip for accessibility support
    return Semantics(
      button: true,
      enabled: isButtonEnabled,
      label: tooltip ?? text,
      child: Tooltip(
        message: tooltip ?? text,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 48.0, // Ensures minimum 48x48 touch target
          ),
          child: button,
        ),
      ),
    );
  }
}
