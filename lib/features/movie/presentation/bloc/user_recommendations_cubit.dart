import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/features/movie/domain/entities/recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/delete_recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/get_user_recommendations.dart';
import 'package:imdumb/features/movie/domain/usecases/recommend_movie.dart';

part 'user_recommendations_state.dart';

class UserRecommendationsCubit extends Cubit<UserRecommendationsState> {
  final GetUserRecommendations getUserRecommendations;
  final RecommendMovie recommendMovie;
  final DeleteRecommendation deleteRecommendation;
  final FirebaseAnalytics analytics;

  UserRecommendationsCubit({
    required this.getUserRecommendations,
    required this.recommendMovie,
    required this.deleteRecommendation,
    required this.analytics,
  }) : super(const UserRecommendationsState());

  Future<void> loadRecommendations() async {
    emit(state.copyWith(status: UserRecommendationsStatus.loading));
    try {
      final recommendations = await getUserRecommendations('test-1');
      emit(
        state.copyWith(
          status: UserRecommendationsStatus.loaded,
          recommendations: recommendations,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserRecommendationsStatus.failure,
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
    emit(state.copyWith(status: UserRecommendationsStatus.submitting));
    try {
      final existingRecommendation = state.recommendations.firstWhere(
        (r) => r.movieId == movieId,
        orElse: () => Recommendation(
          id: '',
          movieId: movieId,
          userId: 'test-1',
          comment: '',
          tags: [],
          createdAt: DateTime.now(),
        ),
      );

      final recommendation = Recommendation(
        id: existingRecommendation.id,
        movieId: movieId,
        userId: 'test-1',
        comment: comment,
        tags: tags,
        createdAt: DateTime.now(),
      );

      final newId = await recommendMovie(recommendation);
      final validRecommendation = Recommendation(
        id: newId,
        movieId: recommendation.movieId,
        userId: recommendation.userId,
        comment: recommendation.comment,
        tags: recommendation.tags,
        createdAt: recommendation.createdAt,
      );
      try {
        await analytics.logEvent(
          name: 'recommend_movie',
          parameters: {
            'movie_id': movieId,
            'has_comment': comment.isNotEmpty ? 1 : 0,
            'tags_count': tags.length,
          },
        );
      } catch (e) {
        debugPrint(e.toString());
      }

      final updatedList = List<Recommendation>.from(state.recommendations);
      final index = updatedList.indexWhere((r) => r.movieId == movieId);
      if (index != -1) {
        updatedList[index] = validRecommendation;
      } else {
        updatedList.add(validRecommendation);
      }

      emit(
        state.copyWith(
          status: UserRecommendationsStatus.success,
          recommendations: updatedList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserRecommendationsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeRecommendation(int movieId) async {
    emit(state.copyWith(status: UserRecommendationsStatus.submitting));
    try {
      final recommendation = state.recommendations.firstWhere(
        (r) => r.movieId == movieId,
      );

      try {
        await deleteRecommendation(recommendation.id);
      } catch (e) {
        debugPrint(e.toString());
      }

      try {
        await analytics.logEvent(
          name: 'remove_recommendation',
          parameters: {'movie_id': movieId.toString()},
        );
      } catch (e) {
        debugPrint(e.toString());
      }

      final updatedList = List<Recommendation>.from(state.recommendations)
        ..removeWhere((r) => r.movieId == movieId);

      emit(
        state.copyWith(
          status: UserRecommendationsStatus.success,
          recommendations: updatedList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserRecommendationsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
