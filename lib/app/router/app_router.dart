import 'package:go_router/go_router.dart';
import '../../features/splash/view/splash_view.dart';
import '../../features/onboarding/view/onboarding_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/signup_screen.dart';
import '../../features/auth/view/forgot_password_view.dart';
import '../../features/home/view/home_view.dart';
import '../../features/profile/view/profile_view.dart';
import '../../features/nav_shell/view/nav_shell.dart';

/// AppRouter defines path and name constants and constructs the GoRouter instance.
abstract class AppRouter {
  // Paths
  static const String splashPath = '/splash';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String forgotPasswordPath = '/forgot-password';
  static const String homePath = '/home';
  static const String profilePath = '/profile';

  // Names
  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String forgotPasswordName = 'forgotPassword';
  static const String homeName = 'home';
  static const String profileName = 'profile';

  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    routes: [
      GoRoute(
        path: splashPath,
        name: splashName,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: onboardingPath,
        name: onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: loginPath,
        name: loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signupPath,
        name: signupName,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: forgotPasswordPath,
        name: forgotPasswordName,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      // Stateful shell routing to persist tab scroll/stack states
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homePath,
                name: homeName,
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                name: profileName,
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
