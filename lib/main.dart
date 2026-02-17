import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imdumb/core/services/remote_config_service.dart';
import 'package:imdumb/core/services/theme_service.dart';
import 'package:imdumb/core/theme/cubit/theme_cubit.dart';
import 'package:imdumb/core/theme/cubit/theme_state.dart';
import 'package:imdumb/features/movie/data/models/genre_model.dart';
import 'package:imdumb/firebase_options.dart';

import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await di.init();
  await sl<ThemeService>().init();
  await sl<RemoteConfigService>().initialize();
  Hive.registerAdapter(GenreModelAdapter());
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ThemeCubit>()..init(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(state.primaryColor),
            darkTheme: AppTheme.dark(state.primaryColor),
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
