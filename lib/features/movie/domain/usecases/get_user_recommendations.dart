import 'package:imdumb/features/movie/domain/entities/recommendation.dart';
import 'package:imdumb/features/movie/domain/repositories/recommendation_repository.dart';

class GetUserRecommendations {
  final RecommendationRepository repository;

  GetUserRecommendations(this.repository);

  Future<List<Recommendation>> call(String userId) {
    return repository.getUserRecommendations(userId);
  }
}
