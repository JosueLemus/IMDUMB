import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_movies_by_genre.dart';
import '../../domain/usecases/is_favorite.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'genre_movies_event.dart';
import 'genre_movies_state.dart';

class GenreMoviesBloc extends Bloc<GenreMoviesEvent, GenreMoviesState> {
  final GetMoviesByGenre getMoviesByGenre;
  final ToggleFavorite toggleFavorite;
  final IsFavorite isFavorite;

  GenreMoviesBloc({
    required this.getMoviesByGenre,
    required this.toggleFavorite,
    required this.isFavorite,
  }) : super(const GenreMoviesState()) {
    on<FetchGenreMovies>(_onFetchGenreMovies);
    on<ToggleFavoriteMovie>(_onToggleFavoriteMovie);
  }

  Future<void> _onToggleFavoriteMovie(
    ToggleFavoriteMovie event,
    Emitter<GenreMoviesState> emit,
  ) async {
    await toggleFavorite.execute(event.movie);
    final isFav = await isFavorite.execute(event.movie.id);

    final updatedFavorites = List<int>.from(state.favorites);
    if (isFav) {
      updatedFavorites.add(event.movie.id);
    } else {
      updatedFavorites.remove(event.movie.id);
    }

    emit(state.copyWith(favorites: updatedFavorites));
  }

  Future<void> _onFetchGenreMovies(
    FetchGenreMovies event,
    Emitter<GenreMoviesState> emit,
  ) async {
    if (state.hasReachedMax && !event.isRefresh) return;

    try {
      if (state.status == GenreMoviesStatus.initial || event.isRefresh) {
        emit(state.copyWith(status: GenreMoviesStatus.loading));

        final movies = await getMoviesByGenre.execute(event.genreId, page: 1);

        final List<int> currentFavorites = [];
        for (final m in movies) {
          if (await isFavorite.execute(m.id)) {
            currentFavorites.add(m.id);
          }
        }

        return emit(
          state.copyWith(
            status: GenreMoviesStatus.success,
            movies: movies,
            favorites: currentFavorites,
            currentPage: 1,
            hasReachedMax: movies.isEmpty,
          ),
        );
      }

      final movies = await getMoviesByGenre.execute(
        event.genreId,
        page: state.currentPage + 1,
      );

      final List<int> newFavorites = List.from(state.favorites);
      for (final m in movies) {
        if (await isFavorite.execute(m.id)) {
          newFavorites.add(m.id);
        }
      }

      emit(
        movies.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: GenreMoviesStatus.success,
                movies: List.of(state.movies)..addAll(movies),
                favorites: newFavorites,
                currentPage: state.currentPage + 1,
                hasReachedMax: false,
              ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GenreMoviesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
