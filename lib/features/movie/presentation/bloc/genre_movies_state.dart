import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

enum GenreMoviesStatus { initial, loading, success, failure }

class GenreMoviesState extends Equatable {
  final GenreMoviesStatus status;
  final List<Movie> movies;
  final List<int> favorites;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const GenreMoviesState({
    this.status = GenreMoviesStatus.initial,
    this.movies = const [],
    this.favorites = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  GenreMoviesState copyWith({
    GenreMoviesStatus? status,
    List<Movie>? movies,
    List<int>? favorites,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return GenreMoviesState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      favorites: favorites ?? this.favorites,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    movies,
    favorites,
    currentPage,
    hasReachedMax,
    errorMessage,
  ];
}
