import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  static bool isEmailVerificationLink(Uri uri) {
    final isFirebaseActionPath = uri.path == '/__/auth/action';
    final isFirebaseLinksPath = uri.path == '/__/auth/links';
    final isCustomVerifyPath = uri.path == '/verify-email';

    if (isFirebaseActionPath || isCustomVerifyPath) {
      return uri.queryParameters['mode'] == 'verifyEmail' &&
          uri.queryParameters.containsKey('oobCode');
    }

    if (isFirebaseLinksPath) {
      final linkValue = uri.queryParameters['link'];
      if (linkValue == null || linkValue.isEmpty) return false;

      final nestedUri = Uri.tryParse(linkValue);
      if (nestedUri == null) return false;

      return nestedUri.path == '/__/auth/action' &&
          nestedUri.queryParameters['mode'] == 'verifyEmail' &&
          nestedUri.queryParameters.containsKey('oobCode');
    }

    return false;
  }

  static String? extractActionCode(Uri uri) {
    if (uri.path == '/__/auth/action' || uri.path == '/verify-email') {
      if (uri.queryParameters['mode'] == 'verifyEmail') {
        return uri.queryParameters['oobCode'];
      }
      return null;
    }

    if (uri.path == '/__/auth/links') {
      final linkValue = uri.queryParameters['link'];
      if (linkValue == null || linkValue.isEmpty) return null;

      final nestedUri = Uri.tryParse(linkValue);
      if (nestedUri == null) return null;

      if (nestedUri.path == '/__/auth/action' &&
          nestedUri.queryParameters['mode'] == 'verifyEmail') {
        return nestedUri.queryParameters['oobCode'];
      }
    }

    return null;
  }

  Future<bool> handleEmailVerificationLink(Uri uri) async {
    final actionCode = extractActionCode(uri);
    if (actionCode == null) return false;

    try {
      await _auth.applyActionCode(actionCode);
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://swiftcel0.web.app/verify-email',
      handleCodeInApp: true,
      androidPackageName: 'com.example.swiftcel',
      androidInstallApp: true,
      androidMinimumVersion: '1',
      iOSBundleId: 'com.example.swiftcel',
    );
    await _auth.currentUser?.sendEmailVerification(actionCodeSettings);
  }

  Future<void> createUserDoc({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String role, // 'sender' | 'rider'
  }) {
    return _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  }
}
