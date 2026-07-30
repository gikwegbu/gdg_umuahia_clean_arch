import 'package:flutter/material.dart';

/// AppTextField wraps standard TextFormField with custom design system:
/// - Explicit labelling & helper states
/// - In-built support for visibility toggling in password/obscure mode
/// - High accessibility touch size (min 48px tap height)
class AppTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build the suffix icon, showing an obscure toggle button if widget.obscureText is true
    Widget? suffix;
    if (widget.obscureText) {
      suffix = Semantics(
        label: _obscured ? 'Show password text' : 'Hide password text',
        child: IconButton(
          icon: Icon(
            _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _obscured = !_obscured;
            });
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Accessible label reflecting current font size settings
        Text(
          widget.labelText,
          style: theme.textTheme.labelMedium?.copyWith(
            color: widget.errorText != null
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6.0),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 48.0, // Standard minimum target for inputs
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscured,
            enabled: widget.enabled,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: suffix,
              errorText: widget.errorText,
              errorStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? theme.colorScheme.surface
                  : theme.colorScheme.surface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
