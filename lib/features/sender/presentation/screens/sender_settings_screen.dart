import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

class SenderSettingsScreen extends StatelessWidget {
  const SenderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real data from AuthProvider / Firestore user doc
    const name = 'Alex Mercer';
    const email = 'alex.mercer@example.com';
    final bool hasImage = false;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings', style: textTheme.headlineMedium),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceBright,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.greyBg,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(email, style: AppFonts.labelSmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppColors.orangePrimary,
                    size: 18,
                  ),
                  onPressed: () {
                    context.push(
                      '/sender/edit-profile',
                    ); // swap in whatever exact path you used
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _SettingsRow(
            icon: Icons.shield_outlined,
            title: 'Account Security',
            subtitle: 'Password, 2FA, linked accounts',
            onTap: () {
              // TODO: navigate to account security screen
            },
          ),
          _SettingsRow(
            icon: Icons.notifications_none,
            title: 'Notification Preferences',
            subtitle: 'Push, SMS, email alerts',
            onTap: () {
              // TODO: navigate to notification preferences screen
            },
          ),
          _SettingsRow(
            icon: Icons.credit_card,
            title: 'Payment Methods',
            subtitle: 'Manage cards and payouts',
            onTap: () {
              context.push('/sender/payment-methods');
            },
          ),
          _SettingsRow(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            subtitle: 'Home, work, frequent hubs',
            onTap: () {
              context.push('/sender/saved-addresses');
            },
          ),
          _SettingsRow(
            icon: Icons.public,
            title: 'Language & Region',
            subtitle:
                'Eng/home/buildwithnuel/buildwithnuel/assets/icons/swiftcel logo.pnglish (US), Timezone',
            onTap: () {
              // TODO: navigate to language/region screen
            },
          ),
          _SettingsRow(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQs, contact support',
            onTap: () {
              context.push('/support');
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: Icon(Icons.logout, color: AppColors.error, size: 18),
              label: Text(
                'Log Out',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                side: BorderSide.none,
                backgroundColor: AppColors.surfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.greyBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bodyLarge.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: AppFonts.labelSmall),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
