import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  static String get baseUrl =>
      dotenv.get('TMDB_BASE_URL', fallback: 'https://api.themoviedb.org/3');
  static String get accessToken =>
      dotenv.get('TMDB_ACCESS_TOKEN', fallback: '');
}
