import '../../domain/entities/cast.dart';
import '../../domain/entities/crew.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return await remoteDataSource.getNowPlayingMovies(page: page);
  }

  @override
  Future<MovieDetails> getMovieDetails(int id) async {
    return await remoteDataSource.getMovieDetails(id);
  }

  @override
  Future<(List<Cast>, List<Crew>)> getMovieCredits(int id) async {
    return await remoteDataSource.getMovieCredits(id);
  }
}
