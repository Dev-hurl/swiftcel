import 'package:flutter/material.dart';
import 'package:swiftcel/features/rider/widgets/update_status_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';

enum DeliveryStopStatus { pickedUp, inTransit, delivered }

class ActiveDeliveryScreen extends StatefulWidget {
  final String deliveryId;
  const ActiveDeliveryScreen({super.key, required this.deliveryId});

  @override
  State<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  // TODO: replace with real data from DeliveryProvider, keyed by widget.deliveryId
  DeliveryStopStatus _currentStatus = DeliveryStopStatus.inTransit;
  final String senderName = 'Olivia Smith';
  final double distanceToNextStop = 1.2;

  Future<void> _openUpdateStatusSheet() async {
    final result = await showModalBottomSheet<DeliveryStopStatus>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => UpdateStatusSheet(currentStatus: _currentStatus),
    );

    if (result != null) {
      setState(() => _currentStatus = result);
      // TODO: write updated status to Firestore delivery doc

      if (result == DeliveryStopStatus.delivered && mounted) {
        // TODO: navigate to ProofOfDeliveryScreen once status hits "delivered"
        // context.push('/rider/proof-of-delivery/${widget.deliveryId}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Delivery', style: AppFonts.headlineMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: AppColors.surfaceVariant,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: AppColors.orangePrimary.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Map view — pending Maps API activation',
                          style: AppFonts.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'STOP 1 OF 3',
                              style: AppFonts.labelSmall.copyWith(
                                color: AppColors.orangeSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Next: ${distanceToNextStop}mi',
                              style: AppFonts.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _StopProgressBar(currentStatus: _currentStatus),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.surfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('SENDER', style: AppFonts.labelSmall),
                                  Text(senderName, style: AppFonts.titleSmall),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 18,
                                  color: AppColors.onSurface,
                                ),
                                onPressed: () {
                                  // TODO: navigate to '/chat/:chatId' for this delivery
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _openUpdateStatusSheet,
                            icon: const Icon(
                              Icons.refresh,
                              size: 18,
                              color: AppColors.white,
                            ),
                            label: Text(
                              'Update Status',
                              style: AppFonts.labelLarge.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orangeSecondary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StopProgressBar extends StatelessWidget {
  final DeliveryStopStatus currentStatus;
  const _StopProgressBar({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        label: 'Picked Up',
        status: DeliveryStopStatus.pickedUp,
        icon: Icons.check,
      ),
      (
        label: 'In Transit',
        status: DeliveryStopStatus.inTransit,
        icon: Icons.local_shipping_outlined,
      ),
      (
        label: 'Delivered',
        status: DeliveryStopStatus.delivered,
        icon: Icons.inventory_2_outlined,
      ),
    ];
    final currentIndex = currentStatus.index;

    return Row(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isDone = index < currentIndex;
        final isActive = index == currentIndex;
        final color = isDone || isActive
            ? AppColors.orangeSecondary
            : AppColors.surfaceVariant;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.success
                          : (isActive
                                ? AppColors.orangeSecondary
                                : AppColors.surfaceVariant),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDone ? Icons.check : step.icon,
                      size: 16,
                      color: isDone || isActive
                          ? AppColors.white
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.label,
                    style: AppFonts.labelSmall.copyWith(color: color),
                  ),
                ],
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: isDone
                        ? AppColors.success
                        : AppColors.surfaceVariant,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
