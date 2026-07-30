import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/utils/currency_formatter.dart';
import 'package:banking_app/core/utils/result.dart';
import 'package:banking_app/core/base/app_activity_notifier.dart';
import 'package:banking_app/features/auth/data/repository/auth_repository.dart';
import 'package:banking_app/features/auth/data/models/user_model.dart';
import 'package:banking_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:banking_app/features/auth/viewmodel/forgot_password_view_model.dart';
import 'package:banking_app/features/auth/viewmodel/signup_view_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppActivityNotifier extends Mock implements AppActivityNotifier {}

void main() {
  group('Validators Unit Tests', () {
    test('Email Validator validates standard email formats', () {
      expect(Validators.isValidEmail('test@example.com'), isTrue);
      expect(Validators.isValidEmail('user.name+tag@domain.co.uk'), isTrue);
      expect(Validators.isValidEmail('invalid-email'), isFalse);
      expect(Validators.isValidEmail('@domain.com'), isFalse);
      expect(Validators.isValidEmail(null), isFalse);
    });

    test('Password Validator validates banking rules', () {
      expect(Validators.isValidPassword('Pass123'), isTrue);
      expect(Validators.isValidPassword('pass123'), isFalse);
      expect(Validators.isValidPassword('PASS123'), isFalse);
      expect(Validators.isValidPassword('Password'), isFalse);
      expect(Validators.isValidPassword('Ps1'), isFalse);
      expect(Validators.isValidPassword(null), isFalse);
    });
  });

  group('Currency Formatter Unit Tests', () {
    test('Formats amount to Naira representation', () {
      final formatted = CurrencyFormatter.formatNaira(1250.50);
      expect(formatted, contains('1,250.50'));
      expect(formatted, contains('₦'));
    });

    test('Compact format removes decimals for whole numbers', () {
      final formattedCompact = CurrencyFormatter.formatNairaCompact(1000.0);
      expect(formattedCompact, contains('1,000'));
      expect(formattedCompact, isNot(contains('.00')));
    });
  });

  group('UserModel Unit Tests', () {
    test('toJson and fromJson serializations match', () {
      const user = UserModel(
        id: 'usr_abc',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        username: 'johndoe',
      );

      final json = user.toJson();
      final parsed = UserModel.fromJson(json);

      expect(parsed.id, 'usr_abc');
      expect(parsed.firstName, 'John');
      expect(parsed.lastName, 'Doe');
      expect(parsed.fullName, 'John Doe');
      expect(parsed.email, 'john@example.com');
      expect(parsed.username, 'johndoe');
    });
  });

  group('AuthViewModel Rate Limiting Unit Tests', () {
    late MockAuthRepository mockRepo;
    late MockAppActivityNotifier mockNotifier;
    late AuthViewModel viewModel;

    setUp(() {
      mockRepo = MockAuthRepository();
      mockNotifier = MockAppActivityNotifier();
      viewModel = AuthViewModel(
        authRepository: mockRepo,
        activityNotifier: mockNotifier,
      );
    });

    test('Initial states are clean and unlocked', () {
      expect(viewModel.isLockedOut, isFalse);
      expect(viewModel.failedAttempts, 0);
      expect(viewModel.rememberMe, isFalse);
      expect(viewModel.obscurePassword, isTrue);
    });

    test('Locks out user for 30s after 5 consecutive login failures', () async {
      // Mock repository response
      when(
        () => mockRepo.login(any(), any()),
      ).thenAnswer((_) async => const Failure('Invalid username or password'));

      viewModel.usernameController.text = 'user123';
      viewModel.passwordController.text = 'wrongPassword';

      // 1. Call login 4 times
      for (int i = 0; i < 4; i++) {
        final success = await viewModel.login();
        expect(success, isFalse);
        expect(viewModel.isLockedOut, isFalse);
        expect(viewModel.failedAttempts, i + 1);
      }

      // 2. Call login the 5th time -> triggers lockout
      final success = await viewModel.login();
      expect(success, isFalse);
      expect(viewModel.failedAttempts, 5);
      expect(viewModel.isLockedOut, isTrue);
      expect(viewModel.lockoutSecondsRemaining, 30);
      expect(viewModel.errorMessage, contains('locked for 30 seconds'));
    });
  });

  group('ForgotPasswordViewModel Unit Tests', () {
    late MockAuthRepository mockRepo;
    late ForgotPasswordViewModel viewModel;

    setUp(() {
      mockRepo = MockAuthRepository();
      viewModel = ForgotPasswordViewModel(authRepository: mockRepo);
    });

    test('Initial state is clean', () {
      expect(viewModel.isResetLinkSent, isFalse);
    });

    test('Invalid email validation returns false and sets error', () async {
      viewModel.emailController.text = 'invalidemail';
      final success = await viewModel.sendResetLink();
      expect(success, isFalse);
      expect(viewModel.isResetLinkSent, isFalse);
      expect(viewModel.errorMessage, 'Please enter a valid email address');
    });

    test('Valid email calls repo and sets isResetLinkSent to true', () async {
      when(() => mockRepo.requestPasswordReset(any()))
          .thenAnswer((_) async => const Success<void>(null));

      viewModel.emailController.text = 'user@example.com';
      final success = await viewModel.sendResetLink();
      expect(success, isTrue);
      expect(viewModel.isResetLinkSent, isTrue);
      expect(viewModel.isError, isFalse);
    });
  });

  group('SignupViewModel Unit Tests', () {
    late MockAuthRepository mockRepo;
    late MockAppActivityNotifier mockNotifier;
    late SignupViewModel viewModel;

    setUp(() {
      mockRepo = MockAuthRepository();
      mockNotifier = MockAppActivityNotifier();
      viewModel = SignupViewModel(authRepository: mockRepo, activityNotifier: mockNotifier);
    });

    test('Initial state is invalid and clean', () {
      expect(viewModel.isFormValid, isFalse);
      expect(viewModel.firstNameError, isNull);
      expect(viewModel.passwordError, isNull);
    });

    test('Validates required fields and email formats', () {
      // Trigger listener changes
      viewModel.firstNameController.text = 'George';
      expect(viewModel.firstNameError, isNull);

      viewModel.emailController.text = 'invalid-email';
      expect(viewModel.emailError, 'Invalid email format');

      viewModel.emailController.text = 'user@example.com';
      expect(viewModel.emailError, isNull);
    });

    test('Validates password rules and confirmation matches', () {
      viewModel.passwordController.text = '123';
      expect(viewModel.passwordError, contains('Min 6 characters'));

      viewModel.passwordController.text = 'Password123';
      expect(viewModel.passwordError, isNull);

      viewModel.confirmPasswordController.text = 'DifferentPass123';
      expect(viewModel.confirmPasswordError, 'Passwords do not match');

      viewModel.confirmPasswordController.text = 'Password123';
      expect(viewModel.confirmPasswordError, isNull);
    });

    test('Form is valid when all rules are satisfied', () {
      viewModel.firstNameController.text = 'George';
      viewModel.lastNameController.text = 'Ikwegbu';
      viewModel.emailController.text = 'user@example.com';
      viewModel.usernameController.text = 'george123';
      viewModel.passwordController.text = 'Password123';
      viewModel.confirmPasswordController.text = 'Password123';

      expect(viewModel.isFormValid, isTrue);
    });
  });
}
