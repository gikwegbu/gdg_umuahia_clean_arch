import 'package:get_it/get_it.dart';
import '../services/local_storage_service.dart';
import '../services/secure_storage_service.dart';
import '../base/app_activity_notifier.dart';
import '../../features/splash/view_model/splash_view_model.dart';
import '../../features/onboarding/viewmodel/onboarding_view_model.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../../features/auth/viewmodel/forgot_password_view_model.dart';
import '../../features/auth/viewmodel/signup_view_model.dart';

/// Exposes the global service locator singleton instance.
final locator = GetIt.instance;

/// Sets up DI registrations. Called exactly once from main() before runApp.
Future<void> setupLocator() async {
  // Local storage service (initialized first to prepare cached preferences)
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  locator.registerSingleton<LocalStorageService>(localStorageService);

  // Secure storage service
  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // Cross-feature event bus activity notifier
  locator.registerLazySingleton<AppActivityNotifier>(
    () => AppActivityNotifier(),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // ViewModels
  locator.registerFactory<SplashViewModel>(() => SplashViewModel());
  locator.registerFactory<OnboardingViewModel>(() => OnboardingViewModel());
  locator.registerFactory<AuthViewModel>(() => AuthViewModel());
  locator.registerFactory<ForgotPasswordViewModel>(() => ForgotPasswordViewModel());
  locator.registerFactory<SignupViewModel>(() => SignupViewModel());
}
