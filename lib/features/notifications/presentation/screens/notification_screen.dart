import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

enum NotifFilter { all, updates, alerts, promos }

class NotificationItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final bool isPromo;
  final String? thumbnailUrl;
  final String? actionLabel;

  const NotificationItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    this.isPromo = false,
    this.thumbnailUrl,
    this.actionLabel,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotifFilter _selected = NotifFilter.all;

  // TODO: replace with real data from NotificationsProvider
  final _today = const [
    NotificationItem(
      icon: Icons.person_pin_circle_outlined,
      iconBg: Color(0xFFFCE4E4),
      iconColor: Color(0xFFD32F2F),
      title: 'Rider assigned',
      body:
          "Michael Scott has been assigned to your shipment #SWC-9921. He is 4.2 km away from the hub.",
      time: '2m ago',
    ),
    NotificationItem(
      icon: Icons.campaign_outlined,
      iconBg: Color(0xFFD4E157),
      iconColor: Colors.black87,
      title: 'Weekend Surge Discount',
      body:
          'Get 20% off all intra-city deliveries this weekend. Use code SPEED20 at checkout!',
      time: '1h ago',
      isPromo: true,
      actionLabel: 'Claim Offer',
    ),
  ];

  final _yesterday = const [
    NotificationItem(
      icon: Icons.inventory_2_outlined,
      iconBg: Color(0xFFEEEEEE),
      iconColor: Colors.black54,
      title: 'Parcel picked up',
      body:
          "Your parcel containing 'Electronics Bundle' has been collected from the sender in downtown core.",
      time: 'Yesterday, 4:15 PM',
    ),
    NotificationItem(
      icon: Icons.check_circle_outline,
      iconBg: Color(0xFFD4E157),
      iconColor: Colors.black87,
      title: 'Delivery successful',
      body:
          'Package #SWC-8812 was delivered. Proof of delivery is now available in your history.',
      time: 'Yesterday, 10:30 AM',
      thumbnailUrl: 'assets/images/track in real time.png',
      actionLabel: 'POD',
    ),
    NotificationItem(
      icon: Icons.shield_outlined,
      iconBg: Color(0xFFFCE4E4),
      iconColor: Color(0xFFD32F2F),
      title: 'New Login Detected',
      body:
          'We noticed a new login to your SwiftCel account from a Chrome browser on Windows.',
      time: 'Oct 24, 8:45 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notifications', style: AppFonts.headlineMedium),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: NotifFilter.values.map((f) {
                  final isSelected = f == _selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_filterLabel(f)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selected = f),
                      selectedColor: const Color(0xFFD32F2F),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 13,
                      ),
                      backgroundColor: const Color(0xFFEFEFEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  _sectionLabel('TODAY'),
                  ..._today.map((n) => _NotificationTile(item: n)),
                  const SizedBox(height: 8),
                  _sectionLabel('YESTERDAY'),
                  ..._yesterday.map((n) => _NotificationTile(item: n)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(NotifFilter f) => switch (f) {
    NotifFilter.all => 'All',
    NotifFilter.updates => 'Updates',
    NotifFilter.alerts => 'Alerts',
    NotifFilter.promos => 'Promos',
  };

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black45,
      ),
    ),
  );
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isPromo ? const Color(0xFFF6FBD8) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                if (item.isPromo && item.actionLabel != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        item.actionLabel!,
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: Color(0xFFD32F2F),
                      ),
                    ],
                  ),
                ],
                if (!item.isPromo &&
                    item.thumbnailUrl != null &&
                    item.actionLabel != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item.thumbnailUrl!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.actionLabel!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
