import '../../domain/entities/cast.dart';
import '../../domain/entities/crew.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/genre_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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

  @override
  Future<List<Genre>> getGenres() async {
    final cachedGenres = await localDataSource.getCachedGenres();

    if (cachedGenres.isNotEmpty) {
      final allHaveBanners = cachedGenres.every(
        (g) => g.bannerUrl != null && g.bannerUrl!.isNotEmpty,
      );
      if (allHaveBanners) {
        return cachedGenres;
      }
    }

    final remoteGenres = await remoteDataSource.getGenres();

    final movieLists = await Future.wait(
      remoteGenres.map((g) => remoteDataSource.getMoviesByGenre(g.id)),
    );

    final List<GenreModel> genresWithBanners = [];
    final Set<String> usedBanners = {};

    for (int i = 0; i < remoteGenres.length; i++) {
      final genre = remoteGenres[i];
      final movies = movieLists[i];

      String? selectedBanner;
      for (final movie in movies) {
        final path = movie.fullBackdropPath;
        if (path.isNotEmpty && !usedBanners.contains(path)) {
          selectedBanner = path;
          usedBanners.add(path);
          break;
        }
      }

      if (selectedBanner == null && movies.isNotEmpty) {
        selectedBanner = movies.first.fullBackdropPath;
      }

      genresWithBanners.add(
        GenreModel(id: genre.id, name: genre.name, bannerUrl: selectedBanner),
      );
    }

    await localDataSource.cacheGenres(genresWithBanners);

    return genresWithBanners;
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    return await remoteDataSource.getMoviesByGenre(genreId);
  }

  @override
  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }
}
