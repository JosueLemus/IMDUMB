import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByGenre {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> execute(int genreId, {int page = 1}) async {
    return await repository.getMoviesByGenre(genreId, page: page);
  }
}
