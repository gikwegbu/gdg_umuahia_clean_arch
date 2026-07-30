import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/service_locator.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<SplashViewModel>();
    _startSessionCheck();
  }

  Future<void> _startSessionCheck() async {
    // Wait for the branded splash duration and the checks to complete
    final startTime = DateTime.now();
    
    final targetRoute = await _viewModel.getNavigationTarget();
    
    final elapsedTime = DateTime.now().difference(startTime);
    final remainingDelay = AppDurations.splashDelay - elapsedTime;
    
    if (remainingDelay > Duration.zero) {
      await Future.delayed(remainingDelay);
    }

    if (mounted) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<SplashViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: theme.brightness == Brightness.light
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Brand text
              Semantics(
                label: 'Apex Banking App Logo',
                child: Text(
                  AppStrings.appName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              // Circular progress indicator matching contrast rules
              const SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
