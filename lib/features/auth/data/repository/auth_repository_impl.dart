import '../../../../core/constants/app_durations.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// AuthRepositoryImpl provides a mock mock-network implementation of [AuthRepository].
/// It validates against seeded mock users, persists user tokens to SecureStorage,
/// and caches user profiles to LocalStorage (Hive).
class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageService _localStorage;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl({
    LocalStorageService? localStorage,
    SecureStorageService? secureStorage,
  })  : _localStorage = localStorage ?? locator<LocalStorageService>(),
        _secureStorage = secureStorage ?? locator<SecureStorageService>();

  // In-memory seeded database users
  static final List<UserModel> _seededUsers = [
    const UserModel(
      id: 'usr_001',
      firstName: 'George',
      lastName: 'Ikwegbu',
      email: 'user@example.com',
      username: 'user123',
    ),
    const UserModel(
      id: 'usr_002',
      firstName: 'Apex',
      lastName: 'Customer',
      email: 'customer@apex.com',
      username: 'apexuser',
    ),
  ];

  @override
  Future<Result<UserModel>> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(AppDurations.mockNetworkDelay);

    try {
      // Clean inputs
      final cleanUsername = username.trim().toLowerCase();

      // Find user matching username or email
      final user = _seededUsers.firstWhere(
        (u) =>
            u.username.toLowerCase() == cleanUsername ||
            u.email.toLowerCase() == cleanUsername,
        orElse: () => throw Exception('User not found'),
      );

      // Validate password (seeded password is "Password1" for both users)
      if (password != 'Password1') {
        return const Failure('Invalid username or password');
      }

      // Login success: persist credentials
      // 1. Save token securely
      final mockToken = 'session_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
      await _secureStorage.saveToken(mockToken);

      // 2. Cache user profile locally as a JSON map
      await _localStorage.put<Map<String, dynamic>>('user_profile', user.toJson());

      return Success(user);
    } catch (_) {
      return const Failure('Invalid username or password');
    }
  }

  @override
  Future<Result<void>> requestPasswordReset(String email) async {
    // Simulate network delay
    await Future.delayed(AppDurations.mockNetworkDelay);

    final cleanEmail = email.trim();
    if (!Validators.isValidEmail(cleanEmail)) {
      return const Failure('Please enter a valid email address');
    }

    // Always succeed for any syntactically valid email in mock implementation
    return const Success<void>(null);
  }

  @override
  Future<Result<UserModel>> signup(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(AppDurations.mockNetworkDelay);

    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanUsername = username.trim().toLowerCase();

      // Check if user already exists
      final exists = _seededUsers.any(
        (u) =>
            u.username.toLowerCase() == cleanUsername ||
            u.email.toLowerCase() == cleanEmail,
      );

      if (exists) {
        return const Failure('Username or email already exists');
      }

      // Create new user model
      final newUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: cleanEmail,
        username: cleanUsername,
      );

      // Add to list
      _seededUsers.add(newUser);

      // Persist session details identically to login
      final mockToken = 'session_token_${newUser.id}_${DateTime.now().millisecondsSinceEpoch}';
      await _secureStorage.saveToken(mockToken);
      await _localStorage.put<Map<String, dynamic>>('user_profile', newUser.toJson());

      return Success(newUser);
    } catch (e) {
      return Failure('Signup failed: ${e.toString()}');
    }
  }
}
