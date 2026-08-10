import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SenderEditProfile extends StatefulWidget {
  const SenderEditProfile({super.key});

  @override
  State<SenderEditProfile> createState() => _SenderEditProfileState();
}

class _SenderEditProfileState extends State<SenderEditProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    bool hasImage = false;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile', style: textTheme.headlineMedium),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      shape: BoxShape.circle,
                    ),
                    child: hasImage
                        ? Image.asset(
                            'assets/images/image.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Center(
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      height: 36,
                      width: 36,
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
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceBright,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colorScheme.onSurfaceVariant),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.person_outlined,
                            color: colorScheme.primary,
                          ),
                          Text(
                            'PERSONAL DETAILS',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _fullNameController,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Alex Vance',
                              hintStyle: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerLowest,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            decoration: InputDecoration(
                              hintText: 'alex.v@swiftcel.com',
                              hintStyle: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerLowest,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _phoneNumberController,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            decoration: InputDecoration(
                              hintText: '+1 (555) 019-2834',
                              hintStyle: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerLowest,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: colorScheme.surfaceBright,
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () {
                    //
                  },
                  child: Text(
                    'Save Changes',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.surfaceBright,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
