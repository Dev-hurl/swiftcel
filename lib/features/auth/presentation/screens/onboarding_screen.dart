import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

class OnboardingSlide {
  final String title;
  final String subtitle;
  final String imagePath;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'Fast, Reliable Deliveries',
      subtitle:
          'Send parcels anywhere, anytime, with real-time tracking every step of the way.',
      imagePath: 'assets/images/delivery.png',
    ),
    OnboardingSlide(
      title: 'Trusted Riders Near You',
      subtitle:
          'Verified riders pick up and deliver your parcels safely and on time.',
      imagePath: 'assets/images/rider.png',
    ),
    OnboardingSlide(
      title: 'Track in Real-time',
      subtitle:
          'Watch your delivery move across the map. Get precision updates every step of the journey.',
      imagePath: 'assets/images/track in real time.png',
    ),
    OnboardingSlide(
      title: 'Safe Delivery',
      subtitle:
          'Our secure network ensures your parcels arrive exactly as they left. Reliability is our core promise.',
      imagePath: 'assets/images/ai_drone.png',
    ),
  ];

  Future<void> _goToLogin() async {
    await context.read<AuthProvider>().completeOnboarding();
    if (!mounted) return;
    context.go('/signup');
  }

  void _onGetStartedPressed() {
    if (_currentPage == _slides.length - 1) {
      _goToLogin();
      debugPrint('Navigated');
    } else {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/icons/orange transparent logo only.png'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surface,
              AppColors.orangeContainer,
            ], // TODO: swap for your exact hex
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          Text(
                            slide.title,
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(slide.subtitle, style: textTheme.titleSmall),
                          SizedBox(height: 24),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(16),
                              child: Image.asset(
                                slide.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              _PageDots(count: _slides.length, currentIndex: _currentPage),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onGetStartedPressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      backgroundColor: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      shadowColor: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.08,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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

class _PageDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageDots({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 2),
          height: 6,
          width: isActive ? 16 : 6,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
