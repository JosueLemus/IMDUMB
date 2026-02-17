import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/theme_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeService _themeService;

  ThemeCubit(this._themeService) : super(ThemeState.initial());

  void init() {
    final hexColor = _themeService.getPrimaryColor();
    emit(state.copyWith(primaryColor: _parseHexColor(hexColor)));
  }

  void updatePrimaryColor(String hexColor) {
    emit(state.copyWith(primaryColor: _parseHexColor(hexColor)));
  }

  Color _parseHexColor(String hexColor) {
    try {
      String hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return const Color(0xFF3713EC);
    }
  }
}
