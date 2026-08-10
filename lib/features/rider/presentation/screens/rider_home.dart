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
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/icons/orange transparent logo only.png',
          width: 60,
          height: 60,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/notifications');
            },
            icon: Icon(Icons.notifications),
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
                            color: AppColors.orangePrimary,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Map view — pending Maps API activation',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
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
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.onSurface.withValues(alpha: 0.05),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.onSurface.withValues(alpha: 0.05)
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
              color: isSelected ? AppColors.surface : AppColors.onSurface,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: AppFonts.titleLarge.copyWith(
                color: isSelected ? AppColors.surface : AppColors.onSurface,
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

  const _JobOfferCard({
    required this.offer,
    required this.secondsLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 100),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.1),
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
              color: AppColors.orangeContainer,
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
                        color: AppColors.orangeSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'NEW JOB AVAILABLE',
                      style: AppFonts.labelSmall.copyWith(
                        color: AppColors.orangeSecondary,
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
                      color: AppColors.orangeSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${secondsLeft}s',
                      style: AppFonts.labelSmall.copyWith(
                        color: AppColors.orangeSecondary,
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
                        color: AppColors.onSurface,
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
                            style: AppFonts.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(offer.subCategory, style: AppFonts.labelSmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${offer.payout.toStringAsFixed(2)}',
                          style: AppFonts.titleLarge.copyWith(
                            color: AppColors.orangePrimary,
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
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.onSurfaceVariant,
                      ),
                      SizedBox(width: 6),
                      Text('PICKUP', style: AppFonts.labelSmall),
                      SizedBox(width: 8),
                      Text(
                        '${offer.distanceKm}km away',
                        style: AppFonts.titleSmall,
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
                      color: AppColors.white,
                    ),
                    label: Text(
                      'View Job Details',
                      style: AppFonts.labelLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeSecondary,
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

  const _JobListView({
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
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
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withValues(alpha: 0.05),
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
                      color: AppColors.greyBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: AppColors.orangeSecondary,
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
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${offer.payout.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(0xFFD32F2F),
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
