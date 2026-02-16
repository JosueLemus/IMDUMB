import '../entities/cast.dart';
import '../entities/crew.dart';
import '../entities/movie.dart';
import '../entities/movie_details.dart';
import '../entities/genre.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<MovieDetails> getMovieDetails(int id);
  Future<(List<Cast>, List<Crew>)> getMovieCredits(int id);
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getMoviesByGenre(int genreId);
  Future<void> clearCache();
}
