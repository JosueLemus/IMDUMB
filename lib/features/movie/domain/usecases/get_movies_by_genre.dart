import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByGenre {
  // [SOLID] Dependency Inversion Principle (DIP):
  // High-level modules (UseCases) depend on abstractions (Repository Interface),
  // not on low-level modules (Repository Implementation).
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> execute(int genreId, {int page = 1}) async {
    return await repository.getMoviesByGenre(genreId, page: page);
  }
}
