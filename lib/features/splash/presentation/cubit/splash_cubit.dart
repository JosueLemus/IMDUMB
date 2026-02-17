import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/core/services/remote_config_service.dart';
import 'package:imdumb/core/services/theme_service.dart';
import 'package:imdumb/core/theme/cubit/theme_cubit.dart';

import 'package:imdumb/features/movie/presentation/bloc/user_recommendations_cubit.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final RemoteConfigService _remoteConfigService;
  final ThemeService _themeService;
  final ThemeCubit _themeCubit;
  final UserRecommendationsCubit _userRecommendationsCubit;

  SplashCubit({
    required RemoteConfigService remoteConfigService,
    required ThemeService themeService,
    required ThemeCubit themeCubit,
    required UserRecommendationsCubit userRecommendationsCubit,
  }) : _remoteConfigService = remoteConfigService,
       _themeService = themeService,
       _themeCubit = themeCubit,
       _userRecommendationsCubit = userRecommendationsCubit,
       super(const SplashState());

  Future<void> init() async {
    emit(state.copyWith(status: SplashStatus.loading));

    await Future.wait([
      _userRecommendationsCubit.loadRecommendations(),
      _remoteConfigService.initialize(),
    ]);

    final newPrimaryColor = _remoteConfigService.getPrimaryColor();

    await _themeService.savePrimaryColor(newPrimaryColor);

    _themeCubit.updatePrimaryColor(newPrimaryColor);

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: SplashStatus.success));
  }
}
