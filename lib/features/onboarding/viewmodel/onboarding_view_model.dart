import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/local_storage_service.dart';
import '../model/onboarding_page_model.dart';

class OnboardingViewModel extends BaseViewModel {
  final LocalStorageService _localStorageService;

  OnboardingViewModel({
    LocalStorageService? localStorageService,
  }) : _localStorageService = localStorageService ?? locator<LocalStorageService>();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<OnboardingPageModel> pages = OnboardingPageModel.pages;

  /// Exposes if we are currently looking at the final slide.
  bool get isLastPage => _currentIndex == pages.length - 1;

  /// Updates the internal index. Called from PageView.onPageChanged.
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Slides the PageView page controller forward, or calls complete if at the end.
  void next(PageController controller) {
    if (isLastPage) {
      complete();
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skips onboarding directly, writing to Hive and signaling target navigation.
  Future<bool> skip() async {
    return await _saveOnboardingCompleted();
  }

  /// Completes onboarding on final page, writing to Hive and signaling target navigation.
  Future<bool> complete() async {
    return await _saveOnboardingCompleted();
  }

  Future<bool> _saveOnboardingCompleted() async {
    setState(ViewState.loading);
    try {
      await _localStorageService.put<bool>('onboarding_completed', true);
      setState(ViewState.success);
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}
