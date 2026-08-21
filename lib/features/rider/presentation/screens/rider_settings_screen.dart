import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

class RiderSettingsScreen extends StatefulWidget {
  const RiderSettingsScreen({super.key, this.documentsVerified = true});

  final bool documentsVerified;

  @override
  State<RiderSettingsScreen> createState() => _RiderSettingsScreenState();
}

class _RiderSettingsScreenState extends State<RiderSettingsScreen> {
  final String _images = 'assets/images/image.png';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // TODO: replace with real data from a RiderProfileProvider / Firestore user doc
    const name = 'Alex Mercer';
    const tier = 'Top Tier Rider';
    const rating = 4.9;
    const proLevel = 'Pro Level';
    const joinedYear = 'Joined 2021';
    const vehicleName = 'Niu MQi GT';
    const vehicleType = 'E-Scooter';
    const payoutMethod = 'Direct Deposit';
    const payoutLast4 = '1234';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    child: _images.isNotEmpty
                        ? Image.asset(_images)
                        : Icon(
                            Icons.person,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                  SizedBox(height: 14),
                  Text(name, style: textTheme.headlineMedium),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$tier • ', style: textTheme.labelSmall),
                      Text('$rating ', style: textTheme.labelSmall),
                      Icon(Icons.star, size: 14, color: AppColors.warning),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          proLevel,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.surface,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          joinedYear,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/rider/edit-profile');
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
                    Icon(Icons.person, color: colorScheme.primary),
                    'Account and Security',
                  ),
                  Divider(
                    color: colorScheme.surfaceContainerLow,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _SettingsTile(
                    icon: Icons.account_balance_outlined,
                    title: 'Payout Settings',
                    subtitle: '$payoutMethod • ••••$payoutLast4',
                    onTap: () {
                      // TODO: navigate to payout settings screen
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password ',
                    subtitle: 'Change your account password',
                    onTap: () {
                      //TODO: navigate to change password screen
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
                    Icon(Icons.bike_scooter, color: colorScheme.primary),
                    'Vehicle Information',
                  ),
                  Divider(
                    color: colorScheme.surfaceContainerLow,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _SettingsTile(
                    icon: Icons.electric_moped_outlined,
                    title: 'Vehicle Information',
                    subtitle: '$vehicleName • $vehicleType',
                    onTap: () {
                      // TODO: navigate to vehicle info screen
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Document Status',
                    subtitle: widget.documentsVerified
                        ? 'All documents verified'
                        : 'Action needed',
                    subtitleColor: widget.documentsVerified
                        ? AppColors.success
                        : colorScheme.primary,
                    highlighted: true,
                    onTap: () {
                      context.push('/rider/document-verification');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
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
                    Icon(Icons.tune, color: colorScheme.primary),
                    'Preferences',
                  ),
                  Divider(
                    color: colorScheme.surfaceContainerLow,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _WorkSettingsTile(
                    iconColor: colorScheme.onSurfaceVariant,
                    title: 'Available for Dispatch',
                    subtitle: 'Receive new job requests instantly',
                    onTap: () {},
                  ),
                  _WorkSettingsTile(
                    iconColor: colorScheme.onSurfaceVariant,
                    title: 'Push Notifications',
                    subtitle: 'Alerts for route changes and updates',
                    onTap: () {},
                  ),
                  _WorkSettingsTile(
                    iconColor: colorScheme.onSurfaceVariant,
                    title: 'Theme Mode',
                    subtitle: 'Change app appearance (Light/Dark)',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Container(
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
                    Icon(Icons.tune, color: colorScheme.primary),
                    'Session ',
                  ),
                  Divider(
                    color: colorScheme.surfaceContainerLow,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _SettingsTile(
                    icon: Icons.headphones,
                    title: 'Contact Support',
                    onTap: () {
                      context.push('/support');
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Log Out',
                    onTap: () async {
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                  ),
                ],
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
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final bool highlighted;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.highlighted = false,
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: textTheme.labelSmall?.copyWith(
                        color: subtitleColor ?? colorScheme.onSurfaceVariant,
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

class _WorkSettingsTile extends StatelessWidget {
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _WorkSettingsTile({
    required this.iconColor,
    required this.title,
    this.subtitle,
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Switch(
              value: false,
              onChanged: (bool v) {},
              thumbColor: WidgetStateProperty.all(colorScheme.primary),
              inactiveThumbColor: colorScheme.surfaceContainerLow,
              trackColor: WidgetStateProperty.all(
                colorScheme.surfaceContainerLowest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
