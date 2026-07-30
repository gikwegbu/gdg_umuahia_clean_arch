# GDG Umuahia Clean Arch - Apex Banking App

A modern Flutter mobile banking application built using **MVVM Clean Architecture** with a **Feature-First folder structure**. This project utilizes **Provider** for reactive state management, **GetIt** for dependency injection, and **GoRouter** for declarative navigation.

---

## 🤝 Open Source Contributions & Roadmap

We welcome contributions from the community! If you are looking to collaborate:
1. Fork this repository and clone the app.
2. Open the comprehensive specifications file **`flutter-banking-app-prompt-pack.md`** to locate the requirements. Contributors can pick the next prompt/feature from this file and proceed with the implementation.
3. Implement the feature following the project's Clean Architecture & MVVM guidelines.
4. Submit a Pull Request (PR) targeting the **`develop`** branch for code review.
   - **Note for PRs**: In your PR description, please explicitly specify which prompt/feature you worked on, and mark it with a ✅ (for example, "Prompt 6: Home page greetings ✅") to indicate completion and update the roadmap checklist accordingly.

### Feature Roadmap Checklist
* [x] **Prompt 1**: Clean Architecture & folder layouts setup ✅
* [x] **Prompt 2**: Splash screen routing & onboarding state checks ✅
* [x] **Prompt 3**: 3-stage swipeable Onboarding screen flow ✅
* [x] **Prompt 4**: Authentication (Login layout & rate-limiting lockout) ✅
* [x] **Prompt 5**: Forgot Password (Recover forms & persistent confirmations) ✅
* [x] **Prompt 5b**: Signup & Registration inputs (Regex validation check & dynamic button enable) ✅
* [ ] **Prompt 6**: Home page greetings (dynamic system clock title) & notification center ☑️
* [ ] **Prompt 7**: Slidable balance, month spent, and limits cards carousel ☑️
* [ ] **Prompt 8**: Apex credit card banner with eye-reveal togglers & deposit/withdraw chips ☑️
* [ ] **Prompt 9**: Activity log overview list with "See all" log history redirects ☑️
* [ ] **Prompt 10**: Horizontal investment boxes (VC startups, VC humanoid robots) ☑️
* [ ] **Prompt 11**: Interactive Withdrawal bottom sheet with transparent Naira inputs & confetti ☑️
* [ ] **Prompt 12**: Interactive Deposit/Add Money flow sheet up to ₦5,000,000 ☑️
* [ ] **Prompt 13**: Profile dashboard with circle initials, settings list tiles, and logout triggers ☑️
* [ ] **Prompt 14**: Edit profile bottom sheet forms ☑️
* [x] **Prompt 15**: Unit tests for all completed components (Validators, Formatter, Auth VM rate lockout) ✅
* [x] **Prompt 16**: Comprehensive README setup ✅
* [x] **Prompt 17**: Git configuration & .gitignore setups ✅

---

## 🚀 Architecture & Folder Layout

The project follows a modular, feature-first structure that scales efficiently for large-scale production banking projects:

```
lib/
  ├── main.dart
  ├── app/
  │   ├── app.dart                   # MaterialApp.router config & global Provider setup
  │   └── router/
  │       └── app_router.dart        # GoRouter navigation paths, ShellRoutes & transitions
  ├── core/
  │   ├── base/                      # BaseViewModel, ViewState & global Activity event bus
  │   ├── di/
  │   │   └── service_locator.dart   # GetIt lazy singleton/factory dependency registrations
  │   ├── theme/
  │   │   ├── app_colors.dart        # Theme colors complying with AA accessibility standards
  │   │   ├── app_text_styles.dart   # Responsive typographic text scaling keys
  │   │   └── app_theme.dart         # Light & Dark ThemeData configurations
  │   ├── services/
  │   │   ├── local_storage_service.dart   # Hive local storage cache
  │   │   └── secure_storage_service.dart  # flutter_secure_storage encryption
  │   ├── utils/
  │   │   ├── currency_formatter.dart      # Naira formatting utilities
  │   │   ├── result.dart                  # Functional success/failure containers
  │   │   └── validators.dart              # Regex email & password validator policies
  │   └── widgets/
  │       ├── app_text_field.dart    # Accessible text form input with toggles
  │       └── primary_button.dart    # Accessible button with loading indicators
  └── features/
      ├── splash/                    # Splash onboarding routing checks
      ├── onboarding/                # PageView onboarding walkthrough (shown once)
      ├── auth/                      # Registration, sign-in, recovery states
      │   ├── data/                  # UserModel & AuthRepository (impl + mock)
      │   ├── viewmodel/             # Login, Signup & ForgotPassword ViewModels
      │   └── view/                  # Sign-in form, recovery success screen, registration inputs
      ├── home/                      # Dashboard scaffold placeholder
      ├── profile/                   # User profile scaffold placeholder
      └── nav_shell/                 # Tab branch IndexedStack shell (Home & Profile)
```

---

## 🔑 Mock Credentials (Access Info)

Use any of these pre-seeded credentials in the mock repository to log in:

### Account Option 1
* **Username:** `user123` (or Email: `user@example.com`)
* **Password:** `Password1`

### Account Option 2
* **Username:** `apexuser` (or Email: `customer@apex.com`)
* **Password:** `Password1`

---

## 🛠️ Verification & Test Suites

Ensure all features compile cleanly and meet constraints:

```bash
# Verify static analysis and syntax lints
flutter analyze

# Execute all units & ViewModel rate-limiting lockout tests
flutter test
```
