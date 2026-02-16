import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

abstract class GenreMoviesEvent extends Equatable {
  const GenreMoviesEvent();

  @override
  List<Object?> get props => [];
}

class FetchGenreMovies extends GenreMoviesEvent {
  final int genreId;
  final bool isRefresh;

  const FetchGenreMovies({required this.genreId, this.isRefresh = false});

  @override
  List<Object?> get props => [genreId, isRefresh];
}

class ToggleFavoriteMovie extends GenreMoviesEvent {
  final Movie movie;

  const ToggleFavoriteMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}
