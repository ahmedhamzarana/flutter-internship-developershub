import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _userTokenKey = 'user_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _userTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
