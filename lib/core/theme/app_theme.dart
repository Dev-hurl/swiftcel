// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    fontFamily: 'Plus Jakarta Sans',

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orangeSecondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),

    textTheme: TextTheme(
      displayLarge: AppFonts.displayLarge,
      displayMedium: AppFonts.displayMedium,
      displaySmall: AppFonts.displaySmall,
      headlineLarge: AppFonts.headlineLarge,
      headlineMedium: AppFonts.headlineMedium,
      headlineSmall: AppFonts.headlineSmall,
      titleLarge: AppFonts.titleLarge,
      titleMedium: AppFonts.titleMedium,
      titleSmall: AppFonts.titleSmall,
      bodyLarge: AppFonts.bodyLarge,
      bodyMedium: AppFonts.bodyMedium,
      bodySmall: AppFonts.bodySmall,
      labelLarge: AppFonts.labelLarge,
      labelMedium: AppFonts.labelMedium,
      labelSmall: AppFonts.labelSmall,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.onSurface),
      titleTextStyle: AppFonts.titleLarge,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orangeSecondary,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: AppFonts.labelLarge.copyWith(color: Colors.white),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        padding: EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: AppColors.surfaceVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: AppFonts.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.orangeSecondary,
        textStyle: AppFonts.labelMedium,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: AppFonts.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.orangeSecondary;
        }
        return AppColors.surfaceVariant;
      }),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.orangeSecondary;
        }
        return AppColors.surfaceVariant;
      }),
    ),

    dividerTheme: DividerThemeData(
      color: AppColors.surfaceVariant,
      thickness: 1,
    ),

    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
