import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';

class RateRiderScreen extends StatefulWidget {
  const RateRiderScreen({super.key});

  @override
  State<RateRiderScreen> createState() => _RateRiderScreenState();
}

class _RateRiderScreenState extends State<RateRiderScreen> {
  final String _image = '';

  @override
  Widget build(BuildContext context) {
    const String name = 'Marcus Johnson';
    const String email = 'marcus.j@swiftcel.com';

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: colorScheme.surfaceBright),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: colorScheme.tertiary,
                              child: _image.isNotEmpty
                                  ? Image.asset(_image)
                                  : Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: -4,
                              right: -2,
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                      color: colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(name, style: textTheme.titleLarge),
                        SizedBox(height: 4),
                        Text(
                          email,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.star_border),
                              Icon(Icons.star_border),
                              Icon(Icons.star_border),
                              Icon(Icons.star_border),
                              Icon(Icons.star_border),
                              Icon(Icons.star_border),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tell us about your experience',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText:
                                    'Was your delivery on time?  Friendly service?',
                                filled: true,
                                fillColor: colorScheme.surfaceContainerLowest,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: FilledButton(
                            onPressed: () {},
                            child: Text('Submit Rating'),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Skip for Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
