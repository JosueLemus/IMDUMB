import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final Color primaryColor;

  const ThemeState({required this.primaryColor});

  factory ThemeState.initial() {
    return const ThemeState(primaryColor: Color(0xFF3713EC));
  }

  @override
  List<Object?> get props => [primaryColor];

  ThemeState copyWith({Color? primaryColor}) {
    return ThemeState(primaryColor: primaryColor ?? this.primaryColor);
  }
}
