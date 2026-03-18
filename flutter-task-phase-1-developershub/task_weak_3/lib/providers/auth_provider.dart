import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCheckingAuth = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get errorMessage => _errorMessage;
  String? get userId => _user?.id;
  bool get isCheckingAuth => _isCheckingAuth;

  Future<void> initialize() async {
    try {
      _isCheckingAuth = true;
      _notifySafely();

      final isLoggedIn = await _storage.isLoggedIn();
      if (isLoggedIn) {
        final uid = await _storage.getUserId();
        if (uid != null) {
          _user = await _authService.getUserData(uid);
        }
      }

      _isCheckingAuth = false;
      _errorMessage = null;
      _notifySafely();
    } catch (e) {
      _isCheckingAuth = false;
      _errorMessage = 'Failed to initialize auth: $e';
      _notifySafely();
    }
  }

  void listenToAuthChanges() {
    _authService.authStream.listen((firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser.uid);
      } else {
        _user = null;
        _isLoading = false;
        _notifySafely();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _isLoading = true;
      _notifySafely();

      _user = await _authService.getUserData(uid);

      _isLoading = false;
      _errorMessage = null;
      _notifySafely();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load user data: $e';
      _notifySafely();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _notifySafely();

      final loggedInUser = await _authService.login(
        email: email,
        password: password,
      );

      if (loggedInUser != null) {
        _user = loggedInUser;
        _isLoading = false;
        _notifySafely();
        return true;
      }

      _isLoading = false;
      _notifySafely();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _notifySafely();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _notifySafely();

      final newUser = await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      if (newUser != null) {
        _user = newUser;
        _isLoading = false;
        _notifySafely();
        return true;
      }

      _isLoading = false;
      _notifySafely();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _notifySafely();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      _notifySafely();
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      _notifySafely();
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      _user = null;
      _notifySafely();
    } catch (e) {
      _errorMessage = 'Account deletion failed: $e';
      _notifySafely();
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _authService.resetPassword(email: email);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _notifySafely();
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    _notifySafely();
  }

  Future<void> updateProfile({String? name, String? email}) async {
    try {
      if (_user == null) return;

      _isLoading = true;
      _notifySafely();

      final updatedUser = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
      );

      _user = updatedUser;
      _isLoading = false;
      _errorMessage = null;
      _notifySafely();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update profile: $e';
      _notifySafely();
    }
  }

  void _notifySafely() {
    Future.microtask(() {
      notifyListeners();
    });
  }
}
