import 'package:flutter/material.dart';

class DeliveryHistory extends StatelessWidget {
  const DeliveryHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Delivery History', style: textTheme.headlineMedium),
      ),
    );
  }
}
