import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies.dart';

// Events
abstract class NowPlayingEvent extends Equatable {
  const NowPlayingEvent();
  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends NowPlayingEvent {
  final bool initial;
  const FetchNowPlayingMovies({this.initial = false});

  @override
  List<Object?> get props => [initial];
}

abstract class NowPlayingState extends Equatable {
  const NowPlayingState();
  @override
  List<Object?> get props => [];
}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoading extends NowPlayingState {}

class NowPlayingLoaded extends NowPlayingState {
  final List<Movie> movies;
  final int page;
  final bool hasReachedMax;

  const NowPlayingLoaded({
    required this.movies,
    required this.page,
    this.hasReachedMax = false,
  });

  NowPlayingLoaded copyWith({
    List<Movie>? movies,
    int? page,
    bool? hasReachedMax,
  }) {
    return NowPlayingLoaded(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [movies, page, hasReachedMax];
}

class NowPlayingError extends NowPlayingState {
  final String message;
  const NowPlayingError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingBloc({required this.getNowPlayingMovies})
    : super(NowPlayingInitial()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      if (state is NowPlayingLoaded &&
          (state as NowPlayingLoaded).hasReachedMax &&
          !event.initial) {
        return;
      }

      try {
        if (event.initial) {
          emit(NowPlayingLoading());
          final movies = await getNowPlayingMovies(page: 1);
          emit(
            NowPlayingLoaded(
              movies: movies,
              page: 1,
              hasReachedMax: movies.isEmpty,
            ),
          );
        } else {
          final currentState = state as NowPlayingLoaded;
          final nextPage = currentState.page + 1;
          final movies = await getNowPlayingMovies(page: nextPage);

          if (movies.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(
              NowPlayingLoaded(
                movies: List.of(currentState.movies)..addAll(movies),
                page: nextPage,
                hasReachedMax: false,
              ),
            );
          }
        }
      } catch (e) {
        emit(NowPlayingError(e.toString()));
      }
    });
  }
}
