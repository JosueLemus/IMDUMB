import 'package:imdumb/features/movie/domain/entities/recommendation.dart';
import 'package:imdumb/features/movie/domain/repositories/recommendation_repository.dart';

class GetRecommendation {
  final RecommendationRepository repository;

  GetRecommendation(this.repository);

  Future<Recommendation?> call(int movieId, String userId) {
    return repository.getRecommendationForMovie(movieId, userId);
  }
}
