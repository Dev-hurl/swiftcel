import 'dart:async';
import 'package:flutter/material.dart';
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
  bool _isOnline = true;
  int _secondsLeft = 45;
  Timer? _timer;

  final JobOffer? _activeOffer = JobOffer(
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

  void _acceptJob(String offerId) {
    // TODO: call JobOfferProvider.acceptJob(offerId), then push to '/rider/job/:deliveryId'
  }

  void _declineJob(String offerId) {
    // TODO: call JobOfferProvider.declineJob(offerId)
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
          Text(
            _isOnline ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _isOnline ? Colors.black87 : Colors.black45,
            ),
          ),
          Switch(
            value: _isOnline,
            activeThumbColor: AppColors.orangeSecondary,
            onChanged: (v) => setState(() => _isOnline = v),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
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
          Expanded(
            child: Stack(
              children: [
                if (_viewMode == RiderViewMode.map)
                  Container(
                    color: Color(0xFFDCEEFB),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 64,
                            color: Colors.blue.shade200,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Map view — pending Maps API activation',
                            style: TextStyle(
                              color: Colors.blue.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  _JobListView(
                    offers: _listOffers,
                    onAccept: _acceptJob,
                    onDecline: _declineJob,
                  ),

                if (_viewMode == RiderViewMode.map && _activeOffer != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _JobOfferCard(
                      offer: _activeOffer,
                      secondsLeft: _secondsLeft,
                      onAccept: () => _acceptJob(_activeOffer.id),
                      onDecline: () => _declineJob(_activeOffer.id),
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.greyBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? AppColors.orangeSecondary
                  : AppColors.onSurface,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: AppFonts.titleLarge.copyWith(
                color: isSelected
                    ? AppColors.orangeSecondary
                    : AppColors.onSurface,
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
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _JobOfferCard({
    required this.offer,
    required this.secondsLeft,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        100,
      ), // clears the floating nav bar
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12),
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
                Text(
                  'NEW JOB AVAILABLE',
                  style: AppFonts.labelSmall.copyWith(
                    color: AppColors.orangeSecondary,
                  ),
                ),
                Text(
                  '${secondsLeft}s',
                  style: AppFonts.labelSmall.copyWith(
                    color: AppColors.orangeSecondary,
                  ),
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
                        color: AppColors.orangeContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.orangeSecondary,
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
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFFD32F2F),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'PICKUP',
                        style: TextStyle(fontSize: 9, color: Colors.black45),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '${offer.distanceKm}km away',
                        style: AppFonts.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDecline,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Decline',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.orangePrimary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Accept Job',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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
  final void Function(String) onAccept;
  final void Function(String) onDecline;

  const _JobListView({
    required this.offers,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.greyBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.04),
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
                    color: AppColors.orangeContainer,
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
          );
        },
      ),
    );
  }
}
