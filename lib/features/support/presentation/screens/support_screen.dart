import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Help Center', style: AppFonts.headlineMedium),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/notifications');
            },
            icon: Icon(Icons.notifications, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('How can we help?', style: AppFonts.headlineLarge),
          SizedBox(height: 4),
          Text(
            'Search for answers or browse categories below.',
            style: AppFonts.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search FAQs, tracking issues...',
              prefixIcon: Icon(Icons.search, color: AppColors.orangePrimary),
              suffixIcon: Icon(Icons.qr_code_scanner, size: 20),
              filled: true,
              fillColor: AppColors.greyBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'CATEGORIES',
            style: AppFonts.labelSmall
          ),
          SizedBox(height: 10),
          _CategoryCard(
            icon: Icons.person_outline,
            iconBg: AppColors.orangeContainer,
            title: 'Account',
            subtitle: 'Profile, security & settings',
          ),
          SizedBox(height: 10),
          _CategoryCard(
            icon: Icons.local_shipping_outlined,
            iconBg: AppColors.success,
            title: 'Delivery',
            subtitle: 'Tracking & parcel status',
          ),
          SizedBox(height: 10),
          _CategoryCard(
            icon: Icons.credit_card,
            iconBg: AppColors.greyBg,
            title: 'Payment',
            subtitle: 'Invoices, refunds & billing methods',
            chips: ['Refund Policy', 'Update Card', 'Receipts'],
          ),
          SizedBox(height: 20),
          Text('POPULAR ARTICLES', style: AppFonts.labelSmall),
          SizedBox(height: 8),
          ..._articles.map((a) => _ArticleTile(text: a)),
          SizedBox(height: 20),
          Text('DIRECT SUPPORT', style: AppFonts.labelSmall),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyBg, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.greyBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.orangePrimary,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chat with Support', style: AppFonts.labelLarge),
                      Text(
                        'Available 24/7 • 2 min wait',
                        style: AppFonts.labelSmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.orangePrimary,
                  size: 18,
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ContactButton(
                  icon: Icons.call_outlined,
                  label: 'Call Us',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ContactButton(
                  icon: Icons.mail_outline,
                  label: 'Email Support',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _articles = [
    'My package is delayed, what now?',
    'How to change delivery address',
    'I received a damaged item',
  ];
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final List<String>? chips;

  const _CategoryCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.chips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.onSurface, size: 20),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: AppFonts.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            style: AppFonts.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (chips != null) ...[
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: chips!
                  .map(
                    (c) => Chip(
                      label: Text(c, style: AppFonts.labelSmall),
                      backgroundColor: AppColors.greyBg,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final String text;
  const _ArticleTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            size: 18,
            color: AppColors.orangePrimary,
          ),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: AppFonts.labelMedium)),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ContactButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyBg, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.orangePrimary, size: 20),
          SizedBox(height: 6),
          Text(label, style: AppFonts.labelMedium),
        ],
      ),
    );
  }
}
