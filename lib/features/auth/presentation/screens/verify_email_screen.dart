import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String? oobCode;
  final String? mode;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.oobCode,
    this.mode,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _pollTimer;
  bool _isChecking = false;
  bool _isCompletingActionCode = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'verifyEmail' && widget.oobCode != null) {
      _completeVerificationFromLink();
    }

    // Auto-check every 3 seconds — catches it without the user tapping anything
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerified(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _completeVerificationFromLink() async {
    if (_isCompletingActionCode || widget.oobCode == null) return;
    _isCompletingActionCode = true;

    try {
      await FirebaseAuth.instance.applyActionCode(widget.oobCode!);
      await FirebaseAuth.instance.currentUser?.reload();

      if (mounted) {
        final isVerified =
            FirebaseAuth.instance.currentUser?.emailVerified ?? false;
        if (isVerified) {
          _pollTimer?.cancel();
          context.go('/login');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification link could not be completed: $e'),
          ),
        );
      }
    } finally {
      _isCompletingActionCode = false;
    }
  }

  Future<void> _checkVerified() async {
    if (_isChecking) return;
    _isChecking = true;

    await FirebaseAuth.instance.currentUser?.reload();
    final isVerified =
        FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    _isChecking = false;
    if (isVerified && mounted) {
      _pollTimer?.cancel();
      context.go('/login');
    }
  }

  Future<void> _resendLink() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification email resent',
            style: AppFonts.labelLarge.copyWith(color: AppColors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.orangeSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mark_email_read,
                        size: 24,
                        color: AppColors.surface,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Verify Your Email', style: AppFonts.headlineLarge),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "We've sent a verification link to",
                        children: [
                          TextSpan(
                            text: ' ${widget.email}',
                            style: AppFonts.labelMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    CircularProgressIndicator(color: AppColors.orangePrimary),
                    SizedBox(height: 12),
                    Text(
                      'Waiting for verification...',
                      style: AppFonts.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextButton(
                      onPressed: _resendLink,
                      child: Text('Resend Link'),
                    ),
                    //Goto Sign up Screen
                    TextButton.icon(
                      onPressed: () => context.go('/signup'),
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      label: Text('Go to Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
