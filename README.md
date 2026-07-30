# GDG Umuahia Clean Arch - Apex Banking App

A modern Flutter mobile banking application built using **MVVM Clean Architecture** with a **Feature-First folder structure**. This project utilizes **Provider** for reactive state management, **GetIt** for dependency injection, and **GoRouter** for declarative navigation.

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

## 🌟 Key Features Completed

### 1. Splash & Routing
* Auto-checks secure storage for session keys and Hive cache for onboarding state.
* Redirects automatically to the appropriate screen: first-launch Onboarding, Login screen, or Home dashboard.
* Includes a static boolean flag `forceShowOnboarding` in `SplashViewModel` for toggling onboarding visibility during design sessions.

### 2. Form Input Validations & Rate Limiting
* **Signup Form**: Checks fields reactively on change (Email regex, password complexity rules). Automatically enables the "Create Account" button only when the form satisfies validation rules.
* **Forgot Password View**: Replaces input forms on success with a persistent checkmark confirmation pane to replace transient snackbars.
* **Security Lockout**: Tracks consecutive failed logins. On the 5th failed attempt, the ViewModel initiates a 30-second countdown lock, disables inputs, and displays live countdown warning messages.

### 3. Responsive Styling & Screen Layouts
* Supports system accessibility text font scaling. Views wrap inside `SingleChildScrollView` containers to prevent viewport overflows.
* Follows AA color contrast compliance in light/dark themes.

---

## 🛠️ Verification & Test Suites

Ensure all features compile cleanly and meet constraints:

```bash
# Verify static analysis and syntax lints
flutter analyze

# Execute all units & ViewModel rate-limiting lockout tests
flutter test
```
