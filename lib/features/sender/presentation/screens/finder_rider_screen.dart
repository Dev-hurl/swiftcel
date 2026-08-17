// lib/features/sender/presentation/screens/finding_rider_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';

class FindingRiderScreen extends StatefulWidget {
  final String deliveryId;
  const FindingRiderScreen({super.key, required this.deliveryId});

  @override
  State<FindingRiderScreen> createState() => _FindingRiderScreenState();
}

class _FindingRiderScreenState extends State<FindingRiderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _pollTimer;

  // TODO: replace with real data from DeliveryProvider / a live Firestore stream on this delivery doc
  final int stopsCount = 2;
  final int ridersNearby = 4;
  final double estimatedTotal = 32.50;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // TODO: replace with a real Firestore listener on this delivery's status field.
    // Polling here is a placeholder so the screen has somewhere to go once a rider accepts.
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      // if (deliveryStatus == 'accepted') context.go('/sender/delivery/${widget.deliveryId}');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _cancelRequest() {
    // TODO: call DeliveryProvider.cancelDelivery(widget.deliveryId), update Firestore status to 'cancelled'
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    color: AppColors.orangePrimary.withValues(alpha: 0.3),
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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onSurface.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return SizedBox(
                  height: 160,
                  width: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _PulseRing(progress: _pulseController.value, delay: 0.0),
                      _PulseRing(progress: _pulseController.value, delay: 0.33),
                      _PulseRing(progress: _pulseController.value, delay: 0.66),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: AppColors.orangeSecondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.circle,
                          color: AppColors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                    bottom: Radius.circular(24),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Finding your rider...',
                            style: AppFonts.headlineSmall,
                          ),
                          RotationTransition(
                            turns: _pulseController,
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: AppColors.orangeSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value:
                                  null, // indeterminate — matches an ongoing search with no known end point
                              minHeight: 6,
                              backgroundColor: AppColors.surfaceVariant,
                              color: AppColors.orangeSecondary,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Pickup & $stopsCount Stops',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _InfoRow(
                            icon: Icons.groups_outlined,
                            label: 'Riders nearby: $ridersNearby',
                          ),
                          Row(
                            children: List.generate(
                              3,
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Container(
                                  height: 6,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ESTIMATED TOTAL', style: AppFonts.labelMedium),
                          Text(
                            '\$${estimatedTotal.toStringAsFixed(2)}',
                            style: AppFonts.headlineSmall.copyWith(
                              color: AppColors.orangeSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _cancelRequest,
                          icon: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.orangeSecondary,
                          ),
                          label: Text(
                            'Cancel Request',
                            style: AppFonts.labelLarge.copyWith(
                              color: AppColors.orangeSecondary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: AppColors.orangeSecondary.withValues(
                                alpha: 0.4,
                              ),
                            ),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  final double progress;
  final double delay;

  const _PulseRing({required this.progress, required this.delay});

  @override
  Widget build(BuildContext context) {
    final adjustedProgress = (progress + delay) % 1.0;
    final scale = 0.3 + (adjustedProgress * 0.7);
    final opacity = (1.0 - adjustedProgress).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity * 0.5,
      child: Transform.scale(
        scale: scale,
        child: Container(
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            color: AppColors.orangeSecondary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(label, style: AppFonts.bodySmall),
      ],
    );
  }
}
