import 'package:app_links/app_links.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swiftcel/core/routing/app_router.dart';
import 'package:swiftcel/core/services/firebase_service.dart';
import 'package:swiftcel/core/theme/app_theme.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';
import 'firebase_options.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver analyticsObserver = FirebaseAnalyticsObserver(
  analytics: analytics,
);

Future<void> _handleInitialAppLink() async {
  final appLinks = AppLinks();
  final initialUri = await appLinks.getInitialLink();

  if (initialUri != null) {
    final service = AppFirebaseService();
    try {
      await service.handleEmailVerificationLink(initialUri);
    } catch (_) {
      // Ignore deep-link verification failures here; the user stays on the app and can retry.
    }
  }

  appLinks.uriLinkStream.listen((uri) async {
    final service = AppFirebaseService();
    try {
      await service.handleEmailVerificationLink(uri);
    } catch (_) {
      // Ignore deep-link verification failures here; the user stays on the app and can retry.
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _handleInitialAppLink();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(AppFirebaseService());
    _router = AppRouter.router(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authProvider,
      child: MaterialApp.router(
        title: 'SwiftCel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
