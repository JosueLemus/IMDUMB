import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/genre_movies_bloc.dart';
import '../bloc/genre_movies_event.dart';
import '../bloc/genre_movies_state.dart';
import '../widgets/movie_list_item.dart';

class GenreMoviesPage extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreMoviesPage({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<GenreMoviesPage> createState() => _GenreMoviesPageState();
}

class _GenreMoviesPageState extends State<GenreMoviesPage> {
  late final GenreMoviesBloc _bloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = sl<GenreMoviesBloc>();
    _bloc.add(FetchGenreMovies(genreId: widget.genreId));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _bloc.add(FetchGenreMovies(genreId: widget.genreId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.genreName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<GenreMoviesBloc, GenreMoviesState>(
          builder: (context, state) {
            if (state.status == GenreMoviesStatus.initial ||
                (state.status == GenreMoviesStatus.loading &&
                    state.movies.isEmpty)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == GenreMoviesStatus.failure &&
                state.movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load movies',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _bloc.add(
                        FetchGenreMovies(
                          genreId: widget.genreId,
                          isRefresh: true,
                        ),
                      ),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.hasReachedMax
                  ? state.movies.length
                  : state.movies.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.movies.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final movie = state.movies[index];
                final isBookmarked = state.favorites.contains(movie.id);
                return MovieListItem(
                  movie: movie,
                  isBookmarked: isBookmarked,
                  onTap: () => context.push('/movie-details', extra: movie),
                  onBookmarkTap: () {
                    _bloc.add(ToggleFavoriteMovie(movie));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
