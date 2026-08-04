import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/features/auth/presentation/screens/forgot_password.dart';
import 'package:swiftcel/features/auth/presentation/screens/login_screen.dart';
import 'package:swiftcel/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:swiftcel/features/auth/presentation/screens/signup_screen.dart';
import 'package:swiftcel/features/auth/presentation/screens/splash_screen.dart';
import 'package:swiftcel/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';
import 'package:swiftcel/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:swiftcel/features/chat/presentation/screens/chat_screen.dart';
import 'package:swiftcel/features/notifications/presentation/screens/notification_screen.dart';
import 'package:swiftcel/features/profile/presentation/screens/edit_profile.dart';
import 'package:swiftcel/features/profile/presentation/screens/profile_screen.dart';
import 'package:swiftcel/features/rider/presentation/screens/delivery_history.dart';
import 'package:swiftcel/features/rider/presentation/screens/document_verification.dart';
import 'package:swiftcel/features/rider/presentation/screens/earning_screen.dart';
import 'package:swiftcel/features/rider/presentation/screens/job_details_screen.dart';
import 'package:swiftcel/features/rider/presentation/screens/rider_home.dart';
import 'package:swiftcel/features/rider/presentation/screens/withdraw_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/create_delivery_address_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/create_delivery_parcel_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/create_delivery_review_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/order_history_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/payment_methods.dart';
import 'package:swiftcel/features/sender/presentation/screens/saved_addresses_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/sender_home.dart';
import 'package:swiftcel/features/support/presentation/screens/support_screen.dart';

class AppRouter {
  static const bool debugMode = true;
  static const String debugInitialLocation = '/signup';

  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: debugMode ? debugInitialLocation : '/rider/home',
      refreshListenable: authProvider,
      redirect: (context, state) {
        if (debugMode) return null;
        return _redirect(context, state, authProvider);
      },
      routes: [
        // ---- Auth flow (outside any shell) ----
        GoRoute(path: '/splash', builder: (_, _) => SplashScreen()),
        GoRoute(path: '/onboarding', builder: (_, _) => OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, _) => LoginScreen()),
        GoRoute(path: '/signup', builder: (_, _) => SignupScreen()),
        GoRoute(
          path: '/verify-email',
          builder: (_, state) =>
              VerifyEmailScreen(email: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (_, _) => ForgotPasswordScreen(),
        ),

        // ---- Shared routes (pushed on top, either role) ----
        GoRoute(path: '/edit-profile', builder: (_, _) => EditProfile()),
        GoRoute(
          path: '/notifications',
          builder: (_, _) => NotificationsScreen(),
        ),
        GoRoute(
          path: '/chat/:chatId',
          builder: (_, state) =>
              ChatScreen(chatId: state.pathParameters['chatId']!),
        ),
        GoRoute(path: '/support', builder: (_, _) => SupportScreen()),

        // ---- Sender shell (bottom nav: Home, History, Chat, Profile) ----
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              SenderShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: '/sender/home', builder: (_, _) => SenderHome()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/sender/history',
                  builder: (_, _) => OrderHistoryScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/sender/chat',
                  builder: (_, _) => ChatListScreen(),
                ), // NEW — see note below
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/sender/profile',
                  builder: (_, _) => ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        // ---- Sender pushed routes (not tabs) ----
        GoRoute(
          path: '/sender/create-delivery/address',
          builder: (_, _) => CreateDeliveryAddressScreen(),
        ),
        GoRoute(
          path: '/sender/create-delivery/parcel',
          builder: (_, _) => CreateDeliveryParcelScreen(),
        ),
        GoRoute(
          path: '/sender/create-delivery/review',
          builder: (_, _) => CreateDeliveryReviewScreen(),
        ),
        /*GoRoute(
          path: '/sender/finding-rider/:deliveryId',
          builder: (_, state) =>
              FindingRider(deliveryId: state.pathParameters['deliveryId']!),
        ),
        GoRoute(
          path: '/sender/delivery/:deliveryId',
          builder: (_, state) => DeliveryDetailsScreen(
            deliveryId: state.pathParameters['deliveryId']!,
          ),
        ),
        GoRoute(
          path: '/sender/rate-rider/:deliveryId',
          builder: (_, state) =>
              RateRiderScreen(deliveryId: state.pathParameters['deliveryId']!),
        ),*/
        GoRoute(
          path: '/sender/saved-addresses',
          builder: (_, _) => SavedAddressesScreen(),
        ),
        GoRoute(
          path: '/sender/payment-methods',
          builder: (_, _) => PaymentMethods(),
        ),

        // ---- Rider shell (bottom nav: Home, History, Profile) ----
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              RiderShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/rider/home',
                  builder: (_, _) => RiderHome(),
                ), // = available deliveries board
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/rider/history',
                  builder: (_, _) => DeliveryHistory(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/rider/profile',
                  builder: (_, _) => ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        // ---- Rider pushed routes (not tabs) ----
        GoRoute(
          path: '/rider/job/:deliveryId',
          builder: (_, state) =>
              JobDetailsScreen(deliveryId: state.pathParameters['deliveryId']!),
        ),
        /*GoRoute(
          path: '/rider/active-delivery/:deliveryId',
          builder: (_, state) => ActiveDeliveryScreen(
            deliveryId: state.pathParameters['deliveryId']!,
          ),
        ),
        GoRoute(
          path: '/rider/proof-of-delivery/:deliveryId',
          builder: (_, state) =>
              ProofOfDelivery(deliveryId: state.pathParameters['deliveryId']!),
        ),*/
        GoRoute(path: '/rider/earnings', builder: (_, _) => EarningScreen()),
        GoRoute(path: '/rider/withdraw', builder: (_, _) => WithdrawScreen()),
        GoRoute(
          path: '/rider/document-verification',
          builder: (_, _) => DocumentVerification(),
        ),
      ],
    );
  }

  static String? _redirect(
    BuildContext context,
    GoRouterState state,
    AuthProvider auth,
  ) {
    final loc = state.matchedLocation;
    final authRoutes = [
      '/splash',
      '/onboarding',
      '/login',
      '/signup',
      '/forgot-password',
    ];

    if (auth.isLoading) {
      return null; // still resolving SharedPreferences / Firebase Auth
    }

    if (!auth.hasSeenOnboarding && loc != '/onboarding') return '/onboarding';
    if (auth.hasSeenOnboarding &&
        !auth.isLoggedIn &&
        !authRoutes.contains(loc)) {
      return '/login';
    }
    if (auth.isLoggedIn && authRoutes.contains(loc)) {
      return auth.userRole == 'rider' ? '/rider/home' : '/sender/home';
    }

    // role guard — block cross-role access
    if (auth.isLoggedIn) {
      if (auth.userRole == 'sender' && loc.startsWith('/rider')) {
        return '/sender/home';
      }
      if (auth.userRole == 'rider' && loc.startsWith('/sender')) {
        return '/rider/home';
      }
    }

    return null;
  }
}

// SenderShell — bottom nav wrapper
class SenderShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const SenderShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// RiderShell — same pattern, 3 tabs
class RiderShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const RiderShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
