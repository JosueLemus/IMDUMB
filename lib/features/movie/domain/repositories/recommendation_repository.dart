import 'package:imdumb/features/movie/domain/entities/recommendation.dart';

abstract class RecommendationRepository {
  Future<String> recommendMovie(Recommendation recommendation);
  Future<void> deleteRecommendation(String id);
  Future<Recommendation?> getRecommendationForMovie(int movieId, String userId);
  Future<List<Recommendation>> getUserRecommendations(String userId);
}
