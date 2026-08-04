import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
      title: 'Smart AI Drone Delivering the Future',
      subtitle:
          'Empower your deliveries with intelligent drone technology that makes shipping faster, safer, smarter.',
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8ECE0),
              Color(0xFFD4E157),
            ], // TODO: swap for your exact hex
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24, top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/white Logo.png',
                    height: 24,
                  ),
                ),
              ),
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
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.6),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                slide.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIconButton(
                      icon: Icons.arrow_back,
                      onTap: _goToLogin,
                    ), // skip intro
                    GestureDetector(
                      onTap: _onGetStartedPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _slides.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _PageDots(
                              count: _slides.length,
                              currentIndex: _currentPage,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _CircleIconButton(
                      icon: Icons.check,
                      filled: true,
                      onTap: _goToLogin,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled
              ? Color(0xFFB5C93B)
              : Colors.transparent, // TODO: swap for your accent hex
          border: filled ? null : Border.all(color: Colors.black26),
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : Colors.black87,
          size: 20,
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 6,
          width: isActive ? 16 : 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.black87 : Colors.black26,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
