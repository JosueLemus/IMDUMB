import 'package:get_it/get_it.dart';
import 'package:imdumb/core/network/dio_client.dart';
import 'package:imdumb/features/home/presentation/bloc/home_bloc.dart';
import 'package:imdumb/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:imdumb/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:imdumb/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:imdumb/features/movie/domain/repositories/movie_repository.dart';
import 'package:imdumb/features/movie/domain/usecases/get_genres.dart';
import 'package:imdumb/features/movie/domain/usecases/get_movie_credits.dart';
import 'package:imdumb/features/movie/domain/usecases/get_movie_details.dart';
import 'package:imdumb/features/movie/domain/usecases/get_movies_by_genre.dart';
import 'package:imdumb/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:imdumb/features/movie/presentation/bloc/movie_details_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => DioClient().dio);

  // BLoC
  sl.registerFactory(() => HomeBloc(getGenres: sl()));
  sl.registerFactory(
    () => MovieDetailsBloc(getMovieDetails: sl(), getMovieCredits: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNowPlayingMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetMovieCredits(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(),
  );
}
