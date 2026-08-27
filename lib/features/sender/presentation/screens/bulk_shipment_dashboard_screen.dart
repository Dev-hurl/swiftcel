import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';

enum StopStatus { delivered, inTransit, pending }

class ShipmentStop {
  final int number;
  final String time;
  final String address;
  final String recipient;
  final StopStatus status;

  ShipmentStop({
    required this.number,
    required this.time,
    required this.address,
    required this.recipient,
    required this.status,
  });
}

class BulkShipmentDashboardScreen extends StatelessWidget {
  const BulkShipmentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // TODO: entirely mocked — no real bulk shipment backend exists yet
    final shipmentId = 'BLCK-9921';
    final completedStops = 2;
    final totalStops = 3;
    final progress = completedStops / totalStops;

    final stops = [
      ShipmentStop(
        number: 1,
        time: '09:15 AM',
        address: '124 Logistics Blvd, Warehouse C',
        recipient: 'John D.',
        status: StopStatus.delivered,
      ),
      ShipmentStop(
        number: 3,
        time: '02:45 PM',
        address: '500 Metro Station Rd, Bay 4',
        recipient: 'Mike T.',
        status: StopStatus.inTransit,
      ),
      ShipmentStop(
        number: 4,
        time: '',
        address: '22 Riverfront Ave, Bldg B',
        recipient: 'Emily K.',
        status: StopStatus.pending,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        title: Text('Bulk Shipment Dashboard', style: textTheme.headlineMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceBright,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Random Shipment',
                            style: textTheme.headlineSmall,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: colorScheme.surfaceBright,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'In Progress',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.surfaceBright,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('ID: $shipmentId', style: textTheme.labelSmall),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Overall Progress', style: textTheme.titleSmall),
                          Text(
                            '$completedStops/$totalStops Stops Completed',
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: colorScheme.surfaceContainerLowest,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'STOP ROUTE',
                  style: textTheme.labelMedium?.copyWith(letterSpacing: 1),
                ),
                SizedBox(height: 10),
                ...stops.map((stop) => _StopCard(stop: stop)),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: colorScheme.secondary),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: call BulkShipmentProvider.cancelRemainingStops(shipmentId)
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 16,
                          color: colorScheme.secondary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Cancel Remaining Stops',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Center(
                  child: Text(
                    'Canceling will return pending items to the hub.',
                    style: textTheme.labelSmall,
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

class _StopCard extends StatelessWidget {
  final ShipmentStop stop;

  const _StopCard({required this.stop});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final (dotColor, badgeLabel, badgeColor) = switch (stop.status) {
      StopStatus.delivered => (
        AppColors.success,
        'Delivered',
        colorScheme.onSurfaceVariant,
      ),
      StopStatus.inTransit => (
        colorScheme.secondary,
        'In Transit',
        colorScheme.primary,
      ),
      StopStatus.pending => (
        colorScheme.onSurfaceVariant,
        'Pending',
        colorScheme.onSurfaceVariant,
      ),
    };

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: stop.status == StopStatus.inTransit
              ? badgeColor
              : colorScheme.surfaceContainerLowest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 8, color: dotColor),
                  SizedBox(width: 6),
                  Text(
                    stop.time.isEmpty
                        ? 'Stop ${stop.number} • Pending'
                        : 'Stop ${stop.number} • ${stop.time}',
                    style: textTheme.titleSmall,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: stop.status == StopStatus.inTransit
                      ? badgeColor
                      : colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                child: Text(
                  badgeLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: stop.status == StopStatus.inTransit
                        ? colorScheme.surfaceBright
                        : badgeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(stop.address, style: textTheme.bodyMedium),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recipient: ${stop.recipient}', style: textTheme.labelSmall),
              if (stop.status == StopStatus.delivered)
                GestureDetector(
                  onTap: () {
                    // TODO: navigate to proof of delivery view for this stop
                  },
                  child: Text(
                    'View Proof',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (stop.status == StopStatus.inTransit)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: colorScheme.surfaceBright,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Track Live',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.surfaceBright,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
