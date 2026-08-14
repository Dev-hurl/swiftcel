import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

class SenderSettingsScreen extends StatefulWidget {
  const SenderSettingsScreen({super.key});

  @override
  State<SenderSettingsScreen> createState() => _SenderSettingsScreenState();
}

class _SenderSettingsScreenState extends State<SenderSettingsScreen> {
  final String _images = 'assets/images/image.png';

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real data from AuthProvider / Firestore user doc
    const name = 'Alex Mercer';
    const email = 'alex.mercer@example.com';
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Settings', style: textTheme.displayMedium),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.surfaceContainerLowest,
                    child: _images.isNotEmpty
                        ? Image.asset(_images)
                        : Icon(
                            Icons.person,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          email,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: colorScheme.primary,
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
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSectionHeader(
                    Icon(Icons.shield_rounded, color: colorScheme.primary),
                    'Account Security',
                  ),
                  Divider(
                    color: colorScheme.surfaceContainerLow,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _SettingsRow(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Make your account stronger',
                    onTap: () {
                      //
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
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                //TODO: Finish this
                children: [
                  _buildSectionHeader(
                    Icon(Icons.tune, color: colorScheme.primary),
                    'Preferences',
                  ),
                  Divider(
                    color: colorScheme.surfaceContainerLow,
                    indent: 20,
                    endIndent: 20,
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
                    icon: Icons.public,
                    title: 'Language & Region',
                    subtitle: 'Timezone',
                    onTap: () {
                      // TODO: navigate to language/region screen
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            _SettingsRow(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'FAQs, contact support',
              onTap: () {
                context.push('/support');
              },
            ),
            SizedBox(height: 24),
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
      ),
    );
  }

  Widget _buildSectionHeader(Widget hIcon, String title) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        spacing: 8,
        children: [
          hIcon,
          Text(
            title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.surfaceContainerLow),
              ),
              child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
