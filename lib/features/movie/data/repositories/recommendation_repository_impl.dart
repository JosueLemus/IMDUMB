import 'package:imdumb/features/movie/data/datasources/recommendation_remote_data_source.dart';
import 'package:imdumb/features/movie/data/models/recommendation_model.dart';
import 'package:imdumb/features/movie/domain/entities/recommendation.dart';
import 'package:imdumb/features/movie/domain/repositories/recommendation_repository.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;

  RecommendationRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> recommendMovie(Recommendation recommendation) {
    return remoteDataSource.recommendMovie(
      RecommendationModel.fromEntity(recommendation),
    );
  }

  @override
  Future<void> deleteRecommendation(String id) {
    return remoteDataSource.deleteRecommendation(id);
  }

  @override
  Future<Recommendation?> getRecommendationForMovie(
    int movieId,
    String userId,
  ) {
    return remoteDataSource.getRecommendationForMovie(movieId, userId);
  }

  @override
  Future<List<Recommendation>> getUserRecommendations(String userId) async {
    final models = await remoteDataSource.getUserRecommendations(userId);
    return models;
  }
}
