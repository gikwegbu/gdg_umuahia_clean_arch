import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SecureStorageService provides encryption-backed key-value storage
/// for tokens, passwords, and sensitive session details.
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'auth_session_token';
  static const String _userPinKey = 'auth_user_pin';

  /// Saves the active authentication session token.
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the active authentication session token.
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Clears the active authentication session token.
  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Saves the user's quick-login transaction PIN.
  Future<void> saveUserPin(String pin) async {
    await _secureStorage.write(key: _userPinKey, value: pin);
  }

  /// Retrieves the user's quick-login transaction PIN.
  Future<String?> getUserPin() async {
    return await _secureStorage.read(key: _userPinKey);
  }

  /// Clears the stored user PIN.
  Future<void> clearUserPin() async {
    await _secureStorage.delete(key: _userPinKey);
  }

  /// Clears all encrypted fields stored securely.
  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }
}
