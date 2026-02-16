import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightPrimaryText,
        surfaceContainerHighest: AppColors.lightAltBackground,
        onSurfaceVariant: AppColors.lightSecondaryText,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme:
          const TextTheme(
            displayLarge: AppTypography.displayLarge,
            headlineMedium: AppTypography.headlineMedium,
            bodyLarge: AppTypography.bodyLarge,
            bodyMedium: AppTypography.bodyMedium,
            labelLarge: AppTypography.labelLarge,
          ).apply(
            bodyColor: AppColors.lightPrimaryText,
            displayColor: AppColors.lightPrimaryText,
          ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkPrimaryText,
        surfaceContainerHighest: AppColors.darkAltSurface,
        onSurfaceVariant: AppColors.darkSecondaryText,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme:
          const TextTheme(
            displayLarge: AppTypography.displayLarge,
            headlineMedium: AppTypography.headlineMedium,
            bodyLarge: AppTypography.bodyLarge,
            bodyMedium: AppTypography.bodyMedium,
            labelLarge: AppTypography.labelLarge,
          ).apply(
            bodyColor: AppColors.darkPrimaryText,
            displayColor: AppColors.darkPrimaryText,
          ),
    );
  }
}
