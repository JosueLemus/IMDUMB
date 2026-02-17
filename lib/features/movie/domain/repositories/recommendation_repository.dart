import 'package:imdumb/features/movie/domain/entities/recommendation.dart';

abstract class RecommendationRepository {
  Future<void> recommendMovie(Recommendation recommendation);
  Future<void> deleteRecommendation(String id);
  Future<Recommendation?> getRecommendationForMovie(int movieId, String userId);
}
