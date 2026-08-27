import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ParcelCategory { electronics, documents, clothing, food, other }

enum ParcelSizeOption { small, medium, large }

class CreateParcelScreen extends StatefulWidget {
  const CreateParcelScreen({super.key});

  @override
  State<CreateParcelScreen> createState() => _CreateParcelScreenState();
}

class _CreateParcelScreenState extends State<CreateParcelScreen> {
  ParcelCategory _selectedCategory = ParcelCategory.electronics;
  ParcelSizeOption? _selectedSize = ParcelSizeOption.medium;
  final _weightController = TextEditingController();
  String?
  _capturedPhotoPath; // TODO: wire up image_picker for auto-size-detection photo

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    context.push('/sender/capture-parcel');
  }

  void _continueToLocation() {
    // TODO: pass parcel details forward via a shared DeliveryDraftProvider once wired
    context.push('/sender/delivery-address');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Parcel Details', style: textTheme.headlineMedium),
      ),
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
                    value: 0.25, // Step 1 of 4
                    minHeight: 4,
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 6),
                Text('Step 1 of 4', style: textTheme.labelSmall),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                GestureDetector(
                  onTap: _capturePhoto,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      image: _capturedPhotoPath != null
                          ? DecorationImage(
                              image: AssetImage(_capturedPhotoPath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _capturedPhotoPath == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 32,
                                  color: colorScheme.primary,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Upload images of your parcel',
                                  style: textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Text('Parcel Category', style: textTheme.titleSmall),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ParcelCategory>(
                      value: _selectedCategory,
                      isExpanded: true,
                      style: textTheme.bodyMedium,
                      items: [
                        DropdownMenuItem(
                          value: ParcelCategory.electronics,
                          child: Text('Electronics'),
                        ),
                        DropdownMenuItem(
                          value: ParcelCategory.documents,
                          child: Text('Documents'),
                        ),
                        DropdownMenuItem(
                          value: ParcelCategory.clothing,
                          child: Text('Clothing'),
                        ),
                        DropdownMenuItem(
                          value: ParcelCategory.food,
                          child: Text('Food'),
                        ),
                        DropdownMenuItem(
                          value: ParcelCategory.other,
                          child: Text('Other'),
                        ),
                      ],
                      onChanged: (v) => setState(
                        () => _selectedCategory = v ?? _selectedCategory,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Total Weight (kg)', style: textTheme.titleSmall),
                SizedBox(height: 8),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    suffixText: 'kg',
                  ),
                ),
                SizedBox(height: 20),
                Text('Parcel Size', style: textTheme.titleSmall),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _SizeOption(
                        label: 'Small',
                        isSelected: _selectedSize == ParcelSizeOption.small,
                        onTap: () => setState(
                          () => _selectedSize = ParcelSizeOption.small,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _SizeOption(
                        label: 'Medium',
                        isSelected: _selectedSize == ParcelSizeOption.medium,
                        onTap: () => setState(
                          () => _selectedSize = ParcelSizeOption.medium,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _SizeOption(
                        label: 'Large',
                        isSelected: _selectedSize == ParcelSizeOption.large,
                        onTap: () => setState(
                          () => _selectedSize = ParcelSizeOption.large,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _continueToLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Set Location',
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

class _SizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.tertiary
              : colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: colorScheme.secondary) : null,
        ),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
