import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackParcelScreen extends StatelessWidget {
  const TrackParcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Track Parcel', style: textTheme.headlineMedium),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              tileColor: colorScheme.surfaceContainerHigh,
              title: Text('New Delivery'),
              subtitle: Text('#12WE4'),
              trailing: IconButton(
                onPressed: () {
                  context.push('/sender/bulk-shipment-dashboard');
                },
                icon: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
