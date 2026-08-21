import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // TODO: restore once Maps billing resolves

enum RiderViewMode { map, list }

class JobOffer {
  final String id;
  final String category;
  final String subCategory;
  final double payout;
  final double distanceKm;
  final String deliverByTime;

  JobOffer({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.payout,
    required this.distanceKm,
    required this.deliverByTime,
  });
}

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  RiderViewMode _viewMode = RiderViewMode.map;
  int _secondsLeft = 45;
  Timer? _timer;

  final JobOffer _activeOffer = JobOffer(
    id: 'SWC-90210',
    category: 'Small Box',
    subCategory: 'Electronics & Gadgets',
    payout: 12.50,
    distanceKm: 2,
    deliverByTime: '14:30 PM',
  );

  final List<JobOffer> _listOffers = [
    JobOffer(
      id: 'SWC-90210',
      category: 'Small Box',
      subCategory: 'Electronics & Gadgets',
      payout: 12.50,
      distanceKm: 2,
      deliverByTime: '14:30 PM',
    ),
    JobOffer(
      id: 'SWC-90188',
      category: 'Documents',
      subCategory: 'Legal Paperwork',
      payout: 7.00,
      distanceKm: 1.2,
      deliverByTime: '13:50 PM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = 45;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 24),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning', style: textTheme.bodyMedium),
            Text('Alex Mercer', style: textTheme.headlineLarge),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
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
                top: -6,
                right: -3,
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
                      style: textTheme.labelMedium?.copyWith(
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_viewMode == RiderViewMode.map)
                  Container(
                    color: AppColors.greyBg,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 64,
                            color: colorScheme.primary,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Map view — pending Maps API activation',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  _JobListView(offers: _listOffers),

                // Toggle now floats over whichever content is above, pinned near the top
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ToggleSegment(
                            label: 'Map',
                            icon: Icons.map_outlined,
                            isSelected: _viewMode == RiderViewMode.map,
                            onTap: () =>
                                setState(() => _viewMode = RiderViewMode.map),
                          ),
                          _ToggleSegment(
                            label: 'List',
                            icon: Icons.list,
                            isSelected: _viewMode == RiderViewMode.list,
                            onTap: () =>
                                setState(() => _viewMode = RiderViewMode.list),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_viewMode == RiderViewMode.map)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _JobOfferCard(
                      offer: _activeOffer,
                      secondsLeft: _secondsLeft,
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

class _ToggleSegment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleSegment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colorScheme.onSurface.withValues(alpha: 0.05)
                  : Colors.transparent,
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? colorScheme.surface : colorScheme.onSurface,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: textTheme.titleLarge?.copyWith(
                color: isSelected ? colorScheme.surface : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobOfferCard extends StatelessWidget {
  final JobOffer offer;
  final int secondsLeft;

  const _JobOfferCard({required this.offer, required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 100),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'NEW JOB AVAILABLE',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: colorScheme.secondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${secondsLeft}s',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: colorScheme.onSurface,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.category,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(offer.subCategory, style: textTheme.labelSmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${offer.payout.toStringAsFixed(2)}',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('EST. EARNINGS', style: TextStyle(fontSize: 8)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 6),
                      Text('PICKUP', style: textTheme.labelSmall),
                      SizedBox(width: 8),
                      Text(
                        '${offer.distanceKm}km away',
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/rider/multi-stop-job/${offer.id}'),
                    icon: Icon(
                      Icons.description_outlined,
                      size: 18,
                      color: colorScheme.surfaceBright,
                    ),
                    label: Text(
                      'View Job Details',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.surfaceBright,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
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

class _JobListView extends StatelessWidget {
  final List<JobOffer> offers;

  const _JobListView({required this.offers});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 70, 16, 16),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return GestureDetector(
            onTap: () => context.push('/rider/multi-stop-job/${offer.id}'),
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: colorScheme.secondary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.category,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${offer.distanceKm}km away · Deliver by ${offer.deliverByTime}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${offer.payout.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
