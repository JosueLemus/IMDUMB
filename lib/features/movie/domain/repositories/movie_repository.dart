import '../entities/cast.dart';
import '../entities/crew.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';
import '../entities/movie_details.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<MovieDetails> getMovieDetails(int id);
  Future<(List<Cast>, List<Crew>)> getMovieCredits(int id);
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
  Future<void> clearCache();
  Future<void> toggleFavorite(Movie movie);
  Future<bool> isFavorite(int id);
}
