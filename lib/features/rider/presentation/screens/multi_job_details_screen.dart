// lib/features/rider/presentation/screens/multi_stop_job_details_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';

enum StopType { pickup, stop, finalDestination }

enum ParcelSize { small, medium, large }

class RouteStop {
  final StopType type;
  final String label;
  final String address;
  final double distanceFromPrevious;
  final String? parcelId;
  final ParcelSize? size;

  RouteStop({
    required this.type,
    required this.label,
    required this.address,
    required this.distanceFromPrevious,
    this.parcelId,
    this.size,
  });
}

class MultiStopJobDetailsScreen extends StatefulWidget {
  final String jobId; // TODO: not yet wired to real data — mock stops below

  MultiStopJobDetailsScreen({super.key, required this.jobId});

  @override
  State<MultiStopJobDetailsScreen> createState() =>
      _MultiStopJobDetailsScreenState();
}

class _MultiStopJobDetailsScreenState extends State<MultiStopJobDetailsScreen> {
  void _acceptJob(BuildContext context, String jobId) {
    context.push('/rider/active-delivery/$jobId');
  }

  void _declineJob(BuildContext context, String jobId) {
    // TODO: call JobOfferProvider.declineJob(jobId) once real multi-stop backend exists
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: this entire mock list needs a real multi-stop data model before it's functional —
    // see conversation note: parked feature, visual-only for now
    const totalDistance = 12.4;
    const totalStops = 4;
    const totalEarnings = 42.50;

    final jobId = widget.jobId;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final stops = [
      RouteStop(
        type: StopType.pickup,
        label: 'Pickup Point',
        address: 'Central Hub Warehouse\nBay 4, Loading Dock B',
        distanceFromPrevious: 0.0,
      ),
      RouteStop(
        type: StopType.stop,
        label: 'Stop 1',
        address: '1042 Market St, Suite 200',
        distanceFromPrevious: 3.2,
        parcelId: '#SC-9992',
        size: ParcelSize.small,
      ),
      RouteStop(
        type: StopType.stop,
        label: 'Stop 2',
        address: '88 King Blvd, Floor 4',
        distanceFromPrevious: 4.1,
        parcelId: '#SC-7741',
        size: ParcelSize.medium,
      ),
      RouteStop(
        type: StopType.finalDestination,
        label: 'Final Destination',
        address: '400 Pine Ave, Building C',
        distanceFromPrevious: 5.1,
        parcelId: '#SC-5310',
        size: ParcelSize.large,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details', style: textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: colorScheme.surfaceContainerHigh,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 40,
                          color: colorScheme.primary.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Map view — pending Maps API activation',
                          style: textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'TOTAL EST.',
                              value: '$totalDistance mi',
                              valueColor: colorScheme.secondary,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              label: 'STOPS',
                              value: '$totalStops',
                              valueColor: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              label: 'EARNINGS',
                              value: '\$${totalEarnings.toStringAsFixed(2)}',
                              valueColor: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        'ROUTE SEQUENCE',
                        style: textTheme.labelMedium?.copyWith(
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 12),
                      ...List.generate(stops.length, (index) {
                        final stop = stops[index];
                        final isLast = index == stops.length - 1;
                        return _RouteStopTile(stop: stop, isLast: isLast);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceBright,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _declineJob(context, jobId),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('Decline', style: textTheme.labelMedium),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => _acceptJob(context, jobId),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Accept Job',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.surface,
                          fontWeight: FontWeight.w600,
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: textTheme.titleLarge?.copyWith(color: valueColor)),
          SizedBox(height: 2),
          Text(label, style: textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _RouteStopTile extends StatelessWidget {
  final RouteStop stop;
  final bool isLast;

  const _RouteStopTile({required this.stop, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final (dotColor, icon) = switch (stop.type) {
      StopType.pickup => (AppColors.success, Icons.local_shipping_outlined),
      StopType.stop => (colorScheme.secondary, Icons.circle),
      StopType.finalDestination => (colorScheme.primary, Icons.location_on),
    };

    final (sizeLabel, sizeColor) = switch (stop.size) {
      ParcelSize.small => ('SMALL', AppColors.success),
      ParcelSize.medium => ('MEDIUM', AppColors.warning),
      ParcelSize.large => ('LARGE', AppColors.error),
      null => ('', colorScheme.onSurfaceVariant),
    };

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: stop.type == StopType.pickup
                          ? dotColor.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: stop.type == StopType.stop ? 12 : 16,
                      color: dotColor,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: EdgeInsets.symmetric(vertical: 4),
                        color: colorScheme.surfaceContainerHigh,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(stop.label, style: textTheme.titleLarge),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${stop.distanceFromPrevious}mi',
                            style: textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      stop.address.replaceAll('\n', ', '),
                      style: textTheme.bodyMedium,
                    ),
                    if (stop.parcelId != null) ...[
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceBright,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.surfaceContainerHigh,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 16,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  stop.parcelId!,
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: sizeColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                sizeLabel,
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
