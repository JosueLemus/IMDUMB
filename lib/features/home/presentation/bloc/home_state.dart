import 'package:equatable/equatable.dart';

import '../../../movie/domain/entities/genre.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Genre> genres;

  const HomeLoaded({required this.genres});

  @override
  List<Object?> get props => [genres];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
