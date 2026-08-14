// lib/features/sender/presentation/screens/create_delivery_location_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';

class DestinationStop {
  final int number;
  final String address;
  final bool isExpanded;

  const DestinationStop({
    required this.number,
    required this.address,
    this.isExpanded = false,
  });

  DestinationStop copyWith({bool? isExpanded}) {
    return DestinationStop(
      number: number,
      address: address,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class CreateDeliveryAddressScreen extends StatefulWidget {
  const CreateDeliveryAddressScreen({super.key});

  @override
  State<CreateDeliveryAddressScreen> createState() =>
      _CreateDeliveryAddressScreenState();
}

class _CreateDeliveryAddressScreenState
    extends State<CreateDeliveryAddressScreen> {
  // TODO: mock data — no real multi-stop backend/provider wired yet
  final String pickupAddress = '100 Market Street';
  final String pickupSubLabel = 'San Francisco, CA 94105';
  final String parcelCategory =
      'Electronics'; // TODO: should come from CreateParcelScreen's selection

  List<DestinationStop> _stops = const [
    DestinationStop(number: 1, address: '456 Tech Boulevard, Floor 4'),
    DestinationStop(number: 2, address: '456 Atonsi Boulevard'),
  ];

  void _toggleStop(int index) {
    setState(() {
      _stops = List.generate(_stops.length, (i) {
        if (i == index)
          return _stops[i].copyWith(isExpanded: !_stops[i].isExpanded);
        return _stops[i];
      });
    });
  }

  void _addStop() {
    // TODO: open an address search/autocomplete flow (Places API) instead of a hardcoded stop
    setState(() {
      _stops = [
        ..._stops,
        DestinationStop(number: _stops.length + 1, address: 'New stop address'),
      ];
    });
  }

  void _removeStop(int index) {
    setState(() {
      _stops = _stops.where((s) => s.number != _stops[index].number).toList();
    });
  }

  void _setLocation() {
    // TODO: pass stops forward via a shared DeliveryDraftProvider once wired
    context.push('/sender/create-review');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Location Details',
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: 0.5, // Step 2 of 4
                    minHeight: 4,
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    color: colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 6),
                Text('Step 2 of 4', style: textTheme.labelSmall),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceBright,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.storefront_outlined,
                          color: AppColors.success,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PICKUP',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(pickupAddress, style: textTheme.titleSmall),
                            Text(pickupSubLabel, style: textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Destination Stops', style: textTheme.titleSmall),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Route optimization active',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ...List.generate(_stops.length, (index) {
                  final stop = _stops[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _StopTile(
                      stop: stop,
                      onTap: () => _toggleStop(index),
                      onRemove: () => _removeStop(index),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: _addStop,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.secondary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 16, color: colorScheme.secondary),
                        SizedBox(width: 6),
                        Text(
                          'Add Another Stop',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _setLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Review Summary',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.surfaceBright,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: colorScheme.surfaceBright,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  final DestinationStop stop;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _StopTile({
    required this.stop,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (!stop.isExpanded) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceBright,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${stop.number}',
                    style: AppFonts.labelSmall.copyWith(
                      color: colorScheme.surfaceBright,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: Text(stop.address, style: textTheme.bodyMedium)),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: colorScheme.surfaceContainerHigh,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Expanded state — matches phone frame 2
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${stop.number}',
                      style: AppFonts.labelSmall.copyWith(
                        color: colorScheme.surfaceBright,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(stop.address, style: AppFonts.bodyMedium),
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.expand_less,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Type',
                      style: AppFonts.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                              'Small Box', // TODO: replace with real ParcelSizeOption enum from CreateDeliveryParcelScreen
                          isExpanded: true,
                          style: AppFonts.bodySmall,
                          items: [
                            DropdownMenuItem(
                              value: 'Small Box',
                              child: Text('Small Box'),
                            ),
                            DropdownMenuItem(
                              value: 'Medium Box',
                              child: Text('Medium Box'),
                            ),
                            DropdownMenuItem(
                              value: 'Large Box',
                              child: Text('Large Box'),
                            ),
                          ],
                          onChanged: (_) {
                            // TODO: wire to per-stop parcel state once DeliveryDraftProvider exists
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight',
                      style: AppFonts.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: AppFonts.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLow,
                        hintText: '0.0',
                        suffixText: 'kg',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Recipient Name',
            style: AppFonts.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          TextField(decoration: InputDecoration(hintText: 'e.g. Mike T')),
          SizedBox(height: 12),
          Text(
            'Recipient Phone',
            style: AppFonts.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '+1 (555) 000-0000',
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Instruction',
            style: AppFonts.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: 'e.g. Keep upright, fragile...',
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
            ),
          ),
        ],
      ),
    );
  }
}
