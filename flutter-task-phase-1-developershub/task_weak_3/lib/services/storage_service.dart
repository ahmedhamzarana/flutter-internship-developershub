import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// StorageService - Handles secure local storage
/// Uses Flutter Secure Storage for sensitive data
class StorageService {
  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() {
    return _instance;
  }
  
  StorageService._internal();

  // Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage keys
  static const String _userTokenKey = 'user_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  /// Save user authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
  }

  /// Get user authentication token
  Future<String?> getToken() async {
    return await _storage.read(key: _userTokenKey);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Check if user is logged in (has token)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Delete specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
