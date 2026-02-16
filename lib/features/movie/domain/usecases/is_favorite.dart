import '../repositories/movie_repository.dart';

class IsFavorite {
  final MovieRepository repository;

  IsFavorite(this.repository);

  Future<bool> execute(int id) async {
    return await repository.isFavorite(id);
  }
}
