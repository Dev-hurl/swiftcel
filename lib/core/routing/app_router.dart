import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
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
import 'package:swiftcel/features/rider/presentation/screens/delivery_history.dart';
import 'package:swiftcel/features/rider/presentation/screens/document_verification.dart';
import 'package:swiftcel/features/rider/presentation/screens/earning_screen.dart';
import 'package:swiftcel/features/rider/presentation/screens/job_details_screen.dart';
import 'package:swiftcel/features/rider/presentation/screens/rider_edit_profile.dart';
import 'package:swiftcel/features/rider/presentation/screens/rider_home.dart';
import 'package:swiftcel/features/rider/presentation/screens/rider_settings_screen.dart';
import 'package:swiftcel/features/rider/presentation/screens/withdraw_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/create_delivery_address_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/create_delivery_parcel_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/create_delivery_review_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/order_history_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/payment_methods.dart';
import 'package:swiftcel/features/sender/presentation/screens/saved_addresses_screen.dart';
import 'package:swiftcel/features/sender/presentation/screens/sender_edit_profile.dart';
import 'package:swiftcel/features/sender/presentation/screens/sender_home.dart';
import 'package:swiftcel/features/sender/presentation/screens/sender_settings_screen.dart';
import 'package:swiftcel/features/support/presentation/screens/support_screen.dart';
import 'package:swiftcel/main.dart';

class AppRouter {
  static const bool debugMode = false;
  static const String debugInitialLocation = '/sender/edit-profile';

  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      observers: [analyticsObserver],
      initialLocation: debugMode ? debugInitialLocation : '/onboarding',
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
          builder: (_, state) {
            final email = state.extra as String? ?? '';
            final oobCode = state.uri.queryParameters['oobCode'];
            final mode = state.uri.queryParameters['mode'];

            return VerifyEmailScreen(
              email: email,
              oobCode: oobCode,
              mode: mode,
            );
          },
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (_, _) => ForgotPasswordScreen(),
        ),
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
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/sender/settings',
                  builder: (_, _) => SenderSettingsScreen(),
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
        /*
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
        GoRoute(
          path: '/sender/edit-profile',
          builder: (_, _) => SenderEditProfile(),
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
                // NEW
                GoRoute(
                  path: '/rider/earnings',
                  builder: (_, _) => EarningScreen(),
                ),
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
                  path: '/rider/settings',
                  builder: (_, _) => RiderSettingsScreen(),
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
        GoRoute(path: '/rider/withdraw', builder: (_, _) => WithdrawScreen()),
        GoRoute(
          path: '/rider/document-verification',
          builder: (_, _) => DocumentVerification(),
        ),
        GoRoute(
          path: '/rider/edit-profile',
          builder: (_, _) => RiderEditProfile(),
        ),
      ],
    );
  }
}

String? _redirect(
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
    return loc == '/splash' ? null : '/splash';
  }

  if (!auth.hasSeenOnboarding && loc != '/onboarding') return '/onboarding';
  if (auth.hasSeenOnboarding && !auth.isLoggedIn && !authRoutes.contains(loc)) {
    return '/login';
  }

  // NEW — logged in but not verified: force them to verify-email
  if (auth.isLoggedIn && !auth.isEmailVerified && loc != '/verify-email') {
    return '/verify-email';
  }
  // Verified and sitting on an auth screen — send home
  if (auth.isLoggedIn && auth.isEmailVerified && authRoutes.contains(loc)) {
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
        items: [
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
      bottomNavigationBar: _RiderNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _RiderNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _RiderNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.payments_outlined, label: 'Earnings'),
    (icon: Icons.history, label: 'History'),
    (icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;
            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.orangePrimary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.onSurfaceVariant,
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 6),
                      Text(
                        item.label,
                        style: AppFonts.labelMedium.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
