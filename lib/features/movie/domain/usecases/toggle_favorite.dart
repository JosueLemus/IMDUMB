import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class ToggleFavorite {
  final MovieRepository repository;

  ToggleFavorite(this.repository);

  Future<void> execute(Movie movie) async {
    await repository.toggleFavorite(movie);
  }
}
