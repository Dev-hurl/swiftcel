import 'package:flutter_test/flutter_test.dart';
import 'package:swiftcel/core/services/firebase_service.dart';

void main() {
  test('extracts Firebase email verification action code from deep link', () {
    final uri = Uri.parse(
      'https://swiftcel0.web.app/__/auth/action?mode=verifyEmail&oobCode=test-action-code-123&apiKey=demo',
    );

    expect(AppFirebaseService.isEmailVerificationLink(uri), isTrue);
    expect(AppFirebaseService.extractActionCode(uri), 'test-action-code-123');
  });

  test('accepts a custom verify-email route used by in-app email verification links', () {
    final uri = Uri.parse(
      'https://swiftcel0.web.app/verify-email?mode=verifyEmail&oobCode=custom-route-code-456',
    );

    expect(AppFirebaseService.isEmailVerificationLink(uri), isTrue);
    expect(AppFirebaseService.extractActionCode(uri), 'custom-route-code-456');
  });

  test('accepts Firebase default action route for verifyEmail', () {
    final uri = Uri.parse(
      'https://swiftcel0.web.app/__/auth/action?mode=verifyEmail&oobCode=firebase-action-code-789',
    );

    expect(AppFirebaseService.isEmailVerificationLink(uri), isTrue);
    expect(AppFirebaseService.extractActionCode(uri), 'firebase-action-code-789');
  });

  test('accepts Firebase nested auth links format used by firebaseapp.com', () {
    final uri = Uri.parse(
      'https://swiftcel0.firebaseapp.com/__/auth/links?link=https%3A%2F%2Fswiftcel0.firebaseapp.com%2F__%2Fauth%2Faction%3Fmode%3DverifyEmail%26oobCode%3Dfirebase-nested-code-321',
    );

    expect(AppFirebaseService.isEmailVerificationLink(uri), isTrue);
    expect(AppFirebaseService.extractActionCode(uri), 'firebase-nested-code-321');
  });

  test('returns null when deep link is not an email verification link', () {
    final uri = Uri.parse('https://swiftcel0.web.app/some-other-path?foo=bar');

    expect(AppFirebaseService.isEmailVerificationLink(uri), isFalse);
    expect(AppFirebaseService.extractActionCode(uri), isNull);
  });
}
