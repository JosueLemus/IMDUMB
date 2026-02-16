import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movie/domain/usecases/get_genres.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetGenres getGenres;

  HomeBloc({required this.getGenres}) : super(HomeInitial()) {
    on<FetchHomeCategories>((event, emit) async {
      emit(HomeLoading());
      try {
        final genres = await getGenres.execute();
        emit(HomeLoaded(genres: genres));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
