import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

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
      backgroundColor: Color(0xFFFAFAFA),
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
                  ), // TODO: real avatar image
                  SizedBox(height: 14),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$tier • ', style: AppFonts.labelSmall),
                      Text('$rating ', style: AppFonts.labelSmall),
                      Icon(Icons.star, size: 14, color: Color(0xFFD4E157)),
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
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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
                        backgroundColor: AppColors.orangeSecondary,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
              iconBg: AppColors.greyBg,
              iconColor: AppColors.orangeSecondary,
              title: 'Vehicle Information',
              subtitle: '$vehicleName • $vehicleType',
              onTap: () {
                // TODO: navigate to vehicle info screen
              },
            ),
            _SettingsTile(
              icon: Icons.verified_user_outlined,
              iconBg: AppColors.greyBg,
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
              iconBg: Color(0xFFEEEEEE),
              iconColor: Colors.black87,
              title: 'Payout Settings',
              subtitle: '$payoutMethod • ••••$payoutLast4',
              onTap: () {
                // TODO: navigate to payout settings screen
              },
            ),
            _SettingsTile(
              icon: Icons.notifications_none,
              iconBg: Color(0xFFEEEEEE),
              iconColor: Colors.black87,
              title: 'Notifications',
              onTap: () {
                context.push('/notifications');
              },
            ),
            SizedBox(height: 16),
            _PlainRow(
              icon: Icons.help_outline,
              label: 'Help Center',
              trailingIcon: Icons.arrow_forward,
              onTap: () {
                // TODO: navigate to '/support'
              },
            ),
            SizedBox(height: 10),
            _PlainRow(
              icon: Icons.logout,
              label: 'Log Out',
              color: Color(0xFFD32F2F),
              onTap: () {
                // TODO: call AuthProvider.logout()
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
  final String? trailingText;
  final bool highlighted;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.trailingText,
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor ?? Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

class _PlainRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final IconData? trailingIcon;
  final Color? color;
  final VoidCallback onTap;

  _PlainRow({
    required this.icon,
    required this.label,
    this.trailingIcon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.black87),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: color ?? Colors.black87,
              ),
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon, size: 18, color: color ?? Colors.black54),
        ],
      ),
    );
  }
}
