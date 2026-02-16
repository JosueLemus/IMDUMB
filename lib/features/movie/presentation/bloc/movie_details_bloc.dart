import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cast.dart';
import '../../domain/entities/crew.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/usecases/get_movie_credits.dart';
import '../../domain/usecases/get_movie_details.dart';

// Events
abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
  @override
  List<Object?> get props => [];
}

class FetchMovieDetails extends MovieDetailsEvent {
  final int id;
  const FetchMovieDetails(this.id);
  @override
  List<Object?> get props => [id];
}

// State
abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails movie;
  final List<Cast> cast;
  final List<Crew> crew;

  const MovieDetailsLoaded({
    required this.movie,
    required this.cast,
    required this.crew,
  });

  @override
  List<Object?> get props => [movie, cast, crew];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  const MovieDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;
  final GetMovieCredits getMovieCredits;

  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getMovieCredits,
  }) : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>((event, emit) async {
      emit(MovieDetailsLoading());
      try {
        final results = await Future.wait([
          getMovieDetails(event.id),
          getMovieCredits.execute(event.id),
        ]);

        final movie = results[0] as MovieDetails;
        final (cast, crew) = results[1] as (List<Cast>, List<Crew>);

        emit(MovieDetailsLoaded(movie: movie, cast: cast, crew: crew));
      } catch (e) {
        emit(MovieDetailsError(e.toString()));
      }
    });
  }
}
