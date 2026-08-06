import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SenderSettingsScreen extends StatelessWidget {
  const SenderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real data from AuthProvider / Firestore user doc
    const name = 'Alex Mercer';
    const email = 'alex.mercer@example.com';

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: Color(0xFFD32F2F), size: 20),
                SizedBox(width: 6),
                Text(
                  'SwiftCel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                Spacer(),
                Icon(Icons.menu, color: Colors.black54),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Settings',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your SwiftCel preferences and account details.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFEEEEEE),
                  ), // TODO: real avatar
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
                        Text(
                          email,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Color(0xFFD32F2F),
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
              subtitle: 'English (US), Timezone',
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
                onPressed: () {
                  // TODO: call AuthProvider.logout()
                },
                icon: Icon(Icons.logout, color: Color(0xFFD32F2F), size: 18),
                label: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide.none,
                  backgroundColor: Color(0xFFEEEEEE),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black87, size: 20),
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
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
