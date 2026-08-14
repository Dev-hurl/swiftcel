import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class AddressSearch extends StatefulWidget {
  const AddressSearch({super.key});

  @override
  State<AddressSearch> createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GooglePlaceAutoCompleteTextField(
            textEditingController: _addressController,
            googleAPIKey: '',
            inputDecoration: InputDecoration(
              hintText: 'Search address...',
              hintStyle: textTheme.labelMedium,
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            debounceTime: 600,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (prediction) {
              final lat = prediction.lat;
              final lng = prediction.lng;
              final address = prediction.description;
            },
            itemClick: (prediction) {
              _addressController.text = prediction.description ?? '';
            },
          ),
        ],
      ),
    );
  }
}
