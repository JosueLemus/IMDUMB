import 'package:hive/hive.dart';

import '../models/genre_model.dart';

abstract class MovieLocalDataSource {
  Future<List<GenreModel>> getCachedGenres();
  Future<void> cacheGenres(List<GenreModel> genres);
  Future<void> clearCache();
  Future<void> toggleFavorite(GenreModel movie);
  Future<bool> isFavorite(int id);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static const String _genresBoxName = 'genresBox';
  static const String _favoritesBoxName = 'favoritesBox';

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
    await Hive.deleteBoxFromDisk(_favoritesBoxName);
  }

  @override
  Future<void> toggleFavorite(GenreModel movie) async {
    final box = await Hive.openBox<GenreModel>(_favoritesBoxName);
    if (box.containsKey(movie.id)) {
      await box.delete(movie.id);
    } else {
      await box.put(movie.id, movie);
    }
  }

  @override
  Future<bool> isFavorite(int id) async {
    final box = await Hive.openBox<GenreModel>(_favoritesBoxName);
    return box.containsKey(id);
  }
}
