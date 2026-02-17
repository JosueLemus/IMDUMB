part of 'user_recommendations_cubit.dart';

enum UserRecommendationsStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  failure,
}

class UserRecommendationsState extends Equatable {
  final UserRecommendationsStatus status;
  final List<Recommendation> recommendations;
  final String? errorMessage;

  const UserRecommendationsState({
    this.status = UserRecommendationsStatus.initial,
    this.recommendations = const [],
    this.errorMessage,
  });

  UserRecommendationsState copyWith({
    UserRecommendationsStatus? status,
    List<Recommendation>? recommendations,
    String? errorMessage,
  }) {
    return UserRecommendationsState(
      status: status ?? this.status,
      recommendations: recommendations ?? this.recommendations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Recommendation? getRecommendationForMovie(int movieId) {
    try {
      return recommendations.firstWhere((r) => r.movieId == movieId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [status, recommendations, errorMessage];
}
