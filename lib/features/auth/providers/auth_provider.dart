import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final AppFirebaseService _firebaseService;

  AuthProvider(this._firebaseService) {
    _init();
  }

  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _hasSeenOnboarding = false;
  String? _userRole; // 'sender' | 'rider'
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  String? get userRole => _userRole;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    _firebaseService.authStateChanges.listen((user) async {
      if (user != null) {
        _isLoggedIn = true;
        _userRole = await _firebaseService.getUserRole(user.uid);
      } else {
        _isLoggedIn = false;
        _userRole = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  String _mapFirebaseError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'configuration-not-found':
        return 'Firebase Auth is not configured for this app. Enable Email/Password auth in Firebase Console and regenerate the Firebase config.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      default:
        return exception.message ??
            'Unable to create account. Please try again.';
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cred = await _firebaseService.signUp(
        email: email,
        password: password,
      );
      await _firebaseService.createUserDoc(
        uid: cred.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
      );
      await _firebaseService.sendEmailVerification();
      _userRole = role;
      _isLoggedIn = true;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e);
      return false;
    } catch (e) {
      _errorMessage = 'Unable to create account. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cred = await _firebaseService.signIn(
        email: email,
        password: password,
      );
      _userRole = await _firebaseService.getUserRole(cred.user!.uid);
      _isLoggedIn = true;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e);
      return false;
    } catch (e) {
      _errorMessage = 'Unable to log in. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _firebaseService.signOut();
    _isLoggedIn = false;
    _userRole = null;
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      await _firebaseService.sendPasswordResetEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e);
      return false;
    } catch (e) {
      _errorMessage = 'Unable to send password reset email.';
      return false;
    }
  }
}
