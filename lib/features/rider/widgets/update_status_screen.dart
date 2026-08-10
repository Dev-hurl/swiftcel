import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
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
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text('Update Status', style: AppFonts.headlineMedium),
          const SizedBox(height: 4),
          Text('Select the current status of the delivery.', style: AppFonts.bodySmall),
          const SizedBox(height: 16),
          _StatusOption(
            icon: Icons.location_on_outlined,
            label: 'Arrived at Stop',
            status: DeliveryStopStatus.pickedUp, // adjust mapping if you add a distinct "arrived" state later
            isSelected: false,
            onTap: () => setState(() {}),
          ),
          const SizedBox(height: 10),
          _StatusOption(
            icon: Icons.inventory_2_outlined,
            label: 'Package Picked Up',
            status: DeliveryStopStatus.pickedUp,
            isSelected: _selected == DeliveryStopStatus.pickedUp,
            onTap: () => setState(() => _selected = DeliveryStopStatus.pickedUp),
          ),
          const SizedBox(height: 10),
          _StatusOption(
            icon: Icons.check_circle_outline,
            label: 'Delivered',
            status: DeliveryStopStatus.delivered,
            isSelected: _selected == DeliveryStopStatus.delivered,
            onTap: () => setState(() => _selected = DeliveryStopStatus.delivered),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeSecondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: Text('Confirm', style: AppFonts.labelLarge.copyWith(color: AppColors.white)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: AppFonts.labelMedium.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final DeliveryStopStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.icon,
    required this.label,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangeContainer : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColors.orangeSecondary : AppColors.onSurfaceVariant),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppFonts.titleSmall.copyWith(color: isSelected ? AppColors.orangeSecondary : AppColors.onSurface),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, size: 18, color: AppColors.orangeSecondary),
          ],
        ),
      ),
    );
  }
}