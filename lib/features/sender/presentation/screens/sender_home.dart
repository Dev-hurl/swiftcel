import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

enum DeliveryStatus { transit, onProcess, completed, pending }

class DeliveryPreview {
  final String trackingId;
  final String itemLabel;
  final DeliveryStatus status;
  final String originCity;
  final String originDate;
  final String destCity;
  final String destDate;
  final int progressStep; // 0 = just created, 3 = delivered

  const DeliveryPreview({
    required this.trackingId,
    required this.itemLabel,
    required this.status,
    required this.originCity,
    required this.originDate,
    required this.destCity,
    required this.destDate,
    required this.progressStep,
  });
}

class SenderHome extends StatefulWidget {
  const SenderHome({super.key});

  @override
  State<SenderHome> createState() => _SenderHomeState();
}

class _SenderHomeState extends State<SenderHome> {
  DeliveryStatus? _selectedFilter; // null = All

  final String _images = 'assets/images/image.png';

  // TODO: replace with real stream from DeliveryProvider
  final List<DeliveryPreview> _deliveries = [
    DeliveryPreview(
      trackingId: 'H314215485',
      itemLabel: 'Electronics Bundle',
      status: DeliveryStatus.transit,
      originCity: 'Jakarta',
      originDate: '09 Mar 26',
      destCity: 'Malang',
      destDate: '16 Mar 26',
      progressStep: 1,
    ),
    DeliveryPreview(
      trackingId: 'H654124578',
      itemLabel: 'iPhone 15 Pro Max',
      status: DeliveryStatus.onProcess,
      originCity: 'Bandung',
      originDate: '22 Mar 26',
      destCity: 'Pekalongan',
      destDate: '28 Mar 26',
      progressStep: 0,
    ),
  ];

  List<DeliveryPreview> get _filtered => _selectedFilter == null
      ? _deliveries
      : _deliveries.where((d) => d.status == _selectedFilter).toList();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 24),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning', style: textTheme.bodyMedium),
            Text('Alex Vance', style: textTheme.headlineLarge),//main edit
          ],
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.push('/sender/edit-profile');
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: colorScheme.surfaceContainerLow,
              child: _images.isNotEmpty
                  ? Image.asset(_images)
                  : Icon(Icons.person, color: colorScheme.onSurfaceVariant),
            ),
          ),
          SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    context.push('/notifications');
                  },
                  icon: Icon(Icons.notifications_none),
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Positioned(
                top: -8,
                right: -2,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: AppFonts.labelMedium.copyWith(
                        color: colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Track\nShipments', style: AppFonts.displayLarge),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search tracking IDs, tracking issues...',
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              suffixIcon: Icon(Icons.qr_code_scanner, size: 20),
              filled: true,
              fillColor: colorScheme.surfaceContainerLowest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedFilter == null,
                  onTap: () => setState(() => _selectedFilter = null),
                ),
                SizedBox(width: 8),
                _FilterChip(
                  label: 'Completed',
                  isSelected: _selectedFilter == DeliveryStatus.completed,
                  onTap: () => setState(
                    () => _selectedFilter = DeliveryStatus.completed,
                  ),
                ),
                SizedBox(width: 8),
                _FilterChip(
                  label: 'On Process',
                  isSelected: _selectedFilter == DeliveryStatus.onProcess,
                  onTap: () => setState(
                    () => _selectedFilter = DeliveryStatus.onProcess,
                  ),
                ),
                SizedBox(width: 8),
                _FilterChip(
                  label: 'Pending',
                  isSelected: _selectedFilter == DeliveryStatus.pending,
                  onTap: () =>
                      setState(() => _selectedFilter = DeliveryStatus.pending),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          Text(
            'What would you like to do?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionItem(
                icon: Icons.inventory_2_outlined,
                bg: colorScheme.tertiary,
                iconColor: colorScheme.secondary,
                label: 'Send parcel',
                onTap: () {
                  context.push('/sender/create-parcel');
                },
              ),
              _ActionItem(
                icon: Icons.location_searching,
                bg: AppColors.success.withValues(alpha: 0.2),
                iconColor: AppColors.success,
                label: 'Track item',
                onTap: () {
                  // TODO: navigate to tracking screen
                },
              ),
              _ActionItem(
                icon: Icons.location_on_outlined,
                bg: Color(0xFFE3F2FD),
                iconColor: Color(0xFF1565C0),
                label: 'Location',
                onTap: () {
                  context.push('/sender/saved-address');
                },
              ),
              _ActionItem(
                icon: Icons.support_agent,
                bg: Color(0xFFEFEBE9),
                iconColor: Color(0xFF6D4C41),
                label: 'Services',
                onTap: () {
                  context.push('/support');
                },
              ),
            ],
          ),
          SizedBox(height: 24),

          ..._filtered.map((d) => _ShipmentCard(delivery: d)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondary : colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.surfaceBright
                : colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final DeliveryPreview delivery;
  const _ShipmentCard({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: colorScheme.secondary,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.trackingId,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      delivery.itemLabel,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: delivery.status),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: List.generate(4, (i) {
              final active = i <= delivery.progressStep;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? colorScheme.secondary
                            : colorScheme.surfaceBright,
                      ),
                    ),
                    if (i < 3)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: active
                              ? colorScheme.secondary
                              : colorScheme.surfaceBright,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    delivery.originCity,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    delivery.originDate,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    delivery.destCity,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    delivery.destDate,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DeliveryStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final (label, color) = switch (status) {
      DeliveryStatus.transit => ('Transit', colorScheme.secondary),
      DeliveryStatus.onProcess => ('On Process', AppColors.information),
      DeliveryStatus.completed => ('Completed', AppColors.success),
      DeliveryStatus.pending => ('Pending', AppColors.warning),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.surfaceBright,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
