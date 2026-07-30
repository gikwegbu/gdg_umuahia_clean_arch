import '../../../core/base/base_view_model.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/secure_storage_service.dart';

class SplashViewModel extends BaseViewModel {
  /// Toggle this to [true] to force the onboarding flow to show every time on app startup.
  static const bool forceShowOnboarding = false;

  final LocalStorageService _localStorageService;
  final SecureStorageService _secureStorageService;

  SplashViewModel({
    LocalStorageService? localStorageService,
    SecureStorageService? secureStorageService,
  }) : _localStorageService =
           localStorageService ?? locator<LocalStorageService>(),
       _secureStorageService =
           secureStorageService ?? locator<SecureStorageService>();

  /// Resolves the destination path based on the user's session state.
  /// - Returns `/onboarding` if they haven't completed onboarding or if forced.
  /// - Returns `/home` if they have a valid secure auth session token.
  /// - Returns `/login` if unauthenticated.
  Future<String> getNavigationTarget() async {
    setState(ViewState.loading);
    try {
      // 1. Check if onboarding should be shown (either forced or because it is uncompleted)
      final onboardingCompleted =
          _localStorageService.get<bool>('onboarding_completed') ?? false;
      if (forceShowOnboarding || !onboardingCompleted) {
        setState(ViewState.success);
        return '/onboarding';
      }

      // 2. Check if a secure session token is saved
      final token = await _secureStorageService.getToken();
      setState(ViewState.success);
      if (token != null && token.isNotEmpty) {
        return '/home';
      }

      return '/login';
    } catch (e) {
      setError(e.toString());
      return '/login';
    }
  }
}
