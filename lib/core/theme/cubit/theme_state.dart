import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final Color primaryColor;
  final ThemeMode themeMode;

  const ThemeState({
    required this.primaryColor,
    this.themeMode = ThemeMode.system,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      primaryColor: Color(0xFF3713EC),
      themeMode: ThemeMode.system,
    );
  }

  @override
  List<Object?> get props => [primaryColor, themeMode];

  ThemeState copyWith({Color? primaryColor, ThemeMode? themeMode}) {
    return ThemeState(
      primaryColor: primaryColor ?? this.primaryColor,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
