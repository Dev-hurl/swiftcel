import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── BACAKGROUND ───────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFF8F9FB); //The primary background color
  static const Color white = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(
    0xFFE1E2E8,
  ); //Used for input fields, inactive states, and subtle dividers.
  static const Color greyBg = Color(0xFFF2F4F6); //Grey

  // ─── BRAND ───────────────────────────────────────────
  static const Color orangePrimary = Color(0xFFFF6B35);
  static const Color orangeSecondary = Color(0xFFF51C1C);
  static const Color orangeContainer = Color(0xFFFFDAD2);

  // ─── TEXT ───────────────────────────────────────────
  static const Color onSurface = Color(0xFF1A1C1E); //The primary color for text
  static const Color onSurfaceVariant = Color(0xFF44474E); //Secondary text

  // ─── STATUS ───────────────────────────────────────────
  static const Color information = Color(
    0xFF0061A4,
  ); //tracking states and informational badges.
  static const Color error = Color(0xFFBA1A1A); //Error, cancelled
  static const Color warning = Color(0xFFFFB74D); //pending reviews
  static const Color success = Color(0xFF48BB78); //Delivered , Success B8F33E
}
