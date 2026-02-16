import 'package:dio/dio.dart';

import '../models/cast_model.dart';
import '../models/crew_model.dart';
import '../models/movie_details_model.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<MovieDetailsModel> getMovieDetails(int id);
  Future<(List<CastModel>, List<CrewModel>)> getMovieCredits(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      final List results = response.data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int id) async {
    final response = await dio.get(
      '/movie/$id',
      queryParameters: {'append_to_response': 'images'},
    );

    if (response.statusCode == 200) {
      return MovieDetailsModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Future<(List<CastModel>, List<CrewModel>)> getMovieCredits(int id) async {
    final response = await dio.get('/movie/$id/credits');

    if (response.statusCode == 200) {
      final List castJson = response.data['cast'] ?? [];
      final List crewJson = response.data['crew'] ?? [];

      final cast = castJson.map((json) => CastModel.fromJson(json)).toList();
      final crew = crewJson.map((json) => CrewModel.fromJson(json)).toList();

      return (cast, crew);
    } else {
      throw Exception('Failed to load movie credits');
    }
  }
}
