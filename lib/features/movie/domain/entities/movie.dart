import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  String get fullPosterPath => posterPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500${posterPath.startsWith('/') ? '' : '/'}$posterPath'
      : '';

  String get fullBackdropPath => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w1280${backdropPath.startsWith('/') ? '' : '/'}$backdropPath'
      : '';

  @override
  List<Object?> get props => [
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    releaseDate,
  ];
}
