import '../entities/cast.dart';
import '../entities/crew.dart';
import '../repositories/movie_repository.dart';

class GetMovieCredits {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  Future<(List<Cast>, List<Crew>)> execute(int id) async {
    return await repository.getMovieCredits(id);
  }
}
