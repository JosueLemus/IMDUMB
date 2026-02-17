import 'package:imdumb/features/movie/domain/entities/recommendation.dart';
import 'package:imdumb/features/movie/domain/repositories/recommendation_repository.dart';

class RecommendMovie {
  final RecommendationRepository repository;

  RecommendMovie(this.repository);

  Future<void> call(Recommendation recommendation) {
    return repository.recommendMovie(recommendation);
  }
}
