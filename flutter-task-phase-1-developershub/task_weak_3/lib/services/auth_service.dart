import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

/// AuthService - Handles all Firebase Authentication operations
class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Storage service
  final StorageService _storage = StorageService();

  // Get current user stream
  Stream<User?> get authStream => _auth.authStateChanges();

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// Register a new user with email and password
  /// Returns UserModel if successful, null otherwise
  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Create user model
        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

        // Save to secure storage
        await _storage.saveToken(await user.getIdToken() ?? '');
        await _storage.saveUserId(user.uid);
        await _storage.saveUserEmail(email);

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Login user with email and password
  /// Returns UserModel if successful, null otherwise
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Get user data from Firestore
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          final userModel = UserModel.fromMap(doc.data()!, doc.id);
          
          // Save to secure storage
          await _storage.saveToken(await user.getIdToken() ?? '');
          await _storage.saveUserId(user.uid);
          await _storage.saveUserEmail(email);

          return userModel;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      // Clear secure storage
      await _storage.clearAll();
      
      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Reset password for user
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete from Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        
        // Delete user from Firebase Auth
        await user.delete();
        
        // Clear storage
        await _storage.clearAll();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Handle Firebase Auth exceptions and return user-friendly messages
  Exception _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = 'The password provided is too weak. Use at least 6 characters.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists for that email.';
        break;
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'user-disabled':
        message = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Try again later.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection.';
        break;
      default:
        message = e.message ?? 'An error occurred.';
    }
    return Exception(message);
  }
}
