import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
}
