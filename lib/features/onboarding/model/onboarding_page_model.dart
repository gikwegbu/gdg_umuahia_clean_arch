import 'package:flutter/material.dart';

/// OnboardingPageModel represents a single presentation slide in the onboarding flow.
class OnboardingPageModel {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Exposes the static preloaded onboarding pages sequence.
  static List<OnboardingPageModel> get pages => const [
        OnboardingPageModel(
          title: 'Premium Digital Banking',
          description: 'Manage accounts, execute safe transfers, and trace expenses with state of the art tools.',
          icon: Icons.account_balance_wallet_outlined,
        ),
        OnboardingPageModel(
          title: 'Smart Spending Analysis',
          description: 'Visualize investments and monthly targets with automated notifications and details.',
          icon: Icons.analytics_outlined,
        ),
        // Verification of font-scaling friendly layouts (long desc)
        OnboardingPageModel(
          title: 'Secure Encrypted Storage',
          description: 'Protected credentials using secure storage. Enjoy peace of mind knowing that authorization keys, logs, and tokens are protected with industry-standard patterns.',
          icon: Icons.security_outlined,
        ),
      ];
}
