import 'package:equatable/equatable.dart';

class MovieDetails extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<String> genres;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
  });

  String get fullPosterPath =>
      posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w780$posterPath' : '';

  String get fullBackdropPath => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';

  String get formattedRuntime {
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    releaseDate,
    runtime,
    genres,
  ];
}
