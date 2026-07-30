import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/primary_button.dart';
import '../model/onboarding_page_model.dart';
import '../viewmodel/onboarding_view_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<OnboardingViewModel>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleSkip(BuildContext context) async {
    final success = await _viewModel.skip();
    if (success && context.mounted) {
      context.go('/login');
    }
  }

  Future<void> _handleNext(BuildContext context) async {
    if (_viewModel.isLastPage) {
      final success = await _viewModel.complete();
      if (success && context.mounted) {
        context.go('/login');
      }
    } else {
      _viewModel.next(_pageController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<OnboardingViewModel>.value(
      value: _viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                if (!vm.isLastPage)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Semantics(
                      button: true,
                      label: 'Skip onboarding presentation',
                      child: TextButton(
                        onPressed: () => _handleSkip(context),
                        child: Text(
                          'Skip',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: vm.pages.length,
                      onPageChanged: vm.setIndex,
                      itemBuilder: (context, index) {
                        final page = vm.pages[index];
                        return _buildPageLayout(context, page);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPageIndicators(vm.pages.length, vm.currentIndex, theme),
                        const SizedBox(height: 32.0),
                        PrimaryButton(
                          text: vm.isLastPage ? 'Continue' : 'Next',
                          tooltip: vm.isLastPage
                              ? 'Complete introduction and go to login'
                              : 'Go to next onboarding page',
                          onPressed: () => _handleNext(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageLayout(BuildContext context, OnboardingPageModel page) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon placeholder vector
                  Semantics(
                    label: 'Onboarding page graphic representation',
                    child: Icon(
                      page.icon,
                      size: 100.0,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  // Title text
                  Text(
                    page.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  // Scrollable/scalable description text
                  Text(
                    page.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicators(int count, int current, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 16.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
