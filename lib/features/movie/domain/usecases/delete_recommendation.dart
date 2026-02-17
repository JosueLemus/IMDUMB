import 'package:imdumb/features/movie/domain/repositories/recommendation_repository.dart';

class DeleteRecommendation {
  final RecommendationRepository repository;

  DeleteRecommendation(this.repository);

  Future<void> call(String id) {
    return repository.deleteRecommendation(id);
  }
}
