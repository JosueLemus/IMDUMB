import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/features/movie/domain/entities/recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/delete_recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/get_recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/recommend_movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final RecommendMovie recommendMovieUseCase;
  final GetRecommendation getRecommendationUseCase;
  final DeleteRecommendation deleteRecommendationUseCase;

  RecommendationCubit({
    required this.recommendMovieUseCase,
    required this.getRecommendationUseCase,
    required this.deleteRecommendationUseCase,
  }) : super(const RecommendationState());

  Future<void> fetchRecommendation(int movieId) async {
    emit(state.copyWith(status: RecommendationStatus.loading));
    try {
      final recommendation = await getRecommendationUseCase(movieId, 'test-1');
      emit(
        state.copyWith(
          status: RecommendationStatus.loaded,
          recommendation: recommendation,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecommendationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> submitRecommendation({
    required int movieId,
    required String comment,
    required List<String> tags,
  }) async {
    emit(state.copyWith(status: RecommendationStatus.loading));
    try {
      final recommendation = Recommendation(
        id: state.recommendation?.id ?? '',
        movieId: movieId,
        userId: 'test-1',
        comment: comment,
        tags: tags,
        createdAt: DateTime.now(),
      );

      await recommendMovieUseCase(recommendation);
      emit(
        state.copyWith(
          status: RecommendationStatus.loaded,
          recommendation: recommendation,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecommendationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeRecommendation() async {
    if (state.recommendation == null) return;

    emit(state.copyWith(status: RecommendationStatus.loading));
    try {
      await deleteRecommendationUseCase(state.recommendation!.id);
      emit(const RecommendationState(status: RecommendationStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: RecommendationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
