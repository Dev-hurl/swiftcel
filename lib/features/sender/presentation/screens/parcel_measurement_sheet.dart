import 'package:flutter/material.dart';

enum PackageSizeOption { large, medium, small }

class ParcelMeasurementSheet extends StatefulWidget {
  const ParcelMeasurementSheet({super.key});

  @override
  State<ParcelMeasurementSheet> createState() => _ParcelMeasurementSheetState();
}

class _ParcelMeasurementSheetState extends State<ParcelMeasurementSheet> {
  // TODO: entirely mocked — no real measurement/weight detection exists
  PackageSizeOption _selectedSize = PackageSizeOption.medium;
  final double mockWeight = 3.5;
  final double mockLength = 25;
  final double mockWidth = 40;
  final double mockHeight = 10;

  void _scanAgain() {
    Navigator.pop(
      context,
      false,
    ); // returns to camera view without applying result
  }

  void _continue() {
    // TODO: pass mock measurement + selected size back to CreateDeliveryParcelScreen
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
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
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Parcel measured', style: textTheme.headlineMedium),
              GestureDetector(
                onTap: _scanAgain,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4),
                      Text('Scan Again', style: textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text('Weight', style: textTheme.labelMedium),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: mockWeight.toString(),
                        style: textTheme.displayMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: ' kg',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'SELECT PACKAGE SIZE',
            style: textTheme.labelMedium?.copyWith(
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SizeChip(
                  label: 'Large',
                  option: PackageSizeOption.large,
                  selected: _selectedSize,
                  onTap: () =>
                      setState(() => _selectedSize = PackageSizeOption.large),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SizeChip(
                  label: 'Medium',
                  option: PackageSizeOption.medium,
                  selected: _selectedSize,
                  onTap: () =>
                      setState(() => _selectedSize = PackageSizeOption.medium),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SizeChip(
                  label: 'Small',
                  option: PackageSizeOption.small,
                  selected: _selectedSize,
                  onTap: () =>
                      setState(() => _selectedSize = PackageSizeOption.small),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DIMENSION',
                style: textTheme.labelMedium?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text('L × W × H', style: textTheme.labelMedium),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DimensionField(label: 'Length', value: mockLength),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _DimensionField(label: 'Width', value: mockWidth),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _DimensionField(label: 'Height', value: mockHeight),
              ),
            ],
          ),
          SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'Continue',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.surfaceBright,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final String label;
  final PackageSizeOption option;
  final PackageSizeOption selected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.label,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final isSelected = option == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.tertiary
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.surfaceContainerHigh,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _DimensionField extends StatelessWidget {
  final String label;
  final double value;

  const _DimensionField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.surfaceContainerHigh,
            ),
          ),
          child: Column(
            children: [
              Row(children: [Text(label, style: textTheme.labelMedium)]),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${value.toInt()}', style: textTheme.headlineLarge),
                  Text('cm', style: textTheme.bodyLarge),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
