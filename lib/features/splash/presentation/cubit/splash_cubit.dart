import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> init() async {
    emit(state.copyWith(status: SplashStatus.loading));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: SplashStatus.success));
  }
}
