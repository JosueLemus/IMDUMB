import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/movie/data/datasources/movie_remote_data_source.dart';
import '../../features/movie/data/repositories/movie_repository_impl.dart';
import '../../features/movie/domain/repositories/movie_repository.dart';
import '../../features/movie/domain/usecases/get_now_playing_movies.dart';
import '../../features/movie/presentation/bloc/now_playing_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => NowPlayingBloc(getNowPlayingMovies: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetNowPlayingMovies(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton<Dio>(() => DioClient().dio);
}
