import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// SectionHeader displays a section title with an optional trailing action button.
/// Typically used to separate content blocks on screens like Dashboard or History.
class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText = AppStrings.seeAll,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onActionPressed != null)
          Semantics(
            button: true,
            label: '$actionText for $title',
            child: Tooltip(
              message: '$actionText for $title',
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 48.0, // Assures accessibility touch height
                ),
                child: TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  ),
                  child: Text(
                    actionText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
