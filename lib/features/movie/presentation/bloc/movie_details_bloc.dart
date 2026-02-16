import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie_details.dart';
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
  const MovieDetailsLoaded(this.movie);
  @override
  List<Object?> get props => [movie];
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

  MovieDetailsBloc({required this.getMovieDetails})
    : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>((event, emit) async {
      emit(MovieDetailsLoading());
      try {
        final movie = await getMovieDetails(event.id);
        emit(MovieDetailsLoaded(movie));
      } catch (e) {
        emit(MovieDetailsError(e.toString()));
      }
    });
  }
}
