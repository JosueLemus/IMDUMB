import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextStyle movieTitle = TextStyle(
    fontFamily: 'Anton',
    fontSize: 44,
    fontWeight: FontWeight.w900,
    color: AppColors.movieAccent,
    height: 0.9,
    letterSpacing: 1.2,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle movieAppBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle movieMetaInfo = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.grey,
  );

  static const TextStyle movieStatsValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle movieStatsLabel = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle movieOverview = TextStyle(fontSize: 16, height: 1.6);

  static const TextStyle genreChip = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}
