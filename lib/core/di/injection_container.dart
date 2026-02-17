import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:imdumb/core/network/dio_client.dart';
import 'package:imdumb/core/services/remote_config_service.dart';
import 'package:imdumb/features/home/presentation/bloc/home_bloc.dart';
import 'package:imdumb/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:imdumb/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:imdumb/features/movie/data/datasources/recommendation_remote_data_source.dart';
import 'package:imdumb/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:imdumb/features/movie/data/repositories/recommendation_repository_impl.dart';
import 'package:imdumb/features/movie/domain/repositories/movie_repository.dart';
import 'package:imdumb/features/movie/domain/repositories/recommendation_repository.dart';
import 'package:imdumb/features/movie/domain/usecases/delete_recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/get_genres.dart';
import 'package:imdumb/features/movie/domain/usecases/get_movie_credits.dart';
import 'package:imdumb/features/movie/domain/usecases/get_movie_details.dart';
import 'package:imdumb/features/movie/domain/usecases/get_movies_by_genre.dart';
import 'package:imdumb/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:imdumb/features/movie/domain/usecases/get_recommendation.dart';
import 'package:imdumb/features/movie/domain/usecases/is_favorite.dart';
import 'package:imdumb/features/movie/domain/usecases/recommend_movie.dart';
import 'package:imdumb/features/movie/domain/usecases/toggle_favorite.dart';
import 'package:imdumb/features/movie/presentation/bloc/genre_movies_bloc.dart';
import 'package:imdumb/features/movie/presentation/bloc/movie_details_bloc.dart';
import 'package:imdumb/features/movie/presentation/bloc/recommendation_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => DioClient().dio);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => RemoteConfigService(sl()));

  // BLoC
  sl.registerFactory(() => HomeBloc(getGenres: sl()));
  sl.registerFactory(
    () => MovieDetailsBloc(getMovieDetails: sl(), getMovieCredits: sl()),
  );
  sl.registerFactory(
    () => GenreMoviesBloc(
      getMoviesByGenre: sl(),
      toggleFavorite: sl(),
      isFavorite: sl(),
    ),
  );
  sl.registerFactory(
    () => RecommendationCubit(
      recommendMovieUseCase: sl(),
      getRecommendationUseCase: sl(),
      deleteRecommendationUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNowPlayingMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetMovieCredits(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));
  sl.registerLazySingleton(() => RecommendMovie(sl()));
  sl.registerLazySingleton(() => GetRecommendation(sl()));
  sl.registerLazySingleton(() => DeleteRecommendation(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<RecommendationRepository>(
    () => RecommendationRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<RecommendationRemoteDataSource>(
    () => RecommendationRemoteDataSourceImpl(sl()),
  );
}
