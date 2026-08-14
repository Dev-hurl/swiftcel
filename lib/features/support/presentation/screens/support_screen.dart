import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Help Center', style: textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/notifications');
            },
            icon: Icon(
              Icons.notifications,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('How can we help?', style: textTheme.headlineLarge),
          SizedBox(height: 4),
          Text(
            'Search for answers or browse categories below.',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search FAQs, tracking issues...',
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              suffixIcon: Icon(Icons.qr_code_scanner, size: 20),
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('CATEGORIES', style: textTheme.labelSmall),
          SizedBox(height: 10),
          _CategoryCard(
            icon: Icons.person_outline,
            iconBg: colorScheme.tertiary,
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
            iconBg: colorScheme.surfaceContainerLow,
            title: 'Payment',
            subtitle: 'Invoices, refunds & billing methods',
            chips: ['Refund Policy', 'Update Card', 'Receipts'],
          ),
          SizedBox(height: 20),
          Text('POPULAR ARTICLES', style: textTheme.labelSmall),
          SizedBox(height: 8),
          ..._articles.map((a) => _ArticleTile(text: a)),
          SizedBox(height: 20),
          Text('DIRECT SUPPORT', style: textTheme.labelSmall),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
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
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chat with Support', style: textTheme.labelLarge),
                      Text(
                        'Available 24/7 • 2 min wait',
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: colorScheme.primary, size: 18),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.onSurface, size: 20),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (chips != null) ...[
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: chips!
                  .map(
                    (c) => Chip(
                      label: Text(c, style: textTheme.labelSmall),
                      backgroundColor: colorScheme.surfaceContainerLow,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(12),
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
          Icon(
            Icons.description_outlined,
            size: 18,
            color: colorScheme.primary,
          ),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: textTheme.labelMedium)),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: colorScheme.primary, size: 20),
          SizedBox(height: 6),
          Text(label, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}
