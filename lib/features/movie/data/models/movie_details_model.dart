import '../../domain/entities/movie_details.dart';

class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
    required super.backdrops,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final backdropsJson = json['images']?['backdrops'] as List? ?? [];
    final backdrops = backdropsJson
        .map((image) => image['file_path'] as String)
        .take(5)
        .toList();

    if (backdrops.isEmpty && json['backdrop_path'] != null) {
      backdrops.add(json['backdrop_path'] as String);
    }

    return MovieDetailsModel(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List? ?? [])
          .map((genre) => genre['name'] as String)
          .toList(),
      backdrops: backdrops,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'runtime': runtime,
      'genres': genres.map((name) => {'name': name}).toList(),
      'backdrops': backdrops,
    };
  }
}
