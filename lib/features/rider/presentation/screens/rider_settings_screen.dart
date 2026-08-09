import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

class RiderSettingsScreen extends StatelessWidget {
  const RiderSettingsScreen({super.key, this.documentsVerified = true});

  final bool documentsVerified;

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.greyBg,
                    child: Icon(Icons.person_2_rounded),
                  ),
                  SizedBox(height: 14),
                  Text(name, style: AppFonts.headlineMedium),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$tier • ', style: AppFonts.labelSmall),
                      Text('$rating ', style: AppFonts.labelSmall),
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
                          color: AppColors.orangeSecondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          proLevel,
                          style: AppFonts.labelSmall.copyWith(
                            color: AppColors.surface,
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
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          joinedYear,
                          style: AppFonts.labelSmall.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/rider/edit-profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangePrimary,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            _SettingsTile(
              icon: Icons.electric_moped_outlined,
              iconBg: AppColors.surface,
              iconColor: AppColors.orangeSecondary,
              title: 'Vehicle Information',
              subtitle: '$vehicleName • $vehicleType',
              onTap: () {
                // TODO: navigate to vehicle info screen
              },
            ),
            _SettingsTile(
              icon: Icons.verified_user_outlined,
              iconBg: AppColors.surface,
              iconColor: AppColors.success,
              title: 'Document Status',
              subtitle: documentsVerified
                  ? 'All documents verified'
                  : 'Action needed',
              subtitleColor: documentsVerified
                  ? AppColors.success
                  : AppColors.orangePrimary,
              highlighted: true,
              onTap: () {
                context.push('/rider/document-verification');
              },
            ),
            _SettingsTile(
              icon: Icons.account_balance_outlined,
              iconBg: AppColors.surface,
              iconColor: AppColors.onSurface,
              title: 'Payout Settings',
              subtitle: '$payoutMethod • ••••$payoutLast4',
              onTap: () {
                // TODO: navigate to payout settings screen
              },
            ),
            _SettingsTile(
              icon: Icons.notifications_none,
              iconBg: AppColors.surface,
              iconColor: AppColors.onSurface,
              title: 'Notifications',
              onTap: () {
                context.push('/notifications');
              },
            ),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              iconBg: AppColors.surface,
              iconColor: AppColors.onSurface,
              title: 'Help Center',
              onTap: () {
                context.push('/support');
              },
            ),
            _SettingsTile(
              icon: Icons.logout_rounded,
              iconBg: AppColors.surface,
              iconColor: AppColors.error,
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
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final bool highlighted;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.highlighted = false,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: highlighted
              ? Border.all(
                  color: AppColors.success.withValues(alpha: 0.7),
                  width: 1.2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.07),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppFonts.labelSmall.copyWith(
                        color: subtitleColor ?? AppColors.onSurfaceVariant,
                      ),
                    ),
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
