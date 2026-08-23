// lib/core/constants/app_fonts.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  AppFonts._(); // prevents instantiation — this is a static-only container

  static const String _fontFamily = 'Plus Jakarta Sans';

  // ---- DISPLAY ----
  // Splash screens, onboarding hero text, major promotional headers
  static TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  // ---- HEADLINES ----
  // Page titles, high-level section headings
  static TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurfaceVariant,
  );

  // ---- TITLES ----
  // Card titles, list headers, prominent UI labels
  static TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  // ---- BODY ----
  // Primary reading content, descriptions, user input
  static TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  // ---- LABELS ----
  // Buttons, status badges, micro-copy, form captions
  static TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  // ---- HIERARCHY HELPERS ----
  // Convenience variants for the brand/secondary color rules, so you're not
  // manually calling .copyWith(color: ...) everywhere a CTA or timestamp shows up

  static TextStyle brandHero(TextStyle base) => base.copyWith(
    color: AppColors.orangePrimary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle secondary(TextStyle base) =>
      base.copyWith(color: AppColors.onSurfaceVariant);
}
