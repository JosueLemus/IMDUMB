import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF3713EC);

  // Theme Source Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightAltBackground = Color(0xFFF3F4F6);
  static const Color lightPrimaryText = Color(0xFF111827);
  static const Color lightSecondaryText = Color(0xFF4B5563);

  static const Color darkBackground = Color(0xFF131022);
  static const Color darkSurface = Color(0xFF1C192E);
  static const Color darkAltSurface = Color(0xFF1E1B2E);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFF9CA3AF);

  // Semantic Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF3B82F6);
  static const Color error = Color(0xFFE62117);

  // Utility Colors
  static const Color bannerPlaceholder = Color(0xFF111111);
  static const Color scrim = Color(0x99000000);
}
