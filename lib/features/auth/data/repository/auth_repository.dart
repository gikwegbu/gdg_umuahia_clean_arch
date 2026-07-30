import '../../../../core/utils/result.dart';
import '../models/user_model.dart';

/// AuthRepository defines the abstract data layer interface for user login tasks.
abstract class AuthRepository {
  /// Executes login using username (or email) and password.
  /// Returns [Success<UserModel>] on validation success or [Failure] for invalid inputs.
  Future<Result<UserModel>> login(String username, String password);

  /// Requests a password reset link for the given [email].
  /// Returns [Success<void>] or [Failure] if the email is invalid.
  Future<Result<void>> requestPasswordReset(String email);

  /// Registers a new user.
  /// Returns [Success<UserModel>] on success or [Failure] on failure.
  Future<Result<UserModel>> signup(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
  );
}
