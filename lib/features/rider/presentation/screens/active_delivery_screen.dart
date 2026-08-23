import 'package:flutter/material.dart';
import 'package:swiftcel/features/rider/widgets/update_status_screen.dart';
import '../../../../core/constants/app_colors.dart';

enum DeliveryStopStatus {
  arrived,
  pickedUp,
  inTransit,
  delivered,
  recipientUnavailable,
  returned,
}

class ActiveDeliveryScreen extends StatefulWidget {
  final String deliveryId;
  const ActiveDeliveryScreen({super.key, required this.deliveryId});

  @override
  State<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  // TODO: replace with real data from DeliveryProvider, keyed by widget.deliveryId
  DeliveryStopStatus _currentStatus = DeliveryStopStatus.inTransit;
  final String senderName = 'Ethan Brooks';
  final String senderLocation = 'Melbourne VIC 3000';
  final String trackingNumber = '34AP123456789';
  final String routeLabel = 'Active Multi-stop Route';
  final String timeRemaining = '2h 15m';

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
        // TODO: context.push('/rider/proof-of-delivery/${widget.deliveryId}');
      }
    }
  }

  void _copyTrackingNumber() {
    // TODO: Clipboard.setData(ClipboardData(text: trackingNumber))
  }

  final String _image = 'assets/images/image.png';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        leading: BackButton(),
        centerTitle: true,
        title: Text('Tracking', style: textTheme.headlineMedium),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onPressed: () {
              // TODO: overflow menu — report issue, contact support, etc.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: colorScheme.surfaceContainerLowest,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 64,
                            color: AppColors.orangePrimary.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Map view — pending Maps API activation',
                            style: textTheme.bodySmall,
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
                        color: colorScheme.surfaceBright,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    colorScheme.surfaceContainerLowest,
                                child: _image.isNotEmpty
                                    ? Image.asset(_image, fit: BoxFit.cover)
                                    : Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(senderName, style: textTheme.titleLarge),
                                  Text(
                                    senderLocation,
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.chat_bubble_outline,
                                    size: 18,
                                    color: colorScheme.onSurface,
                                  ),
                                  tooltip: 'Chat Sender',
                                  onPressed: () {
                                    // TODO: navigate to '/chat/:chatId' for this delivery
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      trackingNumber,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: _copyTrackingNumber,
                                      icon: Icon(
                                        Icons.copy_outlined,
                                        size: 18,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      tooltip: 'Copy',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'In Transit', //TODO ; show that stop one is complete
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '$timeRemaining remaining',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _StopSummaryList(),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _openUpdateStatusSheet,
                              icon: Icon(
                                Icons.refresh,
                                size: 18,
                                color: colorScheme.surfaceBright,
                              ),
                              label: Text(
                                'Update Status',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.surfaceBright,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                padding: EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }
}

class _StopSummaryList extends StatelessWidget {
  const _StopSummaryList();

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real stop data — mock, matches reference design's 3-stop layout
    const stops = [
      (
        title: 'Stop 1: Current Delivery',
        subtitle: 'Melbourne VIC 3000',
        state: 'active',
        subSteps: [
          ('Picked Up', true),
          ('In Transit (Active)', true),
          ('Delivered', false),
        ],
      ),
      (
        title: 'Stop 2: Next Delivery',
        subtitle: 'Richmond VIC 3121',
        state: 'pending',
        subSteps: <(String, bool)>[],
      ),
      (
        title: 'Stop 3: Final Delivery',
        subtitle: 'South Yarra VIC 3141',
        state: 'pending',
        subSteps: <(String, bool)>[],
      ),
    ];

    return Column(
      children: List.generate(stops.length, (index) {
        final stop = stops[index];
        final isActive = stop.state == 'active';
        final isLast = index == stops.length - 1;

        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerLowest,
                      shape: BoxShape.circle,
                    ),
                    child: isActive
                        ? Icon(
                            Icons.circle,
                            size: 8,
                            color: colorScheme.surfaceBright,
                          )
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        color: colorScheme.surfaceContainerLowest,
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.title,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        stop.subtitle,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (stop.subSteps.isNotEmpty) ...[
                        SizedBox(height: 6),
                        ...stop.subSteps.map(
                          (sub) => Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Row(
                              children: [
                                Icon(
                                  sub.$2
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 12,
                                  color: sub.$2
                                      ? AppColors.success
                                      : colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  sub.$1,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: sub.$2
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
