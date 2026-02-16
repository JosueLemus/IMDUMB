import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByGenre {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> execute(int genreId) async {
    return await repository.getMoviesByGenre(genreId);
  }
}
