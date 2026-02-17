import 'package:equatable/equatable.dart';
import 'package:imdumb/features/movie/domain/entities/recommendation.dart';

enum RecommendationStatus { initial, loading, loaded, failure }

class RecommendationState extends Equatable {
  final RecommendationStatus status;
  final Recommendation? recommendation;
  final String? errorMessage;

  const RecommendationState({
    this.status = RecommendationStatus.initial,
    this.recommendation,
    this.errorMessage,
  });

  RecommendationState copyWith({
    RecommendationStatus? status,
    Recommendation? recommendation,
    String? errorMessage,
  }) {
    return RecommendationState(
      status: status ?? this.status,
      recommendation: recommendation ?? this.recommendation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recommendation, errorMessage];
}
