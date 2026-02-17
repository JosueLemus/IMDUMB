import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/core/di/injection_container.dart';
import 'package:imdumb/core/router/app_router.dart';
import 'package:imdumb/core/theme/app_theme.dart';
import 'package:imdumb/core/theme/cubit/theme_cubit.dart';
import 'package:imdumb/core/theme/cubit/theme_state.dart';
import 'package:imdumb/features/movie/presentation/bloc/user_recommendations_cubit.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ThemeCubit>()..init()),
        BlocProvider(create: (context) => sl<UserRecommendationsCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          Widget app = MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: F.title,
            theme: AppTheme.light(state.primaryColor),
            darkTheme: AppTheme.dark(state.primaryColor),
            themeMode: state.themeMode,
            routerConfig: AppRouter.router,
          );

          return _flavorBanner(child: app);
        },
      ),
    );
  }

  Widget _flavorBanner({required Widget child}) {
    if (F.appFlavor != Flavor.qa) return child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.topStart,
        message: 'QA',
        color: Colors.orange.withValues(alpha: 0.8),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          letterSpacing: 1.0,
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
