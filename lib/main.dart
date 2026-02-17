import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imdumb/core/bloc/app_bloc_observer.dart';
import 'package:imdumb/core/di/injection_container.dart';
import 'package:imdumb/core/services/remote_config_service.dart';
import 'package:imdumb/core/services/theme_service.dart';
import 'package:imdumb/features/movie/data/models/genre_model.dart';
import 'package:imdumb/firebase_options_prod.dart';

import 'app.dart';
import 'firebase_options_qa.dart' as qa;
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavorParam = const String.fromEnvironment('appFlavor');
  F.appFlavor = Flavor.values.firstWhere(
    (e) => e.name == flavorParam,
    orElse: () => Flavor.prod,
  );

  final options = F.appFlavor == Flavor.qa
      ? qa.DefaultFirebaseOptions.currentPlatform
      : ProdFirebaseOptions.currentPlatform;

  await Firebase.initializeApp(options: options);

  await mainCommon();
}

Future<void> mainCommon() async {
  Bloc.observer = AppBlocObserver();

  await FirebaseAnalytics.instance.setUserProperty(
    name: 'env',
    value: F.appFlavor.name,
  );

  await Hive.initFlutter();
  await init();
  await sl<ThemeService>().init();
  await sl<RemoteConfigService>().initialize();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(GenreModelAdapter());
  }

  final envFile = F.appFlavor == Flavor.qa ? ".env.qa" : ".env.prod";
  await dotenv.load(fileName: envFile);

  runApp(const App());
}
