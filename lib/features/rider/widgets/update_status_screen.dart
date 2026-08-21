import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/features/rider/presentation/screens/active_delivery_screen.dart';

class UpdateStatusSheet extends StatefulWidget {
  final DeliveryStopStatus currentStatus;
  const UpdateStatusSheet({super.key, required this.currentStatus});

  @override
  State<UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends State<UpdateStatusSheet> {
  late DeliveryStopStatus _selected = widget.currentStatus;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Update Status', style: textTheme.headlineMedium),
          SizedBox(height: 4),
          Text(
            'Select the current state of the delivery.',
            style: textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          _StatusOption(
            icon: Icons.location_on_outlined,
            iconColor: colorScheme.primary,
            label: 'Arrived at Location',
            status: DeliveryStopStatus.arrived,
            selected: _selected,
            onTap: () => setState(() => _selected = DeliveryStopStatus.arrived),
          ),
          SizedBox(height: 8),
          _StatusOption(
            icon: Icons.inventory_2_outlined,
            iconColor: colorScheme.primary,
            label: 'Package Picked Up',
            status: DeliveryStopStatus.pickedUp,
            selected: _selected,
            onTap: () =>
                setState(() => _selected = DeliveryStopStatus.pickedUp),
          ),
          SizedBox(height: 8),
          _StatusOption(
            icon: Icons.local_shipping_outlined,
            iconColor: colorScheme.surfaceBright,
            label: 'In Transit',
            status: DeliveryStopStatus.inTransit,
            selected: _selected,
            onTap: () =>
                setState(() => _selected = DeliveryStopStatus.inTransit),
            highlightedFill: true,
          ),
          SizedBox(height: 8),
          _StatusOption(
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
            label: 'Package Delivered',
            status: DeliveryStopStatus.delivered,
            selected: _selected,
            onTap: () =>
                setState(() => _selected = DeliveryStopStatus.delivered),
          ),
          SizedBox(height: 8),
          _StatusOption(
            icon: Icons.person_off_outlined,
            iconColor: AppColors.error,
            label: 'Recipient Not Available',
            status: DeliveryStopStatus.recipientUnavailable,
            selected: _selected,
            onTap: () => setState(
              () => _selected = DeliveryStopStatus.recipientUnavailable,
            ),
          ),
          SizedBox(height: 8),
          _StatusOption(
            icon: Icons.undo,
            iconColor: colorScheme.onSurfaceVariant,
            label: 'Return to Warehouse',
            status: DeliveryStopStatus.returned,
            selected: _selected,
            onTap: () =>
                setState(() => _selected = DeliveryStopStatus.returned),
          ),
          SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final DeliveryStopStatus status;
  final DeliveryStopStatus selected;
  final VoidCallback onTap;
  final bool highlightedFill;

  const _StatusOption({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.status,
    required this.selected,
    required this.onTap,
    this.highlightedFill = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = status == selected;
    final showFilled = isSelected && highlightedFill;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: showFilled
              ? colorScheme.primary
              : (isSelected
                    ? colorScheme.tertiary
                    : colorScheme.surfaceContainerLow),
          borderRadius: BorderRadius.circular(14),
          
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: showFilled
                  ? colorScheme.surfaceBright
                  : (isSelected ? colorScheme.primary : iconColor),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: textTheme.titleSmall?.copyWith(
                  color: showFilled
                      ? colorScheme.surface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 18,
                color: showFilled
                    ? colorScheme.surfaceBright
                    : colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
