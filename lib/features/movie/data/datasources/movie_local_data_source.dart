import 'package:hive/hive.dart';

import '../models/genre_model.dart';

abstract class MovieLocalDataSource {
  Future<List<GenreModel>> getCachedGenres();
  Future<void> cacheGenres(List<GenreModel> genres);
  Future<void> clearCache();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static const String _genresBoxName = 'genresBox';

  @override
  Future<List<GenreModel>> getCachedGenres() async {
    final box = await Hive.openBox<GenreModel>(_genresBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheGenres(List<GenreModel> genres) async {
    final box = await Hive.openBox<GenreModel>(_genresBoxName);
    await box.clear();
    await box.addAll(genres);
  }

  @override
  Future<void> clearCache() async {
    await Hive.deleteBoxFromDisk(_genresBoxName);
  }
}
